# # ============================================================================
# # MINICONDA CLEAN REINSTALL SCRIPT
# # ============================================================================
# # Run this script in PowerShell as Administrator
# # Execute each section manually, one at a time
# # ============================================================================

# # ============================================================================
# # SECTION 1: CLOSE ALL PYTHON/CONDA PROCESSES
# # ============================================================================

# Write-Host "=== SECTION 1: Closing Python/Conda processes ===" -ForegroundColor Cyan

# # Kill any running Python or Conda processes
# Get-Process -Name python, pythonw, conda -ErrorAction SilentlyContinue | Stop-Process -Force
# Get-Process -Name "Miniconda*", "Anaconda*" -ErrorAction SilentlyContinue | Stop-Process -Force

# Write-Host "[OK] Processes terminated" -ForegroundColor Green

# # ============================================================================
# # SECTION 2: RUN OFFICIAL UNINSTALLER (if exists)
# # ============================================================================

# Write-Host "`n=== SECTION 2: Running official uninstaller ===" -ForegroundColor Cyan

# $Uninstallers = @(
#     "C:\miniconda3\Uninstall-Miniconda3.exe",
#     "C:\ProgramData\miniconda3\Uninstall-Miniconda3.exe",
#     "$env:USERPROFILE\miniconda3\Uninstall-Miniconda3.exe",
#     "$env:LOCALAPPDATA\miniconda3\Uninstall-Miniconda3.exe"
# )

# foreach ($uninstaller in $Uninstallers) {
#     if (Test-Path $uninstaller) {
#         Write-Host "Running uninstaller: $uninstaller" -ForegroundColor Yellow
#         Start-Process -FilePath $uninstaller -ArgumentList "/S" -Wait
#         Write-Host "[OK] Uninstaller completed" -ForegroundColor Green
#     }
# }

# # ============================================================================
# # SECTION 3: REMOVE ALL MINICONDA/ANACONDA FOLDERS
# # ============================================================================

# Write-Host "`n=== SECTION 3: Removing installation folders ===" -ForegroundColor Cyan

# $FoldersToRemove = @(
#     # Common installation locations
#     "C:\miniconda3",
#     "C:\Miniconda3",
#     "C:\miniconda",
#     "C:\Miniconda",
#     "C:\anaconda3",
#     "C:\Anaconda3",
#     "C:\ProgramData\miniconda3",
#     "C:\ProgramData\Miniconda3",
#     "C:\ProgramData\anaconda3",
#     "$env:USERPROFILE\miniconda3",
#     "$env:USERPROFILE\Miniconda3",
#     "$env:USERPROFILE\anaconda3",
#     "$env:USERPROFILE\Anaconda3",
#     "$env:LOCALAPPDATA\miniconda3",
#     "$env:LOCALAPPDATA\Miniconda3",
#     "$env:LOCALAPPDATA\anaconda3",
#     # Config and cache folders
#     "$env:USERPROFILE\.conda",
#     "$env:USERPROFILE\.condarc",
#     "$env:USERPROFILE\.continuum",
#     "$env:USERPROFILE\.anaconda",
#     "$env:USERPROFILE\.jupyter",
#     "$env:USERPROFILE\.ipython",
#     "$env:USERPROFILE\.matplotlib",
#     # Pip cache locations
#     "$env:LOCALAPPDATA\pip",
#     "$env:APPDATA\pip",
#     "$env:USERPROFILE\pip",
#     # Package cache locations
#     "$env:LOCALAPPDATA\conda",
#     "$env:APPDATA\conda",
#     # Temp folders
#     "$env:TEMP\conda-*",
#     "$env:TEMP\pip-*"
# )

# foreach ($folder in $FoldersToRemove) {
#     if (Test-Path $folder) {
#         Write-Host "Removing: $folder" -ForegroundColor Yellow
#         Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
#         if (-not (Test-Path $folder)) {
#             Write-Host "  [OK] Removed" -ForegroundColor Green
#         }
#         else {
#             Write-Host "  [WARN] Could not fully remove (may need manual deletion)" -ForegroundColor Red
#         }
#     }
#     else {
#         Write-Host "Not found: $folder" -ForegroundColor DarkGray
#     }
# }

