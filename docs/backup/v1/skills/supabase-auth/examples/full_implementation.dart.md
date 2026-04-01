// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║                     FLUTTER AUTH GATE WITH SUPABASE                          ║
// ║              Clean Architecture + Bloc + Freezed + GetIt/Injectable          ║
// ║                                                                               ║
// ║  Wersja 3.0 — z obsługą Anonymous Users:                                     ║
// ║  • signInAnonymously() dla "skip login"                                      ║
// ║  • linkWithEmail() / linkWithOAuth() dla upgrade do permanent                ║
// ║  • ValueKey(user.id) gwarantuje ciągłość przy linkowaniu                     ║
// ║  • UI examples dla anonymous user restrictions                               ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

// ════════════════════════════════════════════════════════════════════════════════
// ZASADY (przeczytaj najpierw!)
// ════════════════════════════════════════════════════════════════════════════════
//
// ZASADA #1: UI NIE NAWIGUJE NA LOGOUT
// ────────────────────────────────────
// ❌ ŹLE:  klik logout → Navigator.popUntil('/login')
// ✅ DOBRZE: klik logout → authCubit.signOut() → stream emituje → AuthGate przełącza
//
//
// ZASADA #2: ANONYMOUS USER = AUTHENTICATED Z FLAGĄ
// ──────────────────────────────────────────────────
// Anonymous user to PEŁNOPRAWNY użytkownik:
// • Ma sesję, token, user_id
// • Może zapisywać dane w bazie (RLS działa!)
// • Jedyna różnica: user.isAnonymous == true
//
// AuthState ma nadal tylko 2 główne stany (authenticated/unauthenticated).
// UI decyduje co pokazać na podstawie user.isAnonymous.
//
//
// ZASADA #3: VALUEKEY(USER.ID), NIE VALUEKEY(ISANONYMOUS)
// ───────────────────────────────────────────────────────
// Przy linkowaniu (anon → permanent):
// • user.id się NIE zmienia
// • ValueKey(user.id) zostaje ten sam
// • Widget tree się NIE przebudowuje
// • Dane usera zostają, UX jest płynny
//
//
// ZASADA #4: INITIAL EMISSION
// ───────────────────────────
// W supabase_flutter event `initialSession` jest emitowany po odczycie sesji
// z local storage — to jest właściwy moment na pierwszą emisję.
// Nie emituj `currentSession` synchronicznie w konstruktorze.
//
// Przykład (poprawiony initial emission):
// void _initAuthListener() {
//   // NIE emituj nic synchronicznie!
//   // Czekaj na initialSession event.
//   _authSubscription = _supabase.auth.onAuthStateChange.listen((authState) {
//     switch (authState.event) {
//       case AuthChangeEvent.initialSession:
//         if (authState.session != null) {
//           _emit(AuthStatus.authenticated, _mapUser(authState.session!.user));
//         } else {
//           _emit(AuthStatus.unauthenticated, null);
//         }
//         break;
//       case AuthChangeEvent.signedIn:
//         // ...obsłuż kolejne eventy
//         break;
//       case AuthChangeEvent.signedOut:
//         // ...
//         break;
//       case AuthChangeEvent.userUpdated:
//       case AuthChangeEvent.tokenRefreshed:
//       case AuthChangeEvent.passwordRecovery:
//       case AuthChangeEvent.mfaChallengeVerified:
//         // ...
//         break;
//     }
//   });
// }
//
// ════════════════════════════════════════════════════════════════════════════════
// WYMAGANIA PROJEKTU (MUST)
// ════════════════════════════════════════════════════════════════════════════════
// • Włączone: Anonymous Sign-Ins (Supabase Dashboard → Auth → Providers)
// • Włączone: Manual Identity Linking (beta)
// • Email confirmations: OFF (na start)
// • Auth na start: tylko email/hasło (OAuth przygotowane na przyszłość)
// • RLS: jeśli rozróżniasz anonymous vs permanent, użyj claimu is_anonymous z JWT
// • W realnym kodzie oznacz wszystkie stringi komentarzem // L10N
//
// ════════════════════════════════════════════════════════════════════════════════

// ==============================================================================
// CZĘŚĆ 1: DOMAIN LAYER - Entities & Repository Interface
// ==============================================================================

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/domain/entities/app_user.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// Encja użytkownika w domain layer.
/// 
/// WAŻNE: Zawiera flagę [isAnonymous] która decyduje o:
/// • Czy pokazać banner "Załóż konto"
/// • Czy zablokować niektóre funkcje (eksport, sync, etc.)
/// • Czy ostrzec przed wylogowaniem (utrata danych!)
@freezed
class AppUser with _$AppUser {
  const AppUser._();
  
