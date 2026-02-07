<#
.SYNOPSIS
    Validates agent artifact output against schema.
.DESCRIPTION
    Loads schema.yaml, parses input file, runs P1/P2/P3 checks,
    outputs JSON compatible with CreatorResult.validation
.PARAMETER Path
    Path to the .agent.md file to validate
.EXAMPLE
    .\Validate-Output.ps1 -Path "brain.agent.md"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path
)

# Initialize result object
$result = @{
    file = $Path
    artifact_type = "agent"
    status = "pass"
    checks_run = 0
    checks_passed = 0
    checks_failed = 0
    failures = @()
    warnings = @()
}

function Add-Failure {
    param(
        [string]$Check,
        [string]$Severity,
        [string]$Message,
        [int]$Line = 0
    )
    $script:result.failures += @{
        check = $Check
        severity = $Severity
        message = $Message
        line = $Line
    }
    $script:result.checks_failed++
    if ($Severity -eq "P1") {
        $script:result.status = "fail"
    }
}

function Add-Warning {
    param(
        [string]$Check,
        [string]$Severity,
        [string]$Message
    )
    $script:result.warnings += @{
        check = $Check
        severity = $Severity
        message = $Message
    }
}

function Add-Pass {
    $script:result.checks_passed++
}

# ============================================
# P1 CHECKS (blocking)
# ============================================

# P1: File exists
$result.checks_run++
if (-not (Test-Path $Path)) {
    Add-Failure -Check "file_exists" -Severity "P1" -Message "File does not exist: $Path"
    # Output result and exit early
    $result | ConvertTo-Json -Depth 4 -Compress
    exit 1
}
Add-Pass

# Read file content
$content = Get-Content -Path $Path -Raw -ErrorAction Stop
$lines = Get-Content -Path $Path -ErrorAction Stop

# P1: File under 500 lines
$result.checks_run++
$lineCount = $lines.Count
if ($lineCount -gt 500) {
    Add-Failure -Check "max_lines" -Severity "P1" -Message "File exceeds 500 lines (found: $lineCount)"
} else {
    Add-Pass
}

# P1: Has YAML frontmatter (--- delimited)
$result.checks_run++
$frontmatterMatch = [regex]::Match($content, '^---\r?\n([\s\S]*?)\r?\n---')
if (-not $frontmatterMatch.Success) {
    Add-Failure -Check "frontmatter_exists" -Severity "P1" -Message "Missing YAML frontmatter (--- delimited)" -Line 1
    $frontmatter = ""
    $body = $content
} else {
    Add-Pass
    $frontmatter = $frontmatterMatch.Groups[1].Value
    $body = $content.Substring($frontmatterMatch.Index + $frontmatterMatch.Length).TrimStart()
}

# Parse frontmatter as key-value pairs
$frontmatterData = @{}
if ($frontmatter) {
    foreach ($line in $frontmatter -split "`n") {
        $line = $line.Trim()
        if ($line -match '^([^:]+):\s*(.*)$') {
            $key = $Matches[1].Trim()
            $value = $Matches[2].Trim().Trim('"').Trim("'")
            $frontmatterData[$key] = $value
        }
    }
}

# P1: name field present (1-64 chars, lowercase + hyphens)
$result.checks_run++
if (-not $frontmatterData.ContainsKey('name') -or [string]::IsNullOrWhiteSpace($frontmatterData['name'])) {
    Add-Failure -Check "name_field" -Severity "P1" -Message "Missing 'name' field in frontmatter" -Line 2
} else {
    $name = $frontmatterData['name']
    if ($name.Length -lt 1 -or $name.Length -gt 64) {
        Add-Failure -Check "name_field" -Severity "P1" -Message "name field must be 1-64 chars (found: $($name.Length))" -Line 2
    } elseif ($name -notmatch '^[a-z][a-z0-9-]*$') {
        Add-Failure -Check "name_field" -Severity "P1" -Message "name field must be lowercase alphanumeric + hyphens, starting with letter (found: '$name')" -Line 2
    } else {
        Add-Pass
    }
}

