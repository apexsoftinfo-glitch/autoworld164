# Cel: Ekran formularza z integracją kamery i walidacji

1. Zaimplementuj widok formularza `CarFormScreen` do którego można wejść stąpając przycisk "DODAJ MODEL" w `HomeScreen`.
2. UI musi respektować wygląd VIP Showcase.
3. Formularz potrzebuje pól tekstowych: Brand, Model Name, Series.
4. Formularz wymaga pól dla hajsów: Cena zakupu, Cena wyceniona. Ujmij tu `TextInputType.number` wraz z formatowaniem odpowiednim dla waluty.
5. Główny atrybut – Zdjęcie Autka. Załącz pakiet `image_picker` upewniając się w `pubspec.yaml` oraz kluczach informacyjnych (np. `NSCameraUsageDescription` w `Info.plist` jeśli tego będziemy tu potrzebować). Przycisk powinien odpalać picker, a UI winno pokazać miniaturkę z opcją reset.
6. Po podaniu formularza z triggeriem `CarFormCubit` przycisk poddaje blokadzie UI wraz z opóźnieniem oczekiwania animacji wysyłanej do Supabase. 
7. Wygeneruj odświeżenie l10n.
8. Po sukcesie `flutter test` i `analyze` skamituj stan.

---
# FINISH
Zapytaj czy chce przejrzeć na localu i odblokować komendę
`next`
Co przeniesie was do pliku: `docs/commands/05_build/06_build-integration.md`
