---
type: patterns
version: 1.0.0
purpose: Define THE framework approach to agent orchestration — handoffs, subagents, workflows
applies-to: [generator, build, inspect, architect]
last-updated: 2026-01-28
---

# Orchestration Patterns

> **THE framework approach to agent-to-agent coordination, workflow composition, and multi-agent collaboration.**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
1. Use ARCHITECTURE SELECTION to determine workflow shape
2. Apply HANDOFF vs SUBAGENT decision rule (D1)
3. Follow templates for handoff prompts and subagent requests
4. Validate against AUTHORING RULES

**For Build Agents:**
1. Reference CHAIN PATTERNS for workflow implementation
2. Apply ERROR HANDLING protocol
3. Ensure observability logging per D23

**For Inspect Agents:**
1. Verify hub-and-spoke constraint (D10)
2. Check loop exit conditions (D8)
3. Validate handoff prompt structure (D4)

---

## PURPOSE

Orchestration solves three problems:

| Problem | Solution |
|---------|----------|
| **Context pollution** | Subagent isolation — heavy work returns focused summary |
| **Sequential dependencies** | Handoff chains — pass work to next specialist |
| **Parallel workloads** | Background agents — true concurrent execution |

**Core Principle:** The orchestrator coordinates; specialists execute; results flow through the hub.

---

## THE FRAMEWORK APPROACH

### Orchestration Model: Hub-and-Spoke

```
             User Request
                  ↓
           ┌─────────────┐
           │ orchestrator│ ← ROOT coordinator
           └─────────────┘
             ↙  ↓  ↓  ↘
      specialist specialist specialist specialist
             ↘  ↓  ↓  ↙
           (results return)
           ┌─────────────┐
           │ orchestrator│ ← synthesizes
           └─────────────┘
```

**Non-Negotiable Constraints:**

| Constraint | Status | Implication |
|------------|--------|-------------|
| ONE orchestrator at root | Current | All delegation flows through hub |
| ONE-level depth | Current | Specialists CANNOT invoke other specialists |
| Subagents CANNOT nest | Current | `runSubagent` not inherited by subagents |
| `handoffs:` is VS Code only | Platform | GitHub.com coding agent ignores this property |
| Subagents are SYNCHRONOUS | By design | NOT parallel — context isolation only |

### Primary Decision: Subagent vs Handoff

```
IF results_needed_back
  THEN → #runSubagent (returns inline to parent)
ELSE IF target_completes_independently
  THEN → handoffs: (new session, original archived)
```

| Mechanism | Context Model | Use Case |
|-----------|---------------|----------|
| `#runSubagent` | Inline, returns to parent | Research, exploration, analysis |
| `handoffs:` | New session, archived | Phase transitions, specialist completion |

---

## ARCHITECTURE SELECTION

### Decision Rules (Machine-Parseable)

```
IF each_step_needs_output_from_previous
  THEN → SERIAL

ELSE IF tasks_are_independent AND need_true_concurrency
  THEN → PARALLEL (background agents)

ELSE IF tasks_require_different_specialist_expertise
  THEN → BRANCH

ELSE IF output_needs_iterative_quality_improvement
  THEN → LOOP

ELSE IF workflow_is_reusable_across_projects
  THEN → NESTED (workflow-as-agent)

ELSE
  THEN → SERIAL (safest default)
```

### Architecture Comparison Matrix

| Architecture | Shape | Execution | VS Code Mechanism |
|--------------|-------|-----------|-------------------|
| **Serial** | A → B → C | Sequential, blocking | `handoffs:` chain |
| **Parallel** | Split → [A,B,C] → Merge | Concurrent | Background agents (v1.107+) |
| **Branch** | Classifier → [X OR Y OR Z] | Single path selected | Agent instructions decide |
| **Loop** | Draft → Review → [Pass/Revise] | Iterative until threshold | Handoffs with counter |
| **Nested** | Main → [SubWorkflow] → Continue | Black-box composition | Dedicated workflow agent |

