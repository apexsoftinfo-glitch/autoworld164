# Initialize App Setup

Wykonaj wszystkie te kroki.

To nie jest instrukcja do brainstormingu. To jest instrukcja wykonawcza.

## Cel

Masz najpierw przygotować konfigurację pod `Supabase MCP`.
Dopiero po restarcie agenta AI masz sprawdzić MCP i uzupełnić lokalne pliki aplikacji.
Twoim celem jest doprowadzić checklistę do stanu, w którym wszystkie możliwe pozycje mają status `done`.

## Zasada pracy z checklistą

- Na starcie otwórz:
  - `docs/tasks/checklists/01_INITIALIZE_APP_SETUP_CHECKLIST.md`
- Realizuj kroki dokładnie w kolejności `Krok 1 -> Krok 2 -> Krok 3 ...`.
- Nie wykonuj kilku kroków naraz.
- Po każdym kroku zatrzymaj się i sprawdź, czy wolno przejść dalej.
- Najpierw sprawdź stan faktyczny plików i uzupełnij checklistę.
- Nie zakładaj, że wszystko jest `pending`.
- Jeśli coś już istnieje i jest poprawne, oznacz to jako `done`.
- Jeśli czekasz na ruch usera, oznacz to jako `waiting_for_user`.
- Po każdym wykonanym kroku zaktualizuj checklistę.
- Przy każdej aktualizacji checklisty zmień emoji statusu w pierwszej kolumnie.
- Używaj spójnie tylko tych statusów emoji: `⬜`, `⏳`, `✅`.
- Jeśli task zatrzymuje się na restarcie agenta AI, zakończ go i wróć dopiero po restarcie.
- Na końcu zakończ task dopiero wtedy, gdy wszystkie możliwe pozycje mają status `done`.

## Krok 1. Utwórz `.env`

- Utwórz plik:
  - `.env`
- Wklej do `.env` dokładnie to:

```env
SUPABASE_PROJECT_ID=
SUPABASE_ACCOUNT_ACCESS_TOKEN=
PLATFORM_API_KEY=
APP_PLATFORM_ID=
```

- Po zakończeniu tego kroku zaktualizuj checklistę.

## Krok 2. Przygotuj placeholdery pod Supabase MCP

- Utwórz folder:
  - `.codex`
- Utwórz plik:
  - `.codex/config.toml`
- Wklej do niego dokładnie to:

```toml
[mcp_servers.supabase]
enabled = true
url = "https://mcp.supabase.com/mcp?project_ref=__SUPABASE_PROJECT_ID__"
http_headers = { Authorization = "Bearer __SUPABASE_ACCOUNT_ACCESS_TOKEN__" }
```

- Utwórz plik:
  - `.mcp.json`
- Wklej do niego dokładnie to:

```json
{
  "mcpServers": {
    "supabase": {
      "type": "http",
      "url": "https://mcp.supabase.com/mcp?project_ref=__SUPABASE_PROJECT_ID__",
      "headers": {
        "Authorization": "Bearer __SUPABASE_ACCOUNT_ACCESS_TOKEN__"
      }
    }
  }
}
```

- Utwórz plik:
  - `opencode.json`
