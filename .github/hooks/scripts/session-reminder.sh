#!/usr/bin/env bash
set -euo pipefail

# session-reminder — PostToolUse hook that reminds the brain agent to update
# the session document and re-render the Mermaid diagram after runSubagent calls.

# Skip guard
if [[ "${SKIP_SESSION_REMINDER:-}" == "true" ]]; then
  exit 0
fi

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')

# Only fire on runSubagent — exit silently for everything else
if [[ "$TOOL_NAME" != "runSubagent" ]]; then
  exit 0
fi

cat <<'EOF'
{
  "hookSpecificOutput": {
    "additionalContext": "Subagent returned. Per `<session_document>`, update the session file with the phase outcome and emit a `<progress_tracking>` report. If the plan includes a diagram, re-render it via the `plan-visualization` skill and store the updated Mermaid source in the session document's Diagram section."
  }
}
EOF