  const factory AppUser({
    required String id,
    String? email,
    String? displayName,
    String? avatarUrl,
    DateTime? emailConfirmedAt,
    
    /// Czy to jest anonimowy użytkownik?
    /// 
    /// Anonymous user:
    /// • Ma pełną sesję i może zapisywać dane
    /// • NIE może się "zalogować ponownie" po wylogowaniu
    /// • Powinien być zachęcany do założenia konta
    @Default(false) bool isAnonymous,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
  
  /// Czy user ma zweryfikowany email?
  bool get isEmailVerified => emailConfirmedAt != null;
  
  /// Czy user ma pełne konto (nie anonymous)?
  bool get isPermanent => !isAnonymous;
  
  /// Wyświetlana nazwa (email jako fallback)
  String get displayNameOrEmail => displayName ?? email ?? '';
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/domain/entities/auth_status.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Status autoryzacji emitowany przez repository.
enum AuthStatus {
  /// Użytkownik jest zalogowany (anonymous LUB permanent)
  authenticated,
  
  /// Użytkownik nie jest zalogowany
  unauthenticated,
  
  /// Token został odświeżony (user nadal zalogowany)
  tokenRefreshed,

  /// Hasło wymaga resetu (user kliknął link z maila)
  passwordRecovery,

  /// MFA challenge został zweryfikowany
  mfaChallengeVerified,
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/domain/failures/auth_failure.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.invalidEmail() = _InvalidEmail;
  const factory AuthFailure.invalidPassword() = _InvalidPassword;
  const factory AuthFailure.emailAlreadyInUse() = _EmailAlreadyInUse;
  const factory AuthFailure.userNotFound() = _UserNotFound;
  const factory AuthFailure.wrongPassword() = _WrongPassword;
  const factory AuthFailure.weakPassword() = _WeakPassword;
  const factory AuthFailure.emailNotConfirmed() = _EmailNotConfirmed;
  const factory AuthFailure.tooManyRequests() = _TooManyRequests;
  const factory AuthFailure.serverError([String? message]) = _ServerError;
  const factory AuthFailure.networkError() = _NetworkError;
  const factory AuthFailure.cancelled() = _Cancelled;
  
  /// Próba linkowania konta które już jest permanent
  const factory AuthFailure.alreadyLinked() = _AlreadyLinked;
  
  /// Email jest już używany przez inne konto (przy linkowaniu)
  const factory AuthFailure.identityAlreadyExists() = _IdentityAlreadyExists;
  
  const factory AuthFailure.unknown([String? message]) = _Unknown;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/domain/repositories/i_auth_repository.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dartz/dartz.dart';

/// Abstrakcyjny interfejs repository.
abstract class IAuthRepository {
  /// 🔑 Stream stanu autoryzacji — serce całego systemu.
  /// 
  /// KONTRAKT:
  /// 1. Obsłuż `initialSession` (pierwsza emisja po odczycie z storage)
  /// 2. Dla broadcast stream: replay latest w `onListen`
  /// 3. Emituje każdą zmianę stanu (login, logout, link, etc.)
  /// 
  /// Anonymous user emituje (authenticated, AppUser(isAnonymous: true))
  Stream<(AuthStatus status, AppUser? user)> get authStateChanges;

  AppUser? get currentUser;
  bool get isAuthenticated;
  
  /// Czy aktualny user jest anonymous?
  bool get isAnonymous;

  // ═══════════════════════════════════════════════════════════════════════════
  // STANDARD AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  Future<Either<AuthFailure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, AppUser>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  /// OAuth startuje redirect/native flow — finalny user przychodzi przez stream.
  /// Dla natywnego Google/Apple na mobile docelowo użyj signInWithIdToken().
  Future<Either<AuthFailure, Unit>> signInWithOAuth({
    required OAuthProvider provider,
  });

  Future<Either<AuthFailure, Unit>> signInWithMagicLink({
    required String email,
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ANONYMOUS AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  /// Logowanie anonimowe.
  /// 
  /// Tworzy nowego użytkownika z:
  /// • Unikalnym user_id
  /// • Sesją i tokenem
  /// • isAnonymous = true
  /// 
  /// User może później "upgrade'ować" konto przez [linkWithEmail] lub [linkWithOAuth].
  Future<Either<AuthFailure, AppUser>> signInAnonymously();

  /// Linkowanie anonymous konta z email/password.
  /// 
  /// WAŻNE:
  /// • user.id się NIE zmienia!
  /// • Dane w bazie zostają przypisane do tego samego usera
  /// • Stream emituje userUpdated z isAnonymous = false
  /// 
  /// Może zwrócić [AuthFailure.identityAlreadyExists] jeśli email jest zajęty.
  ///
  /// Ten projekt: email confirmations OFF → można ustawić email+hasło w jednym kroku.
  /// Jeśli włączysz confirmations → najpierw updateUser(email), potem updateUser(password).
  Future<Either<AuthFailure, AppUser>> linkWithEmail({
    required String email,
    required String password,
  });

  /// Linkowanie anonymous konta z OAuth (Google, Apple, etc.)
  /// 
  /// Jak [linkWithEmail] — user.id zostaje ten sam.
  /// Zwraca [Unit] — finalny user przychodzi przez stream.
  /// Dla natywnego Google/Apple na mobile docelowo użyj linkIdentityWithIdToken().
  Future<Either<AuthFailure, Unit>> linkWithOAuth({
    required OAuthProvider provider,
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCOUNT MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  Future<Either<AuthFailure, Unit>> signOut();
  Future<Either<AuthFailure, Unit>> deleteAccount();
  Future<Either<AuthFailure, Unit>> resetPassword({required String email});
  Future<Either<AuthFailure, Unit>> updatePassword({required String newPassword});
  Future<Either<AuthFailure, Unit>> refreshToken();
}

enum OAuthProvider { google, apple, facebook, github, twitter }

// ==============================================================================
// CZĘŚĆ 2: DATA LAYER - DataSource + Repository
// ==============================================================================
// Zasada: Supabase SDK tylko w DataSource. Repository mapuje DTO → Domain.

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/data/models/auth_user_dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class AuthUserDto {
  final String id;
  final String? email;
  final String? displayName;
  final String? avatarUrl;
  final DateTime? emailConfirmedAt;
  final bool isAnonymous;

  const AuthUserDto({
    required this.id,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.emailConfirmedAt,
    required this.isAnonymous,
  });
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/data/data_sources/auth_data_source.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dartz/dartz.dart';

abstract class AuthDataSource {
  Stream<(AuthStatus, AuthUserDto?)> get authStateChanges;

  AuthUserDto? get currentUser;
  bool get isAuthenticated;
  bool get isAnonymous;

  Future<Either<AuthFailure, AuthUserDto>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, AuthUserDto>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  Future<Either<AuthFailure, Unit>> signInWithOAuth({
    required OAuthProvider provider,
  });

  Future<Either<AuthFailure, Unit>> signInWithMagicLink({
    required String email,
  });

  Future<Either<AuthFailure, AuthUserDto>> signInAnonymously();

  Future<Either<AuthFailure, AuthUserDto>> linkWithEmail({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, Unit>> linkWithOAuth({
    required OAuthProvider provider,
  });

  Future<Either<AuthFailure, Unit>> signOut();
  Future<Either<AuthFailure, Unit>> deleteAccount();
  Future<Either<AuthFailure, Unit>> resetPassword({required String email});
  Future<Either<AuthFailure, Unit>> updatePassword({required String newPassword});
  Future<Either<AuthFailure, Unit>> refreshToken();
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/data/data_sources/supabase_auth_data_source.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../../../core/utils/error_logger.dart';

@LazySingleton(as: AuthDataSource)
class SupabaseAuthDataSource implements AuthDataSource {
  final supa.SupabaseClient _supabase;

  late final StreamController<(AuthStatus, AuthUserDto?)> _authStateController =
      StreamController.broadcast(onListen: _emitLatest);
  StreamSubscription<supa.AuthState>? _authSubscription;
  AuthUserDto? _currentUser;
  AuthStatus? _latestStatus;
  AuthUserDto? _latestUser;

  SupabaseAuthDataSource(this._supabase) {
    _initAuthListener();
  }

  void _initAuthListener() {
    _authSubscription = _supabase.auth.onAuthStateChange.listen(
      (supa.AuthState authState) {
        final event = authState.event;
        final session = authState.session;

        switch (event) {
          case supa.AuthChangeEvent.initialSession:
            _emitFromSession(session);
            break;
          case supa.AuthChangeEvent.signedIn:
          case supa.AuthChangeEvent.userUpdated:
            _emitFromSession(session);
            break;
          case supa.AuthChangeEvent.tokenRefreshed:
            _emitFromSession(session, status: AuthStatus.tokenRefreshed);
            break;
          case supa.AuthChangeEvent.signedOut:
          case supa.AuthChangeEvent.userDeleted:
            _emitUnauthenticated();
            break;
          case supa.AuthChangeEvent.passwordRecovery:
            _emit(AuthStatus.passwordRecovery, _currentUser);
            break;
          case supa.AuthChangeEvent.mfaChallengeVerified:
            _emitFromSession(session);
            break;
        }
      },
      onError: (error, st) {
        logError('SupabaseAuthDataSource.authStateChanges', error, st);
        _emitUnauthenticated();
      },
    );
  }

  void _emitFromSession(
    supa.Session? session, {
    AuthStatus status = AuthStatus.authenticated,
  }) {
    final user = session?.user;
    if (user == null) {
      _emitUnauthenticated();
      return;
    }

    _currentUser = _mapSupabaseUser(user);
    _emit(status, _currentUser);
  }

  void _emitUnauthenticated() {
    _currentUser = null;
    _emit(AuthStatus.unauthenticated, null);
  }

  void _emit(AuthStatus status, AuthUserDto? user) {
    _latestStatus = status;
    _latestUser = user;
    _authStateController.add((status, user));
  }

  void _emitLatest() {
    final status = _latestStatus;
    if (status == null) return;
    _authStateController.add((status, _latestUser));
  }

  AuthUserDto _mapSupabaseUser(supa.User supabaseUser) {
    return AuthUserDto(
      id: supabaseUser.id,
      email: supabaseUser.email,
      displayName: supabaseUser.userMetadata?['display_name'] as String?,
      avatarUrl: supabaseUser.userMetadata?['avatar_url'] as String?,
      emailConfirmedAt: supabaseUser.emailConfirmedAt != null
          ? DateTime.parse(supabaseUser.emailConfirmedAt!)
          : null,
      isAnonymous: supabaseUser.isAnonymous,
    );
  }

  @override
  Stream<(AuthStatus, AuthUserDto?)> get authStateChanges => _authStateController.stream;

  @override
  AuthUserDto? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  bool get isAnonymous => _currentUser?.isAnonymous ?? false;

  // ═══════════════════════════════════════════════════════════════════════════
  // STANDARD AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<AuthFailure, AuthUserDto>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return left(const AuthFailure.unknown('User is null after sign in'));
      }

      return right(_mapSupabaseUser(user));
    } on supa.AuthException catch (e, st) {
      logError('SupabaseAuthDataSource.signInWithEmail', e, st);
      return left(_mapAuthException(e));
    } catch (e, st) {
      logError('SupabaseAuthDataSource.signInWithEmail', e, st);
      return left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, AuthUserDto>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );

      final user = response.user;
      if (user == null) {
        return left(const AuthFailure.unknown('User is null after sign up'));
      }

      return right(_mapSupabaseUser(user));
    } on supa.AuthException catch (e, st) {
      logError('SupabaseAuthDataSource.signUpWithEmail', e, st);
      return left(_mapAuthException(e));
    } catch (e, st) {
      logError('SupabaseAuthDataSource.signUpWithEmail', e, st);
      return left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithOAuth({
    required OAuthProvider provider,
  }) async {
    try {
      await _supabase.auth.signInWithOAuth(
        _mapToSupabaseProvider(provider),
        redirectTo: 'io.supabase.yourapp://callback',
      );
      // OAuth flow jest asynchroniczny — finalny user przychodzi przez stream.
      return right(unit);
    } on supa.AuthException catch (e, st) {
      logError('SupabaseAuthDataSource.signInWithOAuth', e, st);
      return left(_mapAuthException(e));
    } catch (e, st) {
      logError('SupabaseAuthDataSource.signInWithOAuth', e, st);
      return left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithMagicLink({
    required String email,
  }) async {
    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'io.supabase.yourapp://callback',
      );
      return right(unit);
    } on supa.AuthException catch (e, st) {
      logError('SupabaseAuthDataSource.signInWithMagicLink', e, st);
      return left(_mapAuthException(e));
    } catch (e, st) {
      logError('SupabaseAuthDataSource.signInWithMagicLink', e, st);
      return left(AuthFailure.unknown(e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ANONYMOUS AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<AuthFailure, AuthUserDto>> signInAnonymously() async {
    try {
      final response = await _supabase.auth.signInAnonymously();

      final user = response.user;
      if (user == null) {
        return left(const AuthFailure.unknown('User is null after anonymous sign in'));
      }

      return right(_mapSupabaseUser(user));
    } on supa.AuthException catch (e, st) {
      logError('SupabaseAuthDataSource.signInAnonymously', e, st);
      return left(_mapAuthException(e));
    } catch (e, st) {
      logError('SupabaseAuthDataSource.signInAnonymously', e, st);
      return left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, AuthUserDto>> linkWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (_currentUser == null) {
        return left(const AuthFailure.unknown('No user logged in'));
      }
      if (!_currentUser!.isAnonymous) {
        return left(const AuthFailure.alreadyLinked());
      }

      // NOTE: Ten projekt ma email confirmations OFF, więc można ustawić email+hasło jednocześnie.
      // Jeśli włączysz confirmations: najpierw updateUser(email), potem po weryfikacji updateUser(password).
      final response = await _supabase.auth.updateUser(
        supa.UserAttributes(
          email: email,
          password: password,
        ),
      );

      final user = response.user;
      if (user == null) {
        return left(const AuthFailure.unknown('User is null after linking'));
      }

      return right(_mapSupabaseUser(user));
    } on supa.AuthException catch (e, st) {
      logError('SupabaseAuthDataSource.linkWithEmail', e, st);
      return left(_mapAuthException(e));
    } catch (e, st) {
      logError('SupabaseAuthDataSource.linkWithEmail', e, st);
      return left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> linkWithOAuth({
    required OAuthProvider provider,
  }) async {
    try {
      if (_currentUser == null) {
        return left(const AuthFailure.unknown('No user logged in'));
      }
      if (!_currentUser!.isAnonymous) {
        return left(const AuthFailure.alreadyLinked());
      }

      await _supabase.auth.linkIdentity(
        _mapToSupabaseProvider(provider),
        redirectTo: 'io.supabase.yourapp://callback',
      );
      // OAuth flow jest asynchroniczny — finalny user przychodzi przez stream.
      return right(unit);
    } on supa.AuthException catch (e, st) {
      logError('SupabaseAuthDataSource.linkWithOAuth', e, st);
      return left(_mapAuthException(e));
    } catch (e, st) {
      logError('SupabaseAuthDataSource.linkWithOAuth', e, st);
      return left(AuthFailure.unknown(e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCOUNT MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<AuthFailure, Unit>> signOut() async {
    try {
      await _supabase.auth.signOut();
      return right(unit);
    } on supa.AuthException catch (e, st) {
      logError('SupabaseAuthDataSource.signOut', e, st);
      return left(_mapAuthException(e));
    } catch (e, st) {
      logError('SupabaseAuthDataSource.signOut', e, st);
      return left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> deleteAccount() async {
    try {
      await _supabase.functions.invoke('delete-user');
      await _supabase.auth.signOut();
      return right(unit);
    } on supa.AuthException catch (e, st) {
      logError('SupabaseAuthDataSource.deleteAccount', e, st);
      return left(_mapAuthException(e));
    } catch (e, st) {
      logError('SupabaseAuthDataSource.deleteAccount', e, st);
      return left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> resetPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.yourapp://reset-password',
      );
      return right(unit);
    } on supa.AuthException catch (e, st) {
      logError('SupabaseAuthDataSource.resetPassword', e, st);
      return left(_mapAuthException(e));
    } catch (e, st) {
      logError('SupabaseAuthDataSource.resetPassword', e, st);
      return left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> updatePassword({required String newPassword}) async {
    try {
      await _supabase.auth.updateUser(
        supa.UserAttributes(password: newPassword),
      );
      return right(unit);
    } on supa.AuthException catch (e, st) {
      logError('SupabaseAuthDataSource.updatePassword', e, st);
      return left(_mapAuthException(e));
    } catch (e, st) {
      logError('SupabaseAuthDataSource.updatePassword', e, st);
      return left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> refreshToken() async {
    try {
      await _supabase.auth.refreshSession();
      return right(unit);
    } on supa.AuthException catch (e, st) {
      logError('SupabaseAuthDataSource.refreshToken', e, st);
      return left(_mapAuthException(e));
    } catch (e, st) {
      logError('SupabaseAuthDataSource.refreshToken', e, st);
      return left(AuthFailure.unknown(e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  AuthFailure _mapAuthException(supa.AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('invalid login credentials') ||
        message.contains('invalid email or password')) {
      return const AuthFailure.wrongPassword();
    }
    if (message.contains('email not confirmed')) {
      return const AuthFailure.emailNotConfirmed();
    }
    if (message.contains('user already registered') ||
        message.contains('email already in use')) {
      return const AuthFailure.emailAlreadyInUse();
    }
    if (message.contains('identity already exists')) {
      return const AuthFailure.identityAlreadyExists();
    }
    if (message.contains('password should be at least')) {
      return const AuthFailure.weakPassword();
    }
    if (message.contains('rate limit') || message.contains('too many requests')) {
      return const AuthFailure.tooManyRequests();
    }
    if (message.contains('network') || message.contains('connection')) {
      return const AuthFailure.networkError();
    }

    return AuthFailure.serverError(e.message);
  }

  supa.Provider _mapToSupabaseProvider(OAuthProvider provider) {
    return switch (provider) {
      OAuthProvider.google => supa.Provider.google,
      OAuthProvider.apple => supa.Provider.apple,
      OAuthProvider.facebook => supa.Provider.facebook,
      OAuthProvider.github => supa.Provider.github,
      OAuthProvider.twitter => supa.Provider.twitter,
    };
  }

  void dispose() {
    _authSubscription?.cancel();
    _authStateController.close();
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/data/repositories/auth_repository_impl.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Stream<(AuthStatus, AppUser?)> get authStateChanges => _dataSource
      .authStateChanges
      .map((record) => (record.$1, _mapDtoToUser(record.$2)));

  @override
  AppUser? get currentUser => _mapDtoToUser(_dataSource.currentUser);

  @override
  bool get isAuthenticated => _dataSource.isAuthenticated;

  @override
  bool get isAnonymous => _dataSource.isAnonymous;

  @override
  Future<Either<AuthFailure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _dataSource.signInWithEmail(
      email: email,
      password: password,
    );
    return result.map(_mapDtoToUserRequired);
  }

  @override
  Future<Either<AuthFailure, AppUser>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final result = await _dataSource.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
    return result.map(_mapDtoToUserRequired);
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithOAuth({
    required OAuthProvider provider,
  }) {
    return _dataSource.signInWithOAuth(provider: provider);
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithMagicLink({
    required String email,
  }) {
    return _dataSource.signInWithMagicLink(email: email);
  }

  @override
  Future<Either<AuthFailure, AppUser>> signInAnonymously() async {
    final result = await _dataSource.signInAnonymously();
    return result.map(_mapDtoToUserRequired);
  }

  @override
  Future<Either<AuthFailure, AppUser>> linkWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _dataSource.linkWithEmail(
      email: email,
      password: password,
    );
    return result.map(_mapDtoToUserRequired);
  }

  @override
  Future<Either<AuthFailure, Unit>> linkWithOAuth({
    required OAuthProvider provider,
  }) {
    return _dataSource.linkWithOAuth(provider: provider);
  }

  @override
  Future<Either<AuthFailure, Unit>> signOut() => _dataSource.signOut();

  @override
  Future<Either<AuthFailure, Unit>> deleteAccount() => _dataSource.deleteAccount();

  @override
  Future<Either<AuthFailure, Unit>> resetPassword({required String email}) {
    return _dataSource.resetPassword(email: email);
  }

  @override
  Future<Either<AuthFailure, Unit>> updatePassword({required String newPassword}) {
    return _dataSource.updatePassword(newPassword: newPassword);
  }

  @override
  Future<Either<AuthFailure, Unit>> refreshToken() => _dataSource.refreshToken();

  AppUser? _mapDtoToUser(AuthUserDto? dto) {
    if (dto == null) return null;
    return _mapDtoToUserRequired(dto);
  }

  AppUser _mapDtoToUserRequired(AuthUserDto dto) {
    return AppUser(
      id: dto.id,
      email: dto.email,
      displayName: dto.displayName,
      avatarUrl: dto.avatarUrl,
      emailConfirmedAt: dto.emailConfirmedAt,
      isAnonymous: dto.isAnonymous,
    );
  }
}

// ==============================================================================
// CZĘŚĆ 3: APPLICATION LAYER - AuthCubit
// ==============================================================================

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/application/auth_state.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

part 'auth_state.freezed.dart';

/// Stan autoryzacji.
/// 
/// UWAGA: Anonymous user to [authenticated] z [user.isAnonymous == true].
/// NIE ma osobnego stanu dla anonymous — to by komplikowało AuthGate.
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  
  /// Zalogowany user (anonymous LUB permanent).
  /// Sprawdź [user.isAnonymous] żeby wiedzieć który.
  const factory AuthState.authenticated(AppUser user) = _Authenticated;
  
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(AuthFailure failure) = _Error;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/application/auth_cubit.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _authRepository;
  StreamSubscription<(AuthStatus, AppUser?)>? _authSubscription;

  AuthCubit(this._authRepository) : super(const AuthState.initial()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = _authRepository.authStateChanges.listen(
      (record) {
        final (status, user) = record;
        
        switch (status) {
          case AuthStatus.authenticated:
          case AuthStatus.tokenRefreshed:
            if (user != null) {
              emit(AuthState.authenticated(user));
            }
            break;
          case AuthStatus.unauthenticated:
            emit(const AuthState.unauthenticated());
            break;
          case AuthStatus.passwordRecovery:
          case AuthStatus.mfaChallengeVerified:
            emit(const AuthState.unauthenticated());
            break;
        }
      },
      onError: (error) {
        emit(AuthState.error(AuthFailure.unknown(error.toString())));
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STANDARD AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const AuthState.loading());
    
    final result = await _authRepository.signInWithEmail(
      email: email,
      password: password,
    );
    
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) {}, // Stream obsłuży sukces
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    emit(const AuthState.loading());
    
    final result = await _authRepository.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
    
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) {},
    );
  }

  Future<void> signInWithOAuth(OAuthProvider provider) async {
    emit(const AuthState.loading());
    
    final result = await _authRepository.signInWithOAuth(provider: provider);
    
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) {},
    );
  }

  Future<void> signInWithMagicLink(String email) async {
    emit(const AuthState.loading());
    
    final result = await _authRepository.signInWithMagicLink(email: email);
    
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ANONYMOUS AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  /// Zaloguj anonimowo.
  /// 
  /// Używaj np. dla przycisku "Pomiń" na ekranie powitalnym.
  Future<void> signInAnonymously() async {
    emit(const AuthState.loading());
    
    final result = await _authRepository.signInAnonymously();
    
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) {}, // Stream obsłuży sukces
    );
  }

  /// Linkuj anonymous konto z email/password.
  /// 
  /// Po sukcesie user.isAnonymous zmieni się na false,
  /// ale user.id zostanie TEN SAM — dane użytkownika są zachowane!
  Future<void> linkWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const AuthState.loading());
    
    final result = await _authRepository.linkWithEmail(
      email: email,
      password: password,
    );
    
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) {}, // Stream wyemituje userUpdated z isAnonymous = false
    );
  }

  /// Linkuj anonymous konto z OAuth.
  Future<void> linkWithOAuth(OAuthProvider provider) async {
    emit(const AuthState.loading());
    
    final result = await _authRepository.linkWithOAuth(provider: provider);
    
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) {},
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCOUNT MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  Future<void> deleteAccount() async {
    emit(const AuthState.loading());
    
    final result = await _authRepository.deleteAccount();
    
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) {},
    );
  }

  Future<void> resetPassword(String email) async {
    emit(const AuthState.loading());
    
    final result = await _authRepository.resetPassword(email: email);
    
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  void clearError() {
    emit(const AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}

// ==============================================================================
// CZĘŚĆ 4: PRESENTATION LAYER - AuthGate & Widgets
// ==============================================================================

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/presentation/auth_gate.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🚪 AUTH GATE — Główny strażnik nawigacji.
/// 
/// WAŻNE: Anonymous i Permanent user trafiają do TEGO SAMEGO [authenticatedBuilder]!
/// UI wewnątrz MainApp decyduje co pokazać na podstawie [user.isAnonymous].
/// 
/// Dlaczego tak? Bo przy linkowaniu (anon → permanent):
/// • user.id się NIE zmienia
/// • ValueKey(user.id) zostaje ten sam
/// • Widget tree się NIE przebudowuje
/// • UX jest płynny — bez "wylogowania" i ponownego logowania
class AuthGate extends StatelessWidget {
  final Widget Function(BuildContext context, AppUser user) authenticatedBuilder;
  final Widget Function(BuildContext context) unauthenticatedBuilder;
  final Widget? splashScreen;
  final Widget? loadingWidget;
  final Widget Function(BuildContext context, AuthFailure failure)? errorBuilder;

  const AuthGate({
    super.key,
    required this.authenticatedBuilder,
    required this.unauthenticatedBuilder,
    this.splashScreen,
    this.loadingWidget,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: state.when(
            initial: () => KeyedSubtree(
              key: const ValueKey('splash'),
              child: splashScreen ?? _defaultSplashScreen(),
            ),
            loading: () => KeyedSubtree(
              key: const ValueKey('loading'),
              child: loadingWidget ?? _defaultLoadingWidget(),
            ),
            authenticated: (user) => KeyedSubtree(
              // ⭐ KLUCZOWE: ValueKey(user.id), NIE ValueKey(user.isAnonymous)!
              // Dzięki temu przy linkowaniu widget tree się nie przebudowuje.
              key: ValueKey('authenticated-${user.id}'),
              child: authenticatedBuilder(context, user),
            ),
            unauthenticated: () => KeyedSubtree(
              key: const ValueKey('unauthenticated'),
              child: unauthenticatedBuilder(context),
            ),
            error: (failure) => KeyedSubtree(
              key: const ValueKey('error'),
              child: errorBuilder?.call(context, failure) 
                  ?? _defaultErrorWidget(context, failure),
            ),
          ),
        );
      },
    );
  }

  Widget _defaultSplashScreen() {
    return const Scaffold(
      body: Center(child: FlutterLogo(size: 100)),
    );
  }

  Widget _defaultLoadingWidget() {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _defaultErrorWidget(BuildContext context, AuthFailure failure) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Wystąpił błąd', style: Theme.of(context).textTheme.headlineSmall), // L10N
              const SizedBox(height: 8),
              SelectableText(_mapFailureToMessage(failure), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  context.read<AuthCubit>().clearError();
                },
                child: const Text('Spróbuj ponownie'), // L10N
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _mapFailureToMessage(AuthFailure failure) {
    return failure.when(
      invalidEmail: () => 'Nieprawidłowy adres email', // L10N
      invalidPassword: () => 'Nieprawidłowe hasło', // L10N
      emailAlreadyInUse: () => 'Ten email jest już zajęty', // L10N
      userNotFound: () => 'Nie znaleziono użytkownika', // L10N
      wrongPassword: () => 'Błędny email lub hasło', // L10N
      weakPassword: () => 'Hasło jest za słabe', // L10N
      emailNotConfirmed: () => 'Potwierdź swój email', // L10N
      tooManyRequests: () => 'Za dużo prób, spróbuj później', // L10N
      serverError: (msg) => msg ?? 'Błąd serwera', // L10N
      networkError: () => 'Brak połączenia z internetem', // L10N
      cancelled: () => 'Operacja anulowana', // L10N
      alreadyLinked: () => 'Konto jest już połączone', // L10N
      identityAlreadyExists: () => 'Ten email jest już używany przez inne konto', // L10N
      unknown: (msg) => msg ?? 'Nieznany błąd', // L10N
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/presentation/widgets/anonymous_upgrade_banner.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Banner zachęcający anonymous usera do założenia konta.
/// 
/// Używaj np. na górze MainApp lub w ustawieniach.
class AnonymousUpgradeBanner extends StatelessWidget {
  final AppUser user;
  final VoidCallback onUpgrade;

  const AnonymousUpgradeBanner({
    super.key,
    required this.user,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    // Nie pokazuj dla permanent users
    if (!user.isAnonymous) return const SizedBox.shrink();

    return MaterialBanner(
      padding: const EdgeInsets.all(16),
      content: const Text(
        'Twoje dane są zapisane tylko na tym urządzeniu. '
        'Załóż konto, żeby ich nie stracić!', // L10N
      ),
      leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
      backgroundColor: Colors.orange.shade50,
      actions: [
        TextButton(
          onPressed: onUpgrade,
          child: const Text('Załóż konto'), // L10N
        ),
      ],
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/presentation/widgets/anonymous_logout_warning_dialog.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Dialog ostrzegający anonymous usera przed wylogowaniem.
/// 
/// Po wylogowaniu anonymous user TRACI dostęp do swoich danych na zawsze!
class AnonymousLogoutWarningDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const AnonymousLogoutWarningDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Uwaga!'), // L10N
      content: const Text(
        'Jesteś zalogowany jako gość. Po wylogowaniu stracisz '
        'dostęp do wszystkich swoich danych na zawsze!\n\n'
        'Czy chcesz najpierw założyć konto?', // L10N
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'), // L10N
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO: Pokaż modal linkowania
          },
          child: const Text('Załóż konto'), // L10N
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('Wyloguj mimo to'), // L10N
        ),
      ],
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/presentation/widgets/link_account_bottom_sheet.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Bottom sheet do linkowania anonymous konta.
class LinkAccountBottomSheet extends StatefulWidget {
  const LinkAccountBottomSheet({super.key});

  @override
  State<LinkAccountBottomSheet> createState() => _LinkAccountBottomSheetState();
}

class _LinkAccountBottomSheetState extends State<LinkAccountBottomSheet> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _showOAuthOptions = false; // Ustaw true gdy dodasz Google OAuth

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (user) {
            if (!user.isAnonymous) {
              // Linkowanie się powiodło!
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Konto zostało utworzone!')), // L10N
              );
            }
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Załóż konto', // L10N
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Twoje dane zostaną zachowane.', // L10N
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email', // L10N
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v?.contains('@') == true ? null : 'Podaj email', // L10N
              ),
              const SizedBox(height: 16),
              
              // Password
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Hasło', // L10N
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) => (v?.length ?? 0) >= 6 ? null : 'Min. 6 znaków', // L10N
              ),
              const SizedBox(height: 16),

              // Inline error (bez SnackBar)
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final errorText = state.whenOrNull(
                    error: (failure) => _mapFailureToMessage(failure),
                  );

                  if (errorText == null) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SelectableText(
                      errorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              
              // Submit
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoading = state is _Loading;
                  
                  return FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Utwórz konto'), // L10N
                  );
                },
              ),
              const SizedBox(height: 16),
              
              // OAuth options (na start ukryte)
              if (_showOAuthOptions) ...[
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('lub'), // L10N
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthCubit>().linkWithOAuth(OAuthProvider.google);
                  },
                  icon: const Icon(Icons.g_mobiledata), // Użyj prawdziwej ikony Google
                  label: const Text('Kontynuuj z Google'), // L10N
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    
    context.read<AuthCubit>().linkWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  String _mapFailureToMessage(AuthFailure failure) {
    return failure.when(
      invalidEmail: () => 'Nieprawidłowy adres email', // L10N
      invalidPassword: () => 'Nieprawidłowe hasło', // L10N
      emailAlreadyInUse: () => 'Ten email jest już zajęty', // L10N
      userNotFound: () => 'Nie znaleziono użytkownika', // L10N
      wrongPassword: () => 'Błędny email lub hasło', // L10N
      weakPassword: () => 'Hasło jest za słabe', // L10N
      emailNotConfirmed: () => 'Potwierdź swój email', // L10N
      tooManyRequests: () => 'Za dużo prób, spróbuj później', // L10N
      serverError: (msg) => msg ?? 'Błąd serwera', // L10N
      networkError: () => 'Brak połączenia z internetem', // L10N
      cancelled: () => 'Operacja anulowana', // L10N
      alreadyLinked: () => 'Konto jest już połączone', // L10N
      identityAlreadyExists: () => 'Ten email jest już używany przez inne konto', // L10N
      unknown: (msg) => msg ?? 'Nieznany błąd', // L10N
    );
  }
}

// ==============================================================================
// CZĘŚĆ 5: PRZYKŁADY UŻYCIA
// ==============================================================================

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/auth/presentation/screens/welcome_screen.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Ekran powitalny z opcją "Pomiń" (anonymous login).
class WelcomeScreen extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const WelcomeScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              
              // Logo / ilustracja
              const FlutterLogo(size: 120),
              const SizedBox(height: 32),
              
              Text(
                'Witaj w aplikacji!', // L10N
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Zaloguj się, aby zsynchronizować dane między urządzeniami.', // L10N
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // Główne przyciski
              FilledButton(
                onPressed: onLogin,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Zaloguj się'), // L10N
              ),
              const SizedBox(height: 12),
              
              OutlinedButton(
                onPressed: onRegister,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Utwórz konto'), // L10N
              ),
              const SizedBox(height: 24),
              
              // ⭐ PRZYCISK "POMIŃ" — anonymous login
              TextButton(
                onPressed: () {
                  context.read<AuthCubit>().signInAnonymously();
                },
                child: const Text('Pomiń na razie'), // L10N
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/home/presentation/screens/main_app.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Główna aplikacja — dla anonymous I permanent users.
/// 
/// UI różni się na podstawie [user.isAnonymous]:
/// • Anonymous: banner zachęcający do założenia konta
/// • Permanent: pełna funkcjonalność
class MainApp extends StatelessWidget {
  final AppUser user;

  const MainApp({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moja Aplikacja'), // L10N
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // ⭐ Banner dla anonymous users
          AnonymousUpgradeBanner(
            user: user,
            onUpgrade: () => _showLinkAccountSheet(context),
          ),
          
          // Reszta UI
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.isAnonymous
                        ? 'Cześć, Gościu!' // L10N
                        : 'Cześć, ${user.displayNameOrEmail}!', // L10N
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.isAnonymous 
                        ? 'Korzystasz jako gość' // L10N
                        : 'Zalogowano jako ${user.displayNameOrEmail}', // L10N
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLinkAccountSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: const LinkAccountBottomSheet(),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(user: user),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/features/settings/presentation/screens/settings_screen.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Ustawienia z obsługą anonymous users.
class SettingsScreen extends StatelessWidget {
  final AppUser user;

  const SettingsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia')), // L10N
      body: ListView(
        children: [
          // ⭐ Dla anonymous: opcja założenia konta
          if (user.isAnonymous) ...[
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.blue),
              title: const Text('Załóż konto'), // L10N
              subtitle: const Text('Zabezpiecz swoje dane'), // L10N
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLinkAccountSheet(context),
            ),
            const Divider(),
          ],
          
          // Inne ustawienia...
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Powiadomienia'), // L10N
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            leading: Icon(Icons.palette),
            title: Text('Wygląd'), // L10N
            trailing: Icon(Icons.chevron_right),
          ),
          
          const Divider(),
          
          // Wylogowanie z ostrzeżeniem dla anonymous
          ListTile(
            leading: Icon(
              Icons.logout,
              color: user.isAnonymous ? Colors.red : null,
            ),
            title: Text(
              'Wyloguj się', // L10N
              style: TextStyle(
                color: user.isAnonymous ? Colors.red : null,
              ),
            ),
            subtitle: user.isAnonymous 
                ? const Text('Uwaga: stracisz wszystkie dane!', // L10N
                    style: TextStyle(color: Colors.red))
                : null,
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }

  void _showLinkAccountSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: const LinkAccountBottomSheet(),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    if (user.isAnonymous) {
      // ⭐ Pokaż ostrzeżenie dla anonymous users
      showDialog(
        context: context,
        builder: (_) => AnonymousLogoutWarningDialog(
          onConfirm: () => context.read<AuthCubit>().signOut(),
        ),
      );
    } else {
      // Normalne wylogowanie
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Wyloguj się'), // L10N
          content: const Text('Czy na pewno chcesz się wylogować?'), // L10N
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anuluj'), // L10N
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthCubit>().signOut();
              },
              child: const Text('Wyloguj'), // L10N
            ),
          ],
        ),
      );
    }
  }
}

// ==============================================================================
// CZĘŚĆ 6: MAIN.DART
// ==============================================================================

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📁 lib/main.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
  
  await configureDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: MaterialApp(
        title: 'My App', // L10N
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: AuthGate(
          // ⭐ Ten sam builder dla anonymous I permanent users!
          authenticatedBuilder: (context, user) => MainApp(user: user),
          unauthenticatedBuilder: (context) => const AuthFlowScreen(),
          splashScreen: const SplashScreen(),
        ),
      ),
    );
  }
}

// ==============================================================================
// CZĘŚĆ 7: APP SESSION + REVENUECAT (PRO)
// ==============================================================================

// Źródłem prawdy dla "PRO" jest RevenueCat. Najbezpieczniej połączyć
// stream auth + stream subskrypcji w jeden AppSession.
// Jeśli chcesz enforce'ować PRO po stronie DB (RLS), zapisuj tier w tabeli
// (np. profiles.tier) aktualizowanej webhookiem/Edge Function.

/*
enum UserTier { guest, registered, pro }

@freezed
class AppSession with _$AppSession {
  const factory AppSession.initial() = _Initial;
  const factory AppSession.unauthenticated() = _Unauthenticated;
  const factory AppSession.authenticated({
    required AppUser user,
    required UserTier tier,
  }) = _Authenticated;
}

Stream<AppSession> get appSession => Rx.combineLatest2(
  authRepository.authStateChanges,
  revenueCatRepository.tierChanges, // źródło prawdy dla PRO
  (auth, isPro) {
    final (status, user) = auth;
    if (status == AuthStatus.unauthenticated || user == null) {
      return const AppSession.unauthenticated();
    }

    final tier = user.isAnonymous
        ? UserTier.guest
        : (isPro ? UserTier.pro : UserTier.registered);

    return AppSession.authenticated(user: user, tier: tier);
  },
);

// Po wylogowaniu: pamiętaj o Purchases.logOut() aby RevenueCat zresetował usera.
*/

// ==============================================================================
// DODATEK: BlocListener do zamykania overlaye po login/logout
// ==============================================================================

/*
class RootGateWithListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, next) => prev != next,
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (_) => _closeOverlays(context),
          unauthenticated: () => _closeOverlays(context),
        );
      },
      child: AuthGate(
        authenticatedBuilder: (context, user) => AppFlow(),
        unauthenticatedBuilder: (context) => AuthFlow(),
        splashScreen: const SplashScreen(),
      ),
    );
  }

  void _closeOverlays(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .popUntil((route) => route.isFirst);
  }
}
*/
// Warunek bezpieczeństwa: działa najlepiej, gdy AppFlow/AuthFlow mają własne Navigatory.
//
// class AppFlow extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       onGenerateRoute: (_) => MaterialPageRoute(
//         builder: (_) => const HomeScreen(),
//       ),
//     );
//   }
// }

// ==============================================================================
// PODSUMOWANIE
// ==============================================================================
//
// ANONYMOUS USER FLOW:
//
// 1. User klika "Pomiń" → signInAnonymously()
// 2. Supabase tworzy anonymous user (isAnonymous: true)
// 3. Stream emituje authenticated → AuthGate pokazuje MainApp
// 4. MainApp pokazuje banner "Załóż konto"
// 5. User klika banner → linkWithEmail() lub linkWithOAuth()
// 6. Supabase linkuje konto (TEN SAM user.id!)
// 7. Stream emituje userUpdated z isAnonymous: false
// 8. ValueKey(user.id) się NIE zmienia → widget tree się NIE przebudowuje
// 9. Banner znika, user ma pełne konto, dane zachowane!
//
// KLUCZOWE:
// • Anonymous = authenticated z flagą
// • ValueKey(user.id), NIE ValueKey(isAnonymous)
// • UI decyduje co pokazać na podstawie user.isAnonymous
// • Przy linkowaniu user.id zostaje ten sam = płynne UX
//
// ════════════════════════════════════════════════════════════════════════════════
