# KROK 10: Finalizacja

> **⚠️ WYKONAJ NATYCHMIAST po "ok" od usera! Nie wyświetlaj komunikatu i nie czekaj — od razu rób poniższe kroki.**

### 10.1 Flutter analyze (OBOWIĄZKOWE!)

```bash
flutter analyze
```

**Wyczyść WSZYSTKO** - zero błędów, zero warningów, zero info!

### 10.2 Aktualizuj CLAUDE.md na done

- Status `/logic`: `done`
- Kontekst: `Modele, Cubity, Repo, FakeDataSource, testy`
- Next Action: `Wpisz /onboarding`

Zaktualizuj sekcję "▶ Co dalej" w CLAUDE.md:

~~~markdown
## ▶ Co dalej

**Następny krok:** `/onboarding` — Welcome + Guided Onboarding od zera
**Instrukcje:** `.claude/commands/onboarding.md`

> Wpisz `/onboarding` gdy będziesz gotowy!
~~~

### 10.3 Auto-commit

```bash
git add -A
git commit -m "feat(logic): implement business logic layer

- Add freezed models
- Implement stream-first FakeDataSource
- Add repositories with Either error handling
- Implement cubits with stream subscriptions
- Add cubit tests
- Wire up UI with BlocBuilder"
```

### 10.4 Zapowiedź następnego kroku

> Dopiero TERAZ (po ustawieniu done + commit) wyświetl komunikat userowi:

```
Logika gotowa! Commit wykonany.
Wpisz `/onboarding` gdy będziesz gotowy.
```

---

## Reguły dla Agenta AI

### KRYTYCZNE
- Stream-first dla list (BehaviorSubject + emit po każdej mutacji)
- Cubit z StreamSubscription + `close()` anuluje subscription
- Either<Failure, Success> w Repository
- `logError()` w każdym catch w Repository/DataSource
- **Nie rób commita bez potwierdzenia usera "ok"!**

### WAŻNE
- Testy dla każdego Cubita
- Abstrakcja + Impl w jednym pliku (Repository, DataSource)
- Modele zgodne ze schematem Supabase z CLAUDE.md
- DI: DataSource → Repository → Cubit

### ZAKAZY
- `Future<List>` zamiast `Stream<List>` dla danych listowych
- Import Supabase poza DataSource
- Import warstwy wyższej (Repository nie importuje Cubit)
- Cubit bez `close()` przy StreamSubscription
- Repository bez error handling
- Commit lub zapowiedź następnego kroku bez "ok" usera
- `registerFactory` dla cubitów współdzielonych między widgetami (→ `registerLazySingleton`!)
- `BlocProvider(create:)` z singletonem z get_it (→ `BlocProvider.value`!)

### Synchronizacja (OBOWIĄZKOWE)
- Przy KAŻDEJ zmianie statusu → sync z platformą
- Na końcu kroku sprawdź czy było trudno → zapisz struggle (bez pytania usera)
- Jeśli API zwraca 401 → poproś o nowy API Key

---

## Struktura plików po /logic

```
lib/
├── core/
│   └── theme/
│       └── theme_cubit.dart        # Globalny theme (Cubit, nie ChangeNotifier!)
├── features/
│   └── {feature}/
│       ├── models/
│       │   ├── {entity}_model.dart
│       │   └── {entity}_model.freezed.dart
│       ├── data_source/
│       │   ├── {entity}_data_source.dart       # Abstrakcja
│       │   └── fake_{entity}_data_source.dart
│       ├── repository/
│       │   └── {entity}_repository.dart        # Abstrakcja + Impl
│       ├── cubit/
│       │   ├── {entities}_cubit.dart
│       │   └── {entities}_cubit.freezed.dart
│       └── ui/
│           └── ...

test/features/{feature}/cubit/
└── {entities}_cubit_test.dart
```

---

## Checklisty

### Po KROKU 1:
- [ ] IDEA.md przeczytane, model danych zaprojektowany i zapisany do IDEA.md
- [ ] Schemat Supabase zaplanowany
- [ ] Schemat zapisany w CLAUDE.md (sekcja "Database Schema")

### Po KROKU 2:
- [ ] Modele stworzone (freezed)
- [ ] Modele zgodne ze schematem z CLAUDE.md
- [ ] build_runner wykonany

### Po KROKU 3:
- [ ] FakeDataSource z BehaviorSubject
- [ ] Stream-first pattern

### Po KROKU 4:
- [ ] Repository z Either
- [ ] logError w catch

### Po KROKU 5:
- [ ] Cubity z StreamSubscription
- [ ] close() anuluje subscription

### Po KROKU 6:
- [ ] Testy cubitów (bloc_test)
- [ ] flutter test przechodzi

### Po KROKU 7:
- [ ] UI używa BlocBuilder
- [ ] DI zarejestrowane
- [ ] ThemeNotifier przekonwertowany na ThemeCubit
- [ ] app.dart używa BlocProvider<ThemeCubit>
- [ ] Settings używa context.read<ThemeCubit>()
- [ ] theme_notifier.dart usunięty

### Po KROKU 8:
- [ ] flutter test OK
- [ ] flutter analyze OK
- [ ] Smoke test przechodzi
- [ ] Status ustawiony na `ready-to-test`

### Po KROKU 9:
- [ ] User przetestował testy i aplikację
- [ ] CRUD działa (add/edit/delete)
- [ ] Real-time updates działają
- [ ] **User potwierdził "ok"**

### Po KROKU 10 (TYLKO po "ok"!):
- [ ] Status ustawiony na `done`
- [ ] CLAUDE.md zaktualizowane
- [ ] Commit wykonany
- [ ] Status zaktualizowany w CLAUDE.md na `done`
- [ ] **Status zsynchronizowany z platformą:**
```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{logic_step_id}", "status": "done"}]}'
```
- [ ] Agent sprawdził czy krok był trudny → jeśli tak, zapisał struggle do API

---

> ✅ KROK /logic ukończony!
