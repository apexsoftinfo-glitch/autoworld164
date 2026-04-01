# KROK 5: Cubity

### 5.1 Wywołaj skill

```
Przeczytaj: .claude/skills/flutter-logic/SKILL.md

Zadanie: Stwórz {Entities}Cubit dla feature'a.

Wymagania:
- Cubit + State w jednym pliku
- State jako freezed (initial/loading/loaded/error)
- StreamSubscription dla list
- close() z subscription.cancel()
- NIE importuje DataSource (tylko Repository)
```

### 5.2 Opis wzorca Cubit ze Stream

**Co ma robić:**
- State z freezed: `initial`, `loading`, `loaded(List<{Entity}Model>)`, `error(String)`
- `_subscription` typu `StreamSubscription?`
- `watch{Entities}(userId)` - emit loading, cancel poprzedniej subskrypcji, subskrybuj stream
- Mutacje (`add{Entity}`, etc.) - wywołują repository, obsługują Either (Left → error, Right → nic, stream zaktualizuje)
- `close()` - `_subscription?.cancel()` + `super.close()`

### 5.3 Implementacja

Stwórz Cubit w feature:
```
lib/features/{feature}/cubit/
├── {entities}_cubit.dart
└── {entities}_cubit.freezed.dart
```

### 5.4 Aktualizuj status

- Status `/logic`: `in-progress: tests`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/logic/logic-7-tests.md`
