# TASK

Rozbij teraz ten plan `docs/IMPL_PLAN.md` na wiele małych kroków / oddzielnych pliczków .md.

Każdy pojedyńczy krok implementacyjny powinien być niezależny i dokładnie technicznie opisany w oddzielnym pliku .md w folderze `docs/commands/05_build/`.

Każdy krok będzie musiał kończyć się commitem, więc każdy krok musi przechodzić `flutter analyze` bez problemu.

Każdy krok (każdy osobny plik .md w /05_build/) ma kończyć się (podobnie jak ten plik) podsumowaniem tego co udało się dokonać i zaleceniem dla użytkownika, aby napisał `next` i dopiero po `next` ma przechodzić do kolejnego pliku. Ścieżka do kolejnego pliku, ma być podana po zaleceniu napisania `next` (podobnie jak w tym pliku). 

Opcjonalnie, jeżeli na jakimś kroku użytkownik może odpalić jakąś aplikację i być w stanie przetestować to co zostało zaimplementowane to niech będzie instrukcja jaki może sprawdzić czy to co właśnie weszło faktycznie działa. Może coś wyłapie, zanim budowniczy będzie szedł dalej. Dopiero wtedy niech pisze `next`. 

Nazwij je w formacie 0x_build-STH.md - gdzie `STH` to krótki tytuł danego kroku a `0x` to numer kroku np `01`, `02` czy `03` itd. np `01_build-adding-screen.md`.

Nie ma limitu kroków. Zrób ich tyle ile potrzebujesz. 

W ostatnim pliku .md napisz na końcu, że ma przetestować aplikację i dać znać czy wszystko działa poprawnie. Tam już nie ma `next`.

# FINISH

Gdy skończysz, daj znać użytkownikowi o tym co zrobiłeś.

Zaleć mu by napisał `next`.

Jak napisze, dopiero wtedy zapoznaj się z plikiem `docs/commands/04_plan/04_plan-build.md` - nie wcześniej!