Validation rules and banned patterns for skill artifact quality assurance. Every generated skill must pass P1 and P2 gates before delivery. P3 issues are flagged as suggestions. This reference is loaded during the validation step — scan the skill body against each section.


<validation_tiers>

**P1 — Blocking** (any violation stops delivery):

| Check | Detail |
|---|---|
| Required fields | `name` and `description` present in frontmatter |
| Name matches folder | Frontmatter `name` matches parent folder name in kebab-case |
| File name casing | Skill file is named `SKILL.md` (uppercase) |
| Frontmatter format | All YAML string values single-quoted |
| Workflow tag present | `<workflow>` tag exists in skill body |
| No platform-reserved tags | None of the tags listed in `<platform_reserved_tags>` appear in skill body |
| No secrets or absolute paths | No hardcoded credentials, drive letters, or OS-specific paths |
| File length | SKILL.md is 500 lines or fewer |

**P2 — Quality** (fix before finalizing):

| Check | Detail |
|---|---|
| Description quality | Frontmatter `description` is keyword-rich with trigger phrases users would say — not generic filler |
| Tag naming | All XML tags use `snake_case` with domain-specific names |
| Step tag naming | Step tags follow `step_N_verb` pattern using domain verbs (e.g., `step_1_analyze`, not `step_1_start`) |
| Resource integrity | All files referenced from SKILL.md via markdown links have corresponding files in subfolders |
| No orphaned resources | Every file in `assets/` and `references/` is referenced from at least one step |
| Prose intro present | SKILL.md opens with 1-3 bare prose sentences before the first XML tag |
| No identity prose | Skills instruct, they don't act — no "This skill generates..." or "This skill is..." phrasing; use imperative voice |

**P3 — Polish** (apply during final review):

| Check | Detail |
|---|---|
| Voice | Active voice throughout — no hedging ("try to", "should", "be careful") |
| Governing principle | Prose intro states the skill's governing principle or purpose |
| Conciseness | No verbose prose — trim to essential information |
| Error handling | Likely failure modes are covered with recovery guidance |

</validation_tiers>


<banned_patterns>

Patterns that indicate portability or quality issues. Scan every skill for these before delivery.

| Pattern | Severity | Detail |
|---|---|---|
| Drive letters or absolute OS paths | P1 | `C:\`, `e:\`, `/home/`, `/Users/` — use relative paths only |
| Bare `#tool:` references | P1 | Must be backticked (`` `#tool:search` ``) to prevent VS Code injection |
| Hard-coded model names | P2 | `gpt-4`, `claude-3` — use capability descriptions instead |
| Identity prose in skills | P2 | "This skill generates...", "This skill is..." — skills instruct, they don't act; use imperative voice |
| Motivational or filler phrases | P3 | "Let's", "Great job", "Remember to" — state rules directly |
| Temporal language | P3 | "currently", "recently", "new" — content becomes stale |

</banned_patterns>


<platform_reserved_tags>

VS Code injects these tags into system prompts at runtime. Using them in authored skill bodies causes collisions. Never use any of the following as XML tag names in a skill:

`<instructions>`, `<skills>`, `<modeInstructions>`, `<toolUseInstructions>`, `<toolSearchInstructions>`, `<communicationStyle>`, `<outputFormatting>`, `<repoMemory>`, `<reminderInstructions>`, `<workflowGuidance>`, `<agents>`

</platform_reserved_tags>


<skill_anti_patterns>

Anti-patterns specific to skill artifacts. Each entry describes what's wrong and why.

**Structural anti-patterns:**

- **Monolithic SKILL.md** — Everything crammed into one file when references or assets would reduce per-run token cost. If content exceeds 100 lines, is not needed on every run, or contains decision rules that clutter the workflow, extract it to `references/`
- **Orphaned resources** — Files sitting in `assets/` or `references/` that no step in SKILL.md links to. Every subfolder file must be referenced via a markdown link from at least one workflow step
- **Reference chains** — Reference files linking to other reference files instead of back to SKILL.md. References are one level deep — SKILL.md loads them, they don't load each other
- **Missing prose intro** — SKILL.md must open with 1-3 bare prose sentences before any XML tag. This prose states what the skill does, when to use it, and sets the governing principle

**Voice and naming anti-patterns:**

- **Identity prose** — "This skill generates...", "This skill creates..." — skills are recipes, not actors. The subject is the AI agent executing the skill, not the skill document. Use imperative voice: "Follow these steps to create..."
- **Generic step names** — `step_1_start`, `step_2_process`, `step_3_finish` give no signal about what each step does. Name steps with domain verbs that describe the action: `step_1_analyze`, `step_2_draft`, `step_3_validate`

**Dependency anti-patterns:**

- **External dependencies** — Referencing files outside the skill's own folder tree. A skill must be fully self-contained so any agent can use it without assuming workspace structure
- **Bundling always-on rules** — Conventions that apply broadly across most work belong in `.instructions.md` files, not baked into a skill. Skills contain task-specific workflow, not project-wide coding standards

</skill_anti_patterns>
