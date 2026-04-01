# KROK 3: FakeDataSource

### 3.1 Wywołaj skill

```
Przeczytaj: .claude/skills/flutter-logic/SKILL.md

Zadanie: Stwórz Fake{Entity}DataSource dla testowania bez backendu.

Wymagania:
- BehaviorSubject dla list (stream-first!)
- Emit po każdej mutacji
- Symulowane opóźnienia (await Future.delayed)
- In-memory storage (Map/List)
- Przygotowanie na podmianę na Supabase
```

### 3.2 Opis wzorca FakeDataSource

**Co ma robić:**
- Przechowywać dane w `Map<String, {Entity}Model>` (klucz = id)
- Używać `BehaviorSubject<List<{Entity}Model>>` seeded pustą listą
- `watch{Entities}(userId)` - filtrować stream po userId
- `add{Entity}()` / `update{Entity}()` / `delete{Entity}()` - mutować Map, potem `_emit()`
- `_emit()` - emitować `_map.values.toList()` do controllera
- `dispose()` - zamknąć controller
- Symulować opóźnienie: `await Future.delayed(Duration(milliseconds: 300))`

### 3.3 Implementacja

Stwórz DataSource w feature:
```
lib/features/{feature}/data_source/
├── {entity}_data_source.dart     # Abstrakcja
└── fake_{entity}_data_source.dart
```

### 3.4 Aktualizuj status

- Status `/logic`: `in-progress: repository`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/logic/logic-5-repository.md`
