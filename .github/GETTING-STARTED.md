# Getting Started

Quick reference for AI agent framework usage.

<overview>

**What this is:** AI-optimized artifact generation framework with 4 artifact types.

**Artifact types:**
- **Agent** — Specialized persona with tools, safety rules, operational modes
- **Instruction** — File-pattern rules, auto-applied via glob matching
- **Prompt** — One-shot template with placeholders
- **Skill** — Reusable procedure any agent can invoke

**Decision order:** Instruction → Skill → Prompt → Agent (prefer lightweight)

</overview>

<quick_start>

<step_1_choose>

## Choose Artifact Type

**Need file-pattern rules?** → Instruction
- Auto-applies to matching files
- Path: `.github/instructions/{domain}.instructions.md`

**Need reusable procedure?** → Skill  
- Explicit invocation required
- Path: `.github/skills/{name}/SKILL.md`

**Need one-shot template?** → Prompt
- Manual attachment required  
- Path: `.github/prompts/{name}.prompt.md`

**Need specialized persona?** → Agent
- Explicit @agent required
- Path: `.github/agents/{name}.agent.md`

</step_1_choose>

<step_2_invoke>

## Invoke Creator Skill

Each artifact type has a creator skill:
- `agent-creator` — Creates .agent.md files
- `instruction-creator` — Creates .instructions.md files
- `prompt-creator` — Creates .prompt.md files
- `skill-creator` — Creates SKILL.md files

**Invocation:** Mention the skill name or describe what you need. Example:
- "Create an agent for code review"
- "I need an instruction for Python files"

</step_2_invoke>

<step_3_validate>

## Validate Output

After generation:
1. Creator runs built-in validation checks
2. Review P1 (blocking) and P2 (quality) results
3. Iterate if needed

**Validation scripts:** Each skill has `scripts/Validate-Output.ps1`

</step_3_validate>

</quick_start>

<artifact_locations>

## File Locations

- **Agents:** `.github/agents/{name}.agent.md`
- **Instructions:** `.github/instructions/{domain}.instructions.md`
- **Prompts:** `.github/prompts/{name}.prompt.md`
- **Skills:** `.github/skills/{name}/SKILL.md`
- **Memory:** `.github/memory-bank/`

</artifact_locations>

<core_agents>

## Core Agents

- **@brain** — Research, exploration, synthesis (read-only)
- **@architect** — Planning, task decomposition
- **@build** — Implementation, execution
- **@inspect** — Quality verification

</core_agents>

<next_steps>

## Learn More

- [copilot-instructions.md](copilot-instructions.md) — Project rules and XML conventions
- [instructions/safety.instructions.md](instructions/safety.instructions.md) — Safety layering
- [instructions/writing.instructions.md](instructions/writing.instructions.md) — Writing patterns and behavioral rules
- [Self-bootstrap](prompts/self-bootstrap.prompt.md) — Use generator on itself
- Core agents in `agents/` folder
- Creator skills in `skills/` folder

</next_steps>
