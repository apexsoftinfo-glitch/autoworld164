# KROK 0: Rozbuduj CLAUDE.md (PIERWSZE co robisz!)

> Ten krok dodaje do CLAUDE.md sekcje o architekturze i zasadach kodowania.
> Wykonaj go **ZANIM** zaczniesz implementację.

Dodaj poniższe sekcje do CLAUDE.md (wstaw je **przed** sekcją "## Zasady dla Agenta AI"):

#### Sekcja: Stack

~~~markdown
## Stack
- **Platformy:** Flutter (Web, iOS, Android)
- **State:** bloc/cubit (freezed states)
- **DI:** get_it + injectable
- **Backend:** Supabase (ukryty w warstwie DataSource)
~~~

#### Sekcja: Architektura

~~~markdown
## Architektura

Clean Architecture: `UI -> Cubit -> Repository -> DataSource`

**Kierunek zależności (KRYTYCZNE):**
```
UI -> Cubit -> Repository -> DataSource
        \        \          \
         Models (współdzielone)
```

| Warstwa    | Zna                          | NIE zna                    |
|------------|------------------------------|----------------------------|
| UI         | Cubit, Models                | Repository, DataSource     |
| Cubit      | Repository, Models           | DataSource, UI             |
| Repository | DataSource, Models           | Cubit, UI                  |
| DataSource | Models, Supabase             | Repository, Cubit, UI      |

**NIGDY** nie importuj warstwy wyższej:
- Repository NIE importuje Cubit
- DataSource NIE importuje Repository
- Models NIE importują niczego z warstw wyższych

**Feature-first struktura folderów:**
```
lib/
  app/
    navigation/
    router/
  features/
    feature_name/
      ui/
      cubit/
      repository/
      data_source/
      models/
  shared/
    widgets/
  core/
    di/
    services/
    navigation/
```

