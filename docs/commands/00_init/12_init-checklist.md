# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Sprawdzić poprawność wykonanych kroków z `docs/commands/00_init/`.

# Task

Sprawdź poprawność wszystkich kroków.

# Checklista

## Krok 1. Utworzenie nowego git repository

- Istnieje lokalne git repository

## Krok 2. Utworzenie pliku `.env`

- `.env` istnieje
- `.env` zawiera pole `SUPABASE_PROJECT_ID=`
- `.env` zawiera pole `SUPABASE_ACCOUNT_ACCESS_TOKEN=`
- `.env` zawiera pole `PLATFORM_API_KEY=`
- `.env` zawiera pole `REVENUECAT_IOS_API_KEY=`
- `.env` zawiera pole `REVENUECAT_ANDROID_API_KEY=`
- `.env` zawiera pole `APP_PLATFORM_ID=`
- `.env` zawiera pole `APP_STORE_ID=`

- `.env` zawiera uzupełnione pole `SUPABASE_PROJECT_ID=`
- `.env` zawiera uzupełnione pole `SUPABASE_ACCOUNT_ACCESS_TOKEN=`
- `.env` zawiera uzupełnione pole `PLATFORM_API_KEY=`

## Krok 3. Przygotowanie plików mcp dla zakresu tego projektu.

- istnieje plik `.mcp.json`
- istnieje plik `opencode.json`
- istnieje plik `.codex/config.toml`
- plik `.mcp.json` posiada wartości `SUPABASE_PROJECT_ID` oraz `SUPABASE_ACCOUNT_ACCESS_TOKEN` z `.env`
- plik `opencode.json` posiada wartości `SUPABASE_PROJECT_ID` oraz `SUPABASE_ACCOUNT_ACCESS_TOKEN` z `.env`
- plik `.codex/config.toml` posiada wartości `SUPABASE_PROJECT_ID` oraz `SUPABASE_ACCOUNT_ACCESS_TOKEN` z `.env`

## Krok 4. Sprawdzenie połączenia z Supabase MCP.

- Jesteś w stanie połączyć się z bazą danych Supabase przez MCP

## Krok 5. Przygotowanie pliku `config/api-keys.json`.

- plik `config/api-keys.json` istnieje

## Krok 6. Wypełnienie pliku `config/api-keys.json`.

- plik `config/api-keys.json` posiada uzupełnioną wartość `SUPABASE_URL`
- plik `config/api-keys.json` posiada uzupełnioną wartość `SUPABASE_ANON_KEY`

## Krok 7. Utworzenie pliku `android/key.properties`.

- plik `android/key.properties` istnieje

## Krok 8. Dać userowi instrukcje jak może wygenerować nowy plik `upload-keystore.p12` dla tej aplikacji.

- User dostał instrukcje jak wygenerować plik `upload-keystore.p12`

## Krok 9. User musi przenieść wygenerowany plik do zalecanej ścieżki dla tej aplikacji i uzupełnić path do pliku w `storeFile` w `android/key.properties`.

- plik `android/key.properties` ma wypełnione wszystkie pola, w tym poprawną ścieżkę path `storeFile` dla pliku `upload-keystore.p12`

## Krok 10. Wykonanie konfiguracji `Supabase shared_users` dla tego projektu.

- istnieje tabela `public.shared_users`
- tabela `public.shared_users` spełnia minimalne wymagania template

## Krok 11. Wykonanie konfiguracji `Supabase delete account` dla tego projektu.

- istnieje wdrożona Edge Function `delete-account`
- `Delete account` ma podpięty prawdziwy flow w aplikacji

# Podsumowanie

Poinformuj użytkownika o stanie. Jeżeli czegoś brakuje, spróbuj razem z użytkownikiem naprawić to za pomocą poleceń dostępnych w `docs/commands/00_init/`.

Jeżeli w trakcie tego flow zostały zmienione pliki, upewnij się, że odpowiednie zmiany zostały zapisane w commicie. Pliki z sekretami i pliki objęte `.gitignore` nie powinny trafiać do commita.

Jeżeli wszystko jest okej, zaleć mu przejście do kolejnego etapu jakim jest `/start` poprzez wywołanie polecenia zawartego w `docs/commands/01_start.md`.
