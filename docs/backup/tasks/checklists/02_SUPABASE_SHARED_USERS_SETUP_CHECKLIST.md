# Supabase Shared Users Setup Checklist

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

## Krok 2. Sprawdź aktualny stan bazy

| Status | Item |
| --- | --- |
| ⬜ | Tabela `public.shared_users` istnieje |
| ⬜ | Kolumna `id` istnieje |
| ⬜ | Kolumna `first_name` istnieje |
| ⬜ | Relacja `shared_users.id -> auth.users.id` istnieje |
| ⬜ | RLS jest włączone dla `public.shared_users` |
| ⬜ | Trigger `on_auth_user_created` istnieje |
| ⬜ | Policy `shared_users_select_own` istnieje |
| ⬜ | Policy `shared_users_insert_own` istnieje |
| ⬜ | Policy `shared_users_update_own` istnieje |
| ⬜ | `public.shared_users` jest dodane do publikacji `supabase_realtime` |
| ⬜ | Brak dodatkowych kolumn albo dodatkowe kolumny zostały uznane za akceptowalne |
| ⬜ | Nie wykryto konfliktu destrukcyjnego albo user dostał raport i task został zatrzymany |

## Krok 3. Zastosuj tylko brakujące elementy

| Status | Item |
| --- | --- |
| ⬜ | Wszystkie brakujące elementy zostały uzupełnione w bazie |
| ⬜ | Jeśli nic nie brakowało, stan bazy został świadomie potwierdzony jako gotowy |

## Krok 4. Zweryfikuj końcowo

| Status | Item |
| --- | --- |
| ⬜ | Po zmianach ponownie sprawdzono każdy element z kroku 2 |
| ⬜ | Schemat bazy jest zgodny z mapowaniem w kodzie Fluttera |

## Krok 5. Końcowe potwierdzenie

| Status | Item |
| --- | --- |
| ⬜ | `flutter analyze` uruchomione i przechodzi bez problemów |
| ⬜ | `flutter test` uruchomione i przechodzi bez problemów |
| ⬜ | Checklista została zaktualizowana i wszystkie możliwe pozycje mają status `done` |
