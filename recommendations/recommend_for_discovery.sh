#!/usr/bin/env bash
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
library_data="$(cat)"
prompt="Use this library snapshot to recommend two books that are intentionally outside the library patterns, giving the reader a useful new perspective. Return only two lines in this exact format: title|author|reason. Do not use bullets, markdown, or extra text.

$library_data"

recommendations=""
if command -v codex >/dev/null 2>&1; then
	recommendations="$(codex exec --skip-git-repo-check --ephemeral -s read-only -m gpt-6-luna -C "$ROOT_DIR" "$prompt" \
		< /dev/null 2>/dev/null \
		| awk -F'|' 'NF == 3 && $1 != "title" { print; count++; if (count == 2) exit }')"
fi

if [[ -n "$recommendations" ]]; then
	printf '%s\n' "$recommendations"
else
	echo "Braiding Sweetgrass|Robin Wall Kimmerer|discovery: a thoughtful nature essay"
	echo "The Left Hand of Darkness|Ursula K. Le Guin|discovery: an unfamiliar perspective"
fi