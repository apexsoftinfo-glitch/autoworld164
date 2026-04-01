---
description: L10N (PL + EN) + przełącznik języka
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob, Grep, Task
---

# /localize - Lokalizacja

Dodaj obsługę wielu języków (PL + EN) i przełącznik w Settings.

**Skill:** `.claude/skills/flutter-localization/SKILL.md` ← **PRZECZYTAJ PRZED ROZPOCZĘCIEM!**

> Po zakończeniu lokalizacji → `/finalize` posprzątanie CLAUDE.md.

---

## PREREQ: Sprawdź stan projektu

1. Przeczytaj `CLAUDE.md` - sekcja "Stan projektu"
2. Sprawdź status:
   - `/review` musi być `done`
   - Jeśli `/review` nie jest `done` → "Najpierw wpisz `/review` aby dodać ask for review."
3. Sprawdź status `/localize`:
   - Jeśli `done` → "Lokalizacja gotowa. Aplikacja jest kompletna!"
   - Jeśli `ready-to-test` → "Lokalizacja gotowa do przetestowania. Uruchom `flutter run`, przetestuj oba języki i napisz 'ok'."
   - Jeśli `in-progress: [substatus]` → kontynuuj od tego miejsca
   - Jeśli `not-started` → rozpocznij od KROKU 1

---

## Synchronizacja z platformą

Przed rozpoczęciem:
1. Sprawdź `.env` → `PLATFORM_API_KEY`. Jeśli brak lub pusty → poproś usera:
   "Potrzebuję API Key z platformy. Wejdź na platformę → Profil → skopiuj API Key i wklej tutaj."
   Po otrzymaniu → zapisz do `.env` i zwaliduj (GET /user). Jeśli 401 → poproś ponownie.
2. Sprawdź w CLAUDE.md:
   - **Platform App ID** - ID tej aplikacji na platformie
   - **Step ID dla tego kroku** - UUID z mapowania w CLAUDE.md
3. Jeśli brakuje Platform App ID lub Step ID → "Najpierw wpisz `/start` aby połączyć z platformą."

> **UWAGA:** Sprawdzanie API Key dotyczy KAŻDEJ komendy, nie tylko /start. Klucz może wygasnąć lub zostać zregenerowany w dowolnym momencie.

---

## Sync: in_progress

Po sprawdzeniu PREREQ i synchronizacji z platformą, wyślij PATCH `in_progress`:

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{localize_step_id}", "status": "in_progress"}]}'
```

---

## KROK 0: Rozbuduj CLAUDE.md (PIERWSZE co robisz!)

Ten krok nie dodaje nowych sekcji do CLAUDE.md.

> Sprzątanie CLAUDE.md przeniesione do osobnego kroku `/finalize`.

---

## KROK 1: Setup

→ **Skill:** `.claude/skills/flutter-localization/SKILL.md` → sekcja "Setup"

**Do zrobienia:**
1. Dodaj dependencies w pubspec.yaml
2. Utwórz l10n.yaml
3. `flutter pub get`

**Status update w CLAUDE.md:**
- Status `/localize`: `in-progress: arb`
- Kontekst: `Setup L10N, tworzenie ARB files`

---

## KROK 2: Pełne skanowanie stringów (KRYTYCZNE!)

**WAŻNE:** Komentarze `// L10N` mogą być pominięte! Musisz przeskanować WSZYSTKIE pliki.

### 2.1 Przeszukaj kod - oznaczone stringi

→ **Skill:** `.claude/skills/flutter-localization/SKILL.md` → sekcja "Finding Strings to Localize"

### 2.2 Przeszukaj kod - WSZYSTKIE stringi

Uruchom grep commands ze skilla dla:
- `Text()` z literałami
- `hintText`, `labelText`
- `title` w AppBar/Dialog
- `SnackBar` content

### 2.3 ONBOARDING - sprawdź STRONĘ PO STRONIE!

| Strona | Co sprawdzić |
|--------|--------------|
| 1. Imię | Pytanie, hint, button label |
| 2. Preview | Greeting, opis, button |
| 3. Problem | Tytuł, opis, tekst przy wizualizacji |
| 4. Solution | Tytuł, opis, tekst przy wizualizacji |
| 5. Experience | Instrukcja, **przykładowe dane demo!** |
| 6. Bridge | CTA tekst, opis wartości |
| 7. Minimal Setup | Label pól, hints, info "Resztę później", button |

**Sprawdź też:**
- `welcome_screen.dart`
- `home_screen.dart` (empty state!)
- `settings_screen.dart`
- `shared/widgets/` (dialogi, buttony)

### 2.4 Zrób listę WSZYSTKICH stringów

Format: `[plik:linia] "tekst"`

---

