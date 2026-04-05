# Implementation Plan: AutoWorld164 MVP

## 1. Zrozumienie Scope'u (Rozszerzony MVP)
Celem jest wdrożenie głównej funkcjonalności "Mój Garaż" pozwalającej kolekcjonerowi:
- Dodać model autka (zdjęcie, marka, model, seria, cena, wartość).
- Wyświetlić całą kolekcję w formie estetycznej listy z miniaturkami.
- Podliczyć automatycznie wartość całkowitą oraz ilość na Home Screen.
- Podejrzeć detale konkretnego autka oraz edytować/usunąć.
Wszystko bazuje na architekturze zdefiniowanej w `AGENTS.md` z naciskiem na strumienie (Stream), czysty kod, odpowiednią obsługę błędów i VIP Showcase Design.

---

## 2. Architektura Bazy Danych (Supabase)
Wykorzystanie Supabase MCP do wprowadzenia zmian na środowisku:
1. **Tabela**: `autoworld_cars`
   - `id` (uuid, primary key)
   - `user_id` (uuid, reference to auth.users, domyślnie `auth.uid()`)
   - `brand` (text, Not Null - np. Hot Wheels)
   - `model_name` (text, Not Null - np. 'Porsche 911 GT3')
   - `series` (text, Nullable)
   - `purchase_price` (numeric, default 0)
   - `estimated_value` (numeric, default 0)
   - `photo_path` (text, Nullable)
   - `created_at` (timestamptz, default now())
2. **Realtime**: Aktywowanie flagi publikacji `supabase_realtime` + `REPLICA IDENTITY FULL` dla `update` i `delete` (by repository mogło nasłuchiwać i emitować kompletne stany dla `Stream`).
3. **RLS Policies**: Standardowe polityki SELECT, INSERT, UPDATE, DELETE tylko dla wpisów, gdzie `user_id = auth.uid()`.
4. **Obiekty S3**: Supabase Storage Bucket `autoworld_photos`. Polityki dostępu ograniczone do `auth.uid()`.

---

## 3. Warstwa Zależności (Data Source & Repository)
Zgodnie z `AGENTS.md`, warstwa wspólna dla stanu aplikacji dostarcza danych (Stream):

1. **`CarsDataSource` / `CarsDataSourceImpl` (Singleton)**: 
   - `Stream<List<Map<String, dynamic>>> watchCars()`
   - `Future<void> addCar(Map<String, dynamic> data, File? photo)` -> obsługa uploadu.
   - `Future<void> editCar(String id, Map<String, dynamic> updates, File? newPhoto)` -> opcjonalne usunięcie/nadpisanie starego.
   - `Future<void> deleteCar(String id, String? oldPhotoPath)`
2. **Data Model**: `CarModel` (freezed, z logiką parsowania z JSON).
3. **`CarsRepository` / `CarsRepositoryImpl` (Singleton)**:
   - Udostępnia `Stream<List<CarModel>>` (mapowane z DataSource).
   - Metody akcji aut `add`, `update`, `delete`.
   - Obsługa rzucania (re-throw) wyjątków po zalogowaniu na konsoli za pomocą `debugPrint`.

---

## 4. Warstwa Logiki Biznesowej (Cubity)

1. **`CarsCollectionCubit` (Sesyjny/Globalny Singleton)**:
   - Nasłuchuje na `CarsRepository.watchCars()`.
   - Oblicza metryki: `totalCount`, `totalValue`.
   - Zasila Dashboard (Home Screen) oraz listę "Mój Garaż". 
   - Zarządza anulowaniem subskrypcji w `close()`.
2. **`CarFormCubit` (Per-screen)**:
   - Obsługa walidacji dodawania nowej pozycji (Upload trzymany w stanie lub pamięci ulotnej do momentu Save).
   - Blokowanie UI podczas wysyłania (state `isLoading: true`).
   - Emituje błędy poprzez lokalizowalne `errorKey`, wyłapywane w UI i zamieniane na komunikaty. Brak sukcesów w "Cubit-to-Cubit".

---

## 5. Ekrany i Wdrożenie UI (VIP Showcase)
Wszystkie ekrany utrzymują layout VIP (z ewentualnie głęboką czernią dla wygodnej edycji).

1. **Home Screen (Integracja)**:
   - Podpięcie `CarsCollectionCubit`, aby statystyki `PIECES` oraz `VALUE` ładowały się dynamicznie na bazie kolekcji.
   - `DODAJ MODEL` wywołuje nawigację do formularza, a `MÓJ GARAŻ` do widoku Listy.
2. **Garage List Screen (Mój Garaż)**:
   - W piękny sposób wylistowana kolekcja w postaci kafelków ze zdjęciami oraz podsumowaniem ceny (glassmorphism cards).
   - Ładny `Empty State`, jeżeli garaż jest pusty (np. złota grafika zachęcająca do dodania 1szego autka).
3. **Car Details Screen**:
   - Szczegóły dla jednego obiektu. Duże zdjęcie auta z efektem cieniowania/wtopienia w tło.
   - Opcje usunięcia i edycji. 
   - Przy usunięciu -> okienko pop-up "Czy na pewno chcesz sprzedać/usunąć z kolekcji?", jeśli tak -> strzał do Repository i `pop` do listy.
4. **Car Form Screen (Dodaj / Edytuj)**:
   - Narzędzie z systemem wybierania lub robienia zdjęć (`image_picker`).
   - Od razu z dodawaniem pól cenowych (bezpieczna klawiatura numeryczna z odpowiednim maskowaniem/formatem dla kwot).
   - Akcja `Zapisz`: Zaznacza loading (disable dla przycisków / unfocus), w przypadku wyłapania exceptionów rzuca `SelectableText` inline.

---

## 6. Ograniczenia `AGENTS.md` (Checklista)
- Odbudowane pliki l10n: `flutter gen-l10n`.
- Cubity startują od stanu `initial`. Nawigacja nie wyzwala eventów ładujących przed wejściem. To ekran w swoim init ładuje.
- Zależności z `get_it` i adnotacje `@lazySingleton`, `@injectable`. DI dla interfejsów, nie samych implementacji.
- `when`/`maybeWhen` dla Freezed jest zakazane - stosujemy dartowski pattern matching `switch (state)`.
- Rejestrowanie klienta poprzez `.eq()` polityki – żadnych magic words.
- Mocktail do testów jednostkowych (Cubity + Data Source).

---

## 7. Testy i Jakość Codebase'u
1. **Unit Tests**:
   - Setup logiki dla `CarsCollectionCubit`, gwarantujący poprawne zliczanie ceny na streamach oraz obsługę wyjątku streama.
   - Konstrukcja testów w Data sources z użyciem mockowanych klientów bazy danych The Supabase.
2. **Integration Tests**:
   - Usunięcie przykładowego testu `counter_test_example.dart`.
   - Utworzenie jednego, silnego flow end-to-end `integration_test/garage_core_flow_test.dart` przechodzącego logikę powitania, przejścia przez ekran domowy i upewnienie się o wyrenderowaniu garażu (puste stany itp.).
3. Koniec końców przepuszczenie przez `flutter analyze`, testy oraz formatowanie przed deploymentem.

---

Po implementacji całej układanki, AutoWorld 164 będzie gotową w 100% używalną i wydajną aplikacją będącą definicją kompletnego produktu w formie wypustu v1.0.0. Zakończenie pracy odbywa się bez technicznego długu.
