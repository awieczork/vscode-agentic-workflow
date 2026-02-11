---
description: 'Audit all core agents for structural consistency, redundancy, and compliance'
agent: 'brain'
argument-hint: 'Ready to start the full agent audit?'
---

Audit all 6 core agents for cross-agent consistency using [brain.agent.md](.github/agents/core/brain.agent.md) as the primary reference point. Spawn @researcher instances for each audit phase, compile findings, and present a consolidated action list.


<audit_dimensions>

Check every agent file against these 13 dimensions. For each finding, state: agent, dimension, location (section + line), what is wrong, and recommended fix.

Structural consistency:

- XML tag vocabulary matches `<tag_vocabulary>` in the agent-creator skill — no unsupported tags, no markdown headings, snake_case names
- Section order follows `<visual_skeleton>`: frontmatter → identity prose → `<constraints>` → `<behaviors>` → `<outputs>` → `<termination>`
- Spacing conventions: blank line after opening tag, blank line before closing tag, two blank lines between major sections
- Single-mode agents have no `<mode>` wrapper — content sits directly under `<behaviors>`
- No `<hub_position>` sections — merge unique facts into identity prose

Iron law format consistency:

- Every iron law uses Statement + Why format — no Rationalization tables, no Red flags within `<iron_law>` tags
- Iron law IDs are sequential within each file (IL_001, IL_002, ...)
- Statement is actionable and imperative; Why explains the failure mode it prevents

Content quality:

- Redundancy — NEVER/ALWAYS bullets that restate iron laws verbatim, Do/Don't lists that duplicate constraints or behavioral steps, BLOCKED formats duplicated between `<outputs>` and `<termination>`
- Contradictions — rules that conflict across sections within the same file, or across files
- Noise — sentences that describe obvious spoke behavior ("you are not a planner" when the agent has no planning tools), excessive anti-identity delegation pointers beyond what shapes behavior
- Unnecessary spoke context — spokes mentioning brain's internal routing, hub lifecycle details, or other spokes' implementation details that the spoke cannot act on. A spoke needs to know: its own task, its constraints, what to return. Not: how brain routes work, what other spokes do, or where it sits in the lifecycle

Language and voice:

- Second-person voice ("You") in identity prose — no third-person ("The agent")
- Imperative voice in constraints and behavioral steps — no hedging ("should", "try to", "be careful")
- Active voice throughout — no passive constructions ("input should be checked" → "Check input")
- Consistent tense within each section
- Grammar and spelling errors

Artifact compliance — `<artifact_rules>` from [artifact-structure.md](.github/skills/artifact-author/references/artifact-structure.md):

- XML tags as exclusive structure — zero markdown headings
- No emojis outside fenced code blocks
- No motivational phrases, artificial markers, or leading special characters
- Consistent formatting: em-dash definitions, arrow notation for hierarchies, pipe-separated enums
- Markdown tables only inside `<outputs>` sections

Canonical vocabulary — `<canonical_terms>` in [glossary.md](.github/skills/artifact-author/references/glossary.md):

- No non-canonical aliases (e.g., "workflow" for skill, "guideline" for rule, "delegation" for handoff)
- Consistent use of canonical terms across all 6 files

Cross-reference accuracy:

- Brain's `<agent_pool>` entries (Strengths, Tools, Leverage) match each spoke's actual capabilities, tools, and constraints
- Brain's `<spawn_templates>` examples include all fields that spokes require in `<context_loading>`
- Brain's `<rework_routing>` covers all return statuses that spokes can produce

Output contract alignment:

- Each spoke's `<return_format>` in `<outputs>` produces what brain's `<rework_routing>` expects to consume
- Standard header fields (Status, Session ID, Summary) are consistent across all spokes
- Status enum values match what brain routes on (e.g., COMPLETE | PARTIAL | BLOCKED for @curator; PASS | PASS WITH NOTES | REWORK NEEDED for @inspect)

Context loading symmetry:

