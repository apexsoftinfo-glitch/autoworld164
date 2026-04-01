# KROK 2: Konfiguracja api-keys.json

## 2.1 Pobierz dane z Supabase MCP

Agent pobiera dane automatycznie:

```
mcp__supabase__get_project_url → SUPABASE_URL
mcp__supabase__get_publishable_keys → SUPABASE_ANON_KEY (anon key)
```

## 2.2 Wypełnij config/api-keys.json

Plik `config/api-keys.json` już istnieje w repo (pusty template). Wypełnij go danymi z MCP:

```json
{
  "SUPABASE_URL": "https://xxxxx.supabase.co",
  "SUPABASE_ANON_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

## 2.3 Dodaj do .gitignore (WAŻNE!)

**Po wypełnieniu pliku** dodaj go do `.gitignore`:

```bash
echo "config/api-keys.json" >> .gitignore
git rm --cached config/api-keys.json 2>/dev/null || true
```

To zapewnia że:
- Pusty template był w repo (dla nowych użytkowników)
- Wypełniony plik z kluczami NIE trafi do repo

## 2.4 Użycie w kodzie (--dart-define)

Klucze są przekazywane przez `--dart-define-from-file` (skonfigurowane w `.vscode/launch.json`):

```dart
// lib/core/supabase/supabase_config.dart

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

bool get isSupabaseConfigured =>
    supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
```

## 2.5 Error handling (brak kluczy)

W `main.dart` dodaj obsługę brakujących kluczy:

```dart
void main() {
  if (!isSupabaseConfigured) {
    runApp(const ConfigurationErrorApp());
    return;
  }
  // normalne uruchomienie...
}
```

`ConfigurationErrorApp` wyświetla ładny ekran z instrukcją:
```
Brak konfiguracji Supabase

Wypełnij plik config/api-keys.json:
{
  "SUPABASE_URL": "twój-url",
  "SUPABASE_ANON_KEY": "twój-klucz"
}

Znajdziesz je w Supabase Dashboard → Settings → API
```

## 2.6 Aktualizuj status

- Status `/database`: `in-progress: tables`
- Kontekst: `api-keys.json skonfigurowane, tworzenie tabel`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/database/database-3-prefix.md`
