Validation rules and banned patterns for agent artifact quality assurance. Every generated agent must pass P1 and P2 gates before delivery. P3 issues are flagged as suggestions. Load this reference during the validation step — scan the agent body against each section.


<validation_tiers>

**P1 — Blocking** (any violation stops delivery):

- **Subagent-only: user-invokable** — `user-invokable` must be `false` — subagents are never user-facing
- **Subagent-only: agents** — `agents` must be `[]` — subagents do not spawn other agents
- **Subagent-only: no handoffs** — No `handoffs` field in frontmatter — handoffs are brain-exclusive
- **Subagent-only: no argument-hint** — No `argument-hint` field in frontmatter — argument hints are brain-exclusive
- **Subagent-only: no target** — No `target` field in frontmatter — target routing is brain-exclusive
- **Required fields** — `description` present in frontmatter
- **Frontmatter format** — All YAML string values single-quoted
- **File extension** — File ends with `.agent.md`
- **No headings** — Zero markdown headings (`#`, `##`, etc.) in agent body — XML tags only
- **No platform-reserved tags** — None of the tags listed in `<platform_reserved_tags>` appear in agent body
- **No secrets or absolute paths** — No hardcoded credentials, drive letters, or OS-specific paths

**P2 — Quality** (fix before finalizing):

- **Description quality** — Frontmatter `description` is keyword-rich and specific — not generic filler
- **Tag naming** — All XML tags use `snake_case` with domain-specific names
- **Tag references** — Same-file refs use backticks only; cross-file refs use backtick + markdown link
- **No project-specific paths** — No drive letters, home directories, or workspace-specific prefixes
- **No cross-agent references** — Only brain.agent.md may use `@agent` names — all other agents use role descriptions instead

**P3 — Polish** (flag as suggestions):

- **Voice** — Active voice throughout — no hedging ("try to", "should", "be careful")
- **Prose intros** — Identity prose and each major XML tag opens with a governing principle
- **Conciseness** — No verbose prose — trim to essential information
- **Examples** — Complex rules include Wrong/Correct contrast pairs

</validation_tiers>


<banned_patterns>

Patterns that indicate portability or quality issues. Scan every agent for these before delivery.

- **Drive letters or absolute OS paths** (P1) — Fix: `C:\`, `e:\`, `/home/`, `/Users/` — use relative paths only
- **Bare `#tool:` references** (P1) — Fix: Must be backticked (`` `#tool:search` ``) to prevent VS Code injection
- **`@agent` outside brain** (P2) — Fix: Cross-agent references belong only in brain.agent.md
- **Hard-coded model names** (P2) — Fix: `gpt-4`, `claude-3` — use capability descriptions instead
- **Motivational or filler phrases** (P3) — Fix: "Let's", "Great job", "Remember to" — state rules directly
- **Temporal language** (P3) — Fix: "currently", "recently", "new" — content becomes stale

</banned_patterns>


<platform_reserved_tags>

VS Code injects these tags into system prompts at runtime. Using them in authored agent bodies causes collisions. Never use any of the following as XML tag names in an agent:

`<instructions>`, `<skills>`, `<modeInstructions>`, `<toolUseInstructions>`, `<toolSearchInstructions>`, `<communicationStyle>`, `<outputFormatting>`, `<repoMemory>`, `<reminderInstructions>`, `<workflowGuidance>`, `<agents>`

</platform_reserved_tags>


<agent_anti_patterns>

Anti-patterns specific to agent artifacts. Each entry describes what's wrong and why.

- **Identity prose wrapped in XML** — Opening identity sentences ("You are the X SUBAGENT — ...") must be bare prose, not wrapped in a tag
- **Constraint bullets inside a tag** — NEVER/ALWAYS rules sit between identity prose and `<workflow>`, unwrapped — no container tag
- **Missing output template** — Every agent needs a dedicated output template tag (e.g., `<findings_template>`) with a fenced code block and an `<example>` sub-tag so the orchestrator knows what to expect
- **Generic tag names** — `<section_1>`, `<rules>`, `<guidelines>` give no signal. Name tags for the domain: `<verdicts>`, `<severity>`, `<build_guidelines>`
- **Rigid tag vocabulary** — Do not impose a fixed set of body tags. Core agents use domain-named tags that fit their purpose — each agent's tags are unique to its domain
- **Cross-agent references outside brain** — Mentioning `@researcher`, `@developer`, or any `@agent` name from a non-brain agent creates coupling. Use role descriptions ("the implementing agent", "the orchestrator") instead
- **Orchestration vocabulary in agent body** — Terms like "spawn", "delegation", "session ID", "BLOCKED" are orchestration protocol. In the agent's workflow and constraints, use domain language. Status codes and session ID echo belong only in the output template
- **Inheritance assumptions** — Phrases like "see parent agent", "as defined in core developer", or "inherits from @inspector" assume context the agent won't have. Each agent is self-contained — state everything it needs directly
- **Coding standards in agent body** — Language conventions, linting rules, and style guides belong in `.instructions.md` files, not baked into the agent. The agent describes workflow and constraints, not project-specific coding standards
- **Enumeration-based constraints** — Listing specific tools, file types, or technologies instead of stating principles. "Use grep for search" breaks when tools change. "Verify claims against source before citing" survives tool evolution
- **Structure the agent will not follow** — If the agent's actual behavior diverges from its documented structure, the structure is wrong. Observe real patterns, do not invent ideal ones

</agent_anti_patterns>
