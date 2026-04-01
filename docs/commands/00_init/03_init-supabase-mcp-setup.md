# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Przygotowanie plików mcp dla zakresu tego projektu.

# Task

1. Sprawdź czy istnieją pliki: `.mcp.json`, `opencode.json`, `.codex/config.toml`.
2. Jeżeli nie, utwórz je na podstawie: `.mcp.example.json`, `opencode.example.json`, `.codex/config.example.toml`.
3. Jeżeli istniały, sprawdź ich zawartość i upewnij się, że zawierają w sobie strukturę dla `supabase mcp`.
4. WAŻNE: We wszystkich trzech plikach podmień klucze `SUPABASE_PROJECT_ID` oraz `SUPABASE_ACCOUNT_ACCESS_TOKEN` na wartości podane w .env.

Gdy skończysz, poinformuj użytkownika o tym co zrobiłeś.

Poproś go o zrestartowanie Waszej sesji.

Gdy odpowie "next", przejdź do wykonania polecenia zawartego w `docs/commands/00_init/04_init-supabase-mcp-check.md`.

