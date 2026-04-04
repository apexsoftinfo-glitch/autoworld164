Wciel się w rolę doświadczonego programisty Flutter i inżyniera CI/CD. Twój klient wygenerował przed chwilą źródłową ikonę aplikacji i zapisał ją w folderze projektu. 

Twoim zadaniem jest wygenerowanie natywnych ikon dla platform iOS i Android przy użyciu paczki `flutter_launcher_icons`, a następnie zapisanie zmian w repozytorium. Działaj krok po kroku.

### 🛠 KROK 1: Weryfikacja plików i konfiguracji
1. Sprawdź, czy plik `assets/images/icon/icon.png` faktycznie istnieje w projekcie. Jeśli go nie ma, ZATRZYMAJ SIĘ i poproś użytkownika o poprawne zapisanie pliku.
2. Otwórz `pubspec.yaml` i upewnij się, że:
   - W sekcji `dev_dependencies` znajduje się `flutter_launcher_icons`.
   - Na dole pliku istnieje blok konfiguracyjny zaczynający się od `flutter_launcher_icons:` z ustawioną ścieżką `image_path: "assets/images/icon/icon.png"` lub `image_path: assets/images/icon/icon.png`.
   *(Jeśli konfiguracja lub paczka z jakiegoś powodu została usunięta, dodaj je, ale domyślnie powinny tam już być).*

### 🛠 KROK 2: Generowanie ikon
1. Uruchom w terminalu projektu komendę: `flutter pub get`.
2. Następnie uruchom komendę: `dart run flutter_launcher_icons`.
3. Zweryfikuj w logach terminala, czy proces zakończył się sukcesem (Success) i czy ikony natywne zostały wygenerowane i nadpisane w folderach `android/` oraz `ios/`.

### 🛠 KROK 3: Commit zmian
Kiedy generowanie zakończy się pełnym sukcesem:
1. Zrób stage wszystkich zmian (dodane/nadpisane pliki w folderach `ios`, `android` oraz ewentualnie zmieniony `pubspec.yaml`).
2. Wykonaj commit z wiadomością: `chore: generate native app icons for iOS and Android`.

### ⚙️ AKCJA KOŃCOWA
Wyświetl w czacie radosną, krótką wiadomość informującą, że ikony są gotowe, zacommitowane i aplikacja jest wizualnie i tekstowo w 100% gotowa do podboju sklepów (App Store i Google Play)! 

Poinformuj użytkownika, że jeżeli ma podpięty Codemagic i wszystko działa, to może zrobić Git Push.