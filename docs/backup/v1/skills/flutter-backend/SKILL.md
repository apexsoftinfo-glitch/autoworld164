---
name: flutter-backend
description: Use when integrating with Supabase, creating DataSource, fetching data, saving to database, authentication backend, API calls, RLS policies, realtime subscriptions, file storage. (project)
---

# Skill: Flutter Backend & Data

Odpowiada za warstwę `DataSource` i komunikację z Supabase.

## Pamięć Projektu (Self-Learning)
*Tutaj Agent AI zapisuje poznane preferencje backendowe za pomocą skilla `reflect`.*

---

## Zasady DataSource

1. **TYLKO ta warstwa może importować `package:supabase_flutter`.**
2. Metody zwracają surowe dane (DTO) lub Modele, rzucają wyjątki Supabase.
3. Nie implementuj tu logiki biznesowej (to rola Cubita/Repo).

---

## DataSource Pattern

Abstrakcja + implementacja w jednym pliku:

```dart
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class <Nazwa>DataSource {
  Future<List<Map<String, dynamic>>> fetchItems();
  Future<Map<String, dynamic>> createItem(Map<String, dynamic> data);
  Future<void> deleteItem(String id);
}

@LazySingleton(as: <Nazwa>DataSource)
class <Nazwa>DataSourceImpl implements <Nazwa>DataSource {
  final SupabaseClient _supabase;

  <Nazwa>DataSourceImpl(this._supabase);

  @override
  Future<List<Map<String, dynamic>>> fetchItems() async {
    final response = await _supabase
        .from('items')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<Map<String, dynamic>> createItem(Map<String, dynamic> data) async {
    final response = await _supabase
        .from('items')
        .insert(data)
        .select()
        .single();
    return response;
  }

  @override
  Future<void> deleteItem(String id) async {
    await _supabase
        .from('items')
        .delete()
        .eq('id', id);
  }
}
```

---

## Supabase Patterns

### Select z filtrami
```dart
final response = await _supabase
    .from('items')
    .select()
    .eq('user_id', userId)
    .order('created_at', ascending: false)
    .limit(10);
```

### Select z joinami
```dart
final response = await _supabase
    .from('items')
    .select('*, category:categories(name)')
    .eq('user_id', userId);
```

### Insert z zwróceniem danych
```dart
final response = await _supabase
    .from('items')
    .insert({'name': name, 'user_id': userId})
    .select()
    .single();
```

### Update
```dart
await _supabase
    .from('items')
    .update({'name': newName})
    .eq('id', id);
```

### Upsert
```dart
await _supabase
    .from('items')
    .upsert({'id': id, 'name': name});
```

### RPC (Stored Procedures)
```dart
final response = await _supabase.rpc('get_user_stats', params: {
  'user_id': userId,
});
```

---

## Reactivity Pattern (OBOWIĄZKOWE dla list)

Dla danych listowych ZAWSZE implementuj hybrydowy pattern Future + Stream:
- `getX()` - jednorazowy fetch (do init, refresh)
- `watchX()` - stream realtime (do subskrypcji zmian)

> **Uwaga:** FakeDataSource też MUSI zwracać `Stream` (nie `Future`).
> Zobacz skill `flutter-logic` sekcja "Stream-First Pattern" - tam są pełne wzory kodu
> dla FakeDataSource z `BehaviorSubject` i Cubit z `StreamSubscription`.

### Koszty i Uwagi (Supabase Realtime)

**Limity planu Free:**
- 200 równoczesnych połączeń
- 2M wiadomości/miesiąc

**Limity planu Pro:**
- 500 równoczesnych połączeń
- 5M wiadomości/miesiąc
- Overage: $2.50 za 1M wiadomości

**Best practices:**
- Jeden stream per ekran (nie per widget)
- `close()` subskrypcji w `Cubit.close()`
- Nie używaj realtime dla danych, które rzadko się zmieniają
- Fan-out: 10 klientów x 1 zmiana = 10 wiadomości

---

## DataSource z watchX()

```dart
abstract class <Nazwa>DataSource {
  // Jednorazowy fetch
  Future<List<<Nazwa>Model>> getItems(String userId);

  // Realtime stream
  Stream<List<<Nazwa>Model>> watchItems(String userId);

  // Mutacje (zawsze Future)
  Future<<Nazwa>Model> createItem(<Nazwa>Model item);
  Future<void> deleteItem(String id);
}

@LazySingleton(as: <Nazwa>DataSource)
class <Nazwa>DataSourceImpl implements <Nazwa>DataSource {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<List<<Nazwa>Model>> getItems(String userId) async {
    final response = await _supabase
        .from('items')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (response as List)
        .map((json) => <Nazwa>Model.fromJson(json))
        .toList();
  }

  @override
  Stream<List<<Nazwa>Model>> watchItems(String userId) {
    return _supabase
        .from('items')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data
            .map((json) => <Nazwa>Model.fromJson(json))
            .toList());
  }

  @override
  Future<<Nazwa>Model> createItem(<Nazwa>Model item) async {
    final response = await _supabase
        .from('items')
        .insert(item.toJson())
        .select()
        .single();
    return <Nazwa>Model.fromJson(response);
  }

  @override
  Future<void> deleteItem(String id) async {
    await _supabase.from('items').delete().eq('id', id);
  }
}
```

