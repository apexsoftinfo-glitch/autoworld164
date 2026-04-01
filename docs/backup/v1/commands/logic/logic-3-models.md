# KROK 2: Modele (freezed)

### 2.1 Wywołaj skill

```
Przeczytaj: .claude/skills/flutter-logic/SKILL.md

Zadanie: Stwórz modele na podstawie zaprojektowanego modelu danych.

Wymagania:
- Używaj freezed
- **freezed 3+:** klasy MUSZĄ być oznaczone jako `abstract` (np. `abstract class TaskModel with _$TaskModel`)
- Końcówka Model: {Entity}Model
- Pola z zaprojektowanego modelu + id, userId, createdAt, updatedAt
- Metody factory dla JSON serialization
```

### 2.2 Implementacja

Stwórz modele w odpowiednich feature'ach:
```
lib/features/{feature}/models/
├── {entity}_model.dart
├── {entity}_model.freezed.dart
└── {entity}_model.g.dart
```

### 2.3 Generuj kod

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2.4 Aktualizuj status

- Status `/logic`: `in-progress: datasource`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/logic/logic-4-datasource.md`
