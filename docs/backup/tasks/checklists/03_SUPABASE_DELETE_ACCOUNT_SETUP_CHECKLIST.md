# Supabase Delete Account Setup Checklist

Aktualizuj ten plik w trakcie pracy.

Statusy:
- `⬜` = `pending`
- `⏳` = `waiting_for_user`
- `✅` = `done`

## Krok 1. Preflight `Supabase MCP`

| Status | Item |
| --- | --- |
| ⬜ | Agent ma działający dostęp do projektu przez `Supabase MCP` |
| ⬜ | Jeśli brak MCP: user dostał instrukcję uruchomienia `docs/tasks/01_INITIALIZE_APP_SETUP.md` |

## Krok 2. Sprawdź aktualny stan repo i projektu

| Status | Item |
| --- | --- |
| ⬜ | Plik `supabase/functions/delete-account/index.ts` istnieje |
| ⬜ | Lokalna funkcja wymaga `Authorization: Bearer <token>` |
| ⬜ | Lokalna funkcja waliduje usera przez token |
| ⬜ | Lokalna funkcja używa `SUPABASE_SERVICE_ROLE_KEY` tylko po stronie funkcji |
| ⬜ | Lokalna funkcja usuwa usera przez `auth.admin.deleteUser(...)` |
| ⬜ | Lokalna funkcja zwraca `401` bez tokena albo przy niepoprawnym tokenie |
| ⬜ | Lokalna funkcja zwraca `500` przy błędzie delete |
| ⬜ | W hostowanym projekcie istnieje Edge Function `delete-account` albo świadomie wykryto jej brak |
| ⬜ | Stan `verify_jwt` dla `delete-account` został sprawdzony |
| ⬜ | Aktualny Flutter flow `Delete account` został sprawdzony |
| ⬜ | Nie wykryto konfliktu destrukcyjnego albo user dostał raport i task został zatrzymany |

## Krok 3. Wdróż lub zaktualizuj Edge Function

| Status | Item |
| --- | --- |
| ⬜ | `delete-account` jest wdrożona i zgodna z repo albo świadomie potwierdzono, że nic nie trzeba wdrażać |
| ⬜ | `verify_jwt` jest włączone dla `delete-account` |
| ⬜ | `SUPABASE_SERVICE_ROLE_KEY` nie trafił do Fluttera |

## Krok 4. Podepnij prawdziwy flow w Flutterze

| Status | Item |
| --- | --- |
| ⬜ | `AuthDataSource.deleteAccount()` istnieje albo został uzupełniony |
| ⬜ | `AuthRepository.deleteAccount()` istnieje albo został uzupełniony |
| ⬜ | `AccountActionsCubit.deleteAccount()` istnieje albo został uzupełniony |
| ⬜ | UI profilu zostało przepięte z setup screena albo placeholdera na docelowy flow |
| ⬜ | UI pokazuje potwierdzenie operacji przed usunięciem konta |
| ⬜ | Po sukcesie wykonywany jest lokalny `signOut()` |
| ⬜ | Po błędzie UI pokazuje błąd inline przez `SelectableText` |
| ⬜ | Jeśli były zmiany w `freezed`, uruchomiono `dart run build_runner build -d` |
| ⬜ | Jeśli były zmiany w ARB, uruchomiono `flutter gen-l10n` |

## Krok 5. Jeśli aplikacja używa Storage, dodaj cleanup plików

| Status | Item |
| --- | --- |
| ⬜ | Jeśli projekt używa `Storage`, cleanup plików usera został dodany przed `deleteUser` |
| ⬜ | Jeśli projekt nie używa `Storage`, ten brak cleanupu został świadomie potwierdzony jako poprawny |

## Krok 6. Zweryfikuj końcowo

| Status | Item |
| --- | --- |
| ⬜ | Przetestowano `Delete account` dla guesta |
| ⬜ | Przetestowano `Delete account` dla zalogowanego usera |
| ⬜ | Po sukcesie user wraca do `Welcome` bez aktywnej sesji |
| ⬜ | Testy `Cubit` zostały zaktualizowane |
| ⬜ | Testy widgetowe zostały zaktualizowane, jeśli UI się zmienił |

## Krok 7. Końcowe potwierdzenie

| Status | Item |
| --- | --- |
| ⬜ | `flutter analyze` uruchomione i przechodzi bez problemów |
| ⬜ | `flutter test` uruchomione i przechodzi bez problemów |
| ⬜ | Checklista została zaktualizowana i wszystkie możliwe pozycje mają status `done` |
