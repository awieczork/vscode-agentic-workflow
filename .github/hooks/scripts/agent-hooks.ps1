# agent-hooks.ps1 -- consolidated hook script for VS Code Copilot Chat events:
# SessionStart, PreToolUse, PostToolUse, PreCompact.
# Brain detection via session_id in YAML frontmatter of .github/.session/*.md files.
# No temp files -- all state stored in session files.

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# --- read stdin and parse ---

$Input_ = $input | Out-String
$Parsed_ = $Input_ | ConvertFrom-Json

$Event_ = $Parsed_.event
if (-not $Event_) { $Event_ = $Parsed_.hookEventName }
$SessionId = $Parsed_.sessionId
if (-not $SessionId) { $SessionId = '' }
$Cwd = $Parsed_.cwd
if (-not $Cwd) { $Cwd = (Get-Location).Path }
$Cwd = $Cwd.TrimEnd('\', '/')

$SessionDir = Join-Path $Cwd '.github\.session'

# --- helpers ---

function Find-BrainSession {
    param([string]$Sid, [string]$Dir)
    if (-not $Sid -or -not (Test-Path $Dir)) { return $null }
    $files = Get-ChildItem -Path $Dir -Filter '*.md' -File -ErrorAction SilentlyContinue
    foreach ($f in $files) {
        $raw = Get-Content -Path $f.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $raw) { continue }
        if ($raw -match '(?s)^---\r?\n(.+?)\r?\n---') {
            $fm = $Matches[1]
            if ($fm -match '(?m)^session_id:\s*(.+)$') {
                $fid = $Matches[1].Trim()
                if ($fid -eq $Sid) { return $f }
            }
        }
    }
    return $null
}

function Get-ToolName {
    if ($Parsed_.toolName) { return $Parsed_.toolName }
    if ($Parsed_.tool_name) { return $Parsed_.tool_name }
    return ''
}

function Get-ToolInput {
    if ($Parsed_.toolInput) { return $Parsed_.toolInput }
    if ($Parsed_.tool_input) { return $Parsed_.tool_input }
    return $null
}

function Write-Block([string]$Reason) {
    $out = @{
        hookSpecificOutput = @{
            permissionDecision       = 'deny'
            permissionDecisionReason = $Reason
        }
    } | ConvertTo-Json -Depth 3 -Compress
    Write-Output $out
}

function Write-Context([string]$Text) {
    $out = @{
        hookSpecificOutput = @{
            additionalContext = $Text
        }
    } | ConvertTo-Json -Depth 3 -Compress
    Write-Output $out
}

# --- event handlers ---

function Handle-SessionStart {
    if (-not (Test-Path $SessionDir)) {
        New-Item -Path $SessionDir -ItemType Directory -Force | Out-Null
    }

    $ts = [System.DateTime]::UtcNow
    $stamp = $ts.ToString('yyyyMMdd-HHmmss')
    $fileName = "session-$stamp.md"
    $filePath = Join-Path $SessionDir $fileName

    # Avoid collision
    $n = 0
    while (Test-Path $filePath) {
        $n++
        $fileName = "session-$stamp-$n.md"
        $filePath = Join-Path $SessionDir $fileName
    }

    $created = $ts.ToString('o')
    $body = "---`nsession_id: $SessionId`ncreated: $created`nstatus: active`ncurrent_phase:`nworkflow:`ntask:`n---`n`n## Interview`n`n## Research`n`n## Plan`n`n## Diagram`n`n## Development`n`n## Testing`n`n## Review`n`n## Curation`n`n## Reflection`n"

    Set-Content -Path $filePath -Value $body -Encoding UTF8 -NoNewline

    $relPath = '.github/.session/' + $fileName
    Write-Context "Session file created at $relPath. Populate the YAML frontmatter fields (current_phase, workflow, task) and the body sections as you progress through the workflow."
}

function Handle-PreToolUse {
    $sessionFile = Find-BrainSession -Sid $SessionId -Dir $SessionDir

    # Non-brain caller -- allow everything
    if (-not $sessionFile) { return }

    $toolName = Get-ToolName

    # --- Edit guard ---
    $editTools = @(
        'editFiles', 'createFile', 'insert', 'replace', 'create',
        'edit_file', 'create_file', 'replace_string_in_file',
        'multi_replace_string_in_file', 'create_directory',
        'createDirectory', 'editNotebook', 'edit_notebook',
        'editNotebookFile', 'edit_notebook_file',
        'createJupyterNotebook', 'create_jupyter_notebook',
        'create_new_jupyter_notebook'
    )

    $isEdit = $false
    foreach ($et in $editTools) {
        if ($toolName -ieq $et) { $isEdit = $true; break }
    }

    if ($isEdit) {
        $ti = Get-ToolInput
        $paths = @()
        if ($ti) {
            if ($ti.filePath) { $paths += $ti.filePath }
            if ($ti.path) { $paths += $ti.path }
            if ($ti.replacements) {
                foreach ($r in $ti.replacements) {
                    if ($r.filePath) { $paths += $r.filePath }
                }
            }
            if ($ti.files) {
                foreach ($f in $ti.files) {
                    if ($f -is [string]) { $paths += $f }
                    elseif ($f.path) { $paths += $f.path }
                }
            }
        }
        foreach ($p in $paths) {
            $norm = $p -replace '\\', '/'
            if ($norm -notlike '*.github/.session/*') {
                Write-Block 'Brain edit guard: edits are restricted to .github/.session/ only. Delegate file edits to a subagent.'
                return
            }
        }
    }

    # --- runSubagent gate ---
    if ($toolName -ieq 'runSubagent' -or $toolName -ieq 'run_subagent') {
        $threshold = [System.DateTime]::UtcNow.AddMinutes(-5)
        if ($sessionFile.LastWriteTimeUtc -lt $threshold) {
            Write-Block 'Session file is stale (not updated in the last 5 minutes). Update the session file in .github/.session/ before spawning a subagent.'
            return
        }
    }
}

function Handle-PostToolUse {
    $sessionFile = Find-BrainSession -Sid $SessionId -Dir $SessionDir
    if (-not $sessionFile) { return }

    $toolName = Get-ToolName
    if ($toolName -ieq 'runSubagent' -or $toolName -ieq 'run_subagent') {
        Write-Context 'Subagent completed. Update the session file in .github/.session/ NOW -- record the phase outcome and current status before delegating the next subagent. The next runSubagent call will be blocked if the session file has not been updated.'
    }
}

function Handle-PreCompact {
    $sessionFile = Find-BrainSession -Sid $SessionId -Dir $SessionDir
    if (-not $sessionFile) { return }

    $relPath = $sessionFile.FullName.Substring($Cwd.Length + 1) -replace '\\', '/'
    Write-Context "Context was compacted. Read $relPath FIRST to restore your working state -- it is your sole persistent memory. After recovery, emit a progress report before taking any other action."
}

# --- dispatch ---

switch ($Event_) {
    'SessionStart' { Handle-SessionStart }
    'PreToolUse'   { Handle-PreToolUse }
    'PostToolUse'  { Handle-PostToolUse }
    'PreCompact'   { Handle-PreCompact }
}
