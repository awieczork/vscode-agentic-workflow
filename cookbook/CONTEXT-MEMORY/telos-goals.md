---
when:
  - capturing project mission and purpose
  - providing deep context about why project exists
  - aligning agent behavior with long-term goals
  - documenting constraints and challenges
pairs-with:
  - memory-bank-files
  - constitutional-principles
  - instruction-files
requires:
  - file-write
complexity: medium
---

# TELOS Goal Files

Purpose capture for AI agents using structured goal hierarchy.

<!-- COMMUNITY PATTERN: TELOS is an external framework from danielmiessler, not a VS Code feature. Paths shown are cookbook adaptations. - flagged 2026-01-26 -->

---

## Core Concept

TELOS provides a systematic way to communicate your intentions, purposes, and goals to AI. Instead of repeating context in every conversation, goal files give agents deep understanding of WHY you're doing what you're doing.

**The hierarchy**: Problems → Mission → Goals → Challenges → Strategies

> **Platform Note**: TELOS originates from [danielmiessler/Telos](https://github.com/danielmiessler/Telos) as a deep context framework, with an implementation in [PAI (Personal AI Infrastructure)](https://github.com/danielmiessler/Personal_AI_Infrastructure) for Claude Code (location: `~/.claude/skills/CORE/USER/TELOS/`). The VS Code paths shown below are **cookbook adaptations** of this pattern. The original Telos repository uses single-file templates (`personal_telos.md`) with sections, while PAI uses separate files.
>
> **VS Code Native Alternatives**: For purpose/goal documentation, consider using:
> - **Custom Agents** (`.github/agents/*.agent.md`) — Define agent personas with built-in `description` field
> - **Agent Skills** (`.github/skills/*/SKILL.md`) — Structured capability definitions (preview)
> - **Prompt Files** (`.github/prompts/*.prompt.md`) — Reusable task-focused prompts
> - **AGENTS.md** — Workspace-wide instructions for all agents
>
> Source: [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents), [Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)

---

## Full TELOS System (10 Files)

<!-- EXTERNAL PATTERN: This file structure is from danielmiessler/PAI for Claude Code, not VS Code Copilot - flagged 2026-01-26 -->

From [PAI README](https://github.com/danielmiessler/Personal_AI_Infrastructure#readme) — the complete personal context structure (note: PAI installation creates 5 template files with support for 15+ flexible additions):

| File | Purpose | Example Content |
|------|---------|-----------------|
| `MISSION.md` | Your core purpose | "Build tools that amplify human creativity" |
| `GOALS.md` | Measurable objectives | "Launch v1.0 by Q2", "Reach 1K users" |
| `PROJECTS.md` | Active work | Current initiatives with status |
| `BELIEFS.md` | Guiding principles | "Simplicity over complexity" |
| `MODELS.md` | Mental frameworks | How you think about problems |
| `STRATEGIES.md` | Approaches | How you achieve goals |
| `NARRATIVES.md` | Your story | Background, journey, context |
| `LEARNED.md` | Past lessons | What worked, what didn't |
| `CHALLENGES.md` | Current obstacles | Known blockers and risks |
| `IDEAS.md` | Future possibilities | Backlog of potential directions |

**Location**: `.github/copilot/USER/TELOS/` (gitignored for privacy)

<!-- PATH NOTE: This location is a cookbook suggestion. VS Code does not recognize this path specially. Consider using .github/agents/ or .github/skills/ for official discovery. - flagged 2026-01-26 -->

---

## TELOS-Lite for Projects

<!-- COOKBOOK PATTERN: This 5-file variant is a cookbook adaptation, not from the original TELOS repository - flagged 2026-01-26 -->

> **Suggested Adaptation**: This simplified 5-file variant is a cookbook recommendation for VS Code projects, not an official TELOS variant. The original framework is flexible — use what serves your project.

Simplified version for VS Code projects (5 essential files):

```
.github/copilot/goals/
├── MISSION.md        # Project purpose
├── GOALS.md          # Success criteria
├── CHALLENGES.md     # Known risks
├── CONSTRAINTS.md    # Hard boundaries
└── CONTEXT.md        # Domain background
```

<!-- PATH NOTE: .github/copilot/goals/ is not an officially recognized path. VS Code discovers files from .github/agents/, .github/instructions/, .github/prompts/, and .github/skills/. Consider placing goal content in instruction files or agent definitions. - flagged 2026-01-26 -->

### Template: MISSION.md

```markdown
# Project Mission

## Purpose
[What this project exists to do — one sentence]

## Why It Matters
[The problem it solves and for whom]

## Success Vision
[What the world looks like when this succeeds]
```

### Template: GOALS.md

```markdown
# Project Goals

## Primary Goals (Must Achieve)
- [ ] [Goal 1 — measurable]
- [ ] [Goal 2 — measurable]

## Secondary Goals (Nice to Have)
- [ ] [Goal 3]

## Success Metrics
| Metric | Target | Current |
|--------|--------|---------|
| [e.g., Test coverage] | 80% | — |
| [e.g., Load time] | <2s | — |
```

### Template: CHALLENGES.md

```markdown
# Known Challenges

## Current Blockers
- [Blocker 1]: [Impact + mitigation]

## Anticipated Risks
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk 1] | Medium | High | [Plan] |

## Open Questions
- [Question 1]: [Why it matters]
```

---

## Integration with Memory Bank

<!-- COMMUNITY PATTERN: Memory Bank with FROZEN tier is from Cline, not VS Code Copilot. VS Code uses sessions/checkpoints for persistence. - flagged 2026-01-26 -->

TELOS files belong in the **FROZEN tier** — stable reference that rarely changes:

| Memory Bank File | TELOS Integration |
|------------------|-------------------|
| `projectbrief.md` | References `MISSION.md` for purpose |
| `activeContext.md` | References `GOALS.md` for current focus |
| `progress.md` | Tracks against `GOALS.md` metrics |

**Loading strategy**: Include TELOS files in system context for all planning/design agents.

---

## Using TELOS in Agent Instructions

<!-- IMPLEMENTATION NOTE: VS Code agents can reference any file via Markdown links. The goals/ prefix is not special to VS Code. - flagged 2026-01-26 -->

Reference goals in your agent files:

```markdown
## Context Loading
You have access to:
- `goals/MISSION.md` — Project purpose and success vision
- `goals/GOALS.md` — Current objectives with metrics
- `goals/CHALLENGES.md` — Known risks to watch for

## Decision Framework
When uncertain, refer to MISSION.md for purpose alignment.
Prioritize work that advances GOALS.md metrics.
Flag anything that triggers CHALLENGES.md risks.
```

---

## Spec Integration

TELOS maps directly to [`.spec.md` templates](../TEMPLATES/spec-template.md):

| Spec Section | TELOS Source |
|--------------|--------------|
| Section 1: Problem Statement | `CHALLENGES.md` |
| Section 2: Mission & Goals | `MISSION.md` + `GOALS.md` |
| Section 6: Challenges & Risks | `CHALLENGES.md` |
| Constraints | `CONSTRAINTS.md` |

---

## When to Use

**Full TELOS (10 files)**:
- Personal AI assistants
- Long-running projects (6+ months)
- Complex multi-agent systems

**TELOS-Lite (5 files)**:
- Standard VS Code projects
- Team projects with shared context
- Time-boxed initiatives

**Skip if**:
- One-off scripts or experiments
- Projects under 1 week
- Context fits in single projectbrief.md

---

## Related

- [memory-bank-files.md](memory-bank-files.md) — 6-file memory schema
- [tiered-memory.md](tiered-memory.md) — Hot/Warm/Cold/Frozen storage
- [memory-bank-schema.md](../CONFIGURATION/memory-bank-schema.md) — Contains projectbrief.md template
- [spec-template.md](../TEMPLATES/spec-template.md) — TELOS-integrated specs

---

## VS Code Native Alternatives

For teams preferring official VS Code features over community patterns:

| TELOS Concept | VS Code Native Feature | How to Use |
|---------------|------------------------|------------|
| **Mission/Goals** | Custom Agent `description` field | Add purpose to `.agent.md` frontmatter |
| **Structured capabilities** | Agent Skills (`SKILL.md`) | Create `.github/skills/*/SKILL.md` files |
| **Reusable task prompts** | Prompt Files (`.prompt.md`) | Store in `.github/prompts/` |
| **Workspace context** | AGENTS.md | Place at workspace root |
| **Persistent memory** | GitHub Copilot Memory | Automatic — repository-scoped, auto-generated |

> **GitHub Copilot Memory**: "Copilot can develop a persistent understanding of a repository by storing 'memories.' Memories are tightly scoped pieces of information about a repository, that are deduced by Copilot as it works on the repository."
>
> Source: [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

---

## Sources

- [danielmiessler/Telos](https://github.com/danielmiessler/Telos) — Original TELOS framework (single-file templates with sections)
- [danielmiessler/PAI](https://github.com/danielmiessler/Personal_AI_Infrastructure) — PAI implementation (separate files in `~/.claude/skills/CORE/USER/TELOS/`)
- [PAI TELOS Skill Pack](https://github.com/danielmiessler/Personal_AI_Infrastructure/tree/main/Packs/pai-telos-skill) — Installation and templates
- [personal_telos.md template](https://github.com/danielmiessler/Telos/blob/main/personal_telos.md) — Original section-based format
- [infrastructure-memory-repositories-patterns.md](../../research/infrastructure-memory-repositories-patterns.md)
- [phase2-critical-gaps-research.md](../../research/phase2-critical-gaps-research.md)

### Official VS Code Documentation

- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — Agent file format with `description` field
- [VS Code Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) — SKILL.md format (preview)
- [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) — Reusable prompt templates
- [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) — Official persistent memory feature
