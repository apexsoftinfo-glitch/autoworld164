# Initialize App Setup Checklist

Aktualizuj ten plik w trakcie pracy.

Statusy:
- `⬜` = `pending`
- `⏳` = `waiting_for_user`
- `✅` = `done`

## Krok 1. Utwórz `.env`

| Status | Item |
| --- | --- |
| ⬜ | `.env` istnieje |
| ⬜ | `.env` zawiera `SUPABASE_PROJECT_ID=` |
| ⬜ | `.env` zawiera `SUPABASE_ACCOUNT_ACCESS_TOKEN=` |
| ⬜ | `.env` zawiera `PLATFORM_API_KEY=` |
| ⬜ | `.env` zawiera `APP_PLATFORM_ID=` |

## Krok 2. Przygotuj placeholdery pod Supabase MCP

| Status | Item |
| --- | --- |
| ⬜ | `.codex/config.toml` istnieje z placeholderami MCP |
| ⬜ | `.mcp.json` istnieje z placeholderami MCP |
| ⬜ | `opencode.json` istnieje z placeholderami MCP |

## Krok 3. Poproś usera o uzupełnienie `.env`

| Status | Item |
| --- | --- |
| ⏳ | `SUPABASE_PROJECT_ID` zostało uzupełnione w `.env` |
| ⏳ | `SUPABASE_ACCOUNT_ACCESS_TOKEN` został uzupełniony w `.env` |
| ⏳ | `PLATFORM_API_KEY` został uzupełniony w `.env` |

## Krok 4. Zaktualizuj pliki MCP po uzupełnieniu `.env`

| Status | Item |
| --- | --- |
| ⬜ | `.codex/config.toml` ma już prawdziwe wartości zamiast placeholderów |
| ⬜ | `.mcp.json` ma już prawdziwe wartości zamiast placeholderów |
| ⬜ | `opencode.json` ma już prawdziwe wartości zamiast placeholderów |

## Krok 5. Wymuś restart agenta AI

| Status | Item |
| --- | --- |
| ⬜ | User dostał informację, że musi zrestartować agenta AI albo rozpocząć nową sesję |
| ⬜ | Agent zostawił userowi komendę resume albo jasny fallback do powrotu od kroku 6 |
| ⏳ | Agent AI został uruchomiony ponownie po konfiguracji MCP |

## Krok 6. Po restarcie sprawdź, czy `Supabase MCP` działa

| Status | Item |
| --- | --- |
| ⏳ | Po restarcie agent ma działający dostęp do projektu przez `Supabase MCP` |
| ⬜ | Agent potrafi odczytać URL projektu `Supabase` |
| ⬜ | Agent potrafi odczytać klucz `anon` albo aktywny klucz publishable projektu |

## Krok 7. Uzupełnij `config/api-keys.json` z `Supabase MCP`

| Status | Item |
| --- | --- |
| ⬜ | `config/api-keys.json` istnieje i ma poprawny template |
| ⬜ | `SUPABASE_URL` zostało wpisane do `config/api-keys.json` |
| ⬜ | `SUPABASE_ANON_KEY` zostało wpisane do `config/api-keys.json` |
| ⬜ | Klucze `RevenueCat` pozostały puste |

## Krok 8. Utwórz placeholder `android/key.properties`

| Status | Item |
| --- | --- |
| ⬜ | `android/key.properties` istnieje i ma placeholder odpowiedni dla systemu usera |

## Krok 9. Poproś usera o wygenerowanie Android upload keystore

| Status | Item |
| --- | --- |
| ⬜ | User dostał komendę do wygenerowania Android upload keystore |
| ⬜ | User dostał zalecaną ścieżkę docelową dla pliku keystore |
| ⬜ | User dostał instrukcję samodzielnego uzupełnienia `android/key.properties` |
| ⏳ | User potwierdził, że wygenerował plik, przeniósł go i uzupełnił `android/key.properties` |
| ⬜ | `android/key.properties` ma już prawdziwe dane zamiast placeholdera |

## Krok 10. Końcowe potwierdzenie

| Status | Item |
| --- | --- |
| ⬜ | Stan faktyczny plików został sprawdzony, nie tylko statusy w checkliście |
| ⬜ | Checklista została zaktualizowana i wszystkie możliwe kroki taska są zakończone |
