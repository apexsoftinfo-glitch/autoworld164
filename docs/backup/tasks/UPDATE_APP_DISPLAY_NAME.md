# Update App Display Name

Wykonaj te kroki, gdy chcesz zmienić nazwę aplikacji wyświetlaną userowi na `iOS` i `Android`.

To nie jest brainstorming. To jest checklista wykonawcza.

## Cel

Masz podmienić obecną nazwę `XII` na nową nazwę aplikacji.

Ta zmiana dotyczy tylko nazwy widocznej dla usera pod ikoną aplikacji.

To nie jest zmiana:
- `Bundle Identifier` na `iOS`
- `applicationId` na `Android`
- nazw folderów projektu

## Krok 1. Wybierz nową nazwę

- Wybierz krótką nazwę, która dobrze wygląda pod ikoną aplikacji.
- Traktuj obecną wartość `XII` jako placeholder do podmiany.

## Krok 2. Zmień nazwę na `iOS`

- Otwórz:
  - [Info.plist](/ios/Runner/Info.plist)

- Znajdź i podmień obie wartości:
  - `CFBundleDisplayName`
  - `CFBundleName`

- Obie ustaw na nową nazwę.
- Nie zostawiaj tam `XII`.

## Krok 3. Zmień nazwę na `Android`

- Otwórz:
  - [AndroidManifest.xml](/android/app/src/main/AndroidManifest.xml)

- Znajdź:
  - `android:label="..."`

- Ustaw tam tę samą nową nazwę.
- Nie zostawiaj tam `XII`.

## Krok 4. Zmień `MaterialApp.title`

- Otwórz:
  - [app.dart](/lib/app/app.dart)

- Znajdź:
  - `MaterialApp(title: '...')`

- Ustaw `title` na tę samą nową nazwę.
- Nie zostawiaj tam `XII`.

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

- Jeśli są też inne, niepowiązane zmiany, nie commituj ich razem z tym taskiem.

## Krok 8. Zakończ pracę

- Zrób commit z jasnym opisem zmian, np.:
  - `build: update app display name`
