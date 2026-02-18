# VS Code Agentic Workflow Framework

A framework for building agentic workflows in VS Code. All artifacts — agents, skills, prompts, and instructions — are written for AI agents to execute.

## What is this

This repository defines a reusable orchestration model for AI-powered development workflows. Six core agents form the backbone; domain-expert agents extend them for specific contexts. The framework ships patterns, skills, and exemplars for creating new agent artifacts.

## Repository structure

```
├── .github/
│   ├── copilot-instructions.md        — Framework-level rules for all agents
│   ├── agents/
│   │   └── core/                      — Living copies of core agents (changes happen here)
│   │       ├── brain.agent.md         — Orchestrator
│   │       ├── curator.agent.md       — Workspace maintenance
│   │       ├── developer.agent.md     — Implementation
│   │       ├── inspector.agent.md     — Quality verification
│   │       ├── planner.agent.md       — Problem decomposition
│   │       └── researcher.agent.md    — Deep research
│   └── .session/                      — Ephemeral session files (gitignored)
├── core-model/
│   └── core-agents/                   — Source-of-truth copies of core agents
├── github-dev/
│   ├── patterns.md                    — 17 design patterns for agent artifacts
│   ├── agents/                        — Domain-specialized agents
│   └── skills/
│       ├── agent-creator/             — Skill for creating domain-expert agents
│       ├── copilot-instructions-creator/ — Skill for creating copilot-instructions.md
│       ├── instruction-creator/       — Skill for creating .instructions.md files
│       └── skill-creator/             — Skill for creating new skills
└── legacy/                            — Deprecated artifacts pending rewrite
```

## Core model

Six agents form the orchestration backbone:

| Agent | Role |
|---|---|
| `@brain` | Central orchestrator — routes tasks, delegates to specialists |
| `@researcher` | Deep research and source synthesis |
| `@planner` | Decomposes problems into phased, dependency-verified plans |
| `@developer` | Executes implementation tasks, produces working code |
| `@inspector` | Final quality gate — verifies against plan and standards |
| `@curator` | Workspace maintenance — docs sync, git commits, cleanup |

`@brain` orchestrates by delegating to specialist agents. Domain-expert agents (like `python-developer`) extend core roles for specific domains.

## Development workflow

Core agents exist in two locations:

- **`core-model/core-agents/`** — Source of truth. Canonical definitions live here.
- **`.github/agents/core/`** — Living copies where active development happens.

Changes are made in `.github/agents/core/` first, then deployed back to `core-model/` once stable. This lets agents be tested in-place before promoting to the canonical source.

## github-dev/

Project-specific development area containing:

- **`patterns.md`** — 17 design patterns distilled from agent artifact iterations.
- **`agents/`** — Domain-specialized agents. `python-developer.agent.md` serves as an exemplar.
- **`skills/`** — Artifact-creator skills, each following the standard format: `SKILL.md` + `references/` + `assets/`, with progressive loading and self-contained references.
  - `agent-creator/` — Creates domain-expert `.agent.md` files
  - `copilot-instructions-creator/` — Creates the singleton `.github/copilot-instructions.md`
  - `instruction-creator/` — Creates scoped `.instructions.md` files
  - `skill-creator/` — Creates new skills with `SKILL.md` workflows

## legacy/

Contains deprecated artifacts from prior architecture iterations. Per `copilot-instructions.md`, these are marked as **"pending full rewrite — treat as outdated and unsupported."** Kept for reference during rewrites only.
