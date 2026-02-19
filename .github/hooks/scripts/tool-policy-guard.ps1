# tool-policy-guard — enforces brain agent file-edit restriction via VS Code hooks.
# Handles PreToolUse, SubagentStart, and SubagentStop events.
# State file tracks subagent nesting depth in the system temp directory.

$ErrorActionPreference = 'Stop'

$Input_ = $input | Out-String
$Parsed_ = $Input_ | ConvertFrom-Json
$Event_ = $Parsed_.hookEventName
$SessionId = $Parsed_.sessionId
if (-not $SessionId) { $SessionId = 'default' }

$StateFile = Join-Path ([System.IO.Path]::GetTempPath()) "vscode-hook-depth-$SessionId"

# --- helpers ---

function Read-Depth {
    if (Test-Path $StateFile) {
        $val = (Get-Content $StateFile -Raw -ErrorAction SilentlyContinue).Trim()
        if ($val -match '^\d+$') {
            return [int]$val
        }
    }
    return 0
}

function Write-Depth([int]$depth) {
    Set-Content -Path $StateFile -Value $depth -NoNewline
}

# --- event handlers ---

function Handle-SubagentStart {
    $depth = Read-Depth
    $depth++
    Write-Depth $depth
}

function Handle-SubagentStop {
    $depth = Read-Depth
    if ($depth -gt 0) { $depth-- }
    Write-Depth $depth
}

function Handle-PreToolUse {
    $depth = Read-Depth

    # Subagent context — allow everything
    if ($depth -gt 0) { return }

    $toolName = $Parsed_.tool_name

    # Only intercept edit tools
    $editTools = @('replace_string_in_file', 'multi_replace_string_in_file', 'create_file')
    if ($toolName -notin $editTools) { return }

    # Collect all file paths from tool_input
    $filePaths = @()

    if ($Parsed_.tool_input.filePath) {
        $filePaths += $Parsed_.tool_input.filePath
    }

    if ($Parsed_.tool_input.replacements) {
        foreach ($r in $Parsed_.tool_input.replacements) {
            if ($r.filePath) {
                $filePaths += $r.filePath
            }
        }
    }

    # No paths found — allow (defensive)
    if ($filePaths.Count -eq 0) { return }

    # Check each path — deny if any is outside .github/.session/
    $blocked = $false
    foreach ($p in $filePaths) {
        # Normalize separators for comparison
        $normalized = $p -replace '\\', '/'
        if ($normalized -notlike '*.github/.session/*') {
            $blocked = $true
            break
        }
    }

    if ($blocked) {
        @{
            hookSpecificOutput = @{
                permissionDecision       = 'deny'
                permissionDecisionReason = 'Brain agent can only edit files inside .github/.session/'
            }
        } | ConvertTo-Json -Depth 3
    }
}

# --- dispatch ---

switch ($Event_) {
    'SubagentStart' { Handle-SubagentStart }
    'SubagentStop'  { Handle-SubagentStop }
    'PreToolUse'    { Handle-PreToolUse }
}
