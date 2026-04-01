# KROK 8: Weryfikacja

### 8.1 Uruchom testy

```bash
flutter test
```

### 8.2 Uruchom analizę

```bash
flutter analyze
```

### 8.3 Smoke test

1. Uruchom aplikację
2. Przejdź przez Guided Onboarding
3. Dodaj element → czy pojawia się na liście?
4. Edytuj → czy zapisuje?
5. Usuń → czy znika?

### 8.4 Ustaw status ready-to-test

W `CLAUDE.md`:
- Status `/logic`: `ready-to-test`

---

# KROK 9: Test & Feedback (OBOWIĄZKOWE!)

### 9.1 Instrukcje uruchomienia

**Dostosuj do `communication_mode` z CLAUDE.md:**

**Dla beginner:**
```
Teraz sprawdź czy logika działa.

Najpierw uruchom testy:
flutter test

Potem uruchom aplikację:
flutter run

Przetestuj:
1. Przejdź przez onboarding (lub użyj Debug button)
2. Na Home → dodaj nowy element → czy pojawia się na liście?
3. Kliknij element → czy Detail pokazuje dane?
4. Edytuj element → zapisz → czy zmiany widoczne?
5. Usuń element → czy znika z listy?

Jak testy przechodzą i aplikacja działa, napisz "ok".
Jak coś nie działa - powiedz co.
```

**Dla intermediate/advanced:**
```
`flutter test` → wszystko zielone?
`flutter run` → CRUD smoke test (add/edit/delete).
Stream updates działają real-time?
Jak OK, napisz "ok".
```

### 9.2 CZEKAJ na odpowiedź usera!

- **błąd / testy nie przechodzą** → napraw i powtórz
- **feedback** → wprowadź zmiany i powtórz pytania
- **"ok" / "wszystko działa"** → **NATYCHMIAST przeczytaj i wykonaj `.claude/commands/logic/logic-10-finalize.md`** (NIE kończ tury, NIE wyświetlaj komunikatu — od razu czytaj plik i rób finalizację!)
