<#
.SYNOPSIS
    Validates prompt artifact output against schema.
.PARAMETER Path
    Path to the .prompt.md file to validate
.EXAMPLE
    .\Validate-Output.ps1 -Path "review.prompt.md"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path
)

# Initialize result object
$result = @{
    valid = $true
    file = $Path
    checks = @{
        p1 = @()
        p2 = @()
        p3 = @()
    }
    errors = @()
    warnings = @()
    info = @()
}

function Add-CheckResult {
    param(
        [string]$Priority,
        [string]$Check,
        [bool]$Passed,
        [string]$Message
    )

    $checkResult = @{
        check = $Check
        passed = $Passed
        message = $Message
    }

    $result.checks[$Priority] += $checkResult

    if (-not $Passed) {
        if ($Priority -eq "p1") {
            $result.errors += $Message
            $result.valid = $false
        } elseif ($Priority -eq "p2") {
            $result.warnings += $Message
        } else {
            $result.info += $Message
        }
    }
}

# ============================================================================
# P1 CHECKS (Blocking)
# ============================================================================

# P1.1: File exists
if (-not (Test-Path $Path)) {
    Add-CheckResult -Priority "p1" -Check "file_exists" -Passed $false -Message "File not found: $Path"
    # Cannot continue without file
    $result | ConvertTo-Json -Depth 10
    exit 1
}

Add-CheckResult -Priority "p1" -Check "file_exists" -Passed $true -Message "File exists"

# Read file content
$content = Get-Content -Path $Path -Raw -ErrorAction SilentlyContinue
if (-not $content) {
    Add-CheckResult -Priority "p1" -Check "file_readable" -Passed $false -Message "File is empty or unreadable"
    $result | ConvertTo-Json -Depth 10
    exit 1
}

# P1.2: Has YAML frontmatter
$frontmatterPattern = "(?s)^---\r?\n(.+?)\r?\n---"
$frontmatterMatch = [regex]::Match($content, $frontmatterPattern)

if (-not $frontmatterMatch.Success) {
    Add-CheckResult -Priority "p1" -Check "has_frontmatter" -Passed $false -Message "Missing YAML frontmatter (---)"
} else {
    Add-CheckResult -Priority "p1" -Check "has_frontmatter" -Passed $true -Message "YAML frontmatter present"
    $frontmatter = $frontmatterMatch.Groups[1].Value

    # P1.3: description field present
    $hasDescription = $frontmatter -match "(?m)^description\s*:"
    if (-not $hasDescription) {
        Add-CheckResult -Priority "p1" -Check "has_description" -Passed $false -Message "Missing required 'description' field in frontmatter"
    } else {
        # Check description is not empty
        $descriptionValue = [regex]::Match($frontmatter, "(?m)^description\s*:\s*['""]?(.+?)['""]?\s*$")
        if ($descriptionValue.Success -and $descriptionValue.Groups[1].Value.Trim().Length -gt 0) {
            Add-CheckResult -Priority "p1" -Check "has_description" -Passed $true -Message "Description field present"
        } else {
            Add-CheckResult -Priority "p1" -Check "has_description" -Passed $false -Message "Description field is empty"
        }
    }
}

# P1.4: File reasonably sized (~500 tokens ≈ 2000 chars)
$charCount = $content.Length
$maxChars = 2000
$isReasonableSize = $charCount -le $maxChars

if (-not $isReasonableSize) {
    Add-CheckResult -Priority "p1" -Check "size_limit" -Passed $false -Message "File exceeds size limit: $charCount chars (max ~$maxChars for ~500 tokens)"
} else {
    Add-CheckResult -Priority "p1" -Check "size_limit" -Passed $true -Message "File size acceptable: $charCount chars"
}

# P2.1: Description length 50-150 characters
if ($hasDescription) {
    $descMatch = [regex]::Match($frontmatter, "(?m)^description\s*:\s*['""]?(.+?)['""]?\s*$")
    if ($descMatch.Success) {
        $descLength = $descMatch.Groups[1].Value.Trim().Length
        if ($descLength -ge 50 -and $descLength -le 150) {
            Add-CheckResult -Priority "p2" -Check "description_length" -Passed $true -Message "Description length acceptable: $descLength chars"
        } else {
            Add-CheckResult -Priority "p2" -Check "description_length" -Passed $false -Message "Description length should be 50-150 chars, got $descLength"
        }

        # P2.2: Description starts with verb
        $startsWithVerb = $descMatch.Groups[1].Value.Trim() -match "^(Generate|Create|Analyze|Review|Build|Check|Convert|Deploy|Execute|Extract|Find|Format|Get|List|Parse|Process|Run|Search|Send|Test|Transform|Update|Validate|Verify)"
        if ($startsWithVerb) {
            Add-CheckResult -Priority "p2" -Check "description_starts_verb" -Passed $true -Message "Description starts with imperative verb"
        } else {
            Add-CheckResult -Priority "p2" -Check "description_starts_verb" -Passed $false -Message "Description should start with imperative verb"
        }
    }
}

# ============================================================================
# P2 CHECKS (Quality)
# ============================================================================

