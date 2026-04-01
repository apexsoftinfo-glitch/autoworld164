# Zwycięski Design: Wariant A ("Prywatny Garaż")

Użytkownik wybrał **Wariant A** jako główny kierunek wizualny dla aplikacji AutoWorld164.
Aplikacja ma prezentować się jako *narzędzie dla profesjonalnego kolekcjonera* - skupione na danych, czyste, z mocnym naciskiem na czytelność.

## Główne założenia wizualne (Design Principles)

1. **Nowoczesny Minimalizm (Editorial Setup)**:
   - Dużo "światła" (whitespace), pozwalającego interfejsowi oddychać.
   - Płaskie, proste panele z maksymalnie zaokrąglonymi rogami, rezygnacja z krzykliwych kolorów.

2. **Ciepłe, Garażowe Akcenty**:
   - Choć bazowy układ (Layout A) operuje głównie na strukturze szarości, docelowo projekt używa przełamanej, ciepłej bieli w tle (cieplejsze szarości zamiast chłodnych, technicznych granatów).
   - *Nota:* Wraz z przejściem do zasilania stanowisk danymi w późniejszym etapie, wprowadzane będą ciepłe kolory dla poszczególnych sygnałów (np. oświetlenie statusu, kolory akcentów na autach).

## Reguły interfejsu (Visual Specs)

- **Tło Główne (Scaffold)**: Bardzo jasna, neutralna szarość (np. `Colors.grey[100]`), nadająca strukturę bez "świecenia w oczy".
- **Karty & Panele (Surface)**: Czysta biel (`Colors.white`) dla paneli dociśniętych do tła (np. dolny panel statystyk), oraz dedykowane, stonowane odcienie dla przycisków akcji (`Colors.grey[200]`, `Colors.grey[300]`).
- **Narożniki**: Spójny promień zaokrąglenia - `BorderRadius.circular(24)` dla kafelków w Gridzie; `circular(32)` dla dużych paneli typu Bottom Sheet.
- **Cienie**: Maksymalnie subtelne, używane tylko tam, gdzie istnieje wyraźna elewacja (np. nakładający się dolny panel statystyk: `alpha: 0.05, blurRadius: 10, offset: y-5`).

## Typografia

- Bazujemy na czytelnych fontach o charakterze sans-serif i nowoczesnej architekturze (skupienie na systemowych, czystych krojach lub Inter z `google_fonts`).
- **Nagłówki (H1/H2)**: Pogrubione (`FontWeight.bold`), silny kontrast względem tła (kolory rzędu `grey[800]`).
- **Teksty Pomocnicze i Podpisy**: Zdecydowanie jaśniejsze (`grey[600]` oraz `grey[500]`), mały rozmiar czcionki (często np. `fontSize: 10` do `12`), użyte z szerokim kerningiem (`letterSpacing: 1.2`) dla tagów i etykiet metadanych.
 
## Konstrukcja "Home Screen"
1. **Pasek powitalny (Złota zasada)**: Nazwa "AutoWorld164" + Powitanie po imieniu + Avatar na samej górze. 
2. **Kafelki nawigacyjne (Narzędziownia Grid)**: "Mój garaż", "Nowości", "Marketplace", "Ustawienia", ułożone wg zbalansowanej siatki `GridView.count` (2 na 2).
3. **Deska rozdzielcza (Dashboard)**: Stały panel zadokowany na dole ekranu, prezentujący podsumowanie na "jedno spojrzenie" (ilość sztuk, wartość zakupowa, bieżąca wycena z dynamicznym wskaźnikiem np. "+ $850").
