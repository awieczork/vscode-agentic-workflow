---
name: 'agent-creator'
description: 'Guides creation of domain-specialized .agent.md files by extending one of the five core roles (developer, researcher, planner, inspector, curator). Use when asked to "create an agent", "build a domain agent", "make a specialized agent", or "extend a core role" (e.g., python-developer, security-researcher, api-planner). The result is a complete .agent.md file with frontmatter, identity prose, constraint bullets, workflow steps, and output template.'
---

Follow these steps to create a domain-specialized agent by extending one of the five core roles. The governing principle is exemplar-driven specialization — study what works, then replicate the pattern for a new domain. Begin with `<step_1_understand>` to capture intent and validate inputs.


<use_cases>

- Build a Python-specialized developer agent
- Create a security-focused researcher for vulnerability analysis
- Extend the inspector role for API contract validation
- Add a docs-specialized developer for documentation projects

</use_cases>


<workflow>

Execute steps sequentially. Each step builds on the previous — intent determines the base agent, the base and exemplar inform structure, the spec governs content, generation produces the file, and validation confirms delivery readiness.


<step_1_understand>

Capture the user's intent and validate inputs.

- Determine the **domain name** — the specialization prefix (e.g., `python`, `security`, `api`, `webapp`, `docs`)
- Determine the **core role** to extend — must be one of: `developer`, `researcher`, `planner`, `inspector`, `curator`
- If the specified role is not one of the 5 archetypes, stop and report the error (see `<error_handling>`)
- Determine the **tool set** — default is to inherit tools from the target core agent. Load [role-frontmatters.md](references/role-frontmatters.md) for the baseline frontmatter of the target role. Note any domain-specific tool additions the user requests
- Created agents are always **subagent-only** (`user-invokable: false`) — never include user-interaction patterns, handoffs, or orchestration affordances
- If the user provides insufficient domain context to proceed, ask for clarification before continuing

**Output of this step:** domain name, target core role, tool set (inherited + additions if any), any domain-specific context the user provided.

</step_1_understand>


<step_2_study>

Study the base agent and the gold-reference exemplar to understand what needs specialization and what structural patterns to follow.

- If available in the workspace, search for the target core agent file (`{role}.agent.md`) and read it to observe its identity prose, constraint structure, workflow shape, output template, and tool set. If not available, proceed using the structural specification in [agent-spec.md](references/agent-spec.md) which contains all necessary patterns.
- Load [exemplar.md](assets/exemplar.md) — study the embedded gold-reference agent and its annotations to understand how a domain agent differs from its core counterpart
- Identify what sections need domain specialization:
  - Identity prose: domain character voice
  - Constraint bullets: domain-specific NEVER/ALWAYS rules
  - Workflow: domain vocabulary and domain-specific sub-actions
  - Output template: domain-specific fields
  - Domain XML tags: only if the domain has structurally distinct content

</step_2_study>


<step_3_plan>

Apply the structural specification to plan the new agent's content.

Load [agent-spec.md](references/agent-spec.md) and apply each section:

- **Frontmatter** — Plan the YAML header using the field spec and [role-frontmatters.md](references/role-frontmatters.md) for the baseline. File name follows `{domain}-{core-role}.agent.md`. The `name` field matches `{domain}-{core-role}`. The `description` uses one em-dash sentence stating what the agent delivers. Tools default to the core agent's tool set unless the domain requires additions or restrictions. `user-invokable` is always `false`, `agents` is always `[]`, and no `handoffs` definitions — all created agents are subagent-only.

- **Body structure** — Plan each section in order:
  - Identity prose: 2-4 sentences, character voice, second-person, em-dash role declaration, governing principle
  - Constraint bullets: 5-9 items in three layers — positive principles (2-3), domain NEVER/ALWAYS (3-5), HALT (1, always last)
  - Workflow: stateless-context preamble, 5 numbered steps with domain verbs, docs-before-code directive
  - Domain XML tags: only if content is structurally distinct enough to warrant separation
  - Output template: domain-named tag, Status COMPLETE|BLOCKED, conditional Session ID, domain-specific fields, realistic example

- **Positioning** — The agent extends its core role as a specialized alternative. Self-contained: no references to core agent, no orchestration language, no cross-agent references. Written from its own perspective.

- **Design guidelines** — Apply the 13 design patterns as guidelines during planning. Prioritize: voice over function, layered constraints, domain vocabulary in workflows, principles over enumerations, sections earn their keep.

</step_3_plan>


<step_4_generate>

Write the complete `.agent.md` file. Generate each section using the plan from step 3.

- **Frontmatter** — YAML between `---` fences. All string values single-quoted. Include: `name`, `description`, `tools`, `user-invokable`, `disable-model-invocation`, `agents` (empty array for domain agents). Always set `user-invokable: false` and `agents: []`. Never generate `handoffs`. Tool set defaults from core role baseline — domain may add tools but not remove core tools.

