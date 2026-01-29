---
when:
  - designing multi-agent workflows
  - building DAG-based task execution
  - implementing parallel or branching workflows
  - orchestrating complex agent collaboration
pairs-with:
  - conditional-routing
  - handoffs-and-chains
  - subagent-isolation
  - task-tracking
requires:
  - multi-agent
complexity: high
---

# Workflow Orchestration

Design multi-agent workflows beyond simple linear chains. This covers DAG patterns, parallel execution, fan-out/fan-in aggregation, and iterative loops—the architectural shapes that determine how agents collaborate.

## Architecture Types

| Pattern | Description | When to Use |
|---------|-------------|-------------|
| **Serial** | Sequential node execution | Linear processing chains |
| **Parallel** | Fan-out to concurrent nodes | Independent tasks requiring speed |
| **Branch** | Conditional routing via classifier | Context-dependent processing |
| **Loop** | Iterative refinement until threshold | Quality improvement cycles |
| **Nested** | Workflow invokes sub-workflow | Composable, reusable components |

## Framework Pattern Reference

Patterns from agent orchestration frameworks, adapted for VS Code:

| Framework | Pattern | VS Code Adaptation |
|-----------|---------|-------------------|
| **LangGraph** | State machine graph | Handoff-based routing with state in handoff prompts |
| **CrewAI** | Role-based crews | Specialized agents with defined handoffs |
| **AutoGen** | Event-driven teams | Round-robin via orchestrator agent |
| **Dify** | DAG workflows | Workflow files with dependency notation |

## Serial Architecture

The simplest pattern—agents execute in sequence:

```
[Research] → [Plan] → [Implement] → [Review]
```

**When to use:** Linear dependencies, each step needs output from previous.

**Implementation:** See [handoffs-and-chains](handoffs-and-chains.md) for configuration details.

## Parallel Architecture (Fan-Out/Fan-In)

Execute independent tasks concurrently, then aggregate results:

```
                    ┌──────────────┐
                    │ orchestrator │
                    └──────────────┘
                          │ split
            ┌─────────────┼─────────────┐
            ↓             ↓             ↓
       ┌────────┐   ┌────────┐   ┌────────┐
       │ task-a │   │ task-b │   │ task-c │
       └────────┘   └────────┘   └────────┘
            │             │             │
            └─────────────┼─────────────┘
                          ↓ aggregate
                    ┌──────────────┐
                    │ orchestrator │
                    └──────────────┘
```

**When to use:** Independent tasks (research multiple topics, analyze different files, parallel reviews).

### VS Code Implementation

