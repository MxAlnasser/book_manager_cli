#!/usr/bin/env bash
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT_DIR/data/book_database.sh"

echo
echo "Your Library"
echo "------------"
list_books | column -t -s '|' 2>/dev/null || list_books
echo