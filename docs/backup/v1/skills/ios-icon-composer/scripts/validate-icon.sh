#!/bin/bash
# Validate Icon Composer .icon file structure
# Usage: validate-icon.sh <path-to-icon-file>

set -e

ICON_PATH="$1"

if [ -z "$ICON_PATH" ]; then
    echo "Usage: validate-icon.sh <path-to-.icon-file>"
    echo "Example: validate-icon.sh assets/myicon.icon"
    exit 1
fi

# Check if path exists
if [ ! -e "$ICON_PATH" ]; then
    echo "ERROR: Path does not exist: $ICON_PATH"
    exit 1
fi

# Check if it's a directory (bundle)
if [ ! -d "$ICON_PATH" ]; then
    echo "ERROR: .icon file must be a directory (bundle), not a regular file"
    exit 1
fi

# Check extension
if [[ ! "$ICON_PATH" == *.icon ]]; then
    echo "WARNING: Path does not end with .icon extension"
fi

# Check for icon.json
if [ ! -f "$ICON_PATH/icon.json" ]; then
    echo "ERROR: Missing icon.json in $ICON_PATH"
    exit 1
fi

# Check for Assets folder
if [ ! -d "$ICON_PATH/Assets" ]; then
    echo "ERROR: Missing Assets/ folder in $ICON_PATH"
    exit 1
fi

# Check for PNG files in Assets
PNG_COUNT=$(find "$ICON_PATH/Assets" -name "*.png" 2>/dev/null | wc -l | tr -d ' ')
if [ "$PNG_COUNT" -eq 0 ]; then
    echo "ERROR: No PNG files found in $ICON_PATH/Assets/"
    exit 1
fi

# Validate icon.json is valid JSON
if ! python3 -c "import json; json.load(open('$ICON_PATH/icon.json'))" 2>/dev/null; then
    echo "ERROR: icon.json is not valid JSON"
    exit 1
fi

# Success
echo "✓ Valid Icon Composer file: $ICON_PATH"
echo "  - icon.json: present"
echo "  - Assets/: $PNG_COUNT PNG file(s)"

# Show layer count from icon.json
LAYER_COUNT=$(python3 -c "
import json
data = json.load(open('$ICON_PATH/icon.json'))
layers = 0
for group in data.get('groups', []):
    layers += len(group.get('layers', []))
print(layers)
" 2>/dev/null || echo "?")
echo "  - Layers: $LAYER_COUNT"

exit 0
