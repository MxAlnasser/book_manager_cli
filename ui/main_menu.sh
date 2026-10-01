#!/usr/bin/env bash

show_main_menu() {
    local options=("Browse Library" "Add Book" "Search Library" "Get Recommendations" "Quit")
    if command -v gum >/dev/null 2>&1; then
        gum choose "${options[@]}"
    else
        echo >&2
        echo "Book Manager" >&2
        for index in "${!options[@]}"; do
            printf '%d) %s\n' "$((index + 1))" "${options[$index]}" >&2
        done
        read -r -p "Choose 1-${#options[@]}: " choice
        printf '%s\n' "${options[$((choice - 1))]:-Quit}"
    fi
}