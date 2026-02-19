---
name: 'agent-creator'
description: 'Guides creation of domain-specialized .agent.md files by extending one of the five core roles (developer, researcher, planner, inspector, curator). Use when asked to "create an agent", "build a domain agent", "make a specialized agent", or "extend a core role" (e.g., python-developer, security-researcher, api-planner). The result is a complete .agent.md file with frontmatter, identity prose, constraint bullets, workflow steps, and output template.'
---

Follow these steps to create a domain subagent by inheriting a core role and specializing it for a domain. The governing principle is role-based inheritance — each core role defines a structural baseline (step names, constraint layers, output template) that the domain agent inherits and extends with domain-specific expertise. The five core roles are: developer, researcher, planner, inspector, curator. Begin with `<step_1_understand>` to capture intent and load the target role's baseline.


<use_cases>

- "Create a python-developer agent" — extend developer for Python projects
- "Build a security-researcher" — extend researcher for vulnerability analysis
- "Make an api-planner agent" — extend planner for API design workflows
- "Extend the inspector for accessibility" — specialize inspector for a11y audits
- "Create a docs-curator agent" — extend curator for documentation governance

</use_cases>


<workflow>

Execute steps sequentially. Each step builds on the previous — intent selects the core role, the role baseline defines inherited structure, the spec governs specialization, generation writes the file, and validation confirms delivery readiness.


<step_1_understand>

Capture the user's intent and load the target role's structural baseline.

- Determine the **domain name** — the specialization prefix (e.g., `python`, `security`, `api`, `webapp`, `docs`)
- Determine the **core role** to extend — must be one of: `developer`, `researcher`, `planner`, `inspector`, `curator`
- If the specified role is not one of the 5 core roles, stop and report the error (see `<error_handling>`)
- Load [references/roles/{role}.md](references/roles/) for the target role — this provides the frontmatter baseline, workflow step names, constraint layers, output template shape, and inheritance guidance. Only the target role's file is loaded (progressive loading).
- Created agents are always **subagent-only** (`user-invokable: false`) — never include user-interaction patterns, handoffs, or orchestration affordances
- Note any domain-specific tool additions the user requests — tools default to the core role's baseline set
- If the user provides insufficient domain context to proceed, ask for clarification before continuing

**Output of this step:** domain name, target core role, inherited baseline (from role file), tool set (inherited + additions if any), domain-specific context.

</step_1_understand>


<step_2_study>

Study the exemplar and base agent to understand how inheritance produces a domain agent.

- If available in the workspace, search for the target core agent file (`{role}.agent.md`) and read it to observe how the baseline manifests in practice — identity prose, constraint structure, workflow, output template, and tool set. If not available, proceed using the role baseline loaded in step 1 and the structural specification.
- Load [exemplar.md](assets/exemplar.md) — study the gold-reference agent and its annotations to see how a domain agent inherits its core role's structure while rewriting identity and specializing constraints
- Identify what gets inherited vs. rewritten:
  - **Inherited (immutable):** workflow step names and ordering, output template base fields, hygiene and project constraint layers
  - **Specialized:** domain constraint layer (NEVER/ALWAYS rules unique to the domain), workflow sub-actions and domain vocabulary, domain-specific output fields
  - **Rewritten:** identity prose — the domain agent gets its own character voice, not a copy

</step_2_study>


<step_3_plan>

Apply the structural specification to plan how the inherited baseline gets specialized.

Load [agent-spec.md](references/agent-spec.md) and apply each section using the role baseline from step 1:

- **Frontmatter** — Start from the role's `<frontmatter_baseline>`. File name: `{domain}-{core-role}.agent.md`. `name` matches `{domain}-{core-role}`. `description` uses one em-dash sentence stating what the agent delivers. Tools default to the role baseline — domain may add tools but not remove core tools. `user-invokable` is always `false`, `agents` is always `[]`, no `handoffs`.

- **Identity prose** — Fully rewritten for the domain. 2-4 sentences, character voice, second-person, em-dash role declaration, governing principle. The domain agent gets its own personality — not a paraphrase of the core role.

- **Constraint bullets** — Three-layer transformation from the role's `<constraint_baseline>`:
  1. **Project-rules** (inherited as-is) — workspace boundary, scope discipline
  2. **Domain-rules** (specialized) — replace core domain-rules with 3-5 concrete NEVER/ALWAYS rules unique to this specialization, each with a reason clause
  3. **Hygiene-rules** (inherited as-is) — build summary, BLOCKED status, HALT for credentials

- **Workflow** — Step names from the role's `<workflow_baseline>` are immutable — never rename or reorder. Add domain-specific sub-actions, vocabulary, and decision points within each step. Open with a stateless-context preamble and docs-before-code directive.

- **Output template** — Additive on the role's `<output_template_baseline>`. Keep all base fields (Status, Session ID, Summary, Files Changed, Tests, Deviations, Blockers). Append domain-specific fields only if the domain produces distinct deliverables. Include realistic example.

