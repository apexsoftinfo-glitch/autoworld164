# ZADANIE
Twoim zadaniem jest zaimplementowanie pełnego flow powitalnego (Welcome, Onboarding, Paywall) we Flutterze dla nowej aplikacji. 
Cała wiedza o produkcie, copywritingu, pytaniach do użytkownika i układzie paywalla znajduje się w plikach `docs/IDEA.md` oraz `docs/ONBOARDING_AND_PAYWALL.md`. Przeczytaj je uważnie, zanim zaczniesz pisać kod.

Używaj prostego, czystego kodu. Postępuj DOKŁADNIE według poniższych, sztywnych zasad architektury i UX. Nie dodawaj niczego od siebie.

# FLOW NAWIGACJI
Flow aplikacji to:
`Splash/Auth Checker` -> `Welcome Screen` -> `Onboarding (Pytania)` -> `Fake Loading Screen` -> `Aha Moment & Hard Paywall` -> `Home (jako Gość)`.

# SZCZEGÓŁOWE WYTYCZNE DLA EKRANÓW

## 1. Welcome Screen
- Głównym, ogromnym i najbardziej widocznym przyciskiem na ekranie ma być "Kontynuuj jako gość" (prowadzi do Onboardingu).
- Przycisk logowania ma być małym, nierzucającym się w oczy tekstem na samym dole ekranu (np. "Masz już konto? Zaloguj się").

