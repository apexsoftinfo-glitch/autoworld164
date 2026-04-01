# KROK 2: Discovery wizji stylu

## 2.1 Potwierdź punkt startowy

```
Wybrany layout: [opis z CLAUDE.md]

Teraz czas na styl - kolory, typografię, vibe całej aplikacji.
```

## 2.2 Zapytaj o wizję i inspiracje (JEDNO PYTANIE!)

**Połącz pytanie o wizję i inspiracje w jedno:**

```
Masz jakąś wizję jak powinna WYGLĄDAĆ aplikacja?

Możesz:
- Wrzucić screenshoty aplikacji które Ci się podobają (nie muszą być związane z tematem - chodzi o styl, kolory, vibe)
- Opisać słowami (np. "ciemna, minimalistyczna", "kolorowa i zabawna", "elegancka jak Notion")
- Powiedzieć czego NIE chcesz (np. "żadnych jaskrawych kolorów", "nie chcę korporacyjnego looku")
- Powiedzieć "nie mam wizji" - to też OK, zaproponuję 5 różnych stylów

Co wolisz?
```

## 2.3 Obsługa odpowiedzi

**Jeśli user daje screenshoty/opisuje wizję:**
1. Przeanalizuj co mu się podoba (kolory? typografia? spacing? vibe?)
2. Doprecyzuj: "Widzę że podoba Ci się [X]. Czy dobrze rozumiem, że chcesz [podsumowanie]?"
3. Dopytaj jeśli coś niejasne
4. **CZEKAJ na potwierdzenie** ("ok", "tak") ZANIM zaczniesz kodować!
5. Nawet z wizją → i tak 5 RÓŻNYCH wariantów eksplorujących tę wizję na różne sposoby

**Jeśli user nie ma wizji:**
1. "Spoko! Przygotuję 5 radykalnie różnych stylów do wyboru."
2. Przejdź do KROKU 3

**Jeśli user mówi czego NIE chce:**
1. Zapisz ograniczenia
2. "Rozumiem - unikam [X]. Przygotuję 5 różnych opcji."
3. Przejdź do KROKU 3

## 2.4 Aktualizuj status

W `CLAUDE.md`:
- Status `/design`: `in-progress: variants`
- Kontekst: `[Opis wizji/inspiracji lub "brak - agent proponuje"]`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/design/design-3-variants.md`
