# KROK 2: Welcome Screen

## 2.1 Wywołaj skill

```
Przeczytaj: .claude/skills/flutter-mobile-design/SKILL.md

Zadanie: Zbuduj Welcome Screen W STYLU z Design System (CLAUDE.md)!

Design System z CLAUDE.md:
- Vibe: [skopiuj z CLAUDE.md]
- Paleta: [skopiuj z CLAUDE.md]
- Typography: [skopiuj z CLAUDE.md]
- Charakterystyka: [skopiuj z CLAUDE.md]

Wymagania:
- Logo aplikacji (używaj ikony z Design System, NIE generyczne koło!)
- Animacja wejścia logo: scale (0.5→1.0) + fade, 600-800ms, elasticOut
- Nazwa aplikacji (fade-in po logo)
- Tagline/subtitle pod nazwą
- Dwa przyciski (fade-in na końcu):
  - "Rozpocznij" → placeholder (później signInAnonymously → Onboarding)
  - "Mam konto" → snackbar "Wkrótce"
- **"Made with ❤️ by [imię i nazwisko]"** - na dole ekranu (mały tekst, secondary color)
  - Pobierz imię i nazwisko z CLAUDE.md → "Dane użytkownika"
  - Pokazuje że wszystkie aplikacje są od tego samego twórcy
  - User może użyć istniejącego konta z innej aplikacji
- Użyj tokenów z shared/theme/ (te same co Home!)
- Light/dark mode

UWAGA:
- To NIE jest formularz! Tylko logo + 2 przyciski + "made with"
- NIE pokazuj pól email/hasło
- NIE używaj generycznego kolorowego koła jako logo
- Styl MUSI być spójny z Home Screen!
```

## 2.2 Implementacja

Stwórz: `lib/features/welcome/ui/welcome_screen.dart`

## 2.3 Aktualizuj status

- Status `/onboarding`: `in-progress: guided-onboarding`
- Kontekst: `Welcome gotowy, budowanie Guided Onboarding`

---

### Checklista po KROKU 2:
- [ ] Welcome screen z logo i animacją
- [ ] "Made with ❤️ by [imię i nazwisko]" na dole Welcome
- [ ] Styl spójny z Home Screen (Design System)
- [ ] "Rozpocznij" placeholder → Guided Onboarding
- [ ] "Mam konto" → snackbar "Wkrótce"

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/onboarding/onboarding-3-guided.md`
