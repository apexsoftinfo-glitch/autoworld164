# KROK 5: Sprzątanie i zapis

> **⚠️ WYKONAJ NATYCHMIAST po wyborze usera! Nie wyświetlaj komunikatu i nie czekaj — od razu rób poniższe kroki.**

## 5.1 Usuń niewybrany warianty

**OBOWIĄZKOWE!** Zostaw TYLKO wybrany wireframe:

```bash
# Przykład jeśli user wybrał B:
rm lib/features/home/ui/variants/home_wireframe_a.dart
rm lib/features/home/ui/variants/home_wireframe_c.dart
rm lib/features/home/ui/variants/home_wireframe_d.dart
rm lib/features/home/ui/variants/home_wireframe_e.dart
# Zostaje tylko home_wireframe_b.dart
```

## 5.2 Zapisz wybór w CLAUDE.md

**OBOWIĄZKOWE!** Zaktualizuj sekcję "Design System" - pole Wireframe:

```markdown
- **Wireframe:** [OPISOWY opis wybranego layoutu, np. "Expandable cards - minimalistyczna lista z kartami które rozwijają się po tap, swipe w lewo archiwizuje element"]
```

**WAŻNE:** NIE pisz "Wireframe: B" - to nic nie znaczy! Opisz CO jest w tym wireframe.

## 5.3 Flutter analyze

```bash
flutter analyze
```

**Wyczyść WSZYSTKO** - zero błędów, zero warningów, zero info!

## 5.4 Aktualizuj status na done

W `CLAUDE.md`:
- Status `/home`: `done`
- Kontekst: `[Krótki opis wybranego layoutu]`
- Next Action: `Wpisz /design`

## 5.5 Commit

```bash
git add -A
git commit -m "feat(wireframes): select home screen layout

- Choose layout: [opisowy opis]
- Remove unused wireframe variants
- Keep VariantSwitcher for design phase"
```

## 5.6 Następny krok

> Dopiero TERAZ (po ustawieniu done + commit) wyświetl komunikat userowi:

```
Wireframe wybrany! Commit wykonany.
Wpisz `/design` gdy będziesz gotowy.
```

---

## Reguły dla Agenta AI

### KRYTYCZNE
- **MAKSYMALNA RÓŻNORODNOŚĆ** - 5 wariantów musi być FUNDAMENTALNIE różnych
- **Implementuj gesty** jeśli layout je sugeruje - to aplikacja mobilna!
- **Po wyborze POSPRZĄTAJ** - usuń niewybrany warianty, zostaw tylko jeden
- **Opisowo w CLAUDE.md** - nie "Wireframe: B" tylko pełny opis layoutu
- **flutter analyze** przed commitem - zero problemów!

### WAŻNE
- Wymyślaj layouty dopasowane do docs/IDEA.md
- Light/dark toggle w każdym wariancie
- Fake data (nie puste ekrany)
- Czekaj na "ok" usera przed generowaniem (jeśli ma wizję)
- Instrukcje testowe dostosowane do communication_mode

### ZAKAZY
- **NIGDY** dwa podobne warianty - to PORAŻKA!
- **NIGDY** layout sugerujący gest bez implementacji - to OSZUSTWO!
- **NIGDY** pytaj o wybór bez wcześniejszego testu
- **NIGDY** przechodź do /design bez sprzątania
- **NIGDY** zostawiaj niewybranych wariantów w kodzie

### Synchronizacja (OBOWIĄZKOWE)
- Przy KAŻDEJ zmianie statusu → sync z platformą
- Na końcu kroku sprawdź czy było trudno → zapisz struggle (bez pytania usera)
- Jeśli API zwraca 401 → poproś o nowy API Key

---

## Struktura plików po /home

```
lib/features/home/ui/
├── variants/
│   └── home_wireframe_[x].dart  # TYLKO wybrany!
├── variant_switcher.dart        # Zostaje dla /design
└── home_dev_router.dart         # Zostaje dla /design
```

---

## Checklist

- [ ] docs/IDEA.md przeczytane
- [ ] User zapytany o wizję layoutu
- [ ] Jeśli ma wizję → doprecyzowane i potwierdzone ("ok")
- [ ] 5 wireframe'ów RADYKALNIE różnych
- [ ] VariantSwitcher + HomeDevRouter działają
- [ ] User przetestował wszystkie warianty
- [ ] User wybrał jeden wireframe
- [ ] Niewybrany warianty USUNIĘTE
- [ ] CLAUDE.md zaktualizowane (opisowy opis wireframe'a!)
- [ ] `flutter analyze` = zero problemów
- [ ] Commit wykonany
- [ ] User poinformowany o `/design`
- [ ] Status zaktualizowany w CLAUDE.md na `done`
- [ ] **Status zsynchronizowany z platformą:**
```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{home_step_id}", "status": "done"}]}'
```
- [ ] Agent sprawdził czy krok był trudny → jeśli tak, zapisał struggle do API

---

> ✅ KROK /home ukończony!