### Serial Chain Pattern

```yaml
# researcher.agent.md
handoffs:
  - label: Create Plan
    agent: planner
    prompt: |
      ## Handoff: researcher → planner
      ### Summary
      {2-3 sentences}
      ### Key Findings
      - {finding 1}
      - {finding 2}
      ### Files Relevant
      - `path/to/file.ts`
      ### Next Steps
      {what planner should do}
    send: false  # Human reviews before proceeding
```

**Depth Limit:** Max 3-4 agents per serial chain. More requires explicit justification.

### Loop Pattern (Iterative Refinement)

```
draft → review → [PASS] → finalize
            ↓
       [NEEDS WORK] → draft (iteration N+1)
            ↓
       [MAX CYCLES] → escalate to human
```

**Exit Conditions (REQUIRED):**

| Condition | Action |
|-----------|--------|
| All criteria met | → Finalize |
| Issues found, cycles < 3 | → Revise (increment counter) |
| Cycles ≥ 3 | → STOP, escalate to human |

**Loop counter in handoff:**
```yaml
prompt: "Revision #2: Please address these issues..."
```

### Branch Pattern (Conditional Routing)

VS Code has NO native conditional syntax. Agent instructions classify and present options:

```yaml
# classifier.agent.md
handoffs:
  - label: Implement
    agent: implementer
    prompt: "Implement this feature."
    send: false

  - label: Review
    agent: reviewer
    prompt: "Review this code."
    send: false

  - label: Document
    agent: documenter
    prompt: "Document this component."
    send: true  # Lower risk — auto-submit OK
```

**Classification in instructions body:**
```markdown
## Routing Rules
| Request Contains | Route To |
|------------------|----------|
| "implement", "build", "create" | → Implement |
| "review", "check", "audit" | → Review |
| "document", "explain" | → Document |
```

### Parallel Pattern (Background Agents)

**Subagents are NOT parallel.** For true concurrency, use background agents (VS Code 1.107+):

```
[Main] ───┬───→ [Background A] (worktree: feature-a)
          ├───→ [Background B] (worktree: feature-b)
          └───→ [Background C] (worktree: feature-c)
```

- Each background agent works in isolated Git worktree
- Prevents file conflicts between parallel tasks
- Orchestrator spawns and checks completion on next interaction

---

## STRUCTURE

### Handoff Configuration

| Property | Required | Default | Purpose |
|----------|----------|---------|---------|
| `label` | Yes | — | Button text shown in UI |
| `agent` | Yes | — | Target agent name (no `.agent.md`) |
| `prompt` | No | — | Context passed to target |
| `send` | No | `false` | `false` = human reviews; `true` = auto-submit |

### Handoff Prompt Template (REQUIRED)

Every handoff prompt MUST include:

```markdown
## Handoff: {source} → {target}

### Summary
{2-3 sentences of completed work}

### Key Findings
- {finding 1}
- {finding 2}

### Files Modified/Relevant
- `path/to/file.ts` — {brief description}

### Next Steps
{What target agent should do}

### Constraints
{Limitations or requirements carried forward}
```

**Critical state summary:** Max 5 bullets (backup for unreliable memory bank writes).

### Subagent Request Template (REQUIRED)

```markdown
Use #runSubagent to research [specific topic] in the codebase.

Return a [50]-line summary with:
- Relevant file paths
- Key functions/patterns found
- Current implementation approach
- Recommended next steps

Do NOT return raw file contents.
```

**Request components:**
1. Explicit `#runSubagent` invocation
2. Specific topic scope
3. Output length constraint (lines or tokens)
4. Structured return format
5. Exclusion directive

### Subagent Return Format (REQUIRED)

```markdown
## Agent: {agent-name}

### {Topic} Findings
{summary}

### Confidence: {High|Medium|Low}
### Sources: {file paths}
```

