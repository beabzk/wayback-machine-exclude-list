#!/usr/bin/env bash
# ==============================================================================
# build.sh - Compile Wayback Machine exclude list
# Builds clean, deduplicated, sorted exclude-list.txt from categories/*.txt
# ==============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CATEGORIES_DIR="$REPO_ROOT/categories"
OUTPUT_FILE="$REPO_ROOT/exclude-list.txt"

if [ ! -d "$CATEGORIES_DIR" ]; then
    echo "Error: Categories directory not found at $CATEGORIES_DIR" >&2
    exit 1
fi

TEMP_FILE=$(mktemp)
trap 'rm -f "$TEMP_FILE"' EXIT

echo "Compiling categories..."
for cat_file in "$CATEGORIES_DIR"/*.txt; do
    [ -f "$cat_file" ] || continue
    cat_name="$(basename "$cat_file")"
    
    # 1. Strip comments (anything after #)
    # 2. Strip carriage returns (\r)
    # 3. Strip leading/trailing whitespace
    # 4. Strip leading http://, https://, www.
    # 5. Strip trailing slashes /
    # 6. Exclude empty lines
    count=$(sed -e 's/#.*//' -e 's/\r$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' "$cat_file" \
      | sed -E 's#^(https?://)?(www\.)?##' \
      | sed -E 's#/$##' \
      | grep -v '^[[:space:]]*$' \
      | tee -a "$TEMP_FILE" \
      | wc -l | tr -d '[:space:]')
      
    printf "  - %-30s : %d rules\n" "$cat_name" "$count"
done

# Sort alphabetically and deduplicate using standard POSIX/C collation
LC_ALL=C sort -u "$TEMP_FILE" > "$OUTPUT_FILE"

TOTAL_RULES=$(wc -l < "$OUTPUT_FILE" | tr -d '[:space:]')
echo ""
echo "Build complete: $TOTAL_RULES unique rules written to $(basename "$OUTPUT_FILE")"
