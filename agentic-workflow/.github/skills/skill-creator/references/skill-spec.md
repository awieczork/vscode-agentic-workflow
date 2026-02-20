Structural specification for skill artifacts (`SKILL.md`). Covers frontmatter fields, body structure, progressive loading architecture, folder layout, and design principles. Skill-only — no other artifact types.


<frontmatter>

Skill frontmatter is YAML between `---` fences. All string values use single quotes. Both fields are required — no optional fields exist for skills.

- **`name`** (string, required) — Lowercase alphanumeric + hyphens, 1-64 chars. Must match parent folder name exactly
- **`description`** (string, required) — What it does and when to use it. Max 1024 chars. Drives skill discovery via semantic matching

**Name rules**

- Lowercase alphanumeric + hyphens only — no underscores, spaces, or uppercase
- Must match parent folder: `skills/api-scaffold/SKILL.md` → `name: 'api-scaffold'`
- No leading or trailing hyphens
- Valid: `api-scaffold`, `webapp-testing`, `code-review`
- Invalid: `API_Scaffold`, `my skill`, `-leading-hyphen`

**Description formula**

VS Code matches descriptions to user intent via LLM semantic similarity — not exact string matching. Descriptions must use the words users actually say, not framework jargon.

**Pattern:** `[What it does]. Use when [trigger phrases]. [Key capabilities].`

- Include 2-4 trigger phrases in quotes — these are the semantic activation anchors
- List at least 3 concrete capabilities
- Stay under 1024 characters
- No negative triggers, no XML tags
- Voice is imperative: "Guides creation of…" not "Creates…" — the skill instructs, it doesn't act

**Example**

```yaml
---
name: 'api-scaffold'
description: 'Guides creation of REST API endpoints. Use when asked to "scaffold an API", "create an endpoint", or "add a route". Produces route handlers, validation schemas, error middleware, and integration tests.'
---
```

</frontmatter>


<body_structure>

Skill bodies follow a fixed sequence: prose intro → optional `<use_cases>` → required `<workflow>` → optional `<error_handling>` → optional `<validation>` → `<resources>`. No markdown headings (`#`) in the body.

**Prose intro** — 1-3 sentences of bare prose before any tag. No XML wrapper. Pattern: "Follow these steps to [what it does]. The governing principle is [principle]. Begin with `<step_1_verb>` to [first action]." The prose intro grounds the executing agent — it states what the skill achieves and how to start.

**`<use_cases>`** — Optional. Aligns trigger language with the skill's scope. List concrete scenarios as bullets — "When a user asks to…" or "When the task involves…". Helps the executing agent confirm the skill applies before beginning the workflow.

**`<workflow>`** — Required parent container. Opens with a prose paragraph describing the execution sequence and any assumptions about what the agent has access to. Contains `<step_N_verb>` sub-tags — numbered imperative steps.

Step naming convention:

- Format: `<step_N_verb>` — number + imperative verb + noun
- The verb describes the action; the noun describes the target
- Examples: `<step_1_analyze>`, `<step_2_draft>`, `<step_3_validate>`
- Anti-pattern: `<step_1_analysis>` — noun form obscures the action

Each step is a self-contained action block:

- States what to do, what inputs to use, what to produce
- Includes verification criteria before proceeding to the next step
- References subfolder content via markdown links when JIT loading is needed
- Steps are imperative — the skill tells the agent what to do, not what the skill does

**`<error_handling>`** — Optional. If/then recovery rules for predictable failure modes. Format: "If [condition], then [recovery action]." Only include when the workflow has non-obvious failure paths that the agent wouldn't handle by default.

**`<validation>`** — Optional. Verifiable checks for the skill's output. For complex skills, organize into priority tiers:

- P1 — Must pass. Violations block delivery
- P2 — Fix before finalizing. Violations require justification
- P3 — Nice to have. Violations noted but accepted

Only use tiered validation when the skill produces artifacts with multiple quality dimensions. Simple skills can use a flat bullet list or omit validation entirely.

**`<resources>`** — Lists subfolder files available for JIT loading. Each entry is a relative-path markdown link with a brief description of what it contains and which step references it. This section serves as a manifest — the agent consults it to find supporting content without scanning the filesystem.

</body_structure>


<progressive_loading>

Skills load in three tiers, each adding detail only when needed. This keeps token cost low — agents pay for what they use.

**Tier 1: Discovery** — Name + description from frontmatter only (~100 tokens). This is all VS Code reads when matching user intent to available skills. The description is the skill's entire sales pitch at this stage — if it doesn't contain the right semantic anchors, the skill never gets selected.

