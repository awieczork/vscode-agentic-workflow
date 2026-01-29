# VS Code Configuration Sync

Last exported: 2026-01-25  
Source machine: Windows 11, VS Code 1.108.2

## Files Included

| File | Purpose |
|------|---------|
| `settings.json` | User settings (UI, editor, extensions, Copilot) |
| `mcp.json` | MCP server configurations |
| `keybindings.json` | Custom keyboard shortcuts |
| `extensions.txt` | List of installed extensions |

---

## Step-by-Step Setup on New Machine

### Prerequisites

1. **Windows 11** (Dev Drive feature requires Windows 11)
2. **VS Code 1.108+** installed
3. **Node.js 18+** (for npx-based MCP servers)
4. **Git** installed and configured
5. **GitHub Copilot Pro+** subscription (for Copilot features)

---

### Step 1: Create Dev Drive (Optional but Recommended)

Dev Drive gives ~25-30% faster builds with ReFS and Defender Performance Mode.

```powershell
# Open Disk Management (Win+X → Disk Management)
# Shrink existing volume or use unallocated space
# Create new volume → Format as Dev Drive (ReFS)

# Verify Dev Drive
fsutil devdrv query E:

# Expected output should show:
# - Developer volumes are enabled
# - Volume E: is a trusted Dev Drive
```

**If you skip Dev Drive:** Edit `settings.json` and change:
- `terminal.integrated.cwd` → Your preferred workspace path
- `mcp.json` filesystem paths → Your workspace paths

---

### Step 2: Set Up Conda/Pip Caches (Optional)

If using Conda with Dev Drive:

```powershell
# Create cache directories
New-Item -ItemType Directory -Path "E:\packages\conda\pkgs" -Force
New-Item -ItemType Directory -Path "E:\packages\conda\envs" -Force
New-Item -ItemType Directory -Path "E:\packages\pip" -Force

# Configure Conda (run in base environment)
conda config --add pkgs_dirs E:\packages\conda\pkgs
conda config --add envs_dirs E:\packages\conda\envs

# Add to user environment variables:
# PIP_CACHE_DIR = E:\packages\pip
```

---

### Step 3: Install VS Code Extensions

```powershell
# From the vscode-sync folder:
Get-Content extensions.txt | ForEach-Object { code --install-extension $_ }
```

Or manually install:
- `charliermarsh.ruff` - Python linter/formatter
- `github.copilot` - GitHub Copilot
- `github.copilot-chat` - Copilot Chat
- `github.github-vscode-theme` - GitHub theme
- `ms-python.debugpy` - Python debugger
- `ms-python.python` - Python support
- `ms-python.vscode-pylance` - Python language server
- `ms-python.vscode-python-envs` - Python environments
- `usernamehw.errorlens` - Inline error display
- `vscode-icons-team.vscode-icons` - File icons

---

### Step 4: Copy Configuration Files

```powershell
# Copy settings.json
Copy-Item ".\settings.json" "$env:APPDATA\Code\User\settings.json" -Force

# Copy mcp.json
Copy-Item ".\mcp.json" "$env:APPDATA\Code\User\mcp.json" -Force

# Copy keybindings.json
Copy-Item ".\keybindings.json" "$env:APPDATA\Code\User\keybindings.json" -Force
```

---

### Step 5: Configure MCP Server API Keys

The MCP servers require API keys. VS Code will prompt for these on first use:

| Server | How to Get Key |
|--------|----------------|
| **Brave Search** | https://brave.com/search/api/ (free tier available) |
| **YouTube** | https://mcp.ytmcp.com (follow signup instructions) |

Keys are stored securely by VS Code after first entry.

---

### Step 6: Adjust Machine-Specific Paths

Edit these settings if your paths differ:

**In `settings.json`:**
```json
"terminal.integrated.cwd": "E:\\workspaces",  // Your workspace root
"python.defaultInterpreterPath": "C:\\miniconda3\\python.exe",  // Your Python path
```

**In `mcp.json`:**
```json
"filesystem": {
    "args": ["-y", "@modelcontextprotocol/server-filesystem", 
             "E:\\workspaces",    // Change to your workspace path
             "E:\\packages"]      // Change to your packages path
}
```

---

### Step 7: Configure Git (If Not Done)

```powershell
git config --global core.fsmonitor true
git config --global core.untrackedCache true
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

### Step 8: Verify Setup

1. **Restart VS Code** after copying files
2. Open Command Palette (`Ctrl+Shift+P`)
3. Run `MCP: List Servers` - verify all 5 servers appear
4. Open a Python file - verify Ruff and Pylance activate
5. Open Copilot Chat - verify it responds

---

## Configuration Overview

### Key Performance Settings

| Setting | Value | Purpose |
|---------|-------|---------|
| `editor.minimap.enabled` | `false` | Reduce rendering load |
| `editor.cursorBlinking` | `solid` | No animation CPU |
| `workbench.reduceMotion` | `on` | Disable all animations |
| `editor.codeLens` | `false` | Reduce clutter/processing |
| `telemetry.telemetryLevel` | `off` | No telemetry overhead |

### Copilot Configuration

| Setting | Value | Purpose |
|---------|-------|---------|
| `chat.agent.maxRequests` | `50` | Extended agent sessions |
| `github.copilot.chat.agent.thinkingTool` | `true` | Enable reasoning |
| `chat.tools.terminal.preventShellHistory` | `true` | Don't pollute history |

### MCP Servers

| Server | Type | Purpose |
|--------|------|---------|
| `microsoftdocs/mcp` | HTTP | Microsoft/Azure docs |
| `brave-search` | stdio | Web search, news |
| `youtube` | HTTP | Video transcripts |
| `filesystem` | stdio | Local file operations |
| `context7` | stdio | Library documentation |

---

## Troubleshooting

### MCP Server Won't Start

```powershell
# Clear npm cache
npm cache clean --force

# Reinstall specific server
npx -y @modelcontextprotocol/server-filesystem --help
```

### Settings Not Applied

1. Check for JSON syntax errors: `Ctrl+Shift+P` → "Open User Settings (JSON)"
2. Look for yellow/red squiggles
3. Reload window: `Ctrl+Shift+P` → "Reload Window"

### Extensions Not Installing

```powershell
# Install one at a time to see errors
code --install-extension github.copilot --force
```

---

## Fonts Used

The config references these fonts (install for best experience):
- **Fira Code** - Primary editor font (with ligatures)
- **Inter** - Chat UI font

Download: https://github.com/tonsky/FiraCode

---

## Notes

- This config is optimized for **Python development** with Copilot
- **Markdown** has checks disabled (Copilot handles it)
- **Workspace Trust** is disabled for convenience (re-enable if needed)
- **Activity Bar** is at top, **Sidebar** is on right
