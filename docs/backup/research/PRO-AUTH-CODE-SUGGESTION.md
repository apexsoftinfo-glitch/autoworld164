Here’s a code-first template that matches the architecture we discussed.

This skeleton uses Supabase `currentSession` as the startup seed, then listens to auth changes, keeps canonical user-facing data in `public.profiles`, upgrades anonymous users in place with `updateUser()` or `linkIdentity()`, and drives subscription state from RevenueCat with a custom App User ID equal to the Supabase user ID. Supabase’s Dart docs also show `stream()` for initial plus live row updates, and RevenueCat’s Flutter docs expose `PurchasesConfiguration.appUserID`, `logIn()`, `getCustomerInfo()`, and customer-info listeners for this pattern. ([Supabase][1])

I intentionally keep **Welcome** to only:

* existing-account login
* continue as guest

There is **no registration button** there. Guest upgrade lives in **Profile**, and provider linking lives there too. I also leave **existing-account OAuth login** out of Welcome for now, because your template wants a very hard boundary between “switch/login existing” and “upgrade current guest”.

The SQL below follows Supabase’s recommended `public.profiles(id references auth.users on delete cascade)` pattern with RLS and a small trigger to create the row on user creation. Anonymous users still use the `authenticated` role, so permanent-only tables need explicit `is_anonymous` checks in RLS. ([Supabase][2])

For account deletion, the client calls an Edge Function because Supabase admin delete-user requires a `service_role` key and must run on a trusted server. Supabase also notes that deleting `auth.users` does not automatically sign the client out, and users who own Storage objects must have those cleaned up first. ([Supabase][3])

### Folder shape

```text
lib/
  main.dart
  app/template_app.dart
  core/app_config.dart
  core/session_models.dart
  data/template_data.dart
  session/template_session.dart
  presentation/command_cubits.dart
  presentation/screens.dart

supabase/
  migrations/0001_profiles.sql
  functions/delete-self/index.ts
```

## 1) Flutter code

### `lib/main.dart`

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/template_app.dart';
import 'core/app_config.dart';
import 'data/template_data.dart';
import 'session/template_session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.supabaseUrl.isEmpty || AppConfig.supabaseAnonKey.isEmpty) {
    throw StateError(
      'Missing Supabase config. Pass SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define.',
    );
  }

  if (AppConfig.revenueCatApiKey.isEmpty) {
    throw StateError(
      'Missing RevenueCat platform API key. Pass RC_APPLE_API_KEY and/or RC_GOOGLE_API_KEY via --dart-define.',
    );
  }

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  await Purchases.setLogLevel(
    kDebugMode ? LogLevel.debug : LogLevel.info,
  );

  final supabase = Supabase.instance.client;

  final authDataSource = SupabaseAuthDataSource(supabase);
  final profileDataSource = SupabaseProfileDataSource(supabase);
  final revenueCatDataSource = RevenueCatDataSource(
    apiKey: AppConfig.revenueCatApiKey,
  );

  final authRepository = AuthRepository(authDataSource);
  final profileRepository = ProfileRepository(profileDataSource);
  final billingRepository = BillingRepository(revenueCatDataSource);

  final sessionRepository = SessionRepository(
    authRepository: authRepository,
    profileRepository: profileRepository,
    billingRepository: billingRepository,
  );

  runApp(
    TemplateApp(
      authRepository: authRepository,
      profileRepository: profileRepository,
      billingRepository: billingRepository,
      sessionRepository: sessionRepository,
    ),
  );
}
```

### `lib/app/template_app.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/template_data.dart';
import '../presentation/screens.dart';
import '../session/template_session.dart';

class TemplateApp extends StatelessWidget {
  const TemplateApp({
    super.key,
    required this.authRepository,
    required this.profileRepository,
    required this.billingRepository,
    required this.sessionRepository,
  });

  final AuthRepository authRepository;
  final ProfileRepository profileRepository;
  final BillingRepository billingRepository;
  final SessionRepository sessionRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => authRepository,
        ),
        RepositoryProvider<ProfileRepository>(
          create: (_) => profileRepository,
        ),
        RepositoryProvider<BillingRepository>(
          create: (_) => billingRepository,
          dispose: (_, repo) => repo.dispose(),
        ),
        RepositoryProvider<SessionRepository>(
          create: (_) => sessionRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => SessionCubit(
          context.read<SessionRepository>(),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Template',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.indigo,
          ),
          home: const AppGate(),
        ),
      ),
    );
  }
}
```

### `lib/core/app_config.dart`

```dart
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

