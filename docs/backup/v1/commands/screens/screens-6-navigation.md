# KROK 6: Nawigacja

## 6.1 Podłącz ekrany

Upewnij się, że nawigacja działa:
- Home → Detail (tap na element)
- Detail → Add/Edit (edit button)
- Home → Add (FAB/CTA)
- Home → Settings (menu/icon)
- Settings → back → Home
- Add/Edit → back → poprzedni ekran

## 6.2 Użyj AppNavigator

Nawigacja przez `AppNavigator` (nie bezpośrednie Navigator.push):

```dart
// W Home
onTap: () => navigator.goToDetail(item.id),

// W Detail
onEdit: () => navigator.goToEdit(item.id),

// W Settings
// Już jest dostępne przez navigator
```

## 6.3 Test nawigacji

Przetestuj wszystkie ścieżki ręcznie:
1. Home → Detail → Edit → Save → Detail
2. Home → Add → Save → Home (z nowym elementem)
3. Home → Settings → zmień imię → back → Home

## 6.4 Ustaw status ready-to-test

W `CLAUDE.md`:
- Status `/screens`: `ready-to-test`
- Kontekst: `Wszystkie ekrany zbudowane, nawigacja podpięta`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/screens/screens-7-finalize.md`