- Wklej do niego dokładnie to:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "supabase_mcp": {
      "type": "remote",
      "url": "https://mcp.supabase.com/mcp?project_ref=__SUPABASE_PROJECT_ID__",
      "headers": {
        "Authorization": "Bearer __SUPABASE_ACCOUNT_ACCESS_TOKEN__"
      },
      "enabled": true
    }
  }
}
```

- Po zakończeniu tego kroku zaktualizuj checklistę.

## Krok 3. Poproś usera o uzupełnienie `.env`

- Powiedz userowi, że ma uzupełnić:
  - `SUPABASE_PROJECT_ID`
  - `SUPABASE_ACCOUNT_ACCESS_TOKEN`
  - `PLATFORM_API_KEY`
- Nie zgaduj tych wartości.
- Nie wpisuj placeholderów do `.env`.
- Poczekaj, aż user wpisze prawdziwe dane.
- Jeśli `.env` nadal jest puste, ustaw odpowiednie pozycje checklisty na `waiting_for_user`.
- Jeśli user już uzupełnił `.env`, oznacz to jako `done`.

- Po zakończeniu tego kroku zaktualizuj checklistę.

## Krok 4. Zaktualizuj pliki MCP po uzupełnieniu `.env`

- Odczytaj wartości z:
  - `.env`
- Podmień placeholder `__SUPABASE_PROJECT_ID__` na wartość z:
  - `SUPABASE_PROJECT_ID`
- Podmień placeholder `__SUPABASE_ACCOUNT_ACCESS_TOKEN__` na wartość z:
  - `SUPABASE_ACCOUNT_ACCESS_TOKEN`
- Zaktualizuj te pliki:
  - `.codex/config.toml`
  - `.mcp.json`
  - `opencode.json`
- Po tej podmianie w tych plikach nie mogą zostać placeholdery.

- Po zakończeniu tego kroku zaktualizuj checklistę.

## Krok 5. Wymuś restart agenta AI

- Powiedz userowi, że po konfiguracji MCP musi:
  - zamknąć i uruchomić swojego agenta AI ponownie
  - albo rozpocząć nową sesję, jeśli jego narzędzie tak działa
- Jeśli znasz dokładną komendę do kontynuowania tej sesji, zostaw ją userowi.
- Nie zgaduj komendy resume.
- Jeśli twoje narzędzie nie podaje pewnej komendy resume, powiedz userowi, żeby po restarcie wrócił do tego taska i kontynuował od kroku 6.
- Nie przechodź dalej w tym tasku, dopóki restart nie nastąpi.
- Jeśli restart jeszcze nie nastąpił:
  - ustaw odpowiednie pozycje checklisty na `waiting_for_user`
  - zakończ task

- Po zakończeniu tego kroku zaktualizuj checklistę.

## Krok 6. Po restarcie sprawdź, czy `Supabase MCP` działa

- Po restarcie upewnij się, że masz działający dostęp do projektu przez `Supabase MCP`.
- Sprawdź, czy możesz odczytać:
  - URL projektu `Supabase`
  - klucz `anon` albo aktywny klucz publishable zgodny z tym projektem
- Jeśli `Supabase MCP` po restarcie nadal nie działa:
  - ustaw odpowiednie pozycje checklisty na `waiting_for_user`
  - zakończ task

- Po zakończeniu tego kroku zaktualizuj checklistę.

## Krok 7. Uzupełnij `config/api-keys.json` z `Supabase MCP`

- Utwórz plik:
  - `config/api-keys.json`
- Wklej do niego dokładnie to:

```json
{
  "SUPABASE_URL": "",
  "SUPABASE_ANON_KEY": "",
  "REVENUECAT_APPLE_API_KEY": "",
  "REVENUECAT_GOOGLE_API_KEY": ""
}
```

- Następnie uzupełnij:
  - `SUPABASE_URL`
  - `SUPABASE_ANON_KEY`
- Weź te wartości z projektu przez `Supabase MCP`.
- Jeśli projekt ma zarówno legacy `anon key`, jak i nowy publishable key, do `SUPABASE_ANON_KEY` wpisz legacy `anon key`.
- Klucze `RevenueCat` zostaw puste na tym etapie.

- Po zakończeniu tego kroku zaktualizuj checklistę.

## Krok 8. Utwórz placeholder `android/key.properties`

- Utwórz plik:
  - `android/key.properties`
- Najpierw wykryj system usera.
- Jeśli user uruchamia to na `macOS` lub `Linux`, wklej do `android/key.properties` dokładnie to:

```properties
storePassword=
keyPassword=
keyAlias=upload
storeFile=/Users/<uzytkownik>/12appschallenge/secrets/app_name/upload-keystore.p12
```

- Jeśli user uruchamia to na `Windows`, wklej do `android/key.properties` dokładnie to:

```properties
storePassword=
keyPassword=
keyAlias=upload
storeFile=C:/Users/<uzytkownik>/12appschallenge/secrets/app_name/upload-keystore.p12
```

- Nie zgaduj prawdziwej ścieżki do keystore.
- Zostaw ten plik jako placeholder do późniejszego uzupełnienia przez usera.

- Po zakończeniu tego kroku zaktualizuj checklistę.

## Krok 9. Poproś usera o wygenerowanie Android upload keystore

- To ma być nowy upload keystore dla tej aplikacji.
- Najpierw wykryj system usera.
- Jeśli user uruchamia to na `Windows`, poleć mu uruchomić:

```powershell
keytool -genkey -v -keystore $env:USERPROFILE\\upload-keystore.p12 -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

- Jeśli user uruchamia to na `macOS`, poleć mu uruchomić:

```bash
keytool -genkey -v -keystore ~/upload-keystore.p12 -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

- Powiedz userowi, że po wygenerowaniu ma:
  - przenieść plik keystore do zalecanej ścieżki dla tej aplikacji
  - samodzielnie uzupełnić `android/key.properties`
- Dla `macOS` lub `Linux` zaproponuj ścieżkę:
  - `/Users/<uzytkownik>/12appschallenge/secrets/app_name/upload-keystore.p12`
- Dla `Windows` zaproponuj ścieżkę:
  - `C:/Users/<uzytkownik>/12appschallenge/secrets/app_name/upload-keystore.p12`
- Powiedz userowi, że ma samodzielnie wpisać do `android/key.properties`:
  - `storePassword`
  - `keyPassword`
  - `storeFile`
- Nie proś usera, żeby podawał ci te wartości w rozmowie.
- Powiedz userowi:
  - daj mi znać, gdy wykonasz tę komendę, przeniesiesz plik i uzupełnisz `android/key.properties`
  - wtedy dokończę weryfikację i zamknę task
- Ustaw odpowiednie pozycje checklisty na `waiting_for_user`.
- Jeśli user potwierdził wykonanie tego kroku, sprawdź stan faktyczny plików i oznacz odpowiednie pozycje jako `done`.

- Po zakończeniu tego kroku zaktualizuj checklistę.

## Krok 10. Zakończ pracę

- Nie commituj tych plików:
  - `config/api-keys.json`
  - `android/key.properties`
  - `.env`
  - `.codex/config.toml`
  - `.mcp.json`
  - `opencode.json`
- Te pliki są lokalne i są w `.gitignore`.
- Sprawdź stan faktyczny plików i upewnij się, że cała instrukcja została naprawdę wykonana.
- Nie opieraj się tylko na statusach wpisanych w checklistę.
- Otwórz checklistę jeszcze raz i upewnij się, że wszystkie możliwe pozycje mają status `done`.
- Jeśli coś nadal ma status `pending` albo `waiting_for_user`, nie zamykaj taska jako zakończonego.
- Jeśli checklista została zaktualizowana, zrób commit tej checklisty.
- Użyj jasnego opisu commita, np.:
  - `docs: complete step 01: initialize app setup checklist`
- Na końcu poinformuj usera:
  - że lokalny setup jest gotowy
  - że `Supabase MCP` działa
  - że `config/api-keys.json` zostało uzupełnione danymi `Supabase`
  - że commit został wykonany
  - użyj w tej finalnej wiadomości `🎉🎉🎉`
