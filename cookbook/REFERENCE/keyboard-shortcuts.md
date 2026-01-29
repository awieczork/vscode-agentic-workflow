---
when:
  - looking up Copilot keyboard shortcuts
  - configuring keybindings
  - training new users on Copilot
  - troubleshooting shortcut conflicts
pairs-with:
  - settings-reference
requires:
  - none
complexity: low
---

# Keyboard Shortcuts

Quick reference for VS Code GitHub Copilot keyboard shortcuts and commands.

> **Platform Note:** All shortcuts verified against official VS Code and GitHub Copilot documentation (Jan 2026). Some command names shown in Command Palette may vary by VS Code version.

---

## Inline Suggestions

### Windows / Linux

| Action | Shortcut | Command |
|--------|----------|---------|
| Accept suggestion | `Tab` | `editor.action.inlineSuggest.commit` || Accept next word | `Ctrl + Right` | `editor.action.inlineSuggest.acceptNextWord` |
| Accept next line | *(custom)* | `editor.action.inlineSuggest.acceptNextLine` || Dismiss suggestion | `Esc` | `editor.action.inlineSuggest.hide` |
| Show next suggestion | `Alt + ]` | `editor.action.inlineSuggest.showNext` |
| Show previous suggestion | `Alt + [` | `editor.action.inlineSuggest.showPrevious` |
| Trigger suggestion | `Alt + \` | `editor.action.inlineSuggest.trigger` |
| Open suggestions panel | `Ctrl + Enter` | `github.copilot.generate` |
| Toggle Copilot | *(none)* | `github.copilot.toggleCopilot` |

### macOS

| Action | Shortcut |
|--------|----------|
| Accept suggestion | `Tab` |
| Accept next word | `Cmd + Right` |
| Accept next line | *(custom)* |
| Dismiss suggestion | `Esc` |
| Show next suggestion | `Option + ]` |
| Show previous suggestion | `Option + [` |
| Trigger suggestion | `Option + \` |
| Open suggestions panel | `Ctrl + Return` |

---

## Chat Panel

| Action | Windows/Linux | macOS |
|--------|---------------|-------|
| Open Copilot Chat | `Ctrl + Alt + I` | `Cmd + Option + I` |
| Quick Chat (floating) | `Ctrl + Shift + Alt + L` | `Cmd + Shift + Option + L` |
| Inline Chat (in editor) | `Ctrl + I` | `Cmd + I` |
| New Chat Session | `Ctrl + N` (in chat) | `Cmd + N` (in chat) |
| Switch to Agent Mode | `Ctrl + Shift + I` | `Cmd + Shift + I` |
| Model Picker | `Ctrl + Alt + .` | `Cmd + Option + .` |
| Clear Chat History | Type `/clear` | Type `/clear` |
| Navigate prompts | `Ctrl + Alt + Up/Down` | `Cmd + Option + Up/Down` |
| Navigate code blocks | `Ctrl + Alt + PageUp/Down` | `Cmd + Option + PageUp/Down` |
| Focus chat terminal | `Ctrl + Shift + Alt + T` | `Cmd + Shift + Option + T` |
| Toggle terminal expand | `Ctrl + Shift + Alt + O` | `Cmd + Shift + Option + O` |

---

## Slash Commands

Type `/` in chat to access:

### Built-in Commands

| Command | Purpose |
|---------|--------|
| `/clear` | Clear chat history |
| `/explain` | Explain selected code |
| `/fix` | Propose fix for problems |
| `/fixTestFailure` | Find and fix failing test |
| `/help` | Quick reference |
| `/new` | Create new project |
| `/tests` | Generate unit tests |
| `/doc` | Generate documentation comments (inline chat) |
| `/setupTests` | Help setting up testing framework |
| `/newNotebook` | Scaffold Jupyter notebook |
| `/search` | Generate search query for Search view |
| `/startDebugging` | Generate launch.json and start debugging |

### Custom Commands

| Command | Purpose |
|---------|--------|
| `/{prompt-name}` | Run custom `.prompt.md` file |
| `/{agent-prompt}` | Run agent-specific prompt |

For custom prompts, see [prompt-files.md](../CONFIGURATION/prompt-files.md).

---

## Chat Variables & Tools

Type `#` in chat to include context or invoke tools:

### Context Variables

| Variable | Includes |
|----------|----------|
| `#file` | Current file content |
| `#selection` | Selected text |
| `#codebase` | Relevant workspace files |
| `#function` | Current function/method |
| `#class` | Current class |
| `#block` | Current code block |
| `#line` | Current line |
| `#comment` | Current comment |
| `#path` | File path |
| `#sym` | Current symbol |

### Chat Tools (Extended)

| Tool | Purpose |
|------|--------|
| `#fetch` | Fetch content from web page |
| `#githubRepo` | Code search in GitHub repository |
| `#changes` | Source control changes context |
| `#problems` | Workspace issues from Problems panel |
| `#extensions` | Search/ask about VS Code extensions |
| `#todos` | Todo list for tracking implementation |
| `#usages` | Find references/implementations/definitions |
| `#testFailure` | Unit test failure information |
| `#VSCodeAPI` | Ask about VS Code extension development |
| `#runSubagent` | Spawn isolated subagent for research |
| `#terminalLastCommand` | Last terminal command and output |
| `#terminalSelection` | Current terminal selection |
| `#searchResults` | Search results from Search view |

Full reference: [context-variables.md](../CONTEXT-ENGINEERING/context-variables.md)

---

## Chat Participants

Type `@` in chat to target specific contexts:

| Participant | Purpose |
|-------------|---------|
| `@workspace` | Workspace code structure |
| `@terminal` | Terminal shell and contents |
| `@vscode` | VS Code commands and features |
| `@github` | GitHub-specific skills |
| `@azure` | Azure services (preview) |
| `@{agent-name}` | Custom agent from `.agent.md` |

---

## Agent Invocation

| Action | How |
|--------|-----|
| Invoke agent | Type `@agent-name` in chat |
| Run prompt | Type `/prompt-name` in chat |
| Switch mode | Select from chat mode dropdown |
| Quick mode switch | `Ctrl + Shift + I` (toggle agent mode) |

### Built-in Chat Modes

| Mode | Purpose |
|------|--------|
| **Ask** | Simple Q&A without code modifications |
| **Edit** | Targeted inline edits with diff preview |
| **Agent** | Full autonomous capabilities (edits files, runs terminal) |
| **Plan** | Read-only mode for generating implementation plans |

---

## Image Input

| Action | Method |
|--------|--------|
| Paste image | `Ctrl + V` (with image in clipboard) |
| Drag and drop | Drag image file into chat |
| Screenshot | System screenshot → paste |

See [vision-capabilities.md](vision-capabilities.md) for supported formats.

---

## Command Palette

Access via `Ctrl + Shift + P` (Windows/Linux) or `Cmd + Shift + P` (macOS):

<!-- NOT IN OFFICIAL DOCS: Exact command palette names may vary. Commands verified by function, not display name - flagged 2026-01-26 -->

| Command | Description | Command ID |
|---------|-------------|------------|
| Open Chat | Open chat panel | `workbench.action.chat.open` |
| Start Inline Chat | Inline chat in editor | `inlineChat.start` |
| Open Completions Panel | View all suggestions | `github.copilot.generate` |
| Toggle Copilot | Enable/disable suggestions | `github.copilot.toggleCopilot` |
| Keep All Edits | Accept all inline edits | *(v1.98+: renamed from "Accept")* |
| Undo All Edits | Reject all inline edits | *(v1.98+: renamed from "Discard")* |
| Snooze Suggestions | Pause completions temporarily | `github.copilot.snooze` |

---

## Quick Actions

| Context | Action |
|---------|--------|
| Hover over code | Click lightbulb → Copilot options |
| Editor gutter | Click Copilot icon → inline suggestions |
| Terminal | Right-click → "Explain with Copilot" |
| Error squiggle | Click → "Fix with Copilot" |

---

## Custom Keybindings

Add to `keybindings.json`:

```json
[
  {
    "key": "ctrl+shift+c",
    "command": "workbench.action.chat.open"
  },
  {
    "key": "ctrl+shift+e",
    "command": "github.copilot.interactiveEditor.explain"
  },
  {
    "key": "ctrl+shift+f",
    "command": "github.copilot.interactiveEditor.fix"
  },
  {
    "key": "ctrl+shift+t",
    "command": "github.copilot.interactiveEditor.generateTests"
  }
]
```

---

## Related

- [context-variables.md](../CONTEXT-ENGINEERING/context-variables.md) — Full `#` variable reference
- [prompt-files.md](../CONFIGURATION/prompt-files.md) — Custom `/` slash commands
- [agent-file-format.md](../CONFIGURATION/agent-file-format.md) — Custom `@` agents
- [vision-capabilities.md](vision-capabilities.md) — Image input details
- [settings-reference.md](../CONFIGURATION/settings-reference.md) — Copilot settings

---

## Sources

- [GitHub Copilot Cheat Sheet](https://docs.github.com/en/copilot/reference/cheat-sheet?tool=vscode) — Official GitHub reference
- [VS Code Copilot Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) — VS Code documentation (updated Jan 2026)
- [VS Code Keyboard Shortcuts](https://docs.github.com/en/copilot/reference/keyboard-shortcuts-for-github-copilot-in-the-ide) — Complete keyboard shortcuts
- [VS Code v1.98 Release Notes](https://code.visualstudio.com/updates/v1_98) — Agent mode, Keep/Undo rename
- [VS Code v1.107 Release Notes](https://code.visualstudio.com/updates/v1_107) — Chat terminal shortcuts
- [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) — Navigation shortcuts

*Last validated: 2026-01-26*
