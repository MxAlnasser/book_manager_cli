#!/usr/bin/env bash
set -u
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
temp_dir="$(mktemp -d)"
trap 'rm -rf "$temp_dir"' EXIT

echo "Starting three recommendation agents..."
"$ROOT_DIR/recommendations/recommend_from_history.sh" > "$temp_dir/history" &
history_pid=$!
"$ROOT_DIR/recommendations/recommend_from_interests.sh" > "$temp_dir/interests" &
interests_pid=$!
"$ROOT_DIR/recommendations/recommend_for_discovery.sh" > "$temp_dir/discovery" &
discovery_pid=$!

while kill -0 "$history_pid" 2>/dev/null || kill -0 "$interests_pid" 2>/dev/null || kill -0 "$discovery_pid" 2>/dev/null; do
    printf '\rAgents are working...'
    sleep 0.2
done
wait "$history_pid" "$interests_pid" "$discovery_pid"
printf '\rAgents finished.     \n'

cat "$temp_dir/history" "$temp_dir/interests" "$temp_dir/discovery" \
    | "$ROOT_DIR/recommendations/refine_recommendations.sh" \
    | "$ROOT_DIR/ui/recommendations_screen.sh"