## KROK 3: Tworzenie plików ARB

### 3.1 Format i klucze

→ **Skill:** `.claude/skills/flutter-localization/SKILL.md` → sekcje "ARB Files" + "Key Naming Convention"
→ **Reference:** `references/arb-format.md` (placeholdery, pluralizacja)

### 3.2 Wymagane klucze (minimum)

- [ ] Welcome screen (tytuł, buttony)
- [ ] Onboarding - WSZYSTKIE strony!
- [ ] Home screen (greeting, empty state, CTA)
- [ ] Detail/Add/Edit screens
- [ ] Settings (opcje, dialogi)
- [ ] Błędy (generic, network)
- [ ] Dialogi (confirm, cancel, tytuły)
- [ ] Języki (`language_polish`, `language_english`)

### 3.3 Wygeneruj kod

```bash
flutter gen-l10n
```

**Status update w CLAUDE.md:**
- Status `/localize`: `in-progress: switch`
- Kontekst: `ARB files gotowe, tworzenie przełącznika`

---

## KROK 4: LocaleService + Przełącznik

→ **Skill:** `.claude/skills/flutter-localization/SKILL.md` → sekcje "LocaleService (with Device Detection)" + "Language Switcher in Settings"

**Priorytet wyboru języka:**
1. Zapisana preferencja → użyj
2. Język urządzenia (pl/en) → użyj
3. Fallback → English

**Status update w CLAUDE.md:**
- Status `/localize`: `in-progress: material-app`
- Kontekst: `Przełącznik gotowy, aktualizacja MaterialApp`

---

## KROK 5: MaterialApp

→ **Skill:** `.claude/skills/flutter-localization/SKILL.md` → sekcja "MaterialApp Configuration"

**Status update w CLAUDE.md:**
- Status `/localize`: `in-progress: migration`
- Kontekst: `MaterialApp zaktualizowany, migracja stringów`

---

## KROK 6: Migracja stringów w kodzie

→ **Skill:** `.claude/skills/flutter-localization/SKILL.md` → sekcja "Usage in Code"

Przejdź przez kod i zamień wszystkie hardcoded stringi na `AppLocalizations.of(context)!.keyName`.

**Status update w CLAUDE.md:**
- Status `/localize`: `ready-to-test`
- Kontekst: `ARB files, przełącznik języka, stringi - czeka na testy`

---

## KROK 7: Test & Feedback (OBOWIĄZKOWE!)

### 7.1 Instrukcje uruchomienia

**Dostosuj do `communication_mode` z CLAUDE.md:**

**Dla beginner:**
```
Teraz sprawdź czy tłumaczenia działają.

Uruchom aplikację:
flutter run

Przetestuj POLSKI:
1. Przejdź przez całą aplikację - wszystko po polsku?

Przetestuj ANGIELSKI:
2. Settings → Język → English
3. Przejdź przez całą aplikację - wszystko po angielsku?

Przetestuj PERSYSTENCJĘ:
4. Zamknij aplikację (całkowicie)
5. Otwórz ponownie → czy pamiętał język (angielski)?
6. Przełącz z powrotem na Polski

Jak wszystko działa, napisz "ok". Jak coś nie działa - powiedz co.
```

**Dla intermediate/advanced:**
```
`flutter run` - przetestuj:
- Wszystkie ekrany w PL
- Switch na EN → wszystkie ekrany w EN
- Persystencja po restarcie
Jak OK, napisz "ok".
```

### 7.2 Checklista stringów

Sprawdź te ekrany w obu językach:
- [ ] Welcome Screen
- [ ] Onboarding (wszystkie strony!)
- [ ] Home Screen (greeting, empty state, lista)
- [ ] Detail Screen
- [ ] Add/Edit Screen
- [ ] Settings Screen
- [ ] Dialogi (logout, delete, upgrade)
- [ ] Error messages

### 7.3 Po testach usera

```
Świetnie że przetestowałeś! Mam pytania:

1. **Polski** - wszystkie teksty są poprawne i brzmi naturalnie?
2. **Angielski** - tłumaczenia są poprawne gramatycznie?
3. **Persystencja** - po restarcie pamiętał język?
4. **Brakujące stringi** - czy gdzieś widzisz jeszcze hardcoded tekst?

Coś chciałbyś zmienić w tłumaczeniach zanim zrobimy commit?
```

### 7.4 CZEKAJ na odpowiedź usera!

- **"ok" / "działa"** → KROK 8 (Finalizacja)
- **błędy w tłumaczeniu** → popraw ARB + `flutter gen-l10n`
- **brakujące stringi** → dodaj do ARB, zaktualizuj kod, powtórz test

---

## KROK 8: Commit i finalizacja

### 8.1 Flutter analyze (OBOWIĄZKOWE!)

