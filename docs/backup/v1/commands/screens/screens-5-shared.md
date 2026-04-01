# KROK 5: Shared Components

## 5.1 Zidentyfikuj powtarzające się elementy

Przejrzyj zbudowane ekrany i wyekstrahuj:
- Przyciski (primary, secondary, destructive)
- Karty/listy (jeśli używane wielokrotnie)
- Inputy (TextField, FormField)
- Dialogi (confirmation, info)
- Loading states
- Empty states

## 5.2 Wywołaj skill

```
Przeczytaj: .claude/skills/flutter-ui/SKILL.md

Zadanie: Wyekstrahuj shared components.

Komponenty do stworzenia:
- AppButton (primary, secondary, destructive variants)
- AppTextField (z walidacją inline)
- AppCard (jeśli używane)
- ConfirmationDialog
- LoadingIndicator
- EmptyStateWidget

Wymagania:
- Użyj tokenów z shared/theme/
- Każdy komponent w osobnym pliku
- Eksportuj przez shared/widgets/widgets.dart
```

## 5.3 Struktura

```
lib/shared/widgets/
├── app_button.dart
├── app_text_field.dart
├── app_card.dart
├── confirmation_dialog.dart
├── loading_indicator.dart
├── empty_state_widget.dart
└── widgets.dart  # Barrel export
```

## 5.4 Refaktoruj ekrany

Zamień hardcoded komponenty na shared widgets we wszystkich ekranach.

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/screens/screens-6-navigation.md`
