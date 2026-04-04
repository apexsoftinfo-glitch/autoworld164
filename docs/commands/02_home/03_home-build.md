# ZADANIE: 03_home_build

## CEL
Zakoduj wariant Ekranu Startowego (sam UI, bez logiki, bez testów, bez backendu).

WAŻNE: Implementację wykonasz w przygotowanym pliku `lib/features/home/ui/temporary_widgets/variants/home_variant_a.dart` jako wariant `A` ekranu Home Screen.

## ZASADY UI/UX:
- **Tylko wireframe**: jedynie odcienie szarości, brak specjalnych kolorów, fontów, gradientów ani finalnego designu.
- Używaj wyłącznie statycznych danych (fake data). Brak integracji API.
- **Zasada nawigacji (Placeholdery):** Budujesz szkielet, ale główny nacisk kładziesz na zawartość ekranu startowego. Jeśli wariant zakłada dodatkowe zakładki/strony (np. z BottomNavigationBar lub Drawer), wejście w nie ma wyświetlać tylko prosty `Center(child: Text('Placeholder'))` lub podepnij `SnackBar`.
- Wyjątkiem jest przejście do profilu – tu musisz zapewnić działającą nawigację do `lib/features/profiles/presentation/ui/profile_screen.dart`.

## KROKI DO WYKONANIA:
1. Stwórz zaplanowany wcześniej wariant.
2. Wygenerowany kod umieść w `lib/features/home/ui/temporary_widgets/variants/home_variant_a.dart`.
3. Uruchom w terminalu `flutter analyze`. Jeśli są błędy - napraw je.
4. Wykonaj commit.
5. Krótko podsumuj zmiany i poproś użytkownika o feedback. Poinformuj go, że to tylko szkielet i że na tym etapie jeszcze nie pracujemy nad wyglądem tylko nad rozmieszczeniem elementów.
6. Po każdej poprawce rób `flutter analyze`, commit i proś o feedback. Pętla trwa dopóki użytkownik nie wykaże zadowolenia z wybranego wariantu. 
7. Gdy wszystko jest okej zaproponuj przejście do kolejnego etapu /design poleceniem dostępnym w `docs/commands/03_docs/DESIGN.md`.