---

## Repository z Stream wrapper

Repository opakowuje Stream z DataSource - nie zmienia jego typu:

```dart
abstract class <Nazwa>Repository {
  Future<Either<Failure, List<<Nazwa>Model>>> getItems();
  Stream<List<<Nazwa>Model>> watchItems();
  Future<Either<Failure, <Nazwa>Model>> createItem(<Nazwa>Model item);
}

@LazySingleton(as: <Nazwa>Repository)
class <Nazwa>RepositoryImpl implements <Nazwa>Repository {
  final <Nazwa>DataSource _dataSource;
  final AuthDataSource _authDataSource;

  <Nazwa>RepositoryImpl(this._dataSource, this._authDataSource);

  String _getCurrentUserId() {
    final user = _authDataSource.getCurrentUser();
    if (user == null) throw Exception('User not authenticated');
    return user.id;
  }

  @override
  Future<Either<Failure, List<<Nazwa>Model>>> getItems() async {
    try {
      final items = await _dataSource.getItems(_getCurrentUserId());
      return Right(items);
    } catch (e, stackTrace) {
      logError('Repository.getItems', e, stackTrace);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<<Nazwa>Model>> watchItems() {
    // Stream NIE używa Either - błędy przez onError w listen()
    return _dataSource.watchItems(_getCurrentUserId());
  }

  @override
  Future<Either<Failure, <Nazwa>Model>> createItem(<Nazwa>Model item) async {
    try {
      final created = await _dataSource.createItem(
        item.copyWith(userId: _getCurrentUserId()),
      );
      return Right(created);
    } catch (e, stackTrace) {
      logError('Repository.createItem', e, stackTrace);
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

**UWAGA:** Stream NIE jest opakowany w `Either` - błędy obsługujesz przez `onError` w `listen()`.

---

## Cubit z subskrypcją (Lifecycle)

```dart
import 'dart:async';

@injectable
class <Nazwa>ListCubit extends Cubit<<Nazwa>ListState> {
  final <Nazwa>Repository _repository;
  StreamSubscription<List<<Nazwa>Model>>? _subscription;

  <Nazwa>ListCubit(this._repository) : super(const <Nazwa>ListState.initial());

  /// Jednorazowy load (init ekranu)
  Future<void> loadItems() async {
    emit(const <Nazwa>ListState.loading());

    final result = await _repository.getItems();
    result.fold(
      (failure) => emit(<Nazwa>ListState.error(failure.message)),
      (items) {
        emit(<Nazwa>ListState.loaded(items: items));
        // Po uzyskaniu pierwszych danych - subskrybuj zmiany
        _subscribeToChanges();
      },
    );
  }

  /// Subskrypcja realtime (po uzyskaniu pierwszych danych)
  void _subscribeToChanges() {
    _subscription?.cancel();
    _subscription = _repository.watchItems().listen(
      (items) {
        // Aktualizuj tylko jeśli jesteśmy w stanie loaded
        final currentState = state;
        if (currentState is _Loaded) {
          emit(currentState.copyWith(items: items));
        }
      },
      onError: (error) {
        // Log error ale NIE zmieniaj stanu na error
        // (mamy już dane, pokazujemy stałe UI)
        logError('Realtime subscription error', error, StackTrace.current);
      },
    );
  }

