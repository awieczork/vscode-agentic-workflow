Complete lifecycle example showing both an initial plan diagram (all phases pending) and a progress-updated diagram (mixed statuses). Reference this asset during step 2 to see the living-diagram pattern in practice.


<scenario>

A three-phase implementation plan:

- **Phase 1** `[parallel]` — Two @developer tasks: create auth handler (`src/auth/handler.ts`) and create session module (`src/auth/session.ts`)
- **Phase 2** `[sequential]` — One @developer task: wire auth middleware (`src/middleware/auth.ts`)
- **Phase 3** `[sequential]` — @inspector gate, then @curator for curation

</scenario>


<initial_render>

All phases pending — rendered at plan approval before any work begins. Uses role-based classDefs only (no status overrides).

```mermaid
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
    accTitle: Auth implementation plan
    accDescr: Parallel phase 1, sequential phase 2, inspector gate, curator phase

    brain(["@brain"]):::brain

    brain ==>|"Phase 1"| fork1@{ shape: fork, label: " " }
    fork1 --> B1["@developer"]:::developer --> T1["create handler<br/>src/auth/handler.ts"]:::task --> join1@{ shape: fork, label: " " }
    fork1 --> B2["@developer"]:::developer --> T2["create session<br/>src/auth/session.ts"]:::task --> join1

    join1 ==>|"Phase 2"| B3["@developer"]:::developer --> T3["wire middleware<br/>src/middleware/auth.ts"]:::task

    T3 ==> gate{"@inspector<br/>verify"}:::gate
    gate -->|"pass"| C1["@curator"]:::curator --> done(["Done"]):::done
    gate -.->|"rework"| rework["re-spawn<br/>@developer"]:::rework -.-> B3

    classDef brain fill:#6366f1,stroke:#818cf8,color:#e0e7ff,stroke-width:2px
    classDef developer fill:#0ea5e9,stroke:#38bdf8,color:#e0f2fe
    classDef curator fill:#10b981,stroke:#34d399,color:#1c1917
    classDef task fill:#1e293b,stroke:#475569,color:#cbd5e1
    classDef gate fill:#78350f,stroke:#b45309,color:#fef3c7
    classDef done fill:#166534,stroke:#22c55e,color:#f0fdf4
    classDef rework fill:#7f1d1d,stroke:#dc2626,color:#fecaca,stroke-dasharray:5 5
```

Observations:

- Every agent node uses its role classDef (`:::developer`, `:::curator`)
- Task nodes use `:::task` for neutral styling
- The rework loop is present but uses `:::rework` class to signal it is a fallback path
- Fork/join bars have `" "` labels (space, not empty string)
- `accTitle` and `accDescr` are present for accessibility

</initial_render>


<progress_update>

After Phase 1 completes and Phase 2 is actively executing — the diagram is re-rendered with status-aware classDefs. Phase 1 nodes turn completed (green), Phase 2 nodes turn active (highlighted blue), and the inspector/curator phases remain in their default role colors since they are pending.

```mermaid
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
    accTitle: Auth implementation plan — progress
    accDescr: Phase 1 completed, Phase 2 active, inspector and curator pending

    brain(["@brain"]):::brain

    brain ==>|"Phase 1"| fork1@{ shape: fork, label: " " }
    fork1 --> B1["@developer"]:::completed --> T1["create handler<br/>src/auth/handler.ts"]:::completed --> join1@{ shape: fork, label: " " }
    fork1 --> B2["@developer"]:::completed --> T2["create session<br/>src/auth/session.ts"]:::completed --> join1

    join1 ==>|"Phase 2"| B3["@developer"]:::active --> T3["wire middleware<br/>src/middleware/auth.ts"]:::active

    T3 ==> gate{"@inspector<br/>verify"}:::gate
    gate -->|"pass"| C1["@curator"]:::curator --> done(["Done"]):::done
    gate -.->|"rework"| rework["re-spawn<br/>@developer"]:::rework -.-> B3

    classDef brain fill:#6366f1,stroke:#818cf8,color:#e0e7ff,stroke-width:2px
    classDef developer fill:#0ea5e9,stroke:#38bdf8,color:#e0f2fe
    classDef curator fill:#10b981,stroke:#34d399,color:#1c1917
    classDef task fill:#1e293b,stroke:#475569,color:#cbd5e1
    classDef gate fill:#78350f,stroke:#b45309,color:#fef3c7
    classDef done fill:#166534,stroke:#22c55e,color:#f0fdf4
    classDef rework fill:#7f1d1d,stroke:#dc2626,color:#fecaca,stroke-dasharray:5 5
    classDef completed fill:#166534,stroke:#22c55e,color:#f0fdf4
    classDef active fill:#1d4ed8,stroke:#60a5fa,color:#dbeafe,stroke-width:3px
    classDef pending fill:#334155,stroke:#475569,color:#94a3b8
```

