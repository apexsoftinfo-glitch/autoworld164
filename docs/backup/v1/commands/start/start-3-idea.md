# KROK 3: Pomysł na aplikację

## 3.1 Pobierz publiczne aplikacje (w tle, bez pokazywania userowi)

```bash
curl -s {API Base URL}/apps/community \
  -H "X-API-Key: {API Key}"
```

Przechowaj listę w pamięci — użyjesz jej przy unikaniu duplikatów. NIE pokazuj userowi listy.

## 3.2 Czy ma pomysł?

**Dla nowego użytkownika (po wywiadzie):**
```
Świetnie, mam Twój obraz!

Teraz najważniejsze - masz już pomysł na swoją aplikację,
czy wolisz żebym pomógł Ci go znaleźć?
```

**Dla powracającego użytkownika:**
```
Masz już pomysł na kolejną aplikację,
czy chcesz żebym pomógł go znaleźć?
```

**CZEKAJ na odpowiedź!**

---

## 3.3a Jeśli TAK - ma pomysł

1. **Wysłuchaj** — niech opisze swój pomysł. **CZEKAJ na odpowiedź!**
2. **ZAPISUJ CYTATY!** — Dokładne słowa użytkownika
3. **Dopytaj** o szczegóły (JEDNO pytanie na raz!):
   - Jaki problem rozwiązuje?
   - Dla kogo jest ta aplikacja?
   - Dlaczego Ty chcesz ją zbudować?
4. **Zapisz pomysł w agent_profile** — nawet jeśli go później uprości, to może do niego wrócić z większym doświadczeniem
5. **Sprawdź duplikaty** — porównaj z listą z GET /apps/community:
   - Jeśli podobna apka istnieje: "Widzę że {X} osób już robi coś podobnego. Może chcesz się wyróżnić czymś innym albo podejść z innej strony?"
6. **Delikatnie zwaliduj** — jeśli pomysł jest zbyt szeroki:
   - NIE mów "to za trudne"
   - POWIEDZ "Super pomysł! Zaproponuję jak go uprościć do wersji, którą zbudujesz w miesiąc"
7. **Zaproponuj SLC (Simple, Lovable, Complete)**
8. **Pomóż zawęzić niszę** — jeśli pomysł jest ogólny, pomóż znaleźć konkretną grupę odbiorców

→ Przejdź do 3.5 (Weryfikacja)

---

## 3.3b Jeśli NIE - nie ma pomysłu → Discovery Flow

> **„Autor sukcesywnej aplikacji spędzał większość czasu na zrozumieniu problemu,
> a rozwiązania przychodziły prawie automatycznie."**
>
> Nie śpieszymy się z pomysłem. Najpierw kierunek, potem research, potem pomysł.

### FAZA 1: Wybór kierunku

Na podstawie danych z wywiadu (agent_profile) zaproponuj **3-5 kierunków** (NIE gotowych pomysłów!).

Kierunek = obszar/temat powiązany z userem, w którym będziemy szukać problemu do rozwiązania.

```markdown
Na podstawie tego co mi powiedziałeś, widzę kilka ciekawych kierunków:

1. **[Kierunek 1]** — [1 zdanie dlaczego pasuje do usera]
2. **[Kierunek 2]** — [1 zdanie dlaczego pasuje do usera]
3. **[Kierunek 3]** — [1 zdanie dlaczego pasuje do usera]

Który z tych kierunków Cię najbardziej ciągnie?
```

Użyj `AskUserQuestion` z kierunkami jako opcjami.

**CZEKAJ na odpowiedź!**

### FAZA 2: Research na Reddit

> **POMIŃ tę fazę przy complexity_tier == starter (apki 1-3)** — od razu przejdź do FAZY 3.
> Przy pierwszych apkach user nie potrzebuje researchu, celem jest publikacja prostej apki.

Poproś usera żeby poszukał na Reddit PROBLEMÓW i FRUSTRACJI w wybranym kierunku:
- Zaproponuj 2-3 subreddity pasujące do kierunku (linki z `/top/?t=year`)
- Podaj frazy do wyszukania: "frustrated with", "I wish", "is there an app", "looking for"
- Poproś o wklejenie 2-3 postów z komentarzami

**Jeśli user nie chce robić researchu** → generuj pomysły sam na podstawie `agent_profile` i listy publicznych apek. Uprzedź że pomysły będą mniej trafne.

**CZEKAJ na odpowiedź!**

### FAZA 3: Analiza i propozycja pomysłu

Na podstawie researchu (lub agent_profile jeśli brak researchu):
1. Zidentyfikuj realny problem
2. Wygeneruj 3-5 pomysłów — każdy z: elevator pitch, problem, dlaczego pasuje do usera, nisza
3. Oznacz rekomendację ⭐
4. Stosuj 5 ZASAD GENEROWANIA POMYSŁÓW (patrz sekcja "Reguły" na dole tego pliku)

Użyj `AskUserQuestion` z pomysłami jako opcjami. **CZEKAJ na odpowiedź!**

---

## 3.5 Weryfikacja pomysłu

**ZANIM przejdziesz dalej, MUSISZ przejść te 3 kroki (każdy osobno, czekaj na odpowiedź!):**

**Krok A: Podsumowanie**
Przedstaw swoje rozumienie pomysłu (3-5 zdań). Oceń mocne strony i potencjał.
```
Lecimy z tym czy chcesz coś zmienić?
```
**CZEKAJ na odpowiedź!**

**Krok B: Weryfikacja "czy będziesz tego używać?"**
Zapytaj czy sam będzie korzystać. Jeśli nie → delikatnie przekonaj (najlepsze apki robi się dla siebie). Jeśli się uprze → przepuść, nie blokuj.
**CZEKAJ na odpowiedź!**

**Krok C: Ustalenie limitów**

Limity są zawsze **ilościowe** (max X elementów ogółem). Agent sam decyduje o wartości na podstawie pomysłu na aplikację i informuje usera:

```
Limity w aplikacji będą ilościowe (max X elementów).
Limit dla gościa: [wartość, np. "5 wpisów"]. Registered: [3× wartość]. Pro: bez limitu.

Jeśli chcesz inną wartość — daj znać, ale to powinno dobrze działać.
```

NIE pytaj o typ limitu. NIE pytaj o wartość — sam ją dobierz sensownie do kontekstu aplikacji.

---

## Reguły dla tego kroku

### 5 ZASAD GENEROWANIA POMYSŁÓW
1. **Nic unikalnego** — rób coś co już istnieje, ludzie lubią alternatywy
2. **Proste** — micro app, minimalna ilość ekranów, zbudujesz w miesiąc
3. **Nisza** — bardzo wąska grupa, NIE "dla wszystkich" (nie "habit tracker" → "habit tracker dla biegaczy maratończyków")
4. **Powiązane z tobą** — wynika z wywiadu, twórca sam chce używać
5. **Dostosuj do tieru** — starter = mega prosty (kalkulator/lista/tracker), master = pushuj AI

### ZAKAZY
- Generyczne pomysły bez niszy
- Pomysły PRZED wywiadem (dla nowych)
- Wysyłanie kilku pytań w jednej wiadomości

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/start/start-4-app.md`
