---
description: Ask for review prompt
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob, Grep, Task, Skill
---

# /review - Ask for Review

Dodaj mechanizm proszenia o ocenę aplikacji (in-app review) z debug mode.

---

## PREREQ: Sprawdź stan projektu

1. Przeczytaj `CLAUDE.md` - sekcja "Stan projektu"
2. Sprawdź status:
   - `/limits` musi być `done`
   - Jeśli `/limits` nie jest `done` → "Najpierw wpisz `/limits` aby dodać limity."
3. Sprawdź status `/review`:
   - Jeśli `done` → "Review gotowy. Wpisz `/localize` aby kontynuować."

   - Jeśli `ready-to-test` → "Review gotowy do przetestowania. Uruchom `flutter run`, przetestuj ask for review i napisz 'ok'."
   - Jeśli `in-progress: [substatus]` → kontynuuj od tego miejsca
   - Jeśli `not-started` → rozpocznij od KROKU 1

---

## Synchronizacja z platformą

Przed rozpoczęciem:
1. Sprawdź `.env` → `PLATFORM_API_KEY`. Jeśli brak lub pusty → poproś usera:
   "Potrzebuję API Key z platformy. Wejdź na platformę → Profil → skopiuj API Key i wklej tutaj."
   Po otrzymaniu → zapisz do `.env` i zwaliduj (GET /user). Jeśli 401 → poproś ponownie.
2. Sprawdź w CLAUDE.md:
   - **Platform App ID** - ID tej aplikacji na platformie
   - **Step ID dla tego kroku** - UUID z mapowania w CLAUDE.md
3. Jeśli brakuje Platform App ID lub Step ID → "Najpierw wpisz `/start` aby połączyć z platformą."

> **UWAGA:** Sprawdzanie API Key dotyczy KAŻDEJ komendy, nie tylko /start. Klucz może wygasnąć lub zostać zregenerowany w dowolnym momencie.

---

## Sync: in_progress

Po sprawdzeniu PREREQ i synchronizacji z platformą, wyślij PATCH `in_progress`:

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{review_step_id}", "status": "in_progress"}]}'
```

---

## KROK 0: Rozbuduj CLAUDE.md (PIERWSZE co robisz!)

Ten krok nie dodaje nowych sekcji do CLAUDE.md.

Na końcu kroku (finalizacja) zaktualizuj sekcję "▶ Co dalej" w CLAUDE.md:

~~~markdown
## ▶ Co dalej

**Następny krok:** `/localize` — L10N (PL + EN) + przełącznik języka
**Instrukcje:** `.claude/commands/localize.md`

> Wpisz `/localize` gdy będziesz gotowy!
~~~

---

## KROK 1: ReviewService + ReviewDialogHelper

### 1.1 Dodaj dependency

```yaml
# pubspec.yaml
dependencies:
  in_app_review: ^2.0.8
```

```bash
flutter pub get
```

### 1.2 Utwórz ReviewService

**Lokalizacja:** `lib/core/services/review_service.dart`

**API:**
```dart
abstract class ReviewService {
  Future<void> recordSuccessfulAction();
}
```

**Logika implementacji:**
1. Przechowuj liczbę udanych akcji w LocalStorage
2. Po osiągnięciu _triggerThreshold (z IDEA.md, np. 5) → trigger review flow
3. Zapisz flagę `review_requested` żeby nie pytać ponownie

### 1.3 Utwórz ReviewDialogHelper

**Lokalizacja:** `lib/features/monetization/ui/review_dialog_helper.dart`

**Flow `maybeShowReviewDialog(context)`:**
1. Pokaż dialog: "Podoba Ci się aplikacja?" // L10N
   - "Twoja opinia pomoże nam ją rozwijać!" // L10N
   - Przyciski: "Nie" / "Tak!"
2. Jeśli "Tak!":
   - **kDebugMode:** Pokaż SnackBar "Tu będzie review dialog (debug mode)" // L10N
   - **Release:** Wywołaj `InAppReview.instance.requestReview()`

**Acceptance Criteria:**
- [ ] Dialog pojawia się po threshold udanych akcji
- [ ] W debug mode - snackbar zamiast prawdziwego review
- [ ] W release - `inAppReview.requestReview()` po sprawdzeniu `isAvailable()`
- [ ] Pytanie tylko raz (flaga w localStorage)

### 1.4 Użycie w Cubit

Po udanej akcji wywołaj `_reviewService.recordSuccessfulAction()`.

### 1.5 Aktualizuj status

W `CLAUDE.md`:
- Status `/review`: `ready-to-test`
- Kontekst: `ReviewService + ReviewDialogHelper - czeka na testy`

---

## KROK 2: Test & Feedback (OBOWIĄZKOWE!)

### 2.1 Instrukcje uruchomienia

**Dostosuj do `communication_mode` z CLAUDE.md:**

**Dla beginner:**
```
Teraz sprawdź czy ask for review działa.

