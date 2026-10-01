#!/usr/bin/env bash
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT_DIR/data/book_database.sh"

declare -A seen
count=0
while IFS='|' read -r title author reason; do
    [[ -z "$title" || -n "${seen["$title"]+yes}" ]] && continue
    seen["$title"]=1
    if book_exists "$title"; then
        continue
    fi
    printf '%d. %s by %s (%s)\n' "$((count + 1))" "$title" "$author" "$reason"
    count=$((count + 1))
    [[ "$count" -ge 5 ]] && break
done