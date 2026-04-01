---
name: supabase-auth
description: Use when implementing auth, login, logout, anonymous users, session management, linking accounts, AuthGate, auth state changes, signInAnonymously, signInWithEmail, linkIdentity, updateUser, or auth stream handling. Covers Supabase Auth with Clean Architecture pattern. (project)
---

# Skill: Supabase Auth Integration

Integracja Supabase Auth z Flutter w architekturze Clean Architecture.

---

## Filozofia (przeczytaj najpierw!)

### Zasada #1: UI nie nawiguje na logout — tylko reaguje na stan sesji

```
❌ ŹLE:  klik logout → Navigator.popUntil('/login')
✅ DOBRZE: klik logout → authCubit.signOut() → stream emituje → AuthGate przełącza root
```

**Dlaczego?**
| Problem z manualną nawigacją | Rozwiązanie przez stream |
|------------------------------|--------------------------|
| Bugi z niepoprawnym stackiem | Stack nie istnieje — nowy widget tree |
| Wycieki stanu po wylogowaniu | Stary subtree jest disposed |
| Problemy na web (back/refresh) | Stan jest reaktywny, nie imperatywny |

### Zasada #2: Anonymous User = Authenticated z flagą

Anonymous user to **PEŁNOPRAWNY użytkownik**:
- Ma sesję, token, user_id
- Może zapisywać dane w bazie (RLS działa!)
- Jedyna różnica: `user.isAnonymous == true`

AuthState ma nadal tylko 2 główne stany (authenticated/unauthenticated).
UI decyduje co pokazać na podstawie `user.isAnonymous`.

### Zasada #3: ValueKey(user.id), NIE ValueKey(isAnonymous)

Przy linkowaniu (anon → permanent):
- `user.id` się NIE zmienia
- `ValueKey(user.id)` zostaje ten sam
- Widget tree się NIE przebudowuje
- Dane usera zostają, UX jest płynny

### Zasada #4: Initial Emission

W `supabase_flutter` event `initialSession` jest emitowany po odczycie sesji z local storage — to jest właściwy moment na pierwszą emisję.

**NIE emituj `currentSession` synchronicznie w konstruktorze** — może być nieodczytana.

**Przykład (poprawiony initial emission):**
```dart
void _initAuthListener() {
  // NIE emituj nic synchronicznie!
  // Czekaj na initialSession event.
  _authSubscription = _supabase.auth.onAuthStateChange.listen((authState) {
    switch (authState.event) {
      case AuthChangeEvent.initialSession:
        if (authState.session != null) {
          _emit(AuthStatus.authenticated, _mapUser(authState.session!.user));
        } else {
          _emit(AuthStatus.unauthenticated, null);
        }
        break;
      case AuthChangeEvent.signedIn:
        // ...obsłuż kolejne eventy
        break;
      case AuthChangeEvent.signedOut:
        // ...
        break;
      case AuthChangeEvent.userUpdated:
      case AuthChangeEvent.tokenRefreshed:
      case AuthChangeEvent.passwordRecovery:
      case AuthChangeEvent.mfaChallengeVerified:
        // ...
        break;
    }
  });
}
```

**Jeśli używasz `StreamController.broadcast`:** trzymaj ostatni stan i emituj go w `onListen` (replay latest), żeby nowy subscriber nie przegapił initiala.

---

## Wymagania Supabase Dashboard (MUST)

| Ustawienie | Gdzie | Wymagane |
|------------|-------|----------|
| Anonymous Sign-Ins | Auth → Providers | ✅ |
| Manual Identity Linking (beta) | Auth → Providers | ✅ |
| Email confirmations | Auth → Settings | ❌ OFF (na start) |

**Dlaczego OFF dla email confirmations?**
Dzięki temu anonymous → email/password może odbyć się jednym `updateUser(...)`.
Jeśli włączysz: najpierw `updateUser(email)`, potem `updateUser(password)` po weryfikacji.