class AppConfig {
  const AppConfig._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static const revenueCatAppleApiKey = String.fromEnvironment('RC_APPLE_API_KEY');
  static const revenueCatGoogleApiKey = String.fromEnvironment('RC_GOOGLE_API_KEY');

  static const proEntitlementId = 'pro';

  // Change this to your real app scheme / host.
  static const authRedirectTo = 'io.example.app://login-callback';

  static String get revenueCatApiKey {
    if (kIsWeb) {
      throw UnsupportedError('This template is mobile-first.');
    }
    if (Platform.isIOS) return revenueCatAppleApiKey;
    if (Platform.isAndroid) return revenueCatGoogleApiKey;
    throw UnsupportedError('Unsupported platform.');
  }
}
```

### `lib/core/session_models.dart`

```dart
enum SessionPhase { booting, signedOut, loading, ready, failure }

enum SubscriptionPhase { signedOut, loading, ready, failure }

class AuthPrincipal {
  const AuthPrincipal({
    required this.userId,
    required this.isAnonymous,
    this.email,
  });

  final String userId;
  final bool isAnonymous;
  final String? email;
}

class UserProfile {
  const UserProfile({
    required this.id,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.onboardingCompleted = false,
  });

  factory UserProfile.empty(String id) => UserProfile(id: id);

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      onboardingCompleted: map['onboarding_completed'] as bool? ?? false,
    );
  }

  final String id;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final bool onboardingCompleted;

  String? get displayName {
    final first = firstName?.trim() ?? '';
    final last = lastName?.trim() ?? '';
    final full = '$first $last'.trim();
    return full.isEmpty ? null : full;
  }
}

class SubscriptionSnapshot {
  const SubscriptionSnapshot._({
    required this.phase,
    required this.isPro,
    this.errorMessage,
  });

  const SubscriptionSnapshot.loading()
      : this._(
          phase: SubscriptionPhase.loading,
          isPro: false,
        );

  const SubscriptionSnapshot.signedOut()
      : this._(
          phase: SubscriptionPhase.signedOut,
          isPro: false,
        );

  const SubscriptionSnapshot.ready({
    required bool isPro,
  }) : this._(
          phase: SubscriptionPhase.ready,
          isPro: isPro,
        );

  const SubscriptionSnapshot.failure(String message)
      : this._(
          phase: SubscriptionPhase.failure,
          isPro: false,
          errorMessage: message,
        );

  final SubscriptionPhase phase;
  final bool isPro;
  final String? errorMessage;
}

class SessionState {
  const SessionState._({
    required this.phase,
    this.principal,
    this.profile,
    this.subscription,
    this.errorMessage,
  });

  const SessionState.booting()
      : this._(phase: SessionPhase.booting);

  const SessionState.signedOut()
      : this._(phase: SessionPhase.signedOut);

  const SessionState.loading({
    required AuthPrincipal principal,
    UserProfile? profile,
  }) : this._(
          phase: SessionPhase.loading,
          principal: principal,
          profile: profile,
        );

  const SessionState.ready({
    required AuthPrincipal principal,
    required UserProfile profile,
    required SubscriptionSnapshot subscription,
  }) : this._(
          phase: SessionPhase.ready,
          principal: principal,
          profile: profile,
          subscription: subscription,
        );

  const SessionState.failure({
    AuthPrincipal? principal,
    UserProfile? profile,
    String? errorMessage,
  }) : this._(
          phase: SessionPhase.failure,
          principal: principal,
          profile: profile,
          errorMessage: errorMessage,
        );

  final SessionPhase phase;
  final AuthPrincipal? principal;
  final UserProfile? profile;
  final SubscriptionSnapshot? subscription;
  final String? errorMessage;

  bool get isSignedIn => principal != null;
  String? get userId => principal?.userId;
  bool get isAnonymous => principal?.isAnonymous ?? false;
  bool get isPro => subscription?.isPro ?? false;
  bool get onboardingReady => profile?.onboardingCompleted ?? false;
  String get userTier => isPro ? 'pro' : 'free';

  String get displayName {
    final profileName = profile?.displayName;
    if (profileName != null && profileName.isNotEmpty) {
      return profileName;
    }

    final email = principal?.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }

    return isAnonymous ? 'Guest' : 'User';
  }

  bool get hasMeaningfulGuestState {
    return isAnonymous &&
        ((profile?.firstName?.trim().isNotEmpty ?? false) ||
            (profile?.lastName?.trim().isNotEmpty ?? false) ||
            (profile?.onboardingCompleted ?? false) ||
            isPro);
  }
}
```

### `lib/data/template_data.dart`

```dart
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_config.dart';
import '../core/session_models.dart';

