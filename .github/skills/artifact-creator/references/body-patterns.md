This file consolidates body structure patterns for all five VS Code Copilot customization artifact types. Each section describes the canonical shape agents follow when writing the body of that artifact — identity, workflow, constraints, and output conventions. The governing principle is pattern by observation — every rule here reflects what the working core artifacts actually do, not an imposed vocabulary.


<agent>

Agent bodies follow a consistent convention observed across all core agents. The body is a sequence of unmarked prose, bare bullet rules, a required `<workflow>` tag, domain-specific XML tags, and an output template. No fixed tag vocabulary exists — tags are named for the agent's domain.

**Identity prose** — The body opens with 2-4 sentences of unmarked prose (no XML wrapper). First sentence declares the role in second person with an em-dash separator: "You are the X SUBAGENT — a [role description]." Second sentence states a governing principle: "Your governing principle: [single principle]." Optional third sentence expands scope or relationship to the orchestrator. Identity prose establishes personality and focus — keep it tight and declarative.

**Bullet constraints** — Immediately after identity prose, list 5-7 NEVER/ALWAYS rules as bare bullets (no wrapping tag). These are the agent's hard limits — scope boundaries, safety rails, and mandatory behaviors. Start each bullet with NEVER, ALWAYS, or HALT. Include a HALT rule for security-sensitive conditions (credentials, secrets, PII). Bullets are imperative and binary — no hedging, no "try to", no "should".

**`<workflow>`** — Required. Opens with a prose paragraph describing the agent's execution model: stateless reception, what arrives in the spawn prompt, tool priority, and what to do when context is missing. Followed by numbered steps with bold names and em-dash descriptions:

- Format: `1. **Verb** — What this step does`
- Steps are domain-specific — parse, scan, execute, verify, report for a developer; parse, investigate, report for a researcher
- Each step is 2-5 lines: what to do, what tools to use, what to produce
- Include decision points inline: "If X, return BLOCKED" or "When Y, delegate to Z"

**Domain-specific XML tags** — After `<workflow>`, add 1-4 XML tags named for the agent's specific domain. These are NOT from a fixed vocabulary — they are self-explanatory names that make sense for what the agent does. Examples from core agents: `<build_guidelines>`, `<planning_guidelines>`, `<research_guidelines>`, `<maintenance_guidelines>`, `<inspection_guidelines>`, `<verdicts>`, `<severity>`. Content inside is prose and bullets — guidelines, decision rules, severity definitions, or any domain knowledge the agent needs.

**Output template** — A dedicated XML tag (e.g., `<build_summary_template>`, `<findings_template>`, `<plan_template>`) containing the agent's required output format. Structure: a prose intro stating "Every return must follow this structure", then a fenced code block with Status/Session ID/Summary header followed by structured sections. Include a When BLOCKED variant. Close with an `<example>` sub-tag containing a realistic fenced code block showing a completed output. The output template is the agent's contract with the orchestrator — it must be machine-parseable and consistent.


<positioning>

New agents extend the orchestrator's capabilities. When designing a new agent, follow these positioning guidelines:

**Naming convention** — Domain agents follow the `{domain}-{core-role}` pattern. The domain prefix describes the specialization; the suffix maps to the core agent role being extended. Examples: `theme-developer`, `security-inspector`, `api-planner`. This convention ensures the orchestrator can infer capability from the agent name.

- Define the agent's role relative to an existing core agent — a `@python-developer` replaces `@developer` for Python projects, a `@security-inspector` extends `@inspector` with security focus
- Specify when the orchestrator should prefer this agent over the core alternative — include selection criteria in the identity prose or guidelines
- Follow the same interface patterns as the core agent being extended — status codes (`COMPLETE` | `BLOCKED`), session ID echo, output template structure — so the orchestrator can route to it seamlessly
- Think of agent creation as growing the orchestrator's agent pool — every new agent enables a new delegation path

**Inheritance model** — Domain agents inherit the interface contract of the core agent they extend. The following elements are inherited by default and should only be overridden when the domain requires it:

| Inherited element | Override when |
|---|---|
| Status codes (`COMPLETE` / `BLOCKED` / `PARTIAL`) | Never — orchestrator depends on these |
| Session ID echo | Never — required for tracking |
| Output template structure | Only to add domain-specific sections |
| Workflow step format | Only when domain steps differ significantly |
| Bullet constraint style | Only to add domain-specific constraints |

</positioning>


<anti_patterns>

