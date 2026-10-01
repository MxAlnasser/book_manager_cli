#!/usr/bin/env bash
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
prompt='Read data/books.csv. Recommend two books related to design, architecture, systems thinking, or technology. Return only two lines in this exact format: title|author|reason. Do not use bullets, markdown, or extra text.'

recommendations=""
if command -v codex >/dev/null 2>&1; then
	recommendations="$(codex exec --skip-git-repo-check --ephemeral -s read-only -m gpt-6-luna -C "$ROOT_DIR" "$prompt" \
		< /dev/null 2>/dev/null \
		| awk -F'|' 'NF == 3 && $1 != "title" { print; count++; if (count == 2) exit }')"
fi

if [[ -n "$recommendations" ]]; then
	printf '%s\n' "$recommendations"
else
	echo "How Buildings Learn|Stewart Brand|interest: systems and architecture"
	echo "A Philosophy of Software Design|John Ousterhout|interest: clear software design"
fi