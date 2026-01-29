# Check Defender Exclusions
# Run as Administrator: Right-click → Run with PowerShell

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "❌ Run as Administrator to view exclusions!" -ForegroundColor Red
    pause
    exit
}

Write-Host "`n=== PATH EXCLUSIONS ===" -ForegroundColor Cyan
$paths = (Get-MpPreference).ExclusionPath
if ($paths) { $paths | ForEach-Object { Write-Host "  ✅ $_" -ForegroundColor Green } }
else { Write-Host "  ❌ None found!" -ForegroundColor Red }

Write-Host "`n=== PROCESS EXCLUSIONS ===" -ForegroundColor Cyan
$procs = (Get-MpPreference).ExclusionProcess
if ($procs) { $procs | ForEach-Object { Write-Host "  ✅ $_" -ForegroundColor Green } }
else { Write-Host "  ❌ None found!" -ForegroundColor Red }

# Expected counts
$expectedPaths = @("Microsoft VS Code", "Code", ".vscode", "E:\Projects", "miniconda3")
$expectedProcs = @("Code.exe", "node.exe", "python.exe", "git.exe")

Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Path exclusions: $($paths.Count) (expected: 5+)"
Write-Host "Process exclusions: $($procs.Count) (expected: 4+)"

pause
