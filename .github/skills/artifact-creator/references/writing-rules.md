Cross-cutting writing quality rules for all VS Code Copilot customization artifacts. The governing principle is: consistent structure and vocabulary across every artifact type — XML tags navigate, prose explains, and validation enforces uniform standards.


<xml_tags>

XML tags are the structural skeleton of every artifact. They replace markdown headings entirely — no `#`, `##`, etc. inside artifact content. Tags navigate, prose explains.

**Freedom principle:** Tags are free-form and domain-specific. There is no closed vocabulary per artifact type. Authors choose tag names that describe their content. A skill can use `<resources>` or `<constraints>` if those names fit. An agent can use `<error_handling>` if it has error handling guidance. The tag's name should communicate what's inside — that is the only naming rule.

**Design guidelines:**

- `snake_case`, self-explanatory names — a reader should guess the content from the tag name alone
- Prefer domain-specific names over generic ones (`<investigation_approach>` over `<section_1>`)
- 4-8 top-level tags is the typical range for a well-structured artifact
- 1-2 nesting levels preferred, 3 maximum — split into separate files rather than exceeding depth
- One concern per tag — separate distinct concepts into distinct tags
- Prose intro (1-3 sentences) inside each tag before structured content — state purpose, not section enumeration
- Tag references: same-file backticks only (`<tag_name>`), cross-file backticks + markdown link (`<tag>` in [file.md](path))
- Structural XML for definitions; backticks for inline prose references to tags

**Platform-reserved tags** — the ONLY hard constraint. VS Code injects these into system prompts; never use them in authored artifacts — they cause collisions with the runtime environment:

`<instructions>`, `<skills>`, `<modeInstructions>`, `<toolUseInstructions>`, `<communicationStyle>`, `<outputFormatting>`, `<repoMemory>`, `<reminderInstructions>`, `<workflowGuidance>`, `<agents>`

Exception: `<agents>` is permitted in `copilot-instructions.md` because VS Code wraps that file in `<attachment>` scope, avoiding collision with the platform-level `<agents>` tag.

</xml_tags>


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
| No platform-reserved tags | None of the VS Code system prompt tags used in authored artifacts (see `<xml_tags>`) |
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
