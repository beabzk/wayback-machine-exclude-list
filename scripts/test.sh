#!/usr/bin/env bash
# ==============================================================================
# test.sh - Contribution Pipeline Linter
# 1. Validates rule syntax in categories/*.txt (no internal spaces, no **)
# 2. Detects duplicate rules across category files
# 3. Verifies that categories compile cleanly via build.sh
# ==============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CATEGORIES_DIR="$REPO_ROOT/categories"

ERRORS=0

error() {
    echo "  [FAIL] $1" >&2
    ERRORS=$((ERRORS + 1))
}

pass() {
    echo "  [PASS] $1"
}

# ------------------------------------------------------------------------------
# 1. Lint category files (Syntax & Duplicates)
# ------------------------------------------------------------------------------
echo "--- Linting categories/*.txt ---"

SEEN_RULES=$(mktemp)
trap 'rm -f "$SEEN_RULES"' EXIT

for cat_file in "$CATEGORIES_DIR"/*.txt; do
    [ -f "$cat_file" ] || continue
    cat_name="$(basename "$cat_file")"
    line_no=0

    while IFS= read -r line || [ -n "$line" ]; do
        line_no=$((line_no + 1))
        # Strip comments
        clean="${line%%#*}"
        # Strip trailing CR (\r)
        clean="${clean%$'\r'}"
        # Trim leading whitespace
        clean="${clean#"${clean%%[![:space:]]*}"}"
        # Trim trailing whitespace
        clean="${clean%"${clean##*[![:space:]]}"}"
        [ -z "$clean" ] && continue

        # Syntax checks: no internal spaces inside rules
        if [[ "$clean" =~ [[:space:]] ]]; then
            error "$cat_name:$line_no: Rule '$clean' contains internal whitespace."
        fi

        # Syntax checks: no redundant **
        if [[ "$clean" == *\*\* ]]; then
            error "$cat_name:$line_no: Rule '$clean' contains redundant '**' wildcards."
        fi

        # Duplicate check across categories
        if grep -q "^${clean}$" "$SEEN_RULES" 2>/dev/null; then
            echo "  [WARN] Duplicate rule across files: '$clean' in $cat_name:$line_no"
        else
            echo "$clean" >> "$SEEN_RULES"
        fi
    done < "$cat_file"
done

if [ "$ERRORS" -eq 0 ]; then
    pass "All category files passed syntax checks."
fi

# ------------------------------------------------------------------------------
# 2. Verify compilation via build.sh
# ------------------------------------------------------------------------------
echo ""
echo "--- Testing compilation via build.sh ---"

if bash "$REPO_ROOT/scripts/build.sh"; then
    pass "Build script executed successfully."
else
    error "Build script failed to compile categories."
fi

# ------------------------------------------------------------------------------
# Summary
# ------------------------------------------------------------------------------
echo ""
if [ "$ERRORS" -gt 0 ]; then
    echo "==========================================" >&2
    echo "LINT FAILED with $ERRORS error(s)." >&2
    echo "==========================================" >&2
    exit 1
else
    echo "=========================================="
    echo "ALL CHECKS PASSED!"
    echo "=========================================="
    exit 0
fi