# P1: description field present (single-line, keyword-rich)
$result.checks_run++
if (-not $frontmatterData.ContainsKey('description') -or [string]::IsNullOrWhiteSpace($frontmatterData['description'])) {
    Add-Failure -Check "description_field" -Severity "P1" -Message "Missing 'description' field in frontmatter" -Line 3
} else {
    $desc = $frontmatterData['description']
    if ($desc -match "`n") {
        Add-Failure -Check "description_field" -Severity "P1" -Message "description must be single-line (found newline)" -Line 3
    } else {
        Add-Pass
    }
}

# P1: Body starts with "You are..." identity
$result.checks_run++
$bodyTrimmed = $body.TrimStart()
if ($bodyTrimmed -notmatch '^You are\b') {
    # Find first significant line for line number
    $identityLineNum = 0
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^---$' -and $i -gt 0) {
            $identityLineNum = $i + 2
            break
        }
    }
    Add-Failure -Check "identity_paragraph" -Severity "P1" -Message "Body must start with 'You are...' identity paragraph" -Line $identityLineNum
} else {
    Add-Pass
}

# P1: <safety> section exists
$result.checks_run++
if ($content -notmatch '<safety>[\s\S]*?</safety>') {
    Add-Failure -Check "safety_section" -Severity "P1" -Message "Missing required <safety> section"
} else {
    Add-Pass
}

# P1: <boundaries> section exists
$result.checks_run++
if ($content -notmatch '<boundaries>[\s\S]*?</boundaries>') {
    Add-Failure -Check "boundaries_section" -Severity "P1" -Message "Missing required <boundaries> section"
} else {
    Add-Pass
}

# ============================================
# P2 CHECKS (quality)
# ============================================

# P2: <error_handling> section exists
$result.checks_run++
if ($content -notmatch '<error_handling>[\s\S]*?</error_handling>') {
    Add-Warning -Check "error_handling_section" -Severity "P2" -Message "Missing recommended <error_handling> section"
} else {
    Add-Pass
}

# P2: No "[PLACEHOLDER]" text
$result.checks_run++
$placeholderMatches = [regex]::Matches($content, '\[PLACEHOLDER\]')
if ($placeholderMatches.Count -gt 0) {
    # Find line number of first occurrence
    $lineNum = 0
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '\[PLACEHOLDER\]') {
            $lineNum = $i + 1
            break
        }
    }
    Add-Warning -Check "no_placeholder" -Severity "P2" -Message "Found $($placeholderMatches.Count) [PLACEHOLDER] text(s) that need replacement"
} else {
    Add-Pass
}

# P2: No "TODO" text
$result.checks_run++
$todoMatches = [regex]::Matches($content, '\bTODO\b')
if ($todoMatches.Count -gt 0) {
    Add-Warning -Check "no_todo" -Severity "P2" -Message "Found $($todoMatches.Count) TODO text(s) that need resolution"
} else {
    Add-Pass
}

# ============================================
# P3 CHECKS (optional)
# ============================================

# P3: Has <modes> section
$result.checks_run++
if ($content -notmatch '<modes>[\s\S]*?</modes>') {
    Add-Warning -Check "modes_section" -Severity "P3" -Message "Consider adding <modes> section for operational modes"
} else {
    Add-Pass
}

# P3: Has examples (code blocks or <example> tags)
$result.checks_run++
$hasCodeBlocks = $content -match '```[\s\S]*?```'
$hasExampleTags = $content -match '<example>[\s\S]*?</example>'
if (-not $hasCodeBlocks -and -not $hasExampleTags) {
    Add-Warning -Check "has_examples" -Severity "P3" -Message "Consider adding examples for complex behaviors"
} else {
    Add-Pass
}

# ============================================
# Output JSON result
# ============================================

# Convert to proper JSON structure with arrays
$jsonOutput = @{
    file = $result.file
    artifact_type = $result.artifact_type
    status = $result.status
    checks_run = $result.checks_run
    checks_passed = $result.checks_passed
    checks_failed = $result.checks_failed
    failures = @($result.failures)
    warnings = @($result.warnings)
}

$jsonOutput | ConvertTo-Json -Depth 4

# Exit with appropriate code
if ($result.status -eq "fail") {
    exit 1
} else {
    exit 0
}
