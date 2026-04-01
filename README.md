# Flutter Mobile App

Aplikacja mobilna Flutter na `iOS` i `Android`.

Szczegóły produktu znajdują się w [IDEA.md](IDEA.md).

## Codemagic: `config/api-keys.json`

Plik `config/api-keys.json` nie powinien być trzymany jawnie w konfiguracji CI. W Codemagic należy przekazać jego zawartość jako base64 przez zmienną środowiskową `API_KEYS_BASE64`.

### Wygenerowanie base64

macOS:

```sh
# Od razu kopiuje do schowka:
base64 -i config/api-keys.json | pbcopy

# Lub żeby zobaczyć wynik w terminalu:
base64 -i config/api-keys.json
```

Windows:

```powershell
# Od razu kopiuje do schowka:
[Convert]::ToBase64String([IO.File]::ReadAllBytes("config\api-keys.json")) | Set-Clipboard

# Lub żeby zobaczyć wynik w terminalu:
[Convert]::ToBase64String([IO.File]::ReadAllBytes("config\api-keys.json"))
```

### Konfiguracja w Codemagic

1. W `Environment Variables` dodaj zmienną `API_KEYS_BASE64`.
2. Wklej do niej wartość wygenerowaną z `config/api-keys.json`.
3. W `Pre-build script` dodaj:

```sh
#!/bin/sh
mkdir -p config
echo "$API_KEYS_BASE64" | base64 --decode > config/api-keys.json
```

4. W `Post-clone script` dodaj:

```sh
flutter pub get
```

5. W `Build -> Build arguments` dodaj dla `iOS` i `Android`:

```sh
--dart-define-from-file=config/api-keys.json --build-name=0.0.$(($PROJECT_BUILD_NUMBER + 9)) --build-number=$(($PROJECT_BUILD_NUMBER + 9))
```

Po tym kroku plik `config/api-keys.json` zostanie odtworzony w czasie buildu.

## Źródło template

Aplikacja została wygenerowana na podstawie Flutter Template by Adam Smaka: [www.12apps.pl](https://www.12apps.pl).
