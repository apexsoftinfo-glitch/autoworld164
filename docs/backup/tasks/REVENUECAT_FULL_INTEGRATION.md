# RevenueCat Full Integration

Wykonaj te kroki dopiero wtedy, gdy chcesz włączyć prawdziwe subskrypcje.

To nie jest opis ogólny. To jest checklista wykonawcza dla agenta AI z dostępem do kodu i repo.

## Cel

Masz osiągnąć 4 rzeczy:

1. `RevenueCat` działa naprawdę na iOS i Android.
2. `RevenueCat appUserID` zawsze równa się `Supabase user.id`, także dla guesta.
3. Guest z `Pro` zachowuje `Pro`, jeśli upgrade'uje bieżące konto.
4. Zwykły account switch nie robi `RevenueCat.logOut()` i nie próbuje magicznie merge'ować zakupów.

## Zasady

- Nie używaj anonimowych `RevenueCat` App User IDs.
- Nie wywołuj `RevenueCat.logOut()` w normalnym flow przełączania kont.
- Przy zmianie principal używaj `logIn(newUserId)`.
- `RevenueCat` ma być źródłem prawdy dla client-side entitlement state.
- Nie przenoś zakupów automatycznie przy switchu konta.
- W debug i release aplikacja ma działać bez crasha także wtedy, gdy klucze `RevenueCat` są puste.

## Krok 1. Zweryfikuj config i klucze

- Upewnij się, że masz uzupełnione:
  - `REVENUECAT_APPLE_API_KEY`
  - `REVENUECAT_GOOGLE_API_KEY`
- Sprawdź:
  - [api_keys.dart](/lib/core/config/api_keys.dart)
  - [app_config.dart](/lib/core/config/app_config.dart)
  - [revenuecat_config.dart](/lib/core/config/revenuecat_config.dart)

## Krok 2. Zmień model subscription z fake na realny

- Przerób:
  - [subscription_data_source.dart](/lib/features/subscription/data/datasources/subscription_data_source.dart)
  - [subscription_repository.dart](/lib/features/subscription/data/repositories/subscription_repository.dart)

- Zaimplementuj w Data Source:
  - konfigurację klienta `RevenueCat`
  - `getCustomerInfo()`
  - listener `CustomerInfo`
  - mapowanie entitlement `pro`
  - `logIn(userId)`
  - `purchasePro()`

- Zostaw jasny fallback:
  - jeśli brak kluczy albo platforma nieobsługiwana -> brak crasha, tylko brak realnych zakupów

## Krok 3. Podepnij `appUserID = Supabase user.id`

- Wykorzystaj aktualny `Supabase user.id` jako jedyny `RevenueCat appUserID`.
- Zrób to także dla anonymous usera.
- Nie twórz dodatkowej warstwy anonymous ID po stronie `RevenueCat`.

## Krok 4. Reaguj na zmianę principal

- Sprawdź:
  - [auth_repository.dart](/lib/features/auth/data/repositories/auth_repository.dart)
  - [session_repository.dart](/lib/app/session/data/repositories/session_repository.dart)
  - [session_navigation_observer.dart](/lib/app/navigation/session_navigation_observer.dart)

- Gdy principal się zmienia:
  - `signed out -> guest`
  - `guest -> registered`
  - `guest -> existing account`
  - `account A -> account B`

  wykonaj właściwe `RevenueCat logIn(newUserId)`.

- Nie rób `logOut()` przed `logIn()`.

## Krok 5. Seed + stream entitlement state

- Zaimplementuj wzorzec:
  - seed z `getCustomerInfo()`
  - aktualizacje z listenera `CustomerInfo`
  - refresh po:
    - purchase
    - restore
    - account switch
    - powrocie aplikacji na foreground

- Nie opieraj całego stanu premium tylko na jednorazowym fetchu.

## Krok 6. Zintegruj purchase flow z aktualnym UI

- Sprawdź:
  - [account_actions_cubit.dart](/lib/app/profile/presentation/cubit/account_actions_cubit.dart)
  - [profile_screen.dart](/lib/features/profiles/presentation/ui/profile_screen.dart)
  - [developer_screen.dart](/lib/app/developer/ui/developer_screen.dart)

- Zastąp fake `Buy Pro` prawdziwym flow zakupu.
- Po sukcesie upewnij się, że:
  - `SessionState` odświeża `isPro`
  - banner guest + `Pro` nadal działa
  - `Home` i `Profile` pokazują nowy stan bez restartu

## Krok 7. Nie zepsuj flow guest -> register

- To jest najważniejszy przypadek.
- Jeśli guest ma `Pro` i robi upgrade bieżącego konta:
  - `user.id` zostaje ten sam
  - `RevenueCat appUserID` zostaje ten sam
  - `Pro` zostaje

- Dodaj to jako obowiązkowy scenariusz do ręcznej weryfikacji przez usera.

## Krok 8. Nie rób automatycznego transferu `Pro` przy account switch

- Jeśli guest z `Pro` wybierze `Log in to existing account`:
  - traktuj to jako switch
  - nie próbuj automatycznie przenosić entitlementów
  - utrzymaj ostrzeżenie w UI

- Jeśli kiedyś aplikacja ma wspierać merge lub transfer zakupów między kontami, zrób to jako osobny, jawny flow produktowy.

## Krok 9. Zaktualizuj ekran debugowy

- W [developer_screen.dart](/lib/app/developer/ui/developer_screen.dart):
  - pokaż, czy `RevenueCat` jest skonfigurowane
  - pokaż aktualne `appUserID`
  - pokaż, czy `isPro` pochodzi już z realnego `RevenueCat`, a nie z fake layer

## Krok 10. Dodaj testy

- Unit testy:
  - `SubscriptionRepository`
  - `AccountActionsCubit`
  - `SessionCubit` / `SessionRepository` dla zmiany `isPro`

- Widget / integration testy:
  - guest -> buy `Pro`
  - guest + `Pro` -> register current account
  - guest + `Pro` -> switch account

## Krok 11. Zweryfikuj końcowo

- Uruchom:
  - `dart format .`
  - `dart run build_runner build --delete-conflicting-outputs`
  - `flutter analyze`
  - `flutter test`

- Zrób commit z jasnym opisem zmian.

## Krok 12. Zaleć userowi zweryfikowanie flow

- Niech przetestuje:
  - guest -> buy `Pro`
  - guest + `Pro` -> register current account (bez utraty `Pro`)
  - guest + `Pro` -> `Log in to existing account` (account switch bez automatycznego transferu `Pro`)
  - `Home` i `Profile` odświeżają stan `Pro` bez restartu aplikacji

## Referencje

- [RevenueCat: Identifying Customers](https://www.revenuecat.com/docs/customers/identifying-customers)
- [RevenueCat: Configuring the SDK](https://www.revenuecat.com/docs/getting-started/configuring-sdk)
- [RevenueCat: CustomerInfo](https://www.revenuecat.com/docs/customers/customer-info)
- [RevenueCat: Restoring Purchases](https://www.revenuecat.com/docs/getting-started/restoring-purchases)