# # ============================================================================
# # SECTION 4: CLEAN REGISTRY ENTRIES
# # ============================================================================

# Write-Host "`n=== SECTION 4: Cleaning registry entries ===" -ForegroundColor Cyan

# # Registry paths to check and clean
# $RegistryPaths = @(
#     # Current User uninstall entries
#     "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Miniconda3*",
#     "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Anaconda3*",
#     # Local Machine uninstall entries (requires Admin)
#     "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Miniconda3*",
#     "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Anaconda3*",
#     "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Miniconda3*",
#     "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Anaconda3*",
#     # Python-related entries
#     "HKCU:\Software\Python\ContinuumAnalytics",
#     "HKCU:\Software\Python\PythonCore",
#     "HKLM:\Software\Python\ContinuumAnalytics",
#     "HKLM:\Software\Python\PythonCore",
#     # Conda-specific
#     "HKCU:\Software\Continuum",
#     "HKCU:\Software\Anaconda",
#     "HKLM:\Software\Continuum",
#     "HKLM:\Software\Anaconda"
# )

# foreach ($regPath in $RegistryPaths) {
#     $items = Get-Item -Path $regPath -ErrorAction SilentlyContinue
#     if ($items) {
#         foreach ($item in $items) {
#             Write-Host "Removing registry: $($item.PSPath)" -ForegroundColor Yellow
#             Remove-Item -Path $item.PSPath -Recurse -Force -ErrorAction SilentlyContinue
#             Write-Host "  [OK] Removed" -ForegroundColor Green
#         }
#     }
# }

# # ============================================================================
# # SECTION 5: CLEAN ENVIRONMENT VARIABLES
# # ============================================================================

# Write-Host "`n=== SECTION 5: Cleaning environment variables ===" -ForegroundColor Cyan

# # Remove conda/python related environment variables
# $EnvVarsToRemove = @(
#     "CONDA_DEFAULT_ENV",
#     "CONDA_PREFIX",
#     "CONDA_PROMPT_MODIFIER",
#     "CONDA_SHLVL",
#     "CONDA_EXE",
#     "CONDA_PYTHON_EXE",
#     "_CE_CONDA",
#     "_CE_M"
# )

# foreach ($var in $EnvVarsToRemove) {
#     [System.Environment]::SetEnvironmentVariable($var, $null, "User")
#     [System.Environment]::SetEnvironmentVariable($var, $null, "Machine")
#     Write-Host "Cleared: $var" -ForegroundColor Green
# }

# # Clean PATH - Remove miniconda/anaconda entries
# Write-Host "`nCleaning PATH variable..." -ForegroundColor Yellow

# # User PATH
# $UserPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
# if ($UserPath) {
#     $CleanUserPath = ($UserPath -split ";" | Where-Object { $_ -notmatch "miniconda|anaconda|conda" -and $_ -ne "" }) -join ";"
#     [System.Environment]::SetEnvironmentVariable("Path", $CleanUserPath, "User")
#     Write-Host "[OK] User PATH cleaned" -ForegroundColor Green
# }

# # System PATH (requires Admin)
# $MachinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
# if ($MachinePath) {
#     $CleanMachinePath = ($MachinePath -split ";" | Where-Object { $_ -notmatch "miniconda|anaconda|conda" -and $_ -ne "" }) -join ";"
#     [System.Environment]::SetEnvironmentVariable("Path", $CleanMachinePath, "Machine")
#     Write-Host "[OK] System PATH cleaned" -ForegroundColor Green
# }

# # ============================================================================
# # SECTION 6: CLEAN SHELL PROFILES (PowerShell, CMD)
# # ============================================================================

# Write-Host "`n=== SECTION 6: Cleaning shell profiles ===" -ForegroundColor Cyan

