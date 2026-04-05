# Cel: Konstrukcja Warstw Logiki (Cubits) i łączenie Statystyk Garażu

1. Wygeneruj `CarsCollectionCubit` który będzie w sposób asynchroniczny nasłuchiwać zmian ze `Stream<List<CarModel>>` od Repozytorium na Start/App Init. Pamiętaj by zamykał stream w `close()`.
2. Zrób logikę obliczania zmiennych typu: całkowity koszt zakupów (purchase_price_total) czy całkowita wartość ujętych pojazdów na streamie (estimated_value_total).
3. Wygeneruj `CarFormCubit` zarządzający stanem od formularza dodawania i edytowania. (Stan Loading, Success i Error z Error Keys z lokalizacją).
4. Napisz pełne testy logiki `CarsCollectionCubit` oraz `CarFormCubit` (bloc_test).
5. Wstrzyknij te Cubity z odbytym wzorcem do routera lub z `get_it`. Dodaj Cubit do HomeScreen UI by wyświetlało faktycznie posiadane pojazdy i hajs. Upewnij się co do zachowania VIP design pattern!
6. Odpal `flutter analyze`, upewnij się że aplikacja na tym etapie nadal bez błedów i ją zakommituj. 

---
# FINISH
Zaleć odpalenie aplikacji by użytkownik zauważył, że liczby na Home Screen się zaktualizowały na zero ($0, uaktualnione wartości zero kolekcji)
Gdy potwierdzi, wskaż mu polecenie wpisania komendy:
`next`
Dopiero wtedy rozpocznij krok: `docs/commands/05_build/04_build-ui-list-screen.md`