Uruchom aplikację:
flutter run

Przetestuj ASK FOR REVIEW:
1. Wykonaj kilka udanych akcji (dodaj elementy)
2. Po kilku akcjach → czy pojawia się "Podoba Ci się aplikacja?"
3. Kliknij "Tak" → czy widzisz snackbar "Tu będzie review dialog"?
4. Zamknij i otwórz aplikację → czy dialog NIE pojawia się ponownie?

Jak wszystko działa, napisz "ok". Jak coś nie działa - powiedz co.
```

**Dla intermediate/advanced:**
```
`flutter run` - przetestuj:
- Ask for review: kilka udanych akcji → dialog "Podoba?" → snackbar debug
- Persystencja: po restarcie NIE pyta ponownie
Jak OK, napisz "ok".
```

### 2.2 CZEKAJ na odpowiedź usera!

- **"ok" / "działa"** → przejdź do KROKU 3 (Finalizacja)
- **brak dialogu** → sprawdź threshold i ReviewService
- **brak snackbar** → sprawdź kDebugMode
- **feedback** → wprowadź zmiany i powtórz test

---

## KROK 3: Finalizacja (TYLKO po "ok" użytkownika!)

### 3.1 Flutter analyze (OBOWIĄZKOWE!)

```bash
flutter analyze
```

**Wyczyść WSZYSTKO** - zero błędów, zero warningów, zero info!

### 3.2 Aktualizuj CLAUDE.md na done

**WARUNEK:** User potwierdził "ok".

- Status `/review`: `done`
- Kontekst: `ReviewService, ReviewDialogHelper, debug snackbar`
- Next Action: `Wpisz /localize`

### 3.3 Auto-commit

```bash
git add -A
git commit -m "feat(review): implement ask for review with debug mode

- Add in_app_review dependency
- Create ReviewService with action threshold tracking
- Create ReviewDialogHelper with debug snackbar
- Persist review_requested flag to avoid repeated prompts"
```

### 3.4 Zapowiedź następnego kroku

```
Świetnie! Ask for review gotowy!

Masz:
- ReviewService z threshold udanych akcji
- ReviewDialogHelper z debug snackbar
- Persystencja flagi (pyta tylko raz)

Ostatni krok to `/localize` - dodamy:
- flutter_localizations
- PL/EN tłumaczenia
- Przełącznik języka w Settings

Wpisz `/localize` gdy będziesz gotowy!
```

---

## Reguły dla Agenta AI

### WAŻNE
- Ask for review: dialog → debug snackbar (kDebugMode) / InAppReview (release)
- Threshold z IDEA.md (sekcja "Ask for review")
- Persystencja flagi `review_requested`

### ZAKAZY
- Ask for review na starcie aplikacji
- Ask for review przed ukończeniem onboardingu
- Wielokrotne pytanie o review (tylko raz!)
- Commit/następny krok bez potwierdzenia usera ("ok")

### Synchronizacja (OBOWIĄZKOWE)
- Przy KAŻDEJ zmianie statusu → sync z platformą
- Na końcu kroku sprawdź czy było trudno → zapisz struggle (bez pytania usera)
- Jeśli API zwraca 401 → poproś o nowy API Key

---

## Struktura plików po /review

```
lib/
├── core/
│   └── services/
│       └── review_service.dart
├── features/
│   └── monetization/
│       └── ui/
│           └── review_dialog_helper.dart
```

---

## Checklisty

### Po KROKU 1:
- [ ] in_app_review dodany
- [ ] ReviewService z threshold
- [ ] ReviewDialogHelper z debug snackbar
- [ ] Użycie w Cubit po udanej akcji
- [ ] Status ustawiony na `ready-to-test`

### Po KROKU 2:
- [ ] User przetestował ask for review
- [ ] **User potwierdził że działa ("ok")**
- [ ] Dialog pojawia się po threshold akcji
- [ ] Snackbar debug widoczny
- [ ] Nie pyta ponownie po restarcie

### Po KROKU 3 (TYLKO po "ok"!):
- [ ] CLAUDE.md zaktualizowane (status `done`)
- [ ] **Status zsynchronizowany z platformą:**
  ```bash
  curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
    -H "X-API-Key: {API Key}" \
    -H "Content-Type: application/json" \
    -d '{"steps": [{"id": "{review_step_id}", "status": "done"}]}'
  ```
- [ ] Commit wykonany
- [ ] Agent sprawdził czy krok był trudny → jeśli tak, zapisał struggle do API
