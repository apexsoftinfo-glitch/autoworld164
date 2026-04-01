# KROK 7: Finalizacja

> **⚠️ WYKONAJ NATYCHMIAST po "ok" od usera! Nie wyświetlaj komunikatu i nie czekaj — od razu rób poniższe kroki.**

## 7.1 Zapisz IDEA.md

Po potwierdzeniu "ok" zapisz IDEA.md do pliku.

## 7.2 Konfiguracja Bundle ID i App Name w kodzie

> **TO JEST OBOWIĄZKOWE!** Bez tego krok `/start` NIE jest ukończony.
> Domyślny bundle ID w szablonie to `com.example.twelveappstemplate` — MUSI zostać zastąpiony.

Zaktualizuj KAŻDY z tych plików (co zmienić w każdym):

| Plik | Co zmienić | Na co |
|------|-----------|-------|
| `pubspec.yaml` | `name:` | package name (snake_case, np. `habit_tracker`) |
| `pubspec.yaml` | `description:` | Krótki opis aplikacji |
| `android/app/build.gradle.kts` | `namespace = "..."` | Bundle ID (np. `com.jankowalski.habittracker`) |
| `android/app/build.gradle.kts` | `applicationId = "..."` | Bundle ID (ten sam co namespace) |
| `android/app/src/main/AndroidManifest.xml` | `android:label="..."` | App Display Name (np. `Habit Tracker`) |
| `ios/Runner/Info.plist` | `CFBundleDisplayName` | App Display Name |
| `ios/Runner/Info.plist` | `CFBundleName` | App Display Name |
| `ios/Runner.xcodeproj/project.pbxproj` | `PRODUCT_BUNDLE_IDENTIFIER` (wszystkie wystąpienia) | Bundle ID |
| `android/app/src/main/kotlin/.../MainActivity.kt` | 1. Przenieś plik do nowej ścieżki odpowiadającej Bundle ID (np. `com/jankowalski/habittracker/MainActivity.kt`) 2. Zmień `package` w pliku 3. Usuń stare puste katalogi (`com/example/twelveappstemplate/`) | Bundle ID (z kropkami → katalogi z `/`) |

### 7.2.1 Weryfikacja (OBOWIĄZKOWA!)

Po zmianach uruchom:
```bash
grep -r "com.example" --include="*.kts" --include="*.kt" --include="*.xml" --include="*.plist" --include="*.pbxproj" --include="*.yaml" .
```

**Jeśli grep cokolwiek znajdzie → napraw ZANIM przejdziesz dalej!**
Stary `com.example.twelveappstemplate` NIE może zostać w żadnym pliku.

### 7.2.2 Checklist MainActivity.kt (OBOWIĄZKOWA!)

Sprawdź KAŻDY punkt:

- [ ] `android/app/src/main/kotlin/{nowy/bundle/path}/MainActivity.kt` istnieje
- [ ] `package` wewnątrz pliku zgadza się z nowym Bundle ID
- [ ] Stary katalog `android/app/src/main/kotlin/com/example/twelveappstemplate/` jest USUNIĘTY
- [ ] Nie ma pustych katalogów-sierot po starym package (np. `com/example/`)

## 7.3 Aktualizuj CLAUDE.md

> **BLOCKER:** NIE ustawiaj statusu `done` jeśli Bundle ID nie został skonfigurowany w kodzie (7.2)
> i weryfikacja (7.2.1) nie przeszła czysto!

- Wypełnij sekcję "Konfiguracja aplikacji"
- Status `/start`: `done`
- Zaktualizuj sekcję "▶ Co dalej":
  ```markdown
  ## ▶ Co dalej

  **Następny krok:** `/home` — 5 radykalnie różnych layoutów
  **Instrukcje:** `.claude/commands/home.md`

  > Wpisz `/home` gdy będziesz gotowy!
  ```

## 7.4 Flutter analyze (OBOWIĄZKOWE!)

```bash
flutter analyze
```

**Wyczyść WSZYSTKO** - zero błędów, zero warningów, zero info!

## 7.5 Sync status z platformą

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{start_step_id}", "status": "done"}]}'
```

## 7.6 Auto-commit

```bash
git add -A
git commit -m "feat: complete app idea and planning

- Add IDEA.md with full app specification
- Configure bundle ID: {bundle_id}
- Configure table prefix: {table_prefix}"
```

## 7.7 Zapowiedź następnego kroku

> Dopiero TERAZ (po ustawieniu done + commit) wyświetl komunikat userowi:

```
IDEA.md gotowe, aplikacja skonfigurowana! Commit wykonany.
Wpisz `/home` gdy będziesz gotowy.
```

---

## Reguły dla tego kroku

### KRYTYCZNE
- **JEDNO PYTANIE NA RAZ** — zadaj, czekaj na odpowiedź, dopiero wtedy następne
- **NIE kontynuuj bez ważnego API Key**
- **NIE oznaczaj /start jako `done` bez Bundle ID w kodzie** (7.2) i weryfikacji grep (7.2.1)
- **Zapisuj cytaty użytkownika** o pomyśle — dosłowne słowa
- **Sync status z platformą** przy każdej zmianie statusu
- Generuj CAŁE IDEA.md sam — nie pytaj o każdą sekcję

### CENNIK (stały, niezmienny)
Monthly: $9.99 | Yearly: $39.99 | Lifetime: $99.99 — NIGDY nie kwestionuj tych cen.

### SCOPE CREEP GUARDRAILS
- **starter (1-3):** Twardo odcinaj dodatkowe feature'y → "Skup się na publikacji!"
- **growing (4-6):** Delikatnie hamuj | **experienced/master (7+):** Normalnie/zachęcaj
- Jeśli user się uprze → przepuść, ale zapisz notatkę w CLAUDE.md