/// -------------------------
/// Data sources
/// -------------------------

class SupabaseAuthDataSource {
  SupabaseAuthDataSource(this._client);

  final SupabaseClient _client;

  Session? get currentSession => _client.auth.currentSession;
  User? get currentUser => _client.auth.currentUser;

  Stream<Session?> watchSession() {
    return Rx.concat<Session?>([
      Stream<Session?>.value(_client.auth.currentSession),
      _client.auth.onAuthStateChange.map((state) => state.session),
    ]);
  }

  Future<void> signInAnonymously() async {
    await _client.auth.signInAnonymously();
  }

  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> requestOtpLogin({
    required String email,
    required String redirectTo,
  }) async {
    // Important:
    // shouldCreateUser: false keeps this flow "existing account login only".
    await _client.auth.signInWithOtp(
      email: email,
      emailRedirectTo: redirectTo,
      shouldCreateUser: false,
    );
  }

  Future<void> beginEmailUpgrade({
    required String email,
    required String redirectTo,
  }) async {
    // Step 1: attach / verify email on the current anonymous user.
    await _client.auth.updateUser(
      UserAttributes(email: email),
      emailRedirectTo: redirectTo,
    );
  }

  Future<void> completeEmailUpgrade({
    required String password,
  }) async {
    // Step 2: after the email is verified, set the password
    // on the same user.
    await _client.auth.updateUser(
      UserAttributes(password: password),
    );
  }

