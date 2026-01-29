---
when:
  - setting up new agent projects from scratch
  - organizing Copilot configuration files
  - determining where to place agents, prompts, and instructions
pairs-with:
  - agent-file-format
  - instruction-files
  - prompt-files
  - memory-bank-schema
requires:
  - none
complexity: low
---

# File Structure

Canonical folder organization for VS Code Copilot agent projects. Where each file type lives and how they're discovered.

## Complete Structure

```
your-project/
├── .vscode/
│   ├── settings.json           # Workspace VS Code settings
│   └── mcp.json                # MCP server configurations
│
├── .github/
│   ├── copilot-instructions.md # Global repository rules (always loaded)
│   │
│   ├── instructions/           # Targeted instruction files
│   │   ├── frontend.instructions.md    # applyTo: "**/*.{jsx,tsx}"
│   │   ├── backend.instructions.md     # applyTo: "**/*.py"
│   │   └── testing.instructions.md     # applyTo: "**/test/**"
│   │
│   ├── agents/                 # Custom agent definitions
│   │   ├── plan.agent.md
│   │   ├── implement.agent.md
│   │   └── review.agent.md
│   │
│   ├── prompts/                # Reusable prompt templates
│   │   ├── code-review.prompt.md
│   │   ├── feature-spec.prompt.md
│   │   └── refactor.prompt.md
│   │
│   ├── skills/                 # Agent skills (experimental)
│   │   ├── fix-issue/
│   │   │   └── SKILL.md
│   │   └── create-pr/
│   │       └── SKILL.md
│   │
│   └── memory-bank/            # Context persistence
│       ├── projectbrief.md
│       ├── progress.md
│       └── activeContext.md
│
└── AGENTS.md                   # Universal agent instructions (root)
```

**User Profile Locations** (cross-workspace availability):

```
~/.vscode/                          # User profile (Windows: %APPDATA%\Code\User)
├── settings.json                   # User-level Copilot settings
├── globalStorage/
│   └── github.copilot-chat/        # User-level prompts/instructions
└── copilot/
    └── skills/                     # Personal skills (~/.copilot/skills/)
```

## File Locations

| File Type | Location | Discovery Setting |
|-----------|----------|-------------------|
| Global instructions | `.github/copilot-instructions.md` | Auto (always loaded) |
| Targeted instructions | `.github/instructions/*.instructions.md` | `chat.instructionsFilesLocations` |
| Agents | `.github/agents/*.agent.md` | Auto (VS Code scans) |
| Prompts | `.github/prompts/*.prompt.md` | `chat.promptFilesLocations` |
| Skills (project) | `.github/skills/*/SKILL.md` | `chat.useAgentSkills` |
| Skills (personal) | `~/.copilot/skills/*/SKILL.md` | Auto (hardcoded paths) |
| MCP servers | `.vscode/mcp.json` | `chat.mcp.gallery.enabled` |
| VS Code settings | `.vscode/settings.json` | Auto |
| Universal rules | `AGENTS.md` (root) | `chat.useAgentsMdFile` |
| Nested rules | `**/AGENTS.md` | `chat.useNestedAgentsMdFiles` |

## .vscode/ Folder

VS Code-specific configuration:

```
.vscode/
├── settings.json      # Copilot settings, file locations
└── mcp.json           # MCP server definitions
```

### settings.json

```json
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.instructionsFilesLocations": {
    ".github/instructions": true
  },
  "chat.promptFilesLocations": {
    ".github/prompts": true
  },
  "chat.useAgentsMdFile": true,
  "chat.useAgentSkills": true
}
```

### mcp.json

```json
{
  "servers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/"
    }
  }
}
```

**MCP Configuration Locations** (in priority order):
1. User settings (`settings.json` under `mcp` key)
2. `.code-workspace` file
3. `.vscode/mcp.json` (workspace-scoped)
4. Remote settings (for remote development)

