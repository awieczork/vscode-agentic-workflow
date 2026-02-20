# Agentic Workflow

Spec-driven agentic development for VS Code. A full-stack framework that pairs a brain orchestrator with five specialist subagents to drive the entire development lifecycle — from structured interviews and spec authoring through planning, implementation, testing, and curation. Deep native integration with VS Code and GitHub Copilot Chat, with auto-scaling complexity that adapts from lightweight single-turn tasks to full spec-driven workflows.

## Core Principles

1. **Understanding before action** — Every task begins with a structured interview and research phase. Brain gathers context before any implementation starts.
2. **WHAT over HOW** — Brain delegates goals and constraints to subagents, never implementation details. Over-specifying reduces output quality.
3. **Context flows down, not across** — Brain distributes context to subagents; subagents never communicate laterally. Hub-and-spoke, not mesh.
4. **Artifacts over memory, purpose over volume** — Persistent files over LLM memory. Every artifact earns its place; nothing is written "just in case."
5. **Extend, don't fork** — Check whether existing code or content handles part of the task. Adjust or extend before creating something new.

## Architecture

**Hub-and-spoke orchestration.** Brain is the sole user-facing agent. All other agents are brain-spawned subagents that receive a problem statement and return structured results. Subagents are stateless — no shared memory, no lateral communication.

**Six core agents:**

| Agent | Role |
|-------|------|
| **brain** | Orchestrator — decomposes problems, delegates work, tracks progress |
| **researcher** | Gathers context from workspace, docs, and external sources |
| **planner** | Decomposes problems into phased plans with success criteria |
| **developer** | Implements tasks — code, docs, config — matching project conventions |
| **inspector** | Quality gate — verifies implementation against plan with evidence |
| **curator** | Workspace maintenance — syncs docs, structures commits, cleans artifacts |

**Two flows:**

- **Generation flow** — One-shot bootstrap that creates a project-specific `.github/` folder with agents, skills, instructions, and hooks tailored to a target project. Runs via a prompt file in this repo.
- **Spec workflow** — Ongoing development loop for complex features. Brain interviews the user, creates a spec file capturing the full non-technical picture, then drives planning, development, testing, review, and curation. Problem statements scope spec content for individual subagent tasks.

**Three-layer persistence:**

| Layer | Location | Lifespan | Purpose |
|-------|----------|----------|---------|
| Project identity | `copilot-instructions.md` | Permanent | Universal rules and context, loaded every turn |
| Spec files | `.github/specs/{feature}.md` | Feature-scoped | Problem-space documentation with acceptance criteria |
| Session docs | `.github/.session/` | Ephemeral | Brain's working memory for the current session |

## How It Works

**Lifecycle:** Interview → Spec (optional) → Research → Planning → Development → Testing → Review → Curation.

**Auto-scaling complexity.** After the first interview round, brain evaluates whether the task warrants a spec workflow and surfaces the suggestion via `askQuestions`. The user always decides. Brain re-evaluates each round and can re-suggest if complexity grows. Simple tasks skip the spec and proceed directly through the lifecycle.

**Spec files** capture the full non-technical picture — goal, user story, requirements (RFC 2119), constraints, acceptance criteria, open questions, and a changelog. Delta markers (`[NEW]`, `[CHANGE]`, `[REMOVE]`) track changes in brownfield development. Status lifecycle: `draft` → `active` → `implemented` → `archived`. Archived specs move to `.github/specs/.archive/`.

**Inspector quality gates** deliver one of three verdicts: PASS, PASS WITH NOTES, or REWORK NEEDED. Individual findings carry severity — Critical (blocks), Major, Minor. Drift detection checks each acceptance criterion against implementation: MET, PARTIALLY MET, NOT MET, or DRIFTED.

**Hooks** add deterministic enforcement to the probabilistic LLM. Five lifecycle events — `SessionStart`, `PreToolUse`, `PostToolUse`, `PreCompact`, `Stop` — run shell scripts that create session files, guard edits, gate stale sessions, inject compaction recovery context, and enforce session archival.

## Getting Started

**Prerequisites:**

- [VS Code](https://code.visualstudio.com/) with [GitHub Copilot Chat](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat) extension
- Copilot Chat agent mode enabled

**Install (copy):**

Copy the `agentic-workflow/.github/` folder into your project's `.github/` directory. This gives you the full framework with all core agents, skills, hooks, and the generation prompt.

**Install (generate):**

Use the generation flow to bootstrap a project-specific version. Open the `generation.prompt.md` prompt file in Copilot Chat and describe your project. Brain interviews you, then generates tailored agents, skills, instructions, and hooks.

**First run:**

Start a chat with `@brain` in Copilot Chat agent mode. Describe what you want to build. Brain handles the rest — interviewing, planning, delegating, and verifying.

## Extensibility

Four artifact types extend the framework:

| Type | Convention | Purpose |
|------|-----------|---------|
| Agents | `.agent.md` | Domain-specialized roles extending one of the five core roles |
| Skills | `.github/skills/{name}/SKILL.md` | Reusable workflows with references and assets for specific domains |
| Instructions | `.instructions.md` | Coding standards, conventions, and project rules scoped by glob |
| Prompts | `.github/prompts/{name}.prompt.md` | Reusable task templates that overlay brain's lifecycle |

**Creator skills** provide guided workflows for authoring each artifact type: `agent-creator`, `skill-creator`, `instruction-creator`, and `copilot-instructions-creator`. Generated agents follow the `{domain}-{role}` naming convention (e.g., `python-developer`, `security-researcher`).

The **generation flow** produces a complete project-specific `.github/` folder — the primary extensibility path for new projects.

## Project Structure

```
agentic-workflow/.github/
├── copilot-instructions.md   # Project identity and universal rules (always-on)
├── agents/core/              # Core agent definitions
│   ├── brain.agent.md        # Orchestrator — sole user-facing agent
│   ├── researcher.agent.md   # Deep research and source synthesis
│   ├── planner.agent.md      # Problem decomposition and planning
│   ├── developer.agent.md    # Implementation — code, docs, config
│   ├── inspector.agent.md    # Quality verification and drift detection
│   └── curator.agent.md      # Workspace maintenance and git operations
├── hooks/                    # Deterministic lifecycle hooks
│   ├── agent-hooks.json      # Hook event registration (5 events)
│   └── scripts/
│       └── agent-hooks.ps1   # Hook handler script
├── prompts/
│   └── generation.prompt.md  # Generation flow — project bootstrapping
└── skills/                   # Creator skills for artifact authoring
    ├── agent-creator/        # Guides .agent.md creation
    ├── skill-creator/        # Guides SKILL.md creation
    ├── instruction-creator/  # Guides .instructions.md creation
    ├── copilot-instructions-creator/  # Guides copilot-instructions.md creation
    └── plan-visualization/   # Mermaid flowchart diagrams for plans
```

## Contributing

All framework source lives in `agentic-workflow/.github/`. Edit agents, skills, hooks, and prompts there.

**Testing:** Use the generation flow against a sample project to verify end-to-end behavior. Manual testing with `@brain` in Copilot Chat validates the spec workflow and agent interactions.

**Conventions:** Follow the five core principles. Agents are project-agnostic and portable — project specificity flows through generated artifacts, not agent bodies. Document each fact once in its canonical location. State principles, not enumerations.
