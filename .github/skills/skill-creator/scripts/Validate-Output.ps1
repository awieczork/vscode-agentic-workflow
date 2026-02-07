<#
.SYNOPSIS
    Validates skill artifact output against schema.
.PARAMETER Path
    Path to the SKILL.md file to validate
.EXAMPLE
    .\Validate-Output.ps1 -Path "SKILL.md"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path
)

# Initialize result object
$result = @{
    file = $Path
    timestamp = (Get-Date -Format "o")
    status = "pass"
    p1_issues = @()
    p2_issues = @()
    p3_issues = @()
    summary = @{
        p1_count = 0
        p2_count = 0
        p3_count = 0
    }
}

function Add-Issue {
    param(
        [string]$Priority,
        [string]$Check,
        [string]$Message
    )

    $issue = @{
        check = $Check
        message = $Message
    }

    switch ($Priority) {
        "P1" {
            $script:result.p1_issues += $issue
            $script:result.summary.p1_count++
            $script:result.status = "fail"
        }
        "P2" {
            $script:result.p2_issues += $issue
            $script:result.summary.p2_count++
        }
        "P3" {
            $script:result.p3_issues += $issue
            $script:result.summary.p3_count++
        }
    }
}

# P1: File exists
if (-not (Test-Path $Path)) {
    Add-Issue -Priority "P1" -Check "file_exists" -Message "File does not exist: $Path"
    $result | ConvertTo-Json -Depth 4
    exit 1
}

# Resolve full path for further checks
$fullPath = Resolve-Path $Path
$fileName = Split-Path $fullPath -Leaf
$parentFolder = Split-Path (Split-Path $fullPath -Parent) -Leaf

# P1: Filename is exactly "SKILL.md"
if ($fileName -ne "SKILL.md") {
    Add-Issue -Priority "P1" -Check "filename" -Message "Filename must be exactly 'SKILL.md', got: $fileName"
}

# Read file content
$content = Get-Content $fullPath -Raw
$lines = Get-Content $fullPath

# P1: File under 500 lines
if ($lines.Count -gt 500) {
    Add-Issue -Priority "P1" -Check "file_size" -Message "File exceeds 500 lines limit: $($lines.Count) lines"
}

# P1: Has YAML frontmatter
$frontmatterMatch = [regex]::Match($content, '(?s)^---\r?\n(.+?)\r?\n---')
if (-not $frontmatterMatch.Success) {
    Add-Issue -Priority "P1" -Check "frontmatter_exists" -Message "Missing YAML frontmatter (---)"
} else {
    $frontmatter = $frontmatterMatch.Groups[1].Value

    # P1: name field present and valid
    $nameMatch = [regex]::Match($frontmatter, '(?m)^name:\s*(.+?)$')
    if (-not $nameMatch.Success) {
        Add-Issue -Priority "P1" -Check "name_present" -Message "Missing 'name' field in frontmatter"
    } else {
        $nameValue = $nameMatch.Groups[1].Value.Trim()

        # Check name format: lowercase + hyphens, 1-64 chars
        if ($nameValue.Length -eq 0 -or $nameValue.Length -gt 64) {
            Add-Issue -Priority "P1" -Check "name_length" -Message "Name must be 1-64 characters, got: $($nameValue.Length)"
        }

        if ($nameValue -notmatch '^[a-z][a-z0-9-]*$') {
            Add-Issue -Priority "P1" -Check "name_format" -Message "Name must be lowercase alphanumeric with hyphens, got: $nameValue"
        }

        # P1: Name matches parent folder name
        if ($nameValue -ne $parentFolder) {
            Add-Issue -Priority "P1" -Check "name_matches_folder" -Message "Name '$nameValue' does not match parent folder '$parentFolder'"
        }
    }

    # P1: description field present and valid
    $descMatch = [regex]::Match($frontmatter, '(?m)^description:\s*(.+?)$')
    if (-not $descMatch.Success) {
        Add-Issue -Priority "P1" -Check "description_present" -Message "Missing 'description' field in frontmatter"
    } else {
        $descValue = $descMatch.Groups[1].Value.Trim()

        # Check description length: under 1024 chars
        if ($descValue.Length -gt 1024) {
            Add-Issue -Priority "P1" -Check "description_length" -Message "Description exceeds 1024 characters: $($descValue.Length)"
        }
    }
}

# P1: <workflow> section exists
if ($content -notmatch '<workflow>') {
    Add-Issue -Priority "P1" -Check "workflow_section" -Message "Missing <workflow> section"
}

# P1: Has at least one <step_N_ tag
if ($content -notmatch '<step_\d+_') {
    Add-Issue -Priority "P1" -Check "step_tags" -Message "Missing numbered step tags (<step_N_verb>)"
}

# P3: Has <defaults> section (recommended but not required)
if ($content -notmatch '<defaults>') {
    Add-Issue -Priority "P3" -Check "defaults_section" -Message "Missing <defaults> section (recommended)"
}

# P2: No "[PLACEHOLDER]" text
if ($content -match '\[PLACEHOLDER\]') {
    Add-Issue -Priority "P2" -Check "no_placeholder" -Message "Contains [PLACEHOLDER] text that should be replaced"
}

# P2: No "TODO" text
if ($content -match '\bTODO\b') {
    Add-Issue -Priority "P2" -Check "no_todo" -Message "Contains TODO text that should be addressed"
}

# P3: Has <quality_signals> section
if ($content -notmatch '<quality_signals>') {
    Add-Issue -Priority "P3" -Check "quality_signals_section" -Message "Missing <quality_signals> section (recommended)"
}

# P3: Has scripts/ folder with validation
$scriptsFolder = Join-Path (Split-Path $fullPath -Parent) "scripts"
if (-not (Test-Path $scriptsFolder)) {
    Add-Issue -Priority "P3" -Check "scripts_folder" -Message "Missing scripts/ folder (recommended for validation)"
} else {
    $validationScripts = Get-ChildItem $scriptsFolder -Filter "*.ps1" -ErrorAction SilentlyContinue
    if ($validationScripts.Count -eq 0) {
        Add-Issue -Priority "P3" -Check "validation_scripts" -Message "No validation scripts found in scripts/ folder"
    }
}

# Output JSON result
$result | ConvertTo-Json -Depth 4
