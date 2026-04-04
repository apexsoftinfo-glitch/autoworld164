# Start Checklist

Jest to checklista instrukcji `docs/steps/02_start.md`.

Aktualizuj ten plik w trakcie pracy.

Statusy:
- `⬜` = `pending`
- `⏳` = `waiting_for_user`
- `✅` = `done`

## Krok 1. Sprawdź `PLATFORM_API_KEY` i dane autora

| Status | Item |
| --- | --- |
| ⬜ | `.env` istnieje |
| ⬜ | `.env` zawiera `PLATFORM_API_KEY=` |
| ⬜ | Jeśli `PLATFORM_API_KEY` brakowało: user dostał instrukcję uzupełnienia `.env` albo świadomie kontynuowano bez klucza |
| ⬜ | Jeśli `PLATFORM_API_KEY` było dostępne: podjęto próbę pobrania danych autora z endpointu user |
| ⬜ | Imię autora zostało ustalone |
| ⬜ | Nazwisko autora zostało ustalone |
| ⬜ | Jeśli endpoint user nie zwrócił danych: brak został poprawnie obsłużony ścieżką ręczną |

## Krok 2. Ustal i zweryfikuj pomysł aplikacji

| Status | Item |
| --- | --- |
| ⬜ | Ustalono konkretny pomysł na aplikację |
| ⬜ | Rozmowa była prowadzona od użytkownika do produktu, a nie od strategii do checklisty |
| ⬜ | Agent zebrał informacje o codziennych sytuacjach, frustracjach, zainteresowaniach lub obecnym sposobie radzenia sobie użytkownika z problemem |
| ⬜ | Potwierdzono, że aplikacja robi jedną rzecz dobrze |
| ⬜ | Potwierdzono, że aplikacja jest prosta jako MVP |
| ⬜ | Potwierdzono, że aplikacja jest wykonalna w stacku Flutter + Supabase bez dodatkowych kosztów |
| ⬜ | Potwierdzono, że pomysł nie wymaga problematycznych integracji, umów ani nie narusza praw |
| ⬜ | Ustalono niszę i docelowego użytkownika |
| ⬜ | Ustalono problem, który aplikacja ma rozwiązywać |
| ⬜ | Ustalono główną obietnicę wartości aplikacji |
| ⬜ | Ustalono proste MVP |
| ⬜ | Agent pomógł doprecyzować kluczowe założenia produktu, zamiast przerzucać tę pracę na usera |
| ⬜ | Potwierdzono, że autor sam chce z tej aplikacji korzystać |
| ⬜ | Sprawdzono endpoint community apps pod kątem duplikatu pomysłu |
| ⬜ | Potwierdzono, że pomysł nie dubluje istniejącej aplikacji community albo różnica została świadomie zaakceptowana |
| ⬜ | User zatwierdził pomysł do realizacji |

## Krok 3. Utwórz `docs/IDEA.md`

