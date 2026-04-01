---
description: LimitPolicy + UpgradeDialogs (Guest→Registered→Pro)
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob, Grep, Task, Skill
---

# /limits - System limitów i upgrade dialogs

Dodaj system limitów z computed tiers i upgrade dialogs.

---

## PREREQ: Sprawdź stan projektu

1. Przeczytaj `CLAUDE.md` - sekcja "Stan projektu"
2. Sprawdź status:
   - `/auth` musi być `done`
   - Jeśli `/auth` nie jest `done` → "Najpierw wpisz `/auth`."
3. Sprawdź status `/limits`:
   - Jeśli `done` → "Limity gotowe. Wpisz `/review` aby kontynuować."
   - Jeśli `ready-to-test` → "Limity gotowe do przetestowania. Uruchom `flutter run`, przetestuj limity i napisz 'ok'."
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

## Tier Computation (COMPUTED, nie stored!)

Na tym etapie tier jest wyliczany tak:

```dart
UserTier get tier {
  if (isPro) return UserTier.pro;  // isPro = false (brak RC)
  if (!isAnonymous) return UserTier.registered;
  return UserTier.guest;
}
```

**Efektywnie:**
- Anonymous user → guest
- User z email → registered
- Pro → z RevenueCat (zintegrowany w /auth)

---

## Sync: in_progress

Po sprawdzeniu PREREQ i synchronizacji z platformą, wyślij PATCH `in_progress`:

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{limits_step_id}", "status": "in_progress"}]}'
```

---

## KROK 0: Rozbuduj CLAUDE.md (PIERWSZE co robisz!)

Ten krok nie dodaje nowych sekcji do CLAUDE.md (korzysta z User Tiers z /logic).

Na końcu kroku (finalizacja) zaktualizuj sekcję "▶ Co dalej" w CLAUDE.md:

~~~markdown
## ▶ Co dalej

**Następny krok:** `/review` — Ask for review prompt
**Instrukcje:** `.claude/commands/review.md`

> Wpisz `/review` gdy będziesz gotowy!
~~~

---

## KROK 1: Skonfiguruj LimitPolicy

### 1.1 Przeczytaj IDEA.md

Znajdź sekcję "Auth & Tiery":
- Typ limitu (count/daily/weekly/monthly)
- Limit gościa (wartość)

### 1.2 Zaktualizuj app_limit_policy.dart

Plik: `lib/core/limits/app_limit_policy.dart`

```dart
const appLimitPolicy = LimitPolicy(
  type: LimitType.[z IDEA.md],
  guestLimit: [z IDEA.md],
);
```

### 1.3 Aktualizuj status

W `CLAUDE.md`:
- Status `/limits`: `in-progress: upgrade-dialog`

---

## KROK 2: LimitExceededFailure

Plik: `lib/features/monetization/models/limit_exceeded_failure.dart`

```dart
class LimitExceededFailure extends Failure {
  final UserTier tier;
  final int limit;
  final LimitType limitType;

  // Computed: jaki dialog pokazać
  UpgradeTarget get upgradeTarget => switch (tier) {
    UserTier.guest => UpgradeTarget.register,    // → UpgradeToRegisteredDialog
    UserTier.registered => UpgradeTarget.paywall, // → PaywallScreen
    UserTier.pro => throw StateError('Pro has no limit'),
  };
}

enum UpgradeTarget { register, paywall }
```

---

## KROK 3: UpgradeToRegisteredDialog

**Dla gości** - zachęca do darmowej rejestracji.

```dart
class UpgradeToRegisteredDialog extends StatelessWidget {
  final int currentLimit;
  final int registeredLimit; // = currentLimit × 3

  // CTA: "Zarejestruj się za darmo" → Navigator.pushNamed('/register')
}
```

---

## KROK 4: PaywallScreen

**Dla registered** - pokazuje opcje subskrypcji.

**RevenueCat już działa** — użyj `showPaywall()` z `lib/features/subscription/show_paywall.dart`.

```dart
// W showUpgradeDialog lub bezpośrednio:
import '../../subscription/show_paywall.dart';

