---
description: 'Audit and refactor all 5 skills with external research for best practices in agentic skill design'
agent: 'brain'
argument-hint: 'Run via /audit-skills to start the full skill audit and refactor'
---

Audit and refactor all 5 skills in [skills/](.github/skills/) with comprehensive external research. Use [audit-agents.prompt.md](.github/prompts/audit-agents.prompt.md) as a structural precedent for the audit methodology — but adapt dimensions for skill artifacts instead of agent artifacts. Spawn @researcher instances for research phases, compile findings, and execute refactoring through @architect → @build → @inspect.


<audit_scope>

**Skills to audit (each = SKILL.md + references/ + assets/):**

1. [agent-creator](.github/skills/agent-creator/SKILL.md) — 169 lines + 3 references + 1 asset
2. [artifact-author](.github/skills/artifact-author/SKILL.md) — 123 lines + 2 references (shared: artifact-structure.md, glossary.md)
3. [instruction-creator](.github/skills/instruction-creator/SKILL.md) — 192 lines + 2 references + 2 assets
4. [prompt-creator](.github/skills/prompt-creator/SKILL.md) — 200 lines + 2 references + 1 asset
5. [skill-creator](.github/skills/skill-creator/SKILL.md) — 197 lines + 2 references + 1 asset

**Reference standards:**

- [artifact-structure.md](.github/skills/artifact-author/references/artifact-structure.md) — XML structure, document anatomy, formatting conventions
- [glossary.md](.github/skills/artifact-author/references/glossary.md) — Canonical vocabulary

**Total files in scope:** 5 SKILL.md + 11 reference files + 5 asset files = 21 files

</audit_scope>


<external_research>

Before auditing, spawn @researcher instances to gather external best practices. This research informs both the audit criteria and the refactoring direction. Each researcher instance must use `web` and `context7` tools for external source retrieval.

**Research wave 1 — Parallel instances (3-5):**

1. **Agentic skill design patterns** — Research how leading AI agent frameworks structure reusable skills/tools/capabilities. Focus on: skill decomposition, composition patterns, validation strategies, and progressive disclosure of context.
   Sources: GitHub repositories for AutoGPT, CrewAI, LangGraph, Semantic Kernel, OpenAI Agents SDK, Anthropic tool-use patterns. Look at how each framework defines reusable procedures that agents invoke.

