# session-safety — PreCompact hook that ensures the brain reads its session
# file after context compaction to restore working state.

$ErrorActionPreference = 'Stop'

# Skip guard
if ($env:SKIP_SESSION_SAFETY -eq 'true') { exit 0 }

$Input_ = $input | Out-String
$Parsed_ = $Input_ | ConvertFrom-Json

$Cwd = $Parsed_.cwd
$SessionDir = Join-Path $Cwd '.github' '.session'

# Find the most recent .md file by modification time
if (-not (Test-Path $SessionDir)) { exit 0 }

$SessionFile = Get-ChildItem -Path $SessionDir -Filter '*.md' -File |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

# Exit silently if no session file exists
if (-not $SessionFile) { exit 0 }

# Convert to relative path from cwd
$RelPath = $SessionFile.FullName.Substring($Cwd.Length + 1) -replace '\\', '/'

$output = @{
    hookSpecificOutput = @{
        additionalContext = 'Context was compacted. Per `<session_document>`, read ' + $RelPath + ' FIRST to restore your working state — this is your sole persistent memory. After recovery, emit a progress report per `<progress_tracking>` before taking any other action.'
    }
} | ConvertTo-Json -Depth 3 -Compress

Write-Output $output
