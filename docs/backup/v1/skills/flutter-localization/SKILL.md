---
name: flutter-localization
description: This skill should be used when the user asks to "add localization", "translate app", "add i18n", "internationalization", "add Polish/English", "language switcher", "przełącznik języka", "dodaj tłumaczenia", "zlokalizuj stringi", mentions "ARB files", "flutter_localizations", "AppLocalizations", or needs to make a Flutter app multilingual. (project)
---

# Skill: Flutter Localization (i18n)

Implements internationalization in Flutter using official `flutter_localizations` package with ARB files.

## Quick Reference

| Item | Value |
|------|-------|
| Packages | `flutter_localizations` (sdk), `intl: any` |
| Config file | `l10n.yaml` in project root |
| ARB location | `lib/l10n/` |
| Template | `app_pl.arb` (Polish as base) |
| Generated | `.dart_tool/flutter_gen/gen_l10n/` |
| Usage | `AppLocalizations.of(context)!.keyName` |

---

## Setup

### 1. Add Dependencies

```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:
  generate: true  # Enable code generation
```

### 2. Create l10n.yaml

```yaml
# l10n.yaml (project root)
arb-dir: lib/l10n
template-arb-file: app_pl.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

### 3. Generate Code

```bash
flutter pub get
flutter gen-l10n
```

---

## ARB Files

### Directory Structure

```
lib/l10n/
├── app_pl.arb   # Template (Polish)
└── app_en.arb   # English translation
```

### Basic Format

```json
{
  "@@locale": "pl",

  "welcome_title": "Witaj w aplikacji",
  "welcome_start": "Rozpocznij",
  "welcome_login": "Mam już konto"
}
```

### With Parameters

```json
{
  "greeting": "Cześć, {name}!",
  "@greeting": {
    "placeholders": {
      "name": { "type": "String" }
    }
  }
}
```

### With Plurals

```json
{
  "itemCount": "{count, plural, =0{brak elementów} =1{1 element} few{{count} elementy} many{{count} elementów} other{{count} elementów}}",
  "@itemCount": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

### Key Naming Convention

- `{screen}_{element}` - `welcome_title`, `home_empty_message`
- `{screen}_{element}_{variant}` - `dialog_delete_title`, `dialog_delete_confirm`
- `{feature}_{action}` - `auth_logout`, `settings_language`

For detailed ARB format, placeholders, and pluralization rules, see `references/arb-format.md`.

---

## MaterialApp Configuration

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialApp(
  locale: localeService.locale,
  supportedLocales: const [
    Locale('pl'),
    Locale('en'),
  ],
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: const AppGate(),
)
```

---

## LocaleService (with Device Detection)

**Priority for locale selection:**
1. Saved user preference → use it
2. Device language (if supported: pl/en) → use it
3. Fallback → English (en)

```dart
// lib/core/services/locale_service.dart

import 'dart:ui';
import 'package:flutter/material.dart';

class LocaleService extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  static const Locale _fallbackLocale = Locale('en');

  static const List<Locale> supportedLocales = [
    Locale('pl'),
    Locale('en'),
  ];

  final LocalStorageService _localStorage;
  Locale _locale = _fallbackLocale;

  LocaleService(this._localStorage) {
    _loadLocale();
  }

  Locale get locale => _locale;

  Future<void> _loadLocale() async {
    // 1. Check saved preference
    final savedCode = _localStorage.getString(_localeKey);
    if (savedCode != null) {
      _locale = Locale(savedCode);
      notifyListeners();
      return;
    }

    // 2. Detect device language
    final deviceLocale = PlatformDispatcher.instance.locale;
    final deviceLanguage = deviceLocale.languageCode;

    if (supportedLocales.any((l) => l.languageCode == deviceLanguage)) {
      _locale = Locale(deviceLanguage);
    }
    // 3. Fallback to 'en' (already set)

    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _localStorage.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }
}
```

### DI Registration

```dart
// injection.config.dart or manual registration
@lazySingleton
LocaleService localeService(LocalStorageService storage) => LocaleService(storage);
```

---

## Usage in Code

### Basic Usage

```dart
// Access translations
Text(AppLocalizations.of(context)!.welcome_title)

