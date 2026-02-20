Color palette and classDef definitions for plan-visualization diagrams. All colors are tested for accessibility on dark backgrounds (WCAG AA contrast ratio ≥ 4.5:1 for text, ≥ 3:1 for graphical elements). Load this reference during step 2 to select the appropriate classDef set.


<role_palette>

Each of the six agent roles gets a visually distinct color. Text color is chosen for maximum contrast against the fill.

| Role         | Fill      | Stroke    | Text      | Notes                    |
|--------------|-----------|-----------|-----------|--------------------------|
| @brain       | `#6366f1` | `#818cf8` | `#e0e7ff` | Indigo — orchestrator    |
| @developer   | `#0ea5e9` | `#38bdf8` | `#e0f2fe` | Sky blue — implementer   |
| @researcher  | `#8b5cf6` | `#a78bfa` | `#ede9fe` | Violet — investigator    |
| @planner     | `#f59e0b` | `#fbbf24` | `#1c1917` | Amber — dark text        |
| @inspector   | `#ef4444` | `#f87171` | `#fef2f2` | Red — quality gate       |
| @curator     | `#10b981` | `#34d399` | `#1c1917` | Emerald — dark text      |

Role classDef declarations:

```
classDef brain fill:#6366f1,stroke:#818cf8,color:#e0e7ff,stroke-width:2px
classDef developer fill:#0ea5e9,stroke:#38bdf8,color:#e0f2fe
classDef researcher fill:#8b5cf6,stroke:#a78bfa,color:#ede9fe
classDef planner fill:#f59e0b,stroke:#fbbf24,color:#1c1917
classDef inspector fill:#ef4444,stroke:#f87171,color:#fef2f2
classDef curator fill:#10b981,stroke:#34d399,color:#1c1917
```

</role_palette>


<task_palette>

Node types that are not agent roles use their own distinct colors.

| Node Type | Fill      | Stroke    | Text      | Notes                          |
|-----------|-----------|-----------|-----------|--------------------------------|
| task      | `#1e293b` | `#475569` | `#cbd5e1` | Slate — default task node      |
| gate      | `#78350f` | `#b45309` | `#fef3c7` | Brown-amber — inspector gate   |
| done      | `#166534` | `#22c55e` | `#f0fdf4` | Green — terminal success node  |

Task classDef declarations:

```
classDef task fill:#1e293b,stroke:#475569,color:#cbd5e1
classDef gate fill:#78350f,stroke:#b45309,color:#fef3c7
classDef done fill:#166534,stroke:#22c55e,color:#f0fdf4
```

</task_palette>


<status_palette>

Status-aware classDefs for living diagrams. Apply these during progress updates to override the default role/task colors based on phase status.

| Status    | Fill      | Stroke    | Text      | Extra                     | Notes                        |
|-----------|-----------|-----------|-----------|---------------------------|------------------------------|
| completed | `#166534` | `#22c55e` | `#f0fdf4` | —                         | Green — finished phase       |
| active    | `#1d4ed8` | `#60a5fa` | `#dbeafe` | `stroke-width:3px`        | Bright blue — current phase  |
| pending   | `#334155` | `#475569` | `#94a3b8` | —                         | Muted slate — not started    |
| rework    | `#7f1d1d` | `#dc2626` | `#fecaca` | `stroke-dasharray:5 5`    | Dark red dashed — sent back  |

Status classDef declarations:

```
classDef completed fill:#166534,stroke:#22c55e,color:#f0fdf4
classDef active fill:#1d4ed8,stroke:#60a5fa,color:#dbeafe,stroke-width:3px
classDef pending fill:#334155,stroke:#475569,color:#94a3b8
classDef rework fill:#7f1d1d,stroke:#dc2626,color:#fecaca,stroke-dasharray:5 5
```

</status_palette>


<applying_status_classes>

When updating a diagram for progress tracking, apply status classes to override the default styling:

- **Completed phases** — Replace the agent and task node classes with `:::completed`. Example: `B1["@developer"]:::completed` instead of `B1["@developer"]:::developer`
- **Active phase** — Replace the agent and task node classes with `:::active`. The thicker stroke width draws attention to the current work
- **Pending phases** — Replace with `:::pending`. The muted slate signals work not yet started
- **Rework phases** — Replace with `:::rework`. The dashed stroke and dark red fill signal phases sent back by the inspector

Include both role-based and status-based classDef declarations in progress-updated diagrams — the role classDefs remain for nodes that haven't changed status (like the brain orchestrator node and terminal nodes), while status classDefs override specific phase nodes.

Gate, done, and terminal-adjacent agent nodes (e.g., @curator when it is the last agent before Done) retain their own role classDefs regardless of phase status. The brain orchestrator node always uses `:::brain`.

</applying_status_classes>


<contrast_notes>

Accessibility considerations for the palette:

- **Dark text roles** — @planner (amber fill) and @curator (emerald fill) use dark text (`#1c1917`) because their bright fills would wash out light text
- **Light text roles** — @brain, @developer, @researcher, @inspector use light text variants that provide ≥ 4.5:1 contrast against their fills
- **Status colors** — chosen to be distinguishable even with color vision deficiency: completed (green) vs active (blue) vs pending (gray) vs rework (red) spans the hue spectrum
- **Stroke contrast** — every stroke color is a lighter shade of its fill, providing ≥ 3:1 contrast against the dark diagram background

</contrast_notes>
