# Cel: Implementacja DataSource i Repository 

1. Zaimplementuj klasę `CarsDataSource` wraz z jej interfejsem i udostępnij metody Supabase jak `watchCars()`, `addCar()`, `editCar()`, `deleteCar()` wg wytycznych.
   - Wrzucanie i kasowanie zdjęć z `autoworld_photos`. 
2. Zaimplementuj `CarsRepository` z mapowaniem Supabase responses do `CarModel`.
3. Skonfiguruj Injection za pomocą `get_it` dla powiązanych operacji (`lazySingleton`).
4. Pamiętaj o obsłudze braku sieci oraz specyficznych błędów (rethrow dla CUBITÓW, użycie `debugPrint` rzucające wyjątki).
5. Napisz Mocki testowe dla klasy w środowisku Testów Unitowych i odpal `flutter test` na samej warstwie danych z użyciem `mocktail`.
6. Odpal `flutter analyze` następnie skomituj ten proces!

---
# FINISH
Skomituj kod, i wskaż by użytkownik napisał komendę:
`next` 
Rozpocznie to czytanie instrukcji: `docs/commands/05_build/03_build-cubits.md`
