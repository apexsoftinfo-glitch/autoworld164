# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Dać userowi instrukcje jak może wygenerować nowy plik `upload-keystore.p12` dla tej aplikacji.

# Task

1. Wykryj system usera.
2. Poproś usera o wygenerowanie Android upload keystore.
- Jeśli user uruchamia to na `macOS` lub `Linux`, poleć mu uruchomić:
```bash
keytool -genkey -v -keystore ~/upload-keystore.p12 -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

- Jeśli user uruchamia to na `Windows`, poleć mu uruchomić:
```powershell
keytool -genkey -v -keystore $env:USERPROFILE\\upload-keystore.p12 -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Powiedz mu, żeby przy generowaniu pliku użył hasła, które podał w `android/key.properties` dla `storePassword` lub `keyPassword` (powinny być te same wartości).

Zasugeruj mu komendę `next` gdy wszystko uda się pomyślnie, lub pomóż mi z wygenerowaniem tego pliku.

Gdy odpowie "next", przejdź do wykonania polecenia zawartego w `docs/commands/00_init/09_init-upload-keystore-path.md`.
