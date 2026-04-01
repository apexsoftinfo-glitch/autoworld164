# KROK 7-8: Test, Feedback i Finalizacja

## KROK 7: Test & Feedback (OBOWIĄZKOWE!)

### 7.1 Instrukcje uruchomienia

**Dostosuj do `communication_mode` z CLAUDE.md:**

**Dla beginner:**
```
Teraz sprawdź czy wszystko działa.

W terminalu wpisz:
flutter run

Przetestuj:
- Home → tap na element → Detail Screen
- Detail → przycisk Edit → Add/Edit Screen
- Home → przycisk Add (FAB) → Add Screen
- Home → ikona Settings → Settings Screen
- Settings → zmień imię → zapisz → wróć
- Formularz → zostaw puste pole → zobacz inline error (nie snackbar!)

Jak będzie OK, napisz "ok". Jak coś nie działa - powiedz co.
```

**Dla intermediate/advanced:**
```
`flutter run` i przetestuj nawigację (Home↔Detail↔Edit, Settings).
Sprawdź inline errors w formularzu.
Jak OK, napisz "ok" i zrobimy commit.
```

### 7.2 Zadaj konkretne pytania

Po testach usera, zapytaj o każdy ekran:

```
Świetnie że przetestowałeś! Mam kilka pytań zanim pójdziemy dalej:

1. **Detail Screen** - jak wygląda? Podoba Ci się układ/kolory?
2. **Add/Edit Screen** - formularz jest czytelny? Inline errors działają?
3. **Settings Screen** - czy wszystkie opcje są na miejscu? Podoba Ci się sekcja "Made with ❤️"?
4. **Nawigacja** - płynnie przechodzi między ekranami?

Coś chciałbyś zmienić zanim zrobimy commit?
```

### 7.3 CZEKAJ na odpowiedź usera!

- **błąd / problem** → napraw i powtórz test
- **feedback do zmian (np. "zmień kolor", "przesuń przycisk")** → wprowadź zmiany i powtórz pytania
- **"ok" / "wszystko git"** → **NATYCHMIAST wykonaj KROK 8 poniżej (NIE kończ tury, NIE czekaj na kolejny input!)**

---

## KROK 8: Finalizacja

> **⚠️ WYKONAJ NATYCHMIAST po "ok" od usera! Nie wyświetlaj komunikatu i nie czekaj — od razu rób poniższe kroki.**

### 8.1 Flutter analyze (OBOWIĄZKOWE!)

```bash
flutter analyze
```

**Wyczyść WSZYSTKO** - zero błędów, zero warningów, zero info!

### 8.2 Aktualizuj CLAUDE.md na done

- Status `/screens`: `done`
- Kontekst: `Detail, Add/Edit, Settings, shared components`
- Next Action: `Wpisz /logic`

### 8.3 Auto-commit

```bash
git add -A
git commit -m "feat(screens): implement core screens and components

- Add Detail screen with edit action
- Add Add/Edit screen with form validation
- Add Settings screen (core options)
- Extract shared components (buttons, inputs, dialogs)
- Connect navigation between screens"
```

### 8.4 Zapowiedź następnego kroku

> Dopiero TERAZ (po ustawieniu done + commit) wyświetl komunikat userowi:

```
Ekrany gotowe! Commit wykonany.
Wpisz `/logic` gdy będziesz gotowy.
```

---

## Reguły dla Agenta AI

### KRYTYCZNE (łamanie = błąd)
- **KAŻDY hardcoded string oznaczaj `// L10N`!** (Text, hintText, labelText, AppBar title, SnackBar, empty states, validation messages, dialog titles, button labels, placeholders)
- Błędy formularzy INLINE (`SelectableText`), **NIE** snackbar
- **Nie rób commita bez potwierdzenia usera!** Zawsze czekaj na "ok"

### WAŻNE
- Używaj tokenów z `shared/theme/` (nigdy hardcoded kolory)
- Snackbar tylko dla sukcesu
- Dialog potwierdzenia dla destrukcyjnych akcji
- Light/dark mode przez Theme
- Nawigacja przez AppNavigator

### ZAKAZY
- Nie twórz ekranów w innym stylu niż Home
- Nie hardcoduj kolorów/fontów w widgetach
- Nie pomijaj Settings core options
- Nie zostawiaj niedziałających placeholderów (muszą pokazać snackbar "Wkrótce")

### Synchronizacja (OBOWIĄZKOWE)
- Przy KAŻDEJ zmianie statusu → sync z platformą
- Na końcu kroku sprawdź czy było trudno → zapisz struggle (bez pytania usera)
- Jeśli API zwraca 401 → poproś o nowy API Key

---

## Struktura plików po /screens

```
lib/
├── core/
│   └── theme/
│       └── theme_notifier.dart     # Globalny theme (ChangeNotifier)
├── features/
│   ├── home/
│   │   └── ui/
│   │       └── home_screen.dart    # BEZ lokalnego toggle!
│   ├── [feature]/
│   │   └── ui/
│   │       ├── detail_screen.dart
│   │       └── add_edit_screen.dart
│   └── settings/
│       └── ui/
│           └── settings_screen.dart  # Z przełącznikiem ThemeNotifier
├── shared/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   └── app_theme.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── confirmation_dialog.dart
│       ├── loading_indicator.dart
│       ├── empty_state_widget.dart
│       └── widgets.dart
```

---

## Checklisty

### Po KROKU 2:
- [ ] Detail Screen zaimplementowany
- [ ] Spójny styl z Home

### Po KROKU 3:
- [ ] Add/Edit Screen zaimplementowany
- [ ] Walidacja inline
- [ ] Jeden ekran dla Add i Edit

### Po KROKU 4:
- [ ] ThemeNotifier stworzony w lib/core/theme/
- [ ] ThemeNotifier podłączony do MaterialApp
- [ ] Lokalne toggles usunięte z innych ekranów
- [ ] Settings Screen z wszystkimi core options (w tym Tryb ciemny)
- [ ] Tryb ciemny działa globalnie przez ThemeNotifier
- [ ] Placeholdery dla auth (snackbar "Wkrótce")
- [ ] Dialog potwierdzenia dla destrukcyjnych akcji

### Po KROKU 5:
- [ ] Shared components wyekstrahowane
- [ ] Ekrany używają shared widgets

### Po KROKU 6:
- [ ] Nawigacja działa między wszystkimi ekranami
- [ ] Używa AppNavigator
- [ ] Status ustawiony na `ready-to-test`

### Po KROKU 7:
- [ ] User przetestował aplikację
- [ ] **User potwierdził "ok"**

### Po KROKU 8 (TYLKO po "ok"!):
- [ ] Status ustawiony na `done`
- [ ] CLAUDE.md zaktualizowane
- [ ] Commit wykonany
- [ ] Status zaktualizowany w CLAUDE.md na `done`
- [ ] **Status zsynchronizowany z platformą:**
```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{screens_step_id}", "status": "done"}]}'
```
- [ ] Agent sprawdził czy krok był trudny → jeśli tak, zapisał struggle do API

---

> ✅ KROK /screens ukończony!
