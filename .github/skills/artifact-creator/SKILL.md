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

Write YAML frontmatter following the contract for the artifact type. All string values use single quotes. Required fields first, optional fields after.

**Quick reference by type:**

- **Agent** — `description` required (keyword-rich, trigger words for discovery). Optional: `name`, `tools` (tool sets or individual tools), `model`, `user-invokable`, `disable-model-invocation`, `agents`, `handoffs`, `mcp-servers`, `target`, `argument-hint`. See frontmatter-contracts.md for the full tool catalog and selection guidance
- **Skill** — `name` required (lowercase + hyphens, must match parent folder), `description` required (formula: `[What]. Use when [triggers]. [Capabilities].`, max 1024 chars)
- **Prompt** — `description` recommended (verb-first, 50-150 chars). Optional: `name`, `agent`, `model`, `tools`, `argument-hint`. See frontmatter-contracts.md for the variable system
- **Instruction** — `description` recommended (keyword-rich, 50-150 chars). Optional: `name`, `applyTo` (glob patterns for auto-attachment). Decision rule: file extensions → use `applyTo`; task type → `description` only; both for dual discovery
- **Copilot-instructions** — No frontmatter. Plain markdown, auto-applied to all chat requests

Validate: YAML parses cleanly, all string values single-quoted, required fields present.

</step_2_frontmatter>


<step_3_body>

Load [body-patterns.md](./references/body-patterns.md) for the classified artifact type.

Write the body following type-specific conventions. Each type has a distinct shape — do not mix patterns across types.

**Agent body:**

1. **Identity prose** (no XML wrapper) — 2-4 sentences. First sentence: "You are the X — a [role]." Second: "Your governing principle: [principle]." Establishes persona in second person
2. **Bullet constraints** (no XML wrapper) — 5-7 NEVER/ALWAYS rules as bare bullets between identity prose and `<workflow>`. Binary enforcement — no hedging
3. **`<workflow>`** — Required. Prose paragraph describing execution model, then numbered steps with bold names and em-dash descriptions. Steps are domain-specific
4. **Domain-specific XML tags** — 1-4 tags named for the agent's domain. NOT from a fixed vocabulary — use self-explanatory names (e.g., `<build_guidelines>`, `<research_guidelines>`, `<verdicts>`)
5. **Output template** — Dedicated XML tag with fenced code block showing the required output format. Include a `<example>` sub-tag with a realistic completed output

New agents should be positioned relative to existing core agents (`@brain`, `@researcher`, `@architect`, `@build`, `@inspect`, `@curator`). Define the role relative to a core agent, specify when the orchestrator should prefer it, and follow the same interface patterns (status codes, session ID echo, output template) so the orchestrator routes to it seamlessly.

**Skill body:**

1. **Prose intro** — "This skill [what]. The governing principle is [principle]. Begin with `<step_1_verb>` to [first action]."
2. **`<use_cases>`** — 3-5 entries aligned with description trigger phrases
3. **`<workflow>`** — Numbered `<step_N_verb>` sub-tags. Each step is self-contained. Use `Load [file](path) for:` directives for JIT content. Keep SKILL.md under 500 lines — extract content exceeding 100 lines to `references/`
4. **`<error_handling>`** — If/then format for recovery actions (3+ entries)
5. **`<validation>`** — Verifiable boolean checks, P1/P2/P3 tiers for complex skills
6. **`<resources>`** — Relative-path links to all subfolder files

**Prompt body:**

1. **Heading** — Verb-first, serves as Quick Pick search label
2. **Task description** — Imperative, direct. No "You are an expert..." preambles — state the task immediately
3. **Prose or XML structure** — Prose for simple prompts (under ~20 lines); XML with ad-hoc tags for multi-section prompts
4. **Variables** — `${input:name}` for runtime inputs, `${selection}` for editor selection, `${file}` for active file. Dollar prefix required
5. **File and tool references** — `[display](./path)` for context attachment, `#tool:<name>` for tool invocation

One task per prompt — "create, test, and deploy" is three prompt files, not one.

**Instruction body:**

1. **Prose intro** — 1-3 sentences stating purpose and governing principle. No identity, no personality
2. **Custom XML groups** — Domain-specific tag names wrapping related rules (`<naming_conventions>`, `<error_handling>`, `<type_safety>` — not `<section_1>`)
3. **Rule style** — Imperative, binary. NEVER/ALWAYS. Reason after em-dash. One rule per bullet

No identity prose, no stance words, no variables, no agent/skill tags. Instructions carry rules, not personas.

**Copilot-instructions body:**

1. **Workspace map** — Directory listing with status markers
2. **Project context** — Overview, tech stack, naming conventions, key abstractions, testing strategy
3. **Project constraints** — Standard rules plus project-specific additions
4. **Decision framework** — Priority hierarchy (e.g., Safety → Accuracy → Clarity → Style)
5. **Development commands** — Grouped by category (build, test, lint, deploy)
6. **Environment context** — Runtime, package management, prerequisites
7. **Agent listing** (optional) — Cross-reference available agents for orchestration awareness

