# VS Code Settings Template

This file documents each setting in `settings.json`. The generation pipeline copies this file into `output/{project}/.vscode/settings.json`. All settings are required — removing any will degrade agent discovery or behavior.

## Agent & Skill Discovery

| Setting | Purpose | If Missing |
|---|---|---|
| `chat.agentFilesLocations` | Tells VS Code where to find `.agent.md` files. Includes both `.github/agents` (root) and `.github/agents/core` (nested hub-and-spoke agents). | Agents in subdirectories are invisible to Copilot Chat. Only top-level agents load. |
| `chat.promptFilesLocations` | Points to `.github/prompts` for reusable `.prompt.md` files. | Prompt files are not discovered. `#prompt:` references fail silently. |
| `chat.instructionsFilesLocations` | Points to `.github/instructions` for `.instructions.md` files. | Path-scoped instructions do not attach to conversations. |
| `chat.agentSkillsLocations` | Tells VS Code where to find `SKILL.md` files. Includes both `.github/skills` (root) and `.github/skills/creators` (nested creator skills). | Skills in subdirectories are invisible. Agents that reference nested skills cannot load them. |

## Behavioral Flags

| Setting | Purpose | If Missing |
|---|---|---|
| `chat.customAgentInSubagent.enabled` | Allows custom agents to invoke other custom agents as subagents (hub-and-spoke pattern). | Brain agent cannot delegate to spoke agents. Multi-agent workflows break. |
| `chat.includeReferencedInstructions` | Auto-includes instruction files referenced by agents and prompts. | Agents must manually specify every instruction. Referenced instructions are silently ignored. |
| `github.copilot.chat.codeGeneration.useInstructionFiles` | Applies instruction files during code generation, not just chat. | Instructions are ignored when Copilot generates code via inline suggestions or edits. |
