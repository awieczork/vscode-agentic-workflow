---
when:
  - configuring agent-to-agent transitions
  - building sequential agent workflows
  - designing review/approval chains
  - passing work between specialist agents
pairs-with:
  - conditional-routing
  - workflow-orchestration
  - agent-file-format
  - session-handoff
requires:
  - multi-agent
complexity: high
---

# Handoffs and Chains

Configure agent-to-agent transitions for sequential workflows. Use handoffs when passing work to a specialist agent who completes independently (vs `#runSubagent` which returns results to the parent).

> **Platform Note:** The `handoffs:` property is **VS Code/IDE-specific**. GitHub.com's Copilot coding agent ignores this property for compatibility. Cloud-based agents use different orchestration mechanisms.

## Subagents vs Handoffs

| Mechanism | Context Model | Use Case |
|-----------|---------------|----------|
| `#runSubagent` | Inline, returns to parent | One-off exploration, research |
| `handoffs:` | New session (original archived), doesn't return | Sequential workflow transitions |

> **Official:** "VS Code creates a new agent session when you hand off, carrying over the full conversation history and context. The original session is archived after handoff." — [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview#_hand-off-a-session-to-another-agent)

**Rule:** Use `#runSubagent` when you need results back. Use handoffs when the target agent completes the workflow independently.

> **Note:** Using custom agents as subagents requires enabling `chat.customAgentInSubagent.enabled` (experimental). Set `infer: false` in an agent's frontmatter to prevent it from being used as a subagent.

## Handoff Configuration

Configure handoffs in the YAML frontmatter of `.agent.md`:

```yaml
---
name: research-agent
description: Deep research before implementation

handoffs:
  - label: Start Planning
    agent: planner
    prompt: "Based on the research findings above, create an implementation plan."
    send: false

  - label: Quick Implementation
    agent: implementer
    prompt: "Implement these findings directly."
    send: true
---
```

### Configuration Fields

| Field | Required | Description |
|-------|----------|-------------|
| `label` | Yes | Button text shown in chat UI |
| `agent` | Yes | Target agent filename (without `.agent.md`) |
| `prompt` | No | Context/instructions passed to target agent |
| `send` | No | `false` (default) = pre-fill for review, `true` = auto-submit |

### Agent Eligibility

Control whether an agent can be invoked as a handoff target or subagent:

```yaml
---
name: sensitive-operations
description: Handles destructive operations
infer: false  # Cannot be used as subagent — must be explicitly invoked
---
```

### The `send` Field

The `send` field controls human review:

| Value | Behavior | Use Case |
|-------|----------|----------|
| `false` (default) | Pre-fills chat, waits for user to send | Human review before proceeding |
| `true` | Auto-submits immediately | Trusted transitions, automation |

**Best Practice:** Default to `send: false` for human-in-the-loop workflows. Use `send: true` only for well-tested, low-risk transitions.

## Chain Patterns

### Linear Chain

Sequential handoffs through specialist agents:

```
researcher → planner → implementer
     ↓           ↓           ↓
 (research)  (planning)  (coding)
     ↓           ↓           ↓
  [REVIEW]   [REVIEW]    [EXECUTE]
```

**researcher.agent.md:**
```yaml
---
name: researcher
description: Deep research and context gathering

handoffs:
  - label: Create Plan
    agent: planner
    prompt: "Create implementation plan from these findings."
    send: false
---
```

**planner.agent.md:**
```yaml
---
name: planner
description: Creates detailed implementation plans

handoffs:
  - label: Implement
    agent: implementer
    prompt: "Implement this plan."
    send: false
---
```

**implementer.agent.md:**
```yaml
---
name: implementer
description: Executes implementation plans
tools: ["read", "edit", "terminal"]
# No handoffs - end of chain
---
```

### Hub-and-Spoke Chain

Central orchestrator dispatches to specialists:

```
                 ┌─────────────┐
                 │ orchestrator│
                 └─────────────┘
                   ↙    ↓    ↘
              ┌────┐ ┌────┐ ┌────┐
              │ A  │ │ B  │ │ C  │
              └────┘ └────┘ └────┘
                 ↘    ↓    ↙
                 ┌─────────────┐
                 │ orchestrator│ (returns)
                 └─────────────┘
```

**orchestrator.agent.md:**
```yaml
---
name: orchestrator
description: Routes tasks to specialist agents

handoffs:
  - label: Research Task
    agent: research-specialist
    prompt: "Research this topic thoroughly."
    send: false

  - label: Code Task
    agent: code-specialist
    prompt: "Implement this feature."
    send: false

  - label: Review Task
    agent: review-specialist
    prompt: "Review this code for issues."
    send: false
---
```

> **Constraint:** Hub-and-spoke is limited to **one-level depth**. Specialists cannot invoke other specialists directly. Subagents cannot spawn subagents. All delegation must flow through the orchestrator.

### Iterative Refinement Loop

Self-referencing handoff until quality threshold:

```
                 ┌─────────┐
                 │ drafter │
                 └─────────┘
                      ↓
                 ┌─────────┐
                 │ reviewer│
                 └─────────┘
                    ↙   ↘
              [PASS]   [NEEDS WORK]
                ↓           ↓
             [DONE]   → drafter (loop)
```

**reviewer.agent.md:**
```yaml
---
name: reviewer
description: Reviews drafts and routes based on quality

handoffs:
  - label: Revise Draft
    agent: drafter
    prompt: "Please address these issues: [ISSUES_LIST]"
    send: false

  - label: Finalize
    agent: finalizer
    prompt: "Quality approved. Finalize for delivery."
    send: false
---
```

**Exit Condition:** Include explicit criteria in the reviewer's instructions:

```markdown
## Review Criteria

Approve (→ Finalize) when:
- All acceptance criteria met
- No critical issues remaining
- Code follows project conventions

Revise (→ Drafter) when:
- Missing required functionality
- Breaking changes detected
- Style violations present

After 3 revision cycles, escalate to human review.
```

## Dependency Types for Chains

<!-- NOT IN OFFICIAL DOCS: Beads dependency notation - flagged 2026-01-25 -->

> **Community Pattern:** This dependency notation is from [Beads](https://github.com/steveyegge/beads), not a native VS Code feature. Use it in your workflow documentation for clarity.

| Type | Meaning | Use Case |
|------|---------|----------|
| `blocks` | A blocks B (B can't start until A done) | Sequential dependencies |
| `related` | A and B are related | Cross-references |
| `parent` | A is parent of B | Epic → Task hierarchy |
| `discovered-from` | B was found while working on A | Bug discovery during feature work |

**In workflow files:**

```markdown
### Step 3.1: Spec Review [blocks: Step 3.2]
Review specification for completeness.

### Step 3.2: Quality Review [blocked-by: Step 3.1]
Review code quality after spec approval.
```

## Conditional Routing Pattern

Route to different agents based on task classification:

```yaml
---
name: task-router
description: Classifies and routes tasks to specialists

handoffs:
  - label: Code Review
    agent: code-review-agent
    prompt: "Review this code for issues."

  - label: Documentation
    agent: documentation-agent
    prompt: "Document this feature."

  - label: Implementation
    agent: implementation-agent
    prompt: "Implement this feature."
---

# Task Router

## Classification Rules

Analyze the user request and select the appropriate handoff:

| Contains | Route To |
|----------|----------|
| "review", "PR", "check" | Code Review |
| "docs", "explain", "document" | Documentation |
| "implement", "build", "create" | Implementation |
```

**Note:** VS Code doesn't have native conditional handoffs. The agent must classify and present the appropriate handoff button(s) based on task analysis.

## Error Handling in Chains

### Retry-Then-Fallback

When an agent fails, define fallback behavior:

```markdown
## Error Handling

If implementation fails:
1. **Retry once** with additional context
2. **Escalate** to debugging-agent if still failing
3. **Report** to user if unrecoverable

Before handoff to debugging-agent, include:
- Error message verbatim
- Last 3 commands executed
- Relevant file paths
```

### Explicit Failure States

```yaml
---
name: implementer

handoffs:
  - label: Debug Issue
    agent: debugger
    prompt: "Implementation hit an error. Debug this issue."
    send: false

  - label: Implementation Complete
    agent: reviewer
    prompt: "Implementation finished. Please review."
    send: false
---
```

### Escalation Configuration

<!-- NOT IN OFFICIAL DOCS: escalation: frontmatter field - flagged 2026-01-25 -->

> **Community Pattern:** The `escalation:` frontmatter field is a **cookbook design pattern**, not a native VS Code feature. Implement escalation logic in your agent's instructions body instead.

**Pattern for instructions body:**

```markdown
## Error Handling

If implementation fails after 2 attempts:
1. Summarize the error and context
2. Use handoff to debugging-agent with error details
3. If unrecoverable, stop and report to user
```

**Using handoffs for escalation:**

```yaml
---
name: implementer
description: Executes implementation plans

handoffs:
  - label: Debug Issue
    agent: debugging-agent
    prompt: "Implementation failed. Debug this issue:"
    send: false
---
```

### GitHub Hooks (GitHub.com Only)

GitHub Copilot's coding agent supports **hooks** — shell commands executed at agent lifecycle events. This provides event-based control similar to escalation patterns:

| Hook Event | Timing | Use Case |
|------------|--------|----------|
| `sessionStart` | When agent session begins | Initialize environment |
| `sessionEnd` | When session completes | Cleanup, logging |
| `userPromptSubmitted` | After user sends prompt | Validation, logging |
| `preToolUse` | Before tool execution | Security checks |
| `postToolUse` | After tool execution | Audit logging |
| `errorOccurred` | When error happens | Error handling, alerts |

> **Platform:** Hooks are configured separately from `.agent.md` files and only available for GitHub.com coding agent. See [GitHub Copilot Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks).

## Context Passing Best Practices

### Structured Handoff Protocol

For complex workflows requiring detailed state transfer, use a structured JSON format (from [agent-architecture-repositories-patterns](../research/agent-architecture-repositories-patterns.md)):

```json
{
  "from_agent": "architect",
  "to_agent": "backend-implementer",
  "timestamp": "2026-01-21T10:30:00Z",
  "completed": {
    "task": "Design API architecture",
    "outputs": {
      "ARCHITECTURE_SUMMARY": "REST API with JWT auth...",
      "API_CONTRACTS": "See api-spec.yaml"
    },
    "files_created": ["docs/api-spec.yaml", "db/schema.sql"]
  },
  "remaining": {
    "task": "Implement REST endpoints",
    "files_to_modify": ["src/routes/", "src/models/"],
    "constraints": ["Use Express.js", "Follow OpenAPI spec"],
    "success_criteria": ["All endpoints return 200", "Tests pass"]
  },
  "context_refs": [
    "docs/api-spec.yaml",
    ".copilot-context/tech-stack.md"
  ]
}
```

Store handoff records in `.copilot-context/handoffs/{timestamp}.json` for audit trail.

### What to Pass in Handoff Prompts

| Include | Exclude |
|---------|---------|
| Summary of findings | Raw file contents |
| Key decisions made | Exploration attempts |
| Specific file paths | General context |
| Acceptance criteria | Background research |

### Prompt Template

```markdown
## Handoff: {source} → {target}

### Summary
{2-3 sentence summary of completed work}

### Key Findings
- {finding 1}
- {finding 2}

### Files Modified/Relevant
- `path/to/file.ts` — {brief description}

### Next Steps
{What the target agent should do}

### Constraints
{Any limitations or requirements carried forward}
```

### Example Handoff Prompt

```yaml
handoffs:
  - label: Implement Plan
    agent: implementer
    prompt: |
      ## Handoff: planner → implementer

      ### Summary
      Created implementation plan for user authentication feature.

      ### Key Decisions
      - Use JWT for session management
      - Store refresh tokens in httpOnly cookies
      - Rate limit to 5 attempts per minute

      ### Files to Create/Modify
      - `src/auth/jwt.ts` — Token generation
      - `src/middleware/auth.ts` — Validation middleware
      - `src/routes/login.ts` — Login endpoint

      ### Acceptance Criteria
      - [ ] Login returns JWT + refresh token
      - [ ] Invalid credentials return 401
      - [ ] Rate limiting enforced
    send: false
```

## Anti-Patterns

| Anti-Pattern | Problem | Instead |
|--------------|---------|---------|
| `send: true` everywhere | Skips human review | Default to `send: false` |
| Passing raw context | Context explosion | Summarize before handoff |
| Deep chain nesting | Hard to debug | Max 3-4 agents in chain |
| No exit criteria | Infinite loops | Define explicit stop conditions |
| Generic prompts | Lost context | Include specific handoff summary |

## Phase Transition Checkpoints

<!-- NOT IN OFFICIAL DOCS: checkpoints: frontmatter field - flagged 2026-01-25 -->

> **Platform Note:** VS Code's [checkpoints feature](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) is a **runtime setting** (`chat.checkpoints.enabled`) that creates file snapshots during chat, not a frontmatter configuration. The pattern below is a **cookbook design pattern** for expressing approval gates in instructions.

**Approval gates via instructions body:**

```markdown
## Phase Transitions

Before transitioning from planning to implementation:
1. Present the complete plan to the user
2. Wait for explicit approval before proceeding
3. Use `send: false` on handoffs for human review

## Destructive Operations

Always ask before: file_delete, config_change, database_migration
```

**Implementation with handoffs:**

```yaml
---
name: planner
description: Creates implementation plans

handoffs:
  - label: Implement Plan
    agent: implementer
    prompt: "Execute this approved plan."
    send: false  # Human approves before handoff
---
```

## Related

- [subagent-isolation](../CONTEXT-ENGINEERING/subagent-isolation.md) — `#runSubagent` for inline research that returns results
- [agent-file-format](../CONFIGURATION/agent-file-format.md) — Full `.agent.md` specification including handoffs
- [workflow-orchestration](workflow-orchestration.md) — Higher-level orchestration patterns
- [conditional-routing](conditional-routing.md) — Task classification routing
- [research-plan-implement](research-plan-implement.md) — Three-phase workflow with phase boundaries
- [session-handoff](../CONTEXT-MEMORY/session-handoff.md) — State preservation across sessions

## Sources

- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — Official handoffs configuration
- [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview) — Session handoff mechanics, `@cli`/`@cloud` delegation
- [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) — Subagent context isolation
- [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) — Runtime checkpoint settings
- [GitHub Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration) — YAML frontmatter reference
- [GitHub Copilot Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks) — Lifecycle hooks for validation/logging
- [Dify Workflow Orchestration](https://docs.dify.ai/en/guides/workflow) — DAG workflow patterns
- [Beads Issue Tracking](https://github.com/steveyegge/beads) — Dependency notation (community pattern)
- [12-Factor Agents](https://github.com/humanlayer/12-factor-agents) — Small, focused agent design
