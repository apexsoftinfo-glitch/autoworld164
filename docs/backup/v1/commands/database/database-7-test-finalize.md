# KROK 8-10: Smoke Test, Feedback, Finalizacja

## KROK 8: Smoke Test

### 8.1 Uruchom aplikację

```bash
flutter run
```

### 8.2 Testuj CRUD

1. **Create**: Dodaj element → czy pojawia się w Supabase?
2. **Read**: Czy lista ładuje się z Supabase?
3. **Update**: Edytuj element → czy zmiany są w Supabase?
4. **Delete**: Usuń element → czy znika z Supabase?

### 8.3 Sprawdź realtime

1. Otwórz aplikację w dwóch oknach
2. Dodaj element w jednym → czy pojawia się w drugim?

### 8.4 Sprawdź dane w Supabase

```
mcp__supabase__execute_sql
query: SELECT * FROM items WHERE user_id = 'dev-user-001';
```

### 8.5 Ustaw status ready-to-test

W `CLAUDE.md`:
- Status `/database`: `ready-to-test`
- Kontekst: `Supabase zintegrowane, CRUD działa, czeka na testy usera`

---

## KROK 9: Test & Feedback (OBOWIĄZKOWE!)

### 9.1 Instrukcje uruchomienia

**Dostosuj do `communication_mode` z CLAUDE.md:**

**Dla beginner:**
```
Teraz sprawdź czy Supabase działa.

Uruchom aplikację:
flutter run

Przetestuj:
1. Dodaj element → czy zapisuje się w bazie?
2. Odśwież aplikację → czy element nadal jest?
3. Edytuj element → czy zmiany są widoczne?
4. Usuń element → czy znika z bazy?

Sprawdź też w dashboardzie Supabase (Table Editor):
- Czy widzisz swoje dane w tabeli?

Jak działa, napisz "ok". Jak coś nie działa - powiedz co.
```

**Dla intermediate/advanced:**
```
`flutter run` - CRUD smoke test.
Sprawdź Supabase dashboard czy dane się zapisują.
Realtime: otwórz 2 okna, dodaj w jednym → czy pojawi się w drugim?
Jak OK, napisz "ok".
```

### 9.2 Zadaj konkretne pytania

Po testach usera, zapytaj:

```
Świetnie że przetestowałeś! Mam pytania:

1. **Zapisywanie** - dane pojawiają się w Supabase dashboard?
2. **Odczyt** - po restarcie aplikacji dane są nadal widoczne?
3. **Edycja** - zmiany zapisują się prawidłowo?
4. **Usuwanie** - element znika zarówno z app jak i z dashboard?
5. **Realtime** (opcjonalne) - czy testowałeś synchronizację między oknami?

Coś chciałbyś zmienić w konfiguracji bazy zanim zrobimy commit?
```

### 9.3 CZEKAJ na odpowiedź usera!

- **błąd połączenia** → sprawdź config/api-keys.json i credentiale
- **dane się nie zapisują** → sprawdź RLS policies
- **feedback** → wprowadź zmiany i powtórz test
- **"ok" / "działa"** → **NATYCHMIAST wykonaj KROK 10 poniżej (NIE kończ tury, NIE czekaj na kolejny input!)**

---

## KROK 10: Finalizacja

> **⚠️ WYKONAJ NATYCHMIAST po "ok" od usera! Nie wyświetlaj komunikatu i nie czekaj — od razu rób poniższe kroki.**

### 10.1 Flutter analyze (OBOWIĄZKOWE!)

```bash
flutter analyze
```

**Wyczyść WSZYSTKO** - zero błędów, zero warningów, zero info!

### 10.2 Aktualizuj CLAUDE.md na done

- Status `/database`: `done`
- Kontekst: `Supabase single-user (kDevUserId), realtime działa`
- Next Action: `Wpisz /auth`

### 10.3 Usuń tymczasowy schemat z CLAUDE.md

Schemat był potrzebny tylko do przekazania planu między `/logic` a `/database`.
Teraz jest zaimplementowany w Supabase - usuń go z CLAUDE.md:

1. Znajdź sekcję `## Database Schema (tymczasowe - usunąć po /database)` w CLAUDE.md
2. Usuń całą sekcję (od nagłówka do następnej sekcji `---`)
3. Schemat jest teraz w Supabase - CLAUDE.md nie musi go trzymać

### 10.4 Auto-commit

```bash
git add -A
git commit -m "feat(database): integrate Supabase backend

- Add Supabase configuration (api-keys.json + dart-define)
- Create database tables with migrations
- Implement SupabaseDataSource with realtime
- Add temporary RLS policies for dev user
- Replace FakeDataSource with Supabase"
```

### 10.5 Zapowiedź następnego kroku

> Dopiero TERAZ (po ustawieniu done + commit) wyświetl komunikat userowi:

```
Supabase podłączony! Commit wykonany.
Wpisz `/auth` gdy będziesz gotowy.
```

---

## Reguły dla Agenta AI

