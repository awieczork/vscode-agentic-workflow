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
        additionalContext = 'Subagent returned. Per `<session_document>`, update the session file with the phase outcome and emit a `<progress_tracking>` report. If the plan includes a diagram, re-render it via the `plan-visualization` skill and store the updated Mermaid source in the session document''s Diagram section.'
    }
} | ConvertTo-Json -Depth 3 -Compress

Write-Output $output
