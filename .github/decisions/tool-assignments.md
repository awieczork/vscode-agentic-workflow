---
description: 'Tool set and individual tool assignments for core agents with design rationale'
---

This artifact maps tool sets and individual tools to core agents. The governing principle is minimal surface area — use built-in tool sets as primary assignments; cherry-pick individual tools only when a tool set grants capabilities beyond the agent boundary. Decided 2026-02-07 based on @brain exploration of VS Code platform contract and agent boundaries.


<design_principles>

- Use built-in tool sets as primary; individual tools only when a tool set is too wide
- `memory` lives inside `execute` set — agents needing `memory` without terminal must cherry-pick it individually
- @brain has no `edit` (read-only explorer + orchestrator)
- @inspect has no `edit` (reports, does not fix)
- `askQuestions` deferred for @brain — communicates through conversation for now

</design_principles>


<tool_map>

- **@brain** — Tool sets: `search`, `read`, `web`. Individual: `runSubagent`, `switchAgent`, `memory`, `vscodeAPI`, `renderMermaidDiagram`. Full exploration + orchestration + research. No edit, no terminal execution
- **@architect** — Tool sets: `search`, `read`. Individual: `todo`, `switchAgent`, `renderMermaidDiagram`. Explore to plan, track work, visualize, hand off
- **@build** — Tool sets: `search`, `read`, `edit`, `execute`. No individual tools. Full implementation capability. Gets `memory` + terminal via `execute`
- **@inspect** — Tool sets: `search`, `read`. Individual: `runTests`, `testFailure`, `problems`. Read-only exploration + quality tools. No edit

</tool_map>


<change_log>

- **@brain** — Removed: `agent`, `edit`, `vscode`. Added: `runSubagent`, `switchAgent`, `memory`, `vscodeAPI`, `renderMermaidDiagram`. `agent` replaced by individual `runSubagent`; `edit` violates read-only boundary; `vscode` too wide — cherry-pick `switchAgent` + `vscodeAPI`; needs diagram visualization
- **@architect** — Removed: `edit`. Added: `switchAgent`, `renderMermaidDiagram`. Architect plans, does not implement; needs handoff capability and diagram visualization
- **@build** — Removed: `agent`. No additions. Build implements, does not delegate
- **@inspect** — Removed: `execute`. Added: `runTests`, `testFailure`, `problems`. `execute` too wide — inspector does not need terminal; individual quality tools are precise

</change_log>
