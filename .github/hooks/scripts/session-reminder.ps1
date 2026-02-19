# session-reminder — PostToolUse hook that reminds the brain agent to update
# the session document and re-render the Mermaid diagram after runSubagent calls.

$ErrorActionPreference = 'Stop'

# Skip guard
if ($env:SKIP_SESSION_REMINDER -eq 'true') { exit 0 }

$Input_ = $input | Out-String
$Parsed_ = $Input_ | ConvertFrom-Json

$ToolName = $Parsed_.tool_name

# Only fire on runSubagent — exit silently for everything else
if ($ToolName -ne 'runSubagent') { exit 0 }

$output = @{
    hookSpecificOutput = @{
        additionalContext = 'Subagent returned. Update the session document in .github/.session/ with the phase outcome. If the workflow includes a plan, re-render the Mermaid diagram using the plan-visualization skill.'
    }
} | ConvertTo-Json -Depth 3 -Compress

Write-Output $output
