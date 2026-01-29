# VS Code Cache Cleaner Script
# Run as Administrator for best results

param(
    [switch]$DryRun,  # Preview what would be deleted
    [switch]$All      # Include workspace storage (clears all workspace data)
)

$ErrorActionPreference = "SilentlyContinue"

# Define cache locations
$cachePaths = @(
    "$env:APPDATA\Code\Cache",
    "$env:APPDATA\Code\CachedData",
    "$env:APPDATA\Code\CachedExtensions",
    "$env:APPDATA\Code\CachedExtensionVSIXs",
    "$env:APPDATA\Code\Code Cache",
    "$env:APPDATA\Code\GPUCache",
    "$env:APPDATA\Code\logs",
    "$env:APPDATA\Code\Service Worker\CacheStorage",
    "$env:APPDATA\Code\Service Worker\ScriptCache",
    "$env:APPDATA\Code\Crashpad"
)

# Optional: workspace storage (warning: clears workspace-specific settings)
$workspacePaths = @(
    "$env:APPDATA\Code\User\workspaceStorage"
)

function Get-FolderSize($path) {
    if (Test-Path $path) {
        $size = (Get-ChildItem -Path $path -Recurse -Force | Measure-Object -Property Length -Sum).Sum
        return [math]::Round($size / 1MB, 2)
    }
    return 0
}

function Clear-CacheFolder($path, $dryRun) {
    if (Test-Path $path) {
        $sizeMB = Get-FolderSize $path
        if ($dryRun) {
            Write-Host "  [DRY RUN] Would delete: $path ($sizeMB MB)" -ForegroundColor Yellow
        } else {
            try {
                Remove-Item -Path $path -Recurse -Force
                Write-Host "  [CLEARED] $path ($sizeMB MB)" -ForegroundColor Green
            } catch {
                Write-Host "  [SKIPPED] $path (in use or access denied)" -ForegroundColor Red
            }
        }
        return $sizeMB
    } else {
        Write-Host "  [NOT FOUND] $path" -ForegroundColor Gray
        return 0
    }
}

# Header
Write-Host "`n=== VS Code Cache Cleaner ===" -ForegroundColor Cyan
Write-Host "Close VS Code before running for best results.`n" -ForegroundColor Yellow

if ($DryRun) {
    Write-Host "[DRY RUN MODE - No files will be deleted]`n" -ForegroundColor Magenta
}

# Check if VS Code is running
$vsCodeProcess = Get-Process -Name "Code" -ErrorAction SilentlyContinue
if ($vsCodeProcess) {
    Write-Host "WARNING: VS Code is currently running. Some files may be locked.`n" -ForegroundColor Red
}

$totalCleared = 0

# Clear standard cache paths
Write-Host "Clearing cache folders:" -ForegroundColor White
foreach ($path in $cachePaths) {
    $totalCleared += Clear-CacheFolder $path $DryRun
}

# Clear workspace storage if -All flag is set
if ($All) {
    Write-Host "`nClearing workspace storage (workspace-specific data):" -ForegroundColor White
    foreach ($path in $workspacePaths) {
        $totalCleared += Clear-CacheFolder $path $DryRun
    }
}

# Summary
Write-Host "`n=== Summary ===" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host "Total space that would be freed: $totalCleared MB" -ForegroundColor Yellow
    Write-Host "Run without -DryRun to actually delete files." -ForegroundColor Yellow
} else {
    Write-Host "Total space freed: $totalCleared MB" -ForegroundColor Green
}

Write-Host "`nDone!`n" -ForegroundColor Cyan
