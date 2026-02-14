This workspace is a Python 3.12/conda toolkit that derives dark editor themes from a single primary hex color using algorithmic color math. It targets VS Code (JSON), RStudio (.rstheme CSS), and DBeaver (XML). The governing principle is: calibrate autonomy to confidence — proceed decisively when evidence is strong, escalate when uncertain.


<workspace>

Directory map — load this first to locate resources.

- `.github/agents/core/` — Core agent definitions (hub-and-spoke lifecycle)
  - `brain.agent.md` — Central orchestrator, routes tasks, tracks session state
  - `researcher.agent.md` — Deep research and source synthesis
  - `planner.agent.md` — Problem decomposition into phased plans
  - `builder.agent.md` — Implementation execution, produces working code
  - `inspector.agent.md` — Final quality gate, verifies against plan and standards
  - `curator.agent.md` — Workspace maintenance: docs sync, git commits, cleanup
- `.github/agents/theme-builder.agent.md` — Derives OKLCH palettes and generates cross-editor dark themes
- `.github/agent-workflows/` — Multi-agent workflow orchestrations
  - `evolution.workflow.md` — Iterative evolution workflow for multi-phase tasks
- `.github/skills/` — Reusable multi-step processes any agent can invoke
  - `artifact-creator/` — Creates and refactors VS Code Copilot customization artifacts
    - `SKILL.md` — Skill definition: classify-then-specialize artifact authoring
    - `references/frontmatter-contracts.md` — YAML frontmatter specs per artifact type
    - `references/body-patterns.md` — Body structure patterns per artifact type
    - `references/writing-rules.md` — Cross-cutting quality and formatting rules
    - `assets/example-agent.md` — Reference example for agent artifacts
    - `assets/example-copilot-instructions.md` — Reference example for copilot-instructions
    - `assets/example-instruction.md` — Reference example for instruction artifacts
    - `assets/example-prompt.md` — Reference example for prompt artifacts
    - `assets/example-skill.md` — Reference example for skill artifacts
  - `contrast-audit/` — WCAG 2.1 AA + APCA dual contrast verification
    - `SKILL.md` — Skill definition: collect, classify, calculate, report contrast compliance
- `.github/instructions/` — Ambient constraints auto-attached by file pattern or relevance
  - `color-derivation.instructions.md` — Rules for OKLCH palette derivation from primary hex
  - `theme-conventions.instructions.md` — Cross-editor theme output conventions and formatting rules
- `.github/prompts/` — One-shot prompt templates (slash commands)
  - `evolve.prompt.md` — Trigger an evolution cycle on the current workspace
  - `calibrate.prompt.md` — Fine-tune palette parameters against contrast targets
  - `generate-palette.prompt.md` — Generate a 12-step Radix-scale palette from a primary hex
  - `port-theme.prompt.md` — Port an existing theme to a new editor format
  - `package-vscode.prompt.md` — Package a theme as a VS Code extension (.vsix)
- `.github/copilot-instructions.md` — This file: project-wide context for all agents

</workspace>


<agents>

Hub-and-spoke: @brain receives requests and delegates to subagents. Each agent is defined in `.github/agents/core/`.

- `@brain` — Central orchestrator, routes tasks, tracks session state
- `@researcher` — Deep research and source synthesis on focused topics
- `@planner` — Decomposes problems into phased, dependency-verified plans
- `@builder` — Executes implementation tasks, produces working code
- `@inspector` — Final quality gate, verifies against plan and standards
- `@curator` — Workspace maintenance: docs sync, git commits, cleanup
- `@theme-builder` — Derives OKLCH palettes and generates cross-editor dark themes (VS Code, RStudio, DBeaver)

</agents>


<conventions>

Project-specific conventions that apply to all work in this workspace.

**Runtime and tooling**
- Python 3.12, conda environment named `theme-framework`
- coloraide library for all color operations — no raw math outside coloraide
- OKLCH color space for all palette derivation — never use HSL internally

**Color architecture**
- 12-step Radix Colors scale: steps 1-12 map to background, surface, border, text, and accent roles
- Every color must trace algorithmically from a single primary hex — no hardcoded color values
- WCAG 2.1 AA + APCA dual-check for all contrast verification — both must pass
- WCAG thresholds: 4.5:1 for normal text, 3:1 for large text and UI components
- APCA thresholds: Lc 75 (body text), Lc 60 (large text), Lc 90 (preferred body), Lc 45 (sub-text), Lc 30 (non-text)

**Output targets**
- VS Code — JSON token/color theme format
- RStudio — CSS `.rstheme` stylesheet
- DBeaver — XML color theme format
- First theme target: "Dark — Teal" from `#008080`

**Artifact conventions**
- XML tags use `snake_case`, domain-specific, self-explanatory names — no markdown headings in artifact bodies
- YAML frontmatter uses single-quoted string values
- One artifact type per file: agents, skills, prompts, instructions, copilot-instructions

**Canonical terms**
- constraint (not restriction), skill (not procedure), handoff (not delegation), escalate (not interrupt), fabricate (not hallucinate)

</conventions>


<rules>

- This file takes precedence over all other instruction files in the workspace
- Never fabricate sources, file paths, or quotes — verify before citing
- Do only what is requested or clearly necessary — treat undocumented features as unsupported
- When rules conflict, apply: Safety → Accuracy → Clarity → Style — the first dimension that distinguishes options wins
- When uncertain: high confidence → proceed; medium → flag and ask; low → stop and clarify
- When resources are unavailable, state the gap and continue with an explicit workaround
- OKLCH is the only permitted color space for palette derivation — converting to other spaces for output is acceptable
- Every color must trace algorithmically from the primary hex — no hardcoded values anywhere in the pipeline
- Every foreground/background pair must pass both WCAG AA and APCA thresholds before inclusion in a theme
- First theme target: "Dark — Teal" from `#008080` — all initial work derives from this primary

</rules>


<commands>

Environment setup:
- `conda activate theme-framework` — activate project environment
- `conda env create -f environment.yml` — create environment from spec

Theme generation:
- `python -m theme_framework generate --primary "#008080"` — generate palette from primary hex
- `python -m theme_framework export --format vscode` — export to VS Code JSON
- `python -m theme_framework export --format rstudio` — export to RStudio .rstheme
- `python -m theme_framework export --format dbeaver` — export to DBeaver XML

Testing:
- `python -m pytest` — run all tests
- `python -m pytest tests/test_contrast.py` — run contrast verification tests
- `python -m pytest --cov=theme_framework` — run tests with coverage

</commands>


<environment>

**Runtime**
- Python 3.12 via conda — run `conda activate theme-framework` to activate
- coloraide for color space conversions and palette math
- No pip outside conda — all dependencies managed through `environment.yml`

**Project structure** (source code — not yet scaffolded)
- `theme_framework/` — main package: palette generation, contrast checking, theme export
- `tests/` — pytest test suite: unit tests for color math, integration tests for theme output
- `themes/` — generated theme output files (JSON, CSS, XML)

</environment>
