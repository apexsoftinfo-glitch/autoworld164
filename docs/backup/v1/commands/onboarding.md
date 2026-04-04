---
description: Welcome + Guided Onboarding od zera
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob, Grep, Task, Skill
---

# /onboarding - Welcome + Guided Onboarding

Zbuduj Welcome screen i 8-stronicowy Guided Onboarding.

**Skille:** `.claude/skills/guided-onboarding/SKILL.md`, `.claude/skills/flutter-mobile-design/SKILL.md`

---

## PREREQ: Sprawdź stan projektu

1. Przeczytaj `CLAUDE.md` - sekcja "Stan projektu"
2. Sprawdź status:
   - `/logic` musi być `done`
   - Jeśli `/logic` nie jest `done` → "Najpierw wpisz `/logic` aby zbudować warstwę logiki (cubity, repos)."
3. Sprawdź status `/onboarding`:
   - Jeśli `done` → "Onboarding gotowy. Wpisz `/database` aby kontynuować."
   - Jeśli `ready-to-test` → "Onboarding jest gotowy do przetestowania. Uruchom `flutter run`, przetestuj Welcome→Guided Onboarding→Home i napisz 'ok'."
   - Jeśli `in-progress: [substatus]` → kontynuuj od tego miejsca
   - Jeśli `not-started` → rozpocznij od KROKU 0

---

## Instrukcja wykonania

Wykonuj kroki **po kolei**. Po ukończeniu każdego → przeczytaj następny plik i wykonaj go.

**⚠️ NIE czytaj wszystkich plików na raz! Czytaj TYLKO bieżący krok.**

| Kolejność | Plik | Co robi |
|-----------|------|---------|
| 0 | `.claude/commands/onboarding/onboarding-0-claudemd.md` | Rozbuduj CLAUDE.md (Flow Contract, EntryPoint Policy) |
| 1 | `.claude/commands/onboarding/onboarding-1-preparation.md` | Przeczytaj docs/IDEA.md, Design System, skill |
| 2 | `.claude/commands/onboarding/onboarding-2-welcome.md` | Welcome Screen (logo + animacja + 2 przyciski) |
| 3 | `.claude/commands/onboarding/onboarding-3-guided.md` | Guided Onboarding (7 stron PageView + cubit) |
| 4 | `.claude/commands/onboarding/onboarding-4-navigation.md` | Podłączenie Welcome → Guided Onboarding → Home |
| 5 | `.claude/commands/onboarding/onboarding-5-debug.md` | Debug button na Home + ready-to-test |
| 6 | `.claude/commands/onboarding/onboarding-6-test.md` | Test & Feedback (OBOWIĄZKOWE!) |
| 7 | `.claude/commands/onboarding/onboarding-7-finalize.md` | AppGate, commit, sync, zapowiedź /database |

**Zacznij teraz:** Przeczytaj `.claude/commands/onboarding/onboarding-0-claudemd.md` i wykonaj go.
