# Zadanie

Sprawdź czy checklisty w docs/tasks/checklists/ są ukończone.

Jeżeli nie, poinformuj użytkownika, że najpierw należy je wykonać.

Jeżeli tak, przejrzyj @IDEA.md oraz ułóż plan implemnetacji aplikacji. 

Zapisz go poniżej w pliku @docs/steps/04_implement.md w `# IMPLEMENTATION PLAN:`.

Pamiętaj aby przestrzegać zasad z @AGENTS.md

Wszelkie ekrany muszą przestrzegać zasad wizualnych sprecyzowanych specjalnie pod tą aplikację w @DESIGN.md.

Ekran główny pownien być już zaprojektowany wizualnie, ale jeszcze w żaden sposób nie spięty z flow aplikacji ani z bazą. 

Wszelkie dane mają być zapisywane do Supabase z user_id zalogowanego użytkownika/gościa.

Pamiętaj o jednym wspólny prefixie dla nowych tabel w Supabase, zdefiniowanym w @AGENTS.md.

# Flow aplikacji

## Pierwsze uruchomienie

Ma koniecznie działać następujące flow aplikacji:

- Welcome Screen i dwie ścieżki wyboru: "Kontynuuj jako gość" oraz "Zaloguj się".

"Zaloguj się" ma przekierowywać do ekranu logowania za pomocą emaila i hasła, po którym zalogowany user trafia na główny ekran aplikacji.

"Kontynuuj jako gość" ma od razu przekierowywać na główny ekran aplikacji.

Jedna i druga ścieżka ma być obsłużona za pomocą Supabase Auth. 

Każde kolejne uruchomienie ma przekierowywać bezpośrednio na ekran home.

Wylogowanie / Usunięcie konta ma przenosić na Welcome Screen. 

Upewnij się, że plan implementacyjny uwzględnia ten flow.

## Dostęp do user profile

Z ekranu głównego user ma mieć dostęp do ekranu profilu, z którego może:

**Wspólne elementy**
- możliwość edycji `firstName`
- przycisk `Usuń konto`

**Tylko dla anonymous**
- Zarejestrować się, co oznacza tak naprawdę podlinkowanie istniejacego konta anonymous do konta email + password. Flow ma przypominać rejestrację a komunikaty mają mówić o "nowym koncie" choć w rzeczywistości pod spodem robimy tylko link.
- Zalogować się - tutaj trafia na ekran logowania, ale z komunikatem że utraci wszystkie swoje dane jakie miał na koncie gościa. Nie robimy migracji.

**Tylko dla zalogowanego**
- przycisk `Wyloguj się`

**Niezależnie od typu konta**
Przycisk `Kup Pro` jest pokazywany wszystkim, którzy jeszcze nie mają `Pro`, czyli i guestowi, i zalogowanemu userowi. 

Wszystkie te rzeczy powinny działać out of the box, raczej nie musisz tego implementować, ale weź to pod uwagę.

