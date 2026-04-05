# Cel: Utworzenie bazy danych w Supabase i modelu danych powiązanego z aplikacją

1. Należy wykorzystać lokalne połączone instancje Supabase i MCP by wdrożyć:
   - Tabelę `autoworld_cars` z kolumnami: `id` (uuid), `user_id` (uuid), `brand` (text), `model_name` (text), `series` (text), `purchase_price` (numeric), `estimated_value` (numeric), `photo_path` (text), `created_at` (timestamptz).
   - Skonfigurować RLS (SELECT, INSERT, UPDATE, DELETE tylko dla własnych aut).
   - Utworzyć bucket w Storage `autoworld_photos` z publicznym odczytem (lub rls auth), ale wgrywaniem tylko w obrębie konta zalogowanego.
   - Włączyć odpowiednie flagi `REPLICA IDENTITY FULL` dla realtime w Supabase.
2. Utworzyć `CarModel` (Freezed) modelujący zapisaną tabelę wraz z funkcjami walidacyjnymi lub generycznymi typu `.fromJson()`.
3. Wrzucić update plików l10n jeśli jakieś błędy (ale na tym etapie raczej jeszcze brak, dodaj jednak tłumaczenia powiązane z nazwami pól w aucie jako fundament w formacie `.arb`).
4. Uruchomić `flutter analyze` i wykonać poprawny git commit.

---
# FINISH
Daj znać i zapisz pliki w repo. 
Jak skończysz poinformuj mnie bym napisał komendę:
`next`
Rozpocznie to czytanie instrukcji: `docs/commands/05_build/02_build-data-layer.md`
