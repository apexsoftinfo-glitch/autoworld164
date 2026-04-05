# Design System: VIP Showcase (Warm Gallery)

## Koncepcja Wizualna
Styl aplikacji **AutoWorld164** opiera się na koncepcji **VIP Showcase** – luksusowej, prywatnej galerii kolekcjonerskiej. Dominują w niej ciepłe, wieczorne barwy, które nadają poczucie prestiżu i pasji do detali.

## Paleta Kolorów
- **Primary:** `#FFD700` (Gold) – Używany do najważniejszych akcentów, nagłówków i ikon.
- **Secondary:** `#FF9800` (Amber) – Barwa oświetlenia i ciepłych tonów tła.
- **Background:** `#0C0C0C` (Deep Black) – Głębia, która pozwala "wybić się" modelom aut.
- **Glass:** `RGBA(255, 255, 255, 0.1)` z rozmyciem `sigma: 18` – Efekt matowego szkła (Glassmorphism).

## Typografia
- **Tytuły Sekcji:** Szeroki rozstaw liter (`letter-spacing: 5`), krój bazujący na elegancji (np. Montserrat lub Inter o niskiej wadze).
- **Nagłówki Główne:** Wyraziste, ale szlachetne (Serif lub lekki Sans-Serif).
- **Etykiety danych:** Precyzyjne, czytelne, często pisane wersalikami (ALL CAPS).

## Kluczowe Elementy UI
1.  **Tło (Atmospheric Background):** Wysokiej jakości fotografia nowoczesnego garażu z otwartymi bramami i ciepłym światłem zachodzącego słońca.
2.  **Karty (GlassBox):** Transparentne kafelki z silnym efektem rozmycia tła (`BackdropFilter`). Posiadają cienkie, złote lub srebrne obramowania (1px).
3.  **Akcje (Floating Action Button):** Złoty przycisk z wyraźnym cieniem, stanowiący centralny punkt interakcji.
4.  **Mikrointerakcje:** Delikatne powiększanie (scale) kafelków po dotknięciu i przejścia oparte na głębi (Z-axis).

## Vibe & Atmosfera
Aplikacja ma sprawiać wrażenie "Centrum Zarządzania Prywatną Kolekcją", gdzie każdy model jest traktowany jak dzieło sztuki w prestiżowej, ciepło oświetlonej galerii.
