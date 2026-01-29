---
when:
  - offloading research tasks to isolated context
  - exploring codebase without polluting parent context
  - running parallel investigations
  - managing context during phase transitions
pairs-with:
  - compaction-patterns
  - utilization-targets
  - handoffs-and-chains
  - workflow-orchestration
requires:
  - multi-agent
complexity: medium
---

# Subagent Isolation

Spawn isolated context windows for exploration, research, or parallel tasks without polluting the parent agent's context. The subagent works with fresh context, does the heavy lifting, then returns a concise summary.

*Introduced in VS Code v1.105 (September 2025), now generally available.*

## When to Use Subagents

| Scenario | Why Subagent Helps |
|----------|-------------------|
| **Research tasks** | Load 10k+ tokens internally, return 1-2k summary |
| **Codebase exploration** | Search broadly without cluttering parent context |
| **Parallel investigation** | Multiple independent questions |
| **Phase transitions** | Fresh context for each workflow phase |
| **Uncertain scope** | Let subagent determine what's relevant |

**Impact:** Subagent uses tokens internally but returns only a focused summary. Each subagent gets its own context window. Parent context stays clean for the actual work.

<!-- NOT IN OFFICIAL DOCS: ~156kb context size and ~50 lines recommended output are community guidelines from Ralph Playbook and FIC, not official VS Code documentation - flagged 2026-01-25 -->

## Invocation Methods

| Method | Description | When to Use |
|--------|-------------|-------------|
| **Automatic delegation** | Copilot analyzes task and delegates based on custom agent descriptions | Default behavior — let Copilot decide |
| **Direct name invocation** | Ask using natural language: "use the research subagent to..." | When you need a specific specialist |
| **Explicit `#runSubagent`** | Call the tool directly in prompt | Maximum control over delegation |

> **Note:** Subagents use natural language invocation (not `@agent` syntax). The `@` prefix is for chat participants, not subagent spawning.

Example automatic delegation:
```markdown
Research the authentication patterns in this codebase and summarize the approach.
# Copilot may automatically spawn a subagent based on task complexity
```

Example explicit invocation:
```markdown
Use #runSubagent to research authentication patterns in the codebase.
Return a 50-line summary with file paths and key functions.
```

## Subagents vs Handoffs

| Mechanism | Context Model | Use Case |
|-----------|---------------|----------|
| `#runSubagent` | Inline, returns to parent | One-off exploration, research |
| `handoffs:` | New session, doesn't return | Sequential workflow transitions |

Use `#runSubagent` when you need the results back. Use handoffs when passing work to a specialist who completes independently.

## Request Template

Structure subagent requests for consistent, useful summaries:

```markdown
Use #runSubagent to research [specific topic] in the codebase.

Return a [length]-line summary with:
- Relevant file paths
- Key functions/patterns found
- Current implementation approach
- Recommended next steps

Do NOT return raw file contents.
```

### Example: Authentication Research

```markdown
Use #runSubagent to research authentication patterns in the codebase.

Return a 50-line summary with:
- Relevant file paths
- Key functions
- Current approach
- Security considerations

Do NOT return raw file contents.
```

### Example: API Endpoint Survey

```markdown
Use #runSubagent to survey all API endpoints in src/api/.

Return a structured list:
- Endpoint path and method
- Handler function location
- Authentication required (yes/no)
- Brief purpose

Format as a markdown table.
```

## Hub-and-Spoke Architecture

Subagents follow a strict one-level depth model:

```
             User Request
                  ↓
           ┌─────────────┐
           │ orchestrator│ (ROOT coordinator)
           └─────────────┘
             ↙  ↓  ↓  ↘
      analyst planner implementer qa
             ↖  ↑  ↑  ↗
           (returns results)
```

## Critical Constraints