**Warstwa danych (architektura):**
- Import `supabase_flutter` **tylko w DataSource**.
- Repository mapuje DTO → Domain i nie zna Supabase SDK.

---

## AuthState (3 stany, nie 2!)

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;           // ← KLUCZOWE!
  const factory AuthState.authenticated(AppUser user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
}
```

**Dlaczego `initial`?**

Na starcie Supabase potrzebuje ułamka sekundy na odczyt sesji z localStorage/SharedPreferences.

```
BEZ initial:
Start → LoginScreen → HomeScreen  ← User widzi "mignięcie" loginu!

Z initial:
Start → SplashScreen → HomeScreen  ← Płynne przejście
```

**UWAGA:** Anonymous user to `authenticated` z `user.isAnonymous == true`.

---

## Anonymous Users — Architektura

### Flow: Anonymous → Permanent

```
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│  signInAnon()   │ ───► │  Anonymous User │ ───► │  Permanent User │
│                 │      │                 │      │                 │
│                 │      │  id: "abc-123"  │      │  id: "abc-123"  │ ← TEN SAM!
│                 │      │  isAnonymous:   │      │  isAnonymous:   │
│                 │      │  true           │      │  false          │
└─────────────────┘      └────────┬────────┘      └─────────────────┘
                                  │
                         linkWithEmail(email, pass)
                         lub linkWithOAuth(google)
                                  │
                                  ▼
                         Stream emituje: userUpdated
                         (user.id się NIE zmienia!)
```

### Dlaczego flaga, nie osobny stan?

```dart
// ❌ ŹLE - komplikuje AuthGate:
@freezed
class AuthState {
  const factory AuthState.anonymous(AppUser) = _Anonymous;
  const factory AuthState.authenticated(AppUser) = _Authenticated;
  // AuthGate musi obsłużyć 3 różne flow...
}

