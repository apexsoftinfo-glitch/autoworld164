# Supabase Shared Users Setup

Wykonaj wszystkie kroki.

To jest instrukcja wykonawcza.

## Cel

Doprowadź `public.shared_users` do minimalnej zgodności z template:
- tabela `shared_users`
- relacja 1:1 do `auth.users`
- kolumny `id` i `first_name`
- RLS + policies
- trigger tworzący shell row po utworzeniu usera
- `supabase_realtime` publication

Twoim celem jest doprowadzić checklistę `02` do stanu, w którym wszystkie możliwe pozycje mają status `done`.

## Zasada pracy z checklistą

- Na starcie otwórz:
  - `docs/tasks/checklists/02_SUPABASE_SHARED_USERS_SETUP_CHECKLIST.md`
- Realizuj kroki dokładnie w kolejności `Krok 1 -> Krok 2 -> Krok 3 ...`.
- Nie wykonuj kilku kroków naraz.
- Po każdym kroku zatrzymaj się i sprawdź, czy wolno przejść dalej.
- Najpierw sprawdź stan faktyczny bazy i uzupełnij checklistę.
- Jeśli coś jest już poprawnie skonfigurowane, oznacz to jako `done`.
- Jeśli czekasz na ruch usera (np. brak MCP), oznacz to jako `waiting_for_user`.
- Po każdym kroku zaktualizuj checklistę.
- Przy każdej aktualizacji checklisty zmień emoji statusu w pierwszej kolumnie.
- Używaj spójnie tylko tych statusów emoji: `⬜`, `⏳`, `✅`.

## Krok 1. Preflight `Supabase MCP`

- Najpierw sprawdź, czy masz działający dostęp do projektu przez `Supabase MCP`.
- Jeśli nie masz dostępu do MCP:
  - ustaw odpowiednie pozycje checklisty na `waiting_for_user`
  - zakończ task
  - poinformuj usera, że najpierw trzeba wykonać:
    - `docs/tasks/01_INITIALIZE_APP_SETUP.md`

- Po zakończeniu kroku 1 zaktualizuj checklistę.

## Krok 2. Sprawdź aktualny stan bazy

- Zweryfikuj osobno:
  - tabela `public.shared_users`
  - kolumny wymagane przez kod Flutter:
    - `id`
    - `first_name`
  - relacja 1:1 `shared_users.id -> auth.users.id`
  - RLS na `public.shared_users`
  - trigger `on_auth_user_created`
  - policies:
    - `shared_users_select_own`
    - `shared_users_insert_own`
    - `shared_users_update_own`
  - obecność `public.shared_users` w publikacji `supabase_realtime`
  - czy tabela ma już dane

- Jeśli `shared_users` już istnieje i ma dodatkowe kolumny, to jest OK.
- Nie próbuj usuwać dodatkowych kolumn ani czyścić danych.
- Jeśli naprawa wymagałaby destrukcyjnej zmiany schemy albo kasowania danych, zatrzymaj task, ustaw checklistę na `waiting_for_user` i opisz konflikt userowi.

- Po zakończeniu kroku 2 zaktualizuj checklistę.

## Krok 3. Zastosuj tylko brakujące elementy

- Nie rób ślepo wszystkich migracji, jeśli część rzeczy już jest poprawna.
- Użyj gotowych plików z repo:
  - `supabase/migrations/0001_shared_users_table.sql`
  - `supabase/migrations/0002_shared_users_triggers.sql`
  - `supabase/migrations/0003_shared_users_rls_policies.sql`
  - `supabase/migrations/0004_shared_users_realtime.sql`
- Jeśli brakuje tylko części konfiguracji, zastosuj tylko potrzebne pliki.
- Jeśli wszystko jest już poprawne, nic nie migruj.
- Nie dotykaj tabeli `profiles`.

- Po zakończeniu kroku 3 zaktualizuj checklistę.

## Krok 4. Zweryfikuj końcowo

- Po zmianach ponownie sprawdź wszystkie elementy z kroku 2.
- Sprawdź zgodność z kodem Fluttera:
  - [shared_user_model.dart](/lib/features/profiles/models/shared_user_model.dart)
  - [shared_user_data_source.dart](/lib/features/profiles/data/datasources/shared_user_data_source.dart)
  - [shared_user_repository.dart](/lib/features/profiles/data/repositories/shared_user_repository.dart)

- Po zakończeniu kroku 4 zaktualizuj checklistę.

## Krok 5. Zakończ pracę

- Uruchom:
  - `flutter analyze`
  - `flutter test`
- Zaktualizuj checklistę `02` i upewnij się, że wszystkie możliwe pozycje mają status `done`.
- Jeśli coś ma status `pending` albo `waiting_for_user`, nie zamykaj taska jako zakończonego.
- Jeśli zrobiłeś zmiany w repo, zrób commit z jasnym opisem, np.:
  - `supabase: align shared_users schema with template`
- Jeśli zaktualizowałeś checklistę albo inne pliki repo, commit jest obowiązkowy przed zamknięciem taska.
- Na końcu wyraźnie poinformuj usera:
  - że task `02` został ukończony
  - że commit został wykonany
  - użyj w tej finalnej wiadomości `🎉🎉🎉`
