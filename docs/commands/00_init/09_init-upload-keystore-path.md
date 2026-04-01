# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: User musi przenieść wygenerowany plik do zalecanej ścieżki dla tej aplikacji i uzupełnić path do pliku w `storeFile` w `android/key.properties`.

# Task

1. Powiedz userowi, że ma przenieść plik keystore do zalecanej ścieżki dla tej aplikacji:
- Dla `macOS` lub `Linux` zaproponuj ścieżkę:
  - `/Users/<uzytkownik>/12appschallenge/secrets/app_name/upload-keystore.p12`
- Dla `Windows` zaproponuj ścieżkę:
  - `C:/Users/<uzytkownik>/12appschallenge/secrets/app_name/upload-keystore.p12`
2. Powiedz userowi, że ma uzupełnić w pliku `android/key.properties` ścieżkę do `upload-keystore.p12` w `storeFile`. W miarę możliwości mu z tym pomóż gdyby miał problemy.

Gdy odpowie "next", przejdź do wykonania polecenia zawartego w `docs/commands/00_init/10_init-supabase-shared-users-setup.md`.
