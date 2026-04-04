---
description: Cubity + Repo + FakeDataSource + testy
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob, Grep, Task, Skill
---

# /logic - Architektura i logika biznesowa

Zbuduj warstwę logiki: modele, cubity, repozytoria, FakeDataSource i testy.

**Skill:** `.claude/skills/flutter-logic/SKILL.md`

> **Nazwy domenowe:** Zastąp `{Entity}` nazwą z docs/IDEA.md (np. Task, Note, Entry).
> Przykłady: `{Entity}Model`, `{Entity}Repository`, `{Entities}Cubit`, `{Entity}DataSource`

---

## PREREQ: Sprawdź stan projektu

1. Przeczytaj `CLAUDE.md` - sekcja "Stan projektu"
2. Sprawdź status:
   - `/screens` musi być `done`
   - Jeśli `/screens` nie jest `done` → "Najpierw wpisz `/screens` aby zbudować ekrany."
3. Sprawdź status `/logic`:
   - Jeśli `done` → "Logika gotowa. Wpisz `/onboarding` aby kontynuować."
   - Jeśli `ready-to-test` → "Logika jest gotowa do przetestowania. Uruchom `flutter test`, potem `flutter run` i przetestuj CRUD. Napisz 'ok' gdy działa."
   - Jeśli `in-progress: [substatus]` → kontynuuj od tego miejsca
   - Jeśli `not-started` → rozpocznij od KROKU 1

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
| 1 | `.claude/commands/logic/logic-1-setup.md` | Rozbuduj CLAUDE.md + architektura referencyjna |
| 2 | `.claude/commands/logic/logic-2-planning.md` | Planowanie architektury, model danych, schemat DB |
| 3 | `.claude/commands/logic/logic-3-models.md` | Modele freezed |
| 4 | `.claude/commands/logic/logic-4-datasource.md` | FakeDataSource (stream-first) |
| 5 | `.claude/commands/logic/logic-5-repository.md` | Repository (Either error handling) |
| 6 | `.claude/commands/logic/logic-6-cubits.md` | Cubity ze stream subscriptions |
| 7 | `.claude/commands/logic/logic-7-tests.md` | Testy cubitów |
| 8 | `.claude/commands/logic/logic-8-wiring.md` | Podpięcie UI + DI + ThemeCubit |
| 9 | `.claude/commands/logic/logic-9-verify.md` | Weryfikacja + Test & Feedback |
| 10 | `.claude/commands/logic/logic-10-finalize.md` | Finalizacja, commit, reguły, checklisty |

**Zacznij teraz:** Przeczytaj `.claude/commands/logic/logic-1-setup.md` i wykonaj go.
