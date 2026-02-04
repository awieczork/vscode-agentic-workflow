<#
.SYNOPSIS
    Validates instruction artifact output against schema.
.PARAMETER Path
    Path to the .instructions.md file to validate
.EXAMPLE
    .\Validate-Output.ps1 -Path "safety.instructions.md"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path
)

# Initialize result object
$result = @{
    file = $Path
    valid = $true
    timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    checks = @{
        p1 = @()
        p2 = @()
        p3 = @()
    }
    summary = @{
        p1_passed = 0
        p1_failed = 0
        p2_passed = 0
        p2_failed = 0
        p3_passed = 0
        p3_failed = 0
    }
}

function Add-Check {
    param(
        [string]$Priority,
        [string]$Name,
        [bool]$Passed,
        [string]$Message
    )

    $check = @{
        name = $Name
        passed = $Passed
        message = $Message
    }

    $result.checks[$Priority] += $check

    if ($Passed) {
        $result.summary["${Priority}_passed"]++
    } else {
        $result.summary["${Priority}_failed"]++
        if ($Priority -eq "p1") {
            $result.valid = $false
        }
    }
}

# ============================================================================
# P1 CHECKS (Blocking)
# ============================================================================

# P1.1: File exists
if (-not (Test-Path $Path)) {
    Add-Check -Priority "p1" -Name "file_exists" -Passed $false -Message "File not found: $Path"
    # Output result and exit early - no point continuing
    $result | ConvertTo-Json -Depth 10
    exit 1
}
Add-Check -Priority "p1" -Name "file_exists" -Passed $true -Message "File exists"

# Read file content
$content = Get-Content -Path $Path -Raw
$lines = Get-Content -Path $Path
$lineCount = $lines.Count

# P1.2: Has YAML frontmatter
$hasFrontmatter = $false
$frontmatterContent = ""
$bodyContent = $content

if ($content -match "^---\s*\r?\n([\s\S]*?)\r?\n---") {
    $hasFrontmatter = $true
    $frontmatterContent = $Matches[1]
    $bodyContent = $content -replace "^---\s*\r?\n[\s\S]*?\r?\n---\s*\r?\n", ""
}

if ($hasFrontmatter) {
    Add-Check -Priority "p1" -Name "has_frontmatter" -Passed $true -Message "YAML frontmatter present"
} else {
    Add-Check -Priority "p1" -Name "has_frontmatter" -Passed $false -Message "Missing YAML frontmatter (must start with ---)"
}

# P1.3: applyTo field present
$hasApplyTo = $false
if ($hasFrontmatter -and $frontmatterContent -match "applyTo\s*:\s*[`"']?([^`"'\r\n]+)[`"']?") {
    $applyToValue = $Matches[1].Trim()
    if ($applyToValue.Length -gt 0) {
        $hasApplyTo = $true
        Add-Check -Priority "p1" -Name "applyTo_present" -Passed $true -Message "applyTo field present: $applyToValue"
    }
}
if (-not $hasApplyTo) {
    Add-Check -Priority "p1" -Name "applyTo_present" -Passed $false -Message "Missing or empty applyTo field in frontmatter"
}

# P1.4: description field present
$hasDescription = $false
if ($hasFrontmatter -and $frontmatterContent -match "description\s*:\s*[`"']?([^`"'\r\n]+)[`"']?") {
    $descriptionValue = $Matches[1].Trim()
    if ($descriptionValue.Length -gt 0) {
        $hasDescription = $true
        Add-Check -Priority "p1" -Name "description_present" -Passed $true -Message "description field present"
    }
}
if (-not $hasDescription) {
    Add-Check -Priority "p1" -Name "description_present" -Passed $false -Message "Missing or empty description field in frontmatter"
}

# P1.5: File under 200 lines
# Note: Specific instructions have 150 limit, global has 200 limit
# Using 200 as the maximum since that's what was requested
$maxLines = 200
if ($lineCount -le $maxLines) {
    Add-Check -Priority "p1" -Name "size_limit" -Passed $true -Message "File is $lineCount lines (limit: $maxLines)"
} else {
    Add-Check -Priority "p1" -Name "size_limit" -Passed $false -Message "File exceeds size limit: $lineCount lines (max: $maxLines)"
}

# P1.6: No <modes> tag (agents only)
if ($content -match "<modes>|</modes>") {
    Add-Check -Priority "p1" -Name "no_modes_tag" -Passed $false -Message "Found <modes> tag - this is an agent-only pattern"
} else {
    Add-Check -Priority "p1" -Name "no_modes_tag" -Passed $true -Message "No <modes> tag found"
}

# P1.7: No ${input:} variables (prompts only)
if ($content -match '\$\{input:') {
    Add-Check -Priority "p1" -Name "no_input_variables" -Passed $false -Message 'Found ${input:} variable - this is a prompt-only pattern'
} else {
    Add-Check -Priority "p1" -Name "no_input_variables" -Passed $true -Message 'No ${input:} variables found'
}

# ============================================================================
# P2 CHECKS (Quality)
# ============================================================================

# P2.1: Has at least one XML-tagged section
# Look for opening and closing XML tags (not self-closing, not HTML-like)
$xmlTagPattern = "<([a-z][a-z0-9_]*)>[\s\S]*?</\1>"
if ($bodyContent -match $xmlTagPattern) {
    Add-Check -Priority "p2" -Name "has_xml_sections" -Passed $true -Message "Contains XML-tagged sections"
} else {
    Add-Check -Priority "p2" -Name "has_xml_sections" -Passed $false -Message "No XML-tagged sections found - instructions should use XML tags for structure"
}

# P2.2: No "[PLACEHOLDER]" text
if ($content -match "\[PLACEHOLDER\]") {
    Add-Check -Priority "p2" -Name "no_placeholder" -Passed $false -Message "Found [PLACEHOLDER] text - must be replaced with actual content"
} else {
    Add-Check -Priority "p2" -Name "no_placeholder" -Passed $true -Message "No [PLACEHOLDER] text found"
}

# P2.3: No "TODO" text
if ($content -match "\bTODO\b") {
    Add-Check -Priority "p2" -Name "no_todo" -Passed $false -Message "Found TODO text - must be completed before delivery"
} else {
    Add-Check -Priority "p2" -Name "no_todo" -Passed $true -Message "No TODO text found"
}

# ============================================================================
# P3 CHECKS (Optional)
# ============================================================================

# P3.1: Has cross-references to other files
# Look for markdown links or explicit cross-reference sections
$hasCrossRefs = $false
if ($content -match "\[.*?\]\(.*?\.md\)") {
    $hasCrossRefs = $true
}
if ($content -match "cross.?reference|see also|related" -and $content -match "\.md") {
    $hasCrossRefs = $true
}

if ($hasCrossRefs) {
    Add-Check -Priority "p3" -Name "has_cross_references" -Passed $true -Message "Cross-references to other files found"
} else {
    Add-Check -Priority "p3" -Name "has_cross_references" -Passed $false -Message "No cross-references to other files - consider adding links to related instructions"
}

# ============================================================================
# OUTPUT
# ============================================================================

# Set overall status message
if ($result.valid) {
    if ($result.summary.p2_failed -gt 0) {
        $result.status = "VALID_WITH_WARNINGS"
        $result.message = "File passes P1 checks but has P2 quality issues"
    } else {
        $result.status = "VALID"
        $result.message = "All P1 and P2 checks passed"
    }
} else {
    $result.status = "INVALID"
    $result.message = "File failed P1 blocking checks"
}

# Output JSON result
$result | ConvertTo-Json -Depth 10