**Warstwa app/** (kompozycja):
- `app/` zawiera tylko wiring: `AppGate`, `AppNavigatorImpl`, konfigurację routingu
- Core nie importuje feature'ów, a feature'y nie importują innych feature'ów
- Cross‑feature nawigacja idzie przez `AppNavigator` (core)
~~~

#### Sekcja: Zasady Krytyczne

~~~markdown
## Zasady Krytyczne (Security & Stability)

1. **Architektura:** `UI -> Cubit -> Repository -> DataSource`. **NIGDY** w drugą stronę.
2. **Izolacja:** Repository i Cubit **NIE** mogą importować paczki `supabase_flutter`. Tylko DataSource ma do tego prawo.
3. **Analiza:** Kod musi przechodzić `flutter analyze` bez błędów.
4. **Testy:** Każda zmiana w logice biznesowej (Cubit) wymaga aktualizacji lub napisania testów.
5. **NIE** wywołuj services bezpośrednio w UI - zawsze przez cubit (testowalność).
6. **Logowanie błędów:** Każdy `catch` w Repository/DataSource musi wywołać `logError(context, error, stackTrace)` przed zwróceniem Failure. Helper: `lib/core/utils/error_logger.dart`.
7. **Stream-First (OBOWIĄZKOWE dla list!):** Dane listowe ZAWSZE przez `Stream`, nawet w FakeDataSource. Mutacje przez Future. Cubit MUSI mieć `close()` z `_subscription?.cancel()`. Szczegóły w `.claude/skills/flutter-logic/SKILL.md`.
8. **DI: Singleton vs Factory:** Cubity współdzielone między widgetami (np. ProfilesCubit, EntriesCubit) → `registerLazySingleton` + `BlocProvider.value`. Cubity per-screen → `registerFactory` + `BlocProvider(create:)`. **NIGDY** `BlocProvider(create:)` z singletonem (dispose zamknie singleton!).
~~~

#### Sekcja: User Tiers (intro)

~~~markdown
## User Tiers (Guest → Registered → Pro)

**KRYTYCZNE:** Tier jest **ZAWSZE COMPUTED**, nigdy stored w DB!

```dart
UserTier get tier {
  if (isPro) return UserTier.pro;           // z RevenueCat CustomerInfo
  if (!isAnonymous) return UserTier.registered;  // z Supabase Auth
  return UserTier.guest;                    // anonymous user
}
```

**SessionRepository ewoluuje przez kroki:**
1. `/logic` → `FakeSessionRepository` (tier = guest, hardcoded)
2. `/auth` → full SessionRepository (auth + profile + connectivity + RevenueCat)

**Limity:**
- Guest: X elementów (z IDEA.md)
- Registered: X × 3 (mnożnik stały)
- Pro: bez limitu (null)
~~~

#### Sekcja: Konwencje nazewnictwa

~~~markdown
## Konwencje nazewnictwa

- Abstrakcja + implementacja w **jednym pliku**: `UserRepository` + `UserRepositoryImpl`
- Cubit + State w **jednym pliku**, state też freezed
- Modele z końcówką `Model`: `UserModel`, `TaskModel`
- **Relative imports** dla plików projektu (nie `package:onlythis/...`)
~~~

#### Sekcja: Komendy CLI

~~~markdown
## Komendy CLI

```bash
# Generowanie kodu (freezed/injectable)
flutter pub run build_runner build --delete-conflicting-outputs

# Testy i analiza
flutter test
flutter analyze
```
~~~

#### Sekcja: Database Schema (tymczasowe)

~~~markdown
## Database Schema (tymczasowe - usunąć po /database)

> Ta sekcja jest wypełniana w `/logic` i usuwana po `/database`.
> Służy do przekazania zaplanowanego schematu tabel między krokami.

[Schemat zostanie dodany poniżej w tym kroku]
~~~

#### Rozbuduj sekcję "Zasady dla Agenta AI"

Dodaj do istniejącej sekcji "### ZAWSZE rób" w CLAUDE.md:

~~~markdown
- Unit testy dla cubitów
- Error handling + empty states
~~~

Dodaj nową podsekcję do "## Zasady dla Agenta AI":

~~~markdown
### NIGDY nie rób
- Metod `_buildWidget()` - używaj prywatnych klas
- Ładowania danych przed Navigator.push
- Importów Supabase poza DataSource
- Injectowania cubitów do innych cubitów
- Importów warstwy wyższej (Repository NIE importuje Cubit)
- **Snackbarów dla błędów** - błędy ZAWSZE inline jako `SelectableText`. Snackbar tylko sukces!
~~~

---

## 0.5 Sync status z platformą

Wyślij PATCH do platformy z nowym statusem `in_progress`:

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{logic_step_id}", "status": "in_progress"}]}'
```

> Wartości `{API Base URL}`, `{Platform App ID}` odczytaj z CLAUDE.md, `{API Key}` z `.env`.

---

## Architektura referencyjna (KRYTYCZNE!)

```
UI → Cubit → Repository → DataSource
        \        \          \
         Models (współdzielone)
```

**Kierunek zależności:**
- UI zna Cubit i Models
- Cubit zna Repository i Models
- Repository zna DataSource i Models
- DataSource zna Models i external packages (Supabase)

**NIGDY nie importuj warstwy wyższej!**

---

## Stream-First Architecture (OBOWIĄZKOWE dla list!)

```dart
// ❌ ŹLE - pull-based
Future<List<{Entity}>> get{Entities}();

// ✅ DOBRZE - stream-first
Stream<List<{Entity}>> watch{Entities}();
Future<void> add{Entity}({Entity} item);
```

**Wzorzec:**
1. DataSource emituje streamy (BehaviorSubject)
2. Po każdej mutacji → emit nowej listy
3. Cubit subskrybuje stream w konstruktorze
4. Cubit.close() anuluje subscription

---

## Profiles Feature (WYMAGANE!)

Każda aplikacja MUSI mieć profiles feature dla personalizacji (greeting na home screen).

### ProfileModel

```dart
@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    @Default(false) bool hasCompletedOnboarding,
    DateTime? createdAt,
    DateTime? updatedAt,
    // UWAGA: BEZ tier! Tier jest computed w UserSession
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
```

### ProfilesRepository

```dart
abstract class ProfilesRepository {
  Stream<ProfileModel> watchProfile(String userId);
  Future<Either<Failure, void>> updateName(String userId, String name);
  Future<Either<Failure, void>> setOnboardingCompleted(String userId);
}
```

### FakeProfilesDataSource

**Opis:** In-memory storage z BehaviorSubject dla reaktywności.

**Acceptance criteria:**
- Inicjalizuje profil z imieniem z CLAUDE.md (sekcja "Dane użytkownika")
- `watchProfile(userId)` zwraca stream profilu
- `updateName()` aktualizuje imię i emituje nowy stan
- `setOnboardingCompleted()` ustawia flagę i emituje

### ProfilesCubit

**Opis:** Cubit zarządzający stanem profilu z subskrypcją streamu.

**Acceptance criteria:**
- State: `name`, `hasCompletedOnboarding`, `isLoading`, `error`
- `watchProfile(userId)` - subskrybuje stream, aktualizuje state
- `updateName()` - wywołuje repository, obsługuje Either
- `close()` - anuluje subscription

---

## Session Integration (WYMAGANE!)

Template ma już gotową strukturę session (`lib/features/session/`).
W tym kroku podpinamy FakeSessionRepository.

### Sprawdź że FakeSessionRepository jest zarejestrowany w DI

W `lib/core/di/injection.dart` upewnij się że wywoływane jest:
```dart
registerSessionModule(getIt);
```

### UI używa SessionCubit dla tier

```dart
BlocBuilder<SessionCubit, UserSession>(
  builder: (context, session) {
    final tier = session.tier; // computed!
    final limit = session.limit;
    // ...
  },
)
```

### FakeSessionRepository na tym etapie:
- tier = guest (hardcoded, bo brak auth)
- isAnonymous = true (zawsze)
- isPro = false (zawsze, bo brak RevenueCat)
- isOffline = false (zawsze online)

### Sprawdź strukturę session

Upewnij się że istnieją pliki z template'a:
- `lib/features/session/domain/models/user_session.dart`
- `lib/features/session/domain/models/user_tier.dart`
- `lib/features/session/domain/repositories/session_repository.dart`
- `lib/features/session/data/repositories/fake_session_repository.dart`

Jeśli brakuje → stwórz je zgodnie z poniższymi definicjami:

**user_tier.dart:**
```dart
enum UserTier { guest, registered, pro }
```

**user_session.dart:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../profiles/models/profile_model.dart';
import 'user_tier.dart';

part 'user_session.freezed.dart';

@freezed
abstract class UserSession with _$UserSession {
  const UserSession._();

  const factory UserSession({
    required String? userId,
    required bool isAnonymous,
    required bool isOffline,
    required ProfileModel? profile,
    required bool isPro,
  }) = _UserSession;

  const factory UserSession.unauthenticated() = _Unauthenticated;
  const factory UserSession.initializing() = _Initializing;

  UserTier get tier => map(
        (session) {
          if (session.isPro) return UserTier.pro;
          if (!session.isAnonymous) return UserTier.registered;
          return UserTier.guest;
        },
        unauthenticated: (_) => UserTier.guest,
        initializing: (_) => UserTier.guest,
      );

  int? get limit => map(
        (session) => switch (session.tier) {
              UserTier.guest => 5,
              UserTier.registered => 15,
              UserTier.pro => null,
            },
        unauthenticated: (_) => 5,
        initializing: (_) => 5,
      );

  bool get needsOnboarding => map(
        (session) => session.userId != null && session.profile == null,
        unauthenticated: (_) => false,
        initializing: (_) => false,
      );

  bool get hasCompletedOnboarding => map(
        (session) => session.profile?.hasCompletedOnboarding ?? false,
        unauthenticated: (_) => false,
        initializing: (_) => false,
      );

  String get displayName => map(
        (session) => session.profile?.firstName ?? 'Użytkownik',
        unauthenticated: (_) => 'Użytkownik',
        initializing: (_) => 'Użytkownik',
      );
}
```

**session_repository.dart:**
```dart
import '../models/user_session.dart';

abstract class SessionRepository {
  Stream<UserSession> get sessionStream;
  UserSession get current;
  Future<void> initialize();
  Future<void> refresh();
  void dispose();
}
```

**fake_session_repository.dart:**
```dart
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../../domain/models/user_session.dart';
import '../../domain/repositories/session_repository.dart';
import '../../../profiles/models/profile_model.dart';

class FakeSessionRepository implements SessionRepository {
  final _sessionController = BehaviorSubject<UserSession>.seeded(
    const UserSession.unauthenticated(),
  );

  String? _userId;
  ProfileModel? _profile;
  bool _isAnonymous = true;

  @override
  Stream<UserSession> get sessionStream => _sessionController.stream.distinct();

  @override
  UserSession get current => _sessionController.value;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> refresh() async => _emitCurrentState();

  @override
  void dispose() => _sessionController.close();

  // Fake Auth
  Future<void> signInAnonymously() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _userId = 'fake-user-${DateTime.now().millisecondsSinceEpoch}';
    _isAnonymous = true;
    _profile = null;
    _emitCurrentState();
  }

  Future<void> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _userId = 'fake-user-${email.hashCode}';
    _isAnonymous = false;
    _emitCurrentState();
  }

  Future<void> signOut() async {
    _userId = null;
    _profile = null;
    _isAnonymous = true;
    _sessionController.add(const UserSession.unauthenticated());
  }

  Future<void> linkEmailToAnonymous(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _isAnonymous = false;
    _emitCurrentState();
  }

  // Fake Profile
  Future<void> updateProfile(ProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _profile = profile;
    _emitCurrentState();
  }

  Future<void> setOnboardingCompleted() async {
    if (_profile != null) {
      _profile = _profile!.copyWith(hasCompletedOnboarding: true);
      _emitCurrentState();
    }
  }

  void _emitCurrentState() {
    if (_userId == null) {
      _sessionController.add(const UserSession.unauthenticated());
    } else {
      _sessionController.add(UserSession(
        userId: _userId,
        isAnonymous: _isAnonymous,
        isOffline: false,
        profile: _profile,
        isPro: false,
      ));
    }
  }
}
```

Po utworzeniu uruchom `flutter pub run build_runner build --delete-conflicting-outputs` dla wygenerowania plików freezed.

---

### Home Screen Integration

Home screen MUSI wyświetlać greeting z imieniem:

```dart
BlocBuilder<ProfilesCubit, ProfilesState>(
  builder: (context, state) {
    return Text('Cześć ${state.name}!'); // L10N
  },
)
```

### Settings Screen Integration

Settings screen MUSI używać ProfilesCubit do:
1. **Wyświetlania** aktualnego imienia (read)
2. **Edycji** imienia (write przez updateName)

**WAŻNE:** Settings MUSI być podłączony do tego samego ProfilesCubit co Home screen, aby zmiany były widoczne w obu miejscach.

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/logic/logic-2-planning.md`
