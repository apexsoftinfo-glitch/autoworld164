# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Utworzenie pliku `.env`

# Task

1. Sprawdź istnienie pliku `.env` w głównym katalogu projektu.
2. Jeżeli go nie ma, utwórz go na podstawie `.env.example`
3. Jeżeli jest, upewnij się, że posiada wszelkie klucze z `.env.example`

Gdy skończysz, poinformuj użytkownika o tym co zrobiłeś.

Poproś go o uzupełnienie `SUPABASE_PROJECT_ID`, `SUPABASE_ACCOUNT_ACCESS_TOKEN` i `PLATFORM_API_KEY` oraz opcjonalnie `REVENUECAT_IOS_API_KEY` i `REVENUECAT_ANDROID_API_KEY`.

Gdy odpowie "next", przejdź do wykonania polecenia zawartego w `docs/commands/00_init/03_init-supabase-mcp-setup.md`.
