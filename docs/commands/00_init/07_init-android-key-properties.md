# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Utworzenie pliku `android/key.properties`.

# Task

1. Sprawdź czy istnieje plik `android/key.properties`.
2. Jeżeli go nie ma, utwórz go na podstawie `android/key.example.properties`
3. Jeżeli jest, upewnij się, że posiada wszelkie klucze z `android/key.example.properties`
4. Następnie wykryj system usera.
- Jeśli user uruchamia to na `macOS` lub `Linux`, uzupełnij `storeFile` przykładowym wpisem: `/Users/<uzytkownik>/.../.../upload-keystore.p12`
- Jeśli user uruchamia to na `Windows`, uzupełnij `storeFile` przykładowym wpisem: `C:/Users/<uzytkownik>/.../.../upload-keystore.p12`

Gdy skończysz, poinformuj użytkownika o tym co zrobiłeś.

Poproś go, aby wymyślił i wypełnił pola `storePassword`, `keyPassword` tym samym, nowym hasłem. Niech zapisze je gdzieś sobie też poza tym plikiem `android/key.properties` w bezpiecznym miejscu.

Gdy odpowie "next", przejdź do wykonania polecenia zawartego w `docs/commands/00_init/08_init-upload-keystore-create.md`.
