#!/bin/bash
# Build Android AAB with all API keys injected from config/api-keys.json.
# Usage: ./scripts/build_android.sh
#
# After build, upload AAB to Google Play Console.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
KEYS_FILE="$PROJECT_DIR/config/api-keys.json"

if [ ! -f "$KEYS_FILE" ]; then
  echo "❌ Missing $KEYS_FILE"
  echo "   Copy config/api-keys.template.json → config/api-keys.json and fill in values."
  exit 1
fi

# Validate that required keys are present and non-empty
SUPABASE_URL=$(jq -r '.SUPABASE_URL // empty' "$KEYS_FILE")
SUPABASE_KEY=$(jq -r '.SUPABASE_ANON_KEY // empty' "$KEYS_FILE")

if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_KEY" ]; then
  echo "❌ SUPABASE_URL or SUPABASE_ANON_KEY is empty in $KEYS_FILE"
  exit 1
fi

echo "✅ Keys found — building AAB..."
echo "   SUPABASE_URL: $SUPABASE_URL"

cd "$PROJECT_DIR"
flutter build appbundle \
  --dart-define-from-file=config/api-keys.json \
  "$@"

echo ""
echo "✅ Build complete!"
echo "   AAB: build/app/outputs/bundle/release/app-release.aab"
