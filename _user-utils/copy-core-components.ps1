<#
.SYNOPSIS
    Copies core components from _EXEMPLAR to generated project folder.

.DESCRIPTION
    Part of WORKFLOW-GUIDE Step 4 (GENERATE). Copies portable core agents,
    instructions, skills, and memory-bank templates to generated output.

    Called by @master-generator before subagent spawning.

.PARAMETER ProjectName
    Name of the project folder under generated/ (required)

.PARAMETER SourcePath
    Source folder with portable components (default: GENERATION-RULES/_EXEMPLAR)

.PARAMETER TargetPath
    Target folder for copied components (default: generated/{ProjectName}/.github)

.EXAMPLE
    ./copy-core-components.ps1 -ProjectName "my-api-project"

.EXAMPLE
    ./copy-core-components.ps1 -ProjectName "test" -SourcePath "C:\custom\_EXEMPLAR"

.OUTPUTS
    PSCustomObject with copied files list for manifest integration
#>

param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ProjectName,

    [string]$SourcePath = "",

    [string]$TargetPath = ""
)

# Resolve workspace root (script location's parent's parent)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$WorkspaceRoot = Split-Path -Parent $ScriptDir

# Set defaults if not provided
if ([string]::IsNullOrEmpty($SourcePath)) {
    $SourcePath = Join-Path $WorkspaceRoot "GENERATION-RULES\_EXEMPLAR"
}
elseif (-not [System.IO.Path]::IsPathRooted($SourcePath)) {
    $SourcePath = Join-Path $WorkspaceRoot $SourcePath
}

if ([string]::IsNullOrEmpty($TargetPath)) {
    $TargetPath = Join-Path $WorkspaceRoot "generated\$ProjectName\.github"
}
elseif (-not [System.IO.Path]::IsPathRooted($TargetPath)) {
    $TargetPath = Join-Path $WorkspaceRoot $TargetPath
}

# Validate source exists
if (-not (Test-Path $SourcePath)) {
    throw "Source folder not found: $SourcePath"
}

Write-Host "Copy Core Components" -ForegroundColor Cyan
Write-Host "  Source: $SourcePath" -ForegroundColor Gray
Write-Host "  Target: $TargetPath" -ForegroundColor Gray
Write-Host ""

# Component folders to copy
$ComponentFolders = @("agents", "instructions", "skills", "memory-bank")

# Files to skip (reference files, not components)
$SkipFiles = @("decision-matrix-exemplar.md")

# Track copied files
$CopiedFiles = @()

# Create target root if not exists
if (-not (Test-Path $TargetPath)) {
    New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
    Write-Host "  Created: $TargetPath" -ForegroundColor Green
}

# Copy each component folder
foreach ($Folder in $ComponentFolders) {
    $SourceFolder = Join-Path $SourcePath $Folder
    $TargetFolder = Join-Path $TargetPath $Folder

    if (-not (Test-Path $SourceFolder)) {
        Write-Host "  Skip: $Folder (not found in source)" -ForegroundColor Yellow
        continue
    }

    # Create target folder if not exists
    if (-not (Test-Path $TargetFolder)) {
        New-Item -ItemType Directory -Path $TargetFolder -Force | Out-Null
    }

    # Get all files recursively
    $Files = Get-ChildItem -Path $SourceFolder -File -Recurse

    foreach ($File in $Files) {
        # Skip excluded files
        if ($SkipFiles -contains $File.Name) {
            Write-Host "  Skip: $($File.Name) (excluded)" -ForegroundColor Yellow
            continue
        }

        # Calculate relative path within the folder
        $RelativePath = $File.FullName.Substring($SourceFolder.Length + 1)
        $TargetFile = Join-Path $TargetFolder $RelativePath

        # Create subdirectory if needed
        $TargetFileDir = Split-Path -Parent $TargetFile
        if (-not (Test-Path $TargetFileDir)) {
            New-Item -ItemType Directory -Path $TargetFileDir -Force | Out-Null
        }

        try {
            Copy-Item -Path $File.FullName -Destination $TargetFile -Force
            $CopiedRelative = ".github/$Folder/$RelativePath" -replace '\\', '/'
            $CopiedFiles += $CopiedRelative
            Write-Host "  Copied: $CopiedRelative" -ForegroundColor Green
        }
        catch {
            Write-Host "  FAILED: $($File.Name) - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "Complete: $($CopiedFiles.Count) files copied" -ForegroundColor Cyan

# Return result object for manifest integration
$Result = [PSCustomObject]@{
    copied = $CopiedFiles
    source = $SourcePath
    target = $TargetPath
    project = $ProjectName
}

# Output as JSON for easy parsing
$Result | ConvertTo-Json -Depth 3
