# Decision Rules

Mappings from spec elements to agent configuration. Use during Step 3: Decide.

<tools_selection>

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

</tools_selection>

<safety_requirements>

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

</safety_requirements>

<iron_law_format>

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

</iron_law_format>

<boundaries_derivation>

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

</boundaries_derivation>

<modes_inclusion>

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

</modes_inclusion>

<stopping_rules_section>

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

</stopping_rules_section>

<context_loading_section>

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

</context_loading_section>

<handoff_configuration>

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

</handoff_configuration>

<behavioral_steering>

## Behavioral Steering

Map behavioral need to XML steering pattern.

### Proactive Implementation

**Use when:** Builder agents, task executors, agents that should act by default

```markdown
<default_to_action>
By default, implement changes rather than only suggesting them.
If the user's intent is unclear, infer the most useful likely action and proceed,
using tools to discover any missing details instead of guessing.
</default_to_action>
```

### Conservative Research

**Use when:** Analyst agents, architects, reviewers, agents that should gather before acting

```markdown
<do_not_act_before_instructions>
Do not jump into implementation or change files unless clearly instructed.
When the user's intent is ambiguous, default to providing information, doing research,
and providing recommendations rather than taking action.
</do_not_act_before_instructions>
```

### Code Exploration Required

**Use when:** Any agent discussing codebase

```markdown
<investigate_before_answering>
Never speculate about code you have not opened.
If the user references a specific file, you MUST read the file before answering.
Investigate and read relevant files BEFORE answering questions about the codebase.
</investigate_before_answering>
```

### Verbosity Control

**Use when:** Agents that use many tools and need summary output

```markdown
After completing a task that involves tool use, provide a quick summary of the work you've done.
```

### Thinking After Tool Use

**Use when:** Complex multi-step workflows requiring reflection

```markdown
After receiving tool results, carefully reflect on their quality and determine optimal next steps before proceeding.
Use your thinking to plan and iterate based on this new information, and then take the best next action.
```

### Subagent Delegation Control

**Use when:** Agents that spawn subagents and need conservative delegation

```markdown
Only delegate to subagents when the task clearly benefits from a separate agent with a new context window.
```

</behavioral_steering>

<cross_references>

## Cross-References

- [SKILL.md](../SKILL.md) — Parent skill entry point

</cross_references>
