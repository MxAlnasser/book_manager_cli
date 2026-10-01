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

book_exists() {
    local title="$1"
    awk -F'|' -v title="$title" 'tolower($1) == tolower(title) { found=1 } END { exit !found }' "$BOOKS_FILE"
}