---
description: 'Hub-and-spoke agent orchestration model — @brain as sole orchestrator, spoke agents execute and return, domain plug-in architecture'
---

This artifact defines the hub-and-spoke agent orchestration model. The governing principle is: @brain is the sole orchestrator; spokes execute and return. Users interact with @brain only — spoke agents are hidden from the UI. All inter-agent communication flows through @brain via `runSubagent`; no peer-to-peer routing exists. The generation pipeline runs through core spokes as a standard @brain-orchestrated workflow — see [generation-workflow.model.md](generation-workflow.model.md) for the refactored design.


<agent_inventory>

*Note: Architectural reference view. The operational copy is `<agent_pool>` in [brain.agent.md](../agents/core/brain.agent.md).*

One agent group operates in this workspace: core agents (hub-and-spoke lifecycle). Generation runs through these same core agents — no dedicated generation agents exist.

**Core agents (6)** — Hub-and-spoke lifecycle: brainstorm → plan → implement → verify → maintain.

- **@brain** (hub) — Sole orchestrator and user-facing entry point. Frames problems, composes workflows dynamically, spawns spokes via `runSubagent`, synthesizes results, tracks progress
  - Mutation: read-only
  - `user-invokable: true`, `disable-model-invocation: true`, `agents: ['*']`
  - Tools: search, read, runSubagent, renderMermaidDiagram, askQuestions, todo
  - Reference: [brain.agent.md](../agents/core/brain.agent.md)

- **@researcher** (spoke, parallel) — Exploration spoke. Deep research, source synthesis, perspective analysis. Spawned 3-5 instances in parallel per wave. Modes: research (quick | deep | synthesis), perspective (pre-mortem | skeptic | steel-man)
  - Mutation: read-only
  - `user-invokable: false`, `agents: []`
  - Tools: search, read, web, context7
  - Reference: [researcher.agent.md](../agents/core/researcher.agent.md)

- **@architect** (spoke) — Planning spoke. Decomposes direction into phased, dependency-verified plans with measurable success criteria per task
  - Mutation: read-only
  - `user-invokable: false`, `agents: []`
  - Tools: search, read
  - Reference: [architect.agent.md](../agents/core/architect.agent.md)

- **@build** (spoke, parallel) — Implementation spoke. Executes approved plans. Multiple instances run in parallel per phase
  - Mutation: high
  - `user-invokable: false`, `agents: []`
  - Tools: search, read, edit, execute, context7
  - Reference: [build.agent.md](../agents/core/build.agent.md)

- **@inspect** (spoke) — Verification spoke. Final quality gate checking quality AND plan compliance. Verdicts: `PASS` | `PASS WITH NOTES` | `REWORK NEEDED`
  - Mutation: read-only
  - `user-invokable: false`, `agents: []`
  - Tools: search, read, context7, runTests, testFailure, problems
  - Reference: [inspect.agent.md](../agents/core/inspect.agent.md)

- **@curator** (spoke) — Maintenance spoke. Final lifecycle agent after @inspect PASS. Syncs docs, cleans workspace, structures git commits. Scope controlled by `.github/.curator-scope`
  - Mutation: high (git operations, file deletion)
  - `user-invokable: false`, `agents: []`
  - Tools: search, read, edit, execute
  - Reference: [curator.agent.md](../agents/core/curator.agent.md)

</agent_inventory>


<orchestration_rules>

**Spoke constraints (all core spokes):**

- `user-invokable: false` — only @brain appears in UI
- `agents: []` — spokes never spawn other agents
- No peer-to-peer routing — all results return to @brain
- No `handoffs` field — @brain controls flow via `runSubagent`
- Only @brain has `disable-model-invocation: true` (prevents being spawned as subagent)

**Flow composition** — @brain selects the workflow dynamically based on request assessment:

- Informational question → @brain reads files, responds directly. No spoke needed
- Exploration → @researcher (parallel waves) → @brain synthesizes → recommend
- Direct implementation (trivially clear single-file, per IL_003) → @build → @inspect
- Plan and build → @architect → plan approval → @build (phased, parallel per phase) → @inspect
- Full workflow → @researcher → @architect → plan approval → @build (phased) → @inspect
- Verify existing code → @inspect directly (no build needed)
- Workspace maintenance → @curator directly (no build/inspect cycle)

**Execution protocol:**

- Session ID format: `{flow-name}-{datetime}`
- Spawn via `runSubagent` with standardized payload: Session ID + Context + spoke-specific body field (Focus for @researcher, Direction for @architect, Task/Plan for @build, Plan + Build Summary for @inspect, Action for @curator). Templates in `<spawn_templates>` of [brain.agent.md](../agents/core/brain.agent.md)
- Progress report after each spoke completes
- Plan approval mandatory by default — user can opt out during intake
- @build phasing: phases run sequentially, @build instances parallel within each phase. @architect assigns non-overlapping file sets
- @curator: spawned after @inspect PASS when changed files affect docs/config

</orchestration_rules>


<rework_model>

*Note: Architectural reference view. The operational copy is `<rework_routing>` in [brain.agent.md](../agents/core/brain.agent.md).*

Each spoke's return status determines @brain's next action. If the same spoke requires rework more than twice, escalate to the user — repeated failures suggest a structural issue that routing alone cannot fix.

**@inspect verdict routing:**

