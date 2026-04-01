# KROK 2: Wywiad (tylko dla NOWYCH użytkowników!)

> **POMIŃ ten krok** jeśli `agent_interview_completed_at` nie jest NULL.

> **ZASADA NADRZĘDNA: JEDNO PYTANIE NA RAZ.**
> Zadaj pytanie → czekaj na odpowiedź → dopiero wtedy zadaj następne.
> NIGDY nie wysyłaj kilku pytań w jednej wiadomości.

> **ZASADA ZAPISU:** Po KAŻDEJ odpowiedzi usera → `PATCH /user` z nowymi danymi w `agent_profile` (w tle).
> Rób incremental update. NIE czekaj na koniec wywiadu!
> **UWAGA:** Arraye w agent_profile są NADPISYWANE przy merge → zawsze read-modify-write (GET → merge → PATCH).

## 2.1 Pytanie o doświadczenie (jeśli brak w API)

Jeśli `initial_programming_level` jest NULL:

Użyj `AskUserQuestion`:
```yaml
question: "Jakie masz doświadczenie z programowaniem?"
header: "Doświadczenie"
options:
  - label: "Beginner"
    description: "Dopiero zaczynam, tłumacz wszystko prostym językiem"
  - label: "Intermediate"
    description: "Znam podstawy, standardowe terminy są OK"
  - label: "Advanced"
    description: "Jestem dev'em, mów technicznie, bez tłumaczeń"
```

Po odpowiedzi:
1. Zapisz do CLAUDE.md: `communication_mode: {wybór}`
2. Zapisz do API: `PATCH /user` z `initial_programming_level: {wybór}`

**CZEKAJ na odpowiedź! Dopiero potem przejdź do 2.2.**

## 2.2 Wywiad konwersacyjny - "Opowiedz o sobie"

> **TO JEST ROZMOWA, NIE ANKIETA.**
> Zaczynaj od otwartego pytania. Dopytuj naturalnie na podstawie odpowiedzi.
> Nie masz listy pytań do "odhaczenia" — masz tematy które chcesz poznać.
>
> **NIGDY nie używaj `AskUserQuestion` w wywiadzie (2.2-2.3).** Pisz zwykłym tekstem.
> AskUserQuestion z opcjami zamienia rozmowę w ankietę — user czuje się przesłuchiwany.
> Jedyny wyjątek to 2.1 (pytanie o doświadczenie).
>
> **Cel wywiadu:** Zebrać informacje potrzebne do zaproponowania pomysłu na appkę
> powiązaną z userem. Każde pytanie MUSI przybliżać Cię do tego celu.
>
> **Test pytania:** Zanim zadasz pytanie, sprawdź: "Czy odpowiedź na to pytanie
> pomoże mi zaproponować lepszy pomysł na appkę?" Jeśli nie — nie pytaj.
> Np. "ile godzin grasz w szachy?" NIE pomoże. "Co Cię wkurza w appkach szachowych?" — TAK.

**Zacznij od:**
```
Zanim przejdziemy do pomysłu na aplikację, chcę Cię lepiej poznać.
Im więcej mi powiesz, tym lepszy pomysł na aplikację razem znajdziemy.

Opowiedz mi coś o sobie - czym się zajmujesz, co Cię interesuje?
```

**CZEKAJ na odpowiedź!**

## 2.3 Dopytuj naturalnie (JEDNO pytanie na raz!)

Na podstawie odpowiedzi wybierz JEDNO pytanie doprecyzowujące i zadaj je.
Po odpowiedzi — kolejne jedno. I tak dalej.

**Tematy które chcesz poznać** (nie pytaj o wszystkie — wyłapuj z rozmowy):
- Wiek (jeśli nie padło → zapytaj naturalnie)
- Czym się zajmuje zawodowo
- Pasje, hobby — co go pochłania
- Społeczności online (FB grupy, Discord, Reddit, Strava itp.) — ile osób, jaka rola
- Co go frustruje w istniejących aplikacjach / narzędziach w swoim hobby
- Co robi ręcznie, co mogłaby robić appka (Excel, notatki, karteczki)

**Jeśli odpowiedzi są zdawkowe (jedno słowo, brak konkretu):**
```
Hej, im więcej mi powiesz, tym lepszą apkę razem wymyślimy.
Nie ma złych odpowiedzi!

Powiedz mi — o czym możesz gadać godzinami? Co Cię pochłania?
```
→ Dopytuj dalej. Nie odpuszczaj po jednowyrazowej odpowiedzi.
→ Uświadom że te informacje bezpośrednio wpłyną na jakość pomysłu.

**Jeśli wspomniał o ekspertyzie/hobby — drąż PROBLEMY i FRUSTRACJE, nie statystyki:**
- NIE pytaj "ile godzin poświęcasz?" / "jaki masz poziom?" — to nie pomoże w pomyśle
- TAK pytaj "Co Cię wkurza w istniejących appkach do tego?" / "Czego Ci brakuje?" / "Co robisz ręcznie?"
- Jeśli hobby jest ogólne (np. "fitness") → dopytaj "Co konkretnie? Siłownia, bieganie, joga?"

**Jeśli wspomniał o społeczności:**
- "Ile mniej więcej osób jest w tej grupie?"
- "Jaka jest Twoja rola - member, admin, aktywny uczestnik?"

**Kiedy kończyć wywiad:**
Gdy masz wystarczająco danych żeby:
1. Napisać 3-5 zdań podsumowania kim jest user
2. Wskazać przynajmniej 2-3 kierunki na aplikację powiązane z nim
3. Znać jego wiek, zajęcie, przynajmniej jedną pasję/ekspertyzę

## 2.4 Zbierz dane do agent_profile

Na podstawie wywiadu wypełnij `agent_profile` (PATCH /user) z polami:
- `about` — pełne podsumowanie kim jest user (wiek, zajęcie, pasje, społeczności)
- `expertise` — {area, specifics, depth: high/medium/low}
- `communities[]` — {platform, name, size, role}
- `own_problems[]` — {problem, intensity, context}
- `app_frustrations[]` — {app, issues[], what_would_fix}
- `manual_workflows[]` — co robi ręcznie, co mogłaby robić apka
- `passions`, `life_stage`, `weekly_availability`

## 2.5 Finalizuj zapis do API

Zrób finalny `PATCH /user` z:
- `agent_profile` — pełna struktura z 2.4 (merge z tym co już jest!)
- `birth_year` (jeśli jeszcze nie zapisany)
- `agent_interview_completed_at: {current ISO timestamp}` — **BEZ TEGO wywiad się powtórzy!**

> **STOP — nie idź dalej dopóki PATCH nie zwróci 200!**

## 2.6 Wygeneruj bio_suggestion i zaktualizuj CLAUDE.md

- Wygeneruj krótkie bio (1-2 zdania) → `PATCH /user` z `bio_suggestion`
- Wypełnij sekcję "Dane użytkownika" w CLAUDE.md

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/start/start-3-idea.md`
