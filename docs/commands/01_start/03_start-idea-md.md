# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Utwórz plik IDEA.md

# Task

1. Zapoznaj się ze strukturą pliku `IDEA.md`.
2. Upewnij się czy masz wszystkie dane, które musisz dostarczyć, aby ten pomysł w nim opisać.
    - Jeżeli tak - wypełnij ten plik od razu
    - Jeżeli brakuje Ci informacji - prowadź dalej dialog z użytkownikiem, aby doprecyzować ostatnie kwestie.

Mając imię i nazwisko autora oraz __APP_DISPLAY_NAME__ z poprzednich kroków utwórz __APP_BUNDLE_ID__ w formacie: com.imienazwisko.appname (wszystko z małych liter [a-z], żadnych cyf, żadnych znaków specjalnych, brak polskich znaków).

Ustal table prefix (__SUPABASE_TABLE_PREFIX__) dla Supabase (ustaw jako ostatni segment `APP_BUNDLE_ID` z dopisanym `_` - przykład: `com.adamsmaka.mytodoapp` -> `mytodoapp_`).

Template w którym pracujemy uwzglednia już ekran Welcome Screen, ekrany logowania, rejestracji, profilu oraz ustawień więc nie musisz tego dodatkowo opisywać. W `Feature screens` rozpisz tylko ekrany specyficzne dla tego pomysłu aplikacji.

Plik `IDEA.md` ma być na tyle obszerny, byśmy mogli tym jedynym plikiem, w pełni przedstawić założenia tego projektu.

Jeżeli czujesz potrzebę dopisać tam więcej niż zakładają predefiniowane sekcje to śmiało.

3. Po utworzeniu pliku, zaleć, aby user go przeczytał i zaakceptował. Jeżeli ma jakieś uwagi, popraw je.

4. Gdy użytkownik zaakceptuje plik `IDEA.md` - zacommituj go do repository.

Gdy odpowie "next", przejdź do wykonania polecenia zawartego w `docs/commands/01_start/04_start-app-bundle-id.md`.
