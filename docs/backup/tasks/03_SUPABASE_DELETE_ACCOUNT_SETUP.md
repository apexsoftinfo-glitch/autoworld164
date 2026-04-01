# Supabase Delete Account Setup

Wykonaj wszystkie te kroki.

To nie jest brainstorming. To jest instrukcja wykonawcza.

## Cel

Doprowadź `Delete account` do stanu zgodnego z template:
- Edge Function `delete-account` wdrożona w `Supabase`
- JWT verification włączone
- brak `service_role` w aplikacji Flutter
- prawdziwy flow usuwania konta podpięty pod przycisk `Usuń konto`
- po sukcesie brak sesji i powrót do `Welcome`

Twoim celem jest doprowadzić checklistę `03` do stanu, w którym wszystkie możliwe pozycje mają status `done`.

## Zasada pracy z checklistą

- Na starcie otwórz:
  - `docs/tasks/checklists/03_SUPABASE_DELETE_ACCOUNT_SETUP_CHECKLIST.md`
- Realizuj kroki dokładnie w kolejności `Krok 1 -> Krok 2 -> Krok 3 ...`.
- Nie wykonuj kilku kroków naraz.
- Po każdym kroku zatrzymaj się i sprawdź, czy wolno przejść dalej.
- Najpierw sprawdź stan faktyczny repo i projektu `Supabase`.
- Jeśli coś już jest poprawnie skonfigurowane, oznacz to jako `done`.
- Jeśli czekasz na ruch usera albo nie masz dostępu do `Supabase MCP`, oznacz to jako `waiting_for_user`.
- Po każdym kroku zaktualizuj checklistę.
- Przy każdej aktualizacji checklisty zmień emoji statusu w pierwszej kolumnie.
- Używaj spójnie tylko tych statusów emoji: `⬜`, `⏳`, `✅`.

## Gotowe pliki w repo

- Edge Function jest już przygotowana:
  - `supabase/functions/delete-account/index.ts`

Nie twórz nowej funkcji od zera, jeśli ta już spełnia wymagania.

## Krok 1. Preflight `Supabase MCP`

- Najpierw sprawdź, czy masz działający dostęp do projektu przez `Supabase MCP`.
- Jeśli nie masz dostępu do MCP:
  - ustaw odpowiednie pozycje checklisty na `waiting_for_user`
  - zakończ task
  - poinformuj usera, że najpierw trzeba wykonać:
    - `docs/tasks/01_INITIALIZE_APP_SETUP.md`

- Po zakończeniu kroku 1 zaktualizuj checklistę.

## Krok 2. Sprawdź aktualny stan repo i projektu

- Zweryfikuj osobno:
  - czy istnieje plik `supabase/functions/delete-account/index.ts`
  - czy funkcja lokalna:
    - wymaga `Authorization: Bearer <token>`
    - waliduje usera przez token
    - używa `SUPABASE_SERVICE_ROLE_KEY` tylko po stronie funkcji
    - usuwa usera przez `auth.admin.deleteUser(...)`
    - zwraca `401` bez tokena lub przy niepoprawnym tokenie
    - zwraca `500` przy błędzie delete
  - czy w hostowanym projekcie istnieje Edge Function `delete-account`
  - czy wdrożona funkcja ma włączone `verify_jwt`
  - czy Flutter nadal nie ma prawdziwego flow `Delete account`
  - czy obecny UI prowadzi do setup screen albo placeholdera zamiast realnego delete

- Jeśli funkcja już istnieje i ma dodatkowy bezpieczny cleanup, to jest OK.
- Nie rób destrukcyjnych zmian w danych userów tylko po to, żeby "wyczyścić" środowisko testowe.
- Jeśli wykryjesz konflikt, który wymagałby niekompatybilnej zmiany istniejącego kontraktu produkcyjnego, zatrzymaj task, ustaw checklistę na `waiting_for_user` i opisz konflikt userowi.

- Po zakończeniu kroku 2 zaktualizuj checklistę.

## Krok 3. Wdróż lub zaktualizuj Edge Function

- Użyj `Supabase MCP`, nie lokalnego `supabase` CLI.
- Wdróż gotową funkcję `delete-account` przez `Supabase MCP`.
- Użyj pliku:
  - `supabase/functions/delete-account/index.ts`
