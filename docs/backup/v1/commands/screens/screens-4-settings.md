# KROK 4: Settings Screen (CORE)

## 4.0 ThemeNotifier (globalny theme)

**UWAGA:** ThemeNotifier jest rozwiązaniem TYMCZASOWYM.
W `/logic` (KROK 7.4) zostanie przekonwertowany na ThemeCubit dla spójności z architekturą Bloc.

**PRZED TWORZENIEM SETTINGS** - stwórz globalny ThemeNotifier w `lib/core/theme/theme_notifier.dart`:

**Co ma robić:**
- Przechowuje `ThemeMode` (system/light/dark)
- Ładuje zapisany tryb z `LocalStorageService` przy starcie
- Zapisuje zmiany do storage przy każdej modyfikacji

**Kluczowe metody:**
- `ThemeMode get mode` - getter aktualnego trybu
- `setMode(ThemeMode)` - ustawia i zapisuje tryb
- `toggle()` - przełącza między light/dark

**Podłączenie do MaterialApp** (`lib/app/app.dart`):
- Owinąć `MaterialApp` w `ChangeNotifierProvider<ThemeNotifier>`
- Użyć `Consumer<ThemeNotifier>` do przekazania `themeMode` do `MaterialApp`

**WAŻNE:** Po utworzeniu ThemeNotifier, **USUŃ lokalne toggles** ze wszystkich istniejących ekranów.

## 4.1 Wymagania Settings Core

Settings MUSI zawierać te opcje:

| Opcja | Opis | Implementacja w /screens |
|-------|------|-------------------------|
| **Tryb ciemny** | Light/Dark toggle | `context.read<ThemeNotifier>().toggle()` |
| **Imię** | Edytowalne pole | TextFormField + Save |
| **Język** | PL/EN toggle | Placeholder (pełne w /localize) |
| **Połącz konto** | Dla gości | Placeholder → snackbar "Wkrótce" |
| **Wyloguj** | Logout | Placeholder → snackbar "Wkrótce" |
| **Usuń konto** | Delete account | Placeholder → dialog potwierdzenia → snackbar |

## 4.1b Pro features w Settings (z IDEA.md)

Sprawdź IDEA.md → "Paywall Content" → tabelę "What's included" → kolumnę "Implementacja".

Jeśli jakiś benefit ma implementację "Toggle w Settings" (np. "Premium Themes"):
- **Zbuduj feature normalnie** (np. ThemeNotifier z dark mode już istnieje powyżej)
- **Oznacz komentarzem `// PRO`** w kodzie przy odpowiednim UI elemencie
- **NIE dodawaj gating** — to zrobi `/limits` z `if (session.isPro)`

Jeśli benefit wymaga dodatkowej opcji w Settings (np. "Export Data" → przycisk eksportu):
- Dodaj opcję do listy w sekcji odpowiedniej grupy (np. "Dane")
- Oznacz `// PRO` w komentarzu

## 4.2 Wywołaj skill

```
Przeczytaj: .claude/skills/flutter-ui/SKILL.md

Zadanie: Zbuduj Settings Screen z opcjami core.

Opcje:
1. Tryb ciemny (toggle) - używa ThemeNotifier.toggle()
2. Imię użytkownika (edytowalne)
3. Język (PL/EN) - placeholder, działa w /localize
4. Połącz konto (widoczne tylko dla gości) - placeholder
5. Wyloguj - placeholder
6. Usuń konto - dialog potwierdzenia + placeholder

Wymagania:
- Użyj tokenów z shared/theme/
- Grupowanie opcji (np. "Wygląd", "Konto", "Inne")
- Tryb ciemny używa globalnego ThemeNotifier
- Dialogi potwierdzenia dla destrukcyjnych akcji
- Na dole: "Made with ❤️ by [Imię Nazwisko z CLAUDE.md]" + wersja aplikacji
```

**UWAGA:** Imię użytkownika jest teraz placeholder (fake data).
Zostanie podłączone do ProfilesCubit w kroku `/logic` - nie martw się że jest zahardcodowane!

## 4.3 Implementacja

Stwórz: `lib/features/settings/ui/settings_screen.dart`

## 4.4 Aktualizuj status

- Status `/screens`: `in-progress: shared`
- Kontekst: `Settings gotowy, budowanie shared components`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/screens/screens-5-shared.md`
