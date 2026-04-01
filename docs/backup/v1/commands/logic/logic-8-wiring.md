# KROK 7: Podpięcie UI

### 7.1 Zamień setState na BlocBuilder

Przejrzyj ekrany i zamień:
- `setState()` → `context.read<Cubit>().method()`
- `StatefulWidget` z logiką → `BlocBuilder`

**Ekrany do podpięcia:**
- **Home** → `{Entities}Cubit` (lista) + `ProfilesCubit` (greeting)
- **Settings** → `ProfilesCubit` (edycja imienia)
- **Detail** → `{Entity}Cubit` (szczegóły)
- **Add/Edit** → `{Entity}Cubit` (formularz)

### 7.2 Singleton vs Factory (KRYTYCZNE!)

**Cubity współdzielone między widgetami** (np. ProfilesCubit, EntriesCubit - używane w Home, Settings, Detail):
- DI: `registerLazySingleton` → jedna instancja w całej aplikacji
- UI: `BlocProvider.value(value: getIt<Cubit>())` → NIE zamyka singletona przy dispose

**Cubity per-screen** (np. formularz edycji, jednorazowy dialog):
- DI: `registerFactory` → nowa instancja za każdym razem
- UI: `BlocProvider(create: (_) => getIt<Cubit>())` → zamyka przy dispose (OK)

**Dlaczego to ważne:**
- `registerFactory` + dwa widgety = dwa różne instance → dane trafiają do jednego, UI renderuje drugi → UI się nie aktualizuje!
- `BlocProvider(create:)` z singletonem → dispose zamyka singleton → cubit umiera globalnie!

```dart
// ✅ DOBRZE - singleton współdzielony
// DI:
getIt.registerLazySingleton<{Entities}Cubit>(
  () => {Entities}Cubit(getIt<{Entity}Repository>()),
);

// UI (main.dart lub app.dart):
BlocProvider<{Entities}Cubit>.value(value: getIt<{Entities}Cubit>()),

// ❌ ŹLE - factory + value lub singleton + create
getIt.registerFactory<{Entities}Cubit>(...); // każde getIt() = nowa instancja!
BlocProvider(create: (_) => getIt<Singleton>()); // dispose zamknie singleton!
```

### 7.3 Wzorzec BlocBuilder (odczyt stanu)

```dart
class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<{Entities}Cubit, {Entities}State>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox(),
          loading: () => const LoadingIndicator(),
          loaded: (items) => _{Entities}List(items: items),
          error: (message) => ErrorWidget(message: message),
        );
      },
    );
  }
}
```

### 7.4 Zarejestruj w DI

Zarejestruj DataSource (jako Fake), Repository i Cubit w `lib/core/di/`.

**Reguła:** Wszystkie cubity współdzielone między ekranami → `registerLazySingleton`.
Wszystkie DataSource i Repository → `registerLazySingleton` (zawsze).

### 7.5 Konwersja ThemeNotifier → ThemeCubit

> **Notatka:** Ten krok konwertuje ThemeNotifier z /screens na ThemeCubit dla spójności architektury.

**Co zrobić:**
1. Stwórz `lib/core/theme/theme_cubit.dart` z ThemeCubit (emituje ThemeMode)
2. W `app.dart`: zamień `ChangeNotifierProvider<ThemeNotifier>` na `BlocProvider<ThemeCubit>`
3. W `app.dart`: zamień `Consumer<ThemeNotifier>` na `BlocBuilder<ThemeCubit, ThemeMode>`
4. W Settings: zamień `context.read<ThemeNotifier>().toggle()` na `context.read<ThemeCubit>().toggle()`
5. Usuń `lib/core/theme/theme_notifier.dart`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/logic/logic-9-verify.md`
