# KROK 1: Przygotowanie

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

## UWAGA: Usuń istniejący onboarding

Jeśli istnieje `lib/features/onboarding/` → usuń cały folder. Budujemy od zera.

---

## 1.1 Przeczytaj IDEA.md

Przeczytaj sekcję "Onboarding (Guided Onboarding)" z `IDEA.md`:
- Wizualizacja Problemu (co pokazać)
- Wizualizacja Rozwiązania (co pokazać)
- Demo Experience (co user może kliknąć)
- Minimal Setup - pola

## 1.2 Przeczytaj Design System (OBOWIĄZKOWE!)

Przeczytaj sekcję **"Design System"** z `CLAUDE.md`:
- Wireframe (layout)
- Design (styl)
- Vibe (klimat)
- Paleta kolorów
- Typography

**KRYTYCZNE:** Wszystkie ekrany onboardingu MUSZĄ używać tego samego stylu co Home Screen!
- Używaj tych samych tokenów z `lib/shared/theme/`
- Ten sam vibe (jeśli Home jest "Zen/Calm" → onboarding też spokojny)
- Ta sama paleta kolorów
- Ta sama typografia

## 1.3 Przeczytaj skill

Przeczytaj `.claude/skills/guided-onboarding/SKILL.md` dla szczegółowych wytycznych Guided Onboarding flow.

## 1.4 Aktualizuj status

W `CLAUDE.md`:
- Status `/onboarding`: `in-progress: welcome`
- Kontekst: `Budowanie Welcome screen`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/onboarding/onboarding-2-welcome.md`
