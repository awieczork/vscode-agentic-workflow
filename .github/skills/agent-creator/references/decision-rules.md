# Decision Rules

Mappings from spec elements to agent configuration. Use during Step 3: Decide.

---

## Tools Selection

Map role to tools using least-privilege principle.

**Research / Analysis:**
- Tools: `['read', 'search', 'web']`
- Rationale: Read-only, no modifications

**Planning / Architecture:**
- Tools: `['read', 'search', 'edit']`
- Rationale: Edit specs only, not code

**Implementation / Building:**
- Tools: `['read', 'edit', 'search', 'execute']`
- Rationale: Full CRUD within boundaries

**Review / Validation:**
- Tools: `['read', 'search']`
- Rationale: Read-only verification

**Orchestration:**
- Tools: `['read', 'search', 'agent']`
- Rationale: Coordinates other agents

**Tool aliases:**
- `read` — readFile, listDirectory
- `edit` — editFiles, createFile
- `search` — codebase, textSearch, fileSearch
- `execute` — runInTerminal
- `agent` — runSubagent
- `web` — fetch, WebSearch

**MCP tools:** Use `server/*` or `server/tool` syntax:
```yaml
tools:
  - 'github/*'           # All tools from server
  - 'context7/resolve'   # Specific tool
```

**Hard limit:** ≤15 tools (avoid context overflow from tool descriptions)

---

## Safety Requirements

Conditional requirements based on tool capabilities.

```
IF tools ∩ {edit, execute, delete} ≠ ∅ THEN
  REQUIRE: <iron_law> section (1-3 laws)
  REQUIRE: <red_flags> section with HALT conditions
  REQUIRE: send: false on all handoffs
  REQUIRE: Rationalization tables for each iron law
```

```
IF tools include execute THEN
  REQUIRE: Iron law for destructive commands (rm, delete, rmdir)
  REQUIRE: Red flag for credential exposure
```

```
IF tools include agent THEN
  REQUIRE: max_cycles limit in stopping_rules
  REQUIRE: Subagent depth = 1 only (no subagent-spawning-subagent)
```

---

## Iron Law Format

Required for agents with destructive tools.

```markdown
<iron_law id="IL_001">
**Statement:** [ALL CAPS INVIOLABLE RULE]
**Red flags:** [pattern1], [pattern2], [pattern3]
**Rationalization table:**
- "[excuse1]" → [why it fails]
- "[excuse2]" → [why it fails]
- "[excuse3]" → [why it fails]
</iron_law>
```

**Common iron laws by role:**
- Builder: "NEVER EXECUTE DESTRUCTIVE COMMANDS WITHOUT PATH VERIFICATION"
- Deployer: "NEVER DEPLOY TO PRODUCTION WITHOUT EXPLICIT CONFIRMATION"
- Data agent: "NEVER DELETE DATA WITHOUT BACKUP VERIFICATION"

---

## Boundaries Derivation

Map role to three-tier boundaries.

**Pattern:**
- **Do:** Core responsibilities, read operations, analysis
- **Ask First:** Modifications, external calls, scope expansion
- **Don't:** Out-of-scope actions, destructive operations without confirmation

**Examples by role:**

**Reviewer:**
- Do: Read, search, analyze, report
- Ask First: Suggest architectural changes
- Don't: Modify files, execute commands

**Builder:**
- Do: Create, edit, run tests
- Ask First: Delete files, run destructive commands
- Don't: Change architecture, skip tests

**Planner:**
- Do: Decompose tasks, write specs
- Ask First: Modify existing plans
- Don't: Implement code, execute commands

**Researcher:**
- Do: Search, synthesize, summarize
- Ask First: Access external APIs
- Don't: Modify files, make decisions

---

## Modes Inclusion

```
IF agent handles multiple distinct task types THEN
  Include <modes> section
  Each mode: trigger phrase, steps, output format
  Limit: 2-7 modes
```

```
IF agent has single behavior THEN
  Omit <modes> section entirely
```

**Mode triggers should be:**
- Distinct (no overlap between modes)
- User-language phrases ("review this", "quick check", "deep analysis")
- Explicit activation conditions

---

## Stopping Rules

Every agent needs exit conditions.

**Required mappings:**
- Task complete → Report to user or handoff target
- Blocker found → HALT, report, ask user
- Confidence <50% → Present options, ask user
- 3+ consecutive errors → Stop, summarize, escalate

**Handoff pattern:**
```markdown
<stopping_rules>
- [completion_condition] → @[target_agent]
- [blocker_condition] → Ask user
- max_cycles: 3 → Escalate with summary
- confidence_below_50 → Present options
</stopping_rules>
```

---

## Context Loading

Derive from role's information needs.

**HOT (load every session):**
- Always: `.github/copilot-instructions.md`
- If memory exists: `sessions/_active.md`, `global/projectbrief.md`

**WARM (load on-demand):**
- Decision-making roles: `global/decisions.md`
- Review roles: Previous reports, archived sessions

**FROZEN (excerpts only):**
- Reference documentation
- Large specification files

---

## Handoff Configuration

```
IF handoff targets identified THEN
  Add handoffs array to frontmatter
  Use send: false for targets with edit/execute tools
  Use send: true ONLY for read-only targets after extensive testing
```

**Payload structure:**
```markdown
prompt: |
  ## Summary
  [2-3 sentences of completed work]
  
  ## Key Findings
  - [Finding 1]
  - [Finding 2]
  
  ## Next Steps
  [What target should do]
```
