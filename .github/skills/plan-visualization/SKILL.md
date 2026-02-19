---
name: 'plan-visualization'
description: 'Guides creation and updating of Mermaid flowchart diagrams that visualize implementation plans and track progress through phase transitions. Use when asked to "visualize a plan", "render a plan diagram", "show plan progress", or "update the plan diagram". Produces accessible dark-mode Mermaid flowcharts with role-distinct colors, status-aware styling, fork/join parallel phases, inspector gates, and rework loops.'
---

Follow these steps to create or update a Mermaid flowchart diagram that maps an implementation plan to a visual representation. The governing principle is living visualization — diagrams are not static snapshots but progress-tracking instruments that reflect current workflow state through status-aware styling. Begin with `<step_1_assess>` to determine the rendering context.


<use_cases>

- Render a newly approved plan as a Mermaid flowchart with all phases pending
- Update an existing plan diagram after a phase completes to reflect progress
- Visualize a plan with parallel phases using fork/join topology
- Re-render a diagram after an inspector returns REWORK NEEDED to show rework loops
- Create a plan diagram for user approval during the planning phase

</use_cases>


<workflow>

Execute steps sequentially. Step 1 determines context (initial render vs. progress update), step 2 builds the diagram using palette and mapping references, and step 3 validates the output against rendering constraints. The executing agent has access to the plan structure (phases, dependencies, agent assignments) and current phase statuses.


<step_1_assess>

Determine the rendering context and gather inputs.

- Classify the render type:
  - **Initial render** — generating a diagram for a newly approved plan; all phases are pending
  - **Progress update** — re-rendering an existing diagram after one or more phases have changed status (completed, active, rework)
- Gather the plan structure:
  - List all phases with their `[parallel]` or `[sequential]` markers
  - Identify agent assignments per task (`@developer`, `@researcher`, `@planner`, `@inspector`, `@curator`)
  - Note file targets for each task (used as second-line labels in task nodes)
  - Identify inter-phase dependencies
- For progress updates, gather current status of each phase:
  - **Completed** — phase finished successfully
  - **Active** — phase currently executing
  - **Pending** — phase not yet started
  - **Rework** — phase sent back by inspector for revision

**Output of this step:** render type (initial or progress), phase list with agents and files, dependency map, and per-phase status (for progress updates).

</step_1_assess>


<step_2_compose>

Build the Mermaid flowchart by applying the color palette and mapping rules to the assessed plan.

- Load [palette.md](references/palette.md) — select the appropriate `classDef` set:
  - For **initial renders**, use the role-based palette (each agent role gets its distinct color) with task, gate, and done classes
  - For **progress updates**, merge role-based and status-based classDefs — completed phases override role colors with the completed class, the active phase gets the active highlight, pending phases get the muted class, rework phases get the rework class

- Load [mapping-rules.md](references/mapping-rules.md) — translate the plan structure to Mermaid syntax:
  - Apply the topology rules: fork/join for parallel phases, thick edges for sequential phases
  - Create node definitions with proper shapes: stadium for orchestrator and terminal nodes, rectangles for agent and task nodes, diamonds for inspector gates
  - Add file paths as second-line labels using `<br/>` (never `\n`)
  - Wire edges using the correct type for each connection (phase transitions, agent-to-task, rework loops)
  - Include the rework loop from inspector gate back to the rework target when the plan includes an inspection phase

- Compose the complete diagram:
  - Open with the config block (theme: base, darkMode: true, curve: basis)
  - Add `accTitle` and `accDescr` for accessibility
  - Declare `flowchart TD` direction
  - Write node definitions and edges in phase order
  - Append all `classDef` declarations at the bottom
  - For progress updates, apply status classes to nodes whose phases have changed — a completed phase's agent and task nodes get `:::completed`, the active phase gets `:::active`, pending phases get `:::pending`

- For reference, consult [lifecycle-example.md](assets/lifecycle-example.md) to see both initial and progress-updated diagram patterns in practice.

**Output of this step:** complete Mermaid code block ready for rendering.

</step_2_compose>


<step_3_validate>

Run pre-render checks against the Mermaid validation checklist before passing the diagram to the rendering tool.

Verify each rule — fix violations before rendering:

- **Label safety** — No `\n` in any label; use `<br/>` for line breaks
- **Accessibility** — `accTitle` and `accDescr` are both present after the flowchart declaration
- **Theme config** — Config block includes `theme: base`, `darkMode: true`, and `curve: basis` under flowchart
- **classDef coverage** — Every `:::class` reference in the diagram has a matching `classDef` declaration
- **Keyword safety** — No bare `end` keyword as a node ID or label (use `done`, `finish`, or wrap in quotes)
- **Color format** — All colors use hex format (`#rrggbb`) — no named colors, no `rgb()` or `hsl()`
- **Fork labels** — Empty fork/join labels use `" "` (space in quotes), never `""`
- **VS Code compatibility** — Mermaid 11.3.0+ syntax only; do NOT use `:::icon`, image shapes, or edge animations — these are unsupported in the VS Code renderer
- **Node ID uniqueness** — Every node ID is unique across the entire diagram
- **Edge consistency** — Phase transitions use `==>`, agent-to-task connections use `-->`, rework loops use `-.->` with dashed styling

If any check fails, return to `<step_2_compose>` and fix the specific violation. Do not re-render until all checks pass.

**Output of this step:** validated Mermaid code block, ready for `#tool:renderMermaidDiagram`.

</step_3_validate>


</workflow>


<error_handling>

Recovery actions for predictable failure modes during diagram creation or updates.

- If the **plan has no phase structure** (flat task list without parallel/sequential markers) — treat all tasks as sequential, connect them with thick edges in listed order, and note the assumption in the diagram's `accDescr`
- If a **phase references an agent role not in the standard pool** — use the `task` classDef color as a fallback and note the unmapped role in the accessibility description
- If the **diagram exceeds 30 nodes** — split into sub-diagrams by major phase groups, each with its own config block and classDefs, and note the split in chat text
- If **`#tool:renderMermaidDiagram` fails** after validation passes — check for unsupported syntax (icons, animations, advanced shapes) and simplify; retry with the corrected diagram
- If the **plan changes between assess and compose** (new phases added during a progress update) — re-run `<step_1_assess>` with the updated plan before composing

</error_handling>


<resources>

Reference files loaded on demand during workflow steps. All paths are relative to the skill folder.

**References:**

- [palette.md](references/palette.md) — Role-distinct color palette, status-aware classDef definitions, and contrast guidance for dark-mode accessibility. Loaded in step 2.
- [mapping-rules.md](references/mapping-rules.md) — Plan-to-Mermaid translation rules: topology patterns, node shapes, edge types, fork/join syntax, and inspector gate wiring. Loaded in step 2.

**Assets:**

- [lifecycle-example.md](assets/lifecycle-example.md) — Complete lifecycle example showing an initial plan diagram (all pending) and a progress-updated diagram (mixed statuses) with status-aware classDefs applied. Referenced in step 2.

</resources>
