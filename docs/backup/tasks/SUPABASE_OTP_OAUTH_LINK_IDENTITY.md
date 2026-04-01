# Supabase OTP, OAuth i linkIdentity

Wykonaj te kroki dopiero wtedy, gdy chcesz rozszerzyć auth poza anonymous + email/password.

To jest checklista wykonawcza dla agenta AI z dostępem do kodu i `Supabase` MCP.

## Cel

Masz osiągnąć 3 rzeczy:

1. Dodać istniejący login przez OTP, bez tworzenia nowych userów z `Welcome`.
2. Dodać upgrade bieżącego guesta przez provider linking (`linkIdentity()`).
3. Nie pomylić `account switch` z `upgrade current guest`.

## Zasady

- `Welcome` nadal nie ma klasycznej rejestracji.
- `Welcome` może oferować tylko istniejący login, nigdy tworzenie nowego usera.
- OTP login dla istniejącego konta musi używać `shouldCreateUser: false`.
- Upgrade guesta przez Google/Apple ma używać `linkIdentity()` na aktualnie zalogowanym anonymous userze.
- Nie używaj zwykłego provider sign-in do upgrade current guest.
- Zwykły provider sign-in to login/switch, nie upgrade.

## Krok 1. Rozszerz `AuthDataSource` i `AuthRepository`

- Sprawdź:
  - [auth_data_source.dart](/lib/features/auth/data/datasources/auth_data_source.dart)
  - [auth_repository.dart](/lib/features/auth/data/repositories/auth_repository.dart)

- Dodaj metody dla:
  - `signInWithOtpExistingAccount(...)`
  - `verifyOtpLogin(...)` jeśli flow tego wymaga
  - `signInWithGoogleExistingAccount()` / `signInWithAppleExistingAccount()`
  - `linkGoogleToCurrentUser()`
  - `linkAppleToCurrentUser()`

## Krok 2. OTP dla istniejącego konta

- W login flow OTP ustaw:
  - `shouldCreateUser: false`

- To jest krytyczne.
- Jeśli tego nie ustawisz, `Supabase` może utworzyć nowego usera, a tego nie chcesz z `Welcome`.

## Krok 3. Zróżnicuj dwa flow

- W kodzie i UI utrzymuj rozdział:

1. `Log in to existing account`
   - to jest switch
   - może być email/password
   - może być OTP
   - może być OAuth sign-in

2. `Register / secure current guest account`
   - to jest upgrade current guest
   - email/password przez `updateUser()`
   - provider przez `linkIdentity()`

- Nie łącz tych flow w jedną metodę.

## Krok 4. Provider linking dla guesta

- Jeśli guest chce podpiąć Google / Apple:
  - musi być już zalogowany jako anonymous user
  - uruchom `linkIdentity()` na tym userze

- Nie używaj zwykłego `signInWithOAuth()` do upgrade current guest.
- To byłby login/switch flow, nie linkowanie.

## Krok 5. Obsłuż konflikt linked identity

- Jeśli `linkIdentity()` zwróci błąd typu „ta tożsamość jest już przypięta gdzie indziej”:
  - nie próbuj automatycznego merge
  - pokaż userowi, że to jest istniejące konto
  - skieruj go do flow `Log in to existing account`

## Krok 6. Zintegruj to z UI

- Sprawdź:
  - [welcome_screen.dart](/lib/features/welcome/ui/welcome_screen.dart)
  - [login_screen.dart](/lib/features/auth/presentation/ui/login_screen.dart)
  - [register_screen.dart](/lib/features/auth/presentation/ui/register_screen.dart)
  - [profile_screen.dart](/lib/features/profiles/presentation/ui/profile_screen.dart)

- Zrób tak:
  - `Welcome` -> existing login only
  - `Profile` -> upgrade current guest
  - `Profile` -> account switch z ostrzeżeniem, jeśli guest ma dane lub `Pro`

## Krok 7. Zachowaj poprawny reset nawigacji

- Sprawdź:
  - [session_navigation_observer.dart](/lib/app/navigation/session_navigation_observer.dart)

- Upewnij się, że:
  - OTP login existing account resetuje stack
  - OAuth login existing account resetuje stack
  - signOut resetuje stack
  - delete account resetuje stack
  - upgrade current guest przy tym samym `user.id` nie resetuje stacku

## Krok 8. Jeśli dodajesz Google/Apple, zrób też platform setup

- Jeśli wchodzisz w Google / Apple:
  - dodaj wymagane paczki
  - dodaj konfigurację iOS / Android
  - dodaj redirect URI
  - dodaj provider config w Supabase

- Nie ruszaj natywnych plików, jeśli task nie wymaga jeszcze prawdziwego provider auth.

## Krok 9. Testy

- Unit testy:
  - `AuthRepository`
  - `LoginCubit`
  - `RegisterCubit`

- Widget / integration testy:
  - OTP login existing account nie tworzy nowego usera
  - guest -> link Google / Apple
  - konflikt linked identity -> redirect do login flow
  - account switch z guesta resetuje stack

## Krok 10. Zweryfikuj końcowo

- Uruchom:
  - `dart format .`
  - `dart run build_runner build --delete-conflicting-outputs`
  - `flutter analyze`
  - `flutter test`

- Zrób commit z jasnym opisem zmian.

## Krok 11. Zaleć userowi zweryfikowanie flow

- Niech przetestuje:
  - OTP login existing account nie tworzy nowego usera
  - guest -> link Google / Apple upgrade'uje bieżące konto
  - konflikt linked identity kieruje do flow `Log in to existing account`
  - account switch z guesta resetuje stack, a upgrade current guest przy tym samym `user.id` nie resetuje stacku

## Referencje

- [Supabase Dart: Sign in with OTP](https://supabase.com/docs/reference/dart/auth-signinwithotp)
- [Supabase Dart: Update a user](https://supabase.com/docs/reference/dart/auth-updateuser)
- [Supabase Dart: Link an identity to a user](https://supabase.com/docs/reference/dart/auth-linkidentity)
- [Supabase: Anonymous Sign-Ins](https://supabase.com/docs/guides/auth/auth-anonymous)