  Future<void> linkGoogle({
    required String redirectTo,
  }) async {
    await _client.auth.linkIdentity(
      OAuthProvider.google,
      redirectTo: redirectTo,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> deleteSelf() async {
    await _client.functions.invoke('delete-self');
    await _client.auth.signOut();
  }
}

class SupabaseProfileDataSource {
  SupabaseProfileDataSource(this._client);

  final SupabaseClient _client;

  Stream<UserProfile> watchProfile(String userId) {
    return _client
        .from('profiles')
        .stream(primaryKey: const ['id'])
        .eq('id', userId)
        .map((rows) {
      if (rows.isEmpty) {
        return UserProfile.empty(userId);
      }
      return UserProfile.fromMap(rows.first);
    });
  }

  Future<void> updateProfile(
    String userId,
    Map<String, dynamic> values,
  ) async {
    if (values.isEmpty) return;

    await _client
        .from('profiles')
        .update(values)
        .eq('id', userId);
  }
}

class RevenueCatDataSource {
  RevenueCatDataSource({
    required this.apiKey,
  });

  final String apiKey;
  bool _configured = false;

  bool get isConfigured => _configured;

  Future<void> configureIfNeeded({
    required String appUserId,
  }) async {
    if (_configured) return;

    final configuration = PurchasesConfiguration(apiKey)
      ..appUserID = appUserId;

    await Purchases.configure(configuration);
    _configured = true;
  }

  Future<void> logIn(String appUserId) async {
    await Purchases.logIn(appUserId);
  }

  Future<CustomerInfo> getCustomerInfo() {
    return Purchases.getCustomerInfo();
  }

  Future<Offerings> getOfferings() {
    return Purchases.getOfferings();
  }

  Future<PurchaseResult> purchasePackage(Package package) {
    return Purchases.purchasePackage(package);
  }

  Future<CustomerInfo> restorePurchases() {
    return Purchases.restorePurchases();
  }

  void addCustomerInfoUpdateListener(CustomerInfoUpdateListener listener) {
    Purchases.addCustomerInfoUpdateListener(listener);
  }

  void removeCustomerInfoUpdateListener(CustomerInfoUpdateListener listener) {
    Purchases.removeCustomerInfoUpdateListener(listener);
  }
}

/// -------------------------
/// Repositories
/// -------------------------

class AuthRepository {
  AuthRepository(this._dataSource);

  final SupabaseAuthDataSource _dataSource;

  Stream<AuthPrincipal?> watchPrincipal() {
    return _dataSource.watchSession().map((session) {
      final user = session?.user;
      if (user == null) return null;

      return AuthPrincipal(
        userId: user.id,
        email: user.email,
        isAnonymous: user.isAnonymous,
      );
    }).distinct(
      (a, b) => a?.userId == b?.userId && a?.isAnonymous == b?.isAnonymous,
    );
  }

  bool get currentUserHasConfirmedEmail =>
      (_dataSource.currentUser?.emailConfirmedAt?.isNotEmpty ?? false);

  Future<void> continueAsGuest() {
    return _dataSource.signInAnonymously();
  }

  Future<void> loginExistingWithPassword({
    required String email,
    required String password,
  }) {
    return _dataSource.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> requestExistingLoginOtp({
    required String email,
  }) {
    return _dataSource.requestOtpLogin(
      email: email,
      redirectTo: AppConfig.authRedirectTo,
    );
  }

  Future<void> beginAnonymousEmailUpgrade({
    required String email,
  }) {
    return _dataSource.beginEmailUpgrade(
      email: email,
      redirectTo: AppConfig.authRedirectTo,
    );
  }

  Future<void> completeAnonymousEmailUpgrade({
    required String password,
  }) {
    return _dataSource.completeEmailUpgrade(
      password: password,
    );
  }

  Future<void> linkGoogleToCurrentAccount() {
    return _dataSource.linkGoogle(
      redirectTo: AppConfig.authRedirectTo,
    );
  }

  Future<void> signOut() {
    return _dataSource.signOut();
  }

  Future<void> deleteSelf() {
    return _dataSource.deleteSelf();
  }
}

class ProfileRepository {
  ProfileRepository(this._dataSource);

  final SupabaseProfileDataSource _dataSource;

  Stream<UserProfile> watchProfile(String userId) {
    return _dataSource.watchProfile(userId);
  }

  Future<void> saveProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    bool? onboardingCompleted,
  }) async {
    await _dataSource.updateProfile(
      userId,
      {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (onboardingCompleted != null)
          'onboarding_completed': onboardingCompleted,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
    );
  }
}

class BillingRepository {
  BillingRepository(this._dataSource) {
    _customerInfoListener = (customerInfo) {
      _subject.add(_mapCustomerInfo(customerInfo));
    };
    _dataSource.addCustomerInfoUpdateListener(_customerInfoListener);
  }

  final RevenueCatDataSource _dataSource;
  late final CustomerInfoUpdateListener _customerInfoListener;

  final BehaviorSubject<SubscriptionSnapshot> _subject =
      BehaviorSubject.seeded(const SubscriptionSnapshot.signedOut());

  String? _currentUserId;

  Stream<SubscriptionSnapshot> watchCurrent() => _subject.stream;

  Future<void> bindToUser(String userId) async {
    _subject.add(const SubscriptionSnapshot.loading());

    try {
      if (!_dataSource.isConfigured) {
        await _dataSource.configureIfNeeded(appUserId: userId);
      } else if (_currentUserId != userId) {
        await _dataSource.logIn(userId);
      }

      _currentUserId = userId;

      final customerInfo = await _dataSource.getCustomerInfo();
      _subject.add(_mapCustomerInfo(customerInfo));
    } catch (e) {
      _subject.add(SubscriptionSnapshot.failure(e.toString()));
    }
  }

  void clearForSignedOut() {
    // Important:
    // do NOT call RevenueCat logOut here, because this template
    // uses only custom App User IDs and avoids RC anonymous IDs.
    _currentUserId = null;
    _subject.add(const SubscriptionSnapshot.signedOut());
  }

  Future<void> purchasePro() async {
    final offerings = await _dataSource.getOfferings();
    final current = offerings.current;

    if (current == null || current.availablePackages.isEmpty) {
      throw StateError(
        'No RevenueCat offering/package configured. '
        'Replace purchasePro() package selection with your own strategy if needed.',
      );
    }

    final result = await _dataSource.purchasePackage(
      current.availablePackages.first,
    );

    _subject.add(_mapCustomerInfo(result.customerInfo));
  }

  Future<void> restorePurchases() async {
    final customerInfo = await _dataSource.restorePurchases();
    _subject.add(_mapCustomerInfo(customerInfo));
  }

  SubscriptionSnapshot _mapCustomerInfo(CustomerInfo info) {
    final isPro = info.entitlements.active.containsKey(
      AppConfig.proEntitlementId,
    );

    return SubscriptionSnapshot.ready(isPro: isPro);
  }

  void dispose() {
    _dataSource.removeCustomerInfoUpdateListener(_customerInfoListener);
    _subject.close();
  }
}
```

### `lib/session/template_session.dart`

```dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../core/session_models.dart';
import '../data/template_data.dart';

class SessionRepository {
  SessionRepository({
    required this.authRepository,
    required this.profileRepository,
    required this.billingRepository,
  });

  final AuthRepository authRepository;
  final ProfileRepository profileRepository;
  final BillingRepository billingRepository;

  Stream<SessionState> watchSession() {
    return authRepository.watchPrincipal().switchMap((principal) {
      if (principal == null) {
        billingRepository.clearForSignedOut();
        return Stream.value(const SessionState.signedOut());
      }

      return Rx.concat<SessionState>([
        Stream.value(SessionState.loading(principal: principal)),
        Stream.fromFuture(
          billingRepository.bindToUser(principal.userId),
        ).asyncExpand((_) {
          return Rx.combineLatest2<UserProfile, SubscriptionSnapshot, SessionState>(
            profileRepository.watchProfile(principal.userId),
            billingRepository.watchCurrent(),
            (profile, subscription) {
              if (subscription.phase == SubscriptionPhase.failure) {
                return SessionState.failure(
                  principal: principal,
                  profile: profile,
                  errorMessage: subscription.errorMessage,
                );
              }

              return SessionState.ready(
                principal: principal,
                profile: profile,
                subscription: subscription,
              );
            },
          );
        }),
      ]);
    }).startWith(const SessionState.booting());
  }
}

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._repository) : super(const SessionState.booting()) {
    _subscription = _repository.watchSession().listen(
      emit,
      onError: (error, _) {
        emit(SessionState.failure(errorMessage: error.toString()));
      },
    );
  }

