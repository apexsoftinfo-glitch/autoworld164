# KROK 4: Test i wybór

## 4.1 Prezentacja

Dla każdego designu:
1. Nazwa stylu i vibe (2-3 słowa)
2. Paleta kolorów
3. Typografia
4. Domyślny tryb (light/dark)
5. Czym się RADYKALNIE różni od innych

## 4.2 Test (OBOWIĄZKOWE!)

Powiedz jak uruchomić (dostosuj do `communication_mode`):

**Dla beginner:**
```
Uruchom aplikację żeby zobaczyć wszystkie 5 stylów na żywo.

flutter run

Zobaczysz design A. Na dole ekranu jest pasek A, B, C, D, E.
Kliknij na literę żeby przełączyć się na inny styl.

Przejrzyj wszystkie i napisz "ok" lub powiedz co nie działa.
```

**Dla intermediate/advanced:**
```
`flutter run` → design A, switcher A/B/C/D/E na dole.
Jak OK, napisz "ok".
```

**CZEKAJ na odpowiedź użytkownika!**

## 4.3 Wybór użytkownika

Użyj `AskUserQuestion` z opcjami dopasowanymi do WYMYŚLONYCH stylów:

```yaml
question: "Który styl najbardziej Ci się podoba?"
header: "Design"
options:
  # GENERUJ na podstawie wymyślonych stylów!
  # OPISOWE labele, nie "A - wariant A"
```

**Przykład formatu:**
```yaml
  - label: "A - Dark Minimal"
    description: "Ciemne tło, biała typografia, dużo przestrzeni, akcenty cyan"
  - label: "B - Warm Organic"
    description: "Kremowe tło, zaokrąglone kształty, earth tones, serif headers"
```

---

Po wyborze → **NATYCHMIAST przeczytaj i wykonaj `.claude/commands/design/design-5-finalize.md`** (NIE kończ tury, NIE wyświetlaj komunikatu — od razu czytaj plik i rób finalizację!)
