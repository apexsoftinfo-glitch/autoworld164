# KROK 5: Debug button na Home

## 5.1 Przycisk do testowania onboardingu

Dodaj przycisk widoczny tylko w `kDebugMode`:
- `OutlinedButton.icon` z `Icons.developer_mode`
- Label: "Debug: Pokaż onboarding"
- `Navigator.push` → `WelcomeScreen(isReplay: true)` jako `fullscreenDialog`

## 5.2 WelcomeScreen z isReplay

Parametr `isReplay` (domyślnie `false`):
- `true` → AppBar z X (IconButton close → `Navigator.pop()`)
- `false` → bez AppBar (pierwszy raz)

## 5.3 Ustaw status ready-to-test

W `CLAUDE.md`:
- Status `/onboarding`: `ready-to-test`
- Kontekst: `Welcome + Guided Onboarding zbudowane, Debug button dodany`

---

### Checklista po KROKU 5:
- [ ] Debug button na Home → WelcomeScreen (tylko debug mode)
- [ ] isReplay: true pokazuje X w AppBar
- [ ] Status ustawiony na `ready-to-test`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/onboarding/onboarding-6-test.md`