2. **VS Code custom agent/skill ecosystem** — Research the current VS Code Copilot extensibility model for custom agents, skills, and prompt files. Focus on: what has changed since the skills were written, new capabilities, deprecated patterns, platform constraints on skill structure.
   Sources: VS Code docs, GitHub Copilot changelog, `microsoft/vscode` and `microsoft/vscode-copilot-release` repositories, Copilot extensibility blog posts, [github/awesome-copilot](https://github.com/github/awesome-copilot) for curated community patterns and examples.

3. **Prompt engineering for tool-using agents** — Research current best practices for instructing AI agents that use tools. Focus on: step decomposition granularity, when to inline vs externalize instructions, context window efficiency, instruction following reliability.
   Sources: Academic papers (arXiv), Anthropic/OpenAI prompt engineering guides, framework-specific documentation on agent instructions.

4. **Reference architecture for skill libraries** — Research how mature projects organize skill/plugin libraries. Focus on: folder conventions, metadata schemas, versioning, dependency management between skills, skill composition (skill-A referencing skill-B).
   Sources: GitHub Action marketplace structure, Backstage plugin architecture, Terraform provider patterns, VS Code extension contribution points.

**Research wave 2 — Synthesis (1 instance):**

5. **Synthesize findings** into actionable audit criteria. Produce:
   - A list of patterns from external sources that the current skills should adopt
   - A list of anti-patterns found externally that the current skills exhibit
   - Specific structural or content gaps compared to industry best practices
   - Recommended refactoring priorities ranked by impact on agent performance

</external_research>


<audit_dimensions>

Check every skill file (SKILL.md + references + assets) against these dimensions. For each finding, state: skill name, file, dimension, location (section + line), what is wrong, and recommended fix.

**Structural consistency:**

- SKILL.md follows skill document anatomy: frontmatter → prose intro → `<use_cases>` → `<workflow>` (with `<step_N_verb>` tags) → `<error_handling>` → `<validation>` → `<resources>`
- Step tags use imperative verb naming: `<step_1_analyze>`, `<step_2_determine_structure>` — no noun-only steps
- Spacing conventions: blank line after opening tag, before closing tag, two blank lines between major sections
- No agent-specific tags in skill files: `<constraints>`, `<behaviors>`, `<outputs>`, `<termination>`, `<iron_law>`, `<mode>`, `<context_loading>`
- No prompt-specific variable patterns in skill files
- No instruction-specific body group patterns used as skill structure
- Reference files follow artifact structure rules from [artifact-structure.md](.github/skills/artifact-author/references/artifact-structure.md)

**Cross-skill consistency:**

- All 5 SKILL.md files use consistent step naming patterns — if all have `step_1_analyze`, verify the analyze step serves the same purpose across skills
- Frontmatter fields are consistent: `name` + `description` per [skill-frontmatter-contract.md](.github/skills/skill-creator/references/skill-frontmatter-contract.md)
- Error handling follows consistent If/Then format across all skills
- Validation sections use consistent P1/P2/P3 severity structure
- `<resources>` sections use consistent description format with `Load for:` tag references

**Reference file quality:**

- Each reference file has a prose intro with governing principle
- Reference files do not chain (A → B → C) — each references back to SKILL.md only
- Content in reference files matches what SKILL.md `Load [file] for:` directives claim to find
- Tag names referenced in `Load for:` actually exist in the target file
- No orphaned files — every reference and asset is linked from SKILL.md
- No duplicate content between SKILL.md body and reference files
- Reference files stay under 500 lines; files exceeding this should be split

**Asset file quality:**

- Each example/asset demonstrates the skill's output at its described scaling tier
- Examples are realistic and self-consistent — they pass the skill's own `<validation>` checks
- Examples contain inline annotations explaining structural choices
- Assets reference the same tag vocabulary and formatting as the SKILL.md workflow

**Content quality:**

- Redundancy — rules stated in both SKILL.md and a reference file, duplicate validation checks, overlapping error handling conditions
- Contradictions — thresholds in SKILL.md vs reference files, formatting rules that conflict
- Noise — obvious statements, filler prose, over-explained concepts agents can infer
- Completeness — missing error conditions, validation gaps, unhandled edge cases
- Step granularity — steps too coarse (combining distinct actions) or too fine (splitting a single action)

**Language and voice:**

- Imperative voice in workflow steps: "Load", "Select", "Apply", "Validate"
- Active voice throughout — no passive constructions
- No hedging: "should", "try to", "consider", "perhaps", "might"
- Consistent "If X, then Y" format in error handling
- No identity prose leaking into skill files (skills are agent-agnostic)

**Artifact compliance — per [artifact-structure.md](.github/skills/artifact-author/references/artifact-structure.md):**

- XML tags as exclusive structure — zero markdown headings
- No emojis outside fenced code blocks
- No motivational phrases or artificial markers
- Consistent formatting: em-dash definitions, arrow notation for hierarchies, pipe-separated enums
- Markdown tables only inside data-oriented sections

**Canonical vocabulary — per [glossary.md](.github/skills/artifact-author/references/glossary.md):**

- No non-canonical aliases across all 21 files
- Consistent term usage: skill (not workflow/procedure), rule (not guideline), phase (not stage), error (not failure/fault), handoff (not delegation)

**Frontmatter hygiene:**

- `name` matches parent folder exactly
- `description` follows formula: `[What] + [When] + [Capabilities]`
- Description includes 2-4 trigger phrases in quotes
- Description ≤1024 characters, single-line
- All YAML string values in single quotes

**External best-practice alignment (from research):**

- Compare skill structure against patterns discovered in `<external_research>`
- Identify gaps where external frameworks handle things the skills miss
- Flag opportunities to adopt industry-proven patterns
- Note patterns the skills use well that align with external best practices

**Shared reference file analysis:**

- artifact-structure.md and glossary.md are shared by artifact-author but referenced by all skills indirectly — verify shared files serve all 5 skills accurately
- If shared files were updated during the recent agent audit, verify all skills still comply
- Check for circular dependencies or implicit assumptions between skills

</audit_dimensions>


<workflow>

Execute in 4 phases. Each phase builds context for the next.

**Phase 1 — External research (parallel @researcher instances)**

Spawn 4-5 @researcher instances per `<external_research>`. Each uses `web` and `context7` tools for external sources. Then spawn 1 synthesis instance to consolidate findings into actionable criteria.

Deliverable: Research brief with external patterns, anti-patterns, and recommended audit criteria additions.

**Phase 2 — Per-skill audits (parallel @researcher instances)**

For each of the 5 skills, spawn @researcher to audit:

1. SKILL.md against all dimensions from `<audit_dimensions>` (including external research findings)
2. Each reference file in `references/`
3. Each asset file in `assets/`
4. Cross-references between the skill's files (do `Load for:` directives resolve? Do tag references exist?)

Additionally spawn 1 @researcher for:

5. Cross-skill consistency — compare all 5 SKILL.md files for pattern consistency, shared reference integrity, and systemic issues

**Phase 3 — Synthesis and planning**

After all audits complete:

1. Synthesize findings: systemic vs isolated, P1/P2/P3 severity, fix-once vs fix-everywhere
2. Incorporate external research recommendations as refactoring direction
3. Present consolidated audit report per `<output_format>`
4. After approval, route to @architect for a phased refactoring plan accounting for:
   - Shared reference files (artifact-structure.md, glossary.md) may need changes affecting all skills
   - Skills must not cross-reference each other's internal files
   - Reference files that need splitting or restructuring
   - Asset files that need updating to match refactored structures
   - New reference or asset files recommended by external research

**Phase 4 — Execute refactoring**

After plan approval:

1. Spawn @build instances per @architect's phased plan
2. Spawn @inspect after each build phase
3. Route rework per standard rework routing
4. Spawn @curator for workspace cleanup after final @inspect PASS

</workflow>


<output_format>

Present findings in this structure:

```
## Skill Audit & Refactoring Report

**Skills audited:** 5 (agent-creator, artifact-author, instruction-creator, prompt-creator, skill-creator)
**Files analyzed:** {count} (SKILL.md + references + assets)
**External sources consulted:** {count}
**Total findings:** {count}
**Breakdown:** P1: {n} | P2: {n} | P3: {n}

### External Research Summary

**Key patterns to adopt:**
- {pattern} — Source: {source with URL}

**Anti-patterns found in current skills:**
- {anti-pattern} — Affects: {skill list}

### Systemic Issues (apply to multiple skills)

- [{dimension}] {description}
  Affected: {skill list}
  Severity: P1 | P2 | P3
  Fix: {what to change}

### Per-Skill Findings

#### {skill_name}

**SKILL.md:**
- [{dimension}] {description}
  Location: {section}, line ~{N}
  Severity: P1 | P2 | P3
  Fix: {what to change}

**Reference files:**
- [{file}] [{dimension}] {description}
  Severity: P1 | P2 | P3
  Fix: {what to change}

**Asset files:**
- [{file}] [{dimension}] {description}
  Severity: P1 | P2 | P3
  Fix: {what to change}

### Cross-Skill Consistency Issues

- {pattern inconsistency between skills}

### Recommended Refactoring Plan

1. {P1 items first, grouped by fix-once vs fix-everywhere}
2. {P2 items incorporating external research improvements}
3. {P3 items}
```

After presenting findings, ask whether to proceed with refactoring (route to @architect → @build → @inspect → @curator) or export for manual review.

</output_format>
