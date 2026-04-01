---
name: flutter-logic
description: Use when creating features, cubits, business logic, state management, models, repositories, unit tests, CRUD operations, form validation logic, pull-to-refresh, reorder lists. (project)
---

# Skill: Flutter Logic & Architecture

Odpowiada za warstwy: Cubit, Repository, Models oraz Testy.

## Pamięć Projektu (Self-Learning)
*Tutaj Agent AI zapisuje poznane preferencje architektoniczne za pomocą skilla `reflect`.*

---

## Struktura Feature (Clean Architecture)

```
lib/features/<nazwa>/
  ui/
    <nazwa>_screen.dart
  cubit/
    <nazwa>_cubit.dart      # Cubit + State (freezed)
  repository/
    <nazwa>_repository.dart # Abstrakcja + Impl
  data_source/
    <nazwa>_data_source.dart # Abstrakcja + Impl
  models/
    <nazwa>_model.dart      # Model z freezed
```

---

## Cubit Podstawowy

Cubit + State w **jednym pliku**, state jako **freezed**:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part '<nazwa>_cubit.freezed.dart';

@freezed
class <Nazwa>State with _$<Nazwa>State {
  const factory <Nazwa>State.initial() = _Initial;
  const factory <Nazwa>State.loading() = _Loading;
  const factory <Nazwa>State.loaded(/* data */) = _Loaded;
  const factory <Nazwa>State.error(String message) = _Error;
}

@injectable
class <Nazwa>Cubit extends Cubit<<Nazwa>State> {
  final <Nazwa>Repository _repository;

  <Nazwa>Cubit(this._repository) : super(const <Nazwa>State.initial());

  Future<void> init() async {
    emit(const <Nazwa>State.loading()); // loading dopiero gdy faktycznie ładujemy
    try {
      // fetch data from repository
      emit(<Nazwa>State.loaded(/* data */));
    } catch (e) {
      emit(<Nazwa>State.error(e.toString()));
    }
  }
}
```

**KRYTYCZNE:**
- Stan początkowy = `initial`, NIE `loading` (zabezpieczenie gdy init() nie wywołane)
- `loading` dopiero w `init()` gdy faktycznie ładujemy

---

## Stream-First Pattern (OBOWIĄZKOWE dla danych listowych!)

**ZASADA:** Dane które się zmieniają (listy, aktywne elementy) ZAWSZE przychodzą na `Stream`.
Nawet `FakeDataSource` zwraca `Stream`, nie `Future`.

### Dlaczego Stream-first?

**Problem z Future:**
1. User otwiera Home → fetch lista → wyświetla
2. User idzie do Detail → edytuje element
3. User wraca do Home → **STARE DANE** (bo nie było ponownego fetch)

**Rozwiązanie ze Stream:**
1. Cubit subskrybuje `watchItems()` na starcie
2. Każda zmiana (create/update/delete) emituje nową listę
3. Home automatycznie się aktualizuje → **ZAWSZE AKTUALNE DANE**

### Struktura DataSource (Stream-first)

```dart
abstract class ItemDataSource {
  // ❌ NIE RÓB: Future<List<ItemModel>> getItems();

  // ✅ RÓB: Stream dla danych które się zmieniają
  Stream<List<ItemModel>> watchItems(String userId);

  // ✅ Mutacje ZAWSZE przez Future (one-shot)
  Future<ItemModel> createItem(ItemModel item);
  Future<void> updateItem(ItemModel item);
  Future<void> deleteItem(String id);
}
```

### FakeDataSource ze Stream

```dart
import 'package:rxdart/rxdart.dart';

class FakeItemDataSource implements ItemDataSource {
  final _itemsController = BehaviorSubject<List<ItemModel>>.seeded([]);
  List<ItemModel> _items = [];

  @override
  Stream<List<ItemModel>> watchItems(String userId) {
    return _itemsController.stream;
  }

  @override
  Future<ItemModel> createItem(ItemModel item) async {
    _items = [..._items, item];
    _itemsController.add(_items); // Emit nowej listy!
    return item;
  }

  @override
  Future<void> updateItem(ItemModel item) async {
    _items = _items.map((i) => i.id == item.id ? item : i).toList();
    _itemsController.add(_items); // Emit nowej listy!
  }

  @override
  Future<void> deleteItem(String id) async {
    _items = _items.where((i) => i.id != id).toList();
    _itemsController.add(_items); // Emit nowej listy!
  }

