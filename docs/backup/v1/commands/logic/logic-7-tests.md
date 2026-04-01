# KROK 6: Testy Cubitów

### 6.1 Wywołaj skill

```
Przeczytaj: .claude/skills/flutter-logic/SKILL.md

Zadanie: Napisz testy dla {Entities}Cubit.

Wymagania:
- Mockowanie Repository (mocktail)
- Testowanie stanów (bloc_test)
- Testowanie stream subscription
- Testowanie error handling
```

### 6.2 Opis wzorca testu Cubit

**Co testować:**
- `watchItems succeeds` → emituje [loading, loaded(items)]
- `watchItems fails` → emituje [loading, error(message)]
- `addItem succeeds` → wywołuje repository.addItem
- `addItem fails` → emituje error state
- Użyj `MockRepository extends Mock implements Repository`
- `setUp`: twórz mock i cubit
- `tearDown`: `cubit.close()`

### 6.3 Implementacja

Stwórz testy:
```
test/features/{feature}/cubit/
└── {entities}_cubit_test.dart
```

### 6.4 Uruchom testy

```bash
flutter test
```

### 6.5 Aktualizuj status

- Status `/logic`: `in-progress: wiring`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/logic/logic-8-wiring.md`
