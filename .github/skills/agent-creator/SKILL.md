---
name: 'agent-creator'
description: 'Creates and refactors .agent.md files that define autonomous AI agent personas with tools, constraints, and behavioral modes. Use when asked to "create an agent", "build an agent", "refactor an agent", "update an agent", "improve an agent file", or "scaffold an agent file". Produces frontmatter, identity prose, constraints, behaviors, outputs, and termination sections.'
---

This skill creates well-structured .agent.md files that define autonomous AI agent personas. The governing principle is single role per agent — each agent has one focused identity with clear boundaries. Begin with `<step_1_analyze>` to answer planning questions that orient subsequent steps.


<use_cases>

- Create a new agent from a role description or requirements spec
- Build a domain-specific agent using a behavioral profile archetype
- Scaffold an agent file with frontmatter, identity, constraints, and behaviors
- Define an agent's tools, modes, and handoff behavior

</use_cases>


<workflow>

Execute steps sequentially. Each step verifies its own output before proceeding to the next.


<step_1_analyze>

Answer the following questions about the target agent. Each answer maps to a section in the final agent file — a missing answer means a missing section.

- **What is this?** — Name, description, trigger words enable discovery and delegation
- **What role does the agent fill?** — Role, expertise, stance, and anti-identity define the agent's persona boundaries
- **What must never happen?** — Safety priorities and prohibitions protect against harmful actions
- **How does the agent behave?** — Core behaviors, modes, and context loading define execution patterns
- **What does the agent produce?** — Output formats, confidence thresholds, and templates set consumer expectations
- **When does the agent stop?** — Handoff targets, escalation conditions, and max cycles prevent unbounded execution

</step_1_analyze>


<step_2_determine_structure>

Load [agent-skeleton.md](./references/agent-skeleton.md) for: `<scaling>`, `<tag_vocabulary>`, `<core_principles>`.

Load [agent-profiles.md](./references/agent-profiles.md) for: `<profiles>`, `<two_layers>`.

Select scaling tier based on agent complexity:

- **Minimal** (~25 lines body) — Solo, single-task. `<constraints>` (2-3 bullets), `<behaviors>` (3-5 bullets, no sub-tags), `<outputs>` (1 template)
- **Medium** (~100-150 lines body) — Multi-mode, domain-focused. Priority hierarchy, 3-5 constraint bullets, 0-1 `<iron_law>`, `<context_loading>`, 2-3 `<mode>` tags, boundaries, confidence thresholds, 1-2 templates, optional `<termination>`
- **Full** (~300-400 lines body) — Orchestrated. 5-6 constraint bullets, 2-4 `<iron_law>` tags, red flags, `<context_loading>`, 2-4 `<mode>` tags, boundaries, update triggers, 2-3 templates, handoff payload format, full `<termination>` with 3-7 `<if>` conditions

Select profile archetype if applicable — match against `<profiles>` in [agent-profiles.md](./references/agent-profiles.md): Guide, Transformer, Curator, Diagnostician, Analyst, Operator. Profile selection pre-configures constraint patterns, sub-tag sets, tool selections, and output templates. If no profile fits, build from scratch using `<tag_vocabulary>` in [agent-skeleton.md](./references/agent-skeleton.md).

Finalize: tier selected, profile (or none), tags to include, sub-tags to include.

</step_2_determine_structure>


<step_3_write_frontmatter>

Load [agent-frontmatter-contract.md](./references/agent-frontmatter-contract.md) for: `<frontmatter_fields>`, `<tool_sets>`, `<tools_list>`, `<tools_selection_guidance>`.

**Name:** Derive from role or purpose. If `name` field is used: lowercase alphanumeric + hyphens, matches filename minus `.agent.md`. If omitted, VS Code derives from filename.

**Description:** Keyword-rich, single-line. Include trigger words so parent agents and users know when to invoke. State role and differentiation from other agents.

**Tools:** Select from `<tool_sets>` and `<tools_list>` in [agent-frontmatter-contract.md](./references/agent-frontmatter-contract.md). Use tool sets for broad capability, individual tools for boundary enforcement per `<tools_selection_guidance>` in [agent-frontmatter-contract.md](./references/agent-frontmatter-contract.md). Select the minimal set for the role — excess tools dilute focus.

**Optional fields:** `argument-hint` (guide user input), `handoffs` (agent transitions — label, agent, prompt, send).

</step_3_write_frontmatter>


<step_4_write_body>

Load [agent-skeleton.md](./references/agent-skeleton.md) for: `<tag_vocabulary>`, `<prose_intro_pattern>`, `<visual_skeleton>`, `<attributes>`.

Load [example-agent.md](./assets/example-agent.md) for: annotated reference output.

Write sections in this order per `<visual_skeleton>` in [agent-skeleton.md](./references/agent-skeleton.md):

1. **Identity prose** (no tag) — "{Role}. {Expertise}. {Stance}. {Anti-identity with delegation pointers}."

2. **`<constraints>`** — Required. Prose intro: "Priority: {hierarchy}." Then NEVER/ALWAYS bullets. Add red flags (optional) and `<iron_law id="">` tags (optional — only for agents with destructive tools, citation authority, or approval authority)