| Constraint | Status | Implication |
|------------|--------|-------------|
| **No nesting** | Current | Subagent cannot call `#runSubagent` |
| **No peer delegation** | Current | Specialists cannot invoke other specialists |
| **One-level depth** | Current | Only orchestrator → specialist |
| **Synchronous execution** | By design | Subagents block until complete; no async execution |
| **Tool inheritance** | Current | Subagents inherit parent's tools except `runSubagent` |
| **Model inheritance** | Current | Subagents use same AI model as main session |
| **Local sessions only** | Current | Subagents only supported in local agent sessions |

> **Note:** Subagents don't run asynchronously or in the background. They operate autonomously without user feedback, then return only the final result. VS Code 1.107 added parallel execution for *background agents* (via Git worktrees), not subagents.
>
> Source: [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

## Custom Agents in Subagents (Experimental)

Subagents can use different built-in or custom agents:

```json
// settings.json
{
  "chat.customAgentInSubagent.enabled": true
}
```

With this enabled, subagents can invoke specialized agents:
- Use Plan agent within a subagent for research planning
- Delegate to custom specialist agents using natural language (e.g., "use the docs agent to...")

### Controlling Subagent Eligibility

To prevent a custom agent from being used as a subagent, set `infer: false` in the agent file:

```yaml
---
name: specialist-agent
infer: false  # Excludes from automatic subagent delegation
---
```

Default is `true` — all custom agents are eligible for subagent use unless explicitly disabled.

Source: [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_header-optional)

## Output Handling

Subagent output is ephemeral. For persistence:

1. **Immediate use:** Parent agent processes summary directly
2. **Session persistence:** Write to memory bank for later retrieval
3. **Cross-session:** Store in `decisions.md` or `progress.md`

```markdown
# After subagent returns
Write the research summary to .github/memory-bank/activeContext.md
under the heading "## Authentication Research"
```

## Workflow Integration

### Research → Plan → Implement

```markdown
## Phase 1: Research (via subagent)
Use #runSubagent to analyze the current user management system.
Return: architecture overview, file locations, extension points.

## Phase 2: Plan (parent context)
Based on research summary, create implementation plan.
→ Context is clean, only summary loaded.

## Phase 3: Implement (fresh or compacted)
Execute plan. Compact if needed between major tasks.
```

### Sequential Research Pattern

```markdown
## Multi-System Investigation
I need context on three systems. Dispatch sequentially:

1. #runSubagent: Research payment processing in src/payments/
2. #runSubagent: Research notification system in src/notifications/
3. #runSubagent: Research user preferences in src/settings/

After all three return, synthesize findings into integration plan.
```

> **Note:** Subagents execute synchronously — each completes before the next starts. They don't run asynchronously or in the background. For true parallel execution, use background agents with Git worktree isolation (v1.107+).

## Current Limitations

| Limitation | Status | Workaround |
|------------|--------|------------|
| Synchronous execution | By design | Plan for serial execution; batch related research |
| No nesting | By design | Structure workflows with single orchestrator |
| Local sessions only | Current | Cloud/background agents use different isolation model |
| No direct parent override | By design | Subagent inherits tools except `runSubagent` |

## Related

- [compaction-patterns](compaction-patterns.md) — Subagent summarization as compaction technique
- [utilization-targets](utilization-targets.md) — Why subagent isolation helps maintain 40-60%
- [handoffs-and-chains](../WORKFLOWS/handoffs-and-chains.md) — When to use handoffs instead
- [memory-bank-schema](../CONFIGURATION/memory-bank-schema.md) — Persisting subagent outputs

## Sources

- [VS Code Copilot Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) — Primary documentation on subagents
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — Agent file format, `infer` property
- [VS Code Release Notes v1.105](https://code.visualstudio.com/updates/v1_105) — Feature introduction
- [VS Code Release Notes v1.107](https://code.visualstudio.com/updates/v1_107) — Custom agents in subagents, background agent parallelism
- [GitHub Docs: Asking Copilot Questions](https://docs.github.com/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide) — Subagent invocation methods
- [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview) — Local vs background vs cloud agents
- [VS Code Blog: Unified Agent Experience](https://code.visualstudio.com/blogs/2025/11/03/unified-agent-experience) — Architecture overview
- [Advanced Context Engineering](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents) — FIC research patterns
