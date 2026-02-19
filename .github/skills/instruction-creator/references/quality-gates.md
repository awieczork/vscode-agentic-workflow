Validation rules and banned patterns for instruction artifact quality assurance. Every generated instruction file must pass P1 and P2 gates before delivery. P3 issues are flagged as suggestions. Load this reference during the validation step — scan the instruction body against each section.

<validation_tiers>

**P1 — Blocking** (any violation stops delivery):

- **File extension** — File ends in `.instructions.md`
- **Frontmatter format** — YAML is valid if present — all fields are optional
- **YAML string quoting** — All YAML string values use single quotes
- **No platform-reserved tags** — None of the tags listed in `<platform_reserved_tags>` appear in body
- **No secrets or absolute paths** — No credentials, drive letters, or OS-specific paths
- **Flat file** — Single file — no subfolders, no folder structure
- **File length** — 150 lines or fewer

**P2 — Quality** (fix before finalizing):

- **Discovery mode** — Appropriate for content — file-triggered for language standards, on-demand for conceptual topics, both for most
- **XML group naming** — Domain-specific names, not generic (`<type_safety>` not `<rules>`)
- **Rule enforcement style** — Uses NEVER/ALWAYS — no hedge words (should, prefer, consider, try to)
- **Description formula** — `description` follows "{verb} {scope} {concern}" if present
- **Scope accuracy** — `applyTo` is neither too broad (`**`) nor too narrow (deeply nested single path)
- **Prose intro** — Present and uses imperative voice
- **One concern per group** — Each XML group covers exactly one topic — no mixing
- **Group size** — Each XML group contains 3–7 rules

**P3 — Polish** (flag as suggestions):

- **Voice** — Active voice throughout
- **Conciseness** — Trim filler words
- **Concern separation** — Related but distinct topics get separate groups
- **Code examples** — Optional examples enhance complex rules

</validation_tiers>

<banned_patterns>

Scan every instruction file for these patterns before delivery.

- **Identity prose ("You are a...", "As a...")** (P1) — Fix: Instructions are ambient constraints, not agent personas
- **Drive letters or absolute OS paths** (P1) — Fix: `C:\`, `e:\`, `/home/`, `/Users/` — use relative paths only
- **Workflow or step tags (`<workflow>`, `<step_N_verb>`)** (P1) — Fix: Workflow structure belongs in skills, not instructions
- **Stance words (should, prefer, consider)** (P2) — Fix: Use NEVER/ALWAYS — binary enforcement, no ambiguity
- **Hedge language (try to, when possible, generally)** (P2) — Fix: State rules directly without hedging
- **Generic XML group names (`<rules>`, `<guidelines>`, `<best_practices>`)** (P2) — Fix: Name groups after the specific concern they address
- **Prompt variables (`{{language}}`, `{framework}`)** (P2) — Fix: Instructions are static — no templating
- **Duplicating linter rules** (P2) — Fix: Focus on conventions tools cannot check
- **Motivational or filler phrases (Let's, Great job, Remember to)** (P3) — Fix: State rules directly
- **Temporal language (currently, recently, new)** (P3) — Fix: Content becomes stale — use timeless phrasing

</banned_patterns>

<platform_reserved_tags>

VS Code injects these tags into system prompts at runtime. Using them in instruction bodies causes collisions. Never use any of the following as XML tag names:

`<instructions>`, `<skills>`, `<modeInstructions>`, `<toolUseInstructions>`, `<toolSearchInstructions>`, `<communicationStyle>`, `<outputFormatting>`, `<repoMemory>`, `<reminderInstructions>`, `<workflowGuidance>`, `<agents>`

</platform_reserved_tags>

<instruction_anti_patterns>

Anti-patterns specific to instruction artifacts. Each entry describes what's wrong and why.

- **Persona leakage** — Identity prose that defines a persona. Instructions are ambient constraints, not agent identities. Remove "You are a..." and "As a..." phrasing entirely.
- **Concern soup** — Mixing multiple concerns in a single XML group. One group = one topic. Split mixed groups until each has a single clear subject.
- **Hedge creep** — Using "should", "prefer", "try to" instead of NEVER/ALWAYS. LLMs respond better to binary enforcement than graduated guidance.
- **Scope mismatch** — `applyTo` glob does not match the instruction's actual concern scope (e.g., Python rules with `applyTo: '**/*.ts'`). Verify glob coverage before delivery.
- **Linter echo** — Duplicating rules that linters or formatters already enforce. Focus on conventions and decisions that tools cannot check.
- **Kitchen sink** — Cramming too many concerns into one file. Split into multiple instruction files, one per concern.

</instruction_anti_patterns>