// Wywołanie — RevenueCatUI.presentPaywallIfNeeded("pro")
await showPaywall();
```

---

## KROK 5: Limit check w Repository

```dart
Future<Either<Failure, void>> addItem(Item item) async {
  final session = _sessionRepository.current;
  final currentCount = await _getCount(session.userId!);

  if (!appLimitPolicy.canAdd(session.tier, currentCount)) {
    return Left(LimitExceededFailure(
      tier: session.tier,
      limit: appLimitPolicy.getLimit(session.tier)!,
      limitType: appLimitPolicy.type,
    ));
  }

  // ... dodaj normalnie
}
```

---

## KROK 6: showUpgradeDialog helper

```dart
void showUpgradeDialog(BuildContext context, LimitExceededFailure failure) {
  switch (failure.upgradeTarget) {
    case UpgradeTarget.register:
      showDialog(
        context: context,
        builder: (_) => UpgradeToRegisteredDialog(
          currentLimit: failure.limit,
          registeredLimit: failure.limit * LimitPolicy.registeredMultiplier,
        ),
      );
    case UpgradeTarget.paywall:
      showPaywall();
  }
}
```

---

## KROK 6.5: Gate Pro features z IDEA.md

### 6.5.1 Przeczytaj IDEA.md → "Paywall Content"

Znajdź tabelę "What's included" i kolumnę **"Implementacja"**.

Dla KAŻDEGO benefitu (poza #1 "Zdjęcie limitu" — to już obsługuje KROK 5):

| Implementacja w IDEA.md | Co zrobić w /limits |
|--------------------------|---------------------|
| **Toggle w Settings** (np. Dark Mode, Themes) | Owinąć widget w `if (session.isPro)` — jeśli nie Pro, pokaż locked tile z `onTap: showPaywall()` |
| **Ekran Pro-only** (np. Insights, Stats) | Dodać check przed nawigacją: `if (!session.isPro) { showPaywall(); return; }` |
| **Feature na Home/Detail** (np. Sorting, Filters) | Owinąć UI element (dropdown, chips) w `if (session.isPro)` — jeśli nie Pro, pokaż lock icon z `onTap: showPaywall()` |

### 6.5.2 Pattern dla locked feature w Settings

```dart
// Zamiast normalnego tile'a:
if (session.isPro) {
  // Normalny tile (np. ThemeModeToggle)
} else {
  ListTile(
    title: Text('Dark Mode'), // L10N
    subtitle: Text('Pro feature'), // L10N
    trailing: Icon(Icons.lock_outline),
    onTap: () => showPaywall(),
  ),
}
```

### 6.5.3 Pattern dla locked feature na ekranie (dropdown/chips)

```dart
// Sorting dropdown - basic sort free, advanced Pro:
DropdownButton(
  items: [
    DropdownMenuItem(value: 'date', child: Text('By date')), // L10N
    if (session.isPro) ...[
      DropdownMenuItem(value: 'alpha', child: Text('A-Z')), // L10N
      DropdownMenuItem(value: 'custom', child: Text('Custom')), // L10N
    ],
  ],
  // Jeśli nie Pro i chce więcej: showPaywall()
)
```

### 6.5.4 Pattern dla Pro-only ekranu

```dart
// W nawigacji lub buttonie:
onTap: () {
  if (!session.isPro) {
    showPaywall();
    return;
  }
  Navigator.pushNamed(context, '/insights');
}
```

> **Szukaj komentarzy `// PRO`** w kodzie — zostały dodane w `/screens` żeby oznaczyć co gatować.

---

## KROK 7-9: Test, Feedback, Finalizacja

**Test scenarios:**
1. Jako guest: dodawaj do limitu → UpgradeToRegisteredDialog
2. Zarejestruj się → limit × 3
3. Jako registered: dodawaj do limitu → showPaywall() (RevenueCat)
4. Jako guest/registered: tap Pro feature (dark mode, stats, etc.) → showPaywall()
5. Jako Pro: wszystkie feature'y odblokowane, brak lock icons

**Flutter analyze (OBOWIĄZKOWE!):**
```bash
flutter analyze
```
**Wyczyść WSZYSTKO** - zero błędów, zero warningów, zero info!

**Commit:**
```
feat(limits): implement tier-based limits with upgrade dialogs

- Configure LimitPolicy from IDEA.md
- Add LimitExceededFailure with computed upgradeTarget
- Add UpgradeToRegisteredDialog for guests
- Integrate showPaywall() for registered users (RevenueCat paywall)
- Add limit check in Repository
- Tier computed from isAnonymous (no stored tier!)
```

---

## Reguły

### KRYTYCZNE
- **Tier jest COMPUTED z session.tier** - NIGDY nie czytaj z DB!
- Guest → UpgradeToRegisteredDialog (rejestracja)
- Registered → PaywallScreen (placeholder)
- Paywall uses `showPaywall()` (RevenueCat already integrated)
- **Pro features z IDEA.md "Paywall Content" MUSZĄ być gated za session.isPro** (KROK 6.5)
- **Szukaj komentarzy `// PRO`** w kodzie z /screens — oznaczają co gatować

### ZAKAZY
- Kolumna `tier` w bazie
- PaywallScreen dla gości
- Hardcoded ceny (używaj RevenueCat offerings)
- Commit bez potwierdzenia usera ("ok")

### Synchronizacja (OBOWIĄZKOWE)
- Przy KAŻDEJ zmianie statusu → sync z platformą
- Na końcu kroku sprawdź czy było trudno → zapisz struggle (bez pytania usera)
- Jeśli API zwraca 401 → poproś o nowy API Key

---

## Checklisty

### Po każdym kroku:
- [ ] Kod działa (flutter analyze czyste)
- [ ] Status zaktualizowany w CLAUDE.md
### Po ostatnim kroku:
- [ ] User potwierdził "ok"
- [ ] Status: `done`
- [ ] **Status zsynchronizowany z platformą:**
  ```bash
  curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
    -H "X-API-Key: {API Key}" \
    -H "Content-Type: application/json" \
    -d '{"steps": [{"id": "{limits_step_id}", "status": "done"}]}'
  ```
- [ ] Commit wykonany
- [ ] Agent sprawdził czy krok był trudny → jeśli tak, zapisał struggle do API

---

## Struktura plików po /limits

```
lib/
├── core/
│   └── limits/
│       ├── limit_policy.dart
│       └── app_limit_policy.dart
├── features/
│   └── monetization/
│       ├── ui/
│       │   ├── upgrade_to_registered_dialog.dart
│       │   ├── paywall_screen.dart
│       │   └── show_upgrade_dialog.dart
│       └── models/
│           └── limit_exceeded_failure.dart
```
