---
when:
  - designing agent architecture from scratch
  - evaluating existing agent design quality
  - implementing reliable agent patterns
  - understanding agent design principles
pairs-with:
  - workflow-orchestration
  - memory-bank-files
  - session-handoff
  - approval-gates
  - subagent-isolation
requires:
  - none
complexity: high
---

# 12-Factor Agents

> Universal design principles for building reliable, maintainable AI agents — inspired by the [12-Factor App](https://12factor.net) methodology.

> **Platform Note:** The 12-Factor Agents framework is a **community pattern** from [HumanLayer](https://github.com/humanlayer/12-factor-agents), not native VS Code functionality. Many principles align with official VS Code Copilot features (tool calls, checkpoints, handoffs), while others (memory bank, specific utilization thresholds) are community adaptations. This file maps the framework to VS Code capabilities where applicable.

These principles provide a mental model for agent architecture. In VS Code Copilot, they translate into specific configuration patterns and workflow choices.

## The 12 Factors

| Factor | Principle | VS Code Implementation |
|--------|-----------|------------------------|
| **1** | **Natural Language → Tool Calls** | Agent translates user intent to structured tool invocations |
| **2** | **Own Your Prompts** | Use `.agent.md`, `.instructions.md` — not framework defaults |
| **3** | **Own Your Context Window** | Custom context variables, compaction triggers, JIT retrieval |
| **4** | **Tools Are Structured Outputs** | Tool calls return JSON; parse and validate explicitly |
| **5** | **Unify Execution and Business State** | Memory bank as single source of truth |
| **6** | **Launch/Pause/Resume** | Handoff templates, session continuity, checkpoint files |
| **7** | **Contact Humans with Tool Calls** | Human escalation as first-class tool action |
| **8** | **Own Your Control Flow** | Define workflow in agent file, not surrendered to AI |
| **9** | **Compact Errors into Context** | Errors become context for self-correction |
| **10** | **Small, Focused Agents** | 3-10 steps max per agent |
| **11** | **Trigger from Anywhere** | `@workspace`, `@terminal`, `@github` (built-in); custom agents via dropdown selector |
| **12** | **Stateless Reducer** | Agent = pure function: `(context, event) → next_step` (conceptual model; VS Code sessions persist state) |

### Honorable Mention: Factor 13

**Pre-fetch All Context You Might Need** — Gather context proactively at the start of a task rather than discovering needs mid-execution. Reduces round-trips and prevents the agent from "going dark" while fetching data.

*Source: [Appendix: Factor 13](https://github.com/humanlayer/12-factor-agents/blob/main/content/appendix-13-pre-fetch.md)*

## Key Factors for VS Code Copilot

### Factor 2: Own Your Prompts

Don't rely on default Copilot behavior. Define your prompts explicitly.

```markdown
<!-- .github/agents/implementer.agent.md -->
# Implementer Agent

You implement features following existing patterns.

<instructions>
1. Read spec file completely before starting
2. Follow existing code style exactly
3. Create tests for all new code
4. Never modify files outside scope
</instructions>
```

**Why:** Control over prompts = control over agent behavior. Framework defaults change; your prompts don't.

### Factor 3: Own Your Context Window

Build custom context formats. Don't accept whatever the system provides.

<!-- NOT IN OFFICIAL DOCS: "Dumb zone" terminology and specific 40-60% utilization thresholds are community guidelines (HumanLayer ACE), not official VS Code documentation. VS Code docs only mention that files may use "outline" fallback when "too large to fit" in context window. - flagged 2026-01-25 -->

**The "Dumb Zone" Problem:**
Large context windows (100k+ tokens) show significant recall degradation at 40-60% utilization — the "dumb zone." Models lose track of middle content while over-attending to beginning and end.

> **Community Guideline:** These thresholds come from [HumanLayer ACE](https://github.com/humanlayer/12-factor-agents), not official VS Code documentation. Official docs recommend "start small and iterate" and note context window limits exist but don't specify percentages.

| Utilization | Risk | Recommendation |
|-------------|------|----------------|
| <40% | Low | Optimal zone |
| 40-60% | High | "Dumb zone" — compact proactively |
| >60% | Critical | Compact immediately |

```markdown
<context_management>
- Always load: activeNotebook.md, CONVENTIONS.md
- Load on demand: source files referenced in task
- Compact when: context exceeds 40% utilization (before dumb zone)
- Preserve: decisions, rationale, blockers
- Drop: verbose logs, intermediate drafts, old tool results
</context_management>
```

**Implementation:** See [utilization-targets.md](../CONTEXT-ENGINEERING/utilization-targets.md), [compaction-patterns.md](../CONTEXT-ENGINEERING/compaction-patterns.md).

### Factor 7: Contact Humans with Tool Calls

Human-in-the-loop is a tool, not an afterthought.

```yaml
# When to escalate (not just when blocked)
escalation_triggers:
  - security_implications: true
  - breaking_changes: true
  - confidence_below: 0.5
  - ambiguous_requirements: true
  - production_modifications: true
```

**Pattern:** Treat `request_human_input` as equivalent to `read_file` — a normal tool in the toolkit.

**Implementation:** See [escalation-tree.md](../CHECKPOINTS/escalation-tree.md), [approval-gates.md](../CHECKPOINTS/approval-gates.md).

### Factor 8: Own Your Control Flow

Define workflow phases explicitly. Don't let the AI decide when to proceed.

```markdown
<workflow>
## Phase 1: Research
- Read all referenced files
- Document findings
- GATE: Human approves understanding

## Phase 2: Plan
- Create implementation plan
- List files to modify
- GATE: Human approves plan

## Phase 3: Implement
- Execute plan step by step
- GATE: Human reviews each file
</workflow>
```

**Why:** Surrendering control flow = surrendering predictability. Explicit phases enable checkpoints, rollback, and human oversight.

**Implementation:** See [workflow-orchestration.md](../WORKFLOWS/workflow-orchestration.md), [verification-gates.md](verification-gates.md).

### Factor 10: Small, Focused Agents

Limit each agent to 3-10 steps. Complex tasks get decomposed.

```
❌ "Build the entire feature"
✅ "Research → Plan → Implement components → Integrate → Test"
```

**The WRAP Pattern:**

<!-- NOT IN OFFICIAL DOCS: WRAP (Wholistic, Research, Atomic, Present) is not documented in official VS Code docs. It's a community pattern for task decomposition. - flagged 2026-01-25 -->

| Step | Scope |
|------|-------|
| **W**holistic | Understand full context |
| **R**esearch | Gather all requirements |
| **A**tomic | Single focused change |
| **P**resent | Show work for review |

**Implementation:** See [wrap-task-decomposition.md](../WORKFLOWS/wrap-task-decomposition.md), [subagent-isolation.md](../CONTEXT-ENGINEERING/subagent-isolation.md).

### Factor 12: Stateless Reducer

Each agent step is a pure function: input state + event → output state.

<!-- PLATFORM NOTE: VS Code sessions are actually stateful - "chat sessions are automatically saved, enabling you to continue conversations where you left off." The stateless reducer is a conceptual model from HumanLayer, not how VS Code agent sessions work. - flagged 2026-01-25 -->

```python
# Conceptual model (not VS Code implementation)
def agent_step(context: Context, event: Event) -> NextStep:
    # No hidden state
    # No global variables
    # All information in context
    next_step = llm.determine_next_step(context)
    return next_step
```

> **Platform Note:** VS Code agent sessions maintain state across turns. The Microsoft Agents SDK notes "as with web apps, an agent is inherently stateless" but VS Code implements session persistence. This conceptual model is useful for designing predictable agents but doesn't reflect VS Code's actual session management.

**Implication for Memory:**
- Session state lives in memory bank files, not agent memory
- Each invocation starts fresh, reads state from files
- Output is deterministic given same inputs

**Implementation:** See [memory-bank-files.md](../CONTEXT-MEMORY/memory-bank-files.md), [session-handoff.md](../CONTEXT-MEMORY/session-handoff.md).

## Orchestration Implications

| Factor | Principle | Orchestration Implication |
|--------|-----------|---------------------------|
| **1** | Natural Language → Tool Calls | Agents output structured JSON, not free-form text |
| **6** | Launch/Pause/Resume | Design for asynchronous workflows, human checkpoints |
| **7** | Contact Humans with Tool Calls | Make human escalation a first-class action |
| **8** | Own Your Control Flow | Don't surrender loop control to AI; instrument it |
| **10** | Small, Focused Agents | Break complex workflows into specialized micro-agents |
| **12** | Stateless Reducer | Each agent step = input state + event → output state |

*Adapted from [HumanLayer 12-Factor Agents](https://github.com/humanlayer/12-factor-agents)*

## VS Code Native Features Supporting These Factors

> **Added from official docs validation (2026-01-25):**

| Factor | VS Code Native Feature | Documentation |
|--------|------------------------|---------------|
| 1 | Tool invocation (`#runSubagent`, MCP tools, built-in tools) | [Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools) |
| 6 | Sessions auto-saved, checkpoints for workspace state | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions), [Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) |
| 7 | Tool approval scopes (session/workspace/user), terminal approval | [Security](https://code.visualstudio.com/docs/copilot/security) |
| 8 | Handoffs with `handoffs:` metadata for workflow transitions | [Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs) |
| 10 | Subagents for isolated context, TDD agents pattern | [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) |
| 13 | Custom instructions for project-wide context curation | [Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) |

**Agent Types in VS Code:**
- **Local agents** — Interactive, in VS Code chat
- **Background agents** — CLI-based, well-defined scope tasks
- **Cloud agents** — Remote/team execution

Source: [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview)

## Factor Mapping to Cookbook

| Factor | Primary Cookbook Files |
|--------|------------------------|
| 2, 8 | [agent-file-format.md](../CONFIGURATION/agent-file-format.md), [iron-law-discipline.md](iron-law-discipline.md) |
| 3 | [context-variables.md](../CONTEXT-ENGINEERING/context-variables.md), [compaction-patterns.md](../CONTEXT-ENGINEERING/compaction-patterns.md) |
| 5, 12 | [memory-bank-files.md](../CONTEXT-MEMORY/memory-bank-files.md), [memory-bank-schema.md](../CONFIGURATION/memory-bank-schema.md) |
| 6 | [session-handoff.md](../CONTEXT-MEMORY/session-handoff.md), [handoffs-and-chains.md](../WORKFLOWS/handoffs-and-chains.md) |
| 7 | [permission-levels.md](../CHECKPOINTS/permission-levels.md), [escalation-tree.md](../CHECKPOINTS/escalation-tree.md) |
| 10 | [wrap-task-decomposition.md](../WORKFLOWS/wrap-task-decomposition.md), [subagent-isolation.md](../CONTEXT-ENGINEERING/subagent-isolation.md) |

## The Agent Loop

All factors serve this core loop:

```
context = [initial_event]

while not done:
    next_step = agent_decide(context)      # Factor 1, 2, 12
    context.append(next_step)              # Factor 3, 9

    if needs_human(next_step):             # Factor 7
        result = await human_input()
    else:
        result = execute(next_step)        # Factor 4, 8

    context.append(result)                 # Factor 5
    context = compact_if_needed(context)   # Factor 3
```

## Anti-Patterns

| Factor Violated | Anti-Pattern | Fix |
|-----------------|--------------|-----|
| 2 | Relying on model defaults | Write explicit instructions |
| 3 | Letting context grow unbounded | Set compaction triggers |
| 7 | Waiting until blocked to ask human | Proactive checkpoints |
| 8 | "Just figure it out" prompts | Explicit phase definitions |
| 10 | Monolithic mega-agents | Decompose into specialists |
| 12 | Hidden state between invocations | Persist to memory bank files |

## Related

- [agent-file-format.md](../CONFIGURATION/agent-file-format.md) — Factor 2 implementation
- [compaction-patterns.md](../CONTEXT-ENGINEERING/compaction-patterns.md) — Factor 3 implementation
- [handoffs-and-chains.md](../WORKFLOWS/handoffs-and-chains.md) — Factor 6 implementation
- [escalation-tree.md](../CHECKPOINTS/escalation-tree.md) — Factor 7 implementation
- [iron-law-discipline.md](iron-law-discipline.md) — Factor 8 enforcement
- [wrap-task-decomposition.md](../WORKFLOWS/wrap-task-decomposition.md) — Factor 10 implementation

## Sources

### Community Framework (Primary)
- [12-Factor Agents — HumanLayer](https://github.com/humanlayer/12-factor-agents) — Original framework
- [AI Engineer World's Fair Talk](https://www.youtube.com/watch?v=8kMaTybvDUw) — Video introduction to the 12 factors
- [Factor 13 Appendix: Pre-fetch Context](https://github.com/humanlayer/12-factor-agents/blob/main/content/appendix-13-pre-fetch.md)
- [ghuntley.com/agent](https://ghuntley.com/agent/) — Agent loop patterns

### Official VS Code Docs (Validation)
- [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools) — Factor 1: Tool invocation patterns
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — Factor 2, 8: Agent files and handoffs
- [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) — Factor 2: Instruction files
- [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) — Factor 6, 12: Session persistence
- [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) — Factor 6: Workspace state restoration
- [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) — Factor 10, 13: Context curation
- [VS Code Security](https://code.visualstudio.com/docs/copilot/security) — Factor 7: Tool approval mechanisms
- [Microsoft Agents SDK State](https://learn.microsoft.com/en-us/microsoft-365/agents-sdk/state-concepts) — Factor 12: Stateless design rationale

*Validated against official VS Code documentation: 2026-01-25*
