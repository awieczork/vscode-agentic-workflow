---
agent: brain
description: Synthesize SETTINGS.md - optimal VS Code + Copilot configuration
---

# Synthesize: SETTINGS.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize THE optimal VS Code + Copilot configuration.

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/settings.md` |
| Output | `GENERATION-RULES/SETTINGS.md` |

## Source Files (2 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [settings-reference.md](../../cookbook/CONFIGURATION/settings-reference.md) | Extract: all settings, defaults, categories |
| 2 | [mcp-servers.md](../../cookbook/CONFIGURATION/mcp-servers.md) | Extract: MCP configuration patterns |

## Iteration Plan (Complexity: Low → 3 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze settings-reference.md + Related | @brain |
| 2 | Analysis | Analyze mcp-servers.md + Related | @brain |
| 3 | Synthesis | Final settings synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-2) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Synthesize** — produce final SETTINGS.md (no critique for Low complexity)

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `configuration`

Key requirements for settings specifically:
- Tables with RATIONALE for each setting
- Copy-paste ready JSON blocks
- Workspace vs User settings distinguished

## Done When

- [ ] All 2 subagent analyses complete
- [ ] Required settings.json documented
- [ ] MCP configuration included
- [ ] Workspace vs User settings distinguished
- [ ] Optional enhancements listed
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