  void dispose() {
    _itemsController.close();
  }
}
```

### Cubit z subskrypcją (LIFECYCLE!)

```dart
@injectable
class ItemListCubit extends Cubit<ItemListState> {
  final ItemRepository _repository;
  StreamSubscription<List<ItemModel>>? _subscription;

  ItemListCubit(this._repository) : super(const ItemListState.initial());

  Future<void> init() async {
    emit(const ItemListState.loading());

    // Subskrybuj stream - każda zmiana automatycznie aktualizuje UI
    _subscription = _repository.watchItems().listen(
      (items) => emit(ItemListState.loaded(items: items)),
      onError: (e) => emit(ItemListState.error(e.toString())),
    );
  }

  // KRYTYCZNE: Zawsze anuluj subskrypcję!
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
```

### Kiedy Stream, kiedy Future?

| Dane | Typ | Przykład |
|------|-----|----------|
| Lista elementów | `Stream<List<T>>` | Challenges, Tasks, Notes |
| Aktywny element | `Stream<T?>` | Active challenge, Current user |
| Pojedynczy fetch | `Future<T>` | User profile (rzadko się zmienia) |
| Mutacje | `Future<T>` | Create, Update, Delete |

### Wymagane pakiety

```yaml
dependencies:
  rxdart: ^0.28.0  # dla BehaviorSubject
```

---

## Cubit CRUD (Lista z add/edit/delete)

Dla ekranów z listą elementów i operacjami CRUD:

```dart
part '<nazwa>_cubit.freezed.dart';

/// Status dla operacji na pojedynczym elemencie
@freezed
class ItemStatus with _$ItemStatus {
  const factory ItemStatus.idle() = _ItemIdle;
  const factory ItemStatus.loading() = _ItemLoading;
  const factory ItemStatus.error(String message) = _ItemError;
}

/// Status dla formularza dodawania
@freezed
class AddItemStatus with _$AddItemStatus {
  const factory AddItemStatus.idle() = _AddIdle;
  const factory AddItemStatus.loading() = _AddLoading;
  const factory AddItemStatus.success() = _AddSuccess;
  const factory AddItemStatus.error(String message) = _AddError;
}

@freezed
class <Nazwa>State with _$<Nazwa>State {
  const factory <Nazwa>State.initial() = _Initial;
  const factory <Nazwa>State.loading() = _Loading;
  const factory <Nazwa>State.error(String message) = _Error;
  const factory <Nazwa>State.loaded({
    required List<<Nazwa>Item> items,
    @Default({}) Map<String, ItemStatus> itemStatuses,
    @Default(AddItemStatus.idle()) AddItemStatus addStatus,
  }) = _Loaded;
}

@injectable
class <Nazwa>Cubit extends Cubit<<Nazwa>State> {
  final <Nazwa>Repository _repository;

  <Nazwa>Cubit(this._repository) : super(const <Nazwa>State.initial());

  Future<void> addItem(String name) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    emit(currentState.copyWith(addStatus: const AddItemStatus.loading()));

    try {
      final newItem = await _repository.addItem(name);
      final updatedState = state;
      if (updatedState is! _Loaded) return;

      emit(updatedState.copyWith(
        items: [...updatedState.items, newItem],
        addStatus: const AddItemStatus.success(),
      ));
    } catch (e) {
      final updatedState = state;
      if (updatedState is! _Loaded) return;
      emit(updatedState.copyWith(addStatus: AddItemStatus.error(e.toString())));
    }
  }

  Future<void> deleteItem(String itemId) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    emit(currentState.copyWith(
      itemStatuses: {...currentState.itemStatuses, itemId: const ItemStatus.loading()},
    ));

    try {
      await _repository.deleteItem(itemId);
      final updatedState = state;
      if (updatedState is! _Loaded) return;

      final newStatuses = Map<String, ItemStatus>.from(updatedState.itemStatuses)..remove(itemId);
      emit(updatedState.copyWith(
        items: updatedState.items.where((i) => i.id != itemId).toList(),
        itemStatuses: newStatuses,
      ));
    } catch (e) {
      final updatedState = state;
      if (updatedState is! _Loaded) return;
      emit(updatedState.copyWith(
        itemStatuses: {...updatedState.itemStatuses, itemId: ItemStatus.error(e.toString())},
      ));
    }
  }
}
```

---

## Form Cubit (Dedykowany ekran Add/Edit)

Gdy masz **osobny ekran** do dodawania/edycji elementu:

```dart
part '<nazwa>_form_cubit.freezed.dart';

