import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:autoworld164/app/locale/models/app_locale_option_model.dart';
import 'package:autoworld164/app/locale/presentation/cubit/app_locale_cubit.dart';
import 'package:autoworld164/app/profile/presentation/cubit/account_actions_cubit.dart';
import 'package:autoworld164/app/session/models/session_status_model.dart';
import 'package:autoworld164/app/session/presentation/cubit/session_cubit.dart';
import 'package:autoworld164/core/di/injection.dart';
import 'package:autoworld164/features/profiles/presentation/cubit/profile_cubit.dart';
import 'package:autoworld164/features/profiles/presentation/ui/profile_screen.dart';
import 'package:autoworld164/features/settings/presentation/settings_cubit.dart';
import 'package:autoworld164/features/settings/models/settings_model.dart';
import 'package:autoworld164/l10n/generated/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockSessionRepository sessionRepository;
  late BehaviorSubject<SessionStatusModel> sessionController;
  late MockAppLocaleRepository appLocaleRepository;
  late BehaviorSubject<AppLocaleOptionModel> appLocaleController;
  late MockSharedUserRepository sharedUserRepository;
  late MockAuthRepository authRepository;
  late MockSubscriptionRepository subscriptionRepository;
  late MockSettingsRepository settingsRepository;
  late MockSettingsCubit settingsCubit;

  setUpAll(() {
    registerFallbackValue(AppLocaleOptionModel.system);
  });

  setUp(() async {
    sessionRepository = MockSessionRepository();
    sessionController = BehaviorSubject.seeded(
      buildAuthenticatedSessionStatus(
        userId: 'guest-1',
        isAnonymous: true,
        isPro: true,
        sharedUser: buildSharedUser(id: 'guest-1', firstName: 'Guest'),
      ),
    );
    appLocaleRepository = MockAppLocaleRepository();
    appLocaleController = BehaviorSubject.seeded(AppLocaleOptionModel.system);
    sharedUserRepository = MockSharedUserRepository();
    authRepository = MockAuthRepository();
    subscriptionRepository = MockSubscriptionRepository();
    settingsRepository = MockSettingsRepository();
    settingsCubit = MockSettingsCubit();

    final mockSettings = SettingsModel(id: 'guest-1', garageName: 'My Garage');
    when(() => settingsCubit.state).thenReturn(
      SettingsState.data(settings: mockSettings, isGuest: true),
    );
    when(() => settingsCubit.stream).thenAnswer(
      (_) => Stream.value(SettingsState.data(settings: mockSettings, isGuest: true)),
    );
    when(() => settingsCubit.init(any())).thenAnswer((_) async {});
    when(() => settingsCubit.close()).thenAnswer((_) async {});

    when(
      () => appLocaleRepository.current,
    ).thenReturn(appLocaleController.value);
    when(
      () => appLocaleRepository.localeStream,
    ).thenAnswer((_) => appLocaleController.stream);
    when(() => appLocaleRepository.setLocaleOption(any())).thenAnswer((
      invocation,
    ) async {
      final option =
          invocation.positionalArguments.single as AppLocaleOptionModel;
      appLocaleController.add(option);
    });
    when(
      () => sessionRepository.sessionStream,
    ).thenAnswer((_) => sessionController.stream.cast());
    when(
      () => sessionRepository.current,
    ).thenAnswer((_) => sessionController.value);
    when(() => sessionRepository.refresh()).thenAnswer((_) async {});

    await getIt.reset();
    getIt.registerLazySingleton<AppLocaleCubit>(
      () => AppLocaleCubit(appLocaleRepository),
    );
    getIt.registerFactory<SessionCubit>(() => SessionCubit(sessionRepository));
    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(sharedUserRepository, settingsRepository),
    );
    getIt.registerFactory<AccountActionsCubit>(
      () => AccountActionsCubit(authRepository, subscriptionRepository),
    );
    getIt.registerLazySingleton<SettingsCubit>(() => settingsCubit);
  });

  tearDown(() async {
    await appLocaleController.close();
    await sessionController.close();
    await getIt.reset();
  });

  testWidgets('shows protect-pro banner for guest with pro', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ProfileScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Zabezpiecz dostęp do Pro'), findsOneWidget);
    expect(find.text('ZAREJESTRUJ SIĘ'), findsOneWidget);
    expect(find.text('ZALOGUJ SIĘ'), findsOneWidget);
  });

  testWidgets('shows app language dropdown under first name controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ProfileScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Język aplikacji'), findsOneWidget);
    expect(find.text('Automatyczny'), findsOneWidget);
    expect(
      find.byType(DropdownButtonFormField<AppLocaleOptionModel>),
      findsOneWidget,
    );
  });

  testWidgets('shows delete account confirmation dialog', (tester) async {
    when(() => authRepository.deleteAccount()).thenAnswer((_) async {});
    when(() => authRepository.signOut()).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ProfileScreen(),
      ),
    );
    await tester.pump();

    await tester.scrollUntilVisible(
      find.text('USUŃ KONTO'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('USUŃ KONTO'));
    await tester.pumpAndSettle();

    expect(find.text('Usunąć konto?'), findsOneWidget);
    expect(
      find.text(
        'Czy na pewno chcesz usunąć swoje konto? Ta operacja jest nieodwracalna. Wszystkie Twoje dane oraz dostęp Pro zostaną utracone.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('USUŃ'));
    await tester.pumpAndSettle();

    verify(() => authRepository.deleteAccount()).called(1);
    verify(() => authRepository.signOut()).called(1);
  });
}
