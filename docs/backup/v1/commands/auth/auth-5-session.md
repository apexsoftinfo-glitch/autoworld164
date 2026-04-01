# Architektura po tym kroku

Po `/auth` SessionRepository będzie **kompletny** (4/4 źródła, pełna integracja RC):

```
SessionRepository (FULL — complete RC integration with logIn/logOut)
├── AuthDataSource ✅ (Supabase Auth)
├── ProfileDataSource ✅ (Supabase + cache)
├── SubscriptionDataSource ✅ (RevenueCat) ← PEŁNY: logIn/logOut, CustomerInfo stream
└── ConnectivityDataSource ✅ (connectivity_plus)
```

**Tier computation (finalne):**
```dart
UserTier get tier {
  if (isPro) return UserTier.pro;           // ← RC entitlements (pełna integracja)
  if (!isAnonymous) return UserTier.registered;
  return UserTier.guest;
}

bool get isPro => customerInfo?.entitlements.active.containsKey('pro') ?? false;
```

---

# KROK 7.5: SessionRepositoryImpl (partial)

**To jest serce architektury!** Przeczytaj `docs/SESSION_ARCHITECTURE.md` sekcja 2.2-2.6.

Zamień `FakeSessionRepository` na prawdziwy `SessionRepositoryImpl`:

1. **SupabaseProfileDataSource** — z realtime + cache w `flutter_secure_storage`
2. **ConnectivityPlusDataSource** — `connectivity_plus` package
3. **SessionRepositoryImpl** — `switchMap` + `combineLatest3` (Profile + Connectivity + Subscription)
   - `SubscriptionDataSource` = RevenueCat anonymous (już zarejestrowany w DI jako `RevenueCatDataSource`)

**Aktualizuj DI** — zamień Fake na prawdziwe DataSources.

**WAŻNE:** `RevenueCatDataSource` jest już zarejestrowany w DI jako `SubscriptionDataSource` — NIE twórz `FakeSubscriptionDataSource`. SessionRepositoryImpl powinien używać `watchEntitlements()` z prawdziwego RC.

**UWAGA:** W tym kroku rozbudowujemy RC do pełnej integracji — w tym logIn/logOut sync z userId. Po tym kroku RC jest kompletny.

**AppGate** — używaj `SessionCubit` zamiast `AuthCubit`:
```dart
BlocBuilder<SessionCubit, UserSession>(
  builder: (context, session) => session.map(
    (s) {
      if (s.needsOnboarding) return const OnboardingScreen();
      if (!s.hasCompletedOnboarding) return const OnboardingScreen();
      return const HomeScreen();
    },
    unauthenticated: (_) => const WelcomeScreen(),
    initializing: (_) => const SplashScreen(),
  ),
)
```

---

# KROK 8: Rozbuduj SubscriptionDataSource i RevenueCatDataSource

**Cel:** Evolve minimal RC integration (bool isPro) to full CustomerInfo stream with auth sync.

## 8.1 Rozbuduj SubscriptionDataSource interface

**Plik do EDYCJI (nie tworzenia!):** istniejący plik z `SubscriptionDataSource`

Rozbuduj minimalny interfejs z `watchIsPro()` + `getIsPro()` do pełnego:

```dart
abstract class SubscriptionDataSource {
  // Ewolucja: bool isPro → pełny CustomerInfo
  Stream<CustomerInfo?> watchEntitlements();
  Future<CustomerInfo?> getCustomerInfo();

  // Auth sync
  Future<void> logIn(String userId);
  Future<void> logOut();

  // Purchases
  Future<CustomerInfo> purchase(Package package);
  Future<Offerings?> getOfferings();
  Future<CustomerInfo> restorePurchases();
}
```

**WAŻNE:** Stare metody `watchIsPro()` i `getIsPro()` zostają ZASTĄPIONE przez `watchEntitlements()` i `getCustomerInfo()`. Zaktualizuj wszystkie miejsca w kodzie które ich używają.

## 8.2 Rozbuduj RevenueCatDataSource

**Plik do EDYCJI (nie tworzenia!):** istniejący `RevenueCatDataSource`

Rozbuduj z minimalnego (bool BehaviorSubject) do pełnego (CustomerInfo? BehaviorSubject):

```dart
class RevenueCatDataSource implements SubscriptionDataSource {
  // ZMIANA: BehaviorSubject<bool> → BehaviorSubject<CustomerInfo?>
  final _customerInfoController = BehaviorSubject<CustomerInfo?>();

  RevenueCatDataSource() {
    Purchases.addCustomerInfoUpdateListener((info) {
      _customerInfoController.add(info);
    });
  }

  @override
  Stream<CustomerInfo?> watchEntitlements() {
    return _customerInfoController.stream
        .distinct((a, b) =>
            a?.entitlements.active.keys.toString() ==
            b?.entitlements.active.keys.toString())
        .doOnError((e, s) => debugPrint('[SubscriptionDS] Error: $e'))
        .onErrorReturn(null); // KRYTYCZNE: null = free tier
  }

  @override
  Future<void> logIn(String userId) async {
    await Purchases.logIn(userId);
    final info = await Purchases.getCustomerInfo();
    _customerInfoController.add(info);
  }

  @override
  Future<void> logOut() async {
    await Purchases.logOut();
    _customerInfoController.add(null);
  }

  @override
  Future<CustomerInfo> purchase(Package package) async {
    final purchaseResult = await Purchases.purchasePackage(package);
    _customerInfoController.add(purchaseResult.customerInfo);
    return purchaseResult.customerInfo;
  }

  @override
  Future<Offerings?> getOfferings() async {
    return await Purchases.getOfferings();
  }

  @override
  Future<CustomerInfo?> getCustomerInfo() async {
    return await Purchases.getCustomerInfo();
  }

  @override
  Future<CustomerInfo> restorePurchases() async {
    final info = await Purchases.restorePurchases();
    _customerInfoController.add(info);
    return info;
  }

  void dispose() {
    _customerInfoController.close();
  }
}
```

## 8.3 Zaktualizuj UserSession i SessionRepositoryImpl

- Zmień pole `isPro` (bool) na computed z `CustomerInfo?`:
  ```dart
  bool get isPro => customerInfo?.entitlements.active.containsKey('pro') ?? false;
  ```
- Podepnij nowy `watchEntitlements()` stream do `combineLatest` w `SessionRepositoryImpl`.
- Zaktualizuj DI jeśli potrzeba.

**UWAGA:** `purchases_flutter` i `purchases_ui_flutter` są już w pubspec, RC już zainicjalizowany w main.dart.

**Status:** `in-progress: rc-sync`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/auth/auth-6-sync.md`