- Włącz weryfikację JWT.
- Nie wyłączaj JWT verification.
- Nie przenoś `SUPABASE_SERVICE_ROLE_KEY` do Fluttera.
- Jeśli funkcja jest już poprawnie wdrożona i zgodna z repo, nic nie wdrażaj ponownie.

- Po zakończeniu kroku 3 zaktualizuj checklistę.

## Krok 4. Podepnij prawdziwy flow w Flutterze

- Template już zawiera przygotowaną warstwę:
  - `AuthDataSource.deleteAccount()`
  - `AuthRepository.deleteAccount()`
  - `AccountActionsCubit.deleteAccount()`
- Najpierw zweryfikuj te elementy.
- Jeśli któryś z nich jest niekompletny, uzupełnij tylko brakujący fragment.

- Rozszerz:
  - [profile_screen.dart](/lib/features/profiles/presentation/ui/profile_screen.dart)
  - [auth_data_source.dart](/lib/features/auth/data/datasources/auth_data_source.dart)
  - [auth_repository.dart](/lib/features/auth/data/repositories/auth_repository.dart)
  - [account_actions_cubit.dart](/lib/app/profile/presentation/cubit/account_actions_cubit.dart)

- Zrób to tak:
  1. Zweryfikuj, że `AuthDataSource.deleteAccount()` woła Edge Function `delete-account`.
  2. Zweryfikuj, że `AuthRepository.deleteAccount()` deleguje i nie połyka błędów.
  3. Zweryfikuj, że `AccountActionsCubit.deleteAccount()` emituje tylko `loading/success/errorKey`.
  4. Zastąp setup screen albo placeholder prawdziwym flow `Delete account` w profilu.
  5. Dodaj potwierdzenie operacji przed usunięciem konta.
  6. Podczas usuwania konto jest w stanie `loading`, interakcje są zablokowane i widok nie zamyka się przed sukcesem.
  7. Po sukcesie wykonaj lokalny `signOut()`, zamknij widok i pokaż success `SnackBar`.
  8. Po błędzie zostaw widok otwarty i pokaż błąd inline przez `SelectableText`.

- Nie zapisuj gotowego tekstu błędu w `Cubit`.
- Nie pokazuj raw error userowi.
- Jeśli dojdą zmiany w `freezed`, uruchom:
  - `dart run build_runner build -d`
- Jeśli dojdą zmiany w ARB, uruchom:
  - `flutter gen-l10n`

- Po zakończeniu kroku 4 zaktualizuj checklistę.

## Krok 5. Jeśli aplikacja używa Storage, dodaj cleanup plików

- Jeśli ten projekt przechowuje pliki usera w `Supabase Storage`, rozszerz `delete-account`.
- Najpierw listuj obiekty usera po prefiksie `userId`, potem je usuwaj, a dopiero na końcu wykonuj `deleteUser`.
- Jeśli ten projekt nie używa `Storage` do danych usera, świadomie oznacz ten krok jako niepotrzebny i nie dodawaj sztucznego kodu.

- Po zakończeniu kroku 5 zaktualizuj checklistę.

## Krok 6. Zweryfikuj końcowo

- Przetestuj co najmniej:
  - `Delete account` dla guesta
  - `Delete account` dla zalogowanego usera
  - po sukcesie brak sesji i powrót do `Welcome`
- Zaktualizuj testy:
  - `Cubit` przy użyciu `bloc_test`
  - mocki przy użyciu `mocktail`
  - widget testy dla profilu, jeśli UI się zmienił

- Po zakończeniu kroku 6 zaktualizuj checklistę.

## Krok 7. Zakończ pracę

- Uruchom:
  - `flutter analyze`
  - `flutter test`
- Zaktualizuj checklistę `03` i upewnij się, że wszystkie możliwe pozycje mają status `done`.
- Jeśli coś ma status `pending` albo `waiting_for_user`, nie zamykaj taska jako zakończonego.
- Jeśli zrobiłeś zmiany w repo, zrób commit z jasnym opisem, np.:
  - `supabase: wire delete-account flow`
- Jeśli zaktualizowałeś checklistę albo inne pliki repo, commit jest obowiązkowy przed zamknięciem taska.
- Na końcu wyraźnie poinformuj usera:
  - że task `03` został ukończony
  - że commit został wykonany