3. **`<behaviors>`** — Required. Prose intro: "Apply `<constraints>` first." Then `<context_loading>` (optional) with load order and `<on_missing>` fallbacks. Then `<mode name="">` tags (optional — only for multi-behavior agents). Then boundaries: Do / Ask First / Don't. Then update triggers (optional)

4. **`<outputs>`** — Required. Prose intro: consumer expectations. Confidence thresholds (High ≥80%, Medium 50-80%, Low <50%). 1-3 templates. Handoff payload format (if multi-agent)

5. **`<termination>`** — Optional (omit for solo agents). Prose intro: completion criteria. Handoff triggers, escalation triggers, `<if condition="">` recovery pairs, `<when_blocked>` template

Calibrate body length to tier from `<step_2_determine_structure>`.

</step_4_write_body>


<step_5_validate>

Run `<validation>` checks against the completed agent. Fix all P1 and P2 findings before delivery; flag P3 items without blocking. If any check fails, consult `<error_handling>` for recovery actions.

</step_5_validate>


</workflow>


<error_handling>

- If `name` format is invalid, then suggest corrected format (e.g., `My Agent` → `my-agent`), apply correction, continue
- If description lacks trigger words, then add keywords derived from role and purpose, continue
- If tools list includes tools outside agent's boundaries, then remove excess tools and flag removal
- If skill contamination detected (`<workflow>`, `<step_N_verb>`, `<use_cases>`, `<resources>` tags), then remove offending content — P1 blocker
- If modes have overlapping triggers, then disambiguate trigger phrases and flag conflict
- If profile archetype does not match requirements, then adapt profile or build from scratch
- If iron_laws used for non-critical agent (no destructive tools, citation, or approval authority), then remove iron_laws and use standard constraints
- If circular handoffs detected (A→B→A without progress criteria), then flag as P1 and require progress gates

</error_handling>


<validation>

**P1 — Blocking (fix before delivery):**

- `description` present in frontmatter, single-line string
- All YAML string values wrapped in single quotes: `name: 'value'`, `description: 'value'`
- If `tools` present, use inline array format: `tools: ['tool1', 'tool2']`
- If `name` present, format valid: lowercase alphanumeric + hyphens, matches filename pattern
- If `tools` present, every tool or tool-set name exists in `<tool_sets>` or `<tools_list>` in [agent-frontmatter-contract.md](./references/agent-frontmatter-contract.md)
- No skill tags: `<workflow>`, `<step_N_verb>`, `<use_cases>`, `<resources>` — these belong to skills
- No hardcoded secrets or absolute paths
- `<constraints>` present with NEVER/ALWAYS prohibitions
- `<behaviors>` present with executable actions
- `<outputs>` present with at least one template or format definition
- No references to specific agents (`@agentname`) in SKILL.md itself — skill is agent-agnostic (agent body MAY reference peers)

**P2 — Quality (fix before delivery):**

- No markdown headings — XML tags are exclusive structure
- No markdown tables outside `<outputs>` — use bullet lists with em-dash definitions
- Identity prose includes: role, expertise, stance, anti-identity
- If `tools` present, minimal set for role — no Swiss-army tooling
- No hedge safety language ("try to avoid", "should", "be careful") — use binary NEVER/ALWAYS
- Description is keyword-rich — no vague descriptions ("A helpful agent")
- Mode triggers (if present) are unambiguous — no overlapping activation phrases
- No scope bleed — agent body stays within declared role
- No circular handoffs without progress criteria
- Cross-file XML tag references use linked-file form: `<tag>` in [file.md](path) — same-file references use backticks only
- Every `Load [file] for:` directive resolves to an existing file
- No orphaned resources — every file in subfolders referenced from SKILL.md

**P3 — Polish (flag, do not block):**

- Prose intros follow `<prose_intro_pattern>` in [agent-skeleton.md](./references/agent-skeleton.md)
- Anti-identity explicitly names which peer agent to delegate to
- Active voice throughout, no hedging
- Constraint priority hierarchy stated explicitly
- Every file in the skill folder opens with a prose intro containing governing principle

</validation>


<resources>

- [agent-frontmatter-contract.md](./references/agent-frontmatter-contract.md) — Defines all YAML frontmatter fields for .agent.md files, including the complete tools catalog with tool sets and individual tools. Load for `<frontmatter_fields>`, `<tool_sets>`, `<tools_list>`, `<tools_selection_guidance>`
- [agent-skeleton.md](./references/agent-skeleton.md) — Structural reference for .agent.md body sections. Defines the closed tag vocabulary, scaling tiers (minimal/medium/full), and design rules that shape agent structure. Load for `<tag_vocabulary>`, `<scaling>`, `<core_principles>`, `<anti_patterns>`, `<prose_intro_pattern>`, `<visual_skeleton>`, `<attributes>`
- [agent-profiles.md](./references/agent-profiles.md) — Six reusable behavioral archetypes (guide, transformer, curator, diagnostician, analyst, operator) that pre-configure constraint patterns, sub-tag sets, and tool selections. Load for `<profiles>`, `<two_layers>`
- [example-agent.md](./assets/example-agent.md) — Ready-to-use Diagnostician profile agent at medium scaling tier (~120 lines body). Demonstrates identity prose in second-person voice, iron laws, context loading, modes, boundaries, and diagnosis report template

</resources>
