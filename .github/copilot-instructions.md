# Copilot Instructions

This file defines content generation rules for AI agents in this repository. All generated content optimizes for AI agent consumption, not human readers.

**Reader identity:** The reader of all files in `.github/` is ALWAYS an AI agent. Write TO the agent, not descriptions ABOUT the agent.

Apply rules from `<critical_rules>` when generating any content. Avoid human-centric patterns listed in `<forbidden_structures>`. Select artifact type using decision order in `<artifact_types>`. For extended conventions, follow [xml-structure.instructions.md](instructions/xml-structure.instructions.md) for XML syntax and [writing.instructions.md](instructions/writing.instructions.md) for writing patterns.

<validation_checks>

## Content Validation

Execute these checks at each generation phase:

**Pre-generation:**
- Verify content is clear and unambiguous for an AI agent
- Confirm an AI agent can parse and act on this content without human interpretation

**During generation:**
- Apply XML tag structure per [xml-structure.instructions.md](instructions/xml-structure.instructions.md)
- Use imperative verbs per `<critical_rules>`
- Avoid patterns in `<forbidden_structures>`

**Post-generation:**
- Verify the AI agent can easily identify and locate specific content
- Confirm another AI agent would understand this without additional context

</validation_checks>

<critical_rules>

## Core Generation Rules

Before output, verify: "Executable by agent without human interpretation?" If no, revise.

**Language rules:**
- Use imperative verbs — "Include X" not "X should be included"
- State facts with evidence basis — avoid "typically" or "probably"
- Quantify all guidance — "2-3 items" not "several"
- Avoid emojis — emojis break parsing in some environments

**Structure rules:**
- Wrap all logical sections in XML tags per [xml-structure.instructions.md](instructions/xml-structure.instructions.md)
- Apply XML tags when generating content or editing files

**Validation:**
- Spawn sub-agent with #tool:runSubagent before creating or editing content to verify clarity

</critical_rules>

<forbidden_structures>

## Patterns to Avoid

These human-centric patterns break agent parseability. Use the positive alternatives.

**Start with actionable content** — Begin files directly with purpose statement and rules.
<example>
- Avoid: "## Introduction\n\nThis guide will help you..."
- Use: "## Purpose\n\nThis file defines validation rules for..."
</example>

**Write section content directly** — Start each section with its content, not commentary.
<example>
- Avoid: "This section covers the key patterns..."
- Use: "Key patterns:\n- Pattern 1..."
</example>

**Present information upfront** — State all required context at the start.
<example>
- Avoid: Revealing constraints gradually through the document
- Use: List all constraints in a `<constraints>` section at the top
</example>

**State purpose factually** — Describe what the artifact does, not how it benefits the reader.
<example>
- Avoid: "This will help you create better agents..."
- Use: "This file contains agent templates for..."
</example>

</forbidden_structures>

<artifact_types>

## Artifact Types

Select type using decision order. Prefer lightweight option.

**Decision order:** Instruction → Skill → Prompt → Agent

- **Instruction** — Rules for file patterns. Path: `.github/instructions/*.instructions.md`. Auto-applies via `applyTo` glob.
- **Skill** — Reusable procedures. Path: `.github/skills/{name}/SKILL.md`. Explicit invocation required.
- **Prompt** — One-shot templates. Path: `.github/prompts/*.prompt.md`. Manual attachment required.
- **Agent** — Specialized personas with tools. Path: `.github/agents/*.agent.md`. Explicit `@agent` required.

</artifact_types>

## Cross-References

- [copilot-instructions.md](copilot-instructions.md) — This file (global rules)
- [xml-structure.instructions.md](instructions/xml-structure.instructions.md) — XML syntax and structure conventions
- [writing.instructions.md](instructions/writing.instructions.md) — Writing patterns and formatting rules
