Validation rules and banned patterns for copilot-instructions.md quality assurance. Every generated file must pass P1 and P2 gates before delivery. P3 issues are flagged as suggestions. Load this reference during the validation step — scan the output against each section.

<validation_tiers>

**P1 — Blocking** (any violation stops delivery):

| Check | Detail |
|---|---|
| No frontmatter | File starts with prose — no YAML frontmatter (copilot-instructions.md never has it) |
| Prose intro | Opens with project name and tech stack in plain prose |
| Rules section | `<rules>` section exists with at least one rule |
| Precedence declaration | First rule inside `<rules>` states "This file takes precedence over…" |
| Line budget | Total file length is ≤50 lines — every line costs tokens on every chat turn |
| No @agent references | Uses role descriptions ("the implementing agent") instead of `@agent` names |
| No absolute paths | No drive letters (`C:\`, `e:\`) or OS-specific paths (`/home/`, `/Users/`) |

**P2 — Quality** (fix before finalizing):

| Check | Detail |
|---|---|
| Imperative enforcement | Rules use NEVER/ALWAYS form — no hedge words (should, prefer, consider) |
| No coding standards | Language conventions and style rules belong in `.instructions.md`, not here |
| No agent personas | Workflow steps, agent identities, and personas belong in `.agent.md` or skills |
| Commands section | `<commands>` present only if project has verified build/test/lint commands |
| Actionable rules | Every rule is testable by reading a diff — no vague advice ("write clean code") |
| No framework metadata | No orchestration details, model names, or framework internals |

**P3 — Polish** (flag as suggestions):

| Check | Detail |
|---|---|
| Intro brevity | Prose intro is ≤3 sentences |
| Rule ordering | Rules follow priority cascade: safety → accuracy → clarity → style |
| Command format | Each command uses backtick-wrapped command + dash-separated description |
| No duplication | No information already present in other workspace artifacts |

</validation_tiers>

<banned_patterns>

Scan every copilot-instructions.md for these patterns before delivery.

| Pattern | Severity | Fix |
|---|---|---|
| Coding standards or style rules | P2 | Move to a `.instructions.md` file scoped to the relevant language |
| Agent pool listings (`@planner`, `@developer`) | P1 | Move to `brain.agent.md` — copilot-instructions.md is agent-agnostic |
| Verbose project descriptions (>3 sentences) | P2 | Condense to project name + tech stack in 1–3 sentences |
| Framework or orchestration metadata | P2 | Remove entirely — implementation details do not belong here |
| Stale commands or paths | P2 | Verify each command runs successfully or remove it |
| Hedge language (try to, when possible, generally) | P2 | Rewrite as NEVER/ALWAYS — binary enforcement only |
| Temporal language (currently, recently, new) | P3 | Use timeless phrasing — content becomes stale |
| Motivational filler (Let's, Great job, Remember to) | P3 | State rules directly without filler |

</banned_patterns>

<copilot_instructions_anti_patterns>

Anti-patterns specific to copilot-instructions.md artifacts.

- **Kitchen-sink file** — Cramming coding standards, agent rosters, and workflow steps into one file. copilot-instructions.md carries only project-wide rules and constraints — everything else has a dedicated artifact type.
- **Token bloat** — Exceeding 50 lines. This file is injected into every chat turn. Each unnecessary line burns tokens across every interaction. Cut ruthlessly.
- **Persona leakage** — "You are a…" or "As a…" identity prose. copilot-instructions.md provides ambient constraints, not agent identities.
- **Unverified commands** — Listing build or test commands that have not been confirmed to work. Stale commands cause agent failures. Verify or omit.
- **Scope creep** — Adding rules that apply only to specific file types or narrow contexts. Scoped rules belong in `.instructions.md` files with proper `applyTo` globs.

</copilot_instructions_anti_patterns>
