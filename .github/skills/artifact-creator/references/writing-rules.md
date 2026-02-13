Cross-cutting writing quality rules for all VS Code Copilot customization artifacts. The governing principle is: consistent structure and vocabulary across every artifact type — XML tags navigate, prose explains, and validation enforces uniform standards.


<xml_conventions>

XML tags are the exclusive structural system for artifact bodies. No markdown headings (`#`, `##`, etc.) inside artifact content — tags replace headings entirely.

| Rule | Detail |
|---|---|
| Tag naming | `snake_case`, domain-specific, self-explanatory — tag names are project vocabulary, not magic keywords |
| Nesting depth | 1-2 levels preferred; 3 maximum — split into separate files rather than exceeding depth |
| Prose intros | 1-3 sentences inside each tag before structured content — state purpose, not section enumeration |
| One concern per tag | No multi-topic tags — separate distinct concepts into distinct tags |
| Tag references | Same-file: backticks only (`<tag_name>`). Cross-file: backticks + markdown link (`<tag>` in [file.md](path)) |
| Structural vs inline | Raw XML for structural definitions; backticks for inline prose references to tags |

Tags describe content — they do not impose rigid vocabulary. Choose meaningful names that communicate what the section contains.

</xml_conventions>


<formatting>

Formatting rules ensure artifacts are parseable by both AI agents and human reviewers.

**Frontmatter:**

- YAML frontmatter uses single-quoted string values: `name: 'value'`
- Required fields first, optional fields after

**Markdown within XML:**

| Element | Convention |
|---|---|
| Emphasis | Bold for key terms, no italics for structure |
| Lists | Bullets for parallel unordered items; numbered lists for sequential steps |
| Tables | Use for specs, comparisons, and structured data in `<outputs>` and `<resources>` sections |
| Code blocks | Fenced with language identifier, surrounded by blank lines |
| Definitions | `**term** — definition` (bold + em-dash); `` `term` — definition `` for code identifiers |

**Spacing:**

- Blank line after opening XML tag, blank line before closing XML tag
- Two blank lines between major sections
- Surround fenced code blocks and lists with blank lines

**Prohibitions:**

- No absolute file paths — use relative paths with forward slashes
- No secrets or credentials in any artifact
- No emojis, motivational phrases, or artificial markers (`---START`, `===END`)
- No markdown headings inside artifact body — XML tags only

**Other conventions:**

- Priority hierarchies use arrow notation: `Safety → Accuracy → Clarity → Style`
- Enum values separated with pipe and backticks: `success` | `partial` | `failed`
- Prohibitions start with "No" or "Never" followed by reason after em-dash
- Replace vague language with explicit conditionals (`If X, then Y`) and precise quantities

</formatting>


<forbidden_tags>

Each artifact type has a closed tag vocabulary. Tags from other types must not appear — this prevents cross-contamination and preserves type boundaries.

| Artifact type | Forbidden tags (belong to other types) |
|---|---|
| `.agent.md` | `<step_N_*>`, `<use_cases>`, `<resources>`, `<error_handling>`, `<validation>` |
| `SKILL.md` | `<constraints>`, `<behaviors>`, `<outputs>`, `<termination>`, `<iron_law>`, `<mode>`, `<context_loading>`, `<on_missing>`, `<when_blocked>`, `<if>` |
| `.prompt.md` | All agent tags above + all skill tags above |
| `.instructions.md` | All agent tags above + all skill tags above |
| `copilot-instructions.md` | No type-specific forbidden tags — uses project-domain XML freely |

**Platform-reserved tags** — VS Code injects these into system prompts. Never use them in authored artifacts:

`<instructions>`, `<skills>`, `<modeInstructions>`, `<toolUseInstructions>`, `<communicationStyle>`, `<outputFormatting>`, `<repoMemory>`, `<reminderInstructions>`, `<workflowGuidance>`, `<agents>`

Exception: `<agents>` is permitted in `copilot-instructions.md` because VS Code wraps that file in `<attachment>` scope, avoiding collision with the platform-level `<agents>` tag.

</forbidden_tags>


<glossary>

Canonical terms prevent vocabulary drift across artifacts. Use only these terms — understand aliases in input but always respond with the canonical form.

| Term | Definition | Common aliases to avoid |
|---|---|---|
| **rule** | Enforceable behavioral instruction within a named group | guideline, policy, directive |
| **constraint** | Hard limit that cannot be exceeded — an obligation | restriction, limitation |
| **skill** | Reusable multi-step process with validation | procedure, recipe |
| **workflow** | Agent orchestration sequence composed by brain | pipeline, flow |
| **handoff** | Structured payload passing work to another agent | delegation, transfer, dispatch |
| **escalate** | Interrupt execution to request human input | interrupt |
| **fabricate** | Produce unverified claims without evidence | hallucinate, invent |
| **mode** | Named behavioral configuration within an agent | behavior-set |
| **boundary** | Capability limit defining what an agent may access or modify | fence, guardrail |
| **artifact** | Any generated or modified content | document, output |

**Conflict pairs** — choose the correct term based on context:

- **constraint** vs **boundary**: constraint = obligation limit; boundary = capability limit
- **skill** vs **workflow**: skill = reusable process; workflow = composed agent sequence
- **handoff** vs **escalate**: handoff = pass to agent; escalate = pause for human decision
- **mode** vs **phase**: mode = behavioral configuration; phase = lifecycle stage

</glossary>


<validation>

Every artifact passes the same quality gates regardless of type. Fix all P1 and P2 issues before delivery. Flag P3 issues as suggestions.

**P1 — Blocking** (any violation stops delivery):

| Check | Detail |
|---|---|
| Frontmatter format | All YAML string values single-quoted |
| File extension | Matches artifact type (`.agent.md`, `SKILL.md`, `.prompt.md`, `.instructions.md`) |
| No headings | Zero markdown headings in artifact body — XML tags only |
| No cross-contamination | No forbidden tags from other artifact types (see `<forbidden_tags>`) |
| No secrets | No hardcoded credentials or absolute paths |

**P2 — Quality** (fix before finalizing):

| Check | Detail |
|---|---|
| Tag references | Cross-file refs use linked form; same-file refs use backticks only |
| File resolution | Every `Load [file] for:` directive resolves to an existing file |
| No orphaned resources | Every file in subfolders referenced from parent file |
| Descriptions | Frontmatter `description` field is keyword-rich and specific |
| Naming consistency | Tag names follow snake_case; terms match `<glossary>` |

**P3 — Polish** (apply during final review):

| Check | Detail |
|---|---|
| Voice | Active voice throughout, no hedging |
| Prose intros | Every file and major section opens with governing principle |
| Format consistency | Spacing, blank lines, and list formatting follow `<formatting>` rules |
| Conciseness | No verbose prose — trim to essential information |
| Examples | Complex rules include Wrong/Correct contrast pairs |

</validation>
