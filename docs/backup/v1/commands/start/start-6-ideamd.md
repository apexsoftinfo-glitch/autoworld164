# KROK 6: Generowanie IDEA.md

## 6.1 Wygeneruj kompletny dokument

Na podstawie ustalonego pomysłu wypełnij WSZYSTKIE sekcje IDEA.md.
Generuj CAŁOŚĆ sam — nie pytaj usera o każdą sekcję.

**⚠️ Sekcja "Paywall Content" jest OBOWIĄZKOWA!** Wygeneruj:
- Headline i Description — konkretne, powiązane z tą aplikacją (nie generyczne "unlock premium")
- 3-5 benefitów w tabeli "What's included" — każdy z tytułem, opisem I kolumną "Implementacja"
- Kolumna "Implementacja" jest KRYTYCZNA — mówi późniejszym krokom (/screens, /limits) CO zbudować i CO zgatować

**Flow generowania benefitów:**
1. Benefit #1 = ZAWSZE "Unlimited [nazwa elementów]" → Implementacja: "Zdjęcie limitu (count)"
2. Benefit #2 = ZAWSZE "Premium Themes" lub "Dark Mode & Colors" → Implementacja: "Toggle w Settings"
3. Benefit #3-5 = przeczytaj katalog strategii w komentarzu HTML w IDEA.md template i dobierz wg:
   - **Complexity tier:** starter = TYLKO trivial/easy, master = easy/medium
   - **Typ apki:** lista → sorting/filters, tracker → insights/streaks, dziennik → history/export
   - **Balans:** mieszaj kategorie (organizacja + insights + data), NIE dawaj 3 z tej samej
4. Pisz językiem marketingowym — "Smart Insights" brzmi lepiej niż "Ekran statystyk"
5. Nawet mega prosta apka (starter) MUSI mieć minimum 3 benefity (z trivial/easy katalogu)

**WAŻNE:** Te benefity zostaną ZBUDOWANE w /screens i ZGATOWANE w /limits.
Agent w /screens przeczyta tabelę i zbuduje ekrany/feature'y Pro.
Agent w /limits przeczyta tabelę i doda if(isPro) checks.

**Na samej górze IDEA.md** (zaraz pod nagłówkiem i elevator pitch) umieść metadane:
- **App Display Name:** [nazwa wyświetlana w Store]
- **Bundle ID:** [com.imienazwisko.nazwaapki — z KROKU 4]
- **Description (EN):** [1-2 zdania po angielsku dla App Store / Google Play]

**Pole "15-Minute Win" w sekcji Złotej Niszy** — wygeneruj sam na podstawie wizji aplikacji.
Odpowiedz na pytanie: *Co konkretnie użytkownik ODCZUJE/OSIĄGNIE po 15 minutach z aplikacją?*
Pisz w pierwszej osobie lub jako konkretny rezultat — np. "Mam już zapisane 3 rzeczy, za które jestem wdzięczny — i naprawdę poczułem ulgę" albo "Widzę swoje pierwsze przemyślenie zapisane i gotowe do przejrzenia za tydzień."

**NIE generuj sekcji "Model Danych"** — model danych zostanie zaprojektowany później w `/logic`.

## 6.2 Pokaż użytkownikowi

```
Oto Twój plan aplikacji. Przeczytaj go uważnie.
Mogę coś zmienić zanim przejdziemy dalej.

Jak wszystko OK, napisz "ok".
```

**CZEKAJ na odpowiedź!**

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/start/start-7-finalize.md`
