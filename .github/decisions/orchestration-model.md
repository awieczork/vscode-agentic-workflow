---
description: 'Core agent model — hub-and-spoke orchestration with 6 agents (@researcher added) and domain plug-in architecture'
---

This artifact defines the core agent model for multi-agent orchestration. The governing principle is hub-and-spoke — @brain is the sole orchestrator (hub) that spawns all other agents (spokes) via `runSubagent`. Spokes execute their specialized task and return results; they never route to each other. Users interact with @brain only; spoke agents are hidden from the UI.


<core_agents>

6 core agents forming a complete lifecycle: brainstorm → plan → implement → verify → maintain.

- **@brain** (hub) — Dynamic orchestrator. Frames problems with users, composes custom workflows from the agent pool, delegates to spokes via `runSubagent`, synthesizes results, tracks progress. The sole entry point for users
  - Profile: No archetype (built from scratch)
  - Mutation level: none (read-only)
  - `user-invokable`: `true`
  - `disable-model-invocation`: `true`
  - `agents`: `['*']`

- **@researcher** (spoke, parallel) — Exploration spoke — deep research, source synthesis, and perspective analysis on focused topics. Spawned 3-5 instances in parallel per brainstorm cycle. 2 modes: research + perspective. Stateless
  - Profile: No archetype (built from scratch)
  - Mutation level: none (read-only)
  - `user-invokable`: `false`
  - `disable-model-invocation`: `false`
  - `agents`: `[]`

- **@architect** (spoke) — Decomposes converged direction into actionable plans with measurable success criteria. Single planning mode
  - Profile: No archetype (built from scratch)
  - Mutation level: none (read-only)
  - `user-invokable`: `false`
  - `disable-model-invocation`: `false`
  - `agents`: `[]`

- **@build** (spoke) — Executes approved plans precisely. Creates, modifies, and deletes files. Follows the plan, flags deviations, reports blockers
  - Profile: No archetype (built from scratch)
  - Mutation level: high
  - `user-invokable`: `false`
  - `disable-model-invocation`: `false`
  - `agents`: `[]`

- **@inspect** (spoke) — Final quality gate. Checks quality AND plan compliance — security, edge cases, standards, glossary. Renders verdicts: PASS, PASS WITH NOTES, REWORK NEEDED. Read-only, never fixes
  - Profile: No archetype (built from scratch)
  - Mutation level: none (read-only)
  - `user-invokable`: `false`
  - `disable-model-invocation`: `false`
  - `agents`: `[]`

- **@curator** (spoke) — Closes the lifecycle loop. After inspection passes, syncs affected docs, cleans temporary files, structures git commits. Operates on workspace meta-level — decision docs, instructions, workspace references, git state. Never modifies project code
  - Profile: No archetype (built from scratch)
  - Mutation level: high (git operations, file deletion)
  - `user-invokable`: `false`
  - `disable-model-invocation`: `false`
  - `agents`: `[]`

</core_agents>


<orchestration_model>

@brain is the sole orchestrator. No peer-to-peer routing between spokes. No handoff frontmatter — @brain controls flow programmatically via `runSubagent`.

**Dynamic workflow model:**

@brain assesses each request, determines which agents are needed, composes a custom workflow, and executes. Default: proceed autonomously, reporting after each spoke.

**4 named patterns** (composed dynamically based on request):

- **Exploration only** — @researcher (parallel waves) → @brain synthesizes → recommend with confidence level. When: user wants to understand options, investigate, or compare approaches
- **Direct implementation** — @build (≤3 tasks, per IL_003) → @inspect → report. When: small, clear-scope change with no research or planning needed
- **Plan and build** — @architect → plan approval → @build (phased) → @inspect → report. When: scope is clear but complex (4+ tasks, dependencies)
- **Full pipeline** — @researcher → @architect → plan approval → @build (phased) → @inspect → report. When: complex work requiring both research and planning

**Execution rules:**