# # PowerShell profile
# $PSProfile = $PROFILE.CurrentUserAllHosts
# if (Test-Path $PSProfile) {
#     $content = Get-Content $PSProfile -Raw
#     if ($content -match "conda") {
#         Write-Host "Found conda init in PowerShell profile: $PSProfile" -ForegroundColor Yellow
#         Write-Host "Creating backup and cleaning..." -ForegroundColor Yellow
#         Copy-Item $PSProfile "$PSProfile.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
#         # Remove conda init block
#         $cleanContent = $content -replace '(?s)#region conda initialize.*?#endregion', ''
#         $cleanContent = $cleanContent -replace '(?s)\(\& ".*?conda\.exe".*?\)', ''
#         Set-Content -Path $PSProfile -Value $cleanContent.Trim()
#         Write-Host "  [OK] PowerShell profile cleaned (backup created)" -ForegroundColor Green
#     }
# }

# # Check Windows Terminal settings (just notify, don't modify)
# $WTSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
# if (Test-Path $WTSettings) {
#     Write-Host "Note: Check Windows Terminal settings for conda profiles: $WTSettings" -ForegroundColor Yellow
# }

# # ============================================================================
# # SECTION 7: VERIFY CLEAN STATE
# # ============================================================================

# Write-Host "`n=== SECTION 7: Verifying clean state ===" -ForegroundColor Cyan

# $remainingIssues = @()

# # Check for remaining folders
# $CheckFolders = @("C:\miniconda3", "C:\anaconda3", "$env:USERPROFILE\miniconda3", "$env:USERPROFILE\.conda")
# foreach ($folder in $CheckFolders) {
#     if (Test-Path $folder) {
#         $remainingIssues += "Folder still exists: $folder"
#     }
# }

# # Check PATH
# $CurrentPath = $env:Path
# if ($CurrentPath -match "miniconda|anaconda|conda") {
#     $remainingIssues += "PATH still contains conda entries (restart shell to refresh)"
# }

# # Check commands
# $condaCmd = Get-Command conda -ErrorAction SilentlyContinue
# if ($condaCmd) {
#     $remainingIssues += "conda command still found: $($condaCmd.Source)"
# }

# if ($remainingIssues.Count -eq 0) {
#     Write-Host "[OK] System is clean! Ready for fresh install." -ForegroundColor Green
# }
# else {
#     Write-Host "[WARN] Remaining issues found:" -ForegroundColor Red
#     $remainingIssues | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
#     Write-Host "`nRestart PowerShell and run verification again." -ForegroundColor Yellow
# }

# Write-Host "`n============================================================================" -ForegroundColor Cyan
# Write-Host "UNINSTALL COMPLETE - RESTART POWERSHELL BEFORE PROCEEDING TO INSTALL" -ForegroundColor Cyan
# Write-Host "============================================================================" -ForegroundColor Cyan
# Write-Host "`nAfter restart, run Section 8 by uncommenting it in the script." -ForegroundColor Yellow

# ============================================================================
# ============================================================================
# SECTION 8: FRESH INSTALL (RUN AFTER RESTARTING POWERSHELL)
# ============================================================================
# ============================================================================
# INSTRUCTIONS: Uncomment the block below (remove <# and #>) after restart

Write-Host "`n=== SECTION 8: Fresh Miniconda Installation ===" -ForegroundColor Cyan

# Create directories on Dev Drive
Write-Host "Creating Dev Drive directory structure..." -ForegroundColor Yellow
New-Item -Path "E:\Projects" -ItemType Directory -Force | Out-Null
New-Item -Path "E:\packages\pip" -ItemType Directory -Force | Out-Null
New-Item -Path "E:\packages\conda\pkgs" -ItemType Directory -Force | Out-Null
New-Item -Path "E:\packages\conda\envs" -ItemType Directory -Force | Out-Null
Write-Host "[OK] Directories created" -ForegroundColor Green