// ✅ DOBRZE - proste:
@freezed
class AppUser {
  const factory AppUser({
    required String id,
    @Default(false) bool isAnonymous,  // ← tylko flaga
  }) = _AppUser;
}
```

---

## Linking Anonymous → Permanent

### Metoda linkWithEmail

```dart
Future<Either<AuthFailure, AppUser>> linkWithEmail({
  required String email,
  required String password,
}) async {
  // 1. Sprawdź czy user jest anonymous
  if (!_currentUser!.isAnonymous) {
    return left(const AuthFailure.alreadyLinked());
  }

  // 2. updateUser z email + password (gdy confirmations OFF)
  final response = await _supabase.auth.updateUser(
    UserAttributes(email: email, password: password),
  );

  // 3. Stream emituje userUpdated z isAnonymous = false
  return right(_mapSupabaseUser(response.user!));
}
```

**WAŻNE:** `user.id` się NIE zmienia! Dane w bazie zostają przypisane do tego samego usera.

### Metoda linkWithOAuth

```dart
Future<Either<AuthFailure, Unit>> linkWithOAuth({
  required OAuthProvider provider,
}) async {
  await _supabase.auth.linkIdentity(
    _mapToSupabaseProvider(provider),
    redirectTo: 'io.supabase.yourapp://callback',
  );
  // OAuth flow asynchroniczny — user przychodzi przez stream
  return right(unit);
}
```

---

## AuthGate Widget

```dart
class AuthGate extends StatelessWidget {
  final Widget Function(BuildContext, AppUser) authenticatedBuilder;
  final Widget Function(BuildContext) unauthenticatedBuilder;
  final Widget? splashScreen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: state.when(
            initial: () => KeyedSubtree(
              key: const ValueKey('splash'),
              child: splashScreen ?? const SplashScreen(),
            ),
            authenticated: (user) => KeyedSubtree(
              // ⭐ KLUCZOWE: ValueKey(user.id), NIE ValueKey(isAnonymous)!
              key: ValueKey('authenticated-${user.id}'),
              child: authenticatedBuilder(context, user),
            ),
            unauthenticated: () => KeyedSubtree(
              key: const ValueKey('unauthenticated'),
              child: unauthenticatedBuilder(context),
            ),
          ),
        );
      },
    );
  }
}
```

**WAŻNE:** Anonymous i Permanent user trafiają do TEGO SAMEGO `authenticatedBuilder`!
UI wewnątrz decyduje co pokazać na podstawie `user.isAnonymous`.

---

## User Tiers (Guest / Registered / Pro)

```
Guest (anonymous):    user.isAnonymous == true
Registered (free):    !isAnonymous && !isPro
Pro (subskrypcja):    !isAnonymous && isPro (z RevenueCat)
```

### Łączenie Auth + Subscription streams

```dart
final appSession = Rx.combineLatest2(
  authRepository.authStateChanges,
  subscriptionRepository.isProChanges,
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
```

**WAŻNE:**
- `tier` NIE idzie do `ValueKey` — zmiana pro/free nie resetuje subtree
- Po `signOut()` wywołaj też `Purchases.logOut()`
- Jeśli chcesz gate’ować PRO w DB (RLS), zapisuj tier w tabeli (webhook/Edge Function)

---

## Struktura folderów

**Warianty (wybierz zgodny z projektem):**
- **Compact:** `cubit/`, `repository/`, `data_source/`, `models/`, `ui/`
- **Clean layers:** `domain/`, `data/`, `application/`, `presentation/` + `data_sources/` i `models/`

```
lib/features/auth/
├── cubit/
│   └── auth_cubit.dart           # Cubit + State (freezed)
├── repository/
│   └── auth_repository.dart      # Abstrakcja + Impl
├── data_source/
│   └── auth_data_source.dart     # Abstrakcja + SupabaseImpl
├── models/
│   └── app_user.dart             # Freezed entity
└── ui/
    ├── auth_gate.dart            # Root switcher
    ├── screens/
    │   ├── login_screen.dart
    │   └── register_screen.dart
    └── widgets/
        ├── anonymous_upgrade_banner.dart
        └── link_account_bottom_sheet.dart
```

---

## RLS dla różnych tierów

### Anonymous vs Registered

```sql
-- tylko użytkownicy nie-anonimowi mogą dodawać rekordy
create policy "Only permanent users can insert"
on public.items
as restrictive for insert
to authenticated
with check ((select (auth.jwt()->>'is_anonymous')::boolean) is false);
```

### Pro-only (z tier w DB)

```sql
-- Zakładając profiles.tier ∈ { 'guest', 'registered', 'pro' }
create policy "Pro users can export"
on public.exports
as restrictive for insert
to authenticated
with check (
  exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.tier = 'pro'
  )
);
```

**UWAGA:** RevenueCat nie jest dostępny w RLS. Jeśli chcesz gate'ować PRO po stronie bazy, musisz mieć tier zapisany w DB (aktualizowany webhookiem/Edge Function).

---

## Nawigacja i zamykanie overlayów

AuthGate **nie wykonuje `popToRoot`**. Przełącza cały subtree.

### Problem z dialogami

`showDialog` domyślnie używa `rootNavigator: true` → dialog może zostać na wierzchu po logout.

### Rozwiązanie: BlocListener

```dart
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
      child: AuthGate(...),
    );
  }

  void _closeOverlays(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .popUntil((route) => route.isFirst);
  }
}
```

### Alternatywa: Osobne Navigatory dla flows

```dart
class AppFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }
}
```

Przy zmianie auth cały `Navigator` flow zostaje **disposed**.

---

## Checklist przed wdrożeniem

- [ ] Anonymous Sign-Ins włączone w Supabase
- [ ] Manual Identity Linking (beta) włączone
- [ ] Email confirmations OFF (na start)
- [ ] Auth stream obsługuje `initialSession` event
- [ ] AuthState ma stan `initial`
- [ ] AuthGate używa `ValueKey(user.id)` — NIE `ValueKey(isAnonymous)`!
- [ ] Cubit NIE robi nawigacji — tylko emituje stany
- [ ] Cubit jest `@lazySingleton` (nie factory!)
- [ ] Repository jest singleton (jeden stream dla całej app)
- [ ] `isAnonymous` mapowany z `supabaseUser.isAnonymous`
- [ ] UI obsługuje banner dla anonymous user
- [ ] Deep linking skonfigurowany dla OAuth/Magic Link
- [ ] `Purchases.logOut()` po wylogowaniu (jeśli RevenueCat)

---

## Anty-wzorce (NIGDY nie rób!)

```dart
// ❌ ŹLE: Nawigacja w Cubit
class AuthCubit extends Cubit<AuthState> {
  Future<void> signOut(BuildContext context) async {
    await _repo.signOut();
    Navigator.of(context).pushReplacementNamed('/login'); // NIE!
  }
}

