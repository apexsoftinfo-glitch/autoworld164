# WPROWADZENIE

Stworzyć 5 wariantów ekranu głównego Home Screen dla pomysłu opisanego w @IDEA.md.

## Znaczenie

Główny ekran aplikacji (Home Screen) to ekran na którego trafia user z trzech źródeł:

1. Pierwsze uruchomienie -> Welcome Screen -> Kontynuuj jako gość -> Home Screen.
2. Pierwsze uruchomienie -> Welcome Screen -> Zaloguj się -> Home Screen.
3. Każde kolejne uruchomienie, gdy otwiera aplikację.

Jest to core całej aplikacji.

## Wymagania

Wszystkie warianty mają być bez kolorów, bez gradientów, bez cieni, bez zaokrągleń, bez czcionek itp Nie na tym się teraz skupiamy.

Za to mają się radykalnie różniej pod względem tego:
- jakie elementy wchodzą w skład ekranu (bardzo rozbudowany lub minimalistyczny?)
- jak są rozłożone (co na górze, co na dole, co za scrollem?)
- co jest jednym, głównym CTA na tym ekranie
- jakie mają animacje
- jak wchodzą w interakcję, jakie gesty, jakie scrolle itp
itp 

Wiesz o co chodzi?

Ma to przypominać implementację wireframeów, gdzie testujemy różne opcje, ale jeszcze na żaden się nie decydujemy.

User wybierze jeden, który mu najbardziej pasuje, resztę usuniesz.

Skupiamy się na UX, nie na wyglądzie.

Warianty muszą radykalnie od siebie różnić. Think outside the box.

# ZADANIE

Zapoznaj się się z plikiem @IDEA.md. Twoim zadaniem będzie zaprojektowanie 5 wariantów głównego ekran aplikacji. 

Pracujemy w `lib/features/home/ui/home_screen.dart`.

Podmień wszystko to co masz tam teraz. Możesz skorzystać z przygotowanego kodu pod zaprezentowanie tych 5 wariantów oraz ready to use HomeVariantSwitcher.

Pamiętaj, że robimy to tylko wizualnie, bez podpninania żadnej bazy danych, wszystko ma się resetować po ponownym uruchomieniu, chodzi tylko ui/presentation layer.

Ekran w każdej wersji ma być prosty i intuicyjny. Don't make them think. Less is more. Robić jedną rzecz, ale dobrze. Im mniej elementów tym lepiej. Wyraźna hierarchia co jest głównym, jednym, najważniejszym CTA, a co całą resztą.

Jeżeli core aplikacji to kilka ekranów, to zaprojektuj kilka z nich pod każdy wariant, ale wciąż, to tylko warstwa UI, nawet nie wchodź w temat bloc/cubit.

Z głównego ekranu, user zawsze ma mieć bezposredni dostęp do istniejącego ekranu Profilu ProfileScreen `lib/features/profiles/presentation/ui/profile_screen.dart`.

[] zapoznales sie z idea.md
[] zaimplementowales 5 radykalnie różnych wariantow ekranu głównego
[] zapytales usera ktory mu sie najabrzdiej podoba
[] user zdecydowal sie na jakas wersje
[] wstawiles do home_screen.dart tylko tę wersję, resztę niepotrzebnego kodu posprzątałeś
[] zrobiles commit