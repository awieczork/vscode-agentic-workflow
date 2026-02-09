---
name: 'skill-creator'
description: 'Creates and refactors SKILL.md files that define reusable multi-step processes for AI agents. Use when asked to "create a skill", "build a skill", "refactor a skill", "update a skill", "improve a SKILL.md", or "scaffold a skill folder". Produces folder structure, YAML frontmatter, numbered workflow steps, error handling, and validation checks.'
---

This skill creates well-structured SKILL.md files that define reusable procedures for AI agents. The governing principle is single-focused capability — each skill solves one problem within a standard folder structure. Begin with `<step_1_analyze>` to answer planning questions that orient subsequent steps.


<use_cases>

- Create a new skill from a requirements description or approved spec
- Build a reusable multi-step process that any agent can invoke for a specific task
- Scaffold a skill folder with SKILL.md, references, and assets
- Convert a repeatable multi-step process into a standardized skill artifact

</use_cases>


<workflow>

Execute steps sequentially. Each step verifies its own output before proceeding to the next.


<step_1_analyze>

Answer the following questions about the target skill. Each answer informs decisions in subsequent steps — incomplete answers produce gaps in the final artifact.

- **What is this?** — Platform metadata enables discovery and matching
- **What does the skill accomplish?** — A clear purpose statement orients every agent that invokes it
- **When should it be used?** — Trigger phrases and use cases drive accurate skill selection
- **How does it work?** — Step-by-step procedures are the skill's core value
- **What resources does it use?** — External files need explicit references and relative paths
- **What can go wrong?** — Known error conditions prevent agents from stalling on errors
- **How to verify it worked?** — Observable success conditions confirm the skill completed correctly

</step_1_analyze>


<step_2_determine_structure>

Load [skill-skeleton.md](./references/skill-skeleton.md) for: `<scaling>`, `<folder_patterns>`, `<core_principles>`.

Select scaling tier based on the skill's scope and content volume:

- **Minimal** (~30 lines body) — no subfolders, 3-5 steps, all inline
- **Medium** (~80 lines body) — `references/` subfolder, 4-6 steps, `<error_handling>` + `<validation>`
- **Full** (~150 lines body) — all subfolders, 5-8 steps, progressive loading

Apply folder creation thresholds from `<folder_patterns>` in [skill-skeleton.md](./references/skill-skeleton.md):

- `scripts/` — code exceeds 20 lines, platform-dependent logic
- `references/` — documentation exceeds 100 lines, JIT-loaded content
- `assets/` — templates, configs, example outputs referenced by steps

Validate planned folder structure against actual content needs. Override if content signals do not justify a subfolder. Never create empty folders.

Finalize: tier selected, folder list, step count range.

</step_2_determine_structure>


<step_3_write_frontmatter>

Load [skill-frontmatter-contract.md](./references/skill-frontmatter-contract.md) for: `<name_rules>`, `<description_rules>`, `<frontmatter_fields>`.

**Name:**

1. Derive from the skill's intended capability
2. Validate against `<name_rules>` in [skill-frontmatter-contract.md](./references/skill-frontmatter-contract.md): lowercase alphanumeric + hyphens, 1-64 chars, no leading/trailing hyphens
3. Confirm name matches target folder: `.github/skills/[name]/SKILL.md`
4. If invalid → suggest corrected format, apply, continue

**Description:**

1. Build using `<description_rules>` in [skill-frontmatter-contract.md](./references/skill-frontmatter-contract.md): `[What it does]. Use when [trigger phrases]. [Key capabilities].`
2. Derive trigger phrases from the skill's capabilities — convert to user-facing language
3. Include 2-4 trigger phrases in quotes
4. Validate: ≤1024 characters, single-line, no XML tags, no negative triggers

</step_3_write_frontmatter>


<step_4_write_body>

Load [skill-skeleton.md](./references/skill-skeleton.md) for: `<tag_vocabulary>`, `<prose_intro_pattern>`, `<visual_skeleton>`.

Load [example-skill.md](./assets/example-skill.md) for: annotated reference output.

**Prose intro** — follow `<prose_intro_pattern>` in [skill-skeleton.md](./references/skill-skeleton.md): "This skill [what]. The governing principle is [principle]. Begin with `<step_1_verb>` to [first action]."

**`<use_cases>`** — 3-5 use cases aligned with description trigger phrases. Each use case is one line describing when to invoke.

**`<workflow>`** — numbered `<step_N_verb>` steps:

- Estimate step count from the skill's scope (may adjust)
- Name each step with imperative verb: `<step_N_verb>`
- Derive step content from the skill's required capabilities — one capability per step or logical grouping
- Include `Load [file] for:` directives where JIT loading applies
- Calibrate step precision to risk: text for non-destructive ops, exact commands for destructive ops

