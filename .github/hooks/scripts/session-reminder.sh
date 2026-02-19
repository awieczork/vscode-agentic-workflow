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
    "additionalContext": "Subagent returned. Update the session document in .github/.session/ with the phase outcome. If the workflow includes a plan, re-render the Mermaid diagram using the plan-visualization skill."
  }
}
EOF
