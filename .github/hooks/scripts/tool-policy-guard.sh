#!/usr/bin/env bash
set -euo pipefail

# tool-policy-guard — enforces brain agent file-edit restriction via VS Code hooks.
# Handles PreToolUse, SubagentStart, and SubagentStop events.
# State file tracks subagent nesting depth in the system temp directory.

INPUT=$(cat)

EVENT=$(echo "$INPUT" | jq -r '.hookEventName')
SESSION_ID=$(echo "$INPUT" | jq -r '.sessionId // "default"')

# State file in system temp — avoids polluting the workspace
STATE_DIR="${TMPDIR:-/tmp}"
STATE_FILE="${STATE_DIR}/vscode-hook-depth-${SESSION_ID}"

# --- helpers ---

read_depth() {
  if [[ -f "$STATE_FILE" ]]; then
    local val
    val=$(cat "$STATE_FILE" 2>/dev/null || echo "0")
    # Validate numeric
    if [[ "$val" =~ ^[0-9]+$ ]]; then
      echo "$val"
    else
      echo "0"
    fi
  else
    echo "0"
  fi
}

write_depth() {
  echo "$1" > "$STATE_FILE"
}

# --- event handlers ---

handle_subagent_start() {
  local depth
  depth=$(read_depth)
  depth=$((depth + 1))
  write_depth "$depth"
}

handle_subagent_stop() {
  local depth
  depth=$(read_depth)
  if [[ "$depth" -gt 0 ]]; then
    depth=$((depth - 1))
  fi
  write_depth "$depth"
}

handle_pre_tool_use() {
  local depth
  depth=$(read_depth)

  # Subagent context — allow everything
  if [[ "$depth" -gt 0 ]]; then
    exit 0
  fi

  # Brain context — check tool name
  local tool_name
  tool_name=$(echo "$INPUT" | jq -r '.tool_name')

  case "$tool_name" in
    replace_string_in_file|multi_replace_string_in_file|create_file)
      ;;
    *)
      # Not an edit tool — allow
      exit 0
      ;;
  esac

  # Extract the target file path from tool_input
  local file_path
  file_path=$(echo "$INPUT" | jq -r '.tool_input.filePath // empty')

  if [[ -z "$file_path" ]]; then
    # No filePath found (e.g. multi_replace uses nested structure) — deny to be safe
    # Check if any replacement targets a file outside .github/.session/
    local all_paths
    all_paths=$(echo "$INPUT" | jq -r '
      .tool_input.filePath // empty,
      (.tool_input.replacements // [] | .[].filePath // empty)
    ')

    if [[ -z "$all_paths" ]]; then
      # Cannot determine target — allow (defensive)
      exit 0
    fi

    local blocked="false"
    while IFS= read -r p; do
      [[ -z "$p" ]] && continue
      if [[ "$p" != *".github/.session/"* ]]; then
        blocked="true"
        break
      fi
    done <<< "$all_paths"

    if [[ "$blocked" == "true" ]]; then
      cat <<'EOF'
{
  "hookSpecificOutput": {
    "permissionDecision": "deny",
    "permissionDecisionReason": "Denied by `<tool_policies>` `#tool:edit` — edits are restricted to files inside .github/.session/."
  }
}
EOF
      exit 0
    fi

    exit 0
  fi

  # Single filePath — check if inside .github/.session/
  if [[ "$file_path" == *".github/.session/"* ]]; then
    exit 0
  fi

  # Deny — file is outside allowed path
  cat <<'EOF'
{
  "hookSpecificOutput": {
    "permissionDecision": "deny",
    "permissionDecisionReason": "Denied by `<tool_policies>` `#tool:edit` — edits are restricted to files inside .github/.session/."
  }
}
EOF
  exit 0
}

# --- dispatch ---

case "$EVENT" in
  SubagentStart)
    handle_subagent_start
    ;;
  SubagentStop)
    handle_subagent_stop
    ;;
  PreToolUse)
    handle_pre_tool_use
    ;;
  *)
    # Unknown event — pass through
    ;;
esac