Key differences from the initial render:

- Phase 1 agent and task nodes changed from `:::developer` and `:::task` to `:::completed` — green fill signals finished work
- Phase 2 agent and task nodes changed from `:::developer` and `:::task` to `:::active` — bright blue with thick stroke draws attention to current phase
- Inspector gate and curator retain their role classDefs (`:::gate`, `:::curator`) — gate and terminal nodes do not get status overrides
- Both role-based and status-based `classDef` declarations are present — role classDefs serve nodes that retain their default styling, status classDefs serve nodes that reflect progress
- The `accDescr` is updated to reflect current status: "Phase 1 completed, Phase 2 active, inspector and curator pending"

</progress_update>


<rework_state>

After the inspector returns REWORK NEEDED on Phase 2 — the diagram is re-rendered to show the rework state. Phase 2 nodes switch to rework styling, and the rework loop edge is visually emphasized.

```mermaid
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
    accTitle: Auth implementation plan — rework
    accDescr: Phase 1 completed, Phase 2 rework, inspector returned REWORK NEEDED

    brain(["@brain"]):::brain

    brain ==>|"Phase 1"| fork1@{ shape: fork, label: " " }
    fork1 --> B1["@developer"]:::completed --> T1["create handler<br/>src/auth/handler.ts"]:::completed --> join1@{ shape: fork, label: " " }
    fork1 --> B2["@developer"]:::completed --> T2["create session<br/>src/auth/session.ts"]:::completed --> join1

    join1 ==>|"Phase 2"| B3["@developer"]:::rework --> T3["wire middleware<br/>src/middleware/auth.ts"]:::rework

    T3 ==> gate{"@inspector<br/>verify"}:::gate
    gate -->|"pass"| C1["@curator"]:::curator --> done(["Done"]):::done
    gate -.->|"rework"| rework["re-spawn<br/>@developer"]:::rework -.-> B3

    classDef brain fill:#6366f1,stroke:#818cf8,color:#e0e7ff,stroke-width:2px
    classDef developer fill:#0ea5e9,stroke:#38bdf8,color:#e0f2fe
    classDef curator fill:#10b981,stroke:#34d399,color:#1c1917
    classDef task fill:#1e293b,stroke:#475569,color:#cbd5e1
    classDef gate fill:#78350f,stroke:#b45309,color:#fef3c7
    classDef done fill:#166534,stroke:#22c55e,color:#f0fdf4
    classDef rework fill:#7f1d1d,stroke:#dc2626,color:#fecaca,stroke-dasharray:5 5
    classDef completed fill:#166534,stroke:#22c55e,color:#f0fdf4
    classDef active fill:#1d4ed8,stroke:#60a5fa,color:#dbeafe,stroke-width:3px
    classDef pending fill:#334155,stroke:#475569,color:#94a3b8
```

Key differences from the progress update:

- Phase 2 agent and task nodes changed from `:::active` to `:::rework` — dark red dashed stroke signals the inspector sent this phase back
- The rework loop from gate to B3 is now the visually expected path, matching the rework styling on the phase nodes
- `accDescr` updated to reflect rework state

</rework_state>