Keep every line concise — this file loads on every request, so every section must earn its token cost.

</step_3_body>


<step_4_quality>

Load [writing-rules.md](./references/writing-rules.md).

Apply cross-cutting quality rules to ensure consistency across all artifact types.

**XML conventions:**

- Tags use `snake_case`, domain-specific, self-explanatory names — not generic labels
- 1-2 nesting levels preferred, 3 maximum — split files rather than exceeding depth
- 4-8 top-level tags is the typical range for a well-structured artifact
- Prose intro (1-3 sentences) inside each tag before structured content
- One concern per tag — separate distinct concepts into distinct tags

**Formatting:**

- YAML frontmatter: single-quoted string values
- Bold for key terms, no italics for structure
- Bullets for unordered items, numbered lists for sequential steps
- Fenced code blocks with language identifier
- `**term** — definition` pattern (bold + em-dash)
- Blank line after opening XML tag, blank line before closing tag
- Two blank lines between major sections

**Forbidden content:**

- No absolute file paths — relative paths with forward slashes only
- No secrets or credentials in any artifact
- No emojis or motivational phrases
- No markdown headings inside artifact body — XML tags replace headings entirely

**Cross-contamination check:**

Verify no forbidden tags from other artifact types appear in the output. The forbidden tags table in [writing-rules.md](./references/writing-rules.md) defines type boundaries — agent tags in skills, skill tags in agents, and platform-reserved tags in any authored artifact are all P1 violations.

**Vocabulary:**

Use canonical terms from the `<glossary>` in [writing-rules.md](./references/writing-rules.md). Accept aliases in user input, write canonical forms in output: constraint (not restriction), skill (not procedure), handoff (not delegation), escalate (not interrupt), fabricate (not hallucinate).

</step_4_quality>


<step_5_validate>

Run validation checks before delivery. P1 issues block delivery — fix them. P2 issues degrade quality — fix them. P3 issues are polish — flag them.

**P1 — Blocking** (fix before delivery):

- File extension matches artifact type: `.agent.md`, `SKILL.md`, `.prompt.md`, `.instructions.md`, `copilot-instructions.md`
- YAML frontmatter parses correctly with single-quoted string values (except copilot-instructions — no frontmatter)
- Zero markdown headings inside artifact body — XML tags only
- No cross-contamination — no forbidden tags from other artifact types (see `<forbidden_tags>` in [writing-rules.md](./references/writing-rules.md))
- No hardcoded secrets, credentials, or absolute paths
- Required frontmatter fields present: `description` for agents, `name` + `description` for skills

**P2 and P3 checks:**

Load [writing-rules.md](./references/writing-rules.md) for the complete `<validation>` section covering P2 (quality) and P3 (polish) checks — tag references, file resolution, orphaned resources, naming consistency, voice, prose intros, format consistency, conciseness, and examples.

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
- If **cross-contamination is detected** (forbidden tags from another type), then consult the forbidden tags table in [writing-rules.md](./references/writing-rules.md), remove offending tags, and replace with type-appropriate alternatives
- If **the artifact exceeds reasonable length** (agents >400 lines, skills >500 lines, prompts >80 lines, instructions >150 lines), then extract to reference files (skills) or split into separate artifacts (instructions, prompts)
- If **the request blends multiple artifact types**, then separate into individual files — one artifact per file, one type per artifact — confirm the split with the user
- If **a referenced file does not exist** (JIT load target, file reference, asset), then note the gap, create a stub if within scope, or flag as a blocker if outside scope

</error_handling>


<resources>

Reference files provide detailed specifications loaded on demand during workflow steps. Example assets demonstrate completed artifacts for each type.

**Reference files:**

- [frontmatter-contracts.md](./references/frontmatter-contracts.md) — YAML frontmatter specifications for all five artifact types: field definitions, type constraints, required vs optional, tool catalog (agents), variable system (prompts), glob patterns (instructions)
- [body-patterns.md](./references/body-patterns.md) — Body structure conventions per artifact type: identity prose (agents), workflow steps (skills), task body (prompts), rule groups (instructions), section layout (copilot-instructions). Includes anti-patterns for each type
- [writing-rules.md](./references/writing-rules.md) — Cross-cutting quality rules for all types: XML conventions, formatting standards, forbidden tags table, canonical vocabulary glossary, P1/P2/P3 validation checks

**Example assets:**

- [example-agent.md](./assets/example-agent.md) — Agent artifact demonstrating identity prose, bullet constraints, workflow, domain tags, and output template
- [example-skill.md](./assets/example-skill.md) — Skill artifact demonstrating prose intro, use cases, workflow steps, error handling, validation, and resources
- [example-prompt.md](./assets/example-prompt.md) — Prompt artifact demonstrating frontmatter, task heading, variable usage, and file references
- [example-instruction.md](./assets/example-instruction.md) — Instruction artifact demonstrating conditional frontmatter, custom XML groups, and bullet rules
- [example-copilot-instructions.md](./assets/example-copilot-instructions.md) — Copilot-instructions artifact demonstrating workspace map, project context, constraints, and agent listing

</resources>
