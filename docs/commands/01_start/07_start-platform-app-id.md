# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Dodać aplikację do platformy `12 Apps Challenge`

# Task

W pliku `.env` powinien być X-API-Key do Platformy. 
Dodaj następujące dane o aplikacji do jego konta:

curl -s -X POST https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user/apps \
  -H "X-API-Key: __PLATFORM_API_KEY__" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "__APP_DISPLAY_NAME__",
    "description": "__APP_DESCRIPTION__",
    "idea_md": "**zawartość pliku IDEA.md**",
    "bundle_id": "__APP_BUNDLE_ID__",
    "table_prefix": "__SUPABASE_TABLE_PREFIX__"
  }'

Jeżeli request zakończy się sukcesem i endpoint zwróci response w stylu `{ "id": "..." }`, zapisz ten identyfikator do `.env` jako `APP_PLATFORM_ID=...`.

Do platformy nadal wysyłasz `idea_md` jako zawartość `IDEA.md`.

# Finish

Gdy odpowie "next", przejdź do wykonania polecenia zawartego w `docs/commands/01_start/08_start-summary.md`.
