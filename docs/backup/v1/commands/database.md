---
description: Supabase single-user (bez auth)
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob, Grep, Task, Skill, WebSearch, mcp__supabase__apply_migration, mcp__supabase__execute_sql, mcp__supabase__list_tables, mcp__supabase__get_project_url, mcp__supabase__get_publishable_keys, mcp__supabase__generate_typescript_types, mcp__supabase__get_advisors
---

# /database - Supabase Single-User

Podłącz Supabase jako backend (bez auth - używamy hardcoded dev user).

**Skill:** `.claude/skills/flutter-backend/SKILL.md`

## Dwa główne cele /database:

1. **Tabele w Supabase** — migracje, RLS, realtime
2. **SupabaseDataSource** — zamień FakeDataSource na prawdziwy backend

> **/database NIE jest ukończony dopóki user nie potwierdzi "ok" po testach CRUD!**

---

## PREREQ: Sprawdź stan projektu

1. Przeczytaj `CLAUDE.md` - sekcja "Stan projektu"
2. Sprawdź status:
   - `/onboarding` musi być `done`
   - Jeśli `/onboarding` nie jest `done` → "Najpierw wpisz `/onboarding` aby zbudować onboarding."
3. Sprawdź status `/database`:
   - Jeśli `done` → "Database gotowa. Wpisz `/auth` aby kontynuować."
   - Jeśli `ready-to-test` → "Database gotowa do przetestowania. Uruchom `flutter run`, przetestuj CRUD i napisz 'ok'."
   - Jeśli `in-progress: [substatus]` → kontynuuj od tego miejsca
   - Jeśli `not-started` → rozpocznij od KROKU 1

---

## Instrukcja wykonania

Wykonuj kroki **po kolei**. Po ukończeniu każdego → przeczytaj następny plik i wykonaj go.

**⚠️ NIE czytaj wszystkich plików na raz! Czytaj TYLKO bieżący krok.**

| Kolejność | Plik | Co robi |
|-----------|------|---------|
| 1 | `.claude/commands/database/database-1-supabase-mcp.md` | Rozbuduj CLAUDE.md + sprawdź/skonfiguruj Supabase MCP |
| 2 | `.claude/commands/database/database-2-config.md` | Konfiguracja api-keys.json |
| 3 | `.claude/commands/database/database-3-prefix.md` | Weryfikacja prefixu i istniejących tabel |
| 4 | `.claude/commands/database/database-4-tables.md` | Tworzenie tabel w Supabase |
| 5 | `.claude/commands/database/database-5-devuser-datasource.md` | Hardcoded dev user + SupabaseDataSource |
| 6 | `.claude/commands/database/database-6-rls.md` | RLS Policies (tymczasowe) |
| 7 | `.claude/commands/database/database-7-test-finalize.md` | Smoke test, feedback usera, finalizacja |

**Zacznij teraz:** Przeczytaj `.claude/commands/database/database-1-supabase-mcp.md` i wykonaj go.