- **Identity prose** — Character voice expressing domain expertise and mindset. First sentence: "You are the {DOMAIN} {ROLE} — ..." with em-dash. Convey personality through verbs and rhythm, not adjectives. Present tense, second-person.

- **Constraint bullets** — Bare bullets (no wrapping tag), three layers:
  1. Positive-framing principles (2-3) — scope discipline, project-first orientation, mandatory build summary. Ground in domain language.
  2. Domain NEVER/ALWAYS (3-5) — concrete prohibitions and mandates unique to this specialization. Each states one rule with a reason clause.
  3. HALT (1, final) — unconditional stop for credentials, secrets, or PII.

- **`<workflow>`** — Open with a stateless-context preamble: two short paragraphs establishing that the agent receives a task with no prior history, plus a docs-before-code directive. Then 5 numbered steps using the format `**Verb** — description`. Steps use domain vocabulary for names and actions. Sub-bullets break down concrete actions. Include decision points inline.

- **Domain XML tags** — Add only if the domain has content structurally distinct enough for a dedicated section (tables, decision matrices, specialized guidelines). Name tags for the domain, not generically. If content can be absorbed into constraint bullets or workflow steps without loss, skip the tag.

- **Output template** — Domain-named tag (e.g., `<build_summary_template>`, `<analysis_template>`). Fenced code block with: Status COMPLETE|BLOCKED, Session ID `{echo if provided}`, Summary, domain-specific fields, Files Changed, Tests, Deviations, Blockers. Include a "When BLOCKED" variant with Reason, Partial work, and Need. Close with `<example>` sub-tag containing realistic output with plausible values.

The agent must be **self-contained** — no references to core agent files, no orchestration language ("spawn", "delegation", "session"), no `@agent` names in body. Output conventions exist as professional delivery practice, not because an orchestrator expects them.

Output file name: `{domain}-{core-role}.agent.md`

</step_4_generate>


<step_5_validate>

Quality-check the generated agent against all validation gates.

Load [quality-gates.md](references/quality-gates.md) and run each tier:

- **P1 — Blocking** (fix before delivery):
  - `description` present in frontmatter
  - All YAML string values single-quoted
  - File ends with `.agent.md`
  - Zero markdown headings (`#`) in agent body
  - No platform-reserved tags in body
  - No secrets or absolute paths

- **P2 — Quality** (fix before finalizing):
  - Description is keyword-rich and specific, not generic filler
  - All XML tags use `snake_case` with domain-specific names
  - No cross-agent `@` references in body
  - No project-specific or OS-specific paths

- **P3 — Polish** (flag as suggestions):
  - Active voice throughout — no hedging ("try to", "should")
  - Identity prose and major tags open with governing principles
  - Concise — no verbose padding
  - Complex rules include Wrong/Correct contrast pairs

- **Banned patterns scan** — Check for drive letters, bare `#tool:` references, `@agent` names outside brain, hard-coded model names, filler phrases, temporal language

- **Self-containment verification**:
  - No references to core agent files within the generated body
  - No orchestration vocabulary in workflow or constraints
  - No platform-reserved XML tags
  - Agent is readable and executable without knowledge of other agents

Fix all P1 and P2 issues. Report P3 suggestions to the user. If P1 fixes require structural changes, return to `<step_4_generate>`.

</step_5_validate>


</workflow>


<error_handling>

Recovery actions for common failure modes. Apply the matching recovery when an issue surfaces during any step.

- If the user specifies a **core role not in the 5 archetypes** (developer, researcher, planner, inspector, curator) — report the valid options and ask the user to select one before proceeding
- If the user provides **insufficient domain context** to differentiate the agent from the generic core role — ask targeted questions: What technologies or practices define this domain? What domain-specific constraints should it enforce? What makes this agent's workflow different from the core role?
- If **P1 validation failures** are found in step 5 — return to `<step_4_generate>` and fix the specific violations — do not regenerate the entire file unless structural issues require it
- If the generated file **exceeds 150 lines or falls below 80 lines** — review for verbose padding (trim) or missing sections (expand) — target 80-150 lines for a well-scoped domain agent

</error_handling>


<resources>

Reference files loaded on demand during workflow steps. All paths are relative to the skill folder.

**References:**

- [agent-spec.md](references/agent-spec.md) — Agent structural specification: frontmatter fields, body structure conventions, positioning rules, and 13 design guidelines. Loaded in step 2.
- [quality-gates.md](references/quality-gates.md) — Validation tiers (P1/P2/P3), banned patterns, platform-reserved tags, and agent anti-patterns. Loaded in step 5.
- [role-frontmatters.md](references/role-frontmatters.md) — Baseline frontmatter for each core role. Loaded in step 1 and step 3.

**Assets:**

- [exemplar.md](assets/exemplar.md) — Annotated pointer to the gold-reference agent (python-developer) with structural observations. Loaded in step 2.

</resources>