## 2. Onboarding Screens (Pytania)
- Użyj widżetu `PageView`. 
- **Zablokuj możliwość scrollowania palcem** (`physics: NeverScrollableScrollPhysics()`). Użytkownik musi kliknąć w opcję odpowiedzi, aby przejść dalej.
- Ekran z pytaniem o główny ból ma być pytaniem zamkniętym. Użytkownik wybiera jedną z gotowych opcji. Możesz dodać opcję `Inne`, jeśli wynika to z `docs/ONBOARDING_AND_PAYWALL.md`.
- Jeżeli ekran onboardingu jest pytaniem o imię albo o minimalną informację potrzebną do zasilenia `Home`, może zawierać prosty input tekstowy i przycisk `Dalej`.
- Po tapnięciu w odpowiedź albo zatwierdzeniu inputu, automatycznie i płynnie przescrolluj do kolejnego pytania. Zbieraj odpowiedzi w pamięci podręcznej (np. w zmiennych wewnątrz State'u).
- **ZAKAZ DODAWANIA PRZYCISKU "SKIP" / "POMIŃ"**. Użytkownik musi przejść przez cały formularz.
- Pytania i opcje odpowiedzi pobierz z `docs/ONBOARDING_AND_PAYWALL.md`.

## 3. Fake Loading Screen (BARDZO WAŻNE)
- Ekran wyświetla loader (np. CircularProgressIndicator) i rotujące teksty (zmieniające się co ok. 1-1.5 sekundy). Teksty pobierz z `docs/ONBOARDING_AND_PAYWALL.md`.
- Cały ekran ma trwać około 3-5 sekund.
- **LOGIKA ZAPISU:** To DOKŁADNIE NA TYM EKRANIE, w tle (podczas udawanego ładowania), musisz zapisać zebrane odpowiedzi użytkownika do bazy danych / local storage.
- **FLAGA ONBOARDINGU:** W trakcie tego ekranu ustaw lokalnie flagę `is_onboarding_completed = true` (np. w SharedPreferences / Flutter Secure Storage).
- **PERSONALIZACJA:** Jeśli onboarding zebrał imię lub inne dane do personalizacji, wykorzystaj je dynamicznie w rotujących tekstach zgodnie z `docs/ONBOARDING_AND_PAYWALL.md`.

## 4. Aha Moment & Hard Paywall
- Ekran, na który użytkownik trafia bezpośrednio po "Fake Loading Screen".
- Najpierw pokaż osobny ekran `Aha Moment` z "Ziemią Obiecaną" / spersonalizowanym wynikiem zdefiniowanym w `docs/ONBOARDING_AND_PAYWALL.md`.
- Ekran `Aha Moment` ma wykorzystywać dane z onboardingu, zwłaszcza wybrany główny ból, a imię użytkownika tylko jeśli wynika to z `docs/ONBOARDING_AND_PAYWALL.md`.
- Na ekranie `Aha Moment` umieść CTA typu `Dalej`, które prowadzi do osobnego ekranu paywalla.
- Na osobnym ekranie paywalla zaimplementuj `Tytuł`, `Subtitle` oraz listę rzeczy odblokowywanych przez płatność zgodnie z `docs/ONBOARDING_AND_PAYWALL.md`.
- **BRAK TRIALA:** Aplikacja oferuje zakup wprost. Nie projektuj przycisków "Rozpocznij darmowy okres próbny", chyba że plik markdown wyraźnie stanowi inaczej.
- **ZAMKNIĘCIE (X):** W prawym górnym lub lewym górnym rogu ekranu MUSI znajdować się ikona zamknięcia (X). Jej kliknięcie zamyka Paywall i przenosi użytkownika do ekranu `Home` jako Gościa.

## 5. Routing i Edge Cases (Ważne zasady startowe)
- Kiedy aplikacja startuje, sprawdza flagę `is_onboarding_completed`. 
- Jeśli `is_onboarding_completed == true`, a użytkownik nie ma opłaconej subskrypcji, ekranem startowym ma być `Home` (nie pokazujemy Paywalla przy starcie, jeśli user wcześniej go zamknął lub ubił aplikację po Fake Loading). Paywall będzie wywoływany z innych miejsc wewnątrz aplikacji (limitów).
- `Home` po odrzuceniu paywalla ma wykorzystywać dane zebrane w onboardingu, jeśli `docs/ONBOARDING_AND_PAYWALL.md` przewiduje nimi zasilenie pierwszego sensownego stanu ekranu.

Wygeneruj teraz potrzebne pliki w katalogu `lib/features/onboarding/` i połącz je z istniejącym routingiem aplikacji.






BEFORE:


## Krok 4. Utwórz `docs/ONBOARDING_AND_PAYWALL.md`

| Status | Item |
| --- | --- |
| ⬜ | `docs/ONBOARDING_AND_PAYWALL.md` istnieje |
| ⬜ | `docs/ONBOARDING_AND_PAYWALL.md` opisuje flow `Welcome -> Continue as guest -> Onboarding -> Hard Paywall` |
| ⬜ | `docs/ONBOARDING_AND_PAYWALL.md` jasno zakłada brak triala na tym etapie |
| ⬜ | `docs/ONBOARDING_AND_PAYWALL.md` opisuje pytania onboardingowe i ich cel |
| ⬜ | `docs/ONBOARDING_AND_PAYWALL.md` zawiera zamknięte pytanie o główny ból użytkownika |
| ⬜ | `docs/ONBOARDING_AND_PAYWALL.md` zawiera gotowe opcje odpowiedzi dla pytania o ból |
| ⬜ | `docs/ONBOARDING_AND_PAYWALL.md` zawiera pytanie zbierające minimalne dane do pierwszego sensownego stanu `Home` |
| ⬜ | `docs/ONBOARDING_AND_PAYWALL.md` opisuje, jak aplikacja komunikuje zrozumienie problemu użytkownika |
| ⬜ | `docs/ONBOARDING_AND_PAYWALL.md` definiuje moment `Aha!` |
| ⬜ | `Aha Moment` jest opisany jako konkretny ekran, a nie ogólna obietnica wartości |
| ⬜ | `Aha Moment` wykorzystuje dane z onboardingu, zwłaszcza wybrany główny ból |
| ⬜ | `docs/ONBOARDING_AND_PAYWALL.md` zawiera konkretne teksty dla ekranu analizy / ładowania |
| ⬜ | `docs/ONBOARDING_AND_PAYWALL.md` zawiera konkretne dane paywalla, a nie tylko ogólne hasła |
| ⬜ | `docs/ONBOARDING_AND_PAYWALL.md` zawiera `Tytuł`, `Subtitle` i listę rzeczy odblokowywanych przez płatność |
| ⬜ | Kluczowe sekcje `docs/ONBOARDING_AND_PAYWALL.md` zostały uzupełnione treścią, a nie zostawione jako puste hasła dla usera |




4. Przygotuj `docs/ONBOARDING_AND_PAYWALL.md` w głównym katalogu projektu.

Ten dokument ma wynikać z ustaleń zapisanych wcześniej w `docs/IDEA.md`.

`docs/ONBOARDING_AND_PAYWALL.md` jest dokumentem pierwszej sesji i konwersji.
Ma opisywać:
- flow `Welcome -> Continue as guest -> Onboarding -> Hard Paywall -> Home Screen`,
- na tym etapie zakładamy brak triala i nie projektujemy komunikacji o darmowym okresie próbnym,
Nie każ userowi samodzielnie wymyślać treści tych sekcji. To Ty masz je zaproponować i uzupełnić na podstawie rozmowy z kroku 2 oraz na podstawie `docs/IDEA.md`.
Jeżeli niektóre elementy są jeszcze niepewne, zapisz najlepszą roboczą propozycję i wyraźnie zaznacz, że wymaga potwierdzenia przez usera.

Po zakończeniu kroku 4 zaktualizuj checklistę.