@freezed
class <Nazwa>FormState with _$<Nazwa>FormState {
  /// Sukces - sygnał dla UI żeby zamknąć ekran
  const factory <Nazwa>FormState.success() = _Success;

  /// Główny stan edycji
  const factory <Nazwa>FormState.editing({
    required <Nazwa>FormData formData,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _Editing;
}

@injectable
class <Nazwa>FormCubit extends Cubit<<Nazwa>FormState> {
  final <Nazwa>Repository _repository;

  <Nazwa>FormCubit(this._repository)
      : super(const <Nazwa>FormState.editing(formData: <Nazwa>FormData.empty()));

  Future<void> save() async {
    final currentState = state;
    if (currentState is! _Editing) return;

    // 1. Zablokuj formularz
    emit(currentState.copyWith(isSaving: true, errorMessage: null));

    try {
      // 2. Zapisz do backendu
      await _repository.save(currentState.formData);

      // 3. Sukces -> UI zrobi Navigator.pop()
      emit(const <Nazwa>FormState.success());
    } catch (e) {
      // 4. Error -> odblokuj, pokaż błąd, dane zachowane
      emit(currentState.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }
}
```

**Kluczowe:**
- `isSaving: true` -> cały formularz zablokowany
- `Navigator.pop()` TYLKO po `success` (NIE przed potwierdzeniem od backendu)
- Error -> zostajemy na ekranie, dane w polach zachowane

---

## Pull-to-refresh (Logika Cubita)

Odświeżanie listy bez pełnego loadera:

```dart
Future<void> refresh() async {
  final current = state;
  if (current is! _Loaded) return;

  // BEZ emit(loading) - RefreshIndicator ma własny spinner
  try {
    final items = await _repository.getItems();
    final updated = state;
    if (updated is! _Loaded) return;
    emit(updated.copyWith(items: items));
  } catch (e) {
    // Błąd przy refresh -> Snackbar (wyjątek od reguły "tylko sukces")
    // Lista pozostaje widoczna, NIE zmieniamy stanu na error
  }
}
```

**Kluczowe:**
- `init()` = pierwszy load (emituje `loading`)
- `refresh()` = odświeżanie (NIE emituje `loading`)
- Błąd -> Snackbar, lista zostaje

---

## Reorder (Logika Cubita)

Zmiana kolejności z pessimistic UI i rollbackiem:

```dart
// Stan - dodaj flagę isReordering
@freezed
class <Nazwa>State with _$<Nazwa>State {
  const factory <Nazwa>State.loaded({
    required List<<Nazwa>Item> items,
    @Default({}) Map<String, ItemStatus> itemStatuses,
    @Default(false) bool isReordering, // blokada podczas reordera
  }) = _Loaded;
}

// Metoda w Cubit
Future<void> reorderItems(int oldIndex, int newIndex) async {
  final current = state;
  if (current is! _Loaded) return;

  // 1. Zapamiętaj oryginalną listę (do rollbacku)
  final previousItems = List<<Nazwa>Item>.from(current.items);

  // 2. Korekta indeksu (ReorderableListView quirk)
  final adjustedNew = newIndex > oldIndex ? newIndex - 1 : newIndex;

  // 3. Utwórz nową kolejność
  final reordered = List<<Nazwa>Item>.from(current.items);
  final item = reordered.removeAt(oldIndex);
  reordered.insert(adjustedNew, item);

  // 4. Pokaż nową kolejność + blokada
  emit(current.copyWith(items: reordered, isReordering: true));

  try {
    // 5. Zapisz do backendu
    await _repository.updateOrder(reordered);

    final updated = state;
    if (updated is! _Loaded) return;
    emit(updated.copyWith(isReordering: false));
  } catch (e) {
    // 6. ROLLBACK do poprzedniej kolejności
    final updated = state;
    if (updated is! _Loaded) return;
    emit(updated.copyWith(items: previousItems, isReordering: false));
    // Snackbar z błędem (przez BlocListener)
  }
}
```

**Kluczowe:**
- `isReordering: true` -> overlay + blokada interakcji
- Zapamiętaj `previousItems` PRZED wywołaniem backendu
- Error -> rollback do `previousItems` + Snackbar

---

## Repository

Abstrakcja + implementacja w jednym pliku:

```dart
abstract class <Nazwa>Repository {
  Future<List<<Nazwa>Model>> getItems();
  Future<<Nazwa>Model> addItem(String name);
  Future<void> deleteItem(String id);
}

@LazySingleton(as: <Nazwa>Repository)
class <Nazwa>RepositoryImpl implements <Nazwa>Repository {
  final <Nazwa>DataSource _dataSource;

  <Nazwa>RepositoryImpl(this._dataSource);

  @override
  Future<List<<Nazwa>Model>> getItems() async {
    return _dataSource.fetchItems();
  }
}
```

**Zasady:**
- Impl z końcówką `Impl`
- Nie zna Supabase
- Rzuca wyjątki przy błędach (cubit łapie w try/catch)

---

## Model (Freezed)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<nazwa>_model.freezed.dart';
part '<nazwa>_model.g.dart';

@freezed
class <Nazwa>Model with _$<Nazwa>Model {
  const factory <Nazwa>Model({
    required String id,
    required String title,
    @Default(false) bool isCompleted,
    DateTime? createdAt,
  }) = _<Nazwa>Model;

  factory <Nazwa>Model.fromJson(Map<String, dynamic> json) =>
      _$<Nazwa>ModelFromJson(json);
}
```

### Model z metodami pomocniczymi
```dart
@freezed
class <Nazwa>Model with _$<Nazwa>Model {
  const <Nazwa>Model._(); // Potrzebne dla metod

  const factory <Nazwa>Model({
    required String id,
    required String title,
  }) = _<Nazwa>Model;

  factory <Nazwa>Model.fromJson(Map<String, dynamic> json) =>
      _$<Nazwa>ModelFromJson(json);

  bool get isEmpty => title.isEmpty;
}
```

### Model z custom JSON keys
```dart
@freezed
class <Nazwa>Model with _$<Nazwa>Model {
  const factory <Nazwa>Model({
    required String id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _<Nazwa>Model;

  factory <Nazwa>Model.fromJson(Map<String, dynamic> json) =>
      _$<Nazwa>ModelFromJson(json);
}
```

### Model z enum
```dart
enum <Nazwa>Status {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
}

@freezed
class <Nazwa>Model with _$<Nazwa>Model {
  const factory <Nazwa>Model({
    required String id,
    @Default(<Nazwa>Status.pending) <Nazwa>Status status,
  }) = _<Nazwa>Model;

  factory <Nazwa>Model.fromJson(Map<String, dynamic> json) =>
      _$<Nazwa>ModelFromJson(json);
}
```

**Konwencje:**
- Nazwa zawsze z końcówką `Model`: `TaskModel`, `UserModel`
- Plik: `<nazwa>_model.dart` (snake_case)
- Używaj `@JsonKey(name: 'snake_case')` dla pól z API

---

## Unit Testy

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class Mock<Nazwa>Repository extends Mock implements <Nazwa>Repository {}

void main() {
  late <Nazwa>Cubit cubit;
  late Mock<Nazwa>Repository mockRepository;

  setUp(() {
    mockRepository = Mock<Nazwa>Repository();
    cubit = <Nazwa>Cubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is correct', () {
    expect(cubit.state, const <Nazwa>State.initial());
  });

  blocTest<<Nazwa>Cubit, <Nazwa>State>(
    'emits [loading, loaded] when init succeeds',
    build: () {
      when(() => mockRepository.getData()).thenAnswer(
        (_) async => /* success */,
      );
      return cubit;
    },
    act: (cubit) => cubit.init(),
    expect: () => [
      const <Nazwa>State.loading(),
      // <Nazwa>State.loaded(...),
    ],
  );

  blocTest<<Nazwa>Cubit, <Nazwa>State>(
    'emits [loading, error] when init fails',
    build: () {
      when(() => mockRepository.getData()).thenThrow(Exception('Error'));
      return cubit;
    },
    act: (cubit) => cubit.init(),
    expect: () => [
      const <Nazwa>State.loading(),
      isA<<Nazwa>State>().having(
        (s) => s.maybeWhen(error: (m) => m, orElse: () => null),
        'error message',
        contains('Error'),
      ),
    ],
  );
}
```

**Zasady:**
- Wymagane dla każdego Cubita
- Mockuj Repository (nie DataSource)
- Testuj każdą ścieżkę (success, failure, loading)

---

## Aktualizacja Testów po Zmianach w Cubicie

**KRYTYCZNE:** Każda zmiana w Cubicie wymaga weryfikacji/aktualizacji testów!

### Workflow

1. **Po edycji `*_cubit.dart`** -> sprawdź `test/features/<feature>/cubit/*_cubit_test.dart`
2. **Jeśli test nie istnieje** -> utwórz go (wzór powyżej)
3. **Jeśli test istnieje** -> zaktualizuj odpowiednie przypadki

### Co zmieniłeś -> Co przetestować

| Zmiana w Cubicie | Wymagana aktualizacja testu |
|------------------|----------------------------|
| Nowa metoda | Dodaj `blocTest` dla success + failure |
| Nowy stan w State | Zaktualizuj `expect()` we wszystkich testach używających tego stanu |
| Zmiana sygnatury metody | Zaktualizuj `act:` w odpowiednich testach |
| Nowa zależność (Repository) | Dodaj mock + `setUp()` |
| Zmiana logiki w metodzie | Zweryfikuj `expect()` - czy oczekiwane stany są poprawne |
| Usunięcie metody/stanu | Usuń odpowiednie testy |

### Przykład: Dodanie nowej metody

**Cubit:**
```dart
Future<void> deleteItem(String id) async {
  // ...implementacja...
}
```

**Test do dodania:**
```dart
blocTest<MyCubit, MyState>(
  'emits updated list when deleteItem succeeds',
  build: () {
    when(() => mockRepository.deleteItem(any())).thenAnswer((_) async {});
    return cubit;
  },
  seed: () => MyState.loaded(items: [testItem]),
  act: (cubit) => cubit.deleteItem('123'),
  expect: () => [
    MyState.loaded(items: [], itemStatuses: {'123': const ItemStatus.loading()}),
    const MyState.loaded(items: []),
  ],
);

blocTest<MyCubit, MyState>(
  'emits error status when deleteItem fails',
  build: () {
    when(() => mockRepository.deleteItem(any())).thenThrow(Exception('Error'));
    return cubit;
  },
  seed: () => MyState.loaded(items: [testItem]),
  act: (cubit) => cubit.deleteItem('123'),
  expect: () => [
    MyState.loaded(items: [testItem], itemStatuses: {'123': const ItemStatus.loading()}),
    MyState.loaded(items: [testItem], itemStatuses: {'123': const ItemStatus.error('Exception: Error')}),
  ],
);
```

### Checklist przed zakończeniem

- [ ] Test używa `blocTest` z `bloc_test` package
- [ ] Mock używa `mocktail` (nie mockito)
- [ ] Każda nowa metoda ma test success + failure
- [ ] `setUp()` tworzy świeży cubit przed każdym testem
- [ ] `tearDown()` wywołuje `cubit.close()`
- [ ] `flutter test` przechodzi bez błędów

---

## Zasady Architektoniczne

1. **Clean Architecture:**
   `UI` -> `Cubit` -> `Repository` -> `DataSource`

2. **Kierunek Zależności:** Warstwa niższa nigdy nie zna wyższej (np. Repo nie wie o Cubicie).

3. **Cubity:**
   - NIE injectują innych cubitów
   - Komunikacja między cubitami przez UI (BlocListener)
   - Zawsze error handling w metodach async

4. **Repository:** Operuje na `Model` (domenowych). Rzuca wyjątki.

5. **Cubit:** Zarządza stanem UI. Łapie wyjątki z Repo i mapuje na stan `.error()`.

---

## Po utworzeniu feature/cubita

1. Zarejestruj w DI (injectable)
2. `flutter pub run build_runner build --delete-conflicting-outputs`
3. Napisz testy dla cubita
4. `flutter test`
5. `flutter analyze`

---

## User Tiers

```
Guest (bez konta):    Limit elementów, podstawowe CRUD, lokalne dane
Registered (free):    Wyższy limit, cloud sync, historia
Pro (subskrypcja):    Unlimited, wszystkie features
```

- Centralizuj limity w `lib/core/tier_policy.dart`
- Guest musi wystarczyć na First Value Moment!
- Sprawdzaj tier w Cubit, nie w UI

---

## Review Prompt

Śledź `firstSuccessAt` w `LocalStorageService`. Prompt o recenzję po 24h od pierwszego sukcesu.

```dart
// W odpowiednim cubit/service
if (DateTime.now().difference(firstSuccessAt) > Duration(hours: 24)) {
  // Pokaż dialog z prośbą o recenzję
}
```

---

## Gate/Router

- `AppGate` sprawdza: auth status, subscription status
- Home obsługuje welcome state dla nowych użytkowników
- Bez go_router - prosta nawigacja Navigator

```dart
class AppGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SplashScreen(),
          authenticated: (user) => const HomeScreen(),
          unauthenticated: () => const WelcomeScreen(),
        );
      },
    );
  }
}
```