- All spokes reference brain's `<spawn_templates>` as their context source
- `<on_missing>` blocks follow consistent patterns: BLOCKED for critical fields, inline fallback for non-critical
- Rework detection is present in all spokes with consistent prefix format (`Rework: {type}`)
- Spawn prompt field parsing matches what brain actually sends

Frontmatter hygiene:

- `description` is keyword-rich and single-line
- `tools` list matches what the agent actually uses in its behavioral steps
- No unnecessary frontmatter fields
- All YAML string values wrapped in single quotes

Structural improvements:

- Opportunities to better use XML tags (e.g., thin sections that should merge, content that deserves its own tag)
- Sections that could benefit from worked examples
- Templates that lack placeholder variables (`{variable}` format)
- Missing edge case handling in `<termination>`

</audit_dimensions>


<workflow>

Execute audits sequentially. Each phase builds context for the next.

**Phase 1 — Self-audit of @brain**

Spawn @researcher to audit [brain.agent.md](.github/agents/core/brain.agent.md) against all 13 dimensions. Brain is the reference, but it can still have internal inconsistencies, noise, and compliance issues. Focus on:

- Internal contradictions between `<agent_pool>`, `<spawn_templates>`, `<flow_composition>`, and `<rework_routing>`
- Noise and redundancy within brain's own sections
- Artifact compliance and canonical vocabulary
- Structural improvements brain itself could benefit from

Compile brain findings as the baseline before auditing spokes.

**Phase 2 — Spoke audits (sequential, each vs brain)**

For each spoke in order, spawn @researcher to audit the spoke file against brain AND the brain baseline findings:

1. [researcher.agent.md](.github/agents/core/researcher.agent.md) vs brain
2. [architect.agent.md](.github/agents/core/architect.agent.md) vs brain
3. [build.agent.md](.github/agents/core/build.agent.md) vs brain
4. [inspect.agent.md](.github/agents/core/inspect.agent.md) vs brain
5. [curator.agent.md](.github/agents/core/curator.agent.md) vs brain

For each spoke audit, check:

- Do brain's `<agent_pool>` descriptions match the spoke's actual capabilities?
- Does the spoke's `<context_loading>` parse what brain's `<spawn_templates>` sends?
- Does the spoke's `<return_format>` produce what brain's `<rework_routing>` consumes?
- Does the spoke contain unnecessary context about brain's routing, other spokes' internals, or hub lifecycle details it cannot act on?
- All 13 dimensions from `<audit_dimensions>`

**Phase 3 — Cross-cutting synthesis**

After all 6 audits, synthesize:

- Patterns that repeat across multiple files (systemic issues vs isolated issues)
- Severity classification: P1 (blocks agent behavior), P2 (degrades quality), P3 (polish)
- Grouped action list: fix-once items (change in one file) vs fix-everywhere items (change in all files)

</workflow>


<output_format>

Present findings in this structure:

```
## Agent Consistency Audit

**Agents audited:** 6 (brain, researcher, architect, build, inspect, curator)
**Total findings:** {count}
**Breakdown:** P1: {n} | P2: {n} | P3: {n}

### Systemic Issues (apply to multiple agents)

- [{dimension}] {description}
  Affected: {agent list}
  Severity: P1 | P2 | P3
  Fix: {what to change}

### Per-Agent Findings

#### @{agent_name}

- [{dimension}] {description}
  Location: {section}, line ~{N}
  Severity: P1 | P2 | P3
  Fix: {what to change}

### Cross-Reference Mismatches

- brain `<agent_pool>` → @{spoke}: {mismatch description}
- brain `<spawn_templates>` → @{spoke} `<context_loading>`: {mismatch description}
- brain `<rework_routing>` → @{spoke} `<return_format>`: {mismatch description}

### Recommended Fix Order

1. {P1 items first, grouped by fix-once vs fix-everywhere}
2. {P2 items}
3. {P3 items}
```

After presenting findings, ask via #tool:askQuestions whether to proceed with fixes (spawn @build per agent) or export the action list for manual review.

</output_format>