- Rigid tag vocabularies — do not impose a fixed set of body tags like `<constraints>`, `<behaviors>`, `<outputs>`, `<termination>`. Core agents use domain-named tags that fit their purpose
- Structure the agent will not follow — if the agent's actual behavior diverges from its documented structure, the structure is wrong. Observe real patterns, do not invent ideal ones
- Identity prose in XML — the opening identity sentences are bare prose, not wrapped in a tag
- Constraint bullets in a tag — the NEVER/ALWAYS rules sit between identity prose and `<workflow>`, unwrapped
- Generic tag names — `<section_1>`, `<rules>`, `<guidelines>` give no signal. Name tags for the domain: `<verdicts>`, `<severity>`, `<delegation_header>`
- Missing output template — every agent needs a parseable output contract so the orchestrator knows what to expect

</anti_patterns>

</agent>


<skill>

Skill bodies follow a progressive-loading model: the SKILL.md file contains the core workflow, while supporting content lives in subfolders loaded on demand. The body shape is a prose intro, optional `<use_cases>`, a required `<workflow>` with numbered steps, optional `<error_handling>` and `<validation>`, and a `<resources>` listing.

**Folder structure** — Every skill lives in its own folder with a required SKILL.md at the root. Optional subfolders exist for progressive loading, not organization:

- `references/` — JIT-loaded documentation exceeding 100 lines, decision rules, domain patterns that are not needed on every run
- `assets/` — Templates, configuration files, example outputs, non-markdown resources
- `scripts/` — Executable code exceeding 20 lines, platform-dependent logic

**Progressive loading** — Skills load in three stages: discovery (name + description from frontmatter), instructions (SKILL.md body), and resources (scripts, references, assets loaded from subfolders when a step calls for them). This keeps token cost low — agents pay only for what they need.

**Prose intro** — 1-3 sentences before any tag. Pattern: "This skill [what it does]. The governing principle is [principle]. Begin with `<step_1_verb>` to [first action]."

**`<workflow>`** — Required parent container. Opens with prose stating execution sequence. Contains `<step_N_verb>` sub-tags — numbered imperative steps (e.g., `<step_1_classify>`, `<step_2_draft>`). Each step is a self-contained action with its own verification before proceeding. Steps reference subfolders via markdown links when they need JIT content.

**When to extract to references** — If content exceeds 100 lines, is not needed on every run, or contains decision rules that would clutter the workflow, move it to `references/`. Reference files are one level deep from SKILL.md — no reference-to-reference chains. Keep SKILL.md under 500 lines total.

**Optional tags** — `<use_cases>` for trigger alignment, `<error_handling>` for if/then recovery, `<validation>` for verifiable checks (P1/P2/P3 severity tiers for complex skills), `<resources>` for listing subfolder files with relative-path markdown links.


<anti_patterns>

- Monolithic SKILL.md — everything in one file when references would reduce per-run token cost
- Orphaned resources — files in subfolders not referenced from any step in SKILL.md
- Reference chains — reference files linking to other reference files instead of back to SKILL.md
- Vague descriptions — "A helpful skill" does not enable discovery. Use verb-first, specific language
- Bundling always-on rules — use custom instructions for conventions that apply to most work, not a skill

</anti_patterns>

</skill>


<prompt>

Prompt bodies are task-focused instructions — no identity, no personality, just what to do. The body follows a prose-or-XML structure depending on complexity, with one task per prompt file.

**Body structure** — Two patterns based on complexity:

