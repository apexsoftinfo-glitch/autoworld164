# KROK 5: Styl komunikacji (jeśli jeszcze nie ustalony)

## 5.1 Zapisz communication_mode

Jeśli nie było ustalone w KROKU 2:
1. Użyj wartości z `initial_programming_level` z API
2. Zapisz w CLAUDE.md: `communication_mode: {wartość}`

## 5.2 Ustaw commit_mode

**Dla beginner:**
- Ustaw `commit_mode: auto` w CLAUDE.md
- Nie pytaj

**Dla intermediate:**
```yaml
question: "Jak chcesz zarządzać commitami?"
header: "Commity"
options:
  - label: "Automatycznie (Recommended)"
    description: "Robię commit po każdym 'ok'"
  - label: "Sam robię"
    description: "Tylko powiem kiedy warto, ale nie zrobię"
```

**Dla advanced:**
- Ustaw `commit_mode: manual` w CLAUDE.md

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/start/start-6-ideamd.md`
