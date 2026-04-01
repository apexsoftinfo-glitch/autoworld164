---
name: revenuecat-setup
description: This skill should be used when the user asks to "add RevenueCat", "install purchases_flutter", "configure RevenueCat", "set up in-app purchases", "add billing permission", "configure Podfile for purchases", or needs to set up RevenueCat SDK and Dashboard for a Flutter project. Covers dependency, platform config, API keys, Dashboard products/entitlements/offerings, and SDK initialization. (project)
---

# Skill: RevenueCat Setup

Jednorazowa konfiguracja RevenueCat SDK (`purchases_flutter`) w projekcie Flutter. Po zakończeniu setup, użyj skill `revenuecat-integration` do implementacji logiki zakupów.

**Test Store:** RevenueCat udostępnia wbudowany Test Store — można zacząć development bez konfiguracji Apple/Google. Zakupy testowe działają natychmiast, bez realnych opłat.

---

## Krok 1: Dependency

```bash
flutter pub add purchases_flutter
```

---

## Krok 2: iOS

### Podfile

W `ios/Podfile` upewnij się:

```ruby
platform :ios, '13.0'
```

Minimalna wersja RevenueCat to iOS 13.0+ (od wersji 6.x SDK).

### Xcode Capability

Dodaj notatkę dla usera:
> W Xcode: Project Target → Signing & Capabilities → + Capability → In-App Purchase

Szczegóły:
1. Otwórz projekt w Xcode: `ios/Runner.xcworkspace`
2. Wybierz target `Runner`
3. Tab "Signing & Capabilities"
4. Kliknij "+ Capability"
5. Dodaj "In-App Purchase"

Bez tego capability zakupy nie będą działać na urządzeniu (simulator nie wspiera zakupów).

### StoreKit Configuration (do testów)

Dla testów na simulatorze bez konta sandbox:
1. Xcode → File → New → File → StoreKit Configuration File
2. Dodaj produkty zgodne z RevenueCat Dashboard
3. Scheme → Edit Scheme → Run → Options → StoreKit Configuration → wybierz plik

---

## Krok 3: Android

### AndroidManifest.xml

W `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Wewnątrz <manifest> (przed <application>) -->
<uses-permission android:name="com.android.vending.BILLING" />
```

Oraz w `<activity>` upewnij się:

```xml
<activity
    android:name=".MainActivity"
    android:launchMode="singleTop"
    ...>
```

**KRYTYCZNE:** `launchMode` MUSI być `standard` lub `singleTop`. Inne wartości powodują anulowanie zakupu przy weryfikacji w aplikacji bankowej.

### MainActivity

W `android/app/src/main/kotlin/.../MainActivity.kt`:

```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity()
```

**Zmień z `FlutterActivity` na `FlutterFragmentActivity`** — wymagane dla RevenueCat Paywalls.

### Google Play Console

1. Utwórz aplikację w Google Play Console
2. Dodaj produkty subskrypcyjne (monthly, yearly) i jednorazowe (lifetime)
3. Skonfiguruj cenę dla każdego kraju
4. Skopiuj klucz API z RevenueCat Dashboard

---

## Krok 4: API Keys

Przeczytaj `api-keys.json` w root projektu. Dodaj klucze RevenueCat:

```json
{
  "REVENUECAT_APPLE_API_KEY": "appl_...",
  "REVENUECAT_GOOGLE_API_KEY": "goog_..."
}
```

Klucze przekazywane przez `--dart-define-from-file=api-keys.json`.

Klucze pobrać z: RevenueCat Dashboard → Project → API Keys → Public app-specific API keys. To są klucze PUBLICZNE — bezpieczne w aplikacji klienckiej. Apple key zaczyna się od `appl_`, Google od `goog_`.

---

## Krok 5: Inicjalizacja SDK

**W `main.dart` lub odpowiednim serwisie startowym, PO `Supabase.initialize()`, PRZED `runApp()`:**

```dart
import 'dart:io' show Platform;
import 'package:purchases_flutter/purchases_flutter.dart';

Future<void> initRevenueCat() async {
  await Purchases.setLogLevel(LogLevel.debug); // Wyłączyć w produkcji

  final apiKey = Platform.isIOS
      ? const String.fromEnvironment('REVENUECAT_APPLE_API_KEY')
      : const String.fromEnvironment('REVENUECAT_GOOGLE_API_KEY');

  final configuration = PurchasesConfiguration(apiKey)
    ..appUserID = null // RevenueCat generuje $RCAnonymousID
    ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();

  await Purchases.configure(configuration);
}
```

`appUserID = null` → RevenueCat tworzy anonymous ID. Po zalogowaniu usera wywołać `Purchases.logIn(userId)` aby powiązać z Supabase user.

---

## Krok 6: RevenueCat Dashboard Configuration

### Products

Utwórz produkty w RevenueCat Dashboard → Products:

| Identifier | Typ | Cena |
|---|---|---|
| `pro_monthly` | Auto-Renewable Subscription | $9.99/mo |
| `pro_yearly` | Auto-Renewable Subscription | $39.99/yr |
| `pro_lifetime` | Non-Consumable | $99.99 |

### Entitlements

Utwórz entitlement `pro` i przypisz wszystkie 3 produkty.

### Offerings

Utwórz offering `default` z 3 pakietami:
- Monthly → `pro_monthly`
- Annual → `pro_yearly`
- Lifetime → `pro_lifetime`

---

## Reguły

### KRYTYCZNE
- `launchMode` MUSI być `standard` lub `singleTop`
- `FlutterFragmentActivity` zamiast `FlutterActivity`
- `PurchasesAreCompletedByRevenueCat()` w konfiguracji
- Inicjalizacja PRZED `runApp()` ale PO `Supabase.initialize()`
- `Purchases.setLogLevel(LogLevel.debug)` w dev, wyłączyć w produkcji

### WAŻNE
- API keys to klucze PUBLICZNE (app-specific) — bezpieczne w kliencie
- Test Store pozwala testować bez konfiguracji Apple/Google
- Entitlement name `'pro'` musi zgadzać się z Dashboard

---

## Troubleshooting

### "No offerings found"
- Sprawdź czy produkty są skonfigurowane w App Store Connect / Google Play Console
- Sprawdź czy produkty są przypisane do offering w RevenueCat Dashboard
- Na iOS simulatorze: użyj StoreKit Configuration File
- Test Store działa od razu — jeśli offerings puste, problem z API key

### "Invalid API key"
- Upewnij się że używasz PUBLIC app-specific key (nie secret key)
- Apple key zaczyna się od `appl_`, Google od `goog_`
- Sprawdź `api-keys.json` i `--dart-define-from-file`

### Sandbox Testing
- iOS: Settings → App Store → Sandbox Account
- Android: Google Play Console → License Testing → dodaj email testera
- Alternatywnie: użyj RevenueCat Test Store (nie wymaga konfiguracji store'ów)

### Referencyjny przykład

Oficjalny przykład Flutter: https://github.com/RevenueCat/purchases-flutter/tree/main/revenuecat_examples/MagicWeather
