# User Utilities

This folder contains user-specific maintenance and utility scripts. These are NOT part of the framework — they are personal tools for managing the development environment.

> **Note:** This folder is prefixed with `_` to sort it separately from framework folders.

## Available Scripts

### `clear-vscode-cache.ps1`

Clears VS Code cache and temporary files to free disk space and resolve performance issues.

**Parameters:**
- `-DryRun` — Preview what would be deleted without actually removing files
- `-All` — Also clear workspace storage (resets workspace-specific settings)

**Usage:** See step-by-step guide below.

---

## How to Run PowerShell Scripts

### Step 1: Close VS Code (Recommended)

For best results, close VS Code before running cache cleanup scripts. Some cache files may be locked while VS Code is running.

### Step 2: Open PowerShell

**Option A:** Use the integrated terminal in VS Code
- Press `Ctrl+`` ` (backtick) to open terminal
- Make sure it's PowerShell (not Command Prompt)

**Option B:** Open PowerShell externally
- Press `Win+X` → Select "Windows Terminal" or "PowerShell"

### Step 3: Navigate to the Utils Folder

```powershell
cd "E:\workspaces\active\vscode_agentic_workflow\_user-utils"
```

### Step 4: Check Execution Policy (First Time Only)

PowerShell may block script execution by default. Check your policy:

```powershell
Get-ExecutionPolicy
```

If it says `Restricted`, you need to allow scripts. Choose one option:

**Option A: Allow for current session only (safest)**
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

**Option B: Allow for current user permanently**
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

### Step 5: Run the Script

**Preview first (recommended):**
```powershell
.\clear-vscode-cache.ps1 -DryRun
```

**Actually clear the cache:**
```powershell
.\clear-vscode-cache.ps1
```

**Clear everything including workspace data:**
```powershell
.\clear-vscode-cache.ps1 -All
```

---

## Quick One-Liner

If you want to run without changing directory:

```powershell
& "E:\workspaces\active\vscode_agentic_workflow\_user-utils\clear-vscode-cache.ps1" -DryRun
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Running scripts is disabled" | Run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` |
| Files skipped as "in use" | Close VS Code completely and run again |
| "Access denied" | Run PowerShell as Administrator |