- **Domain XML tags** — Inherit tag names from the role's `<domain_tags>` where applicable. Add new tags only if the domain has structurally distinct content that cannot be absorbed into existing sections.

- **Design guidelines** — Apply the 13 design patterns from agent-spec.md. Prioritize: voice over function, layered constraints, domain vocabulary in workflows, principles over enumerations.

</step_3_plan>


<step_4_generate>

Write the complete `.agent.md` file. Generate each section by specializing the inherited baseline.

- **Frontmatter** — YAML between `---` fences. All string values single-quoted. Start from the role's frontmatter baseline. Include: `name`, `description`, `tools`, `user-invokable`, `disable-model-invocation`, `agents` (empty array). Always set `user-invokable: false` and `agents: []`. Never generate `handoffs`. Tools default to the role baseline — domain may add but not remove.

- **Identity prose** — Fully rewritten for the domain. First sentence: "You are the {DOMAIN} {ROLE} — ..." with em-dash. Convey domain personality through verbs and rhythm, not adjectives. Present tense, second-person.

- **Constraint bullets** — Bare bullets (no wrapping tag). Three-layer transformation:
  1. Project-rules (inherited as-is) — workspace boundary, scope discipline
  2. Domain-rules (specialized) — 3-5 concrete NEVER/ALWAYS rules unique to this domain, each with a reason clause
  3. Hygiene-rules (inherited as-is) — build summary, BLOCKED status, HALT always last

- **`<workflow>`** — Stateless-context preamble, then steps using inherited step names from the role baseline. Domain vocabulary in sub-actions. Decision points inline. Docs-before-code directive where applicable.

- **Domain XML tags** — Reuse tag names from the role's `<domain_tags>`. Add new tags only if the domain has structurally distinct content. Name tags for the domain, not generically.

- **Output template** — Use the tag name from the role's `<output_template_baseline>`. Base fields inherited (Status, Session ID, Summary, Files Changed, Tests, Deviations, Blockers). Domain fields appended. Include "When BLOCKED" variant. Close with `<example>` sub-tag containing realistic output.

The agent must be **self-contained** — no references to core agent files, no orchestration language ("spawn", "delegation", "session"), no `@agent` names in body. The inheritance model informs generation, but the output stands alone.

Output file name: `{domain}-{core-role}.agent.md`

</step_4_generate>


<step_5_validate>

Quality-check the generated agent against all validation gates.

Load [quality-gates.md](references/quality-gates.md) and run each tier:

- **P1 — Blocking** (fix before delivery): subagent-only fields enforced (`user-invokable: false`, `agents: []`, no `handoffs`/`argument-hint`/`target`), required fields present, YAML strings single-quoted, file ends with `.agent.md`, zero markdown headings, no platform-reserved tags, no secrets or absolute paths

- **P2 — Quality** (fix before finalizing): description keyword-rich, tags use `snake_case` with domain names, no cross-agent `@` references, no project-specific paths

- **P3 — Polish** (flag as suggestions): active voice throughout, governing principles open major sections, concise prose, contrast pairs for complex rules

- **Banned patterns scan** — Check for drive letters, bare `#tool:` references, `@agent` names outside brain, hard-coded model names, filler phrases, temporal language

- **Self-containment verification** — No references to core agent files, no orchestration vocabulary, no platform-reserved tags, agent is fully readable without knowledge of other agents

Fix all P1 and P2 issues. Report P3 suggestions to the user. If P1 fixes require structural changes, return to `<step_4_generate>`.

</step_5_validate>


</workflow>


<error_handling>

Recovery actions for common failure modes. Apply the matching recovery when an issue surfaces during any step.

- If the user specifies a **core role not in the 5 core roles** (developer, researcher, planner, inspector, curator) — report the valid options and ask the user to select one before proceeding
- If the user provides **insufficient domain context** to differentiate the agent from the generic core role — ask targeted questions: What technologies or practices define this domain? What domain-specific constraints should it enforce? What makes this agent's workflow different from the core role?
- If **P1 validation failures** are found in step 5 — return to `<step_4_generate>` and fix the specific violations — do not regenerate the entire file unless structural issues require it
- If the generated file **exceeds 150 lines or falls below 80 lines** — review for verbose padding (trim) or missing sections (expand) — target 80-150 lines for a well-scoped domain agent

</error_handling>


<resources>

Reference files loaded on demand during workflow steps. All paths are relative to the skill folder.

**References:**

- [agent-spec.md](references/agent-spec.md) — Agent structural specification: frontmatter fields, body structure conventions, positioning rules, and design guidelines. Loaded in step 3.
- [quality-gates.md](references/quality-gates.md) — Validation tiers (P1/P2/P3), banned patterns, platform-reserved tags, and agent anti-patterns. Loaded in step 5.
- [references/roles/{role}.md](references/roles/) — Per-role structural baselines (frontmatter, workflow steps, constraint layers, output template, inheritance guidance), loaded progressively based on target role. Loaded in step 1.

**Assets:**

- [exemplar.md](assets/exemplar.md) — Annotated pointer to the gold-reference agent (python-developer) with structural observations. Loaded in step 2.

</resources>
