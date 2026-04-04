Wciel się w rolę Senior ASO Eksperta. Masz już pełen kontekst o aplikacji. 
Twoim zadaniem jest nadpisanie pliku `docs/PUBLISH.md` gotowymi tekstami marketingowymi oraz usunięcie zbędnych elementów.

### 📝 ZASADY EDYCJI I FORMATOWANIA (Rygorystyczne):

**1. Języki**
- Formularze (IARC, Data Safety, kategorie) mają zostać PO POLSKU.
- Teksty ASO (Title, Subtitle, Description, teksty na screeny) PO ANGIELSKU.

**2. Czystość i Formatowanie (BARDZO WAŻNE)**
- **Usuń znaczniki limitów:** Wszędzie tam, gdzie w szablonie było napisane np. `(max 30)`, `(max 80)`, `(max 4000)` – USUŃ TO.
- **Brak liczników:** Pilnuj limitów znaków wewnętrznie, ale NIE WPISUJ do pliku liczników typu `[25/30 znaków]`.
- **Wyraźne oddzielenie długich tekstów:** Długie bloki tekstu (Description dla iOS i Pełny opis dla Androida) muszą być oddzielone od reszty dokumentu poziomymi liniami. Użyj `---` nad i pod opisem, oraz pustych linii, by tekst oddychał i nie zlewał się z checklistą.
- **Usuń nieużywane opcje:** Usuń z dokumentu CAŁKOWICIE wszystkie niezaznaczone tagi, kategorie i typy danych. Zostaw tylko to, co wybrałeś.
- **Placeholdery:** Wszędzie tam, gdzie brakuje maila, adresu URL, konta testowego, wpisz dokładnie: `🛑 [TODO: UZUPEŁNIJ]`.

**3. Optymalizacja ASO**
- **App Name / Tytuł (iOS & Android):** Max 30 znaków. "Brand: Niche Keyword".
- **iOS Keywords:** Max 100 znaków. Słowa oddzielone TYLKO PRZECINKAMI (zero spacji).
- **iOS Subtitle:** Max 30 znaków.
- **Description (iOS/Android):** Max 4000 znaków. Naturalne słowa kluczowe. Używaj punktowania. iOS - bez emotikonów. Android - umiarkowane emotikony jako separatory.
- **Screenshots:** Koncepcja 5 zrzutów. Format: [Opis UI] | Tytuł marketingowy na grafice.

**4. Formularze**
- Zaznacz odpowiednie opcje w Data Safety, Prawa autorskie itp., na podstawie SDK, które znalazłeś w kodzie w poprzednim kroku. 

### ⚙️ AKCJA KOŃCOWA:
1. Nadpisz plik `docs/PUBLISH.md`.
2. **ZACOMMITUJ ten plik do repozytorium** z wiadomością: "chore: generate initial ASO metadata and PUBLISH.md template".
3. Wyświetl w czacie TYLKO tę wiadomość:

*"Zacommitowałem wstępny plik PUBLISH.md. Znajdziesz w nim znaczniki `🛑 [TODO: UZUPEŁNIJ]`. Napisz `next`, a wczytam trzeci prompt z pliku `docs/commands/06_publish/03_publish-questions.md`, w którym sprawnie poproszę Cię o te brakujące dane."*