**Tier 2: Instructions** — The full SKILL.md body loads when the skill is activated (<5K tokens target). This gives the executing agent the complete workflow, validation criteria, and resource manifest. The body must be sufficient to begin work — an agent can start executing after reading only the SKILL.md file.

**Tier 3: Resources** — Supporting files from `references/`, `assets/`, and `scripts/` subfolders load on demand when a workflow step explicitly calls for them. A step references a resource via markdown link; the agent reads it at that point in execution. Resources are never pre-loaded — they enter the context window only when their step arrives.

**When to extract to a subfolder**

Move content out of SKILL.md into a subfolder file when any of these apply:

- The content exceeds 100 lines
- The content is not needed on every run of the skill
- The content contains decision rules or reference tables that would clutter the workflow narrative
- The content is a template, example output, or non-markdown asset

Content that stays in SKILL.md:

- The workflow itself — steps must be inline, never extracted
- Short validation checklists (under ~30 items)
- Error handling rules (typically compact)
- The resource manifest

The goal is a SKILL.md that an agent can read in one pass and begin working, with deeper reference material available on demand.

</progressive_loading>


<folder_structure>

Every skill lives in its own folder. The folder name must match the skill's `name` field exactly.

```
skills/
  my-skill/
    SKILL.md              ← Required. Workflow and instructions
    references/           ← Optional. JIT-loaded documentation
      decision-rules.md
      domain-patterns.md
    assets/               ← Optional. Templates and examples
      output-template.md
      config-sample.json
    scripts/              ← Optional. Executable code
      validate.py
```

**SKILL.md** — The only required file. Contains frontmatter, prose intro, workflow, and resource manifest. Target: under 500 lines. If the file grows beyond this, extract reference material to subfolders.

**`references/`** — Documentation that supports specific workflow steps: decision rules, domain specifications, structural patterns, quality gates. Files here are markdown prose loaded when a step needs them. One level deep — reference files do not link to other reference files. Each reference file loads independently.

**`assets/`** — Non-workflow content: templates, exemplar outputs, configuration samples, example files the skill produces. These are concrete artifacts the agent uses as models, not instructions it follows.

**`scripts/`** — Executable code that a workflow step runs: validation scripts, generators, transformation logic. Extract to scripts when code exceeds ~20 lines or contains platform-dependent logic.

**Constraints**

- Reference files are one level deep — no reference-to-reference chains
- Every file in a subfolder must be referenced from at least one workflow step or the resource manifest — no orphaned files
- SKILL.md stays under 500 lines total
- Folder name matches the `name` frontmatter field exactly

</folder_structure>


<design_guidelines>

Principles governing well-crafted skill artifacts. These are the design philosophy behind structural decisions — not a checklist.

**Skills instruct, they don't act** — A skill is a recipe, not a chef. It guides the AI through a process but does not perform the work itself. Prose voice is imperative: "Classify the request" not "The skill classifies the request." The subject is always the executing agent, not the skill document.

**Self-containment is non-negotiable** — A skill can only reference files within its own folder tree. No links to files outside the skill directory, no assumptions about what else exists in the workspace. If content is needed, embed it or place it in a subfolder. Runtime workspace reads (searching for project files during execution) are acceptable — static references to external artifacts are not.

**Descriptions are semantic triggers** — VS Code discovers skills through LLM semantic similarity matching. The description must contain the words users actually say when they need this skill. Trigger phrases in quotes ("create an agent", "scaffold a skill") are semantic anchors that increase match probability. Framework jargon decreases it.

**Progressive disclosure reduces cost** — Not every token needs to load on every run. The three-tier model (discovery → instructions → resources) ensures agents pay only for what the current execution needs. Extract aggressively — if content isn't needed every run, it belongs in a subfolder.

**Sections earn their keep** — Every XML section in the body must carry content that cannot be absorbed elsewhere without loss. If `<error_handling>` has two bullets, fold them into the relevant workflow steps. If `<validation>` is a single "check that it works," omit it. Structural overhead without structural content is noise.

**Principles over enumerations** — Workflow steps and validation criteria express durable principles rather than listing specific tools, files, or commands. "Identify the project's test runner and execute" survives tool changes; "Run `npm test`" assumes a specific ecosystem. Let the executing agent discover the environment.

**Steps are self-contained actions** — Each workflow step states what to do, what to verify, and when to proceed. An agent executes each step without reading ahead to later steps. Steps that depend on implicit state from prior steps create fragile workflows.

**Imperative voice throughout** — Skill prose uses imperative mood consistently. "Analyze the request" not "The request should be analyzed." "Load the reference file" not "The reference file is loaded at this point." The skill is giving instructions to a competent practitioner.

</design_guidelines>