  final SessionRepository _repository;
  late final StreamSubscription<SessionState> _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
```

### `lib/presentation/command_cubits.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/template_data.dart';

enum CommandPhase { idle, running, success, failure }

class CommandState {
  const CommandState._({
    required this.phase,
    this.message,
  });

  const CommandState.idle()
      : this._(phase: CommandPhase.idle);

  const CommandState.running()
      : this._(phase: CommandPhase.running);

  const CommandState.success([String? message])
      : this._(
          phase: CommandPhase.success,
          message: message,
        );

  const CommandState.failure(String message)
      : this._(
          phase: CommandPhase.failure,
          message: message,
        );

  final CommandPhase phase;
  final String? message;

  bool get isRunning => phase == CommandPhase.running;
}

class AuthCubit extends Cubit<CommandState> {
  AuthCubit(this._repository) : super(const CommandState.idle());

  final AuthRepository _repository;

  Future<void> _run(
    Future<void> Function() action, {
    String? successMessage,
  }) async {
    emit(const CommandState.running());

    try {
      await action();
      emit(CommandState.success(successMessage));
    } catch (e) {
      emit(CommandState.failure(e.toString()));
    }
  }

  void clear() => emit(const CommandState.idle());

  Future<void> continueAsGuest() => _run(_repository.continueAsGuest);

  Future<void> loginExistingWithPassword({
    required String email,
    required String password,
  }) {
    return _run(
      () => _repository.loginExistingWithPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<void> requestExistingLoginOtp({
    required String email,
  }) {
    return _run(
      () => _repository.requestExistingLoginOtp(email: email),
      successMessage: 'Magic link sent if this account exists.',
    );
  }

  Future<void> beginAnonymousEmailUpgrade({
    required String email,
  }) {
    return _run(
      () => _repository.beginAnonymousEmailUpgrade(email: email),
      successMessage: 'Verification email sent.',
    );
  }

  Future<void> completeAnonymousEmailUpgrade({
    required String password,
  }) {
    return _run(
      () => _repository.completeAnonymousEmailUpgrade(password: password),
      successMessage: 'Password set.',
    );
  }

  Future<void> linkGoogleToCurrentAccount() {
    return _run(_repository.linkGoogleToCurrentAccount);
  }

  Future<void> signOut() => _run(_repository.signOut);

  Future<void> deleteAccount() => _run(_repository.deleteSelf);
}

class ProfileCubit extends Cubit<CommandState> {
  ProfileCubit(this._repository) : super(const CommandState.idle());

  final ProfileRepository _repository;

  Future<void> saveProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    bool? onboardingCompleted,
  }) async {
    emit(const CommandState.running());

    try {
      await _repository.saveProfile(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: avatarUrl,
        onboardingCompleted: onboardingCompleted,
      );

      emit(const CommandState.success('Profile saved.'));
    } catch (e) {
      emit(CommandState.failure(e.toString()));
    }
  }

  void clear() => emit(const CommandState.idle());
}

class BillingCubit extends Cubit<CommandState> {
  BillingCubit(this._repository) : super(const CommandState.idle());

  final BillingRepository _repository;

  Future<void> purchasePro() async {
    emit(const CommandState.running());

    try {
      await _repository.purchasePro();
      emit(const CommandState.success('Purchase completed.'));
    } catch (e) {
      emit(CommandState.failure(e.toString()));
    }
  }

  Future<void> restorePurchases() async {
    emit(const CommandState.running());

    try {
      await _repository.restorePurchases();
      emit(const CommandState.success('Restore completed.'));
    } catch (e) {
      emit(CommandState.failure(e.toString()));
    }
  }

