#Requires -Version 5.1
<#
.SYNOPSIS
    Moves vscode_agentic_workflow workspace to the E: dev drive.

.DESCRIPTION
    This script moves the current workspace from:
    C:\Users\wiecz\Documents\E backup\Projects\vscode_agentic_workflow
    To:
    E:\workspaces\active\vscode_agentic_workflow

    Run this script AFTER closing VS Code.

.NOTES
    Author: Migration Script
    Date: 2026-01-25
#>

param(
    [switch]$DryRun,
    [switch]$SkipVerification,
    [switch]$KeepOriginal
)

$ErrorActionPreference = "Stop"

# Configuration
$SourcePath = "C:\Users\wiecz\Documents\E backup\Projects\vscode_agentic_workflow"
$TargetPath = "E:\workspaces\active\vscode_agentic_workflow"

# Colors for output
function Write-Step { param($msg) Write-Host "`n[$((Get-Date).ToString('HH:mm:ss'))] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "  [OK] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "  [WARN] $msg" -ForegroundColor Yellow }
function Write-Err { param($msg) Write-Host "  [ERR] $msg" -ForegroundColor Red }

Write-Host ""
Write-Host "=================================================================" -ForegroundColor White
Write-Host "         WORKSPACE MIGRATION TO DEV DRIVE                       " -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor White
Write-Host "  Source: $SourcePath" -ForegroundColor Gray
Write-Host "  Target: $TargetPath" -ForegroundColor Gray
Write-Host "=================================================================" -ForegroundColor White
Write-Host ""

if ($DryRun) {
    Write-Warn "DRY RUN MODE - No changes will be made"
}

# ============================================================
# STEP 1: Pre-flight checks
# ============================================================
Write-Step "Running pre-flight checks..."

# Check if VS Code is running
$vsCodeProcesses = Get-Process -Name "Code" -ErrorAction SilentlyContinue
if ($vsCodeProcesses) {
    Write-Err "VS Code is still running! Please close it before running this script."
    Write-Host "  Run: Stop-Process -Name 'Code' -Force" -ForegroundColor Gray
    exit 1
}
Write-Success "VS Code is not running"

# Check source exists
if (-not (Test-Path $SourcePath)) {
    Write-Err "Source path does not exist: $SourcePath"
    exit 1
}
Write-Success "Source path exists"

