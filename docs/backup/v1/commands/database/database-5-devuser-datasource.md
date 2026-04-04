# KROK 5 + 6: Hardcoded Dev User + SupabaseDataSource

## KROK 5: Hardcoded Dev User

### 5.1 Utwórz stałą

```dart
// lib/core/constants/dev_constants.dart

/// Hardcoded user ID for development (before auth is implemented)
/// This will be replaced with real auth in /auth step
const kDevUserId = 'dev-user-001';
```

### 5.2 Użycie w aplikacji

Wszystkie operacje używają `kDevUserId` do czasu implementacji auth:
```dart
// W Cubit
void loadItems() {
  watchItems(kDevUserId); // Hardcoded na razie
}
```

---

## KROK 6: SupabaseDataSource

### 6.1 Wywołaj skill

```
Przeczytaj: .claude/skills/flutter-backend/SKILL.md

Zadanie: Stwórz SupabaseDataSource zamiast FakeDataSource.

Wymagania:
- Implementuje ten sam interfejs co FakeDataSource
- Używa Supabase realtime dla streamów
- Hardcoded kDevUserId
- Stream-first pattern (jak w FakeDataSource)
```

### 6.2 Wzorzec Supabase{Entities}DataSource

> **Parametryzacja:** Zastąp `{Entities}` nazwą encji z docs/IDEA.md (np. Entries, Tasks, Notes).

**WAŻNE:** Nazwa tabeli w `.from()` MUSI mieć prefix!

**Pattern - kluczowe elementy:**

1. **Stała `_tableName`** - zdefiniuj na górze klasy:
   ```dart
   static const _tableName = '{prefix}_{entities}';
   ```

2. **BehaviorSubject** - kontroler streamu dla listy:
   ```dart
   final _controller = BehaviorSubject<List<{Entity}Model>>();
   ```

3. **RealtimeChannel** - do realtime subscription:
   ```dart
   RealtimeChannel? _channel;
   ```

4. **`watch{Entities}(userId)`** - Stream-first pattern:
   - Initial fetch przez `_fetch{Entities}(userId)`
   - Realtime subscription przez `_client.channel()`:
     - `onPostgresChanges(event: all, table: _tableName, filter: user_id=userId)`
     - Callback: `_fetch{Entities}(userId)` (refetch on change)
   - Return `_controller.stream`

5. **`_fetch{Entities}(userId)`** - private helper:
   - `_client.from(_tableName).select().eq('user_id', userId).order('created_at')`
   - Map response → List<Model>
   - `_controller.add(list)`

6. **CRUD methods** - wszystkie używają `_tableName`:
   - `add{Entity}()` → `_client.from(_tableName).insert()`
   - `update{Entity}()` → `_client.from(_tableName).update().eq('id', id)`
   - `delete{Entity}()` → `_client.from(_tableName).delete().eq('id', id)`

7. **`dispose()`** - cleanup:
   - `_channel?.unsubscribe()`
   - `_controller.close()`

**Tip:** Zdefiniuj `_tableName` jako stałą na górze klasy - łatwiej zmienić i trudniej zapomnieć o prefixie!

### 6.3 Podmień w DI

```dart
// lib/core/di/injection.dart
@module
abstract class DataSourceModule {
  @lazySingleton
  ItemDataSource get itemDataSource => SupabaseItemDataSource(
    Supabase.instance.client,
  );
}
```

### 6.4 SupabaseProfilesDataSource → implementacja w /auth

**UWAGA:** SupabaseProfilesDataSource z migracją danych jest implementowany w `/auth`.

W /database implementujesz tylko DataSource dla tabel **domenowych** (z prefixem).

### 6.5 Aktualizuj status

- Status `/database`: `in-progress: rls`
- Kontekst: `SupabaseDataSource gotowy, konfiguracja RLS`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/database/database-6-rls.md`
