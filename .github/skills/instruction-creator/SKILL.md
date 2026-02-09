---
name: 'instruction-creator'
description: 'Creates and refactors .instructions.md files that define ambient constraints for AI agent behavior. Use when asked to "create an instruction", "refactor an instruction", "update coding standards", "improve an instruction file", or "add project conventions". Produces conditional frontmatter, custom XML groups with bullet rules, and validated output.'
---

This skill creates well-structured .instructions.md files that define ambient constraints shaping AI agent behavior. The governing principle is ambient constraints without identity — instructions carry rules, not personas. Begin with `<step_1_analyze>` to determine sub-type and orient subsequent steps.


<use_cases>

- Create a new instruction file from coding standards or project conventions
- Build file-type-specific rules that auto-attach when matching files appear in context
- Define repo-wide conventions applied to every chat request
- Create on-demand domain rules discoverable by task relevance
- Convert existing coding rules into instruction files

</use_cases>


<workflow>

Execute steps sequentially. Each step verifies its own output before proceeding to the next.


<step_1_analyze>

Answer the following questions about the target instruction. Each answer informs decisions in subsequent steps — incomplete answers produce gaps in the final artifact.

- **What is this?** — Platform metadata (name, description, glob patterns) enables discovery and matching
- **What does the instruction accomplish?** — Purpose statement orients the scope: repo-wide standards, file-type rules, or domain rules
- **Which sub-type?** — Repo-wide, path-specific file-triggered, or path-specific on-demand — determines frontmatter, location, and discovery mode
- **What rules does it contain?** — Custom `<group_name>` tags wrapping bullet rules — one concern per group, domain-specific names
- **How does discovery work?** — No frontmatter (repo-wide), `applyTo` + `description` (file-triggered), `description` only (on-demand)
- **What must it NOT contain?** — Anti-contamination: no identity prose, no stance words, no tools, no variables, no agent/skill tags

</step_1_analyze>


<step_2_determine_structure>

Load [instruction-skeleton.md](./references/instruction-skeleton.md) for: `<sub_type_decision>`, `<scaling>`, `<core_principles>`.

Determine sub-type using `<sub_type_decision>` in [instruction-skeleton.md](./references/instruction-skeleton.md):

- Rules apply to ALL chat requests regardless of file type? → **Repo-wide**
- Rules apply only when specific file patterns appear in context? → **Path-specific file-triggered**
- Rules apply when agent detects task relevance from description keywords? → **Path-specific on-demand**

Select scaling tier based on the instruction's scope and rule count:

- **Minimal** (~15 lines body) — 1 group, 3-5 bullet rules, no examples
- **Standard** (~50 lines body) — 2-3 groups with bullet rules + Wrong/Correct pairs
- **Full** (~100-150 lines body) — 3-5 groups, all with rules and examples

Evaluate splitting: ~100 lines for path-specific, ~150 lines for repo-wide. Split by file type when rules serve different extensions; split by concern when rules cover distinct domains.

Finalize: sub-type selected, scaling tier, group count, split decision.

</step_2_determine_structure>


<step_3_write_frontmatter>

Load [instruction-frontmatter-contract.md](./references/instruction-frontmatter-contract.md) for: `<frontmatter_fields>`, `<repo_wide_exception>`, `<discovery_mode_guidance>`, `<description_rules>`.

Apply sub-type from `<step_2_determine_structure>`:

- **Repo-wide** → Produce NO frontmatter. No `---` YAML block — content begins immediately with prose. Location: `.github/copilot-instructions.md`
- **Path-specific file-triggered** → `applyTo` + `description` required. Use `<glob_pattern_guidance>` in [instruction-frontmatter-contract.md](./references/instruction-frontmatter-contract.md) for valid glob syntax. Location: `.github/instructions/[DOMAIN].instructions.md`
- **Path-specific on-demand** → `description` only required. Location: `.github/instructions/[DOMAIN].instructions.md`

**Description patterns** per `<description_rules>` in [instruction-frontmatter-contract.md](./references/instruction-frontmatter-contract.md):

- File-triggered: `'[DOMAIN] [CONSTRAINT_TYPE] for [SCOPE]'`
- On-demand: `'Use when [TASK]. [SUMMARY].'`

Validate: description 50-150 characters, keyword-rich, single-line. All YAML string values in single quotes.

</step_3_write_frontmatter>


<step_4_write_body>

Load [instruction-skeleton.md](./references/instruction-skeleton.md) for: `<prose_intro_pattern>`, `<body_structure>`, `<anti_patterns>`.

Load [example-repo-wide.md](./assets/example-repo-wide.md) or [example-path-specific.md](./assets/example-path-specific.md) for: annotated reference output matching the selected sub-type.

**Prose intro** — follow `<prose_intro_pattern>` in [instruction-skeleton.md](./references/instruction-skeleton.md):

- Repo-wide: "This project follows [principle]. [Primary constraint]. [Scope statement]."
- Path-specific: "This file defines [domain] rules for [scope]. The governing principle is [principle]."

**Body groups** — custom `<group_name>` tags per `<body_structure>` in [instruction-skeleton.md](./references/instruction-skeleton.md):

- Use domain-specific tag names: `<naming_conventions>`, `<error_handling>`, `<type_safety>` — never generic names
- Bullet rules directly inside each group tag — imperative voice, one rule per bullet
- Optional Wrong/Correct pairs inline — contrast examples with em-dash
- Optional `<example>` sub-tags for complex code demonstrations
- Markdown links to reference files and URLs where applicable

**Anti-contamination** — verify against `<anti_patterns>` in [instruction-skeleton.md](./references/instruction-skeleton.md):