| Status | Item |
| --- | --- |
| ⬜ | `docs/IDEA.md` istnieje |
| ⬜ | `docs/IDEA.md` zawiera nazwę aplikacji |
| ⬜ | `docs/IDEA.md` zawiera imię i nazwisko autora |
| ⬜ | `docs/IDEA.md` zawiera `APP_BUNDLE_ID` |
| ⬜ | `APP_BUNDLE_ID` ma poprawny format `com.imienazwisko.appname` |
| ⬜ | `docs/IDEA.md` zawiera `SUPABASE_TABLE_PREFIX` |
| ⬜ | `SUPABASE_TABLE_PREFIX` jest równy ostatniemu segmentowi `APP_BUNDLE_ID` z dopisanym `_` |
| ⬜ | `docs/IDEA.md` opisuje co aplikacja robi |
| ⬜ | `docs/IDEA.md` opisuje docelowego użytkownika |
| ⬜ | `docs/IDEA.md` opisuje główny ból użytkownika |
| ⬜ | `docs/IDEA.md` opisuje, jak użytkownik radzi sobie dziś z problemem |
| ⬜ | `docs/IDEA.md` opisuje, co w obecnym sposobie jest niewygodne, za wolne albo nieskuteczne |
| ⬜ | `docs/IDEA.md` wyjaśnia, dlaczego aplikacja ma być dla użytkownika lepszym rozwiązaniem |
| ⬜ | `docs/IDEA.md` opisuje rezultat, który użytkownik chce osiągnąć |
| ⬜ | `docs/IDEA.md` opisuje wartość dla użytkownika |
| ⬜ | `docs/IDEA.md` zawiera główną obietnicę wartości aplikacji |
| ⬜ | `docs/IDEA.md` opisuje niszę aplikacji |
| ⬜ | `docs/IDEA.md` zawiera język i sformułowania użytkownika z rozmowy |
| ⬜ | `docs/IDEA.md` zawiera krótki opis aplikacji |
| ⬜ | `docs/IDEA.md` zawiera długi opis aplikacji |
| ⬜ | `docs/IDEA.md` zawiera ustalenia z rozmowy z userem |
| ⬜ | `docs/IDEA.md` zawiera opis pierwszego głównego ekranu po onboardingu (Home Screen) |
| ⬜ | `docs/IDEA.md` zawiera listę pozostałych ekranów |
| ⬜ | `docs/IDEA.md` rozróżnia funkcje free i pro oraz proponuje podstawowe limity |
| ⬜ | `docs/IDEA.md` zawiera plan wersji `0.0.1`, `0.0.2`, `0.0.3` |
| ⬜ | Kluczowe sekcje `docs/IDEA.md` zostały uzupełnione treścią, a nie zostawione jako puste hasła dla usera |

## Krok 4. Zweryfikuj `docs/IDEA.md` z userem

| Status | Item |
| --- | --- |
| ⬜ | User został poproszony o weryfikację `docs/IDEA.md` |
| ⬜ | Jeśli user zgłosił uwagi do dokumentów: zostały uwzględnione |
| ⬜ | User ostatecznie zatwierdził `docs/IDEA.md` |

## Krok 5. Ustaw identyfikatory aplikacji

| Status | Item |
| --- | --- |
| ⬜ | `APP_BUNDLE_ID` został ustawiony w aplikacji |
| ⬜ | `APP_DISPLAY_NAME` został ustawiony w aplikacji |
| ⬜ | Zmiany wykonano zgodnie z `docs/tasks/UPDATE_APP_IDENTIFIERS.md` |
| ⬜ | Zmiany wykonano zgodnie z `docs/tasks/UPDATE_APP_DISPLAY_NAME.md` |

## Krok 6. Zaktualizuj `AGENTS.md`

| Status | Item |
| --- | --- |
| ⬜ | Placeholder `<app_description>...</app_description>` został podmieniony w sekcji `App Context` w `AGENTS.md` |
| ⬜ | Sekcja `App Context` w `AGENTS.md` zawiera krótki opis aplikacji w `1-3` zdaniach |
| ⬜ | Sekcja `App Context` w `AGENTS.md` odsyła do `docs/IDEA.md` po pełny opis produktu |
| ⬜ | Placeholder `<supabase_table_prefix>` został podmieniony w `AGENTS.md` |
| ⬜ | Użyty prefix jest zgodny z ustalonym `SUPABASE_TABLE_PREFIX` |

## Krok 7. Wykonaj commity

| Status | Item |
| --- | --- |
| ⬜ | `docs/IDEA.md` i `docs/ONBOARDING_AND_PAYWALL.md` zostały zapisane w osobnym commicie |
| ⬜ | Pozostałe zmiany zostały zapisane w oddzielnym commicie lub commitach |

## Krok 8. Wyślij dane aplikacji do platformy

| Status | Item |
| --- | --- |
| ⬜ | Jeśli `PLATFORM_API_KEY` był dostępny: wykonano request dodający aplikację do konta usera z kompletem wymaganych pól |
| ⬜ | Jeśli request dodający aplikację zakończył się sukcesem i zwrócił `id`: zapisano je do `.env` jako `APP_PLATFORM_ID=` |

## Końcowe potwierdzenie

| Status | Item |
| --- | --- |
| ⬜ | Stan faktyczny plików i wykonanych działań został sprawdzony |
| ⬜ | Checklista została zaktualizowana i wszystkie możliwe pozycje mają status `done` zgodny ze stanem rzeczywistym tego projektu |
