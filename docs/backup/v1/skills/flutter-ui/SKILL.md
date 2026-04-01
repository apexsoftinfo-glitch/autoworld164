---
name: flutter-ui
description: Use when creating screens, widgets, forms, layouts, buttons, styling, animations, error displays, validation UI. CRITICAL - errors must be inline SelectableText (NOT Snackbar!). Snackbar only for success. (project)
---

# Skill: Flutter UI & UX

Odpowiada za warstwę prezentacji (`lib/features/.../ui/` oraz `lib/shared/widgets/`).

## Pamięć Projektu (Self-Learning)
*Tutaj Agent AI zapisuje poznane preferencje UI za pomocą skilla `reflect`.*

- Limit 100-150 linii dotyczy pojedynczych widgetów/klas, NIE plików. Pliki mogą mieć do 1000 linii jeśli zawierają wiele małych, wyekstrahowanych widgetów.

---

## Tworzenie Nowego Ekranu

### Struktura pliku
```dart
class <Nazwa>Screen extends StatelessWidget {
  const <Nazwa>Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<<Nazwa>Cubit>()..init(),
      child: const _<Nazwa>View(),
    );
  }
}

class _<Nazwa>View extends StatelessWidget {
  const _<Nazwa>View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tytuł')), // L10N
      body: BlocBuilder<<Nazwa>Cubit, <Nazwa>State>(
        builder: (context, state) {
          return state.when(
            initial: () => const _InitialView(), // NIE spinner! Zabezpieczenie
            loading: () => const _LoadingView(),
            loaded: (data) => _LoadedView(data: data),
            error: (message) => _ErrorView(message: message),
          );
        },
      ),
    );
  }
}
```

### Prywatne widgety (ekstrakcja)
```dart
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _LoadedView extends StatelessWidget {
  final Data data;
  const _LoadedView({required this.data});
  // ...
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SelectableText(message), // Błędy jako SelectableText!
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  // ...
}
```

---

## Standardy Kodowania UI

### Widgety
- **Max 100-150 linii**. Ekstrakcja do prywatnych klas (`class _Header extends...`), NIE metod (`_buildHeader()`).
- Widgety używane w >1 miejscu przenieś do `shared/widgets/`.

### UX & Interakcje
- **Błędy:** Wyświetlaj inline jako `SelectableText` (kopiowalne).
- **Loading:**
    - Pierwsze ładowanie (`init`) -> Pełny spinner/Skeleton.
    - Odświeżanie (`refresh`) -> `RefreshIndicator` (bez blokowania UI).
    - Akcje (`save/delete`) -> Blokada interakcji (`AbsorbPointer`) lub loading na przycisku.
- **Snackbary:** TYLKO dla potwierdzenia sukcesu lub błędu przy odświeżaniu (gdy dane są widoczne).
- **Klawiatura:** `GestureDetector` na `Scaffold` do chowania klawiatury (`unfocus`).
- **Pola tekstowe:** Domyślnie `TextCapitalization.sentences`. Wyjątki: email, login, password.

### Keyboard Dismiss
Każdy ekran z TextField musi chować klawiaturę przy tap poza pole:
```dart
GestureDetector(
  onTap: () => FocusScope.of(context).unfocus(),
  child: Scaffold(...),
)
```

### Haptic Feedback
Przy ważnych buttonach używaj `HapticFeedback.lightImpact()`.

---

## Transactional UI (Pessimistic Updates)

UI odzwierciedla **potwierdzony** stan backendu.

### Lista z operacjami per-element
- `ItemStatus.loading()` -> blokuj CAŁY wiersz (edit, delete, checkbox - wszystko)
- Sukces -> odblokuj i zaktualizuj dane
- Error -> odblokuj i pokaż inline error