- Prose format for single-instruction prompts under ~20 lines — paragraphs with bullet lists
- XML-structured for multi-section prompts over ~20 lines — ad-hoc tags (author's choice) separating context, task, and format sections. Common tag choices: `<context>`, `<task>`, `<format>`, `<constraints>`, `<examples>`

**Opening line** — The body starts with a plain prose line (no `#` markdown heading) that VS Code uses as the Quick Pick label when users browse prompts. Make it verb-first and imperative — this is a label, not a heading.

**Content flow** — Task description → scope and preconditions → workflow steps (if multi-step) → output expectations. Sentences are imperative and direct. No preambles like "You are an expert..." — state the task immediately.

**Context attachment** — Reference workspace files via markdown links (`[display](./path)`) resolved by VS Code as context. Reference tools via `#tool:<name>` syntax. Use `${variable}` syntax for runtime inputs — the dollar prefix is required.

**One task per prompt** — Each prompt file does one thing. "Create, test, and deploy" is three prompts, not one. This keeps prompts composable and predictable.


<anti_patterns>

- Multi-task prompts — bundling create, test, and deploy into one file instead of separate focused prompts
- Identity prose — "You are an expert..." preambles belong in agents, not prompts. State the task directly
- Missing descriptions — omitting the `description` field blocks command discovery
- Wrong variable syntax — `{name}` is invalid; variables require the dollar prefix: `${name}`

</anti_patterns>

</prompt>


<instruction>

Instruction bodies provide ambient constraints — rules that shape agent behavior without explicit invocation. No identity, no workflow, no personality. Just grouped rules organized by domain concern.

**Sub-types** — Two routing mechanisms determine when instructions load:

- File-triggered — loads when files matching `applyTo` glob patterns appear in context (e.g., `applyTo: '**/*.ts'`). Best for language-specific or path-specific rules
- On-demand — loads when the agent detects relevance from `description` keywords. Best for domain rules not tied to file patterns
- When uncertain, prefer file-triggered with both `applyTo` and `description` for dual discovery

**Prose intro** — 1-3 sentences of bare prose before the first XML group. States purpose and governing principle: "This file defines [domain] rules for [scope]. The governing principle is [principle]."

**Body structure** — Custom XML groups wrapping related rules by domain concern. Each group gets a domain-specific tag name — `<naming_conventions>`, `<error_handling>`, `<type_safety>`, not generic names like `<section_1>`. Inside each group: bullet rules (one rule per bullet), optional Wrong/Correct contrast pairs with em-dash, and optional `<example>` sub-tags for complex code demonstrations.

**Rule style** — Imperative mood, binary enforcement. Start prohibitions with NEVER or No. Start mandates with ALWAYS. Include reason after em-dash: "No emojis — break parsing in some environments." One concern per bullet — no compound rules.


<anti_patterns>

- Identity prose — "You are a..." or role statements. Instructions are ambient constraints, not agent personas
- Stance words — "thorough", "cautious", "creative" are identity leakage even without "You are a..."
- Hedge language — "try to avoid", "should", "be careful" instead of binary NEVER/ALWAYS
- Mixing concerns — testing + API design + styling in one file instead of separate instruction files
- Generic group names — `<rules_group>` instead of domain-specific `<naming_conventions>`
- Prompt variables — `${input:}`, `${selection}` — runtime variable syntax belongs in prompts, not instructions

</anti_patterns>

</instruction>


<copilot_instructions>

Project context, goals, and universal rules. Attached to every chat turn — every line must earn its token cost.

**Core content** — Project overview prose (what it is, its goal, tech stack, key conventions) plus a rules section (behavioral constraints in imperative NEVER/ALWAYS form). These two concerns are the minimum viable file.

**Optional content** — Development commands, environment info — include only when directly relevant to day-to-day agent work.

**What does NOT belong** — Framework infrastructure paths, agent pool listings, or artifact authoring conventions. These are documented in their own files and should not consume tokens on every turn.


<anti_patterns>

- Verbose descriptions — every token loads on every request; prefer terse, factual entries
- Stale or inaccurate content — outdated maps or rules that no longer reflect the project
- Duplicating information documented elsewhere — agent definitions, skill details, or conventions already in dedicated files
- Framework metadata — framework internals, artifact-type guidance, or orchestration details that don't help the project
- Project-specific paths — absolute paths, drive letters, or workspace-specific prefixes that break portability across environments

</anti_patterns>

</copilot_instructions>


<cross_agent_references>

Not all artifact types should reference other agents by name. Cross-agent references (`@developer`, `@researcher`) create coupling between artifacts. Follow these rules per type:

| Type | `@agent` references | Rationale |
|------|---------------------|----------|
| Agent (brain) | Allowed | The orchestrator references subagents for delegation routing |
| Agent (other) | Never | Subagents focus on their own task — they do not need to know about other agents |
| Skill | Never | Skills are reusable across agents — agent names reduce portability |
| Prompt | Never | Prompts are user-facing commands — agent routing is the orchestrator's concern |
| Instruction | Never | Instructions are ambient constraints — they should not assume an agent topology |
| Copilot-instructions | Never | Project-level context should not embed framework-internal agent names |

When any artifact (including non-brain agents) needs to describe delegation behavior, use role descriptions ("the orchestrator", "the implementing agent") instead of `@`-prefixed names. Only brain.agent.md may reference subagents by name.

</cross_agent_references>
