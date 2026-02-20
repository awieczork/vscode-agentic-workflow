---
name: 'skill-creator'
description: 'Guides creation of complete SKILL.md-based skills with workflow steps, references, and assets. Use when asked to "create a skill", "build a skill", "scaffold a skill", or "make a new skill". Produces a self-contained skill folder with SKILL.md (frontmatter, prose intro, use cases, workflow, error handling, resources manifest) and any supporting reference or asset files.'
---

Follow these steps to create a complete, self-contained skill by studying an exemplar and replicating its patterns for a new domain. The governing principle is exemplar-driven construction — study what works, then adapt the structure to the new skill's purpose. Begin with `<step_1_understand>` to capture intent and validate inputs.


<use_cases>

- Scaffold a deployment skill for CI/CD pipeline automation
- Create an API testing skill for endpoint validation workflows
- Build a documentation generation skill for code-to-docs pipelines
- Add a code review skill for pull request analysis and feedback

</use_cases>


<workflow>

Execute steps sequentially. Each step builds on the previous — intent determines scope, the exemplar informs structure, the spec governs content, generation produces the files, and validation confirms delivery readiness.


<step_1_understand>

Capture the user's intent and validate inputs.

- Determine the **skill name** — must be kebab-case, 1-64 characters, lowercase alphanumeric + hyphens only, no leading or trailing hyphens (e.g., `api-scaffold`, `code-review`, `doc-generator`)
- Determine the **skill purpose** — what problem does this skill solve, what domain does it operate in
- Determine the **skill output** — what artifacts does the skill produce when executed (files, reports, configurations)
- Determine the **target audience** — what kind of agent will execute this skill (developer, researcher, planner, etc.)
- If the name violates naming rules, report the violation and ask the user to provide a valid name
- If the user provides insufficient context to differentiate this skill from a trivial checklist, ask for clarification before continuing

**Output of this step:** skill name, purpose, expected outputs, target agent type, any domain-specific context the user provided.

</step_1_understand>


<step_2_study>

Study the gold-reference exemplar to understand structural patterns.

- Load [exemplar.md](assets/exemplar.md) — study the embedded skill alongside its structural annotations
- Observe how the exemplar handles: frontmatter fields, prose intro with governing principle, use case phrasing, step naming and sequencing, JIT resource loading via markdown links, error handling patterns, and the resources manifest
- Determine how many workflow steps the new skill needs — default is 3-5, adjust based on complexity
- Determine what reference and asset files the new skill needs in subfolders
- Determine what validation approach fits — tiered gates for complex skills, flat checklist for simple ones

</step_2_study>


<step_3_plan>

Apply the structural specification to plan each section of the new skill.

Load [skill-spec.md](references/skill-spec.md) and plan:

- **Frontmatter** — Plan the 2 required fields. `name` matches the skill folder name. `description` follows the three-part formula: what it does, trigger phrases in quotes, key capabilities. Imperative voice ("Guides creation of..." not "Creates...").

- **Prose intro** — 1-3 bare sentences before any XML tag. State the goal, name the governing principle, point to `<step_1_verb>` to begin. Imperative voice throughout.

- **`<use_cases>`** — 3-5 concrete scenarios starting with action verbs. Specific enough to match real requests, general enough to cover domain range.

- **`<workflow>`** — Plan each `<step_N_verb>` sub-tag. Number + imperative verb, not noun form. Each step is self-contained: what to do, what inputs to use, what to produce, when to proceed. Reference subfolder content via markdown links for JIT loading.

- **`<error_handling>`** — Plan if/then recovery rules for predictable failure modes. Include only when the workflow has non-obvious failure paths.

- **`<resources>`** — Plan the manifest listing all subfolder files with relative-path markdown links, grouped by type.

- **Reference extraction** — Decide what goes in SKILL.md vs. subfolders. Content exceeding 100 lines, not needed every run, or containing decision tables belongs in `references/` or `assets/`. The workflow itself stays inline.

</step_3_plan>


<step_4_generate>

Write the complete skill. Generate each section using the plan from step 3.

- **Frontmatter** — YAML between `---` fences. All string values single-quoted. Include `name` and `description` only — skills carry no other frontmatter fields.

- **Prose intro** — Imperative voice, 1-3 sentences. State the goal, name the governing principle, point to the first step. No XML wrapper.

