#!/usr/bin/env bash
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT_DIR/data/book_database.sh"

term="${1:-}"
if [[ -z "$term" ]]; then
    read -r term
fi
search_books "$term"