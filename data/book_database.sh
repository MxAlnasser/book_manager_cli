#!/usr/bin/env bash
set -u

DATA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOKS_FILE="$DATA_DIR/books.csv"

add_book() {
    local book="$1"
    printf '%s\n' "$book" >> "$BOOKS_FILE"
}

list_books() {
    tail -n +2 "$BOOKS_FILE"
}

search_books() {
    local term="${1,,}"
    awk -F'|' -v term="$term" 'tolower($0) ~ term { print }' "$BOOKS_FILE"
}

library_snapshot() {
    cat "$BOOKS_FILE"
}

update_book_status() {
    local title="$1"
    local status="$2"
    update_book_field "$title" 5 "$status"
}

update_book_rating() {
    local title="$1"
    local rating="$2"
    update_book_field "$title" 6 "$rating"
}

update_book_field() {
    local title="$1"
    local field="$2"
    local value="$3"
    local temporary_file
    temporary_file="$(mktemp)"

    if ! awk -F'|' -v title="$title" -v field="$field" -v value="$value" '
        BEGIN { OFS = FS; found = 0 }
        NR == 1 { print; next }
        {
            if (tolower($1) == tolower(title)) {
                $field = value
                found = 1
            }
            print
        }
        END { if (!found) exit 1 }
    ' "$BOOKS_FILE" > "$temporary_file"; then
        rm -f "$temporary_file"
        return 1
    fi

    mv "$temporary_file" "$BOOKS_FILE"
}

book_exists() {
    local title="$1"
    awk -F'|' -v title="$title" 'tolower($1) == tolower(title) { found=1 } END { exit !found }' "$BOOKS_FILE"
}