- No identity prose: "You are...", role statements, expertise declarations
- No stance words: "thorough", "cautious", "creative", "helpful"
- No prompt variables: `${input:}`, `${selection}`, `${file}`
- No agent tags: `<constraints>`, `<behaviors>`, `<outputs>`, `<termination>`, `<iron_law>`, `<mode>`
- No skill tags: `<workflow>`, `<step_N_verb>`, `<use_cases>`, `<resources>`
- No markdown headings — XML tags are exclusive structure

</step_4_write_body>


<step_5_validate>

Run `<validation>` checks against the completed instruction. Fix all P1 and P2 findings before delivery; flag P3 items without blocking. If any check fails, consult `<error_handling>` for recovery actions.

</step_5_validate>


</workflow>


<error_handling>

- If sub-type is ambiguous between file-triggered and on-demand, then prefer file-triggered with `applyTo` + `description` for dual discovery
- If repo-wide instruction contains frontmatter, then remove `---` YAML block — P1 blocker
- If agent contamination detected (`<constraints>`, `<behaviors>`, `<outputs>`, `<termination>`, `<iron_law>`, `<mode>` tags), then remove offending content — P1 blocker
- If skill contamination detected (`<workflow>`, `<step_N_verb>`, `<use_cases>`, `<resources>` tags), then remove offending content — P1 blocker
- If identity prose or stance words detected, then remove and rephrase as imperative rules — P1 blocker
- If prompt variables detected (`${input:}`, `${selection}`, `${file}`), then remove — P1 blocker
- If markdown headings used as structure, then convert to XML group tags — P1 blocker
- If `applyTo` uses regex instead of glob syntax, then convert to valid glob pattern
- If instruction exceeds split threshold (~100 lines path-specific, ~150 lines repo-wide), then evaluate splitting by file type or concern

</error_handling>


<validation>

**P1 — Blocking (fix before delivery):**

- Sub-type correctly determines frontmatter presence/absence
- Repo-wide variant produces NO frontmatter — no `---` YAML block
- Path-specific file-triggered has both `applyTo` and `description` in frontmatter
- Path-specific on-demand has `description` only in frontmatter
- All YAML string values wrapped in single quotes: `description: 'value'`, `applyTo: '**/*.ts'`
- `description` follows correct pattern for sub-type per `<description_rules>` in [instruction-frontmatter-contract.md](./references/instruction-frontmatter-contract.md)
- No agent tags in output: `<constraints>`, `<behaviors>`, `<outputs>`, `<termination>`, `<iron_law>`, `<mode>`, `<context_loading>`, `<on_missing>`, `<when_blocked>`
- No skill tags in output: `<workflow>`, `<step_N_verb>`, `<use_cases>`, `<resources>`
- No identity prose in output: "You are...", role statements, expertise declarations
- No stance words in output: "thorough", "cautious", "creative", "helpful"
- No prompt variables in output: `${input:}`, `${selection}`, `${file}`
- No markdown headings — XML tags are exclusive structure
- Body uses custom grouped format: `<group_name>` with bullet rules directly inside
- No hardcoded secrets or absolute paths

**P2 — Quality (fix before delivery):**

- `applyTo` uses valid glob syntax, not regex
- No markdown tables — use bullet lists with em-dash definitions
- Anti-contamination enforced: no cross-artifact-type patterns
- Groups use domain-specific names, not generic (`<naming_conventions>` not `<section_1>`)
- One concern per file — no mixing of unrelated domains
- Rules use imperative voice: "Use X" not "You should use X"
- Specific quantities: "Maximum 3 levels" not "Avoid deep nesting"
- One rule per bullet — no compound rules
- Cross-file XML tag references use linked-file form: `<tag>` in [file.md](path)
- Every `Load [file] for:` directive resolves to an existing file
- No orphaned resources — every file in subfolders referenced from SKILL.md

**P3 — Polish (flag, do not block):**

- ALWAYS/NEVER count: 2-5 per file for safety-critical rules
- Wrong/Correct pairs present for ambiguous rules
- Token economy: no redundant rules across groups
- Markdown links reference relevant files and docs
- Prose intro follows `<prose_intro_pattern>` in [instruction-skeleton.md](./references/instruction-skeleton.md) for sub-type
- Active voice throughout, no hedging
- Every file in the skill folder opens with a prose intro containing governing principle

</validation>


<resources>

- [instruction-frontmatter-contract.md](./references/instruction-frontmatter-contract.md) — Defines YAML frontmatter fields for .instructions.md files with conditional presence rules per sub-type. Covers the repo-wide exception (no frontmatter), discovery mode selection, description patterns, and glob syntax for `applyTo`. Load for `<frontmatter_fields>`, `<repo_wide_exception>`, `<discovery_mode_guidance>`, `<description_rules>`, `<glob_pattern_guidance>`
- [instruction-skeleton.md](./references/instruction-skeleton.md) — Structural reference for .instructions.md body sections. Defines the 3 sub-types, scaling tiers, custom grouped body format, and anti-contamination patterns. Load for `<sub_type_decision>`, `<scaling>`, `<body_structure>`, `<prose_intro_pattern>`, `<core_principles>`, `<anti_patterns>`
- [example-repo-wide.md](./assets/example-repo-wide.md) — Ready-to-use repo-wide instruction with no frontmatter, 2 custom groups, and Wrong/Correct pairs. Demonstrates the prose intro + grouped body format for universal project rules
- [example-path-specific.md](./assets/example-path-specific.md) — Ready-to-use path-specific file-triggered instruction for TypeScript files. Demonstrates `applyTo` + `description` frontmatter, single group, and ALWAYS/NEVER usage

</resources>
