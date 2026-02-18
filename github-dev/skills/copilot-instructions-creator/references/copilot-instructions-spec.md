Structural specification for the copilot-instructions artifact (`copilot-instructions.md`). Covers identity, precedence, body structure, token-cost constraints, content placement, and anti-patterns. Copilot-instructions only — no other artifact types.


<identity>

`copilot-instructions.md` is a singleton, always-on project-level context file. It lives at a fixed path — `.github/copilot-instructions.md` — and loads automatically on every chat turn. There is exactly one per repository.

| Property | Value |
|---|---|
| Location | `.github/copilot-instructions.md` (fixed, non-negotiable) |
| Frontmatter | None — no YAML header, no `---` fences |
| Discovery | Always-on — loads every turn, no glob matching, no semantic matching |
| Cardinality | Singleton — one per repository |
| Scope | Project-wide — applies to all chat interactions regardless of open files |

Unlike `.instructions.md` (scoped by glob/semantic match) and `.agent.md` (scoped by agent selection), this file has no activation conditions. It is always present, always costs tokens.

</identity>


<priority_hierarchy>

When instructions conflict, VS Code resolves by precedence. Higher entries override lower ones.

| Priority | Source | Scope |
|---|---|---|
| 1 (highest) | Personal instructions (user settings) | User-level |
| 2 | `.instructions.md` with path match | File/directory-level |
| 3 | **`copilot-instructions.md`** | **Project-level** |
| 4 | `.agent.md` / `AGENTS.md` | Agent-level |
| 5 (lowest) | Organization instructions | Org-level |

The first rule in the `<rules>` section MUST declare: "This file takes precedence over all other instruction files in the workspace." This establishes the file's authority over `.agent.md` and org instructions, while acknowledging that personal settings and path-scoped `.instructions.md` files can override it.

</priority_hierarchy>


<body_structure>

The body follows a fixed three-section sequence. No markdown headings (`#`) in the body.

**Prose introduction** — 1-3 bare sentences before any XML tag. State the project name, purpose, tech stack, and architecture summary. Terse and factual — no marketing language, no aspirational statements. Every word pays a per-turn token cost.

**`<rules>` section** (required) — Behavioral constraints in imperative NEVER/ALWAYS form. 5-12 bullets covering:

- Precedence declaration (always first bullet)
- Safety and accuracy constraints
- Tool-use boundaries and scope limits
- Conflict-resolution principles
- Source verification requirements

Rules are binary and unconditional — no hedging, no "should", no "when possible."

**`<commands>` section** (optional) — Development commands the agent needs for day-to-day tasks: build, test, lint, dev server. Include only commands that are non-obvious or project-specific. Omit if the project uses standard toolchain defaults. Format as a brief list or table — no prose explanations.

</body_structure>


<token_cost>

This is the defining constraint. The file loads on every chat turn — not conditionally like `.instructions.md` (glob match) or `.agent.md` (agent selection). Every line burns tokens on every interaction.

- Target output: ≤50 lines
- Every line must earn its inclusion — if removing a line wouldn't degrade agent behavior, remove it
- Verbose descriptions are an anti-pattern; terse imperative statements are the norm
- Prefer one bullet that absorbs three related concerns over three separate bullets
- Content that applies only to specific file types or domains belongs in `.instructions.md`, where it loads conditionally

</token_cost>


<content_placement>

What belongs in `copilot-instructions.md` vs. other artifacts. The guiding principle: if content doesn't apply to every chat turn, it doesn't belong here.

| Content | Belongs in | Reason |
|---|---|---|
| Project overview, tech stack, architecture | `copilot-instructions.md` | Universal context needed every turn |
| Universal behavioral rules, common dev commands | `copilot-instructions.md` | Apply to all interactions |
| Coding standards, formatting, language idioms | `.instructions.md` | Scoped to file types — load conditionally |
| Agent personas, domain expertise, tool configs | `.agent.md` | Scoped to agent selection |
| Task workflows, generation procedures | Skills (folder) | Multi-step processes with references |
| Framework metadata, orchestration details, absolute paths | Nowhere in this file | Internal tooling, non-portable |

</content_placement>


<anti_patterns>

Content that MUST NOT appear in `copilot-instructions.md`:

- Verbose prose or explanatory paragraphs — every word costs tokens on every turn
- Stale or inaccurate content — wrong instructions are worse than no instructions; audit regularly
- Duplicated content from `.instructions.md` or `.agent.md` — single source of truth; never repeat
- Framework internals or orchestration protocol — agents don't need to know how they're coordinated
- Absolute paths or drive letters (`C:\`, `/home/user/`) — use relative paths from workspace root
- `@agent` references — use role descriptions ("the implementing agent") instead of named references
- Coding standards or language conventions — these belong in `.instructions.md` scoped by `applyTo` glob
- Content that applies only to specific file types — use `.instructions.md` with glob matching

</anti_patterns>


<reserved_tags>

VS Code injects platform behavior through specific XML tags. These MUST NOT be used as custom section names in the body — they may collide with platform-injected content or be stripped during processing.

| Reserved tag | Platform purpose |
|---|---|
| `<instructions>` | Wraps system-level instruction injection |
| `<toolUseInstructions>` | Tool usage guidance injected by VS Code |
| `<communicationStyle>` | Response style configuration |
| `<outputFormatting>` | Output format directives |
| `<modeInstructions>` | Mode-specific behavioral overrides |

Use domain-specific tag names instead: `<rules>`, `<commands>`, or project-specific names like `<architecture>`, `<conventions>`.

</reserved_tags>
