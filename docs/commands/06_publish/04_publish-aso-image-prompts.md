Wciel się w rolę wybitnego Prompt Engineera oraz dyrektora artystycznego. Twój cel to stworzenie dwóch niezależnych od siebie promptów (w języku angielskim), które użytkownik będzie mógł skopiować i wkleić do generatora obrazów (np. Midjourney, DALL-E, Nano Banana), aby wygenerować grafiki do sklepów z aplikacjami.

### 🗂 ETAP 1: KONTEKST WIZUALNY
Zanim zaczniesz pisać, przeanalizuj styl aplikacji:
1. Przeczytaj plik `docs/DESIGN.md`, by zrozumieć zamysł artystyczny.
2. Sprawdź w kodzie pliki odpowiedzialne za kolory (np. `ThemeData`, pliki z paletami kolorów), aby poznać dokładne odcienie bazowe i akcenty używane w aplikacji.
3. Przypomnij sobie z `IDEA.md` czym jest aplikacja, jaka jest jej główna obietnica oraz `Long tail keyword`.

### 📝 ETAP 2: GENEROWANIE PROMPTÓW (Na sam dół PUBLISH.md)
Otwórz plik `docs/PUBLISH.md` i dodaj na samym dole nową sekcję: `## 🎨 5. AI Image Generation Prompts`. W tej sekcji umieść instrukcję dla użytkownika oraz dwa poniższe prompty (same prompty muszą być po angielsku!). Sam wymyśl konkretny symbol i wizję grafiki na podstawie zdobytej wiedzy.

Struktura, którą masz wygenerować w pliku `PUBLISH.md`, ma wyglądać dokładnie tak:

**⚠️ WAŻNE:** Zanim wkleisz poniższe prompty do generatora AI (np. Nano Banana, GPT, Midjourney), **MUSISZ ZAŁĄCZYĆ SCREENSHOT** ze swojej aplikacji! Oba prompty bezpośrednio się do niego odwołują jako do głównego źródła inspiracji.

**Prompt 1: App Icon (Ikona Aplikacji)**
"I have attached a screenshot of my mobile app to this message. Act as an expert graphic designer specializing in minimalist, flat-vector logos. Generate a single, perfectly square app icon based on the UI, style, and colors of the attached screenshot, combined with the specific concept below.
CRITICAL RULES:
1. STRICTLY SQUARE: 1:1 aspect ratio.
2. NO ROUNDED CORNERS: Full-bleed background edge-to-edge.
3. NO MARGINS/BORDERS.
4. NO TEXT: Zero letters or numbers.
5. STYLE MATCH: Extract the exact color palette, lighting, and visual vibe from the attached screenshot. Additionally, ensure these core brand colors are prominent:[Wypisz 2-3 główne kolory, które znalazłeś w kodzie/DESIGN.md].
6. MINIMALIST: Design only ONE central symbol.
SYMBOL CONCEPT:[Zbuduj 1-2 zdania precyzyjnie opisujące prosty, minimalistyczny symbol związany z funkcją aplikacji. Np. 'A stylized geometric leaf overlapping a checkmark', a nie 'an icon for a habit app']."

**Prompt 2: Google Play Feature Graphic**
"I have attached a screenshot of my mobile app to this message. Act as an expert mobile app store marketer and graphic designer. Generate a Google Play Feature Graphic based heavily on the visual style, vibe, and color palette of the attached screenshot.
TECHNICAL REQUIREMENTS:
- Dimensions: 1024x500px (Wide, horizontal format).
- Clean, professional, and readable as a thumbnail.
- Leave safe margins around the edges.
- DO NOT add 'Download' buttons or store UI elements.
DESIGN INSTRUCTIONS:
1. VIBE & COLORS: Treat the attached screenshot as your primary inspiration. Harmonize the graphic with the screenshot's aesthetic. Incorporate the core brand colors:[Wypisz te same kolory co wyżej]. Avoid generic stock aesthetics.
2. TEXT OVERLAY: Place exactly this text on the graphic in a bold, highly legible modern font: "[Wpisz tutaj nazwę aplikacji oraz Long tail keyword, np. 'ZenHabit: Daily Routine Tracker']". DO NOT add any other words.
3. VISUAL CONCEPT:[Zbuduj 1-2 zdania opisujące co powinno znajdować się w tle / obok tekstu. Powinno to być abstrakcyjne tło z delikatnym motywem nawiązującym do aplikacji, niezbyt krzykliwe, by tekst był czytelny]."

### ⚙️ AKCJA KOŃCOWA:
1. Dopisz tę nową sekcję na koniec pliku `docs/PUBLISH.md`.
2. Zapisz plik.
3. **ZACOMMITUJ plik do repozytorium** z wiadomością: `chore: append AI image generation prompts to PUBLISH.md`.
4. Poinformuj mnie w czacie, że proces jest zakończony, a gotowe prompty czekają na dole pliku `PUBLISH.md`. 

Zakończ wiadomość dokładnie tym tekstem:
*"Wygeneruj teraz swoje grafiki przy użyciu dostarczonych promptów. 

Gdy wybierzesz najlepszą ikonę, zapisz ją w projekcie w lokalizacji `assets/images/icon/icon.png` (upewnij się, że ma dokładnie taką nazwę i rozszerzenie).

Gdy to zrobisz, napisz `next`, a wczytam piąty prompt z pliku `docs/commands/06_publish/05_publish-icon-gen.md`."*