---
description: Home - 5 radykalnie różnych layoutów, wybór jednego
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob, Grep, Task, Skill
---

# /home - Layout Home Screen

Zaprojektuj UKŁAD głównego ekranu: discovery wizji → 5 wireframe'ów → wybór → sprzątanie.

**Skill:** Użyj `.claude/skills/flutter-mobile-design/SKILL.md` dla generowania wariantów

---

## PREREQ: Sprawdź stan projektu

1. Przeczytaj `CLAUDE.md` - sekcja "Stan projektu"
2. Sprawdź status:
   - `/start` musi być `done` (docs/IDEA.md gotowe)
   - Jeśli `/start` nie jest `done` → powiedz: "Najpierw wpisz `/start` aby ustalić pomysł."
3. Sprawdź status `/home`:
   - Jeśli `done` → "Masz już wireframe. Wpisz `/design` aby kontynuować."
   - Jeśli `in-progress: discovery` → kontynuuj od KROKU 2 (plik home-2)
   - Jeśli `in-progress: variants` → kontynuuj od KROKU 3 (plik home-3)
   - Jeśli `in-progress: testing` → kontynuuj od KROKU 4 (plik home-4)
   - Jeśli `not-started` → rozpocznij od KROKU 0

---

## Instrukcja wykonania

Wykonuj kroki **po kolei**. Po ukończeniu każdego → przeczytaj następny plik i wykonaj go.

**⚠️ NIE czytaj wszystkich plików na raz! Czytaj TYLKO bieżący krok.**

| Kolejność | Plik | Co robi |
|-----------|------|---------|
| 0 | `.claude/commands/home/home-0-setup.md` | Rozbuduj CLAUDE.md, sync z platformą |
| 1 | `.claude/commands/home/home-1-discovery.md` | Przeczytaj docs/IDEA.md, discovery wizji layoutu |
| 2 | `.claude/commands/home/home-2-wireframes.md` | 5 fundamentalnie różnych wireframe'ów |
| 3 | `.claude/commands/home/home-3-test.md` | Test, prezentacja, wybór użytkownika |
| 4 | `.claude/commands/home/home-4-finalize.md` | Sprzątanie, zapis, commit, sync |

**Zacznij teraz:** Przeczytaj `.claude/commands/home/home-0-setup.md` i wykonaj go.
