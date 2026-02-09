This file is the structural reference for building `SKILL.md` artifacts. The governing principle is fixed shapes with open content — the tag vocabulary and section order are closed, domain extension happens through step content and reference files.


<tag_vocabulary>

Tags are the skill's structural skeleton — fixed shapes filled with domain procedures. 1 required tag, 4 optional tags. No attributes.

- `<workflow>` — Required. Parent container for all steps. Prose intro states execution sequence and governing principle
  - `<step_N_verb>` — Required inside `<workflow>`. Numbered imperative steps (e.g., `<step_1_classify>`, `<step_2_draft>`). Each step is a self-contained action
- `<use_cases>` — Optional. List of use cases this skill addresses. Align triggers with `description` field for discovery consistency
- `<error_handling>` — Optional. List of If/Then statements describing error conditions and recovery actions if applicable to the nature of the skill. If [condition], then [recovery action]
- `<validation>` — Optional. Verifiable checks if applicable to the nature of the skill. Each check is a condition that can be true/false based on observable outputs or state
- `<resources>` — Optional. Include when skill uses additional files. List of links to `references/` and/or `assets/` and/or `scripts/`. Use relative paths (`./`) and markdown link syntax

</tag_vocabulary>


<prose_intro_pattern>

Every skill file opens with 1-3 sentences of prose before the first tag. This intro orients the invoking agent — what, principle, first action.

"This skill [what it does]. The governing principle is [single principle]. Begin with `<step_1_verb>` to [first action]."

**Examples:**

- "This skill creates well-structured SKILL.md files that define reusable procedures for AI agents. The governing principle is single-focused capability — each skill solves one specific problem within a standard folder structure. Begin with `<step_1_analyze>` to answer planning questions that orient subsequent steps."
- "This skill scaffolds REST API endpoints with validation and error handling. The governing principle is convention over configuration — standard patterns unless the spec overrides. Begin with `<step_1_analyze>` to determine the API framework and routing style."

</prose_intro_pattern>


<visual_skeleton>

The visual layout shows section order at a glance. Use this as a structural checklist when assembling the final skill file.

```
┌─────────────────────────────────────┐
│  FRONTMATTER (YAML)                 │  ← Discovery phase (~100 tokens)
│  name, description                  │
├─────────────────────────────────────┤
│  PROSE INTRO (no tag)               │  ← Purpose + governing principle
├─────────────────────────────────────┤
│  <use_cases>                        │  ← Optional
├─────────────────────────────────────┤
│  <workflow>                         │  ← Required
│  ├── <step_1_verb>                  │
│  ├── <step_2_verb>                  │
│  └── <step_N_verb>                  │
├─────────────────────────────────────┤
│  <error_handling>                   │  ← Optional
├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┤
│  <validation> (optional)            │
│  <resources> (optional)             │
└─────────────────────────────────────┘
```

Folder structure alongside:

```
.github/skills/<skill-name>/
├── SKILL.md              ← Always present
├── scripts/              ← Executable code (optional)
├── references/           ← JIT-loaded docs (optional)
└── assets/               ← Templates, configs (optional)
```

</visual_skeleton>


<scaling>

Not every skill needs every tag. Match structural complexity to the skill's scope — simple skills stay minimal; multi-resource skills use the full vocabulary.

**Minimal skill (~30 lines body):** Single SKILL.md, no subfolders.

- Frontmatter: `name`, `description`
- Prose intro: 2-3 sentences
- `<use_cases>` — 2-3 use cases aligned with discovery description
- `<workflow>` — 3-5 `<step_N_verb>` tags
- All steps inline — no subfolders

**Medium skill (~80 lines body):** SKILL.md + `references/` subfolder.

- All minimal sections
- `<error_handling>` — 3-5 failure modes with recovery actions
- `<validation>` — 2-4 verifiable success conditions
- `<resources>` — Links to extracted reference files
- Extract decision rules, domain patterns, or documentation exceeding 100 lines into `references/`
- Use `Load [file] for:` directives in steps that need JIT content

**Full skill (~150 lines body):** All subfolders.

- All medium sections
- `scripts/` — Executable code exceeding 20 lines, platform-dependent logic
- `assets/` — Templates, configuration files, example outputs referenced by steps
- `<workflow>` — 5-8 `<step_N_verb>` tags
- Progressive loading across all three subfolders — SKILL.md stays under 500 lines

</scaling>


<folder_patterns>

Subfolders exist for progressive loading, not organization. Create them only when content signals justify extraction from SKILL.md.

- **`scripts/`** — Code exceeds 20 lines, shell-specific execution, platform-dependent logic, or code that benefits from syntax highlighting and linting
- **`references/`** — Documentation exceeds 100 lines, content is JIT-loaded (not needed every run), decision rules or domain-specific patterns need separation from main flow
- **`assets/`** — Templates, configuration files, boilerplate, example approaches and patterns, non-markdown resources, or example outputs that steps reference

Default to single SKILL.md when all steps are inline-explainable and no JIT content separation benefits exist.

</folder_patterns>


<core_principles>

7 design rules shape skill structure — violating any one produces skills that degrade under real usage.

- **Progressive loading** — Frontmatter costs ~100 tokens. Full SKILL.md loads on invocation. Reference files load on demand. Keep SKILL.md under 500 lines; extract to `references/` when content exceeds 100 lines. Use `Load [file] for:` to trigger JIT context loading
- **Single capability** — One skill solves one problem. Multiple capabilities split into separate skills. Include all procedural knowledge to complete the task
- **Agent-agnostic** — No identity, stance, or behavioral configuration. Any agent invokes with the same result
- **XML structure** — Use XML tags as exclusive structure, no markdown headings
- **Relative paths** — Reference skill resources with `./` prefix
- **Precision matches risk** — Calibrate step specificity to operation risk: text for non-destructive ops, exact commands for destructive/irreversible ops
- **Keyword-rich descriptions** — Include trigger words and use-case phrases in `description` so discovery phase matches user prompts effectively

</core_principles>


<anti_patterns>

Common mistakes that produce skills that appear functional but fail in practice. Check the final skill against this list before delivery.

**Agent tags that must not appear in skills:**

- `<constraints>`, `<behaviors>`, `<outputs>`, `<termination>` — Agent top-level structure
- `<iron_law>`, `<mode>`, `<context_loading>`, `<on_missing>`, `<when_blocked>` — Agent sub-tags
- Identity prose (role, expertise, stance, anti-identity) — Agent behavioral identity

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
- Missing procedures — descriptions without step-by-step instructions
- Forbidden frontmatter — using unsupported YAML fields (tools, model, applyTo, handoffs) that belong to agents, not skills
- Bundling always-on rules — using a skill for rules that apply to most work (conventions, standards) instead of custom instructions

</anti_patterns>
