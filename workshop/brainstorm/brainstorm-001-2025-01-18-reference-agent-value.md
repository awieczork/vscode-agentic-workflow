# Reference Agent Files — VALUE Research

**Objective:** Find VALUE additions for REFERENCE/agent/ files from internal codebase and external sources.
**Constraint:** Must follow current file format — it's working well.

---

## Current State (5 files)

| File | Lines | Key Content |
|------|-------|-------------|
| README.md | ~30 | Navigation hub, quick start |
| PATTERNS.md | ~140 | Design Questions, Tool Selection, Anti-Patterns |
| TEMPLATE.md | ~90 | Full + Minimal templates, Placeholders |
| CHECKLIST.md | ~55 | P1/P2/P3 tiers, Quick Pass |
| TAGS-AGENT.md | ~75 | Required/Recommended/Optional tags + examples |

---

## Sources Analyzed

### 1. GENERATION-RULES/PATTERNS/agent-patterns.md (356 lines)
- RULE_001-008 format with YAML validation blocks
- Reserved Names list (workspace, terminal, vscode, github, azure, plan, ask, edit, agent)
- Tool Aliases table (execute, read, edit, search, agent, web, todo)
- Section Order specification
- Feature Requirements table (experimental settings)

### 2. GENERATION-RULES/CHECKLISTS/agent-checklist.md (237 lines)
- GATE format (CHECK_S001, CHECK_T001, etc.)
- VERIFY/PASS_IF/FAIL_IF/SEVERITY structure
- 5-gate system: Structure → Required Sections → Tool Config → Size → Anti-Patterns

### 3. Official VS Code Docs
- `infer` field (boolean, default true — controls subagent visibility)
- `target` field (vscode | github-copilot)
- `mcp-servers` field (org/enterprise only)
- Handoff behavior details (button display, context preservation)

### 4. awesome-copilot Repository
- 100+ agent examples
- Agent archetypes (Planner, Implementer, Reviewer, Test Writer, Documentation)
- Tool Usage Policy patterns (blueprint-mode)
- Communication Guidelines (spartan, confidence 0-100, final summary)
- Quality Gates pattern (context7)
- Workflow patterns (Debug/Express/Main/Loop)

---

## Decision Log

| ID | Decision | Source | Status |
|----|----------|--------|--------|
| D1 | DROP Reserved Names | Already in NAMING.md + CHECKLIST.md | ✅ Final |
| D2 | DROP Tool Selection rewrite | Current is sufficient; MCP patterns exist | ✅ Final |
| D3 | DROP Handoff Behavior | Belongs in cookbook/WORKFLOWS | ✅ Final |
| D4 | DROP Agent Archetypes | Implicit in tool mappings sufficient | ✅ Final |
| D5 | DROP `infer`/`target` docs | Already in GENERATION-RULES; edge cases | ✅ Final |
| D6 | ADD argument-hint guidance | Missing best practices, high UX impact | ✅ Final |
| D7 | ADD Model Selection guidance | Missing entirely in REFERENCE | ✅ Final |

---

## Iteration Tracker

| # | Type | Focus | Finding |
|---|------|-------|---------|
| 1 | exploration | Reserved Names | HIGH confidence from VS Code source; but already documented |
| 2 | exploration | Tool Aliases | Official names vs aliases; GENERATION-RULES outdated aliases |
| 3 | exploration | Handoffs | Rich behavior details; but cookbook has 548-line coverage |
| 4 | exploration | Archetypes | Common patterns across sources; but implicit is sufficient |
| 5 | CRITIQUE | All proposals | Challenged all 4; found duplications and theoretical bloat |
| 6 | exploration | Counter-arguments | Validated REFERENCE vs GENERATION-RULES audience split |
| 7 | exploration | New Gaps | Found `infer`, `target`, `argument-hint`, model selection |
| 8 | exploration | Validation | Kept argument-hint + model selection only (~18 lines) |
| 9 | exploration | Cross-refs | All links working; optional cookbook link identified |
| 10 | synthesis | Final | Two small additions; everything else stays unchanged |

---

## Potential VALUE Additions (Initial Scan)

### High Value (Missing completely)
1. **Reserved Names** — list of names that conflict with built-in agents → **DROPPED** (already documented)
2. **Tool Aliases** — official alias table for tools → **DROPPED** (already sufficient)
3. **Feature Requirements** — experimental settings needed for certain features → **N/A** (for GENERATION-RULES)
4. **Handoff Behavior** — how buttons work, context preservation → **DROPPED** (cookbook handles)

### Medium Value (Could enhance)
5. **Agent Archetypes** — common patterns (Planner, Builder, Reviewer) → **DROPPED** (implicit sufficient)
6. **Communication Guidelines** — spartan style, confidence scores → **N/A** (agent body, not reference)
7. **Workflow Patterns** — when to use Debug/Express/Main/Loop → **N/A** (cookbook)

### Actually Missing (Found in Iteration 7-8)
8. **`argument-hint` best practices** — action verbs, examples, length → **KEEP** (~8 lines)
9. **Model selection guidance** — when to specify, which model → **KEEP** (~10 lines)

---

## Final Recommendations

### ✅ ADD to PATTERNS.md (~18 lines total)

**1. Argument Hint Guidance (after Anti-Patterns section):**
```markdown
### Argument Hints

Good hints guide user input with action verbs:

```yaml
# Good
argument-hint: 'What do you need researched? (question, URL, or topic)'
argument-hint: 'What should I build? (plan link or task description)'

# Bad
argument-hint: 'Enter input'  # Too vague
argument-hint: 'Type here'    # No guidance
```

**Best practices:**
- Lead with action: "Describe...", "Ask about...", "Provide..."
- Include concrete example in parentheses
- Keep under 100 characters (truncates in UI)
```

**2. Model Selection Guidance (after Tool Selection section):**
```markdown
### Model Selection

Use `model:` when reasoning capability justifies it:

| Task Type | Model Choice | Rationale |
|-----------|--------------|-----------|
| Strategic planning | Opus 4.5 | Extended thinking required |
| Code execution | Sonnet 4 | Fast, sufficient for task |
| Research/synthesis | Opus 4.5 | Cross-document reasoning |

**When to omit:**
- Agent should use user's preferred model
- Cross-platform agents (`target` not set)
- Flexibility more important than consistency

> **Note:** `model` is VS Code-only — ignored by GitHub Copilot.
```

### ⭐ Optional: Cross-Reference Enhancement

Add link to cookbook in Cross-References section:
```markdown
- [cookbook/WORKFLOWS/handoffs-and-chains.md](../../cookbook/WORKFLOWS/handoffs-and-chains.md) — Workflow patterns
```

---

## Handoff

**Research complete.** 10x iteration cycle finished.

**Summary:**
- Analyzed GENERATION-RULES, cookbook, VS Code docs, awesome-copilot
- Ran critique at iteration 5 — rejected 4 proposals as duplicative/theoretical
- Found 2 actual gaps in iteration 7-8: argument-hint + model selection
- Cross-refs validated in iteration 9
- Final synthesis: ~18 lines of additions to PATTERNS.md

**Next:** @build to implement the two additions, or @brain to decide if changes are warranted.
