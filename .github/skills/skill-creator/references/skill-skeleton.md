This file is the structural reference for building `SKILL.md` artifacts. The governing principle is fixed shapes with open content — the tag vocabulary and section order are closed, domain extension happens through step content and reference files.


<tag_vocabulary>

Tags are the skill's structural skeleton — fixed shapes filled with domain processes. 1 required tag, 4 optional tags. No attributes.

- `<workflow>` — Required. Parent container for all steps. Prose intro states execution sequence and governing principle
  - `<step_N_verb>` — Required inside `<workflow>`. Numbered imperative steps (e.g., `<step_1_classify>`, `<step_2_draft>`). Each step is a self-contained action
- `<use_cases>` — Optional. List of use cases this skill addresses. Align triggers with `description` field for discovery consistency
- `<error_handling>` — Optional. List of If/Then statements describing error conditions and recovery actions if applicable to the nature of the skill. If [condition], then [recovery action]
- `<validation>` — Optional. Verifiable checks if applicable to the nature of the skill. Each check is a condition that can be true/false based on observable outputs or state. For Full-tier skills, organize into P1 (blocking), P2 (quality), P3 (polish) severity groups
- `<resources>` — Optional. Include when skill uses additional files. List of links to `references/` and/or `assets/` and/or `scripts/`. Use relative paths (`./`) and markdown link syntax

</tag_vocabulary>


<prose_intro_pattern>

Every skill file opens with 1-3 sentences of prose before the first tag. This intro orients the invoking agent — what, principle, first action.

"This skill [what it does]. The governing principle is [single principle]. Begin with `<step_1_verb>` to [first action]."

**Examples:**

- "This skill creates well-structured SKILL.md files that define reusable processes for AI agents. The governing principle is single-focused capability — each skill solves one specific problem within a standard folder structure. Begin with `<step_1_analyze>` to answer planning questions that orient subsequent steps."
- "This skill scaffolds REST API endpoints with validation and error handling. The governing principle is convention over configuration — standard patterns unless the spec overrides. Begin with `<step_1_analyze>` to determine the API framework and routing style."

</prose_intro_pattern>


<visual_skeleton>

```
.github/skills/<skill-name>/
├── SKILL.md              ← Always present
├── scripts/              ← Executable code (optional)
├── references/           ← JIT-loaded docs (optional)
└── assets/               ← Templates, configs (optional)
```

</visual_skeleton>


<folder_patterns>

Subfolders exist for progressive loading, not organization. Create them only when content signals justify extraction from SKILL.md.

- **`scripts/`** — Code exceeds 20 lines, shell-specific execution, platform-dependent logic, or code that benefits from syntax highlighting and linting
- **`references/`** — Documentation exceeds 100 lines, content is JIT-loaded (not needed every run), decision rules or domain-specific patterns need separation from main flow
- **`assets/`** — Templates, configuration files, boilerplate, example approaches and patterns, non-markdown resources, or example outputs that steps reference

Default to single SKILL.md when all steps are inline-explainable and no JIT content separation benefits exist.

</folder_patterns>


<anti_patterns>

Common mistakes that produce skills that appear functional but fail in practice. Check the final skill against this list before delivery.

**Structural violations:**

- Markdown headings for document structure — use XML tags
- Negative triggers in description ("Don't use when...")

**Resource violations:**

- Orphaned resources — files in subfolders not referenced from SKILL.md, or empty folders created speculatively
- Reference chains — reference files linking to other reference files instead of back to SKILL.md (violates single-hop loading)

**Content violations:**

- Vague descriptions — "A helpful skill" doesn't enable discovery
- Monolithic SKILL.md — everything in one file instead of references
- Name mismatch — folder name doesn't match `name` field
- Missing processes — descriptions without step-by-step instructions
- Forbidden frontmatter — using unsupported YAML fields (tools, model, applyTo, handoffs) that belong to agents, not skills
- Bundling always-on rules — using a skill for rules that apply to most work (conventions, standards) instead of custom instructions

</anti_patterns>