# Get body content (after frontmatter)
$bodyContent = $content
if ($frontmatterMatch.Success) {
    $bodyContent = $content.Substring($frontmatterMatch.Length).Trim()
}

# P2.1: Has <context> section
$hasContext = $bodyContent -match "<context>"
if (-not $hasContext) {
    Add-CheckResult -Priority "p2" -Check "has_context_section" -Passed $false -Message "Missing <context> section"
} else {
    Add-CheckResult -Priority "p2" -Check "has_context_section" -Passed $true -Message "<context> section present"
}

# P2.2: Has <task> section
$hasTask = $bodyContent -match "<task>"
if (-not $hasTask) {
    Add-CheckResult -Priority "p2" -Check "has_task_section" -Passed $false -Message "Missing <task> section"
} else {
    Add-CheckResult -Priority "p2" -Check "has_task_section" -Passed $true -Message "<task> section present"
}

# P2.3: Task appears before context (task-before-context rule)
if ($hasTask -and $hasContext) {
    $taskIndex = $bodyContent.IndexOf("<task>")
    $contextIndex = $bodyContent.IndexOf("<context>")

    if ($taskIndex -lt $contextIndex) {
        Add-CheckResult -Priority "p3" -Check "task_before_context" -Passed $true -Message "Task section appears before context (correct order)"
    } else {
        Add-CheckResult -Priority "p3" -Check "task_before_context" -Passed $false -Message "Task section should appear before context section"
    }
} elseif ($hasTask -or $hasContext) {
    Add-CheckResult -Priority "p3" -Check "task_before_context" -Passed $false -Message "Cannot verify order: missing task or context section"
}

# P2.4: No "[PLACEHOLDER]" text
$hasPlaceholder = $content -match "\[PLACEHOLDER\]"
if ($hasPlaceholder) {
    Add-CheckResult -Priority "p2" -Check "no_placeholder_text" -Passed $false -Message "Contains '[PLACEHOLDER]' text that should be replaced"
} else {
    Add-CheckResult -Priority "p2" -Check "no_placeholder_text" -Passed $true -Message "No placeholder text found"
}

# P2.5: No "TODO" text
$hasTodo = $content -match "\bTODO\b"
if ($hasTodo) {
    Add-CheckResult -Priority "p2" -Check "no_todo_text" -Passed $false -Message "Contains 'TODO' text that should be addressed"
} else {
    Add-CheckResult -Priority "p2" -Check "no_todo_text" -Passed $true -Message "No TODO text found"
}

# P2.6: Variable syntax uses ${name} not {name}
$incorrectVarSyntax = $bodyContent -match '\{[a-zA-Z_]+\}' -and $bodyContent -notmatch '\$\{[a-zA-Z_]+\}'
if ($incorrectVarSyntax) {
    Add-CheckResult -Priority "p2" -Check "variable_syntax" -Passed $false -Message "Variables should use \${name} syntax, not {name}"
} else {
    Add-CheckResult -Priority "p2" -Check "variable_syntax" -Passed $true -Message "Variable syntax correct"
}

# ============================================================================
# P3 CHECKS (Optional)
# ============================================================================

# P3.1: Has <format> section
$hasFormat = $bodyContent -match "<format>"
if (-not $hasFormat) {
    Add-CheckResult -Priority "p3" -Check "has_format_section" -Passed $false -Message "Missing <format> section (recommended)"
} else {
    Add-CheckResult -Priority "p3" -Check "has_format_section" -Passed $true -Message "Format section present"
}

# P3.2: Has variables defined if using placeholders
$usesInputVariables = $content -match '\$\{input:'
$hasVariablesInFrontmatter = $false

if ($frontmatterMatch.Success) {
    $hasVariablesInFrontmatter = $frontmatter -match "(?m)^variables\s*:"
}

if ($usesInputVariables) {
    if ($hasVariablesInFrontmatter) {
        Add-CheckResult -Priority "p3" -Check "variables_documented" -Passed $true -Message "Variables declared in frontmatter"
    } else {
        Add-CheckResult -Priority "p3" -Check "variables_documented" -Passed $false -Message 'Uses ${input:} variables but no variables field in frontmatter (recommended)'
    }
} else {
    Add-CheckResult -Priority "p3" -Check "variables_documented" -Passed $true -Message "No input variables used (no documentation needed)"
}

# ============================================================================
# OUTPUT RESULT
# ============================================================================

# Calculate summary
$p1Passed = ($result.checks.p1 | Where-Object { $_.passed }).Count
$p1Total = $result.checks.p1.Count
$p2Passed = ($result.checks.p2 | Where-Object { $_.passed }).Count
$p2Total = $result.checks.p2.Count
$p3Passed = ($result.checks.p3 | Where-Object { $_.passed }).Count
$p3Total = $result.checks.p3.Count

$result.summary = @{
    p1 = "$p1Passed/$p1Total passed"
    p2 = "$p2Passed/$p2Total passed"
    p3 = "$p3Passed/$p3Total passed"
    status = if ($result.valid) { "VALID" } else { "INVALID" }
}

# Output JSON
$result | ConvertTo-Json -Depth 10
