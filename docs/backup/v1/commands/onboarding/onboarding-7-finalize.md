# KROK 7: Finalizacja

> **⚠️ WYKONAJ NATYCHMIAST po "ok" od usera! Nie wyświetlaj komunikatu i nie czekaj — od razu rób poniższe kroki.**

## 7.1 Aktywuj AppGate

Otwórz `lib/app/router/app_gate_cubit.dart` i znajdź komentarze `TODO(onboarding)`:

1. **Usuń blok DEV** (linie z `emit(AppGateState.home(...))` i `return`)
2. **Odkomentuj prawdziwą logikę auth** (blok z `_authSubscription`)
3. **Usuń `ignore_for_file`** na górze pliku

Po zmianach `init()` powinien wyglądać tak:
```dart
Future<void> init() async {
  emit(const AppGateState.loading());

  _authSubscription = _authRepository.authStateChanges.listen(
    _handleAuthStateChange,
    onError: (error, stackTrace) {
      logError('AppGateCubit.authStream', error, stackTrace);
      emit(const AppGateState.welcome());
    },
  );
}
```

## 7.2 Flutter analyze (OBOWIĄZKOWE!)

```bash
flutter analyze
```

**Wyczyść WSZYSTKO** - zero błędów, zero warningów, zero info!

## 7.3 Aktualizuj CLAUDE.md na done

**WARUNEK:** User potwierdził "ok".

- Status `/onboarding`: `done`
- Kontekst: `Welcome + Guided Onboarding (8 stron) z error handling`
- Next Action: `Wpisz /database`

## 7.4 Auto-commit

```bash
git add -A
git commit -m "feat(onboarding): implement welcome and Guided Onboarding flow with error handling

- Add Welcome screen with logo animation
- Implement 8-page Guided Onboarding
- Add Problem/Solution visualizations
- Add interactive Experience demo
- Add Minimal Setup with error handling (loading/error/success)
- Save name via ProfilesRepository
- Save first entry via {Entities}Repository
- Add debug button for onboarding replay (Welcome → Guided Onboarding)
- Placeholder for auth (signInAnonymously)"
```

## 7.5 Zapowiedź następnego kroku

> Dopiero TERAZ (po ustawieniu done + commit) wyświetl komunikat userowi:

```
Onboarding gotowy! Commit wykonany.
Wpisz `/database` gdy będziesz gotowy.
```

---

## Reguły dla Agenta AI

### KRYTYCZNE (blokery jeśli naruszone)
- **Każdy hardcoded string oznaczaj `// L10N`** - onboarding ma DUŻO tekstów (wizualizacje, CTA, labels, przykładowe dane)
- **Design System z CLAUDE.md** - onboarding MUSI wyglądać jak Home (vibe, paleta, typography)
- **Error handling** dla kroków z zapisem (idle/loading/error/success)
- **Repository z `/logic`** - używaj ProfilesRepository i `{Entities}Repository` (np. TasksRepository - z IDEA.md)
- **Błędy inline (SelectableText)** - NIGDY snackbar!
- **Czekaj na "ok"** przed commitem - nie rób commita bez potwierdzenia usera

### WAŻNE (jakość UX)
- `.claude/skills/guided-onboarding/SKILL.md` dla wytycznych flow
- Problem/Solution = WIZUALIZACJE (widgety, nie tekst!)
- Experience = user KLIKA (2-3 kliknięcia demo, nie pisze)
- Minimal Setup = max 1-2 pola + info "Resztę później"
- Po Guided Onboarding → od razu Home z podświetlonym elementem (BEZ "Jesteś gotowy!")
- Welcome: logo z animacją scale+fade
- isReplay: true → X w AppBar

### ZAKAZY
- Welcome jako formularz (Welcome = logo + 2 przyciski!)
- Generyczne kolorowe koło jako logo
- Pola email/hasło na Welcome
- Tekst zamiast wizualizacji w Problem/Solution
- Formularz w Experience
- >2 pola w Minimal Setup
- Osobny ekran "Jesteś gotowy!"
- `_localStorageService` bezpośrednio (tylko przez Repository)
- Przejście dalej gdy `saveState = error`

### Synchronizacja (OBOWIĄZKOWE)
- Przy KAŻDEJ zmianie statusu → sync z platformą
- Na końcu kroku sprawdź czy było trudno → zapisz struggle (bez pytania usera)
- Jeśli API zwraca 401 → poproś o nowy API Key

---

## Struktura plików po /onboarding

```
lib/features/
├── welcome/
│   └── ui/
│       └── welcome_screen.dart
├── onboarding/
│   ├── ui/
│   │   └── onboarding_screen.dart  # 7 stron PageView
│   └── cubit/
│       ├── onboarding_cubit.dart
│       └── onboarding_cubit.freezed.dart
└── home/
    └── ui/
        └── home_screen.dart  # + debug button → WelcomeScreen
```

---

### Checklista po KROKU 7 (TYLKO po "ok"!):
- [ ] AppGate aktywowany (TODO(onboarding) usunięte)
- [ ] Status ustawiony na `done`
- [ ] CLAUDE.md zaktualizowane
- [ ] Commit wykonany
- [ ] Status zaktualizowany w CLAUDE.md na `done`
- [ ] **Status zsynchronizowany z platformą:**
```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{onboarding_step_id}", "status": "done"}]}'
```
- [ ] Agent sprawdził czy krok był trudny → jeśli tak, zapisał struggle do API

---

> ✅ KROK /onboarding ukończony!
