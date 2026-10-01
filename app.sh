#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$ROOT_DIR/ui/main_menu.sh"

while true; do
    choice="$(show_main_menu)"
    case "$choice" in
        "Browse Library") "$ROOT_DIR/ui/library_screen.sh" ;;
        "Add Book") "$ROOT_DIR/workflows/manage_library.sh" add ;;
        "Update Book") "$ROOT_DIR/workflows/manage_library.sh" update ;;
        "Search Library") "$ROOT_DIR/workflows/manage_library.sh" search ;;
        "Get Recommendations") "$ROOT_DIR/workflows/get_recommendations.sh" ;;
        "Quit"|"") echo "Goodbye."; break ;;
        *) echo "Unknown choice: $choice" ;;
    esac
done