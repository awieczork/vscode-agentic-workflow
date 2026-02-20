Plan-to-Mermaid translation rules for converting structured implementation plans into flowchart diagrams. Load this reference during step 2 to apply the correct topology, node shapes, and edge types.


<topology_rules>

How plan phase types map to Mermaid graph structures.

**Parallel phases** — Use fork/join bars to fan out and reconverge:

```
phase_fork@{ shape: fork, label: " " }
  --> agent_1["@developer"]:::developer --> task_1["task label"]:::task
  --> phase_join@{ shape: fork, label: " " }
phase_fork
  --> agent_2["@developer"]:::developer --> task_2["task label"]:::task
  --> phase_join
```

- Fork bar fans out to N parallel paths, one per task
- Each path has its own agent node and task node
- Join bar reconverges all paths before the next phase
- Fork and join labels must be `" "` (space in quotes) — never empty string `""`
- Use unique IDs for each fork/join pair: `fork1`/`join1`, `fork2`/`join2`

**Sequential phases** — Use thick edges with phase labels:

```
previous_node ==>|"Phase N"| agent["@developer"]:::developer
  --> task["task label"]:::task
```

- Thick double-arrow (`==>`) marks phase boundaries
- Optional phase label in `|"Phase N"|` format
- Tasks within a sequential phase chain with `-->`

**Mixed plans** — Combine both patterns. A parallel phase ends at a join bar; the next sequential phase starts with `==>` from that join bar.

</topology_rules>


<node_shapes>

How plan elements map to Mermaid node shapes.

| Plan Element          | Mermaid Shape     | Syntax Example                                  | Class     |
|-----------------------|-------------------|------------------------------------------------|-----------|
| Orchestrator (@brain) | Stadium (rounded) | `brain(["@brain"]):::brain`                    | `brain`   |
| Agent assignment      | Rectangle         | `B1["@developer"]:::developer`                 | role name |
| Task                  | Rectangle         | `T1["create handler<br/>src/auth/handler.ts"]:::task` | `task` |
| Inspector gate        | Diamond           | `gate{"@inspector<br/>verify"}:::gate`         | `gate`    |
| Terminal (Done)       | Stadium (rounded) | `done(["Done"]):::done`                        | `done`    |
| Fork/Join bar         | Fork shape        | `fork1@{ shape: fork, label: " " }`           | (none)    |

**Task node labels** — Always two lines:

- Line 1: action verb + brief description (e.g., `create handler`, `refactor middleware`)
- Line 2: target file path (e.g., `src/auth/handler.ts`)
- Separate lines with `<br/>` — never use `\n`
- Keep labels concise; truncate long paths to the significant portion

**Agent node labels** — Use the role name with `@` prefix: `["@developer"]`, `["@researcher"]`, `["@inspector"]`

**Node IDs** — Use short, unique, descriptive IDs:

- Agent nodes: `B1`, `B2`, `B3` (B for builder/agent)
- Task nodes: `T1`, `T2`, `T3`
- Fork bars: `fork1`, `fork2`
- Join bars: `join1`, `join2`
- Gate: `gate` (or `gate1`, `gate2` for multiple inspection points)

</node_shapes>


<edge_types>

Three edge types express different relationship semantics.

| Connection Type   | Syntax                      | Usage                                          |
|-------------------|-----------------------------|-------------------------------------------------|
| Phase transition  | `==>` or `==>\|"Phase N"\|` | Between phases — marks major workflow boundaries |
| Agent-to-task     | `-->` or `-->\|"label"\|`   | Within a phase — connects agents to tasks        |
| Rework loop       | `-.->` or `-.->\|"rework"\|`| From inspector gate back to rework target        |

**Phase transition edges** (`==>`)

- Connect the previous phase's last node (or join bar) to the next phase's first agent node
- Include a phase label when the plan has numbered phases: `==>|"Phase 2"|`
- The first phase connects from the brain node: `brain ==>|"Phase 1"|`

**Agent-to-task edges** (`-->`)

- Connect agent nodes to their task nodes within a phase
- Chain multiple sequential tasks: `agent --> task1 --> task2`
- Within parallel phases, each branch uses `-->` from fork to agent to task to join

**Rework loop edges** (`-.->`)

- Dashed arrows from the inspector gate back to the rework target
- Always include the `"rework"` label: `gate -.->|"rework"| rework_node`
- The rework target is typically the first agent node of the phase being reworked
- Rework nodes use `:::rework` class for dashed-stroke styling

</edge_types>


<inspector_gate>

How to wire the inspector quality gate into the diagram.

- Place the inspector gate as a diamond node after the last development phase and before the terminal node
- The gate receives a thick edge from the last task or join bar: `last_node ==> gate{"@inspector<br/>verify"}:::gate`
- The pass edge goes to the done node: `gate -->|"pass"| done(["Done"]):::done`
- The rework edge loops back with a dashed arrow: `gate -.->|"rework"| rework["re-spawn<br/>@developer"]:::rework -.-> target_agent`
- If the plan includes a curator phase, the pass edge goes to the curator instead of done: `gate -->|"pass"| C1["@curator"]:::curator`

</inspector_gate>


<rework_loops>

How to represent rework cycles in the diagram.

- Create a dedicated rework node: `rework["re-spawn<br/>@developer"]:::rework`
- Connect from inspector gate to rework node: `gate -.->|"rework"| rework`
- Connect from rework node back to the target phase's agent: `rework -.-> B3`
- Use `:::rework` class on the rework node (dashed stroke, dark red fill)
- Rework edges always use `-.->` (dashed arrows) to visually distinguish from normal flow

</rework_loops>


<diagram_skeleton>

Standard structure every diagram follows. Fill in the bracketed sections with plan-specific content.

```
---
config:
  theme: base
  themeVariables:
    darkMode: true
    primaryColor: "#6366f1"
    primaryTextColor: "#e0e7ff"
    lineColor: "#818cf8"
  flowchart:
    curve: basis
---
flowchart TD
    accTitle: {plan title}
    accDescr: {brief description of phases and topology}

    %% Orchestrator
    brain(["@brain"]):::brain

    %% Phase 1 — {description}
    {phase 1 nodes and edges}

    %% Phase N — {description}
    {phase N nodes and edges}

    %% Inspector gate
    {gate node and pass/rework edges}

    %% Terminal
    {done or curator node}

    %% classDef declarations
    {all classDef lines}
```

- Comments (`%%`) mark phase boundaries for readability — they do not render
- Declare all `classDef` lines at the bottom, after all nodes and edges
- Include `accTitle` and `accDescr` immediately after `flowchart TD`

</diagram_skeleton>


<vs_code_constraints>

VS Code Mermaid renderer constraints (Mermaid 11.3.0+):

- Fork shape syntax (`@{ shape: fork, label: " " }`) is supported
- `classDef` and `:::class` syntax is fully supported
- `accTitle` and `accDescr` are supported for accessibility
- Theme configuration via frontmatter config block is supported
- **NOT supported:** `:::icon()` syntax, image shapes, edge animations, link callbacks
- Labels must use `<br/>` for line breaks — `\n` renders literally
- The `end` keyword is reserved — never use it as a bare node ID or label

</vs_code_constraints>
