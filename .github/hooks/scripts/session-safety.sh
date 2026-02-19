#!/usr/bin/env bash
set -euo pipefail

# session-safety — PreCompact hook that ensures the brain reads its session
# file after context compaction to restore working state.

# Skip guard
if [[ "${SKIP_SESSION_SAFETY:-}" == "true" ]]; then
  exit 0
fi

INPUT=$(cat)

CWD=$(echo "$INPUT" | jq -r '.cwd')
SESSION_DIR="$CWD/.github/.session"

# Find the most recent .md file by modification time (portable — no GNU find -printf)
SESSION_FILE=$(ls -t "$SESSION_DIR"/*.md 2>/dev/null | head -1)

# Exit silently if no session file exists
if [[ -z "$SESSION_FILE" ]]; then
  exit 0
fi

# Convert to relative path from cwd
REL_PATH="${SESSION_FILE#"$CWD"/}"

# Build JSON safely via jq to handle special characters in paths
jq -n --arg path "$REL_PATH" '{
  hookSpecificOutput: {
    additionalContext: ("Context was compacted. Per `<session_document>`, read " + $path + " FIRST to restore your working state — this is your sole persistent memory. After recovery, emit a progress report per `<progress_tracking>` before taking any other action.")
  }
}'