**Identity requirement:** Returns MUST include agent name header for orchestrator validation.

---

## AUTHORING RULES

```
RULE_001: Hub-and-Spoke Mandatory
  REQUIRE: ONE orchestrator at root level
  REJECT_IF: Specialist invokes another specialist
  RATIONALE: Platform constraint — subagents cannot spawn subagents
  EXAMPLE_VALID: orchestrator → [analyst, planner, implementer] → orchestrator
  EXAMPLE_INVALID: analyst → planner (peer-to-peer)

RULE_002: Handoff Human Gate Default
  REQUIRE: `send: false` unless explicitly justified
  REJECT_IF: `send: true` on destructive/implementation handoffs
  RATIONALE: Human-in-the-loop catches errors before propagation
  EXAMPLE_VALID: send: false (human reviews)
  EXAMPLE_INVALID: send: true on "Deploy to Production" handoff

RULE_003: Loop Exit Condition
  REQUIRE: max_cycles field (default 3), explicit exit criteria
  REJECT_IF: Loop without iteration counter or max cycles
  RATIONALE: Prevents infinite loops and token burn
  EXAMPLE_VALID: "Revision #2: ..." with max 3 cycles
  EXAMPLE_INVALID: Loop with no counter or "until done"

RULE_004: Subagent Output Constraint
  REQUIRE: Output length limit in request (e.g., "50-line summary")
  REJECT_IF: Request allows unbounded output or raw dumps
  RATIONALE: Prevents context pollution in parent
  EXAMPLE_VALID: "Return 50-line summary with file paths"
  EXAMPLE_INVALID: "Return everything you find"

RULE_005: Fast Path for Simple Tasks
  REQUIRE: Single-agent tasks bypass orchestration
  REJECT_IF: Orchestration ceremony for trivial requests
  RATIONALE: Framework overhead unjustified for simple cases
  EXAMPLE_VALID: Direct response to "explain this function"
  EXAMPLE_INVALID: Spawning subagent for one-line answer

RULE_006: Chain Depth Limit
  REQUIRE: Max 3-4 agents in serial chain
  REJECT_IF: Chain depth > 4 without documented justification
  RATIONALE: Debuggability — longer chains are error-prone
  EXAMPLE_VALID: researcher → planner → implementer (depth 3)
  EXAMPLE_INVALID: A → B → C → D → E → F (depth 6)
```

---

## ERROR HANDLING

### Timeout Configuration

| Task Type | Timeout | Use When |
|-----------|---------|----------|
| `fast` | 30s | Simple lookups, single-file reads |
| `standard` | 60s | Multi-file analysis, moderate research |
| `extended` | 180s | Deep research, large codebase exploration |

### Failure Protocol

```
ON agent_failure:
  1. LOG: timestamp, agent, error, context
  2. IF retries < 2:
       RETRY with additional context
  3. ELSE IF failure is recoverable:
       SKIP non-critical step, continue
  4. ELSE:
       ESCALATE to orchestrator with error summary

ON orchestrator_failure:
  CIRCUIT BREAKER: 3 consecutive errors from same chain
    → STOP chain
    → REQUIRE human review before proceeding
  
  CROSS-CHAIN: 5 errors across chains
    → ESCALATE to human
```

### Partial Completion Protocol

When agent completes partially before failure:

```markdown
## Partial Completion Report

### Completed
- {what was done}

### Remaining
- {what's left}

### Blockers
- {why stopped}

### Recommendation
{resume OR reassign OR escalate}
```

### Branch Conflict Resolution

When parallel branches return conflicting results:

```
IF conflict_detected:
  1. Orchestrator presents BOTH results with rationale
  2. IF priority_hierarchy_defined:
       Apply `handoffs:` declaration order
  3. ELSE:
       User decides
```

---

## OBSERVABILITY

### Logging Requirements

