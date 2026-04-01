# Update App Icon

Wykonaj te kroki, gdy chcesz podmienić ikonę aplikacji na `iOS` i `Android`.

To nie jest brainstorming. To jest checklista wykonawcza.

## Cel

Masz podmienić launcher icon aplikacji na nową ikonę usera.

Załóż, że nowa ikona jest już w:
- `assets/images/icon/icon.png`

Załóż, że `flutter_launcher_icons` jest już skonfigurowane w projekcie.

## Krok 1. Pobierz zależności

- Uruchom:
  - `flutter pub get`

## Krok 2. Wygeneruj ikony

- Uruchom:
  - `dart run flutter_launcher_icons`

- Nie podmieniaj ręcznie wszystkich plików w:
  - `ios/Runner/Assets.xcassets/AppIcon.appiconset`
  - `android/app/src/main/res`

- Generator ma zrobić to automatycznie.

## Krok 3. Sprawdź, co się zmieniło

- Sprawdź `git diff`.

- Oczekiwane zmiany są zwykle w:
  - `pubspec.lock`
  - `ios/Runner/Assets.xcassets/AppIcon.appiconset/...`
  - `ios/Runner.xcodeproj/project.pbxproj`
  - `android/app/src/main/res/mipmap-.../ic_launcher.png`

- Jeśli pojawiły się niepowiązane zmiany, nie commituj ich razem z tym taskiem.

## Krok 4. Uruchom walidację

- Uruchom:
  - `flutter analyze`

- Jeśli analiza zwróci błędy, warningi lub info, napraw je.

## Krok 5. Zakończ pracę

- Zrób commit z jasnym opisem zmian, np.:
  - `build: update app icon`

## Krok 6. Powiedz userowi jak to sprawdzić

- Poleć userowi:
  - uruchomić aplikację na `iOS`
  - uruchomić aplikację na `Android`
  - sprawdzić ikonę na ekranie głównym systemu
  - jeśli stara ikona nadal się pokazuje, usunąć aplikację z urządzenia i zainstalować ją ponownie
