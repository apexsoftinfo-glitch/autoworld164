---
description: Design - 5 radykalnie różnych stylów, wybór jednego
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob, Grep, Task, Skill
---

# /design - Styl Home Screen

Zaprojektuj STYL głównego ekranu: discovery wizji → 5 designów → wybór → finalizacja.

**Skill:** Użyj `.claude/skills/flutter-mobile-design/SKILL.md` dla generowania wariantów

---

## PREREQ: Sprawdź stan projektu

1. Przeczytaj `CLAUDE.md` - sekcja "Stan projektu"
2. Sprawdź status:
   - `/home` musi być `done` (layout wybrany)
   - Jeśli `/home` nie jest `done` → powiedz: "Najpierw wpisz `/home` aby wybrać layout."
3. Sprawdź status `/design`:
   - Jeśli `done` → "Masz już design. Wpisz `/screens` aby kontynuować."
   - Jeśli `ready-to-test` → "Design gotowy do testu. Uruchom `flutter run` i napisz 'ok'."
   - Jeśli `in-progress: discovery` → kontynuuj od KROKU 2 (design-2)
   - Jeśli `in-progress: variants` → kontynuuj od KROKU 3 (design-3)
   - Jeśli `in-progress: testing` → kontynuuj od KROKU 4 (design-4)
   - Jeśli `not-started` → rozpocznij od KROKU 1

---

## Instrukcja wykonania

Wykonuj kroki **po kolei**. Po ukończeniu każdego → przeczytaj następny plik i wykonaj go.

**NIE czytaj wszystkich plików na raz! Czytaj TYLKO bieżący krok.**

| Kolejność | Plik | Co robi |
|-----------|------|---------|
| 1 | `.claude/commands/design/design-1-prep.md` | Synchronizacja, przygotowanie, CLAUDE.md |
| 2 | `.claude/commands/design/design-2-discovery.md` | Discovery wizji stylu z userem |
| 3 | `.claude/commands/design/design-3-variants.md` | 5 radykalnie różnych designów |
| 4 | `.claude/commands/design/design-4-test.md` | Test, wybór i finalizacja |
| 5 | `.claude/commands/design/design-5-finalize.md` | Sprzątanie, tokeny, commit, status |

**Zacznij teraz:** Przeczytaj `.claude/commands/design/design-1-prep.md` i wykonaj go.
