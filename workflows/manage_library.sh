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
    update)
        read -r -p "Book title: " title
        read -r -p "Status (owned/want/reading/finished): " status
        read -r -p "Rating (0-5): " rating
        case "$status" in
            owned|want|reading|finished) ;;
            *) echo "Status must be owned, want, reading, or finished." >&2; exit 1 ;;
        esac
        if [[ ! "$rating" =~ ^[0-5]$ ]]; then
            echo "Rating must be a whole number from 0 to 5." >&2
            exit 1
        fi
        if ! update_book_status "$title" "$status" || ! update_book_rating "$title" "$rating"; then
            echo "Book not found: $title" >&2
            exit 1
        fi
        echo "Updated: $title ($status, rating $rating)"
        ;;
    search)
        read -r -p "Search term: " term
        "$ROOT_DIR/books/search_books.sh" "$term"
        ;;
    *)
        echo "Usage: $0 {add|update|search}" >&2
        exit 1
        ;;
esac