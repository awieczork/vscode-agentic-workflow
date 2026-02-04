# Project Brief

Persistent project context loaded by agents as WARM tier.

<project_identity>

**Name:** VS Code Agentic Workflow

**Purpose:** AI-optimized artifact generation framework with agents, skills, instructions, and prompts

**Repository:** vscode_agentic_workflow

</project_identity>

<tech_stack>

- **Language:** Markdown (artifacts), PowerShell (validation), YAML (schemas)
- **Framework:** VS Code Copilot Agent Framework
- **Build:** None (declarative artifacts)
- **Test:** PowerShell validation scripts per skill

</tech_stack>

<conventions>

**Code style:**
- XML tags for structure (snake_case naming)
- Bullet lists over tables
- Imperative verbs in rules

**Naming:**
- Agents: `{name}.agent.md`
- Skills: `{name}/SKILL.md`
- Instructions: `{domain}.instructions.md`
- Prompts: `{name}.prompt.md`

**Structure:**
- Core agents in `core-agents/agents/`
- Generator agents in `.github/agents/`
- Skills in `.github/skills/{name}/`
- Instructions in `.github/instructions/`

</conventions>

<constraints>

**Must:**
- Follow `copilot-instructions.md` XML conventions
- Validate artifacts against skill schemas
- Use safety layering from `safety.instructions.md`

**Must not:**
- Use markdown tables in artifacts
- Use emojis in generated content
- Fabricate sources or citations

</constraints>

<active_context>

**Current focus:** Phase 6.5 complete — framework ready for use

**Recent decisions:** See [decisions.md](decisions.md)

</active_context>