```markdown
## Orchestration Log Entry

**Timestamp:** {ISO 8601}
**Source:** {agent name}
**Target:** {agent name or "user"}
**Action:** {handoff | subagent | error | complete}
**Prompt Summary:** {first 100 chars}
**Result Summary:** {first 100 chars or error message}
```

**Storage:**
- Ephemeral: `workshop/orchestration-logs/{session-id}.md`
- Persistent: Summary to memory bank at session end only

### Context Budget Heuristic

```
AFTER N handoffs OR subagent returns (N = 3-5):
  ASSUME context at ~50%
  TRIGGER compaction checkpoint
  
MANUAL: Agent can request compaction anytime with justification
```

---

## ROUTING AND CLASSIFICATION

### Confidence Thresholds

| Confidence | Action |
|------------|--------|
| ≥ 0.8 | Route immediately |
| 0.5 – 0.8 | Route + offer: "Let me know if you meant something different" |
| < 0.5 | Ask ONE clarifying question with options |

**Precedence:** Loop max cycles (RULE_003) overrides confidence-based clarification.

### Fallback Protocol

```
ON classification_failure:
  1. Answer directly (if possible)
  2. Ask ONE clarifying question (max 1)
  3. Route to research (if exploratory)
  4. Escalate to human (if truly ambiguous)

NEVER:
  - Refuse without attempting to help
  - Route randomly
  - Ask multiple questions
```

### Priority Handling

| Priority | Trigger | Action |
|----------|---------|--------|
| **P0** | "blocks all work" — security, data loss | STOP immediately, escalate to human |
| **P1** | "blocks this track" — missing dependency | Pause current, route to specialist |
| **P2-P4** | Non-blocking issues | Log discovery, continue current work |

---

## VALIDATION CHECKLIST

```
VALIDATE_orchestration:
  □ Uses hub-and-spoke (no peer-to-peer)
  □ Subagent requests include output constraint
  □ Handoff prompts follow template
  □ Loops have max_cycles and exit conditions
  □ `send: false` for destructive handoffs
  □ Chain depth ≤ 4 (or justified)
  □ Fast path for single-agent tasks
  □ Error handling defined
  □ Logging to workshop/orchestration-logs/
```

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| Nested subagents | Hub-and-spoke only | Platform constraint — `runSubagent` not inherited |
| `send: true` on implementations | `send: false` (human gate) | Catch errors before propagation |
| Unbounded subagent output | "Return 50-line summary" | Prevents context pollution |
| Loop without exit condition | Max 3 cycles + criteria | Prevents infinite loops |
| Passing raw file dumps | Pass findings, paths, decisions | Keeps handoffs focused |
| Assuming subagents are parallel | Subagents are synchronous | Context isolation ≠ parallel execution |
| Complex orchestration for simple tasks | Fast path bypass | Framework overhead not always justified |
| Peer-to-peer specialist routing | All through orchestrator | Maintains single point of coordination |

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [agent-patterns.md](agent-patterns.md) | Agent structure that participates in orchestration |
| [memory-patterns.md](memory-patterns.md) | State persistence between orchestration steps |
| [COMPONENT-MATRIX.md](../COMPONENT-MATRIX.md) | When to create orchestrator vs specialist agents |

---

## SOURCES

- [handoffs-and-chains.md](../../cookbook/WORKFLOWS/handoffs-and-chains.md) — Handoff configuration, chain patterns
- [workflow-orchestration.md](../../cookbook/WORKFLOWS/workflow-orchestration.md) — Architecture types, VS Code constraints
- [subagent-isolation.md](../../cookbook/CONTEXT-ENGINEERING/subagent-isolation.md) — Subagent mechanics, context isolation
- [conditional-routing.md](../../cookbook/WORKFLOWS/conditional-routing.md) — Classification strategies, routing logic
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — Official handoffs reference
- [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) — Subagent constraints, background agents
