# KROK 6: Test & Feedback (OBOWIĄZKOWE!)

## 6.1 Instrukcje uruchomienia

**Dostosuj do `communication_mode` z CLAUDE.md:**

**Dla beginner:**
```
Teraz sprawdź czy onboarding działa.

W terminalu wpisz:
flutter run

Przetestuj cały flow:
1. Welcome → "Rozpocznij" → powinien przejść do Guided Onboarding
2. Strona 1 (Imię) → wpisz coś → Dalej
3. Strona 2 (Preview) → czy pokazuje Twoje imię?
4. Strona 3 (Problem) → czy wizualizacja pasuje do IDEA.md?
5. Strona 4 (Solution) → czy wizualizacja pokazuje rozwiązanie?
6. Strona 5 (Experience) → kliknij 2-3 elementy demo
7. Strona 6 (Bridge) → "Twoja kolej!"
8. Strona 7 (Minimal Setup) → wypełnij 1-2 pola → Dodaj
9. Home → czy Twój element jest podświetlony?

Na Home znajdź przycisk "Debug: Pokaż onboarding" i sprawdź czy replay działa (X w AppBar).

Jak będzie OK, napisz "ok". Jak coś nie działa - powiedz co.
```

**Dla intermediate/advanced:**
```
`flutter run` - przetestuj Welcome→Guided Onboarding→Home.
Sprawdź: wizualizacje Problem/Solution, Experience clicks, Minimal Setup, element podświetlony na Home.
Debug button → Welcome → Guided Onboarding, isReplay działa.
Jak OK, napisz "ok".
```

## 6.2 Zadaj konkretne pytania

Po testach usera, zapytaj:

```
Świetnie że przetestowałeś! Mam kilka pytań:

1. **Welcome Screen** - animacja logo wygląda dobrze? Przyciski czytelne?
2. **Strona Problem** - wizualizacja pokazuje problem z IDEA.md? Zrozumiała?
3. **Strona Solution** - widać różnicę między problemem a rozwiązaniem?
4. **Strona Experience** - klikanie działa płynnie? Demo jest jasne?
5. **Minimal Setup** - tylko 1-2 pola? Łatwe do wypełnienia?
6. **Home z elementem** - element jest podświetlony/wyróżniony?

Coś chciałbyś zmienić w onboardingu zanim zrobimy commit?
```

## 6.3 CZEKAJ na odpowiedź usera!

- **błąd / problem** → napraw i powtórz test
- **feedback (np. "zmień tekst", "inna animacja")** → wprowadź zmiany i powtórz pytania
- **"ok" / "wszystko git"** → **NATYCHMIAST przeczytaj i wykonaj `.claude/commands/onboarding/onboarding-7-finalize.md`** (NIE kończ tury, NIE wyświetlaj komunikatu — od razu czytaj plik i rób finalizację!)