**`<error_handling>`** — Identify error conditions and express as If/Then format:

- If [condition], then [recovery action]
- Include ≥3 error conditions — scale count to skill complexity
- Cover: type mismatch, missing required fields, name format invalid, validation error, orphaned resources

**`<validation>`** — 3-5 verifiable boolean conditions:

- Each check is true/false based on observable output
- Cover: frontmatter valid, name matches folder, no agent tags, no markdown headings, description follows formula

**`<resources>`** — link all reference and asset files with relative `./` paths.

**Reference files** — for medium and full tier skills:

- Create files in `references/` subfolder
- Extract content exceeding 100 lines from SKILL.md body
- Verify no reference chains (references link back to SKILL.md, not to each other)
- Update relative paths to work from new location

**Asset files** — for full tier skills:

- Create templates and examples in `assets/` subfolder
- Each asset is referenced by at least one step

</step_4_write_body>


<step_5_validate>

Run `<validation>` checks against the completed skill. Fix all P1 and P2 findings before delivery; flag P3 items without blocking. If any check fails, consult `<error_handling>` for recovery actions.

</step_5_validate>


</workflow>


<error_handling>

- If `name` format is invalid, then suggest corrected format (e.g., `My Skill` → `my-skill`), apply correction, continue
- If description exceeds 1024 characters, then trim to essential content preserving formula structure, flag trimming in output
- If source URL is unreachable, then skip source, note: "Source [url] unreachable — proceeding without", continue
- If agent contamination detected in output (identity/safety/boundaries tags), then remove offending content — this is a P1 blocker
- If planned subfolder has no content to justify it, then do not create empty folder, override suggestion
- If reference file exceeds 500 lines, then split into focused reference files, each under 500 lines

</error_handling>


<validation>

**P1 — Blocking (fix before delivery):**

- `name` + `description` present in frontmatter, both single-line strings
- All YAML string values wrapped in single quotes: `name: 'value'`, `description: 'value'`
- `name` matches parent folder name exactly
- Name format: `[a-z0-9]+(-[a-z0-9]+)*`, 1-64 chars
- Description follows `<description_rules>` in [skill-frontmatter-contract.md](./references/skill-frontmatter-contract.md): `[What] + [When] + [Capabilities]`, ≤1024 chars, no negative triggers
- No unsupported frontmatter fields (no `tools`, `model`, `applyTo`, `handoffs`)
- `<workflow>` present with numbered `<step_N_verb>` tags
- No hardcoded secrets or absolute paths
- No references to specific agents (`@agentname`) — skill is agent-agnostic

**P2 — Quality (fix before delivery):**

- No markdown headings — XML tags are exclusive structure
- No markdown tables outside `<resources>` — use bullet lists with em-dash definitions
- No agent tags: `<constraints>`, `<behaviors>`, `<outputs>`, `<termination>`, `<iron_law>`, `<mode>`, `<context_loading>`
- No identity prose (role, expertise, stance, anti-identity)
- Description 1-1024 characters with 2-4 trigger phrases
- Every `Load [file] for:` directive resolves to an existing file
- No orphaned resources — every file in subfolders referenced from SKILL.md
- No reference chains — reference files do not link to other reference files
- Cross-file XML tag references use linked-file form: `<tag>` in [file.md](path) — same-file references use backticks only
- `<resources>` entries use XML tag references consistent with Load directives in workflow steps
- Numeric thresholds in workflow steps do not contradict thresholds in reference files

**P3 — Polish (flag, do not block):**

- Prose intro follows `<prose_intro_pattern>` in [skill-skeleton.md](./references/skill-skeleton.md) exactly
- Steps use imperative verbs
- `<use_cases>` align with description triggers
- Active voice throughout, no hedging
- Every file in the skill folder opens with a prose intro containing governing principle

</validation>


<resources>

- [skill-frontmatter-contract.md](./references/skill-frontmatter-contract.md) — Defines the two YAML frontmatter fields for SKILL.md files (name and description) with format validation rules and the description formula for trigger-phrase construction. Load for `<frontmatter_fields>`, `<description_rules>`, `<name_rules>`
- [skill-skeleton.md](./references/skill-skeleton.md) — Structural reference for SKILL.md body sections. Defines the closed tag vocabulary, scaling tiers (minimal/medium/full), folder extraction thresholds, and design rules that shape skill structure. Load for `<tag_vocabulary>`, `<prose_intro_pattern>`, `<visual_skeleton>`, `<scaling>`, `<folder_patterns>`, `<core_principles>`, `<anti_patterns>`
- [example-skill.md](./assets/example-skill.md) — Ready-to-use API scaffold skill at medium scaling tier (~80 lines body). Demonstrates workflow steps, error handling, validation checks, and linked-file XML tag references

</resources>
