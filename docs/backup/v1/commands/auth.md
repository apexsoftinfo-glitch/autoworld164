---
description: Login/Register, full SessionRepository, offline mode
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob, Grep, Task, Skill, mcp__supabase__apply_migration, mcp__supabase__execute_sql, mcp__supabase__list_tables, mcp__supabase__get_advisors
---

# /auth - Autentykacja i SessionRepository

Zaimplementuj prawdziwą autentykację i pełny SessionRepository (4/4 źródła, w tym pełna integracja RevenueCat z logIn/logOut).

**Skille:** `.claude/skills/flutter-backend/SKILL.md`, `.claude/skills/supabase-auth/SKILL.md`

> 📖 **PRZED ROZPOCZĘCIEM** przeczytaj:
> - `docs/SESSION_ARCHITECTURE.md` — pełna architektura sesji
> - `.claude/skills/supabase-auth/SKILL.md` — wzorce kodu

---

## PREREQ: Sprawdź stan projektu

1. Przeczytaj `CLAUDE.md` - sekcja "Stan projektu"
2. Sprawdź status:
   - `/database` musi być `done`
   - Jeśli `/database` nie jest `done` → "Najpierw wpisz `/database` aby podłączyć Supabase."
3. Sprawdź status `/auth`:
   - Jeśli `done` → "Auth gotowy. Wpisz `/limits` aby kontynuować."
   - Jeśli `ready-to-test` → "Auth gotowy do przetestowania. Uruchom `flutter run`, przetestuj flow logowania i napisz 'ok'."
   - Jeśli `in-progress: [substatus]` → kontynuuj od tego miejsca
   - Jeśli `not-started` → rozpocznij od KROKU 0

---

## Synchronizacja z platformą

Przed rozpoczęciem:
1. Sprawdź `.env` → `PLATFORM_API_KEY`. Jeśli brak lub pusty → poproś usera:
   "Potrzebuję API Key z platformy. Wejdź na platformę → Profil → skopiuj API Key i wklej tutaj."
   Po otrzymaniu → zapisz do `.env` i zwaliduj (GET /user). Jeśli 401 → poproś ponownie.
2. Sprawdź w CLAUDE.md:
   - **Platform App ID** - ID tej aplikacji na platformie
   - **Step ID dla tego kroku** - UUID z mapowania w CLAUDE.md
3. Jeśli brakuje Platform App ID lub Step ID → "Najpierw wpisz `/start` aby połączyć z platformą."

> **UWAGA:** Sprawdzanie API Key dotyczy KAŻDEJ komendy, nie tylko /start. Klucz może wygasnąć lub zostać zregenerowany w dowolnym momencie.

---

## Instrukcja wykonania

Wykonuj kroki **po kolei**. Po ukończeniu każdego → przeczytaj następny plik i wykonaj go.

**⚠️ NIE czytaj wszystkich plików na raz! Czytaj TYLKO bieżący krok.**

| Kolejność | Plik | Co robi |
|-----------|------|---------|
| 1 | `.claude/commands/auth/auth-1-setup.md` | Konfiguracja Supabase Dashboard + CLAUDE.md |
| 2 | `.claude/commands/auth/auth-2-screens.md` | Auth Screens + SupabaseAuthDataSource |
| 3 | `.claude/commands/auth/auth-3-appgate.md` | Welcome Screen, AppGate, Profiles table |
| 4 | `.claude/commands/auth/auth-4-migration.md` | Migracja gościa, hardcoded IDs, Settings |
| 5 | `.claude/commands/auth/auth-5-session.md` | SessionRepositoryImpl + RC evolution |
| 6 | `.claude/commands/auth/auth-6-sync.md` | RC logIn/logOut sync, lifecycle, tier |
| 7 | `.claude/commands/auth/auth-7-test.md` | Smoke test, feedback, finalizacja |

**Zacznij teraz:** Przeczytaj `.claude/commands/auth/auth-1-setup.md` i wykonaj go.
