# Theme Framework — AI Workflow Artifacts

Copilot agent ecosystem for deriving dark editor themes from a single hex color using algorithmic color math.

## What's Inside

| Category | Path | Purpose |
|---|---|---|
| Agents | `agents/core/`, `agents/` | 6 core agents (@brain, @researcher, @architect, @build, @inspect, @curator) + @theme-builder at `agents/` for palette derivation |
| Skills | `skills/` | `artifact-creator` (framework authoring) + `contrast-audit` (WCAG/APCA checks) |
| Instructions | `instructions/` | Color derivation rules + theme format conventions |
| Prompts | `prompts/` | Palette generation, theme porting, calibration, VS Code packaging |
| Workflows | `agent-workflows/` | Evolution workflow for iterating artifacts |
| Config | `copilot-instructions.md` | Project-wide conventions, rules, and workspace map |

## Quick Start

**Generate a palette from teal:**

```text
Use @generate-palette with primary hex #008080
→ Derives a 12-step OKLCH Radix-style palette
→ Runs dual contrast audit (WCAG AA + APCA) on every pair
```

**Port a VS Code theme to RStudio and DBeaver:**

```text
Use @port-theme with your *-color-theme.json
→ Outputs .rstheme CSS for RStudio
→ Outputs XML preferences for DBeaver
→ Preserves contrast guarantees across all formats
```

**Package for the VS Code Marketplace:**

```text
Use @package-vscode with theme name and publisher ID
→ Scaffolds extension folder structure
→ Generates package.json + contributes.themes
→ Provides vsce package command to build .vsix
```

## Key Conventions

- **Color space** — OKLCH is the only permitted perceptual color space (not HSL)
- **Palette structure** — 12-step scale following Radix Colors conventions
- **Contrast** — Dual-checked: WCAG 2.1 AA thresholds (4.5:1 / 3:1) and APCA Lc values
- **Runtime** — Python 3.12, conda environment, `coloraide` library for color math
- **Output formats** — VS Code (JSON `*-color-theme.json`), RStudio (`.rstheme` CSS), DBeaver (XML preferences)
- **Derivation** — All theme colors derived algorithmically from one primary hex; no hand-picked swatches

## Related Files

- [copilot-instructions.md](copilot-instructions.md) — Full project configuration, workspace map, and rules
- [skills/artifact-creator/SKILL.md](skills/artifact-creator/SKILL.md) — Artifact authoring conventions and templates
- [agent-workflows/evolution.workflow.md](agent-workflows/evolution.workflow.md) — Multi-agent workflow for iterating on artifacts