# Check E: drive exists
if (-not (Test-Path "E:\")) {
    Write-Err "E: drive is not available"
    exit 1
}
Write-Success "E: drive is available"

# Check target doesn't already exist (or is empty)
if (Test-Path $TargetPath) {
    $existingFiles = Get-ChildItem $TargetPath -Recurse -File -ErrorAction SilentlyContinue
    if ($existingFiles.Count -gt 0) {
        Write-Err "Target path already exists and contains files: $TargetPath"
        Write-Host "  Delete it first or choose a different target" -ForegroundColor Gray
        exit 1
    }
}
Write-Success "Target path is clear"

# ============================================================
# STEP 2: Calculate source size
# ============================================================
Write-Step "Calculating source size..."

$sourceFiles = Get-ChildItem $SourcePath -Recurse -File
$sourceSize = ($sourceFiles | Measure-Object -Property Length -Sum).Sum
$sourceSizeMB = [math]::Round($sourceSize / 1MB, 2)
$sourceFileCount = $sourceFiles.Count
$sourceFolderCount = (Get-ChildItem $SourcePath -Recurse -Directory).Count

Write-Success "Files: $sourceFileCount | Folders: $sourceFolderCount | Size: $sourceSizeMB MB"

# Check available space on E:
$eDrive = Get-PSDrive E
$freeSpaceMB = [math]::Round($eDrive.Free / 1MB, 2)
if ($freeSpaceMB -lt ($sourceSizeMB * 1.5)) {
    Write-Err "Not enough space on E: drive (need ~$([math]::Round($sourceSizeMB * 1.5, 0)) MB, have $freeSpaceMB MB)"
    exit 1
}
Write-Success "E: drive has sufficient space ($freeSpaceMB MB free)"

# ============================================================
# STEP 3: Create target directory structure
# ============================================================
Write-Step "Creating target directory..."

if (-not $DryRun) {
    New-Item -Path $TargetPath -ItemType Directory -Force | Out-Null
}
Write-Success "Created: $TargetPath"

# ============================================================
# STEP 4: Copy files with robocopy (faster than Copy-Item)
# ============================================================
Write-Step "Copying files with robocopy..."

if (-not $DryRun) {
    # Robocopy options:
    # /E = Copy subdirectories including empty ones
    # /COPY:DAT = Copy Data, Attributes, Timestamps
    # /R:3 = Retry 3 times on failed copies
    # /W:1 = Wait 1 second between retries
    # /MT:8 = Use 8 threads for parallel copying
    # /NP = No progress percentage (cleaner output)
    
    $robocopyResult = & robocopy $SourcePath $TargetPath /E /COPY:DAT /R:3 /W:1 /MT:8 /NP
    $robocopyExitCode = $LASTEXITCODE
    
    # Robocopy exit codes: 0-7 are success, 8+ are errors
    if ($robocopyExitCode -ge 8) {
        Write-Err "Robocopy failed with exit code $robocopyExitCode"
        Write-Host ($robocopyResult -join "`n") -ForegroundColor Gray
        exit 1
    }
}
Write-Success "Files copied successfully"

# ============================================================
# STEP 5: Verify copy
# ============================================================
if (-not $SkipVerification -and -not $DryRun) {
    Write-Step "Verifying copy..."
    
    $targetFiles = Get-ChildItem $TargetPath -Recurse -File
    $targetSize = ($targetFiles | Measure-Object -Property Length -Sum).Sum
    $targetFileCount = $targetFiles.Count
    
    if ($targetFileCount -ne $sourceFileCount) {
        Write-Err "File count mismatch! Source: $sourceFileCount, Target: $targetFileCount"
        exit 1
    }
    Write-Success "File count matches: $targetFileCount files"
    
    if ($targetSize -ne $sourceSize) {
        Write-Warn "Size mismatch (may be due to filesystem differences)"
        Write-Host "    Source: $sourceSize bytes, Target: $targetSize bytes" -ForegroundColor Gray
    } else {
        Write-Success "Size matches: $sourceSizeMB MB"
    }
}

# ============================================================
# STEP 6: Update VS Code recent workspaces (optional)
# ============================================================
Write-Step "Updating VS Code workspace references..."

$recentStoragePath = "$env:APPDATA\Code\User\globalStorage\storage.json"
if (Test-Path $recentStoragePath) {
    if (-not $DryRun) {
        $storageContent = Get-Content $recentStoragePath -Raw
        $updatedContent = $storageContent -replace [regex]::Escape($SourcePath.Replace('\', '/')), $TargetPath.Replace('\', '/')
        $updatedContent = $updatedContent -replace [regex]::Escape($SourcePath.Replace('\', '\\')), $TargetPath.Replace('\', '\\')
        
        if ($storageContent -ne $updatedContent) {
            Copy-Item $recentStoragePath "$recentStoragePath.bak" -Force
            Set-Content $recentStoragePath $updatedContent -NoNewline
            Write-Success "Updated VS Code storage.json (backup created)"
        } else {
            Write-Success "No workspace references to update"
        }
    }
} else {
    Write-Warn "VS Code storage.json not found"
}

# ============================================================
# STEP 7: Delete original (optional)
# ============================================================
if (-not $KeepOriginal -and -not $DryRun) {
    Write-Step "Removing original files..."
    
    Write-Host ""
    Write-Host "  Original location: $SourcePath" -ForegroundColor Yellow
    Write-Host ""
    $confirmation = Read-Host "  Delete original? (yes/no)"
    
    if ($confirmation -eq "yes") {
        Remove-Item $SourcePath -Recurse -Force
        Write-Success "Original deleted"
    } else {
        Write-Warn "Original kept at: $SourcePath"
    }
} elseif ($KeepOriginal) {
    Write-Warn "Original kept (--KeepOriginal specified)"
}

# ============================================================
# DONE
# ============================================================
Write-Host ""
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "                    MIGRATION COMPLETE                          " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "  New location: $TargetPath" -ForegroundColor White
Write-Host "" -ForegroundColor White
Write-Host "  Next steps:" -ForegroundColor White
Write-Host "  1. Open VS Code" -ForegroundColor Gray
Write-Host "  2. File > Open Folder > $TargetPath" -ForegroundColor Gray
Write-Host "  3. Trust the workspace when prompted" -ForegroundColor Gray
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""

# Open new location in explorer
if (-not $DryRun) {
    $openExplorer = Read-Host "Open new location in Explorer? (y/n)"
    if ($openExplorer -eq "y") {
        explorer.exe $TargetPath
    }
}
