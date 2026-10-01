#!/usr/bin/env bash
set -u
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT_DIR/data/book_database.sh"
source "$ROOT_DIR/books/fetch_book_metadata.sh"

case "${1:-}" in
    add)
        read -r -p "Title: " title
        read -r -p "Author: " author
        book="$(fetch_book_metadata "$title" "$author")"
        add_book "$book"
        echo "Added: $book"
        ;;
    search)
        read -r -p "Search term: " term
        "$ROOT_DIR/books/search_books.sh" "$term"
        ;;
    *)
        echo "Usage: $0 {add|search}" >&2
        exit 1
        ;;
esac