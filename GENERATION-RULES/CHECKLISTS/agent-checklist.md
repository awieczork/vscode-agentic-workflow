---
type: checklist
version: 1.0.0
purpose: Validate agent files against agent-patterns.md rules
checklist-for: agent
applies-to: [generator, build, inspect]
last-updated: 2026-01-28
---

# Agent Checklist

> **Validate `.agent.md` files against framework rules before deployment**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
Run this checklist after creating any agent file. All BLOCKING items must pass.

**For Build Agents:**
Validate generated agents before committing. Fix any failures before proceeding.

**For Inspect Agents:**
Use this checklist as verification criteria. Report failures with specific rule IDs.

---

## GATE 1: Structure & Naming

```
CHECK_S001: Filename Format
  VERIFY: Filename matches pattern `{name}.agent.md`
  PASS_IF: Lowercase, hyphens only, ≤50 characters
  FAIL_IF: Uppercase, underscores, spaces, or >50 chars
  SEVERITY: BLOCKING

CHECK_S002: Reserved Names
  VERIFY: Agent name not in reserved list
  PASS_IF: Name not in: workspace, terminal, vscode, github, azure, plan, ask, edit, agent
  FAIL_IF: Uses any reserved name
  SEVERITY: BLOCKING

CHECK_S003: Frontmatter Present
  VERIFY: File starts with YAML frontmatter
  PASS_IF: Has `---` delimiters with valid YAML
  FAIL_IF: Missing or malformed frontmatter
  SEVERITY: BLOCKING

CHECK_S004: Title Present
  VERIFY: Has markdown title with summary
  PASS_IF: `# Agent Name` heading with one-line description
  FAIL_IF: Missing title or summary
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_S001: Filename is lowercase with hyphens, ≤50 chars
- [ ] CHECK_S002: Name not reserved (workspace, terminal, vscode, github, azure, plan, ask, edit, agent)
- [ ] CHECK_S003: Valid YAML frontmatter present
- [ ] CHECK_S004: Has `# Title` with one-line summary

**Gate 1 Result:** [ ] PASS  [ ] FAIL

---

## GATE 2: Required Sections

```
CHECK_R001: Safety Section
  VERIFY: Has `<safety>` or `## Safety` section
  PASS_IF: P1 constraints documented, no escape clauses
  FAIL_IF: Missing for agent with edit/execute tools; P1 has "unless..." clauses
  SEVERITY: BLOCKING (if has tools), WARNING (advisory-only)

CHECK_R002: Context Loading
  VERIFY: Has `<context_loading>` or equivalent section
  PASS_IF: Declares session start files to load
  FAIL_IF: No context strategy (starts blind)
  SEVERITY: WARNING

