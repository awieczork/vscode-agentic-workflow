# Prerequisites

Requirements for using the VS Code Agentic Workflow generator.

---

## VS Code Requirements

**Minimum version:** 1.106 or later (custom agents introduced in 1.106)

**Required extensions:**
- GitHub Copilot (`GitHub.copilot`)
- GitHub Copilot Chat (`GitHub.copilot-chat`)

**Required settings:**
- `github.copilot.chat.codeGeneration.useInstructionFiles`: `true` — enables `.github/copilot-instructions.md` loading
- `chat.useAgentSkills`: `true` — enables Agent Skills discovery (preview feature)

**Recommended settings:**
- `chat.useAgentsMdFile`: `true` — enables `AGENTS.md` support if used
- `chat.instructionsFilesLocations`: include `.github/instructions` (default)

---

## Copilot Subscription

**Minimum tier:** Copilot Individual, Copilot Business, or Copilot Enterprise

**Required capabilities:**
- Chat access — all tiers support this
- Agent mode — available in all tiers as of VS Code 1.106+
- Custom agents — available in all tiers

**Model requirements:**
- This generator's prompting patterns optimize for Claude 4.x models
- Other models (GPT-4, Gemini) work but produce less consistent results
- Select Claude Sonnet 4 or Claude Opus 4 in the model picker for best results

---

## Workspace Requirements

**Folder structure:**
- No specific project structure required
- Generator creates `.github/` folder if absent
- Works with any project type (monorepo, single package, polyglot)

**Required for generation:**
- Write access to workspace root
- Ability to create `.github/` folder and subfolders

**Gitignore considerations:**
- Do NOT gitignore `.github/` — artifacts must be committed to share with team
- Consider ignoring `.github/memory-bank/sessions/` for session-specific state
- Keep `.github/memory-bank/global/` tracked for shared project context

---

## Tool Requirements

Agents in this generator require specific tools. If tools are restricted, functionality degrades.

### Required Tools by Agent

| Agent | Required Tools | Purpose |
|-------|---------------|---------|
| @interview | `read`, `search` | Parse questionnaire, scan existing artifacts |
| @interview | `web` | Fetch and summarize referenced URLs |
| @interview | `runSubagent` | Spawn @brain for reference processing |
| @architect | `read`, `search`, `edit` | Create implementation plans |
| @build | `read`, `edit`, `search`, `execute` | Generate artifacts, run validation |
| @inspect | `read`, `search`, `execute` | Verify quality, run tests |
| @brain | `read`, `search`, `web`, `edit` | Research and exploration |

### Tool Availability Matrix

**P0 (Critical) — Generator fails without:**
- `read` — Cannot read existing files or context
- `search` — Cannot find existing artifacts
- `edit` — Cannot create or modify files

**P1 (Important) — Generator works but with reduced functionality:**
- `web` / `fetch` — Cannot process external refs in questionnaire; skip ref summaries
- `execute` — Cannot run validation commands; skip test execution
- `runSubagent` — Cannot delegate to @brain; inline ref processing instead

**P2 (Enhancement) — Quality improvements:**
- `codebase` — Semantic search for existing patterns
- `problems` — Access to workspace diagnostics
- `usages` — Symbol reference lookup

### Handling Tool Restrictions

If the user or organization restricts tools:

| Scenario | Impact | Workaround |
|----------|--------|------------|
| No `web` tool | Cannot fetch external refs | User provides ref content manually or removes refs |
| No `execute` tool | Cannot run tests/lint | Manual validation after generation |
| No `runSubagent` | No subagent delegation | Single-agent processing, slower but functional |
| No `edit` tool | **Cannot generate** | Generator cannot function; read-only mode impossible |

---

## Environment Compatibility

### Supported Environments

| Environment | Support Level | Notes |
|-------------|--------------|-------|
| VS Code Desktop (Windows) | Full | Primary development platform |
| VS Code Desktop (macOS) | Full | No known issues |
| VS Code Desktop (Linux) | Full | No known issues |
| VS Code Web (vscode.dev) | Partial | No terminal/execute tools; read-only generation possible |
| GitHub Codespaces | Full | Requires Copilot access in Codespace |
| VS Code Remote - SSH | Full | Tools execute on remote host |
| VS Code Remote - Containers | Full | Tools execute in container |
| VS Code Remote - WSL | Full | Tools execute in WSL |

### Platform-Specific Considerations

**Windows:**
- PowerShell recommended over Command Prompt for terminal tools
- Command Prompt lacks shell integration; slower, less reliable
- Path separators handled automatically

**macOS/Linux:**
- Bash or zsh recommended
- Default shell works without configuration

**Web environments:**
- Terminal tools unavailable
- `execute` tool restricted
- `edit` works for file creation
- Generation functional but validation skipped

---

## Network Requirements

**Required access:**
- GitHub API (for Copilot authentication)
- VS Code extension marketplace (for extension updates)

**Required for full functionality:**
- External URLs specified in `<refs>` (if provided)
- Timeout: 30 seconds per ref fetch

**Offline mode:**
- Generator works offline if no external refs provided
- Copilot requires network connection

---

## Quick Validation Checklist

Verify prerequisites before running the generator:

- [ ] VS Code version 1.106 or later
- [ ] GitHub Copilot extension installed and authenticated
- [ ] GitHub Copilot Chat extension installed
- [ ] `github.copilot.chat.codeGeneration.useInstructionFiles` enabled
- [ ] `chat.useAgentSkills` enabled (for skills support)
- [ ] Workspace has write access
- [ ] `read`, `search`, and `edit` tools available (check tools picker)
- [ ] Claude model selected in model picker (recommended)

---

## Troubleshooting

### Custom agent not appearing

1. Verify VS Code version ≥ 1.106
2. Check `.github/agents/` folder exists with `.agent.md` files
3. Run `Chat: Configure Custom Agents` from Command Palette
4. Verify agent appears in agents dropdown

### Instructions not loading

1. Check `github.copilot.chat.codeGeneration.useInstructionFiles` is `true`
2. Verify `.github/copilot-instructions.md` exists at workspace root
3. For `*.instructions.md` files, verify path matches `chat.instructionsFilesLocations`
4. Check `applyTo` glob pattern matches target files

### Skills not discovered

1. Enable `chat.useAgentSkills` setting
2. Verify skills are in `.github/skills/` or `~/.copilot/skills/`
3. Each skill needs a `SKILL.md` file with valid frontmatter
4. Check skill `name` and `description` in frontmatter

### Tools not available

1. Open Chat view → Agent mode
2. Select Configure Tools button
3. Verify required tools are enabled
4. Some tools require explicit approval on first use

---

## Cross-References

- User manual: [user-manual.md](user-manual.md)
- Architecture: [architecture.md](architecture.md)
- Generation pipeline: [generator.md](generator.md)
