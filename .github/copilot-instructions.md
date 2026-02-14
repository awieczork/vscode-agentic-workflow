This workspace is a framework for building agentic workflows in VS Code. It uses a hub-and-spoke orchestration pattern — @brain delegates to specialized subagents. Every artifact is written FOR AI agents TO execute.


<workspace>

Directory map — load this first to locate resources.

- `.github/agents/core/` — Core agent definitions (brain, researcher, planner, builder, inspector, curator)
- `.github/agent-workflows/` — Multi-agent workflow orchestrations (evolution, generation)
- `.github/instructions/` — Path-specific instruction files — `Reserved`
- `.github/prompts/` — One-shot prompt templates (evolve, init-project, calibrate)
- `.github/skills/artifact-creator/` — Unified skill for creating/refactoring all artifact types
- `.github/skills/mermaid-diagramming/` — B4 plan visualization diagrams for @brain with fork-join parallelism, agent delegation, and teal monochrome styling

</workspace>


<agents>

Hub-and-spoke: @brain receives requests and delegates to subagents. Each agent has its own definition in `.github/agents/core/`.

- `@brain` — Central orchestrator, routes tasks, tracks session state
- `@researcher` — Deep research and source synthesis on focused topics
- `@planner` — Decomposes problems into phased, dependency-verified plans
- `@builder` — Executes implementation tasks, produces working code
- `@inspector` — Final quality gate, verifies against plan and standards
- `@curator` — Workspace maintenance: docs sync, git commits, cleanup

</agents>


<conventions>

- **Artifact types** — agents, skills, prompts, instructions, copilot-instructions — one type per file
- **Agent structure** — identity prose → bullet constraints → `<workflow>` → domain tags → output template
- **XML tags replace headings** — free-form, domain-specific, snake_case names; no markdown headings in artifact bodies
- **Authoring** — use the `artifact-creator` skill when creating or modifying any artifact
- **Canonical terms** — constraint (not restriction), skill (not procedure), handoff (not delegation), escalate (not interrupt), fabricate (not hallucinate)

</conventions>


<rules>

- This file takes precedence over all other instruction files in the workspace
- Never fabricate sources, file paths, or quotes — verify before citing
- Do only what is requested or clearly necessary — treat undocumented features as unsupported
- When rules conflict, apply: Safety → Accuracy → Clarity → Style — the first dimension that distinguishes options wins
- When uncertain: high confidence → proceed; medium → flag and ask; low → stop and clarify
- When resources are unavailable, state the gap and continue with an explicit workaround

</rules>