// ❌ ŹLE: ValueKey z isAnonymous
KeyedSubtree(
  key: ValueKey('auth-${user.isAnonymous}'), // Spowoduje rebuild przy linkowaniu!
  child: MainApp(user: user),
)

// ❌ ŹLE: Osobny stan dla anonymous
@freezed
class AuthState {
  const factory AuthState.anonymous(AppUser) = _Anonymous; // Niepotrzebna komplikacja
}

// ❌ ŹLE: Synchroniczny initial w konstruktorze DataSource
SupabaseAuthDataSource() {
  _emit(AuthStatus.authenticated, _mapUser(_supabase.auth.currentUser)); // Może być null!
}
```

---

## Testy

```dart
blocTest<AuthCubit, AuthState>(
  'emituje authenticated z isAnonymous=true dla anonymous user',
  build: () {
    when(() => mockRepo.authStateChanges).thenAnswer(
      (_) => Stream.value((AuthStatus.authenticated, anonymousUser)),
    );
    return AuthCubit(mockRepo);
  },
  expect: () => [
    AuthState.authenticated(anonymousUser),
  ],
  verify: (_) {
    expect(anonymousUser.isAnonymous, true);
  },
);

blocTest<AuthCubit, AuthState>(
  'linkWithEmail zmienia isAnonymous na false',
  seed: () => AuthState.authenticated(anonymousUser),
  build: () {
    when(() => mockRepo.linkWithEmail(any(), any()))
        .thenAnswer((_) async => right(permanentUser));
    when(() => mockRepo.authStateChanges).thenAnswer(
      (_) => Stream.value((AuthStatus.authenticated, permanentUser)),
    );
    return AuthCubit(mockRepo);
  },
  act: (cubit) => cubit.linkWithEmail(email: 'test@test.com', password: '123456'),
  verify: (_) {
    expect(permanentUser.isAnonymous, false);
    expect(permanentUser.id, anonymousUser.id); // TEN SAM ID!
  },
);
```

---

## FAQ

**Q: Czy anonymous user może się "wylogować"?**
Tak, ale to oznacza utratę danych (chyba że je zsynchronizowałeś). `signOut()` dla anon usera = utrata sesji na zawsze.

**Q: Co jeśli anonymous user odinstaluje appkę?**
Sesja jest w SharedPreferences/localStorage. Po reinstalacji = nowy anonymous user, stare dane stracone.

**Q: Jak przenieść dane anonymous → permanent?**
Nie musisz! `user_id` się nie zmienia przy linkowaniu. Dane w bazie zostają automatycznie.

**Q: Czy mogę użyć `go_router`?**
Tak! `go_router` ma `redirect` który może nasłuchiwać na stan auth. AuthGate działa równie dobrze bez niego.

---

## Pełna implementacja

Kompletny przykład z wszystkimi warstwami (Domain, Data, Application, Presentation) znajdziesz w:
- `examples/full_implementation.dart.md` — gotowy do skopiowania kod z komentarzami

