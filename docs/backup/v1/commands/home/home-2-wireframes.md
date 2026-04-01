# KROK 3: 5 Wireframe'ów

## RÓŻNORODNOŚĆ - TO JEST KRYTYCZNE!

### 5 wireframe'ów MUSI się RADYKALNIE różnić

**Agent AI wymyśla layouty dopasowane do TEGO pomysłu na aplikację.**

Nie ma gotowych szablonów - każda aplikacja jest inna. Tracker nawyków potrzebuje innych layoutów niż lista zakupów czy dziennik.

**WYMÓG:** Każdy z 5 wireframe'ów MUSI być FUNDAMENTALNIE inny:
- **Inna organizacja treści** - lista vs grid vs karty vs timeline vs calendar vs cokolwiek innego
- **Inna gęstość informacji** - minimalistyczny (1-2 elementy na ekran) vs gęsty (10+ elementów)
- **Inny sposób interakcji** - tap vs swipe vs expand vs drag vs long-press
- **Inna hierarchia wizualna** - co jest najważniejsze? gdzie oko idzie najpierw?
- **Inny układ przestrzenny** - content na górze vs na dole vs wycentrowany vs full-bleed

**GESTY - TO JEST APLIKACJA MOBILNA! (KRYTYCZNE)**

Jeśli layout sugeruje gest - ZAIMPLEMENTUJ GO od razu! To nie jest "potem dopiszemy".

Eksploruj RÓŻNE gesty w RÓŻNYCH wireframe'ach:
- Swipe (w różnych kierunkach, na różne akcje)
- Pull to refresh
- Drag & drop / reorder
- Expand/collapse
- Long press
- Dismissable (swipe to delete/archive)

**ZAKAZ - PORAŻKA jeśli:**
- Dwa warianty są podobne (np. "lista A" i "lista B z drobnymi zmianami")
- User musi się przyglądać żeby zobaczyć różnicę (różnica musi być OCZYWISTA od razu!)
- Layout sugeruje gest ale go nie implementuje (to oszustwo UX!)
- Wszystkie 5 to warianty listy (eksploruj RÓŻNE podejścia!)

---

## 3.1 Wywołaj skill

```
Przeczytaj: .claude/skills/flutter-mobile-design/SKILL.md

Zadanie: Wymyśl i stwórz 5 FUNDAMENTALNIE różnych wireframe'ów dla Home Screen.

Kontekst z IDEA.md:
- Aplikacja: [nazwa]
- Elementy do wyświetlenia: [z IDEA.md]
- Empty state: [z IDEA.md]
- CTA: [z IDEA.md]
- Wizja użytkownika: [opis lub "brak - zaproponuj sam"]

KRYTYCZNE - MAKSYMALNA RÓŻNORODNOŚĆ:
- Wymyśl 5 layoutów które są FUNDAMENTALNIE inne od siebie
- Każdy wariant = zupełnie inna organizacja, gęstość, interakcja
- User MUSI widzieć różnicę od razu, bez przyglądania się
- ZAKAZ: dwa podobne warianty = PORAŻKA!
- Eksploruj: lista, grid, karty, timeline, calendar, tabs, sections, single-item focus...

GESTY - ZAIMPLEMENTUJ JE!
- Różne wireframe'y = różne interakcje (nie wszystkie na tap!)
- Jeśli coś WYGLĄDA na przesuwalne - MUSI być przesuwalne
- Eksploruj: swipe, drag, expand, long-press, dismiss, pull-to-refresh

Wymagania:
- Czarno-białe (bez kolorów, bez stylowania)
- Fake data (hardcoded listy)
- Każdy w osobnym pliku: home_wireframe_a.dart, home_wireframe_b.dart, etc.
- Light/dark toggle w każdym (TYMCZASOWY - tylko do preview)
- Gesty ZAIMPLEMENTOWANE, nie tylko wizualnie sugerowane!
```

## 3.2 Implementacja

Stwórz 5 plików:
```
lib/features/home/ui/variants/
├── home_wireframe_a.dart
├── home_wireframe_b.dart
├── home_wireframe_c.dart
├── home_wireframe_d.dart
└── home_wireframe_e.dart
```

## 3.3 VariantSwitcher + HomeDevRouter

**Po stworzeniu wireframe'ów, user musi móc je zobaczyć!**

Stwórz **VariantSwitcher** i **HomeDevRouter** - pełnoekranowy podgląd z instant-switch.

#### VariantSwitcher (`lib/features/home/ui/variant_switcher.dart`)

Reusable widget do przełączania wariantów.

**Parametry:**
- `variants` - lista widgetów do wyświetlenia
- `labels` - krótkie etykiety (np. ['A', 'B', 'C', 'D', 'E'])
- `selectedColor` - kolor wybranego przycisku (czerwony dla wireframes)

**Acceptance criteria:**
- [ ] Content zajmuje cały dostępny obszar (Expanded)
- [ ] Switcher bar na dole ekranu (POD contentem, nie overlay)
- [ ] IndexedStack dla instant-switch bez przeładowania
- [ ] SafeArea tylko na dole (top: false)
- [ ] Przyciski w Row, wycentrowane, zaokrąglone (borderRadius: 20)
- [ ] Wybrany: selectedColor + biały tekst + bold
- [ ] Niewybrany: szare tło + szary tekst

#### HomeDevRouter (`lib/features/home/ui/home_dev_router.dart`)

Tymczasowy router używający VariantSwitcher.

**Dla wireframe'ów:** selectedColor = Colors.red

#### Podłączenie do AppGate

W `lib/app/router/app_gate.dart` zamień import HomeScreen na HomeDevRouter.

## 3.4 Aktualizuj status

W `CLAUDE.md`:
- Status `/home`: `in-progress: testing`
- Kontekst: `5 wireframe'ów gotowych do testu`

## 3.5 Mini-commit

```bash
git add lib/features/home/ui/
git commit -m "wip(wireframes): add 5 wireframe variants with VariantSwitcher"
```

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/home/home-3-test.md`
