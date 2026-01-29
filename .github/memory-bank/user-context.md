# User Context

> **Updated:** 2026-01-27 (Phase 5) | **Source:** Interview Batches 1-5 + Brainstorm Sessions

Distilled preferences for agent consumption. Raw interviews at `workshop/interviews/`.

---

## Identity

- **Role:** Lead Data Scientist, BI Department
- **Organization:** Wolters Kluwer Poland
- **Project type:** Personal framework for own projects

---

## Work Style

- **Autonomy preference:** Balanced — autonomous execution with checkpoints at key stages
- **Checkpoint frequency:** At key decision points (not every step, not fully autonomous)
- **Documentation style:** *(to be filled)*
- **Iteration preference:** brain + research (parallel) → architect → build → inspect

---

## Workflow Pattern

```
brain ─┬─→ architect → build → inspect
research ───┘ (parallel)
```

- **brain:** Starting point for most work — strategic thinking + project state
- **research:** Parallel information gathering during brain sessions
- **architect:** Essential for clarity — structures brain decisions into plans
- **build:** Essential for progress — implements architect plans
- **inspect:** Always runs after build (nice to have, but consistent)

---

## Technical Preferences

- **Primary languages:** *(to be filled)*
- **Frameworks:** *(to be filled)*
- **Testing approach:** *(to be filled)*
- **Code style:** *(to be filled)*

---

## Output Preferences

- **Synthesis style:** Option B — blend patterns intelligently, don't just select templates
- **Agent tone:** *(to be filled)*
- **Verbosity:** *(to be filled)*

---

## Generator Preferences

- **Output format:** Direct VS Code/Copilot folder structure (not intermediate spec)
- **Inference pattern:** "Infer + Confirm" — smart defaults → summary → user confirmation → generate
- **Versioning:** Latest only (no spec version history)
- **Core value:** Solve the "messy manual scaffolding" problem

### Metadata Schema (Expanded)
```yaml
project:
  type: "data-pipeline" | "web-app" | "cli-tool" | ...
  languages: [python, sql, ...]
  frameworks: [pandas, fastapi, ...]
  complexity: simple | moderate | complex
  goals: "Project objectives in plain language"
  preferred-tools:
    testing: pytest
    linting: ruff
```

---

## Error Handling

- **Wrong assumptions:** Re-run with extended interview (not manual edit)
- **Missing patterns:** Note gap + ask user for definition
- **Uncertainty:** Best-effort with warnings, iterate with feedback
- **Philosophy:** Don't block on uncertainty — generate, warn, refine

---

## Component Model

Generator identifies what components a project needs:

| Component | When to Use |
|-----------|-------------|
| **Plug-in agents** | Domain-specific workflows extending 5-agent core |
| **Skills** | Capabilities added to existing core agents |
| **Instructions** | Context/rules for specific domains |
| **Prompts** | Reusable prompt templates |

- Domain agents = plug-in modules to 5-agent workflow
- User can specify components explicitly (override auto-detection)
- Mix of skills + plug-ins + instructions often optimal

---

## Progressive Generation (Decided)

*Staged workflow — now part of master/subagent architecture:*

1. **Plan:** Master creates explicit file list from spec → user approves
2. **Generate:** Subagents create files per type (agents, skills, instructions, prompts, memory)
3. **Validate:** Master validates against plan, @inspect verifies against checklists
4. **Feedback:** User reviews → re-generate specific files if needed

---

## Generator Behavior Model

*Confirmed via Interview Batch 5:*

### Authority Hierarchy
```
User Override > Generator Recommendation > Cookbook Defaults
```

### Autonomy Pattern
| Domain | Behavior |
|--------|----------|
| Structure decisions | Confirm first |
| Content generation | Best-effort + warn |
| Checkpoints | At stage boundaries, not per-decision |

### Confirmation Flow
```
1. Infer all defaults
2. Single comprehensive confirmation gate
3. Lightweight checkpoint per generation stage
4. NOT per-decision prompting
```