- Spawn spokes via #tool:runSubagent with Session ID (`{flow-name}-{datetime}`)
- Report progress inline after each spoke completes
- Plan approval: default mandatory, user can opt out during intake
- @build phasing: phases sequential, @build instances parallel within each phase
- @curator: spawned after @inspect PASS when changed files affect docs/config, or on-demand at user request

**Rework loop:** If @inspect returns REWORK NEEDED, @brain routes: plan flaws → @architect (re-plan), build issues → @build (rework). After @build rework → re-inspect. Track rework count — escalate to user on patterns.

**BLOCKED handling:** If any spoke returns BLOCKED, @brain evaluates: (A) ask user to clarify via #tool:askQuestions, (B) re-spawn with narrowed scope, (C) spawn @researcher for missing info, (D) accept gap and proceed.

**Mid-flow interruption:** If user changes topic: pause flow, report state, offer options: (A) Resume later, (B) Abandon, (C) Finish current spoke then pause.

</orchestration_model>


<agent_contract>

Interface pattern — what each spoke produces and what the next expects. @brain mediates all transitions.

**Spawn interface:** @brain uses standardized spawn templates: Session ID + Context (standard header), plus per-spoke body fields. Templates defined in `<spawn_templates>` section of [brain.agent.md](../../agents/core/brain.agent.md).

**Return interface:** Each spoke returns a structured result in its `<return_format>` (inline in the spoke's `<outputs>` section). @brain parses the result and decides: spawn next spoke, rework, or escalate to user.

**Data flow between spokes (mediated by @brain):**

- **@brain → @researcher:** Focus + Scope + Mode + Variant. Returns: ≤10 findings with citations
- **@brain → @architect:** Direction + Scope + Constraints. Returns: phase-based plan with success criteria
- **@brain → @build:** Plan (task subset) + Scope + Constraints. Returns: build summary (files, tests, deviations)
- **@brain → @inspect:** Plan + Build Summary. Returns: verdict (PASS/PASS WITH NOTES/REWORK NEEDED) with evidence
- **@brain → @curator:** Action + Scope + Files Affected. Returns: maintenance report with status

**Positive scope pattern:** Every agent declares its scope as positive statements in identity prose. Each spoke has a `<hub_position>` section describing its position in the hub-spoke model — who spawns it, when, what it receives/returns, adjacent spoke connections.

</agent_contract>


<domain_plug_in>

Core agents form a fixed scaffold. Domain-specific agents plug in without modifying core agent files.

**Discovery:** @brain uses `agents: ['*']` — it dynamically discovers all agents in the workspace, including domain-specific agents added by the generation pipeline or manually.

**Awareness:** The workspace `copilot-instructions.md` lists all agents with descriptions. Core agents load this file in `<context_loading>` HOT tier. When domain agents are added, they appear in `copilot-instructions.md` and become visible to all core agents automatically.

**Integration pattern:** @architect plans work that references domain agents by name. @brain spawns domain agents via `runSubagent` per the plan. Domain agents execute and return results to @brain. No special wiring needed — the plan is the integration layer.

**Domain agent requirements for plug-in compatibility:**

- Set `user-invokable: false` — users interact through @brain
- Set `agents: []` — domain agents execute, they do not orchestrate
- Return structured results so @brain can evaluate them
- Include positive scope declaration in identity prose referencing relevant core agents

</domain_plug_in>


<platform_fields>

VS Code frontmatter fields used by the core model. Documented here as the authoritative reference for agent creation.

- `user-invokable` — Boolean (default: `true`). Controls visibility in the agents dropdown. Set `false` for all spokes — only @brain appears in UI
- `disable-model-invocation` — Boolean (default: `false`). Prevents the agent from being invoked as a subagent by other agents. Set `true` only for @brain — it orchestrates, it is never orchestrated
- `agents` — Array of agent names or `['*']`. Restricts which subagents an agent can spawn. Only @brain gets `['*']`; all spokes get `[]`
- `handoffs` — Not used. @brain controls flow via `runSubagent`. Users switch agents manually from the picker if needed

@researcher follows spoke defaults: `user-invokable: false`, `disable-model-invocation: false`, `agents: []`.

</platform_fields>
