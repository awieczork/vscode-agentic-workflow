# Architecture

Workspace structure and artifact type decisions for VS Code agentic frameworks.

---

## Workspace Purpose

This workspace serves two purposes:

- **knowledge-base/** — Reference documentation for creating agentic artifacts
- **generator/** — Automated creation of `.github/` frameworks for new projects

---

## Folder Structure

```
.github/
├── copilot-instructions.md     # Global project rules (auto-loaded)
├── instructions/               # File-pattern-specific rules
│   └── *.instructions.md
├── prompts/                    # One-shot templates
│   └── *.prompt.md
├── agents/                     # Agent definitions
│   └── *.agent.md
├── skills/                     # Reusable procedures
│   └── {name}/SKILL.md
└── memory-bank/                # Shared state (for generated projects)
    ├── sessions/
    └── global/

knowledge-base/
├── artifacts/                  # Core generatable types
│   └── {type}-{checklist|patterns|template}.md
└── references/                 # Supporting guides
    └── {topic}.md

generator/
└── user-manual.md              # Interview usage guide
```

---

## Artifact Types

Select artifact type using this decision order. Prefer the lightweight option.

**Decision order:** Instruction → Skill → Prompt → Agent

| Type | Purpose | Path | Auto-applies |
|------|---------|------|--------------|
| **Instruction** | Rules for specific file patterns | `.github/instructions/*.instructions.md` | Yes, via `applyTo` glob |
| **Skill** | Reusable procedures any agent can invoke | `.github/skills/{name}/SKILL.md` | No, explicit invocation |
| **Prompt** | One-shot templates with placeholders | `.github/prompts/*.prompt.md` | No, manual attachment |
| **Agent** | Specialized personas with tools and handoffs | `.github/agents/*.agent.md` | No, explicit `@agent` |

---

## Knowledge-Base Organization

**artifacts/** — Core generatable types (agent, instruction, prompt, skill)

Each type has three files:
- `{type}-checklist.md` — Validation rules (pass/fail checks)
- `{type}-patterns.md` — Design decisions and reasoning
- `{type}-template.md` — Structure and format

**references/** — Supporting guides (architecture, artifact-quality, generator, xml-tags)

Enhance core artifacts with specialized patterns.

---

## File Responsibilities

| File | Contains | Does NOT Contain |
|------|----------|------------------|
| `{type}-template.md` | Structure, placeholders, defaults | Reasoning, validation rules |
| `{type}-patterns.md` | When to use, anti-patterns, decisions | Structure duplication, pass/fail checks |
| `{type}-checklist.md` | Atomic pass/fail checks by priority | Explanations, structure |

---

## Generation Entry Point

Run `/interview` prompt to generate a `.github/` framework for your project. The prompt contains an XML questionnaire for project requirements.

See [generator.md](generator.md) for the full generation pipeline.

---

## Cross-References

- Prerequisites: [prerequisites.md](prerequisites.md)
- XML tag reference: [xml-tags.md](xml-tags.md)
- Generation pipeline: [generator.md](generator.md)
