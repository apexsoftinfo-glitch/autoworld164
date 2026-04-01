# KROK 1-2: Przygotowanie i Discovery wizji layoutu

## 1.1 Przeczytaj IDEA.md

Przeczytaj `IDEA.md` - potrzebujesz:
- Sekcja "Home Screen" (layout, elementy, empty state, CTA)
- Sekcja "Złota Nisza" (co aplikacja robi, dla kogo)
- Nazwa aplikacji

## 1.2 Aktualizuj status

W `CLAUDE.md`:
- Status `/home`: `in-progress: discovery`
- Kontekst: `Czekam na wizję użytkownika`

---

## 2.1 Potwierdź zrozumienie

Powiedz użytkownikowi co zrozumiałeś z IDEA.md:
```
Przeczytałem IDEA.md i wiem o czym jest [nazwa aplikacji].

[2-3 zdania podsumowujące główną funkcję i co user będzie robił na Home Screen]
```

## 2.2 Zapytaj o wizję layoutu

**Jedno pytanie, trzy możliwości:**

```
Zanim zacznę projektować układ - masz jakąś wizję jak powinien wyglądać główny ekran?

Możesz:
- Opisać słowami co widzisz (np. "lista z kartami", "kalendarz z wydarzeniami")
- Powiedzieć czego NIE chcesz (np. "żadnych gridów", "nie chcę przeładowanego UI")
- Powiedzieć "nie mam wizji" - to też OK, zaproponuję 5 różnych opcji

Co wolisz?
```

## 2.3 Obsługa odpowiedzi

**Jeśli user opisuje wizję:**
1. Słuchaj uważnie
2. Doprecyzuj: "Czy dobrze rozumiem, że chcesz [podsumowanie]?"
3. Dopytaj jeśli coś niejasne: "A co z [element]? Gdzie go widzisz?"
4. **CZEKAJ na potwierdzenie** ("ok", "tak", "zgadza się") zanim przejdziesz dalej
5. Nawet z wizją usera → i tak 5 RÓŻNYCH wariantów eksplorujących tę wizję

**Jeśli user nie ma wizji:**
1. "Spoko! Na podstawie IDEA.md przygotuję 5 radykalnie różnych układów."
2. Przejdź do następnego kroku

**Jeśli user mówi czego NIE chce:**
1. Zapisz ograniczenia
2. "Rozumiem - unikam [X]. Przygotuję 5 różnych opcji bez tego."
3. Przejdź do następnego kroku

## 2.4 Aktualizuj status

W `CLAUDE.md`:
- Status `/home`: `in-progress: variants`
- Kontekst: `[Krótki opis wizji lub "brak wizji - agent proponuje"]`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/home/home-2-wireframes.md`
