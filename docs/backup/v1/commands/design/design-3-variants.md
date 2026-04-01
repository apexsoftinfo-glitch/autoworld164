# KROK 3: 5 Designów

## RÓŻNORODNOŚĆ - TO JEST KRYTYCZNE!

### 5 designów MUSI się RADYKALNIE różnić

**Agent AI wymyśla style dopasowane do charakteru aplikacji.**

**WAŻNE:** Wybrany wireframe to INSPIRACJA, nie sztywna rama! Design może modyfikować layout - przesuwać elementy, zmieniać proporcje, dodawać przestrzeń.

**WYMÓG:** Każdy z 5 designów MUSI mieć zupełnie inny vibe:
- **Paleta kolorów** - mono vs żywe vs pastele vs ciemne vs neon vs earth tones
- **Typografia** - serif vs sans vs mono vs display vs handwritten vs mixed sizes
- **Nastrój** - spokojny vs energiczny vs elegancki vs zabawny vs brutalny vs minimalistyczny
- **Kształty** - ostre vs zaokrąglone vs organiczne vs geometryczne
- **Spacing** - tight vs airy vs asymetryczny
- **Domyślny tryb** - niektóre DARK, inne LIGHT (nie wszystkie takie same!)

**ZAKAZ - PORAŻKA jeśli:**
- Dwa designy są podobne (np. "minimalizm A" i "minimalizm B")
- "Zmiana koloru przycisku" to NIE jest nowy design!
- Wszystkie designy mają ten sam domyślny tryb (light/dark)
- User musi się przyglądać żeby zobaczyć różnicę

**Think out of the box!**
- Co jeśli tekst byłby OGROMNY? Albo mikroskopijny?
- Co jeśli główny element byłby na dole ekranu?
- Co jeśli użyć nietypowej czcionki?
- Co jeśli asymetria zamiast symetrii?
- Co jeśli gradient zamiast flat?
- Co jeśli shadows vs flat vs neumorphism?

---

## 3.1 NAJPIERW PRZEMYŚL (OBOWIĄZKOWE!)

**ZATRZYMAJ SIĘ. Nie koduj jeszcze.**

Zanim napiszesz linijkę kodu, przemyśl:
1. Jakie 5 RADYKALNIE różnych kierunków stylistycznych ma sens?
2. Jak każdy zmieni nie tylko kolory, ale też proporcje, spacing?
3. Które będą domyślnie DARK, a które LIGHT?
4. Jakie nietypowe czcionki/rozmiary mogę użyć?
5. Co jest "out of the box"?

## 3.2 Wywołaj skill

```
Przeczytaj: .claude/skills/flutter-mobile-design/SKILL.md

Zadanie: Wymyśl i stwórz 5 FUNDAMENTALNIE różnych designów bazując na wybranym wireframe.

Kontekst:
- Wybrany wireframe: [opisowy opis z CLAUDE.md]
- Aplikacja: [nazwa]
- Wireframe to INSPIRACJA - możesz modyfikować proporcje, spacing, rozmieszczenie!
- Wizja/inspiracje użytkownika: [opis lub "brak - zaproponuj sam"]

KRYTYCZNE - MAKSYMALNA RÓŻNORODNOŚĆ:
- Każdy design = zupełnie INNY vibe, nie wariant tego samego
- Różnicuj WSZYSTKO: paletę, typografię, nastrój, kształty, spacing
- Różne DOMYŚLNE tryby (niektóre dark, niektóre light!)
- ZAKAZ: dwa podobne style = PORAŻKA!
- User MUSI widzieć różnicę od razu!

Think out of the box:
- Eksperymentuj z typografią! Serif, mono, display, handwritten, mixed sizes
- Eksperymentuj z kolorami! Mono, neon, pastele, earth tones, gradients
- Eksperymentuj z kształtami! Ostre, zaokrąglone, organiczne, asymetryczne

Wymagania:
- Pełne kolory i stylowanie
- Light/dark mode toggle w każdym (TYMCZASOWY)
- Różne DOMYŚLNE tryby (nie wszystkie light lub dark!)
- Fake data
- Każdy w osobnym pliku: home_design_a.dart, etc.
```

## 3.3 Implementacja

Stwórz 5 plików:
```
lib/features/home/ui/variants/
├── home_wireframe_[x].dart  # wybrany z /home (nie ruszaj!)
├── home_design_a.dart
├── home_design_b.dart
├── home_design_c.dart
├── home_design_d.dart
└── home_design_e.dart
```

## 3.4 Aktualizacja DevRouter

Zaktualizuj HomeDevRouter:
- Zamień importy wireframe'ów na designy
- Zmień selectedColor z Colors.red na Colors.black

## 3.5 Aktualizuj status

W `CLAUDE.md`:
- Status `/design`: `in-progress: testing`
- Kontekst: `5 designów gotowych do testu`

## 3.6 Mini-commit

```bash
git add lib/features/home/ui/
git commit -m "wip(design): add 5 design variants"
```

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/design/design-4-test.md`
