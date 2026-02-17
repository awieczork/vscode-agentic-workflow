---
name: 'artifact-creator'
description: 'Creates and refactors VS Code Copilot customization artifacts — agents, skills, prompts, instructions, and copilot-instructions. Use when asked to "create an agent", "write a skill", "scaffold a prompt", "add instructions", or "generate copilot-instructions". Produces properly-structured markdown files following framework conventions.'
---

This skill creates all five types of VS Code Copilot customization artifacts. The governing principle is classify-then-specialize — identify the artifact type first, then apply type-specific conventions for frontmatter, body, and validation. Begin with `<step_1_classify>` to determine which artifact the user needs.


<artifact_types>

Five artifact types exist, each with a distinct purpose and file pattern. Classification drives every downstream decision — frontmatter fields, body structure, tag vocabulary, and validation rules.

| Type | File pattern | Purpose | When to use |
|---|---|---|---|
| Agent | `.agent.md` | Autonomous AI persona with tools, constraints, and behavioral modes | User needs a persistent identity that receives tasks and produces structured output |
| Skill | `SKILL.md` | Reusable multi-step process any agent can invoke | User needs a repeatable workflow with steps, validation, and reference files |
| Prompt | `.prompt.md` | One-shot task template with variables and file references | User needs a `/` command that performs a single focused task |
| Instruction | `.instructions.md` | Ambient constraints that auto-attach based on file patterns or task relevance | User needs rules that shape behavior without explicit invocation |
| Copilot-instructions | `copilot-instructions.md` | Project-wide context applied to every chat request | User needs workspace-level conventions, project context, or decision frameworks |

</artifact_types>


<workflow>

Execute steps sequentially. Each step builds on the previous — classification determines frontmatter, frontmatter sets up body structure, body content feeds quality checks, and validation confirms delivery readiness.


<step_1_classify>

Determine which artifact type the user wants. Scan the request for signal words and match against the table below. If the request maps to exactly one type, proceed. If ambiguous — ask before continuing.

| Signal words | Artifact type |
|---|---|
| "create an agent", "build an agent", "scaffold an agent", "agent persona", "autonomous agent" | Agent |
| "create a skill", "write a skill", "scaffold a skill", "reusable process", "multi-step workflow" | Skill |
| "create a prompt", "write a prompt", "scaffold a prompt", "slash command", "prompt template" | Prompt |
| "create instructions", "add instructions", "coding standards", "file-specific rules", "ambient rules" | Instruction |
| "copilot-instructions", "workspace instructions", "project instructions", "project config" | Copilot-instructions |

**Disambiguation rules:**

- "Create rules for TypeScript files" → Instruction (ambient constraints, file-triggered)
- "Create an agent that reviews TypeScript" → Agent (persistent identity with tools)
- "Create a prompt for code review" → Prompt (one-shot `/` command)
- "Create a reusable review process" → Skill (multi-step, any agent can invoke)
- "Set up project-wide conventions" → Copilot-instructions (workspace-level)

If the request blends types ("create an agent with a skill for..."), separate into individual artifacts — one file per type. Confirm the split with the user before proceeding.

**Refactoring:** If the request targets an existing artifact, read the file first. Preserve working structure — change only what the user asks for.

</step_1_classify>


<step_2_frontmatter>

Load [frontmatter-contracts.md](./references/frontmatter-contracts.md) for the classified artifact type.

Write YAML frontmatter following the contract. All string values use single quotes. Required fields first, optional fields after.

| Type | Required | Key optional | Note |
|------|----------|-------------|------|
| Agent | `description` | `tools`, `model`, `agents` | Keyword-rich description for discovery |
| Skill | `name`, `description` | — | Name must match parent folder name |
| Prompt | — | `description`, `tools`, `model` | `description` recommended; verb-first, 50-150 chars |
| Instruction | — | `applyTo`, `description` | Glob patterns scope auto-attachment |
| Copilot-instructions | — | — | No frontmatter needed; plain markdown |

Validate: YAML parses cleanly, all string values single-quoted, required fields present.

</step_2_frontmatter>


<step_3_body>

Load [body-patterns.md](./references/body-patterns.md) for the classified artifact type.

Write the body following type-specific conventions. Each type has a distinct shape — do not mix patterns across types.

| Type | Body skeleton |
|------|---------------|
| Agent | Identity prose → bullet constraints → `<workflow>` → domain tags → output template |
| Skill | Prose intro → `<use_cases>` → `<workflow>` with Load-and-execute steps → `<error_handling>` → `<resources>` |
| Prompt | Verb-first opening line → task description → `#tool:` directives → `${variable}` placeholders |
| Instruction | Prose intro → 2+ custom XML groups wrapping NEVER/ALWAYS rules per domain concern |
| Copilot-instructions | Project context → `<rules>` block with NEVER/ALWAYS constraints → commands (optional) |

