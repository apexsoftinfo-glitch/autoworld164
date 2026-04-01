# KROK 4: Test i wybór

## 4.1 Prezentacja

Dla każdego wireframe'a:
1. Krótki opis layoutu (2-3 zdania)
2. Czym się RADYKALNIE różni od innych

## 4.2 Test (OBOWIĄZKOWE!)

Powiedz jak uruchomić (dostosuj do `communication_mode`):

**Dla beginner:**
```
Teraz uruchom aplikację żeby zobaczyć wszystkie 5 układów na żywo.

W terminalu wpisz:
flutter run

Zobaczysz wariant A. Na dole ekranu jest pasek z literami A, B, C, D, E.
Kliknij na literę żeby przełączyć się na inny wariant.

Przejrzyj wszystkie i napisz "ok" lub powiedz co nie działa.
```

**Dla intermediate/advanced:**
```
`flutter run` → wariant A, switcher A/B/C/D/E na dole.
Jak OK, napisz "ok".
```

**CZEKAJ na odpowiedź użytkownika!**
- błąd / problem → napraw i powtórz test
- "ok" / "działa" → przejdź do wyboru (4.3)

## 4.3 Wybór użytkownika

Użyj `AskUserQuestion` z opcjami dopasowanymi do WYMYŚLONYCH layoutów:

```yaml
question: "Który układ najbardziej Ci odpowiada?"
header: "Wireframe"
options:
  # GENERUJ na podstawie wymyślonych layoutów!
  # Każda opcja = OPISOWY label + description
  # NIE "A - wariant A" tylko "A - Karty z gestem swipe"
```

**Przykład formatu:**
```yaml
  - label: "A - Lista z expandable cards"
    description: "Minimalistyczna lista, tap rozwija szczegóły, swipe archiwizuje"
  - label: "B - Grid z quick actions"
    description: "Kompaktowy grid 2x3, long-press pokazuje menu, drag reorderuje"
```

---

Po wyborze → **NATYCHMIAST przeczytaj i wykonaj `.claude/commands/home/home-4-finalize.md`** (NIE kończ tury, NIE wyświetlaj komunikatu — od razu czytaj plik i rób finalizację!)
