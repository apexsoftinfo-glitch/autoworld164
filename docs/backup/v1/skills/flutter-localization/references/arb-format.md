# ARB File Format Reference

Application Resource Bundle (ARB) is a JSON-based format for localization.

## Basic Structure

```json
{
  "@@locale": "pl",

  "key": "value",
  "@key": {
    "description": "Optional description for translators"
  }
}
```

---

## Simple Strings

```json
{
  "welcome_title": "Witaj w aplikacji",
  "welcome_start": "Rozpocznij",
  "welcome_login": "Mam już konto",
  "settings_logout": "Wyloguj się"
}
```

---

## Strings with Placeholders

### String Parameter

```json
{
  "greeting": "Cześć, {name}!",
  "@greeting": {
    "description": "Greeting with user name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "Jan"
      }
    }
  }
}
```

**Dart usage:**
```dart
AppLocalizations.of(context)!.greeting('Jan')
// Output: "Cześć, Jan!"
```

### Integer Parameter

```json
{
  "limitMessage": "Masz już {count} elementów",
  "@limitMessage": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

**Dart usage:**
```dart
AppLocalizations.of(context)!.limitMessage(5)
// Output: "Masz już 5 elementów"
```

### Multiple Parameters

```json
{
  "welcomeBack": "Witaj ponownie, {name}! Masz {count} nowych wiadomości.",
  "@welcomeBack": {
    "placeholders": {
      "name": { "type": "String" },
      "count": { "type": "int" }
    }
  }
}
```

---

## Pluralization

### Polish Plural Forms

Polish has complex plural rules:
- `=0` - zero (brak)
- `=1` - singular (1 element)
- `few` - 2-4, 22-24, 32-34... (elementy)
- `many` - 0, 5-21, 25-31... (elementów)
- `other` - fallback (elementów)

```json
{
  "itemCount": "{count, plural, =0{brak elementów} =1{1 element} few{{count} elementy} many{{count} elementów} other{{count} elementów}}",
  "@itemCount": {
    "description": "Number of items with proper Polish pluralization",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

**Results:**
| count | Output |
|-------|--------|
| 0 | brak elementów |
| 1 | 1 element |
| 2 | 2 elementy |
| 5 | 5 elementów |
| 12 | 12 elementów |
| 22 | 22 elementy |
| 100 | 100 elementów |

### English Plural Forms

English is simpler:
- `=0` - zero
- `=1` - singular
- `other` - plural

```json
{
  "itemCount": "{count, plural, =0{no items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

### Tasks/Zadania Example

**Polish (app_pl.arb):**
```json
{
  "taskCount": "{count, plural, =0{brak zadań} =1{1 zadanie} few{{count} zadania} many{{count} zadań} other{{count} zadań}}"
}
```

**English (app_en.arb):**
```json
{
  "taskCount": "{count, plural, =0{no tasks} =1{1 task} other{{count} tasks}}"
}
```

---

## Select (Gender/Variants)

Use `select` for variants based on string value:

```json
{
  "pronoun": "{gender, select, male{on} female{ona} other{ta osoba}}",
  "@pronoun": {
    "placeholders": {
      "gender": {
        "type": "String"
      }
    }
  }
}
```

**Dart usage:**
```dart
AppLocalizations.of(context)!.pronoun('male')   // "on"
AppLocalizations.of(context)!.pronoun('female') // "ona"
AppLocalizations.of(context)!.pronoun('other')  // "ta osoba"
```

### Notification Type Example

```json
{
  "notificationTitle": "{type, select, reminder{Przypomnienie} alert{Uwaga!} message{Nowa wiadomość} other{Powiadomienie}}",
  "@notificationTitle": {
    "placeholders": {
      "type": { "type": "String" }
    }
  }
}
```

---

## Date Formatting

```json
{
  "lastUpdated": "Ostatnia aktualizacja: {date}",
  "@lastUpdated": {
    "placeholders": {
      "date": {
        "type": "DateTime",
        "format": "yMd"
      }
    }
  }
}
```

### Available Date Formats

| Format | Example (2024-01-15) |
|--------|---------------------|
| `yMd` | 1/15/2024 |
| `yMMMMd` | January 15, 2024 |
| `EEEE` | Monday |
| `jm` | 3:30 PM |
| `Hm` | 15:30 |
| `yMMMEd` | Mon, Jan 15, 2024 |

**Custom format:**
```json
{
  "eventDate": "Data: {date}",
  "@eventDate": {
    "placeholders": {
      "date": {
        "type": "DateTime",
        "format": "dd.MM.yyyy",
        "isCustomDateFormat": "true"
      }
    }
  }
}
```

---

## Number Formatting

```json
{
  "price": "Cena: {value}",
  "@price": {
    "placeholders": {
      "value": {
        "type": "double",
        "format": "currency",
        "optionalParameters": {
          "symbol": "zł",
          "decimalDigits": 2
        }
      }
    }
  }
}
```

### Available Number Formats

| Format | Example (1200000) |
|--------|------------------|
| `compact` | 1.2M |
| `compactLong` | 1.2 million |
| `currency` | USD1,200,000.00 |
| `decimalPattern` | 1,200,000 |
| `percentPattern` | 120,000,000% |
| `scientificPattern` | 1E6 |

---

## Escaping Special Characters

### Apostrophes
Use two single quotes to escape:
```json
{
  "instruction": "Kliknij ''Zapisz'' aby kontynuować"
}
```
Output: `Kliknij 'Zapisz' aby kontynuować`

### Curly Braces
Use single quotes to escape:
```json
{
  "codeExample": "Użyj '{name}' jako placeholder"
}
```
Output: `Użyj {name} jako placeholder`

---

## Metadata Fields

```json
{
  "@greeting": {
    "description": "Greeting shown after login",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "Jan Kowalski"
      }
    }
  }
}
```

| Field | Purpose |
|-------|---------|
| `description` | Help for translators |
| `placeholders` | Define dynamic values |
| `type` | Data type (String, int, double, DateTime, num) |
| `format` | Formatting for dates/numbers |
| `example` | Example value for context |

---

## Common Patterns

### Error Messages

```json
{
  "error_generic": "Wystąpił błąd. Spróbuj ponownie.",
  "error_network": "Brak połączenia z internetem.",
  "error_not_found": "Nie znaleziono elementu.",
  "error_field_required": "To pole jest wymagane.",
  "error_field_min_length": "Minimum {min} znaków.",
  "@error_field_min_length": {
    "placeholders": { "min": { "type": "int" } }
  }
}
```

### Dialog Buttons

```json
{
  "dialog_confirm": "Potwierdź",
  "dialog_cancel": "Anuluj",
  "dialog_delete": "Usuń",
  "dialog_save": "Zapisz",
  "dialog_close": "Zamknij",
  "dialog_yes": "Tak",
  "dialog_no": "Nie"
}
```

### Settings

```json
{
  "settings_title": "Ustawienia",
  "settings_language": "Język",
  "settings_theme": "Motyw",
  "settings_notifications": "Powiadomienia",
  "settings_logout": "Wyloguj się",
  "settings_delete_account": "Usuń konto",

  "language_polish": "Polski",
  "language_english": "English"
}
```

### Empty States

```json
{
  "empty_items": "Brak elementów",
  "empty_items_cta": "Dodaj pierwszy element",
  "empty_search": "Nie znaleziono wyników",
  "empty_search_suggestion": "Spróbuj innych słów kluczowych"
}
```

---

## Validation Checklist

- [ ] Both ARB files have identical keys
- [ ] All placeholders are defined in @metadata
- [ ] Polish plurals use `few` and `many` forms
- [ ] Special characters are properly escaped
- [ ] No trailing commas (invalid JSON)
- [ ] `@@locale` is set correctly in each file
- [ ] Run `flutter gen-l10n` after changes