```bash
flutter analyze
```

**Wyczyść WSZYSTKO** - zero błędów, zero warningów, zero info!

### 8.2 Aktualizuj status

**WARUNEK:** User potwierdził "ok".

W `CLAUDE.md`:
- Status `/localize`: `done`
- Kontekst: `L10N (PL + EN), przełącznik w Settings`
- Next Action: `Wpisz /finalize`

### 8.3 Zaktualizuj sekcję "▶ Co dalej" w CLAUDE.md

```markdown
## ▶ Co dalej

**Następny krok:** `/finalize` — Posprzątaj CLAUDE.md, przygotuj projekt do dalszego developmentu
**Instrukcje:** `.claude/commands/finalize.md`

> Wpisz `/finalize` gdy będziesz gotowy!
```

### 8.4 Commit

```bash
git add -A
git commit -m "feat(l10n): add Polish and English localization

- Add ARB files for PL (default) and EN
- Implement language switcher in Settings
- Replace all hardcoded strings with l10n keys"
```

### 8.5 Następny krok

```
Lokalizacja gotowa!

Teraz czas posprzątać CLAUDE.md — usunąć kursowy scaffolding
i przygotować projekt do samodzielnego developmentu.

Wpisz `/finalize` gdy będziesz gotowy!
```

---

## Checklisty per krok

### Po KROKU 1:
- [ ] flutter_localizations w pubspec
- [ ] l10n.yaml utworzony

### Po KROKU 2:
- [ ] Przeszukano wszystkie pliki .dart (nie tylko // L10N!)
- [ ] Onboarding sprawdzony strona po stronie
- [ ] Lista wszystkich stringów zapisana

### Po KROKU 3:
- [ ] app_pl.arb utworzony (na podstawie listy z KROKU 2!)
- [ ] app_en.arb utworzony
- [ ] Wszystkie klucze z listy KROKU 2 są w ARB
- [ ] flutter gen-l10n działa

### Po KROKU 4:
- [ ] LocaleService z wykrywaniem języka urządzenia
- [ ] Priorytet: zapisana preferencja > język urządzenia > fallback (en)
- [ ] Przełącznik w Settings

### Po KROKU 5:
- [ ] MaterialApp z localizationsDelegates
- [ ] Consumer dla LocaleService

### Po KROKU 6:
- [ ] Wszystkie stringi zamienione na AppLocalizations
- [ ] Brak // L10N komentarzy
- [ ] Status ustawiony na `ready-to-test`

### Po KROKU 7:
- [ ] User przetestował oba języki
- [ ] **User potwierdził że działa ("ok")**
- [ ] PL działa poprawnie
- [ ] EN działa poprawnie
- [ ] Persystencja działa
- [ ] **Onboarding sprawdzony w obu językach!**

### Po KROKU 8 (TYLKO po "ok"!):
- [ ] CLAUDE.md status `/localize` zaktualizowany na `done`
- [ ] Commit wykonany
- [ ] User poinformowany o `/finalize`
- [ ] **Status zsynchronizowany z platformą:**
  ```bash
  curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
    -H "X-API-Key: {API Key}" \
    -H "Content-Type: application/json" \
    -d '{"steps": [{"id": "{localize_step_id}", "status": "done"}]}'
  ```
- [ ] Agent sprawdził czy krok był trudny → jeśli tak, zapisał struggle do API

---

## Reguły dla Agenta AI

### KRYTYCZNE
- Przeskanuj WSZYSTKIE pliki .dart - komentarze `// L10N` mogą być pominięte!
- Onboarding sprawdzaj strona po stronie - każdy tekst musi być w ARB
- Nie rób commita bez potwierdzenia usera ("ok")
- Po "ok" → commit + kieruj do `/finalize`

### WAŻNE
- Template ARB file to polski (app_pl.arb)
- Wszystkie stringi w obu językach (PL + EN)
- Wykrywanie języka urządzenia przy pierwszym uruchomieniu
- Persystencja wyboru języka (po ręcznej zmianie)
- Placeholder dla parametrów ({name}, {count})
- Fallback do angielskiego (en) gdy język urządzenia nieobsługiwany

### ZAKAZY
- Hardcoded stringi w UI (używaj AppLocalizations)
- Brakujące tłumaczenia (sprawdź oba ARB przed commitem)
- Hardcoded domyślny język (np. `Locale('pl')`) - wykrywaj język urządzenia!
- Język bez persystencji

### Synchronizacja (OBOWIĄZKOWE)
- Przy KAŻDEJ zmianie statusu → sync z platformą
- Na końcu kroku sprawdź czy było trudno → zapisz struggle (bez pytania usera)
- Jeśli API zwraca 401 → poproś o nowy API Key