**Gold references** — After drafting, compare your artifact against the matching example:

| Type | Reference |
|------|-----------|
| Agent | [example-agent.md](./assets/example-agent.md) |
| Skill | [example-skill.md](./assets/example-skill.md) |
| Prompt | [example-prompt.md](./assets/example-prompt.md) |
| Instruction | [example-instruction.md](./assets/example-instruction.md) |
| Copilot-instructions | [example-copilot-instructions.md](./assets/example-copilot-instructions.md) |

Verify structural alignment — tag layout, prose intro presence, constraint style. Do not copy content; match shape.

</step_3_body>


<step_4_quality>

Load [writing-rules.md](./references/writing-rules.md).

Apply cross-cutting quality rules — XML conventions, formatting standards, forbidden content, and platform-reserved tag checks are defined in writing-rules.md.

**Vocabulary:**

Use canonical terms from the `<glossary>` in [writing-rules.md](./references/writing-rules.md). Accept aliases in user input, write canonical forms in output: constraint (not restriction), skill (not procedure), handoff (not delegation), escalate (not interrupt), fabricate (not hallucinate).

</step_4_quality>


<step_5_validate>

Load [writing-rules.md](./references/writing-rules.md) `<validation>` section for P1/P2/P3 check lists.

Fix all P1 issues before delivery. Address P2 issues. Flag P3 as suggestions.

**Pattern scan** — Before final review, scan the completed artifact against the `<banned_patterns>` table in [writing-rules.md](./references/writing-rules.md). Flag any matches by severity. Fix P1 matches immediately; include P2 matches in the delivery notes.

**Final review:**

- Re-read the complete artifact
- Verify each success criterion from the original request
- Confirm the artifact is self-contained — an agent reading it for the first time can execute without external knowledge

</step_5_validate>


</workflow>


<error_handling>

Common failure modes and recovery actions. Apply the matching recovery when an issue surfaces during any workflow step.

- If the **wrong artifact type is detected** in step 1, then re-classify using the signal words table — ask the user to confirm if still ambiguous
- If **frontmatter validation fails** (missing fields, wrong types, bad format), then reload [frontmatter-contracts.md](./references/frontmatter-contracts.md) for the artifact type and fix against the contract
- If **body structure does not match the type** (e.g., identity prose in a skill, workflow steps in an instruction), then reload [body-patterns.md](./references/body-patterns.md) and restructure — check the `<anti_patterns>` section for the type
- If **a platform-reserved tag is detected** (VS Code system prompt tag in an authored artifact), then consult the reserved tags list in [writing-rules.md](./references/writing-rules.md), rename the offending tag to a domain-specific alternative
- If **the artifact exceeds reasonable length** (agents >400 lines, skills >500 lines, prompts >80 lines, instructions >150 lines), then extract to reference files (skills) or split into separate artifacts (instructions, prompts)
- If **the request blends multiple artifact types**, then separate into individual files — one artifact per file, one type per artifact — confirm the split with the user
- If **a referenced file does not exist** (JIT load target, file reference, asset), then note the gap, create a stub if within scope, or flag as a blocker if outside scope

</error_handling>


<resources>

Reference files provide detailed specifications loaded on demand during workflow steps. Example assets demonstrate completed artifacts for each type.

**Reference files:**

- [frontmatter-contracts.md](./references/frontmatter-contracts.md) — YAML frontmatter specifications for all five artifact types: field definitions, type constraints, required vs optional, tool catalog (agents), variable system (prompts), glob patterns (instructions)
- [body-patterns.md](./references/body-patterns.md) — Body structure conventions per artifact type: identity prose (agents), workflow steps (skills), task body (prompts), rule groups (instructions), section layout (copilot-instructions). Includes anti-patterns for each type
- [writing-rules.md](./references/writing-rules.md) — Cross-cutting quality rules for all types: XML conventions, formatting standards, tag usage guidelines, canonical vocabulary glossary, P1/P2/P3 validation checks

**Example assets:**

- [example-agent.md](./assets/example-agent.md) — Agent artifact demonstrating identity prose, bullet constraints, workflow, domain tags, and output template
- [example-skill.md](./assets/example-skill.md) — Skill artifact demonstrating prose intro, use cases, workflow steps, error handling, validation, and resources
- [example-prompt.md](./assets/example-prompt.md) — Prompt artifact demonstrating frontmatter, task heading, variable usage, and file references
- [example-instruction.md](./assets/example-instruction.md) — Instruction artifact demonstrating conditional frontmatter, custom XML groups, and bullet rules
- [example-copilot-instructions.md](./assets/example-copilot-instructions.md) — Copilot-instructions artifact demonstrating project context prose, rules, and commands

</resources>
