---
agent: brain
description: Synthesize mcp-patterns.md - THE framework MCP configuration
---

# Synthesize: mcp-patterns.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize THE framework MCP (Model Context Protocol) configuration approach.

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/mcp-patterns.md` |
| Output | `GENERATION-RULES/PATTERNS/mcp-patterns.md` |

## Source Files (3 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [mcp-servers.md](../../cookbook/CONFIGURATION/mcp-servers.md) | Extract: configuration format, transport types |
| 2 | [mcp-server-stacks.md](../../cookbook/REFERENCE/mcp-server-stacks.md) | Extract: recommended stacks, use cases |
| 3 | [settings-reference.md](../../cookbook/CONFIGURATION/settings-reference.md) | Extract: MCP-related settings |

## Iteration Plan (Complexity: Medium → 5 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze mcp-servers.md + Related | @brain |
| 2 | Analysis | Analyze mcp-server-stacks.md + Related | @brain |
| 3 | Analysis | Analyze settings-reference.md (MCP section) | @brain |
| 4 | Critique | Challenge decisions D1-Dn | @brain |
| 5 | Synthesis | Final pattern synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-3) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 4) — challenge accumulated decisions
5. **Address critique** — resolve or document deferral
6. **Synthesize** — produce final mcp-patterns.md

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `patterns`

## Done When

- [ ] All 3 subagent analyses complete
- [ ] Critique iteration complete + challenges addressed
- [ ] THE MCP configuration approach defined
- [ ] mcp.json structure specified
- [ ] Transport types (stdio, http, docker) documented
- [ ] Server stacks for common workflows
- [ ] Anti-patterns documented with "why"
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
