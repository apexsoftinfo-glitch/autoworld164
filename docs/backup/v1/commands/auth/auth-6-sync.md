# KROK 9: RC logIn/logOut w auth flow

Wbuduj RC sync w `SessionRepositoryImpl` lub `AuthDataSource`:

| Event | RC Action |
|-------|-----------|
| `signInAnonymously()` | `Purchases.logIn(user.id)` |
| `signInWithEmail()` | `Purchases.logIn(user.id)` |
| `linkIdentity()` | **NIC** (user.id się nie zmienia!) |
| `signOut()` | `Purchases.logOut()` |

Użyj `SubscriptionDataSource.logIn()` / `.logOut()` — NIE bezpośrednio `Purchases.*`.

---

# KROK 10: App Lifecycle Observer

Refresh on resume, throttle 30s:

```dart
class AppLifecycleObserver extends WidgetsBindingObserver {
  final SessionRepository _sessionRepository;
  DateTime? _lastRefresh;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshIfNeeded();
    }
  }

  void _refreshIfNeeded() {
    final now = DateTime.now();
    if (_lastRefresh == null ||
        now.difference(_lastRefresh!) > const Duration(seconds: 30)) {
      _sessionRepository.refresh();
      _lastRefresh = now;
    }
  }
}
```

---

# KROK 11: Weryfikacja tier computation

Po tym kroku tier musi być **fully computed end-to-end**. 4 test scenarios:

```dart
// 1. Anonymous user bez subskrypcji → guest
// 2. Registered user bez subskrypcji → registered
// 3. Anonymous user Z subskrypcją → pro (+ CTA "zarejestruj się")
// 4. Registered user Z subskrypcją → pro
```

Sprawdź `session.shouldShowRegisterCTA`:
```dart
if (session.shouldShowRegisterCTA) {
  // Pokaż banner "Zarejestruj się żeby nie stracić zakupu"
}
```

**Status:** `in-progress: smoke-test`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/auth/auth-7-test.md`
