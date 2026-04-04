Wciel się w asystenta publikacji. W poprzednim kroku wygenerowałeś plik `docs/PUBLISH.md`, w którym znajdują się placeholdery oznaczone jako `🛑[TODO: UZUPEŁNIJ]`.

Twoim celem jest dokończenie pliku na podstawie odpowiedzi użytkownika.

### 🛠 KROK 1: ZAPYTAJ UŻYTKOWNIKA
1. Przeskanuj plik `docs/PUBLISH.md` w poszukiwaniu wystąpień tekstu `🛑 [TODO: UZUPEŁNIJ]`.
2. Wypisz je w formie ponumerowanej listy w czacie. 
**WAŻNE WYJĄTKI:**
- Jeśli brakuje danych do "Konta Testowego", zapytaj Opcjonalnie o e-mail i hasło. Poinformuj, że jeśli użytkownik ich nie ma (bo apka pozwala na logowanie gościa), może to pominąć. 
- NIE PYTAJ o pole "Notes" dla konta testowego (uzupełnisz je sam w kolejnym kroku).

3. Poinformuj mnie: *"Jeśli nie masz jeszcze niektórych danych, napisz 'pomiń', a zostawię placeholdery. Gdy odpowiesz, zaktualizuję plik i zacommituję zmiany."*

ZATRZYMAJ SIĘ I CZEKAJ NA MOJĄ ODPOWIEDŹ.

### 🛠 KROK 2: AKTUALIZACJA I COMMIT (Po mojej odpowiedzi)
Gdy podam Ci dane (lub napiszę "pomiń"):
1. Otwórz `docs/PUBLISH.md` i podmień odpowiednie placeholdery.
2. Jeśli użytkownik pominął dane logowania testowego, wypełnij pole "Notes" tekstem: *"Aplikacja posiada tryb gościa (Guest Mode). Weryfikacja nie wymaga podawania danych logowania."* Jeśli podał dane, wpisz *"Zaloguj się powyższymi danymi."*
3. **ZACOMMITUJ plik do repozytorium** z wiadomością: `chore: update PUBLISH.md with missing administrative data`.
4. Wyświetl w czacie TYLKO tę wiadomość:
*"Plik zaktualizowany! Napisz `next`, a wczytam prompt z pliku `docs/commands/06_publish/04_publish-aso-image-prompts.md`."*