// With parameter
Text(AppLocalizations.of(context)!.greeting(userName))

// With plural
Text(AppLocalizations.of(context)!.itemCount(items.length))
```

### Extension Helper (Optional)

```dart
// lib/core/extensions/build_context_extensions.dart
extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

// Usage
Text(context.l10n.welcome_title)
```

---

## Language Switcher in Settings

```dart
ListTile(
  title: Text(AppLocalizations.of(context)!.settings_language),
  subtitle: Text(_currentLanguageName(context)),
  trailing: const Icon(Icons.chevron_right),
  onTap: () => _showLanguageDialog(context),
),

void _showLanguageDialog(BuildContext context) {
  final localeService = context.read<LocaleService>();
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (_) => SimpleDialog(
      title: Text(l10n.settings_language),
      children: [
        RadioListTile<Locale>(
          title: Text(l10n.language_polish),
          value: const Locale('pl'),
          groupValue: localeService.locale,
          onChanged: (locale) {
            localeService.setLocale(locale!);
            Navigator.pop(context);
          },
        ),
        RadioListTile<Locale>(
          title: Text(l10n.language_english),
          value: const Locale('en'),
          groupValue: localeService.locale,
          onChanged: (locale) {
            localeService.setLocale(locale!);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

String _currentLanguageName(BuildContext context) {
  final locale = context.read<LocaleService>().locale;
  final l10n = AppLocalizations.of(context)!;
  return locale.languageCode == 'pl'
      ? l10n.language_polish
      : l10n.language_english;
}
```

---

## Finding Strings to Localize

### Search Commands

```bash
# Find marked strings (// L10N comments)
grep -r "// L10N" lib/

# Find Text() with literals
grep -rE "Text\s*\(\s*['\"]" lib/ --include="*.dart"

# Find hintText, labelText
grep -rE "(hintText|labelText):\s*['\"]" lib/ --include="*.dart"

# Find SnackBar content
grep -rE "SnackBar\s*\(" lib/ --include="*.dart"
```

### Critical Locations

Check these files thoroughly:
- `welcome_screen.dart` - title, buttons
- `onboarding_screen.dart` - ALL pages (questions, hints, buttons, demo data)
- `home_screen.dart` - greeting, empty state, CTA
- `settings_screen.dart` - all options, dialogs
- `shared/widgets/` - reusable dialogs, buttons

---

## File Structure After Setup

```
lib/
├── l10n/
│   ├── app_pl.arb          # Polish (template)
│   └── app_en.arb          # English
├── core/
│   ├── services/
│   │   └── locale_service.dart
│   └── extensions/
│       └── build_context_extensions.dart
└── app/
    └── app.dart            # MaterialApp with localization

# Generated (in .gitignore)
.dart_tool/flutter_gen/gen_l10n/
├── app_localizations.dart
├── app_localizations_en.dart
└── app_localizations_pl.dart
```

---

## Required ARB Keys (Minimum)

Every app should have these localized:
- Welcome screen (title, buttons)
- Onboarding - ALL pages
- Home screen (greeting, empty state)
- Settings (all options, language names)
- Dialogs (confirm, cancel, delete)
- Error messages (generic, network)
- Language names (`language_polish`, `language_english`)

---

## Rules

### Always
- Polish (app_pl.arb) as template file
- Both languages have identical keys
- Device language detection on first launch
- Persist user's manual language choice
- Use placeholders for dynamic content ({name}, {count})
- Fallback to English when device language unsupported

### Never
- Hardcoded strings in UI after localization
- Missing translations (check both ARB files)
- Hardcoded default locale (detect device language)
- Language without persistence

---

## Additional Resources

### Reference Files
- **`references/arb-format.md`** - Detailed ARB syntax, plurals, select, dates, numbers

### Commands
```bash
flutter gen-l10n           # Regenerate after ARB changes
flutter analyze            # Check for issues
```
