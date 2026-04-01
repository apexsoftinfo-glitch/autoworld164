# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: 

# Task

Masz podmienić obecną nazwę `XII` na nową nazwę aplikacji widocznej dla usera pod ikoną aplikacji.

## Krok 1. Zlokalizuj nową nazwę

- Upewnij się, że w pliku `IDEA.md` jest zdefiniowana nazwa aplikacji.

## Krok 2. Zmień nazwę na `iOS`

- Otwórz:
  - [Info.plist](/ios/Runner/Info.plist)

- Znajdź i podmień obie wartości:
  - `CFBundleDisplayName`
  - `CFBundleName`

- Obie ustaw na nową nazwę.

## Krok 3. Zmień nazwę na `Android`

- Otwórz:
  - [AndroidManifest.xml](/android/app/src/main/AndroidManifest.xml)

- Znajdź:
  - `android:label="..."`

- Ustaw tam tę samą nową nazwę.

## Krok 4. Zmień `MaterialApp.title`

- Otwórz:
  - [app.dart](/lib/app/app.dart)

- Znajdź:
  - `MaterialApp(title: '...')`

- Ustaw `title` na tę samą nową nazwę.

## Krok 5. Zweryfikuj, że starej nazwy już nie ma

- Przeszukaj repo pod kątem:
  - `XII`

- Jeśli `XII` nadal występuje w plikach odpowiedzialnych za nazwę aplikacji, popraw to.

## Krok 6. Uruchom walidację

- Uruchom:
  - `flutter analyze`

- Jeśli analiza zwróci błędy, warningi lub info, napraw je.

## Krok 7. Sprawdź zmiany przed commitem

- Sprawdź `git diff`.
- Upewnij się, że zmieniły się tylko pliki odpowiedzialne za nazwę aplikacji:
  - `ios/Runner/Info.plist`
  - `android/app/src/main/AndroidManifest.xml`
  - `lib/app/app.dart`

- Jeśli są też inne, niepowiązane zmiany, nie commituj ich razem z tym taskiem. Poinformuj o nich użytkownika i zaproponuj oddzielny commit.

## Krok 8. Zakończ pracę

- Zrób commit z jasnym opisem zmian, np.:
  - `build: update app display name`

# Finish

Gdy odpowie "next", przejdź do wykonania polecenia zawartego w `docs/commands/01_start/06_start-agents-md.md`.
