Zapoznaj się z `docs/IDEA.md`, aby zrozumieć pomysł na aplikację.

Póki co w tej aplikacji mamy zaimplementowany tylko Welcome Screen, który otwiera się przy pierwszym uruchomieniu aplikacji.

Z Welcome Screen `lib/features/welcome/ui/welcome_screen.dart` user może kontynować jako gość `anonymous` Supabase Auth.

Albo się zalogować. Nie ma opcji rejestracji (i nie będzie), ale tak czy siak do aplikacji wchodzi zawsze jako user z własnym id.

Dalej jest przkierowywany na Home Screen, którego ekran już powinien być gotowy w samej warstwie UI `lib/features/home/ui/home_screen.dart`.

Z ekranu Home Screen może przejść do Profile, gdzie może się zalogować lub zarejestrować (tak naprawdę to zmigrować istniejące konto `guest` na `registered` - nigdy w tej aplikacji nie tworzymy nowego konta od zera). Może tam też się wylogować, ustawić swoje imię itp.

I to na razie tyle ile mamy w tej aplikacji. Jedynie wstępny welcome flow. Wstępny Supabase Auth.

Rozeznaj się, zobacz jak to wszystko działa. Analyze & Explore. Ale niczego nie implementuj. Zapoznaj się tylko z projektem i to wszystko. Zrozum jak to wszystko jest powiązane, ale nie zmieniaj kodu.

Gdy skończysz, poinformuj użytkownika o tym, czy rozumiesz istniejącą bazę kodu. Następnie zaleć mu napisanie `next`. Gdy go otrzymasz, dopiero wtedy przejdź do `docs/commands/04_plan/02_plan-plan.md` - nie podgląduj tego pliku wczesniej!