# Download Miniconda
Write-Host "Downloading Miniconda installer..." -ForegroundColor Yellow
$InstallerPath = "$env:TEMP\Miniconda3-latest-Windows-x86_64.exe"
Invoke-WebRequest -Uri "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe" -OutFile $InstallerPath
Write-Host "[OK] Download complete" -ForegroundColor Green

# Install Miniconda to C:\miniconda3 (applications should stay on NTFS, not Dev Drive)
Write-Host "Installing Miniconda to C:\miniconda3..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor DarkGray
Write-Host "(Note: Base install on C:, caches/envs will be on Dev Drive E:)" -ForegroundColor DarkGray

Start-Process -FilePath $InstallerPath -ArgumentList "/S", "/D=C:\miniconda3" -Wait
Write-Host "[OK] Installation complete" -ForegroundColor Green

# Configure environment variable for pip cache
Write-Host "Setting environment variables..." -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable("PIP_CACHE_DIR", "E:\packages\pip", "User")
Write-Host "[OK] PIP_CACHE_DIR set to E:\packages\pip" -ForegroundColor Green

# Create .condarc configuration
Write-Host "Creating conda configuration..." -ForegroundColor Yellow
$condarcContent = @"
pkgs_dirs:
  - E:\packages\conda\pkgs
envs_dirs:
  - E:\packages\conda\envs
auto_activate_base: false
channel_priority: flexible
"@
$condarcContent | Out-File -FilePath "$env:USERPROFILE\.condarc" -Encoding utf8
Write-Host "[OK] .condarc created" -ForegroundColor Green

# Initialize conda for PowerShell
Write-Host "Initializing conda for PowerShell..." -ForegroundColor Yellow
& "C:\miniconda3\Scripts\conda.exe" init powershell
Write-Host "[OK] Conda initialized" -ForegroundColor Green

# Clean up installer
Remove-Item $InstallerPath -Force -ErrorAction SilentlyContinue

Write-Host "`n============================================================================" -ForegroundColor Cyan
Write-Host "INSTALLATION COMPLETE!" -ForegroundColor Green
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. RESTART PowerShell" -ForegroundColor White
Write-Host "2. Run: conda --version" -ForegroundColor White
Write-Host "3. Run: conda info" -ForegroundColor White
Write-Host "4. Run: pip cache dir" -ForegroundColor White


# ============================================================================
# SECTION 9: POST-INSTALL VERIFICATION (RUN AFTER SECOND RESTART)
# ============================================================================
# INSTRUCTIONS: Uncomment the block below (remove <# and #>) to verify

<#

Write-Host "`n=== SECTION 9: Post-Install Verification ===" -ForegroundColor Cyan

Write-Host "`nConda version:" -ForegroundColor Yellow
conda --version

Write-Host "`nConda info:" -ForegroundColor Yellow
conda info

Write-Host "`nConda config - pkgs_dirs:" -ForegroundColor Yellow
conda config --show pkgs_dirs

Write-Host "`nConda config - envs_dirs:" -ForegroundColor Yellow
conda config --show envs_dirs

Write-Host "`nPip cache directory:" -ForegroundColor Yellow
pip cache dir

Write-Host "`nDev Drive status:" -ForegroundColor Yellow
fsutil devdrv query E:

Write-Host "`n============================================================================" -ForegroundColor Green
Write-Host "ALL VERIFIED! Your Dev Drive Python setup is complete." -ForegroundColor Green
Write-Host "============================================================================" -ForegroundColor Green

Write-Host "`nYour setup:" -ForegroundColor Cyan
Write-Host "  C:\miniconda3\          - Conda installation (on NTFS)" -ForegroundColor White
Write-Host "  E:\packages\pip\        - Pip cache (on Dev Drive)" -ForegroundColor White
Write-Host "  E:\packages\conda\pkgs\ - Conda package cache (on Dev Drive)" -ForegroundColor White
Write-Host "  E:\packages\conda\envs\ - Conda environments (on Dev Drive)" -ForegroundColor White
Write-Host "  E:\Projects\            - Your projects (on Dev Drive)" -ForegroundColor White

#>