- **PASS** → Proceed to @curator if changed files affect docs or config, otherwise complete
- **PASS WITH NOTES** → Surface Minor findings to user. If user requests fixes: spawn @build for the specific items then re-spawn @inspect. If user accepts notes: proceed to @curator if applicable
- **REWORK NEEDED** → @brain parses findings into two categories: plan flaws → re-spawn @architect with `Rework: plan-flaw` + evidence + original plan; build issues → re-spawn @build with `Rework: build-issue` + findings + original plan. After rework → re-spawn @inspect with `Rework: re-inspection`

**@researcher returns:**

- **COMPLETE** → Use findings as input for next workflow step (e.g., feed to @architect as context)
- **COMPLETE with insufficient findings** → Re-spawn with `Rework: research` + narrowed scope or adjusted Focus
- **BLOCKED** → Required Focus missing or scope too vague. Re-spawn with corrected prompt or escalate to user for clarification

**@architect returns:**

- **COMPLETE** → Proceed to plan approval with user
- **BLOCKED** → Diagnose missing fields or unclear requirements in the original spawn prompt. Re-spawn with corrected prompt including the missing information, or escalate to user if the gap requires information @brain does not have

**@curator returns:**

- **COMPLETE** → Maintenance done. Review health scan findings — if orphaned files or stale docs reported, decide: spawn @curator again with targeted action, surface to user, or defer
- **PARTIAL** → Some tasks failed. Review maintenance report for what succeeded and what blocked. Re-spawn with `Rework: maintenance` + prior report for the failed tasks
- **BLOCKED** → Required fields missing or critical error. Fix the gap and re-spawn

**Any spoke BLOCKED (generic handling):**

- Diagnose the missing fields or unclear requirements in the original spawn prompt
- Re-spawn with corrected prompt including the missing information
- If the gap requires information @brain does not have, escalate to the user with the BLOCKED reason and what is needed

</rework_model>


<data_contracts>

*Note: Architectural reference view. The operational copy is `<spawn_templates>` in [brain.agent.md](../agents/core/brain.agent.md).*

What each spoke receives and returns. @brain mediates all transitions.

All spokes receive two standard input fields in addition to their spoke-specific fields:

- **Session ID** — `{flow-name}-{datetime}` format. Required for all spawns
- **Context** — Prior findings, relevant code, or rework instructions. Prefix with `Rework:` variant when re-spawning (e.g., `Rework: research`, `Rework: build-issue`)

Spoke-specific contracts:

- **@brain → @researcher:** Focus + Scope + Mode + Variant (optional — defaults per mode) → Returns: ≤10 findings with citations, markers (`[CONFLICT]`, `[OUT OF SCOPE]`, `[EMPTY]`)
- **@brain → @architect:** Direction + Scope + Constraints (optional) → Returns: phased plan with per-task success criteria, dependency verification, risk assessment
- **@brain → @build:** Plan (task subset) + Scope → Returns: build summary (files changed, tests, deviations, blockers)
- **@brain → @inspect:** Plan + Build Summary + Scope (optional) → Returns: verdict with evidence-backed findings (severity: `Critical` | `Major` | `Minor`)
- **@brain → @curator:** Action + Scope + Files Affected (required for sync-docs) + Verdict (optional) + Build Summary (optional) → Returns: maintenance report with health scan
- **@brain → domain agent:** See `<domain_agent_model>` in [generation-workflow.model.md](generation-workflow.model.md) for detailed domain agent contracts including mutation tiers, orchestration positions, and advisory patterns

</data_contracts>


<domain_plug_in>

Core agents form a fixed scaffold. Domain-specific agents plug in without modifying core agent files.

- **Discovery** — @brain uses `agents: ['*']` and discovers all agents in the workspace automatically
- **Awareness** — `copilot-instructions.md` lists all agents with descriptions. Core agents load this in context. Adding a domain agent to the workspace makes it visible to all core agents
- **Integration** — @architect plans reference domain agents by name. @brain spawns them per plan via `runSubagent`. No special wiring needed — the plan is the integration layer
- **Generation pipeline** — Produces domain agents via @build using 6 creator skills (agent-creator, artifact-author, skill-creator, instruction-creator, prompt-creator, copilot-instructions-creator). The pipeline is orchestrated by @brain through standard spokes — see [generation-workflow.model.md](generation-workflow.model.md)

**Domain agent requirements for plug-in compatibility:**

- `user-invokable: false` — users interact through @brain
- `agents: []` — domain agents execute, they do not orchestrate
- Structured return format so @brain can evaluate results
- Positive scope declaration in identity prose

This section covers plug-in compatibility requirements. See `<domain_agent_model>` in [generation-workflow.model.md](generation-workflow.model.md) for detailed capability tiers and orchestration positions.

</domain_plug_in>


<platform_fields>

VS Code frontmatter fields governing orchestration behavior.

- **`user-invokable`** — Boolean. Controls visibility in agents dropdown. `false` for all spokes
- **`disable-model-invocation`** — Boolean. Prevents being invoked as subagent. `true` only for @brain
- **`agents`** — Array of agent names or `['*']`. Restricts subagent spawning. Only @brain gets `['*']`
- **`handoffs`** — Declarative handoff with label + target agent + prompt. Not used in the current model — all routing uses `runSubagent` instead
- **`tools`** — Array of tool aliases. Each agent receives minimum required tools
- **`argument-hint`** — Prompt text shown in UI. Only on user-invokable agents (@brain)
- **`model`** — Suggest LLM model for agent
- **`mcp-servers`** — Enable MCP servers for agent
- **`target`** — Restrict agent to `cli` or `editor`

</platform_fields>