### Edge Case Handling
| Scenario | Behavior |
|----------|----------|
| **Gap in cookbook** | Best-effort + warn; escalate only if genuinely novel |
| **Pattern conflicts** | Flag conflict, user resolves |
| **Malformed patterns** | Skip broken + warn, proceed with valid |

---

## Constraints

- **Tools:** VS Code + GitHub Copilot Pro+ only
- **Platform:** Windows
- **External dependencies:** Minimize

---

## Decision History

Key decisions from interviews that inform framework direction:

| # | Decision | Source |
|---|----------|--------|
| 1 | Generator synthesizes (Option B), not selects | Interview Batch 1 |
| 2 | Personal project — builder IS user | Interview Batch 1 |
| 3 | Spec template customization deferred to Phase 4B/4C | Interview Batch 1 |
| 4 | Workflow: brainstorm + research (parallel) → architect → build → inspect | Interview Batch 2 |
| 5 | Balanced autonomy — checkpoints at key stages only | Interview Batch 2 |
| 6 | Generated projects get 5 core agents + domain-specific additions | Interview Batch 2 |
| 7 | Generated agent behaviors cloned from this framework's agents | Interview Batch 2 |
| 8 | Domain-specific agents designed per-project, not pre-made | Interview Batch 2 |
| 9 | Generator outputs real VS Code/Copilot structure (no intermediate spec) | Interview Batch 3 |
| 10 | "Infer + Confirm" pattern — defaults → summary → confirm → generate | Interview Batch 3 |
| 11 | Expanded metadata: type, goals, preferred-tools (beyond 4-field) | Interview Batch 3 |
| 12 | No spec versioning — latest only | Interview Batch 3 |
| 13 | Core value: solve messy manual scaffolding problem | Interview Batch 3 |
| 14 | Wrong assumptions → re-run with extended interview | Interview Batch 4 |
| 15 | Missing patterns → note + ask user | Interview Batch 4 |
| 16 | Component identification system (agents, skills, instructions) | Interview Batch 4 |
| 17 | Domain agents as plug-in modules to 5-agent core | Interview Batch 4 |
| 18 | User can specify components explicitly | Interview Batch 4 |
| 19 | Best-effort + warnings + iterate | Interview Batch 4 |
| 20 | Progressive generation idea (structure → content → enhancement) | Interview Batch 4 |
| 21 | Authority hierarchy: User > Generator > Cookbook | Interview Batch 5 |
| 22 | Autonomy: confirm structure, best-effort content, stage checkpoints | Interview Batch 5 |
| 23 | Gap handling: best-effort + warn, escalate if genuinely novel | Interview Batch 5 |
| 24 | Confirmation: single gate at start + per-stage checkpoints | Interview Batch 5 |
| 25 | Cookbook conflicts: generator flags, user resolves | Interview Batch 5 |
| 26 | Malformed cookbook: skip broken + warn, proceed with valid | Interview Batch 5 |
| 27 | Guidelines in folder (`GENERATION-RULES/`), not single file | Brainstorm 2026-01-27 |
| 28 | Master + subagent generator architecture for context isolation | Brainstorm 2026-01-27 |
| 29 | Subagent communication via `runSubagent` tool | Brainstorm 2026-01-27 |
| 30 | Plan-first, validate-against-plan approach | Brainstorm 2026-01-27 |
| 31 | New `master-generator.agent.md` (separate from generator) | Brainstorm 2026-01-27 |
| 32 | Always copy all 5 core agents (no selection) | Brainstorm 2026-01-27 |
| 33 | Feedback via master re-spawning specific subagent | Brainstorm 2026-01-27 |
| 34 | One comprehensive interview with progressive save to file | Brainstorm 2026-01-27 |
| 35 | Interview captures ALL synthesis decisions; generator executes only | Brainstorm 2026-01-27 |
