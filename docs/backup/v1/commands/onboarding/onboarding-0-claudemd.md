# KROK 0: Rozbuduj CLAUDE.md (PIERWSZE co robisz!)

Dodaj poniższą sekcję do CLAUDE.md (wstaw ją **przed** sekcją "## Zasady dla Agenta AI"):

#### Sekcja: Flow Contract & EntryPoint Policy

~~~markdown
## Flow Contract & EntryPoint Policy

### EntryPoint Policy (KRYTYCZNE)
- `app.dart` ZAWSZE używa `home: const AppGate()` - NIGDY hardcoded screen
- Ekrany debug/warianty dostępne przez `AppNavigator`, nie przez zmianę app.dart
- Jeśli potrzebujesz testować ekran w izolacji → użyj debug menu lub DevRouter

### Flow po ukończeniu wszystkich kroków
```
AppGate (sprawdza stan)
    ↓
┌───────────────────────────────────────┐
│ Nowy user (brak onboarding)           │
│   → Welcome Screen                    │
│      → "Rozpocznij" → signInAnonymously() → Onboarding │
│      → "Zaloguj się" → Login Screen   │
│   → Onboarding (8 stron Guided Onboarding) │
│   → Home (z pierwszym elementem)      │
└───────────────────────────────────────┘
┌───────────────────────────────────────┐
│ Powracający user (ukończył onboarding)│
│   → Home Screen                       │
└───────────────────────────────────────┘
```

### Ekrany per etap

**Po /home:**
- Wybrany wireframe layout (1 z 5, reszta usunięta)
- VariantSwitcher + HomeDevRouter (tymczasowe, dla /design)

**Po /design:**
- Home Screen (finalny design)
- Design tokens w shared/theme/

**Po /screens:**
- Detail screens
- Add/Edit screens
- Settings (core: logout, delete, link account, change name, language)
- Shared components

**Po /onboarding:**
- Welcome Screen (logo + 2 przyciski)
- Onboarding (8 stron Guided Onboarding)

**Po /auth:**
- Login/Register/Reset Password
- AppGate pełna logika
- Partial SessionRepository (3/4 źródeł, bez RevenueCat)
- Profile cache (flutter_secure_storage)

**Po /limits:**
- LimitPolicy z computed tiers
- UpgradeToRegisteredDialog (dla gości)
- PaywallScreen (placeholder buttons)
- Limit check w Repository

**Po /auth:**
- RevenueCat SDK zintegrowany (logIn/logOut w auth flow)
- Pełny SessionRepository (4 źródła)
- Tier computed z isPro

**Po /localize:**
- Wszystkie stringi w PL + EN
- Przełącznik języka w Settings
~~~

Dodaj do sekcji "### NIGDY nie rób" w CLAUDE.md:

~~~markdown
- **Formularza logowania na Welcome** - Welcome = logo + 2 przyciski, login to OSOBNY ekran
- **Hardcoded home w app.dart** - ZAWSZE używaj `AppGate`, NIGDY `home: const SomeScreen()`
- **Ekranów-wysp** - każdy ekran MUSI być osiągalny przez nawigację z AppGate
~~~

Na końcu kroku (finalizacja) zaktualizuj sekcję "▶ Co dalej" w CLAUDE.md:

~~~markdown
## ▶ Co dalej

**Następny krok:** `/database` — Supabase single-user
**Instrukcje:** `.claude/commands/database.md`

> Wpisz `/database` gdy będziesz gotowy!
~~~

## 0.5 Sync status z platformą

Wyślij PATCH do platformy z nowym statusem `in_progress`:

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{onboarding_step_id}", "status": "in_progress"}]}'
```

> Wartości `{API Base URL}`, `{Platform App ID}` odczytaj z CLAUDE.md, `{API Key}` z `.env`.

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/onboarding/onboarding-1-preparation.md`
