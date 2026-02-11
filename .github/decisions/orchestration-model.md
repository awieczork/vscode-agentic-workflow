---
description: 'Hub-and-spoke agent orchestration model — @brain as sole orchestrator, spoke agents execute and return, domain plug-in architecture'
---

This artifact defines the hub-and-spoke agent orchestration model. The governing principle is: @brain is the sole orchestrator; spokes execute and return. Users interact with @brain only — spoke agents are hidden from the UI. All inter-agent communication flows through @brain via `runSubagent`; no peer-to-peer routing exists. The generation pipeline has its own orchestration model documented in [generation-workflow-model.md](generation-workflow-model.md).


<agent_inventory>

Two agent groups operate in this workspace: core agents (hub-and-spoke lifecycle) and generation agents (linear creation pipeline).

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

- **@curator** (spoke) — Maintenance spoke. Final lifecycle agent after @inspect PASS. Syncs docs, cleans workspace, structures git commits. Scope controlled by `.github/curator-scope`
  - Mutation: high (git operations, file deletion)
  - `user-invokable: false`, `agents: []`
  - Tools: search, read, edit, execute
  - Reference: [curator.agent.md](../agents/core/curator.agent.md)

**Generation agents (3)** — Linear creation pipeline: interview → orchestrate → create. Documented in detail in [generation-workflow-model.md](generation-workflow-model.md).

- **@interviewer** — Conducts expert interview from seed prompt, produces specs and manifest. Has `handoffs` to @master. Tools: search, read, edit, web, askQuestions
- **@master** — Pipeline orchestrator. Reads manifest, scaffolds output, spawns @creator per artifact. Tools: search, read, edit, execute, runSubagent
- **@creator** — Artifact worker. Reads spec, fetches sources, selects creator skill via hard-coded mapping, produces artifact file. Tools: search, read, edit, web

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

Verdict routing from @inspect determines next action.

- **PASS** → Proceed to @curator if docs affected, otherwise complete
- **PASS WITH NOTES** → Surface Minor findings to user. If user requests fixes: @build → @inspect. If user accepts: proceed
- **REWORK NEEDED** → @brain parses findings: plan flaws → @architect (re-plan), build issues → @build (rework). After rework → @inspect re-inspection
- **BLOCKED** → @brain evaluates: clarify via #tool:askQuestions, re-spawn with narrowed scope, spawn @researcher for missing info, or accept gap
- **Escalation** — If same spoke needs rework more than twice, escalate to user

</rework_model>


<data_contracts>

What each spoke receives and returns. @brain mediates all transitions.

- **@brain → @researcher:** Focus + Scope + Mode + Variant → Returns: ≤10 findings with citations, markers (`[CONFLICT]`, `[OUT OF SCOPE]`, `[EMPTY]`)
- **@brain → @architect:** Direction + Scope + Constraints → Returns: phased plan with per-task success criteria, dependency verification, risk assessment
- **@brain → @build:** Plan (task subset) + Scope → Returns: build summary (files changed, tests, deviations, blockers)
- **@brain → @inspect:** Plan + Build Summary → Returns: verdict with evidence-backed findings (severity: `Critical` | `Major` | `Minor`)
- **@brain → @curator:** Action + Scope + Files Affected → Returns: maintenance report with health scan

</data_contracts>


<domain_plug_in>

Core agents form a fixed scaffold. Domain-specific agents plug in without modifying core agent files.

- **Discovery** — @brain uses `agents: ['*']` and discovers all agents in the workspace automatically
- **Awareness** — `copilot-instructions.md` lists all agents with descriptions. Core agents load this in context. Adding a domain agent to the workspace makes it visible to all core agents
- **Integration** — @architect plans reference domain agents by name. @brain spawns them per plan via `runSubagent`. No special wiring needed — the plan is the integration layer
- **Generation pipeline** — Produces domain agents via @creator with creator skills. Generated agents plug directly into the core model

**Domain agent requirements for plug-in compatibility:**

- `user-invokable: false` — users interact through @brain
- `agents: []` — domain agents execute, they do not orchestrate
- Structured return format so @brain can evaluate results
- Positive scope declaration in identity prose

</domain_plug_in>


<platform_fields>

VS Code frontmatter fields governing orchestration behavior.

- **`user-invokable`** — Boolean. Controls visibility in agents dropdown. `false` for all spokes
- **`disable-model-invocation`** — Boolean. Prevents being invoked as subagent. `true` only for @brain
- **`agents`** — Array of agent names or `['*']`. Restricts subagent spawning. Only @brain gets `['*']`
- **`handoffs`** — Declarative handoff with label + target agent + prompt. Used only by @interviewer → @master. Core model uses `runSubagent` instead
- **`tools`** — Array of tool aliases. Each agent receives minimum required tools
- **`argument-hint`** — Prompt text shown in UI. Only on user-invokable agents (@brain) and generation entry points

</platform_fields>