- **`<use_cases>`** — Concrete trigger scenarios as bullets. Each starts with an action verb.

- **`<workflow>`** — Opening preamble explaining step sequencing. Then `<step_N_verb>` sub-tags, each a self-contained action block with purpose statement, concrete sub-actions as bullets, and verification criteria. Reference subfolder content via markdown links when JIT loading is needed.

- **`<error_handling>`** — If/then recovery rules. Bold the failure condition, specify the exact recovery action. Include only non-obvious failure modes.

- **`<resources>`** — Relative-path markdown links grouped by type (References vs Assets). Each entry includes what the file contains and which step loads it.

- **Subfolder files** — Generate any `references/` or `assets/` files the skill needs. Each must be referenced from at least one workflow step or the resources manifest.

The skill must be **self-contained** — reference only files within its own folder tree. Imperative voice throughout. No markdown headings (`#`) in the body. No identity prose — instruct, do not narrate.

Output: the skill folder with SKILL.md and any subfolder files.

</step_4_generate>


<step_5_validate>

Quality-check the generated skill against all validation gates.

Load [quality-gates.md](references/quality-gates.md) and run each tier:

- **P1 — Blocking** (fix before delivery):
  - `name` and `description` present in frontmatter
  - Name matches parent folder in kebab-case
  - File named `SKILL.md` (uppercase)
  - All YAML string values single-quoted
  - `<workflow>` tag present in body
  - No platform-reserved tags in body
  - No secrets or absolute paths
  - SKILL.md is 500 lines or fewer

- **P2 — Quality** (fix before finalizing):
  - Description is keyword-rich with trigger phrases — not generic filler
  - All XML tags use `snake_case` with domain-specific names
  - Step tags follow `step_N_verb` pattern with domain verbs
  - All markdown-linked files exist in subfolders
  - No orphaned files in `assets/` or `references/`
  - Prose intro present before first XML tag
  - No identity prose — imperative voice only

- **P3 — Polish** (flag as suggestions):
  - Active voice throughout — no hedging ("try to", "should")
  - Governing principle stated in prose intro
  - Concise — no verbose padding
  - Error handling covers likely failure modes

- **Banned patterns scan** — Check for drive letters, bare `#tool:` references, hard-coded model names, identity prose, filler phrases, temporal language

- **Self-containment verification**:
  - No references to files outside the skill folder tree
  - No platform-reserved XML tags
  - No orphaned subfolder files
  - Skill is readable and executable without knowledge of other skills or external artifacts

Fix all P1 and P2 issues. Report P3 suggestions to the user. If P1 fixes require structural changes, return to `<step_4_generate>`.

</step_5_validate>


</workflow>


<error_handling>

Recovery actions for common failure modes. Apply the matching recovery when an issue surfaces during any step.

- If the user provides a **skill concept that is too broad** (e.g., "make a skill for everything about security") — assess whether the concept is actually an instruction (always-on rules) rather than a task-specific skill — if so, redirect to an instruction file instead
- If the user provides **insufficient context** to differentiate the skill from a trivial checklist — ask targeted questions: What specific workflow does this skill guide? What artifacts does it produce? What failure modes should it handle?
- If **P1 validation failures** are found in step 5 — return to `<step_4_generate>` and fix the specific violations — do not regenerate the entire skill unless structural issues require it
- If **SKILL.md exceeds 500 lines or is too short to be useful** — review for content to extract to `references/` or `assets/` subfolders (if too long) or missing sections to expand (if too short) — a well-scoped skill typically runs 100-300 lines
- If the user asks for a **non-skill artifact type** (agent, instruction, prompt) — identify the correct artifact type and redirect to the appropriate creator skill or workflow

</error_handling>


<resources>

Reference files loaded on demand during workflow steps. All paths are relative to the skill folder.

**References:**

- [skill-spec.md](references/skill-spec.md) — Skill structural specification: frontmatter fields, body structure, progressive loading, folder layout, and design guidelines. Loaded in step 3.
- [quality-gates.md](references/quality-gates.md) — Validation tiers (P1/P2/P3), banned patterns, platform-reserved tags, and skill anti-patterns. Loaded in step 5.

**Assets:**

- [exemplar.md](assets/exemplar.md) — Annotated gold-reference skill (agent-creator SKILL.md) with structural observations. Loaded in step 2.

</resources>
