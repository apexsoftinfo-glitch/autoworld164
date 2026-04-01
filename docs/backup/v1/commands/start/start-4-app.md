# KROK 4: Utwórz aplikację na platformie

## 4.1 Wygeneruj bundle_id i table_prefix

Na podstawie imienia, nazwiska i nazwy aplikacji:

**Sanityzacja imienia i nazwiska:**
- Połącz WSZYSTKIE człony imienia i nazwiska (bez spacji, myślników)
- Usuń polskie znaki: ą→a, ć→c, ę→e, ł→l, ń→n, ó→o, ś→s, ź→z, ż→z
- Małe litery
- Tylko litery (usuń cyfry, myślniki, spacje)

**Sanityzacja nazwy aplikacji:**
- Małe litery
- Usuń spacje i znaki specjalne
- Usuń polskie znaki

**Przykłady:**
- "Jan Kowalski" + "Habit Tracker" → `com.jankowalski.habittracker`
- "Anna Nowak-Wiśniewska" + "Water Drop" → `com.annanowaknowakwisniewska.waterdrop`

**bundle_id:** `com.{imienazwisko}.{nazwaapki}` (identyczny dla iOS i Android, małe litery, bez znaków specjalnych)
**table_prefix:** `{nazwaapki}_`

## 4.2 Utwórz aplikację

```bash
curl -X POST {API Base URL}/user/apps \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Habit Tracker",
    "description": "Prosta aplikacja do śledzenia codziennych nawyków z przypomnieniami i statystykami tygodniowymi.",
    "bundle_id": "com.jankowalski.habittracker",
    "table_prefix": "habittracker_"
  }'
```

**WAŻNE:** `description` to krótki elevator pitch (2-3 zdania), NIE cały IDEA.md!

## 4.3 Zapisz dane z response

Response zawiera `id` aplikacji i listę `steps` z ich UUID.

Zapisz w CLAUDE.md:
- Platform App ID: {response.id}
- Mapowanie kroków na Step IDs (tabela)

---

## 4.4 Sync: in_progress

Po zapisaniu danych z response, wyślij PATCH `in_progress` dla kroku /start:

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{start_step_id}", "status": "in_progress"}]}'
```

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/start/start-5-comms.md`
