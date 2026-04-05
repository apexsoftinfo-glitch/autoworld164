# Cel: Ekran Mój Garaż (Oglądanie Kolekcji)

1. Stwórz zupełnie nowy ekran `GarageScreen` (`lib/features/garage/ui/garage_screen.dart`), trzymający stylistykę VIP Showcase (ciemne tło the same garazu, szkliste bloki jako auta).
2. Na tym ekranie umieść piękny "Empty State" z grafiką, jeśli `CarsCollectionCubit` emituje pustą serię. 
3. Jeżeli użytkownik ma wpisy - wyświetl siatkę ładnych Boxów z listą pojazdów z ceną, powiązana z `CarsCollectionCubit`. Pamiętaj wspierać stream builder, brak "Pull to Refresh" jako standard wedle obostrzeń.
4. Z ekranu `HomeScreen` zmień tapnięcie z logiki 'Coming wkrótce Mój Garaż' na rzeczywistą nawigację do `GarageScreen`.
5. Uzupełnij wszelkie UI labels polskimi `arb`.
6. Odpal komendę analizy i komendę formatu. Skomituj do bazy.

---
# FINISH
Zapytaj czy odpalić widok w emulatorze a by sprawdzić routing z "MÓJ GARAŻ". 
Jeśli wyłapie się upewnij go i zaleć wpisanie:
`next`
Aby uruchomić podążenie za `docs/commands/05_build/05_build-ui-form-screen.md`
