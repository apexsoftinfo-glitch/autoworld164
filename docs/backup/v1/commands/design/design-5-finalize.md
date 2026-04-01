# KROK 5: Finalizacja i sprzątanie (KRYTYCZNE!)

## 5.1 Przenieś wybrany design

Skopiuj wybrany design do `lib/features/home/ui/home_screen.dart`

## 5.2 Wyekstrahuj tokeny

Wyekstrahuj design tokens do `lib/shared/theme/`:
- `app_colors.dart` - paleta kolorów (light + dark)
- `app_typography.dart` - style tekstów
- `app_spacing.dart` - marginesy, paddingi
- `app_theme.dart` - ThemeData

## 5.3 Usuń WSZYSTKIE warianty

**OBOWIĄZKOWE!** Usuń cały folder variants i pliki developerskie:

```bash
rm -rf lib/features/home/ui/variants/
rm lib/features/home/ui/variant_switcher.dart
rm lib/features/home/ui/home_dev_router.dart
```

## 5.4 Przywróć AppGate

W `lib/app/router/app_gate.dart`:
```dart
import '../../features/home/ui/home_screen.dart';
home: () => const HomeScreen(),
```

## 5.5 Zapisz Design System w CLAUDE.md

**OBOWIĄZKOWE!** Wypełnij CAŁĄ sekcję "Design System":

```markdown
## Design System (zamrożony w /design)

- **Wireframe:** [opis z poprzedniego kroku - layout]
- **Design:** [OPISOWY opis wybranego stylu, np. "Dark Minimal - ciemne tło (#121212), biała typografia, akcenty cyan (#00BCD4), dużo przestrzeni, ostre kąty"]
- **Vibe:** [2-3 słowa opisujące nastrój, np. "spokojny, nowoczesny, premium"]
- **Paleta:** [główne kolory, np. "dark: #121212, surface: #1E1E1E, primary: #00BCD4, text: #FFFFFF"]
- **Typography:** [fonty i style, np. "Inter - headers 24/bold, body 16/regular, caption 12/medium"]
- **Charakterystyka:** [3-5 słów, np. "dark, minimal, spacious, modern"]
```

**WAŻNE:** Opisz KONKRETNIE co jest w designie - kolory hex, nazwy fontów, vibe. NIE "Design: B"!

## 5.6 Flutter analyze

```bash
flutter analyze
```

**Wyczyść WSZYSTKO** - zero błędów, zero warningów, zero info!

## 5.7 Ustaw status ready-to-test

W `CLAUDE.md`:
- Status `/design`: `ready-to-test`
- Kontekst: `[Krótki opis designu], czeka na finalne zatwierdzenie`

## 5.8 Test finalny

```
Sprawdź finalny Home Screen:

flutter run

Upewnij się że:
- Wybrany design jest w home_screen.dart
- Tokeny są wyekstrahowane do shared/theme/
- Light/dark mode działa
- Wszystko wygląda jak wybrany design

Jak OK, napisz "ok".
```

**CZEKAJ na "ok" użytkownika!**

- **błąd / problem** → napraw i powtórz test
- **"ok"** → **NATYCHMIAST wykonaj 5.9 + 5.10 + 5.11 poniżej (NIE kończ tury, NIE czekaj na kolejny input!)**

## 5.9 Aktualizuj status na done

> **⚠️ WYKONAJ NATYCHMIAST po "ok" od usera!**
- Status `/design`: `done`
- Kontekst: `[Nazwa stylu], tokeny zamrożone`
- Next Action: `Wpisz /screens`

## 5.10 Commit

```bash
git add -A
git commit -m "feat(design): implement home screen design system

- Apply design: [opisowy opis stylu]
- Extract design tokens (colors, typography, spacing)
- Support light/dark mode
- Remove development variants"
```

## 5.11 Następny krok

> Dopiero TERAZ (po ustawieniu done + commit) wyświetl komunikat userowi:

```
Design zamrożony! Commit wykonany.
Wpisz `/screens` gdy będziesz gotowy.
```

---

## Reguły dla Agenta AI

### KRYTYCZNE
- **MAKSYMALNA RÓŻNORODNOŚĆ** - 5 designów musi być FUNDAMENTALNIE różnych
- **Czekaj na "ok"** przed kodowaniem jeśli user ma wizję
- **Po wyborze POSPRZĄTAJ** - usuń WSZYSTKIE warianty, zostaw tylko home_screen.dart
- **Opisowo w CLAUDE.md** - nie "Design: B" tylko pełny opis z kolorami hex, fontami, vibe
- **flutter analyze** przed commitem - zero problemów!

### WAŻNE
- Wireframe to inspiracja, nie sztywna rama - modyfikuj proporcje!
- Różne DOMYŚLNE tryby (nie wszystkie light/dark!)
- Eksperymentuj z typografią i kolorami
- Instrukcje testowe dostosowane do communication_mode

### ZAKAZY
- **NIGDY** dwa podobne style - to PORAŻKA!
- **NIGDY** koduj przed potwierdzeniem zrozumienia wizji usera
- **NIGDY** zostawiaj wariantów po wyborze
- **NIGDY** zapisuj "Design: B" w CLAUDE.md - opisz CO jest w designie!

### Synchronizacja (OBOWIĄZKOWE)
- Przy KAŻDEJ zmianie statusu → sync z platformą
- Na końcu kroku sprawdź czy było trudno → zapisz struggle (bez pytania usera)
- Jeśli API zwraca 401 → poproś o nowy API Key

---

## Struktura plików po /design

```
lib/
├── features/home/ui/
│   └── home_screen.dart       # Finalny design
├── shared/theme/
│   ├── app_colors.dart        # Paleta (light + dark)
│   ├── app_typography.dart    # Style tekstów
│   ├── app_spacing.dart       # Marginesy, paddingi
│   └── app_theme.dart         # ThemeData
```

---

## Checklist

- [ ] Wybrany wireframe przeczytany z CLAUDE.md
- [ ] User zapytany o wizję/inspiracje stylu
- [ ] Jeśli ma wizję → doprecyzowane i potwierdzone ("ok") PRZED kodowaniem
- [ ] 5 designów RADYKALNIE różnych (różne vibe, różne domyślne tryby!)
- [ ] User przetestował wszystkie style
- [ ] User wybrał jeden design
- [ ] Design przeniesiony do home_screen.dart
- [ ] Tokeny wyekstrahowane do shared/theme/
- [ ] WSZYSTKIE warianty i pliki dev USUNIĘTE
- [ ] AppGate przywrócony do HomeScreen
- [ ] CLAUDE.md zaktualizowane (OPISOWY Design System!)
- [ ] `flutter analyze` = zero problemów
- [ ] User przetestował finalny design ("ok")
- [ ] Commit wykonany
- [ ] User poinformowany o `/screens`
- [ ] Status zaktualizowany w CLAUDE.md na `done`
- [ ] **Status zsynchronizowany z platformą:**
```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{design_step_id}", "status": "done"}]}'
```
- [ ] Agent sprawdził czy krok był trudny → jeśli tak, zapisał struggle do API

---

> ✅ KROK /design ukończony!
