# VS Code Agentic Workflow Generator

Generate customized `.github/` frameworks for your projects through guided AI interviews.

---

## Quick Start

1. Open this workspace in VS Code
2. Open the chat panel (Ctrl+Shift+I)
3. Select Claude Sonnet 4 or Opus 4 in the model picker
4. Type `/interview` and press Enter
5. Fill in the XML questionnaire with your project details and send

The interview agent validates your input, asks clarifying questions, and produces a project brief with artifact recommendations.

---

## What You Get

After completing the interview, you receive:

**Project Brief**
- Synthesized requirements from your questionnaire
- Reference summaries from any linked documentation

**Artifact Manifest**
- Recommended agents, skills, instructions, and prompts
- Rationale tied to your specific workflows
- Creation order based on dependencies

**Generated Artifacts** (after approval)
- `.github/copilot-instructions.md` — Global project rules
- `.github/instructions/*.instructions.md` — File-pattern-specific rules
- `.github/agents/*.agent.md` — Specialized agent definitions
- `.github/skills/{name}/SKILL.md` — Reusable procedures
- `.github/prompts/*.prompt.md` — One-shot templates

All files are created in the `.github/` folder of your target project.

---

## Prerequisites

**VS Code:** Version 1.106 or later

**Extensions:**
- GitHub Copilot
- GitHub Copilot Chat

**Settings:** Enable instruction files and agent skills in VS Code settings.

**Full details:** [generator/prerequisites.md](generator/prerequisites.md)

---

## Documentation

- [User Manual](generator/user-manual.md) — Questionnaire fields, validation rules, examples
- [Architecture](generator/architecture.md) — Workspace structure and artifact types
- [Prerequisites](generator/prerequisites.md) — VS Code version, extensions, tool requirements
- [Generation Pipeline](generator/generator.md) — Three-agent workflow and generation flow

---

## Current Status

**Implemented:**
- Interview agent — Parses questionnaire, clarifies requirements, produces project brief
- Creator skills — agent-creator, instruction-creator, prompt-creator, skill-creator
- Support agents — @architect, @brain, @build, @inspect

**Planned:**
- Master agent — Validates decisions, determines creation order, spawns Creator
- Creator agent — Reads skills, produces artifacts with validation reports

---

## Workspace Structure

```
.github/
├── agents/           # Agent definitions (interview, architect, build, inspect, brain)
├── instructions/     # File-pattern rules
├── prompts/          # interview.prompt.md (questionnaire template)
└── skills/           # Creator skills (agent, instruction, prompt, skill)

generator/
├── user-manual.md    # Interview usage guide
├── architecture.md   # Project structure
├── prerequisites.md  # Requirements
└── generator.md      # Pipeline documentation

knowledge-base/       # Reference documentation for artifact creation
core-agents/          # Portable agent pack documentation
audit/                # Design decisions and specifications
```

---

## License

See LICENSE file for details.