CHECK_R003: Boundaries Section
  VERIFY: Has boundaries or scope definition
  PASS_IF: Three-tier format (✅ Do / ⚠️ Caution / 🚫 Don't)
  FAIL_IF: Vague boundaries without actionable rules
  SEVERITY: WARNING

CHECK_R004: Stopping Rules
  VERIFY: Has stopping/handoff criteria
  PASS_IF: Handoff triggers documented with conditions
  FAIL_IF: No stopping rules for iterative modes
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_R001: Safety section with P1 constraints (no escape clauses)
- [ ] CHECK_R002: Context loading strategy defined
- [ ] CHECK_R003: Boundaries section with ✅/⚠️/🚫 format
- [ ] CHECK_R004: Stopping rules defined with triggers

**Gate 2 Result:** [ ] PASS  [ ] FAIL

---

## GATE 3: Tool Configuration

```
CHECK_T001: Tools Explicit
  VERIFY: `tools:` field is explicitly configured
  PASS_IF: Specific tool list OR intentional `["*"]` with justification
  FAIL_IF: `tools: []` without advisory-only documentation
  SEVERITY: WARNING

CHECK_T002: Handoff Safety
  VERIFY: Handoff `send:` defaults are safe
  PASS_IF: All handoffs have `send: false` OR documented justification for `send: true`
  FAIL_IF: `send: true` on handoffs to agents with edit/execute tools
  SEVERITY: BLOCKING
```

**Human-readable:**
- [ ] CHECK_T001: Tools explicitly configured (not empty without reason)
- [ ] CHECK_T002: Handoffs default to `send: false`

**Gate 3 Result:** [ ] PASS  [ ] FAIL

---

## GATE 4: Size & Complexity

```
CHECK_C001: Character Limit
  VERIFY: Body content ≤25,000 characters
  PASS_IF: Total body characters ≤25,000
  FAIL_IF: Exceeds 25,000 characters
  SEVERITY: WARNING

CHECK_C002: Line Limit
  VERIFY: Total lines ≤300 (soft limit)
  PASS_IF: ≤300 lines OR justified complexity
  FAIL_IF: >300 lines without justification
  SEVERITY: WARNING

CHECK_C003: Step Scope
  VERIFY: Designed for bounded tasks
  PASS_IF: 3-10 step tasks with exit criteria
  FAIL_IF: Unbounded iteration without exit criteria
  SEVERITY: WARNING

CHECK_C004: Prefix Matches Category
  VERIFY: Name prefix matches agent type
  PASS_IF: Core (no prefix), meta (`meta-`), model variant (`-{model}`)
  FAIL_IF: Wrong prefix for agent type
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_C001: Body ≤25,000 characters
- [ ] CHECK_C002: File ≤300 lines (or justified)
- [ ] CHECK_C003: Tasks are 3-10 steps with exit criteria
- [ ] CHECK_C004: Name prefix matches category

**Gate 4 Result:** [ ] PASS  [ ] FAIL

---

## GATE 5: Anti-Patterns

```
CHECK_A001: No Nested Subagents
  VERIFY: Architecture is hub-and-spoke
  PASS_IF: Only orchestrator spawns subagents
  FAIL_IF: Specialist agent spawns other specialists
  SEVERITY: BLOCKING

CHECK_A002: Examples Over Explanations
  VERIFY: Content ratio favors examples
  PASS_IF: More DO/DON'T examples than prose explanations
  FAIL_IF: Explanation-heavy without examples
  SEVERITY: WARNING

CHECK_A003: Exit Conditions in Loops
  VERIFY: Iterative modes have limits
  PASS_IF: Has "After N cycles, escalate" or equivalent
  FAIL_IF: Loop without iteration counter or max cycles
  SEVERITY: WARNING

CHECK_A004: Specific Stack
  VERIFY: Technology references are explicit
  PASS_IF: Explicit versions (e.g., "TypeScript 5.4")
  FAIL_IF: Vague descriptions ("modern practices")
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_A001: No nested subagent spawning (hub-and-spoke only)
- [ ] CHECK_A002: More examples than explanations
- [ ] CHECK_A003: Loops have exit conditions ("After N, escalate")
- [ ] CHECK_A004: Tech stack versions explicit (not "modern")

**Gate 5 Result:** [ ] PASS  [ ] FAIL

---

## SUMMARY

| Gate | Status | Notes |
|------|--------|-------|
| 1. Structure & Naming | | |
| 2. Required Sections | | |
| 3. Tool Configuration | | |
| 4. Size & Complexity | | |
| 5. Anti-Patterns | | |

**Overall:** [ ] PASS — Ready for deployment  [ ] FAIL — Needs revision

**Blocking Issues:**
- 

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [agent-patterns.md](../PATTERNS/agent-patterns.md) | Rules being verified |
| [RULES.md](../RULES.md) | P1/P2/P3 constraint definitions |
| [NAMING.md](../NAMING.md) | Naming convention details |
| [orchestration-checklist.md](orchestration-checklist.md) | Related handoff validation |

---

## SOURCES

- [agent-patterns.md](../PATTERNS/agent-patterns.md) — All RULE_NNN items
- [validation-checklist.md](../../cookbook/TEMPLATES/validation-checklist.md) — Gate format