### Dedykowany ekran add/edit (Form)
```dart
BlocListener<<Nazwa>FormCubit, <Nazwa>FormState>(
  listener: (context, state) {
    state.whenOrNull(success: () => Navigator.of(context).pop());
  },
  child: BlocBuilder<<Nazwa>FormCubit, <Nazwa>FormState>(
    builder: (context, state) {
      return state.maybeWhen(
        editing: (formData, isSaving, errorMessage) {
          return AbsorbPointer(
            absorbing: isSaving,
            child: Column(
              children: [
                TextField(enabled: !isSaving, /* ... */),
                if (errorMessage != null)
                  SelectableText(errorMessage, style: /* error style */),
                FilledButton(
                  onPressed: isSaving ? null : () => context.read<<Nazwa>FormCubit>().save(),
                  child: isSaving
                      ? const CircularProgressIndicator()
                      : const Text('Zapisz'), // L10N
                ),
              ],
            ),
          );
        },
        orElse: () => const SizedBox.shrink(),
      );
    },
  ),
)
```

**Kluczowe:**
- `isSaving: true` -> cały formularz zablokowany (`AbsorbPointer` + `enabled: false`)
- `Navigator.pop()` TYLKO po `success` (NIE przed potwierdzeniem od backendu)
- Error -> zostajemy na ekranie, dane w polach zachowane

---

## Pull-to-refresh (UI)

```dart
RefreshIndicator(
  onRefresh: () => context.read<<Nazwa>Cubit>().refresh(),
  child: ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(), // WYMAGANE!
    itemCount: items.length,
    itemBuilder: (context, index) => /* ... */,
  ),
)
```

**Kluczowe:**
- `refresh()` (NIE `init()`) - patrz flutter-logic
- Błąd -> Snackbar, lista zostaje (wyjątek od "snackbar tylko sukces")
- `AlwaysScrollableScrollPhysics()` wymagane dla pull-to-refresh

---

## Reorder (UI)

```dart
BlocBuilder<<Nazwa>Cubit, <Nazwa>State>(
  builder: (context, state) {
    return state.maybeWhen(
      loaded: (items, itemStatuses, isReordering) {
        return Stack(
          children: [
            ReorderableListView.builder(
              itemCount: items.length,
              onReorder: (oldIndex, newIndex) {
                context.read<<Nazwa>Cubit>().reorderItems(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  key: ValueKey(item.id), // WYMAGANE dla reordera
                  title: Text(item.name),
                );
              },
            ),
            // Overlay podczas zapisywania
            if (isReordering)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  },
)
```

**Kluczowe:**
- `isReordering: true` -> overlay + blokada interakcji
- `ValueKey(item.id)` wymagane dla każdego elementu

---

## Modal Screens (fullscreenDialog)

Ekrany typu "accept/dismiss" pokazuj modalnie (od dołu, nie push z prawej):
```dart
Navigator.push(MaterialPageRoute(
  builder: (_) => PaywallScreen(),
  fullscreenDialog: true,
));
```

**Użyj gdy:** Paywall, compose/create, settings, onboarding, "zrób lub anuluj"
**NIE używaj gdy:** Drill-down (lista -> szczegóły), hierarchiczna nawigacja

---

## Paywall

- **Kontekstowy** - pokazuj przy: limicie Guest, kliknięciu PRO feature, manual "Upgrade"
- **NIE blokujący** - nigdy przed użyciem core feature
- `fullscreenDialog: true`, zawsze dismissowalny
- Copy odnoszące się do wartości: "Masz już 3 zadania! Odblokuj więcej..."

```dart
// Pokazanie paywalla kontekstowego
void _showPaywall(BuildContext context, {required String reason}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PaywallScreen(triggerReason: reason),
      fullscreenDialog: true,
    ),
  );
}

// Przykład użycia - przy limicie
if (items.length >= tierPolicy.maxItems) {
  _showPaywall(context, reason: 'limit_reached');
  return;
}
```

---

## Zasady
- **NIE** ładuj danych przed Navigator.push - ładuj w `init()` po wejściu na ekran
- Błędy jako `SelectableText` (kopiowalne)
- Snackbary tylko na sukces (wyjątek: błąd przy refresh stanu loaded)
- Max 100 linii na widget, potem ekstrakcja
- TextField z `TextCapitalization.sentences` (chyba że email/login)
- Haptic feedback przy ważnych buttonach
- Używaj `/frontend-design` do zaprojektowania wyglądu
- **NIE** pokazuj paywalla przed użyciem core feature
