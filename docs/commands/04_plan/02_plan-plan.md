# INTRO

Okej więc jeżeli rozumiesz już jak działa aplikacja, widzisz, jak działa Supabase Auth, twoim zadaniem będzie ułożenie planu, aby doprowadzić tą aplikację od A do Z, aby działała na naszej architekturze.

Na tym etapie nie piszesz jeszcze żadnego kodu! Tworzymy tylko dokładny plan implementacyjny!

CEL: Aplikacja musi robić jedną główną rzecz ale DOBRZE. Nie przeginaj ze scope. Ma to być proste MVP, które działa. DZIAŁA DOBRZE. 

Plan powinien zawierać w sobie implemnetację całej aplikacji. 
- kolejne ekrany z utrzymaniem stylu `lib/features/home/ui/home_screen.dart` (opisany dodatkowo w `docs/DESIGN.md`)
- cubity + test jednostkowe
- nowa struktura tabel w supabase database z użyciem zalogowanego uid
- polityki RLS
- spięcie tego wszystkiego w aktualnej architekturze z użyciem repositories i data sources
- lokalizację wszelkich stringów na pl/en
- testy integracyjne (wyrzuć przykładowy integration_test/counter_test_example.dart)
itp. 

Trzymaj się zasad opisanych w `AGENTS.md`.

Na tym etapie nie ma ograniczeń względem guest / registered / pro. Gość nie ma żadnych limitów. Rejestracja daje mu tylko taki benefit, że jego dane będą przypisane do konta i ich nie straci po usunięciu aplikacji. Zakupu konta `pro` na tym etapie jeszcze nie implementujemy.

Upewnij się, że ekrany działają na streamach, albo łatwo je odświeżyć aby nie było sytuacji że wchodzimy kilka ekranów głębiej, zmieniamy coś, wracamy parę razy wstecz na stacku, a tam wyświetlają się nieaktualne dane.

Upewnij się że wszelkie operacje dodawania, edycji, usuwania działają bez problemu.

W miejscach gdzie mają wyświetlać się elementy zaplanuj ładne empty states gdy jeszcze nic nie jest dodane.

Pamiętaj, aby ograć obsługę błędów zarówno w UI jak i w Debug Console przez debugPrint.

Po implemnetacji tego planu aplikacja powinna być gotowa do wypuszczenia na produkcję. Nie może być w niej jeszcze jakichś elementów to-do do zrobienia na później. Brak fake data, wszystko ma być już oparte na bazie danych.

Rzeczy powiązane z Supabase zalecaj w tym planie wprowadzać przez Supabase MCP.

# TASK

Przygotuj pełny plan implemnetacyjny głównego MVP i zapisz go w całości do `docs/IMPL_PLAN.md`.

Na końcu przedstaw jego skróconą wersję użytkownikowi.

# FINISH

Zaleć by napisał `next` jak jest gotowy przejść dalej.

Jak napisze `next`, dopiero zapoznaj się z plikiem `docs/commands/04_plan/03_plan-baby-steps.md` - nie wcześniej!