  /// Refresh (bez utraty subskrypcji)
  Future<void> refresh() async {
    final result = await _repository.getItems();
    result.fold(
      (failure) {
        // Błąd przy refresh -> Snackbar, NIE zmieniaj stanu
      },
      (items) {
        final currentState = state;
        if (currentState is _Loaded) {
          emit(currentState.copyWith(items: items));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
```

**KRYTYCZNE:**
- `_subscription?.cancel()` w `close()` - zapobiega memory leaks
- Błąd w `onError` NIE zmienia stanu na error (mamy dane, UI działa)
- `loadItems()` najpierw fetchuje, potem subskrybuje

---

## Izolacja Supabase

**KRYTYCZNE:** Inne warstwy NIE wiedzą o Supabase!

```
UI -> Cubit -> Repository -> DataSource -> Supabase
                   |             |
                   |     Tylko tu import supabase_flutter
                   |
            Operuje na Model (domenowych)
```

### Repository NIE importuje Supabase
```dart
// DOBRZE
@LazySingleton(as: ItemRepository)
class ItemRepositoryImpl implements ItemRepository {
  final ItemDataSource _dataSource;

  ItemRepositoryImpl(this._dataSource);

  @override
  Future<List<ItemModel>> getItems() async {
    final data = await _dataSource.fetchItems();
    return data.map((json) => ItemModel.fromJson(json)).toList();
  }
}
```

```dart
// ŹLE - repository nie powinno znać Supabase!
import 'package:supabase_flutter/supabase_flutter.dart'; // NIE!
```

---

## Error Handling

DataSource rzuca wyjątki - łapane przez Repository lub Cubit:

```dart
@override
Future<void> deleteItem(String id) async {
  try {
    await _supabase.from('items').delete().eq('id', id);
  } on PostgrestException catch (e) {
    throw Exception('Failed to delete item: ${e.message}');
  }
}
```

---

## RLS (Row Level Security)

Pamiętaj o RLS przy projektowaniu tabel:
- Każda tabela powinna mieć włączone RLS
- Polityki oparte na `auth.uid()`
- Testuj polityki przed deployem

```sql
-- Przykład polityki RLS
CREATE POLICY "Users can only see their own items"
ON items FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can only insert their own items"
ON items FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can only update their own items"
ON items FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can only delete their own items"
ON items FOR DELETE
USING (auth.uid() = user_id);
```

---

## Realtime - Raw API (dla zaawansowanych)

Podstawowe API Supabase Realtime (preferuj pattern `watchX()` opisany wyżej):

```dart
final subscription = _supabase
    .from('items')
    .stream(primaryKey: ['id'])
    .eq('user_id', userId)
    .listen((List<Map<String, dynamic>> data) {
  // Handle realtime updates
});
```

---

## Storage (Pliki)

```dart
// Upload
final path = await _supabase.storage
    .from('avatars')
    .upload('$userId/avatar.png', file);

// Download URL
final url = _supabase.storage
    .from('avatars')
    .getPublicUrl('$userId/avatar.png');
```

---

## User Profiles & Tier Management

Implementacja systemu tierów (Guest -> Registered -> Pro) z profiles table:

### SQL Schema
```sql
-- Profiles table (stores user tier and metadata)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  tier TEXT NOT NULL DEFAULT 'guest'
    CHECK (tier IN ('guest', 'registered', 'pro')),
  display_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policies: Users can only access their own profile
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Auto-create profile when user signs up
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, tier, display_name)
  VALUES (
    NEW.id,
    'guest',
    NEW.raw_user_meta_data->>'display_name'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
```

### SupabaseProfilesDataSource
```dart
@LazySingleton(as: ProfilesDataSource)
class SupabaseProfilesDataSourceImpl implements ProfilesDataSource {
  final SupabaseClient _supabase;

  SupabaseProfilesDataSourceImpl(this._supabase);

  @override
  Future<UserProfileModel?> getProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (response == null) return null;
    return UserProfileModelJsonX.fromSupabaseJson(response);
  }

  @override
  Future<UserProfileModel> createProfile(
    String userId, {
    UserTier tier = UserTier.guest,
    String? displayName,
  }) async {
    final response = await _supabase
        .from('profiles')
        .insert({
          'id': userId,
          'tier': tier.name,
          'display_name': displayName,
        })
        .select()
        .single();
    return UserProfileModelJsonX.fromSupabaseJson(response);
  }

  @override
  Future<UserProfileModel> updateTier(String userId, UserTier tier) async {
    final response = await _supabase
        .from('profiles')
        .update({'tier': tier.name})
        .eq('id', userId)
        .select()
        .single();
    return UserProfileModelJsonX.fromSupabaseJson(response);
  }

  @override
  Stream<UserProfileModel?> profileChanges(String userId) {
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((data) => data.isNotEmpty
            ? UserProfileModelJsonX.fromSupabaseJson(data.first)
            : null);
  }
}
```

### SupabaseAuthDataSource
```dart
@LazySingleton(as: AuthDataSource)
class SupabaseAuthDataSourceImpl implements AuthDataSource {
  final SupabaseClient _supabase;

  SupabaseAuthDataSourceImpl(this._supabase);

  @override
  Future<AuthUserModel> signInAnonymously() async {
    final response = await _supabase.auth.signInAnonymously();
    if (response.user == null) {
      throw Exception('Anonymous sign-in failed');
    }
    return AuthUserModel(
      id: response.user!.id,
      isAnonymous: true,
      createdAt: DateTime.tryParse(response.user!.createdAt),
    );
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return AuthUserModel(
      id: user.id,
      isAnonymous: user.isAnonymous ?? false,
      email: user.email,
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }

  @override
  Stream<AuthUserModel?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return AuthUserModel(
        id: user.id,
        isAnonymous: user.isAnonymous ?? false,
        email: user.email,
        createdAt: DateTime.tryParse(user.createdAt),
      );
    });
  }
}
```

### Tier Upgrade via Edge Function
```typescript
// supabase/functions/handle-payment-webhook/index.ts
import { createClient } from '@supabase/supabase-js';

Deno.serve(async (req) => {
  const { userId, event } = await req.json();

  if (event === 'subscription.created') {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    );

    await supabase
      .from('profiles')
      .update({ tier: 'pro' })
      .eq('id', userId);
  }

  return new Response('OK');
});
```

---

## Po utworzeniu DataSource

1. Zarejestruj w DI (injectable)
2. Upewnij się że tabela ma RLS
3. Przetestuj polityki RLS
4. `flutter pub run build_runner build --delete-conflicting-outputs`
