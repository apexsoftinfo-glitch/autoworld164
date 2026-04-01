# KROK 4: Repository

### 4.1 Wywołaj skill

```
Przeczytaj: .claude/skills/flutter-logic/SKILL.md

Zadanie: Stwórz {Entity}Repository pattern.

Wymagania:
- Abstrakcja + implementacja w jednym pliku
- Opakowuje DataSource
- Konwertuje wyjątki na Either<Failure, Success>
- Loguje błędy przez logError()
- NIE importuje Supabase (tylko DataSource)
```

### 4.2 Opis wzorca Repository

**Co ma robić:**
- Abstrakcja definiuje kontrakt: `watch{Entities}()`, `add{Entity}()`, `update{Entity}()`, `delete{Entity}()`
- Impl przyjmuje DataSource w konstruktorze
- `watch{Entities}()` - przekazuje stream z DataSource (bez try-catch)
- Mutacje - opakowują wywołanie DataSource w try-catch
- W catch: `logError(context, error, stackTrace)` + `return Left(Failure.unexpected(...))`
- Sukces: `return Right(result)`

### 4.3 Implementacja

Stwórz Repository w feature:
```
lib/features/{feature}/repository/
└── {entity}_repository.dart  # Abstrakcja + Impl
```

### 4.4 Aktualizuj status

- Status `/logic`: `in-progress: cubits`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/logic/logic-6-cubits.md`
