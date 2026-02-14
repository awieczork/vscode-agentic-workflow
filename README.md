# VS Code Agentic Workflow Framework

A framework for generating AI agent systems in VS Code using a hub-and-spoke orchestration pattern.

## What is this

This repository contains reusable agents, workflows, skills, and prompt templates that produce complete `.github/` configurations for any project. You describe your project; the framework interviews you and generates a tailored set of AI agents, skills, instructions, and prompts — all executable by GitHub Copilot in VS Code.

## Repository structure

```
.github/
├── agents/core/             — 6 core agents (brain, researcher, planner, builder, inspector, curator)
├── agent-workflows/         — Workflow orchestrations (generation, evolution)
├── instructions/            — Path-specific instruction files (reserved)
├── prompts/                 — One-shot prompt templates (init-project, evolve, calibrate)
├── skills/artifact-creator/ — Unified skill for creating all artifact types
├── skills/mermaid-diagramming/ — B4 plan visualization diagrams for @brain with fork-join parallelism and teal monochrome styling
└── copilot-instructions.md  — Workspace-level AI context
```

## Quick start

Three workflows, each triggered by running a prompt template in VS Code Copilot Chat:

| Workflow | Prompt file | What it does |
|---|---|---|
| **Generate** | `init-project.prompt.md` | Fill the seed (name, tech, goal) and run — starts an expert interview that produces a full `.github/` agent setup for your project |
| **Evolve** | `evolve.prompt.md` | Describe what to add or change — creates or modifies agents, skills, instructions, or prompts in an existing project |
| **Calibrate** | `calibrate.prompt.md` | Scans a target workspace and updates `copilot-instructions.md` to match the actual project structure |

## Agents

Hub-and-spoke model — `@brain` receives all requests and delegates to specialized subagents:

| Agent | Role |
|---|---|
| `@brain` | Central orchestrator — routes tasks, tracks session state |
| `@researcher` | Deep research and source synthesis on focused topics |
| `@planner` | Decomposes problems into phased, dependency-verified plans |
| `@builder` | Executes implementation tasks, produces working code |
| `@inspector` | Final quality gate — verifies against plan and standards |
| `@curator` | Workspace maintenance — docs sync, git commits, cleanup |

## Output

Generated artifacts are written to `output/{projectName}/.github/` and are self-contained — copy the `.github/` folder into your target project, run the **Calibrate** workflow, and you're ready to go.