> **Source:** [VS Code v1.99 Release Notes](https://code.visualstudio.com/updates/v1_99#_model-context-protocol-server-support)

## .github/ Folder

GitHub Copilot configuration:

```
.github/
├── copilot-instructions.md     # Always loaded for every request
├── instructions/               # Conditionally loaded by applyTo
├── agents/                     # Custom agent personas
├── prompts/                    # Reusable workflow prompts
├── skills/                     # Portable tool packages
└── memory-bank/                # Session and project context
```

### copilot-instructions.md

Global rules loaded for every chat request in this workspace:

```markdown
# Project Instructions

## Stack
- TypeScript 5.x with strict mode
- React 19 with Server Components
- PostgreSQL 16

## Conventions
- Use async/await, not callbacks
- Prefer composition over inheritance
- All functions must have explicit return types

## Testing
- Jest for unit tests
- Playwright for E2E
- 80% coverage minimum
```

### instructions/ Folder

File-specific rules with `applyTo` patterns:

```
instructions/
├── frontend.instructions.md    # applyTo: "**/*.{jsx,tsx,css}"
├── backend.instructions.md     # applyTo: "src/api/**"
├── database.instructions.md    # applyTo: "**/migrations/**"
└── testing.instructions.md     # applyTo: "**/*.test.*"
```

### agents/ Folder

Custom agent personas:

```
agents/
├── plan.agent.md        # Planning and specification
├── implement.agent.md   # Code implementation
├── review.agent.md      # Code review
├── debug.agent.md       # Debugging assistance
└── docs.agent.md        # Documentation generation
```

### prompts/ Folder

Reusable workflow prompts:

```
prompts/
├── code-review.prompt.md       # Review code for issues
├── feature-spec.prompt.md      # Create feature specifications
├── refactor.prompt.md          # Refactoring guidance
├── create-api.prompt.md        # Generate API endpoints
└── write-tests.prompt.md       # Generate test cases
```

### skills/ Folder

Portable agent skills (experimental):

```
skills/
├── fix-issue/
│   ├── SKILL.md                # Skill definition
│   └── templates/              # Optional resources
├── create-pr/
│   └── SKILL.md
└── database-migration/
    └── SKILL.md
```

**Skill Locations** (auto-detected, no configuration needed):

| Scope | Recommended | Legacy |
|-------|-------------|--------|
| Project | `.github/skills/` | `.claude/skills/` |
| Personal | `~/.copilot/skills/` | `~/.claude/skills/` |

> Enable with `"chat.useAgentSkills": true` (experimental, default: false)

### memory-bank/ Folder

Project and session context (community pattern, not official VS Code):

> **Note:** `memory-bank/` is a community-developed pattern for context persistence, adopted from [Cline Memory Bank](https://docs.cline.bot/improving-your-prompting-skills/custom-instructions-library/cline-memory-bank). Not officially supported by VS Code but widely used.

```
memory-bank/
├── projectbrief.md      # Project overview and constraints
├── progress.md          # Current task state
├── activeContext.md     # Session-specific context
├── decisions.md         # Architecture Decision Records
└── systemPatterns.md    # Discovered patterns
```

## Root-Level Files

### AGENTS.md

Universal instructions for all AI agents (not Copilot-specific):

```markdown
# AGENTS.md

Instructions for any AI agent working on this repository.

## Core Rules
1. Never modify files in /config without approval
2. All changes require tests
3. Follow semantic versioning

## Project Context
See .github/memory-bank/projectbrief.md for full context.
```

**Note:** Enable with `"chat.useAgentsMdFile": true`

### Content Exclusion

There is no `.copilotignore` file. Exclude files from Copilot context using:

**1. VS Code Settings** (recommended for local exclusion):

```json
{
  "files.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/.git": true
  },
  "search.exclude": {
    "**/package-lock.json": true,
    "**/*.min.js": true
  }
}
```

**2. .gitignore** — Copilot respects `.gitignore` for workspace indexing.

**3. GitHub Repository Settings** (Business/Enterprise only):
- Repository → Settings → Copilot → Content Exclusion
- Add glob patterns for files to exclude
- Organization-level exclusions also available

> **⚠️ Limitation:** Content exclusion does **NOT** apply to Edit and Agent modes in VS Code. Only affects Ask mode and code completions.

> **Note:** `.gitignore` files are bypassed if you have the file open or have text selected within an ignored file.

> **Source:** [GitHub Docs - Content Exclusion](https://docs.github.com/en/copilot/concepts/context/content-exclusion)

## Alternative Locations

Custom paths via settings:

```json
{
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    "docs/copilot-rules": true,
    ".vscode/instructions": true
  },
  "chat.promptFilesLocations": {
    ".github/prompts": true,
    "prompts": true
  }
}
```

## Starter Template

Minimal setup for new projects:

```bash
mkdir -p .github/{instructions,agents,prompts,skills,memory-bank}
mkdir -p .vscode

# Create essentials
touch .github/copilot-instructions.md
touch .github/agents/default.agent.md
touch .github/memory-bank/projectbrief.md
touch .vscode/settings.json
touch .vscode/mcp.json
```

## Community Patterns

Alternative folder structures used in other AI coding tools:

| Tool | Config Folder | Instructions File | Skills/Agents |
|------|---------------|-------------------|---------------|
| **Claude Code** | `.claude/` | `CLAUDE.md` | `.claude/skills/`, `.claude/agents/` |
| **Cursor** | `.cursorrules` | `.cursorrules` | n/a |
| **Cline** | n/a | `.clinerules` | `memory-bank/` |
| **Universal** | n/a | `AGENTS.md` (root) | n/a |

**Soft-link pattern** for cross-tool compatibility:

```bash
# Create unified instructions, then link for each tool
ln -s .github/copilot-instructions.md AGENTS.md
ln -s .github/copilot-instructions.md CLAUDE.md
ln -s .github/copilot-instructions.md .cursorrules
```

> **Source:** [Community pattern](https://github.com/danielmeppiel/awesome-ai-native)

## Related

- [agent-file-format](./agent-file-format.md) — .agent.md specification
- [instruction-files](./instruction-files.md) — .instructions.md hierarchy
- [prompt-files](./prompt-files.md) — .prompt.md templates
- [skills-format](./skills-format.md) — SKILL.md format
- [settings-reference](./settings-reference.md) — File location settings
- [mcp-servers](./mcp-servers.md) — .vscode/mcp.json configuration
- [memory-bank-schema](./memory-bank-schema.md) — memory-bank/ structure

## Sources

- [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) — copilot-instructions.md, .instructions.md locations
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — .agent.md file locations
- [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) — .prompt.md locations
- [VS Code Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) — Skills folder structure
- [VS Code MCP Servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers) — mcp.json configuration
- [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) — Overall structure
- [GitHub Docs - Content Exclusion](https://docs.github.com/en/copilot/concepts/context/content-exclusion) — File exclusion methods
- [GitHub Blog - How to Write a Great AGENTS.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/) — Six core areas
- [Cline Memory Bank](https://docs.cline.bot/improving-your-prompting-skills/custom-instructions-library/cline-memory-bank) — memory-bank/ pattern origin
