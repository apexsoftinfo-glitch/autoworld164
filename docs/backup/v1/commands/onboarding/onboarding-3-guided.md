# KROK 3: Onboarding Screen (Guided Onboarding)

## Guided Onboarding Flow (8 stron)

```
┌─────────────────────────────────────────────────────────────┐
│  WELCOME SCREEN (osobny ekran, nie część Guided Onboarding) │
│  Logo + animacja scale (0.5→1.0, elasticOut)               │
│  "Rozpocznij" → signInAnonymously placeholder → Guided Onboarding │
│  "Mam konto" → snackbar "Wkrótce" (placeholder)            │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  1. IMIĘ                                                    │
│  "Jak masz na imię?"                                        │
│  [TextField autofocus]                                      │
│  [Dalej]                                                    │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  2. PREVIEW                                                 │
│  "Witaj, [imię]!"                                           │
│  "Za chwilę zobaczysz jak działa [App]."                   │
│  [Zaczynamy!]                                               │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  3. PROBLEM                                                 │
│  WIZUALIZACJA problemu (widgety, nie tekst!)               │
│  1-2 zdania kontekstu                                       │
│  [Dalej]                                                    │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  4. SOLUTION                                                │
│  WIZUALIZACJA rozwiązania (widgety, nie tekst!)            │
│  1-2 zdania wyjaśnienia                                     │
│  [Pokaż mi]                                                 │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  5. EXPERIENCE                                              │
│  Demo interaktywne (2-3 kliknięcia)                        │
│  User KLIKA, nie czyta ani nie pisze                        │
│  Przykładowe dane (demo)                                    │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  6. BRIDGE                                                  │
│  "Widzisz? [Podsumowanie wartości]"                        │
│  "Twoja kolej - dodaj swój pierwszy [element]!"            │
│  [Dodaj swój pierwszy →]                                   │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  7. MINIMAL SETUP                                           │
│  "Dodaj swój pierwszy [element]:"                          │
│  [Tylko 1-2 pola REQUIRED]                                 │
│  "Resztę możesz uzupełnić później"                         │
│  [Dodaj i rozpocznij]                                       │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  8. → HOME                                                  │
│  Od razu Home (BEZ ekranu "Jesteś gotowy!")                │
│  Nowy element PODŚWIETLONY/ANIMOWANY                        │
│  Opcjonalny tooltip: "Oto Twój pierwszy [element]!"        │
└─────────────────────────────────────────────────────────────┘
```

---

## Error Handling Pattern (WYMAGANE!)

Kroki które zapisują dane (Imię, Mini Setup) MUSZĄ mieć error handling.

### OnboardingSaveState (freezed)

Stany: `idle` | `loading` | `error(message)` | `success`

### Flow zapisu

```
User klika "Dalej"
       ↓
   saveState = loading (spinner na przycisku)
       ↓
   Próba zapisu (Repository)
       ↓
┌──────────────────────────────────────┐
│ BŁĄD:                                │
│ - saveState = error(message)         │
│ - NIE przechodzi dalej!              │
│ - Pokazuje błąd inline (SelectableText)│
│ - Debug: pełny komunikat             │
│ - Release: "Nie udało się zapisać"   │
└──────────────────────────────────────┘
       lub
┌──────────────────────────────────────┐
│ SUKCES:                              │
│ - saveState = success                │
│ - Przechodzi do następnej strony     │
└──────────────────────────────────────┘
```

### Acceptance Criteria dla UI z zapisem

- [ ] TextField z `onChanged` aktualizuje stan cubita
- [ ] Error message inline jako `SelectableText` (NIE snackbar!)
- [ ] Debug mode: pełny komunikat błędu, Release: generyczny tekst
- [ ] Przycisk disabled podczas `loading`
- [ ] Spinner (20x20 CircularProgressIndicator) zamiast tekstu podczas `loading`

---

## 3.1 Struktura

```
lib/features/onboarding/
├── ui/
│   └── onboarding_screen.dart    # Wszystkie 7 stron w jednym pliku
└── cubit/
    └── onboarding_cubit.dart     # Stan + logika (freezed)
```

## 3.2 Wywołaj skill

