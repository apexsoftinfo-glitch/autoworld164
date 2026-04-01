---
description: Discovery + IDEA.md - pierwszy krok w tworzeniu aplikacji
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob, Grep, Task
---

# /start - Discovery + IDEA.md

Przeprowadź użytkownika przez proces odkrywania pomysłu i wygeneruj kompletny IDEA.md.

## Dwa główne cele /start:

1. **IDEA.md** — plan aplikacji zatwierdzony przez usera
2. **Konfiguracja projektu** — Bundle ID, App Name, table prefix ustawione w kodzie

> **/start NIE jest ukończony dopóki OBA cele nie są zrobione!**

---

## PREREQ: Sprawdź stan projektu

1. Przeczytaj `CLAUDE.md` - sekcja "Stan projektu"
2. Sprawdź status `/start`:
   - Jeśli `done` → "Masz już ukończony /start. Wpisz `/home` aby kontynuować."
   - Jeśli `in-progress: [substatus]` → zaproponuj kontynuację od tego miejsca
   - Jeśli `not-started` → rozpocznij od KROKU 1

---

## Instrukcja wykonania

Wykonuj kroki **po kolei**. Po ukończeniu każdego → przeczytaj następny plik i wykonaj go.

**⚠️ NIE czytaj wszystkich plików na raz! Czytaj TYLKO bieżący krok.**

| Kolejność | Plik | Co robi |
|-----------|------|---------|
| 1 | `.claude/commands/start/start-1-platform.md` | Połączenie z platformą, API Key |
| 2 | `.claude/commands/start/start-2-interview.md` | Wywiad (tylko nowi userzy) |
| 3 | `.claude/commands/start/start-3-idea.md` | Pomysł na aplikację |
| 4 | `.claude/commands/start/start-4-app.md` | Utwórz aplikację na platformie |
| 5 | `.claude/commands/start/start-5-comms.md` | Styl komunikacji |
| 6 | `.claude/commands/start/start-6-ideamd.md` | Generuj i zatwierdź IDEA.md |
| 7 | `.claude/commands/start/start-7-finalize.md` | Bundle ID w kodzie, sync, commit |

**Zacznij teraz:** Przeczytaj `.claude/commands/start/start-1-platform.md` i wykonaj go.