<!-- NOTE: Subagents (#runSubagent) execute SYNCHRONOUSLY, not in parallel. Official docs state: "Subagents don't run asynchronously or in the background." For true parallel execution, use background agents with Git worktrees or Mission Control. -->

Subagents (`#runSubagent`) provide **context-isolated execution** but run synchronously. For parallel task execution, use background agents or Mission Control.

Source: [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

**Two approaches:**

**1. Sequential Subagents with Context Isolation**

Subagents run one at a time but with isolated context, preventing context window pollution:

```markdown
# orchestrator.agent.md

## Sequential Research Protocol

When given multiple research tasks:

1. **Dispatch sequentially** (each runs in isolated context):
   - Use #runSubagent for topic A → wait for completion
   - Use #runSubagent for topic B → wait for completion
   - Use #runSubagent for topic C → wait for completion

2. **Aggregate results**:
   - Collect summaries as each subagent completes
   - Synthesize into unified output

3. **Report format**:
   | Topic | Key Findings | Confidence |
   |-------|--------------|------------|
   | A | {summary} | High/Medium/Low |
   | B | {summary} | High/Medium/Low |
   | C | {summary} | High/Medium/Low |
```

> **Note:** Subagents don't run asynchronously or in the background. They operate autonomously without pausing for user feedback, but complete sequentially.
>
> Source: [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

**2. Background Agents with Git Worktrees (VS Code 1.107+)**

For heavier parallel workloads, use background agents with Git worktree isolation:

```
[Main Workspace] ───┬───→ [Background Agent A] (worktree: feature-a)
                    ├───→ [Background Agent B] (worktree: feature-b)
                    └───→ [Background Agent C] (worktree: feature-c)
```

- Each background agent works in an isolated Git worktree
- Prevents file conflicts between parallel tasks
- Results merge back via standard Git operations
- Managed through **Agent Sessions view** in VS Code Chat

### Custom Agents as Subagents

Enable custom agents for parallel dispatch:

```json
// settings.json
{
  "chat.customAgentInSubagent.enabled": true
}
```

### Fan-Out Request Template

```markdown
Use #runSubagent to research [TOPIC].

Constraints:
- Focus only on [TOPIC], ignore related areas
- Return 50-line summary maximum
- Include confidence assessment

Return format:
### [TOPIC] Findings
{summary}

### Confidence: {High|Medium|Low}
### Sources: {list}
```

### Fan-In Aggregation Template

After collecting parallel results, aggregate:

```markdown
## Aggregation Protocol

Given results from parallel tasks:

1. **Deduplicate** overlapping findings
2. **Resolve conflicts** (higher confidence wins)
3. **Synthesize** into coherent summary
4. **Flag gaps** where coverage is incomplete

Output format:
### Synthesized Findings
{merged summary}

### Conflicts Resolved
| Finding | Source A | Source B | Resolution |
|---------|----------|----------|------------|

### Coverage Gaps
- {gap 1}
- {gap 2}
```

## Branch Architecture

Route tasks to specialized agents based on classification:

```
               ┌──────────────┐
               │  classifier  │
               └──────────────┘
                      │
        ┌─────────────┼─────────────┐
        ↓             ↓             ↓
   ┌────────┐   ┌────────┐   ┌────────┐
   │ code   │   │  docs  │   │ review │
   └────────┘   └────────┘   └────────┘
```

**When to use:** Tasks requiring different expertise, user intents vary.

### VS Code Implementation

```yaml
# classifier.agent.md
---
name: task-classifier
description: Routes tasks to specialist agents

handoffs:
  - label: Implementation Task
    agent: implementer
    prompt: "Implement this feature."

  - label: Documentation Task
    agent: documenter
    prompt: "Document this component."

  - label: Review Task
    agent: reviewer
    prompt: "Review this code."
---

## Classification Rules

Analyze the request and route appropriately:

| Request Contains | Route To |
|------------------|----------|
| "implement", "build", "create", "add" | Implementation Task |
| "document", "explain", "describe" | Documentation Task |
| "review", "check", "audit", "PR" | Review Task |

Present only the relevant handoff button(s).
```

See [conditional-routing](conditional-routing.md) for advanced classification patterns.

## Loop Architecture (Iterative Refinement)

Repeat until quality threshold met:

```
                    ┌──────────┐
                    │  draft   │
                    └──────────┘
                          │
                          ↓
                    ┌──────────┐
            ┌───────│  review  │───────┐
            │       └──────────┘       │
            │             │            │
         [PASS]      [REVISE]      [ESCALATE]
            │             │            │
            ↓             ↓            ↓
         [DONE]    → back to      [HUMAN
                     draft          REVIEW]
```

**When to use:** Quality improvement, code review cycles, iterative design.

### VS Code Implementation

**reviewer.agent.md:**
```yaml
---
name: reviewer
description: Reviews work and routes based on quality

handoffs:
  - label: Revision Needed
    agent: drafter
    prompt: |
      ## Revision Required

      Issues found:
      {ISSUES_LIST}

      Please address these and resubmit.
    send: false

  - label: Approved
    agent: finalizer
    prompt: "Quality approved. Finalize for delivery."
    send: false
---

## Review Protocol

### Quality Criteria
- [ ] Meets acceptance criteria
- [ ] No critical issues
- [ ] Follows project conventions

### Routing Decision

**Approve** (→ Finalizer) when:
- All criteria met
- Issues are minor/cosmetic only

**Revise** (→ Drafter) when:
- Missing required functionality
- Breaking changes detected
- Major style violations

**Escalate** (→ Human) when:
- 3+ revision cycles completed
- Ambiguous requirements
- Architectural decisions needed

## Exit Condition

After **3 revision cycles**, escalate to human review.
Never loop infinitely.
```

### Loop Counter Pattern

Track iterations to prevent infinite loops:

```markdown
## Iteration Tracking

At the start of each review:

1. Check revision count in handoff prompt
2. If count >= 3: escalate to human
3. Otherwise: increment and continue

Handoff prompt format:
"Revision #{N}: Please address these issues..."
```

## Nested Architecture

Invoke sub-workflows as reusable components:

```
┌─────────────────────────────────────────┐
│            main-workflow                │
│                                         │
│  [Start] → [auth-workflow] → [End]      │
│                    │                    │
│            ┌──────────────┐             │
│            │ (nested)     │             │
│            │ Login → 2FA  │             │
│            └──────────────┘             │
└─────────────────────────────────────────┘
```

**When to use:** Reusable workflows (auth, validation, deployment), DRY principle.

### VS Code Implementation

Create specialized agents that encapsulate workflows:

**auth-workflow.agent.md:**
```yaml
---
name: auth-workflow
description: Handles authentication flows
tools: ["read", "edit"]
---

## Authentication Workflow

### Steps
1. Validate credentials format
2. Check rate limits
3. Generate tokens
4. Set secure cookies

### Interface
**Input:** User credentials, session context
**Output:** Auth tokens or error with reason

### Usage
Invoke from parent workflow:
"Use @auth-workflow to handle user authentication for this session."
```

## Cross-Platform Orchestration

### Mission Control (GitHub)

For orchestrating agents across multiple repositories:

```
┌─────────────────────────────────────────────────────┐
│                  Mission Control                     │
│           (github.com/copilot/agents)               │
├──────────────┬──────────────┬───────────────────────┤
│   Repo A     │    Repo B    │       Repo C          │
│ [Agent 1]    │  [Agent 2]   │    [Agent 3]          │
│ (Feature X)  │ (Bug fix Y)  │  (Refactor Z)         │
└──────────────┴──────────────┴───────────────────────┘
```

- Assign multiple tasks across repositories from one dashboard
- Track progress, steer agents, and review results centrally
- Available on: GitHub.com, VS Code, GitHub Mobile, GitHub CLI, JetBrains IDEs
- Access via: Agents panel on github.com, or type `/task` in github.com/copilot chat

Source: [GitHub Blog - Mission Control](https://github.blog/ai-and-ml/github-copilot/how-to-orchestrate-agents-using-mission-control/)

### Agent Sessions View (VS Code)

Unified interface for managing local, background, and cloud agents:

- **Local agents:** Run in current VS Code session
- **Background agents:** Run asynchronously with Git worktree isolation
- **Cloud agents (Coding Agent):** Run on GitHub infrastructure

**Access methods:**
- Chat view → Sessions list (controlled by `chat.viewSessions.enabled`)
- Command Palette: `Chat: New Background Agent`, `Chat: New Cloud Agent`
- Quick Open: Type "agent" in Ctrl+P/⌘P
- @cli or @cloud mentions in chat to delegate tasks

**Settings:**
- `chat.viewSessions.orientation` — controls sessions list display (auto, horizontal, vertical)
- `chat.agentSessionsViewLocation` — controls view location (`view` for Side Bar, `showChatsMenu` for Chat dropdown)

Source: [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

## Dependency Notation

For complex workflows, use explicit dependency tracking (from [steveyegge/beads](https://github.com/steveyegge/beads)):

### Dependency Types

| Notation | Meaning | Example |
|----------|---------|---------|
| `[blocks: X]` | This task blocks X | Task A [blocks: B] |
| `[blocked-by: Y]` | This task blocked by Y | Task C [blocked-by: A, B] |
| `[parallel]` | Can run in parallel | Tasks D, E [parallel] |
| `[discovered-from: Z]` | Found while working on Z | Task F [discovered-from: D] |

### Workflow File Example

```markdown
## Execution Model
Phases execute sequentially. Steps within phases run in parallel unless blocked.

## Phase 1: Design [sequential]
- [ ] Step 1.1: Research existing patterns

## Phase 2: Implementation [parallel]
- [ ] Step 2.1: Backend [parallel]
- [ ] Step 2.2: Frontend [parallel]

## Phase 3: Review [sequential]
- [ ] Step 3.1: Spec Review [blocks: Step 3.2]
- [ ] Step 3.2: Quality Review [blocked-by: Step 3.1]
```

## Data Flow Between Nodes

### Variable Passing

| Source | Mechanism | Example |
|--------|-----------|---------|
| **Handoff prompt** | Explicit context | `prompt: "Based on: {FINDINGS}"` |
| **Subagent return** | Summary in response | "Return 50-line summary" |
| **Shared files** | File system | `.github/memory-bank/active.md` |

### What to Pass Forward

| Pass | Don't Pass |
|------|------------|
| Decisions made | Exploration attempts |
| Key findings | Raw file dumps |
| File paths | Background context |
| Acceptance criteria | Research detours |

### Handoff Summary Template

```markdown
## Handoff: {source} → {target}

### Summary
{2-3 sentences of completed work}

### Key Findings
- {finding 1}
- {finding 2}

### Files Relevant
- `path/to/file.ts` — {brief note}

### Next Steps
{What target agent should do}
```

## Error Handling

### Strategy Matrix

| Strategy | Behavior | When to Use |
|----------|----------|-------------|
| **Fail Fast** | Stop immediately | Critical operations, destructive actions |
| **Retry** | Attempt again (max 2) | Transient failures, API timeouts |
| **Fallback** | Route to error handler | Recoverable errors |
| **Continue** | Log and proceed | Non-critical steps |

### Error Branch Pattern

```yaml
# implementer.agent.md
---
handoffs:
  - label: Implementation Complete
    agent: reviewer
    prompt: "Implementation finished. Please review."

  - label: Debug Issue
    agent: debugger
    prompt: |
      ## Implementation Error

      Error: {ERROR_MESSAGE}
      Last commands: {COMMANDS}
      Relevant files: {FILES}

      Please diagnose and fix.
---

## Error Handling

When encountering errors:

1. **Classify error type**
   - Syntax error → Self-fix, retry
   - Missing dependency → Install, retry
   - Logic error → Debug handoff
   - Unknown → Human escalation

2. **Retry limit: 2 attempts**

3. **On persistent failure:** Use "Debug Issue" handoff
```

## VS Code Constraints

| Constraint | Status | Workaround |
|------------|--------|------------|
| **Sequential subagents** | Current | Subagents run synchronously; use background agents for parallel work |
| **No native DAG editor** | Current | Encode workflows in agent markdown files |
| **One-level depth** | Current | Subagents can't spawn subagents; use orchestrator hub |
| **No conditional syntax** | Current | Agent decides routing via classification instructions |
| **No nested workflows** | Current | Use workflow-as-tool pattern with dedicated agents |

> **Note:** VS Code 1.107 (December 2025) introduced background agents with Git worktree isolation for parallel work. Subagents (`#runSubagent`) remain synchronous but provide context isolation. Check [VS Code Release Notes](https://code.visualstudio.com/updates) for latest capabilities.

## Architecture Selection Guide

| Scenario | Architecture | Why |
|----------|--------------|-----|
| Linear dependencies | Serial | Each step needs previous output |
| Independent tasks | Parallel | True parallel with 1.107+; speed, no dependencies |
| Different expertise needed | Branch | Route to specialists |
| Quality improvement | Loop | Iterative refinement |
| Reusable components | Nested | DRY, encapsulation |
| Heavy parallel workloads | Background Agents | Git worktree isolation prevents conflicts |
| Complex multi-step | Hybrid | Combine patterns |

## Related

- [handoffs-and-chains](handoffs-and-chains.md) — Sequential chain configuration
- [conditional-routing](conditional-routing.md) — Task classification logic
- [subagent-isolation](../CONTEXT-ENGINEERING/subagent-isolation.md) — Parallel execution mechanics
- [task-tracking](task-tracking.md) — Dependency graphs for orchestration
- [research-plan-implement](research-plan-implement.md) — Three-phase serial workflow
- [approval-gates](../CHECKPOINTS/approval-gates.md) — Human checkpoints in workflows

## Sources

- [VS Code 1.107 Release Notes](https://code.visualstudio.com/updates/v1_107) — Parallel subagents, background agents, Agent HQ
- [GitHub Mission Control](https://github.blog/ai-and-ml/github-copilot/how-to-orchestrate-agents-using-mission-control/) — Cross-platform agent orchestration
- [Dify Workflow Documentation](https://docs.dify.ai/en/guides/workflow) — DAG-based workflow patterns
- [Agentic Workflows: Emerging Architectures](https://www.vellum.ai/blog/agentic-workflows-emerging-architectures-and-design-patterns)
- [LangGraph Orchestration](https://langchain-ai.github.io/langgraph/) — State machine workflow pattern
- [CrewAI Documentation](https://docs.crewai.com/) — Role-based agent crews
- [AutoGen Teams](https://microsoft.github.io/autogen/) — Event-driven team coordination
- [steveyegge/beads](https://github.com/steveyegge/beads) — Dependency graph patterns
- [HumanLayer 12-Factor Agents](https://github.com/humanlayer/12-factor-agents)