```
Przeczytaj: .claude/skills/guided-onboarding/SKILL.md

Zadanie: Zbuduj 7-stronicowy Guided Onboarding W STYLU z Design System (CLAUDE.md)!

Design System z CLAUDE.md:
- Vibe: [skopiuj z CLAUDE.md]
- Paleta: [skopiuj z CLAUDE.md]
- Typography: [skopiuj z CLAUDE.md]
- Charakterystyka: [skopiuj z CLAUDE.md]

Kontekst z docs/IDEA.md:
- Wizualizacja Problemu: [z docs/IDEA.md]
- Wizualizacja Rozwiązania: [z docs/IDEA.md]
- Demo Experience: [z docs/IDEA.md]
- Minimal Setup pola: [z docs/IDEA.md]

Strony:
1. Imię - TextField autofocus
2. Preview - "Witaj, [imię]!" + zapowiedź
3. Problem - WIZUALIZACJA (widgety, max 1-2 zdania)
4. Solution - WIZUALIZACJA (widgety, max 1-2 zdania)
5. Experience - Demo interaktywne (2-3 kliknięcia na przykładowych danych)
6. Bridge - "Twoja kolej!" CTA
7. Minimal Setup - TYLKO required fields (max 1-2), info "Resztę później"

Wymagania:
- PageView z PageController (swipe disabled)
- Nawigacja przez przyciski (nie swipe)
- isReplay parameter (true → pokazuj X w AppBar)
- Użyj tokenów z shared/theme/ (te same co Home!)
- Light/dark mode
- Styl MUSI być spójny z Welcome i Home Screen!
```

## 3.3 OnboardingState (freezed)

Pola stanu:
- `currentPage` (int) - aktualna strona (0-6)
- `userName` (String) - imię usera
- `first{Entity}Text` (String) - pole z Minimal Setup (z docs/IDEA.md, np. firstTaskText, firstNoteText)
- `saveState` (OnboardingSaveState) - stan zapisu
- `isCompleted` (bool) - czy zakończony
- `isAuthenticating` (bool) - placeholder dla auth
- `authError` (String?) - błąd auth
- `userId` (String?) - ID usera

## 3.4 OnboardingCubit - wymagania (KRYTYCZNE!)

Onboarding MUSI używać Repository z `/logic` do zapisu danych.

**Zależności cubita:**
- `ProfilesRepository` - zapis imienia, oznaczenie onboardingu jako ukończony
- `{Entities}Repository` - zapis pierwszego elementu (np. TasksRepository, NotesRepository - z docs/IDEA.md)

**Metoda `saveName()` - strona Imię:**
1. Walidacja: `userName.trim().isEmpty` → return
2. Emit `loading`
3. Wywołanie `_profilesRepository.updateName(userId, userName)`
4. Fold result: error → emit error, success → emit success + `currentPage++`

**Metoda `saveFirstEntry()` - strona Minimal Setup:**
1. Walidacja: pole tekstowe puste → return
2. Emit `loading`
3. Utworzenie `{Entity}Model` z danymi usera (np. TaskModel, NoteModel - z docs/IDEA.md)
4. Wywołanie `_{entities}Repository.add{Entity}(model)`
5. Fold result: error → emit error, success → `setOnboardingCompleted()` + emit `isCompleted = true`

## 3.5 Implementacja stron

Dla każdej strony pamiętaj:

| Strona | Wizualna? | Interaktywna? | Max tekst |
|--------|-----------|---------------|-----------|
| 1. Imię | - | TextField | Pytanie |
| 2. Preview | - | - | 1-2 zdania |
| 3. Problem | TAK | - | 1-2 zdania |
| 4. Solution | TAK | - | 1-2 zdania |
| 5. Experience | TAK | klikanie | Instrukcja |
| 6. Bridge | TAK | - | CTA |
| 7. Minimal Setup | - | formularz | Info |

---

### Checklista po KROKU 3:
- [ ] Strona 1: Imię (TextField autofocus + error handling)
- [ ] Strona 2: Preview ("Witaj, [imię]!")
- [ ] Strona 3: Problem (WIZUALIZACJA z docs/IDEA.md)
- [ ] Strona 4: Solution (WIZUALIZACJA z docs/IDEA.md)
- [ ] Strona 5: Experience (2-3 kliknięcia demo)
- [ ] Strona 6: Bridge ("Twoja kolej!")
- [ ] Strona 7: Minimal Setup (1-2 pola + error handling)
- [ ] OnboardingCubit używa ProfilesRepository i {Entities}Repository
- [ ] Error handling: idle/loading/error/success
- [ ] Błędy wyświetlane inline (SelectableText, NIE snackbar!)
- [ ] isReplay parameter działa (X w AppBar)

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/onboarding/onboarding-4-navigation.md`
