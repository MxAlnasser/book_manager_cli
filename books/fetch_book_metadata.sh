#!/usr/bin/env bash

fetch_book_metadata() {
    local title="$1"
    local author="$2"
    local genre="General"
    local year="Unknown"

    case "${title,,}" in
        *dune*) genre="Science Fiction"; year="1965" ;;
        *design*|*architecture*) genre="Design"; year="2016" ;;
        *history*|*empire*) genre="History"; year="2019" ;;
        *python*|*programming*) genre="Technology"; year="2023" ;;
    esac
    printf '%s|%s|%s|%s|unread|0|%s' "$title" "$author" "$genre" "$year" "https://openlibrary.org/search?q=${title// /+}"
}