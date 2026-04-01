---
description: Reszta ekranów + Settings (core) + shared components
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob, Grep, Task, Skill
---

# /screens - Pozostałe ekrany

Zbuduj pozostałe ekrany aplikacji w stylu Home Screen + Settings core + shared components.

**Skille:** `.claude/skills/flutter-mobile-design/SKILL.md`, `.claude/skills/flutter-ui/SKILL.md`

---

## PREREQ: Sprawdź stan projektu

1. Przeczytaj `CLAUDE.md` - sekcja "Stan projektu"
2. Sprawdź status:
   - `/design` musi być `done` (design zamrożony)
   - Jeśli `/design` nie jest `done` → "Najpierw wpisz `/home` i `/design` aby zaprojektować główny ekran."
3. Sprawdź status `/screens`:
   - Jeśli `done` → "Ekrany gotowe. Wpisz `/onboarding` aby kontynuować."
   - Jeśli `ready-to-test` → "Ekrany są gotowe do przetestowania. Uruchom `flutter run`, przetestuj nawigację i napisz 'ok'."
   - Jeśli `in-progress: [substatus]` → kontynuuj od tego miejsca
   - Jeśli `not-started` → rozpocznij od KROKU 1

---

## Instrukcja wykonania

Wykonuj kroki **po kolei**. Po ukończeniu każdego → przeczytaj następny plik i wykonaj go.

**⚠️ NIE czytaj wszystkich plików na raz! Czytaj TYLKO bieżący krok.**

| Kolejność | Plik | Co robi |
|-----------|------|---------|
| 1 | `.claude/commands/screens/screens-1-inventory.md` | Sync z platformą, inwentaryzacja ekranów |
| 2 | `.claude/commands/screens/screens-2-detail.md` | Detail Screen |
| 3 | `.claude/commands/screens/screens-3-add-edit.md` | Add/Edit Screen z formularzem |
| 4 | `.claude/commands/screens/screens-4-settings.md` | ThemeNotifier + Settings Screen (core) |
| 5 | `.claude/commands/screens/screens-5-shared.md` | Shared components + refaktor |
| 6 | `.claude/commands/screens/screens-6-navigation.md` | Nawigacja między ekranami |
| 7 | `.claude/commands/screens/screens-7-finalize.md` | Test, feedback, commit, finalizacja |

**Zacznij teraz:** Przeczytaj `.claude/commands/screens/screens-1-inventory.md` i wykonaj go.