### KRYTYCZNE (blokujące)
- **Przeczytaj Table Prefix z CLAUDE.md ZANIM utworzysz jakąkolwiek tabelę!**
- **Każda nazwa tabeli = `{prefix}_{entities}`** - NIGDY bez prefixu (wyjątek: `profiles`)
- **Nie rób commita ani nie zapowiadaj następnego kroku bez potwierdzenia usera!** Zawsze czekaj na "ok" po testach
- **RLS włączone** - nawet tymczasowe polityki są lepsze niż brak RLS

### WAŻNE (best practices)
- Używaj MCP tools do operacji Supabase (pobierz URL i klucze automatycznie!)
- `user_id` w każdej tabeli domenowej
- Realtime dla streamów (nie polling)
- `config/api-keys.json` w `.gitignore` (po wypełnieniu)
- Zdefiniuj `_tableName` jako stałą na górze klasy DataSource
- Error handling dla brakujących kluczy (ConfigurationErrorApp)

### ZAKAZY (NIGDY nie rób)
- Tabele bez prefixu (wyjątek: `profiles`)
- Hardcoded credentials w kodzie (używaj config/api-keys.json + --dart-define)
- Używanie .env i flutter_dotenv (używamy JSON + dart-define!)
- Tabele bez `user_id`
- Wyłączone RLS w produkcji
- Polling zamiast realtime subscription
- Tworzenie tabel BEZ dodania do `supabase_realtime` publication (realtime nie będzie działać!)
- Commit bez potwierdzenia usera

### Synchronizacja (OBOWIĄZKOWE)
- Przy KAŻDEJ zmianie statusu → sync z platformą
- Na końcu kroku sprawdź czy było trudno → zapisz struggle (bez pytania usera)
- Jeśli API zwraca 401 → poproś o nowy API Key

---

## Struktura plików po /database

```
lib/
├── core/
│   ├── constants/
│   │   └── dev_constants.dart  # kDevUserId
│   └── supabase/
│       └── supabase_config.dart  # const supabaseUrl, supabaseAnonKey, isSupabaseConfigured
├── features/{feature}/
│   └── data_source/
│       ├── {entities}_data_source.dart
│       ├── fake_{entities}_data_source.dart  # Zachowaj dla testów
│       └── supabase_{entities}_data_source.dart  # NOWY

config/
└── api-keys.json  # Supabase credentials (w .gitignore po wypełnieniu)
```

> **Parametryzacja:** Zastąp `{feature}` i `{entities}` nazwami z IDEA.md.

---

## Checklisty

### Po KROKU 1:
- [ ] Supabase MCP działa (mcp__supabase__get_project_url zwraca URL)
- [ ] User ma konto Supabase
- [ ] Projekt Supabase istnieje
- [ ] URL i anon key dostępne przez MCP

### Po KROKU 2:
- [ ] config/api-keys.json wypełniony danymi z MCP
- [ ] .gitignore zawiera config/api-keys.json
- [ ] git rm --cached config/api-keys.json wykonane
- [ ] supabase_config.dart z String.fromEnvironment()
- [ ] ConfigurationErrorApp dla brakujących kluczy

### Po KROKU 3:
- [ ] Table Prefix przeczytany z CLAUDE.md
- [ ] Istniejące tabele sprawdzone (list_tables)
- [ ] Brak kolizji z prefixem (lub obsłużone)

### Po KROKU 4:
- [ ] Tabele domenowe utworzone z prefixem (np. `{prefix}_{entities}`)
- [ ] Index na user_id
- [ ] Trigger dla updated_at
- [ ] RLS włączone
- [ ] **Tabele dodane do `supabase_realtime` publication** (ALTER PUBLICATION)
- [ ] (profiles → /auth)

### Po KROKU 5:
- [ ] kDevUserId zdefiniowane

### Po KROKU 6:
- [ ] SupabaseDataSource implementuje interfejs
- [ ] Nazwy tabel z prefixem w DataSource
- [ ] Realtime subscription działa
- [ ] DI zaktualizowane
- [ ] (ProfilesDataSource → /auth)

### Po KROKU 7:
- [ ] RLS włączone
- [ ] Tymczasowe polityki dla dev user
- [ ] Security advisors sprawdzone

### Po KROKU 8:
- [ ] CRUD działa
- [ ] Realtime działa
- [ ] Dane widoczne w Supabase (z prefixem)
- [ ] Status ustawiony na `ready-to-test`

### Po KROKU 9:
- [ ] User przetestował CRUD w aplikacji
- [ ] User sprawdził dane w Supabase dashboard
- [ ] **User potwierdził że działa ("ok")**

### Po KROKU 10 (TYLKO po "ok"!):
- [ ] CLAUDE.md zaktualizowane (status `done`)
- [ ] Sekcja "Database Schema" usunięta z CLAUDE.md
- [ ] Commit wykonany
- [ ] Status zaktualizowany w CLAUDE.md na `done`
- [ ] **Status zsynchronizowany z platformą:**
```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{database_step_id}", "status": "done"}]}'
```
- [ ] Agent sprawdził czy krok był trudny → jeśli tak, zapisał struggle do API

> ✅ KROK /database ukończony!
