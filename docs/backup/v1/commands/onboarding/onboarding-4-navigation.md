# KROK 4: Podłączenie Welcome → Guided Onboarding → Home

## 4.1 Welcome → Guided Onboarding

Przycisk "Rozpocznij" → `Navigator.pushReplacement` → `OnboardingScreen()`
(Placeholder - później `signInAnonymously()`)

## 4.2 Guided Onboarding → Home

Po Minimal Setup (strona 7):
1. `saveFirstEntry()` zapisuje wpis przez `{Entities}Repository` (np. TasksRepository - z IDEA.md)
2. `setOnboardingCompleted()` ustawia flagę przez `ProfilesRepository`
3. `isCompleted = true` → UI nawiguje do Home

**Acceptance Criteria:**
- [ ] `BlocListener` nasłuchuje na zmianę `isCompleted` (false → true)
- [ ] `Navigator.pushReplacement` → `HomeScreen(highlightFirstEntry: true)`
- [ ] NIE używaj `_localStorageService` bezpośrednio - wszystko przez Repository!

---

### Checklista po KROKU 4:
- [ ] Welcome → Guided Onboarding działa
- [ ] Guided Onboarding → Home działa
- [ ] Nowy element podświetlony na Home

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/onboarding/onboarding-5-debug.md`