  void clear() => emit(const CommandState.idle());
}
```

### `lib/presentation/screens.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/session_models.dart';
import '../data/template_data.dart';
import '../session/template_session.dart';
import 'command_cubits.dart';

class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, session) {
        if (session.phase == SessionPhase.booting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (session.phase == SessionPhase.signedOut) {
          return const WelcomeScreen();
        }

        return const HomeScreen();
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(context.read<AuthRepository>()),
      child: Builder(
        builder: (context) {
          final command = context.watch<AuthCubit>().state;

          return BlocListener<AuthCubit, CommandState>(
            listener: (context, state) {
              _handleCommandState(context, state);
            },
            child: Scaffold(
              appBar: AppBar(title: const Text('Welcome')),
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Start with an existing account or continue as a guest.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: command.isRunning
                                ? null
                                : () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const LoginScreen(),
                                      ),
                                    );
                                  },
                            child: const Text('Log in to existing account'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: command.isRunning
                                ? null
                                : () {
                                    context.read<AuthCubit>().continueAsGuest();
                                  },
                            child: command.isRunning
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Continue as guest'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.isAccountSwitch = false,
  });

  final bool isAccountSwitch;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final currentEmail = context.read<SessionCubit>().state.principal?.email ?? '';
    _emailController = TextEditingController(text: currentEmail);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitPasswordLogin(BuildContext context) async {
    final session = context.read<SessionCubit>().state;

    if (widget.isAccountSwitch && session.hasMeaningfulGuestState) {
      final confirmed = await _confirm(
        context,
        title: 'Switch accounts?',
        message:
            'This guest account already has profile data or Pro access. '
            'Logging in to an existing account is treated as account switching, not merging. '
            'Upgrade this guest account if you want to keep the same data and purchases.',
      );

      if (!confirmed) return;
    }

    await context.read<AuthCubit>().loginExistingWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  Future<void> _submitMagicLink(BuildContext context) async {
    final session = context.read<SessionCubit>().state;

    if (widget.isAccountSwitch && session.hasMeaningfulGuestState) {
      final confirmed = await _confirm(
        context,
        title: 'Switch accounts?',
        message:
            'This guest account already has profile data or Pro access. '
            'Logging in to an existing account is treated as account switching, not merging.',
      );

      if (!confirmed) return;
    }

    await context.read<AuthCubit>().requestExistingLoginOtp(
          email: _emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(context.read<AuthRepository>()),
      child: Builder(
        builder: (context) {
          final command = context.watch<AuthCubit>().state;
          final session = context.watch<SessionCubit>().state;

          return BlocListener<SessionCubit, SessionState>(
            listenWhen: (previous, current) {
              return previous.userId != current.userId &&
                  current.phase != SessionPhase.signedOut;
            },
            listener: (context, _) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: BlocListener<AuthCubit, CommandState>(
              listener: (context, state) {
                _handleCommandState(context, state);
              },
              child: Scaffold(
                appBar: AppBar(title: const Text('Log in')),
                body: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          if (widget.isAccountSwitch && session.hasMeaningfulGuestState)
                            const Card(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'This guest account already contains meaningful state. '
                                  'Use “Upgrade current account” in Profile to keep the same data and Pro access.',
                                ),
                              ),
                            ),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: command.isRunning
                                  ? null
                                  : () => _submitPasswordLogin(context),
                              child: const Text('Log in with password'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: command.isRunning
                                  ? null
                                  : () => _submitMagicLink(context),
                              child: const Text(
                                'Send magic link (existing accounts only)',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;

    if (!session.isSignedIn) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text(
              'Hello, ${session.displayName}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(session.isAnonymous ? 'Guest account' : 'Regular account'),
                ),
                Chip(
                  label: Text(session.isPro ? 'Pro' : 'Free'),
                ),
                Chip(
                  label: Text('Tier: ${session.userTier}'),
                ),
              ],
            ),
            if (session.phase == SessionPhase.loading) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            if (session.phase == SessionPhase.failure && session.errorMessage != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(session.errorMessage!),
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
              child: const Text('Profile'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProScreen(),
                  ),
                );
              },
              child: Text(session.isPro ? 'Manage Pro' : 'Go Pro'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _upgradeEmailController;
  late final TextEditingController _upgradePasswordController;

  @override
  void initState() {
    super.initState();

    final session = context.read<SessionCubit>().state;
    _firstNameController = TextEditingController(
      text: session.profile?.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: session.profile?.lastName ?? '',
    );
    _upgradeEmailController = TextEditingController(
      text: session.principal?.email ?? '',
    );
    _upgradePasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _upgradeEmailController.dispose();
    _upgradePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final authRepository = context.read<AuthRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(context.read<AuthRepository>()),
        ),
        BlocProvider(
          create: (_) => ProfileCubit(context.read<ProfileRepository>()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final authCommand = context.watch<AuthCubit>().state;
          final profileCommand = context.watch<ProfileCubit>().state;
          final canSetPassword = authRepository.currentUserHasConfirmedEmail;

          return BlocListener<SessionCubit, SessionState>(
            listenWhen: (previous, current) => current.phase == SessionPhase.signedOut,
            listener: (context, _) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: MultiBlocListener(
              listeners: [
                BlocListener<AuthCubit, CommandState>(
                  listener: (context, state) {
                    _handleCommandState(context, state);
                  },
                ),
                BlocListener<ProfileCubit, CommandState>(
                  listener: (context, state) {
                    _handleCommandState(context, state);
                  },
                ),
              ],
              child: Scaffold(
                appBar: AppBar(title: const Text('Profile')),
                body: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: profileCommand.isRunning || session.userId == null
                          ? null
                          : () {
                              context.read<ProfileCubit>().saveProfile(
                                    userId: session.userId!,
                                    firstName: _firstNameController.text.trim(),
                                    lastName: _lastNameController.text.trim(),
                                  );
                            },
                      child: const Text('Save profile'),
                    ),
                    const SizedBox(height: 24),
                    if (session.isAnonymous) ...[
                      const Divider(),
                      const SizedBox(height: 12),
                      Text(
                        'Upgrade current guest account',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Use this path to keep the same user id, profile data, and Pro access.',
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _upgradeEmailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email for this account',
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: authCommand.isRunning
                            ? null
                            : () {
                                context.read<AuthCubit>().beginAnonymousEmailUpgrade(
                                      email: _upgradeEmailController.text.trim(),
                                    );
                              },
                        child: const Text('Send verification email'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _upgradePasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'New password',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        canSetPassword
                            ? 'Email verified. You can set a password now.'
                            : 'After you verify the email link, come back here and set the password.',
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: authCommand.isRunning || !canSetPassword
                            ? null
                            : () {
                                context.read<AuthCubit>().completeAnonymousEmailUpgrade(
                                      password: _upgradePasswordController.text,
                                    );
                              },
                        child: const Text('Set password on current account'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: authCommand.isRunning
                            ? null
                            : () {
                                context.read<AuthCubit>().linkGoogleToCurrentAccount();
                              },
                        child: const Text('Link Google to current account'),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: authCommand.isRunning
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(
                                      isAccountSwitch: true,
                                    ),
                                  ),
                                );
                              },
                        child: const Text('Log in to existing account instead'),
                      ),
                    ] else ...[
                      const Divider(),
                      const SizedBox(height: 12),
                      Text(
                        'Signed in as: ${session.principal?.email ?? session.displayName}',
                      ),
                    ],
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: authCommand.isRunning
                          ? null
                          : () {
                              context.read<AuthCubit>().signOut();
                            },
                      child: const Text('Log out'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: authCommand.isRunning
                          ? null
                          : () async {
                              final confirmed = await _confirm(
                                context,
                                title: 'Delete account?',
                                message:
                                    'This deletes the current account. '
                                    'For anonymous accounts, this removes the guest account too.',
                              );
                              if (!confirmed) return;

                              if (!context.mounted) return;
                              context.read<AuthCubit>().deleteAccount();
                            },
                      child: const Text('Delete account'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProScreen extends StatelessWidget {
  const ProScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;

    return BlocProvider(
      create: (_) => BillingCubit(context.read<BillingRepository>()),
      child: Builder(
        builder: (context) {
          final command = context.watch<BillingCubit>().state;

          return BlocListener<BillingCubit, CommandState>(
            listener: (context, state) {
              _handleCommandState(context, state);
            },
            child: Scaffold(
              appBar: AppBar(title: const Text('Pro')),
              body: Padding(
                padding: const EdgeInsets.all(24),
                child: ListView(
                  children: [
                    Text(
                      session.isPro ? 'You already have Pro.' : 'Upgrade to Pro',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    if (session.isAnonymous)
                      const Text(
                        'Guest users can buy Pro. Upgrade this same guest account later to keep the same access.',
                      ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: command.isRunning || session.isPro
                          ? null
                          : () {
                              context.read<BillingCubit>().purchasePro();
                            },
                      child: const Text('Buy Pro'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: command.isRunning
                          ? null
                          : () {
                              // Keep this user-triggered.
                              context.read<BillingCubit>().restorePurchases();
                            },
                      child: const Text('Restore purchases'),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Restore stays behind a user button. Do not auto-run it on account switch.',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void _handleCommandState(BuildContext context, CommandState state) {
  if (state.phase == CommandPhase.failure && state.message != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.message!)),
    );
  }

  if (state.phase == CommandPhase.success &&
      state.message != null &&
      state.message!.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.message!)),
    );
  }
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
```

## 2) Supabase SQL migration

Enable Manual Linking in Supabase if you use the `linkGoogleToCurrentAccount()` path. Also remember that anonymous users still use the `authenticated` role, so any “permanent-user-only” table needs an explicit `is_anonymous = false` policy, usually as a restrictive policy. ([Supabase][4])

### `supabase/migrations/0001_profiles.sql`

```sql
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text,
  last_name text,
  avatar_url text,
  onboarding_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "profiles_select_own"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

create policy "profiles_insert_own"
on public.profiles
for insert
to authenticated
with check (auth.uid() = id);

create policy "profiles_update_own"
on public.profiles
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id)
  values (new.id)
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
after insert on auth.users
for each row
execute procedure public.handle_new_user();

-- Example pattern for permanent-user-only writes on some other table:
-- create policy "only permanent users can insert"
-- on public.some_permanent_only_table
-- as restrictive
-- for insert
-- to authenticated
-- with check (((auth.jwt() ->> 'is_anonymous')::boolean) is false);
```

## 3) Edge Function for delete account

Supabase admin auth methods require a `service_role` key and must run on a trusted server. Supabase also warns that if the user owns Storage objects, delete will fail until you remove or reassign them. ([Supabase][3])

### `supabase/functions/delete-self/index.ts`

```ts
import { createClient } from 'npm:@supabase/supabase-js@2';

Deno.serve(async (req: Request) => {
  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: 'Missing Authorization header' }),
        { status: 401 },
      );
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const anonKey = Deno.env.get('SUPABASE_ANON_KEY')!;
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

    // Resolve the caller from the JWT that came from the mobile app.
    const userClient = createClient(supabaseUrl, anonKey, {
      global: {
        headers: {
          Authorization: authHeader,
        },
      },
    });

    const {
      data: { user },
      error: userError,
    } = await userClient.auth.getUser();

    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: userError?.message ?? 'Unauthorized' }),
        { status: 401 },
      );
    }

    const adminClient = createClient(supabaseUrl, serviceRoleKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    });

    // TODO:
    // delete or reassign any Storage objects owned by user.id before deleting
    // the auth user, otherwise deleteUser can fail.

    const { error: deleteError } = await adminClient.auth.admin.deleteUser(
      user.id,
    );

    if (deleteError) {
      return new Response(
        JSON.stringify({ error: deleteError.message }),
        { status: 400 },
      );
    }

    return new Response(
      JSON.stringify({ ok: true }),
      { status: 200 },
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: String(error) }),
      { status: 500 },
    );
  }
});
```

## 4) Hard rules encoded in this skeleton

* `SessionCubit` is global and read-only. It only listens to `SessionRepository`.
* Write cubits are screen-local.
* Welcome has no registration route.
* Existing-account magic-link login uses `shouldCreateUser: false`.
* Guest upgrade uses the same Supabase user via `updateUser()` or `linkIdentity()`.
* RevenueCat is configured with the Supabase user ID, switches users with `logIn()`, and never calls RevenueCat `logOut()`.
* “Log in to existing account” from a guest is a **switch**, not a merge.
* `restorePurchases()` is only exposed behind a button, never auto-run on switch. ([Supabase][5])

The two app-specific pieces you still need to decide are the exact RevenueCat package-selection rule in `purchasePro()` and any domain-specific guest-data conflict checks beyond profile + Pro before allowing account switch.

[1]: https://supabase.com/docs/reference/dart/upgrade-guide?utm_source=chatgpt.com "Flutter: Upgrade guide | Supabase Docs"
[2]: https://supabase.com/docs/guides/auth/managing-user-data?utm_source=chatgpt.com "User Management | Supabase Docs"
[3]: https://supabase.com/docs/reference/javascript/auth-admin-deleteuser?utm_source=chatgpt.com "JavaScript: Delete a user | Supabase Docs"
[4]: https://supabase.com/docs/reference/dart/auth-linkidentity?utm_source=chatgpt.com "Flutter: Link an identity to a user"
[5]: https://supabase.com/docs/reference/dart/auth-signinwithotp?utm_source=chatgpt.com "Flutter: Sign in a user through OTP"
