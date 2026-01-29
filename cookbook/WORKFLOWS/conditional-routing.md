---
when:
  - routing tasks to specialist agents
  - building orchestrator agents
  - classifying user intent
  - designing multi-agent workflows
pairs-with:
  - handoffs-and-chains
  - workflow-orchestration
  - subagent-isolation
requires:
  - multi-agent
complexity: high
---

# Conditional Routing

Route tasks to specialist agents based on classification. Since VS Code doesn't have native conditional syntax, agents analyze requests and present appropriate handoff options—the "agent decides" pattern.

> **Architecture Constraint:** Hub-and-spoke only. The orchestrator routes to specialists, but subagents cannot spawn other subagents—all delegation flows through the main agent. Source: [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

## Classification Strategies

### 1. Keyword Matching

Simple pattern matching for clear-cut cases:

```markdown
## Routing Rules

Analyze the user request and route based on keywords:

| Keywords | Route To |
|----------|----------|
| "implement", "build", "create", "add", "fix" | @implementer |
| "review", "check", "audit", "PR", "analyze" | @reviewer |
| "document", "explain", "describe", "README" | @documenter |
| "test", "coverage", "spec", "assertion" | @tester |
| "deploy", "release", "publish", "CI/CD" | @devops |

Present only the matching handoff button(s).
```

### 2. Intent Detection

For ambiguous requests, classify intent first:

```markdown
## Intent Classification

Before routing, determine the primary intent:

### Question Types
| Type | Indicators | Response |
|------|------------|----------|
| **Informational** | "what is", "how does", "explain" | Answer directly or route to documenter |
| **Actionable** | "create", "fix", "implement" | Route to implementer |
| **Evaluative** | "review", "is this correct", "check" | Route to reviewer |
| **Exploratory** | "could we", "what if", "options for" | Route to researcher |

### Classification Process
1. Identify primary verb/action
2. Check for domain-specific terms
3. Assess complexity (single task vs multi-step)
4. Route to specialist or handle directly
```

### 3. Complexity Scoring

Route based on task complexity (tool usage as proxy):

| Level | Tool Usage | When to Apply |
|-------|------------|---------------|
| **Never Search** | 0 tools | Stable info: code help, concepts, math, syntax |
| **Offer to Search** | 0 + offer | Annual updates, known entities |
| **Single Search** | 1 tool | Real-time data, unknown terms, single lookup |
| **Research** | 2-20 tools | Multi-source analysis, comprehensive tasks |

```markdown
## Complexity-Based Routing

### Simple (handle directly)
- Syntax questions
- Concept explanations
- Single-line fixes

### Moderate (single specialist)
- File modifications
- Feature additions
- Bug fixes with clear scope

### Complex (orchestrated workflow)
- Cross-cutting changes
- New feature development
- Architecture decisions

### Research (subagent fan-out)
- Unknown codebase exploration
- Technology evaluation
- Root cause analysis
```

### 4. Model Routing

<!-- CORRECTED 2026-01-25: Updated model names to current VS Code models per official docs -->

Route to appropriate model based on task complexity. VS Code's "Auto" mode automatically selects from available models to optimize performance.

> **Platform Note:** Auto model selection currently chooses between Claude Sonnet 4, GPT-5, GPT-5 mini and other models. Agent mode is limited to models with tool-calling support. Source: [VS Code Language Models](https://code.visualstudio.com/docs/copilot/customization/language-models#_auto-model-selection)

| Task Type | Model Selection | Rationale |
|-----------|----------------|------------|
| Simple queries | Auto (fast models) | Quick response, cost-effective |
| Standard coding | Auto or Claude Sonnet 4 | Balanced performance |
| Complex reasoning | Explicit model selection | Maximum intelligence for architecture |
| High-volume tasks | Auto | Rate limit optimization |

```markdown
## Model Selection Routing

For incoming requests:
- Quick syntax help → Let Auto select (fast, cost-effective)
- Standard coding tasks → Auto or specified model (balanced)
- Complex architecture decisions → Explicit model in agent frontmatter
- Rate-limited scenarios → Auto handles fallback automatically

Use the `model` field in custom agent frontmatter to specify a model:
```yaml
model: claude-sonnet-4
```
```

> **Tip:** VS Code's "Auto" mode automatically selects the best available model, detects degraded performance, and applies multiplier discounts for paid users.

## VS Code Implementation

VS Code doesn't support `condition:` syntax in handoffs. The agent must classify and present options:

### Classifier Agent Pattern

**classifier.agent.md:**
```yaml
---
name: task-classifier
description: Analyzes requests and routes to specialists
infer: true  # Allow this agent to be used as subagent (default is true)

handoffs:
  - label: Implement Feature
    agent: implementer
    prompt: "Implement the following feature."
    send: false  # Human reviews before sending (default is false)

  - label: Review Code
    agent: reviewer
    prompt: "Review the following code."
    # send: false is default — omitted for brevity

  - label: Write Documentation
    agent: documenter
    prompt: "Document the following."
    send: true  # Auto-submit (lower risk)

  - label: Research Topic
    agent: researcher
    prompt: "Research the following topic."
    # send: false is default
---

# Task Classifier

## Classification Protocol

1. **Parse request** — Extract action verbs and domain terms
2. **Match patterns** — Check against routing rules
3. **Assess complexity** — Simple/Moderate/Complex/Research
4. **Present options** — Show only relevant handoff buttons

## Routing Rules

| Pattern | Classification | Handoff |
|---------|---------------|---------|
| Contains "implement/build/create/fix" + code terms | Implementation | → Implement Feature |
| Contains "review/check/audit" OR mentions PR | Review | → Review Code |
| Contains "document/explain" OR asks "what is" | Documentation | → Write Documentation |
| Contains "investigate/explore" OR "why does" | Research | → Research Topic |
| Ambiguous | Multiple | Present all matching options |

## Ambiguity Handling

When request matches multiple categories:
1. Present all matching handoff buttons
2. Add brief description of each option
3. Let user choose

When no clear match:
1. Ask clarifying question
2. Default to Research if exploratory
3. Default to Implementation if actionable
```

### Handoff Configuration Reference

<!-- ADDED 2026-01-25: Explicit documentation of handoff defaults per official docs -->

| Property | Required | Default | Description |
|----------|----------|---------|-------------|
| `label` | Yes | — | Button text shown to user |
| `agent` | Yes | — | Target agent name (without @) |
| `prompt` | No | — | Pre-filled prompt for target agent |
| `send` | No | `false` | If `true`, auto-submits; if `false`, user reviews first |

Source: [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_header-optional)

### Self-Routing Agent Pattern

For simple routing, an agent can decide internally without handoffs:

```markdown
## Self-Routing Protocol

Based on the request type, I will:

### For Implementation Requests
1. Gather requirements
2. Create implementation plan
3. Execute changes
4. Verify with tests

### For Review Requests
1. Analyze code structure
2. Check for issues
3. Provide findings with line references
4. Suggest improvements

### For Documentation Requests
1. Understand the component
2. Write clear explanation
3. Include usage examples
4. Format appropriately

### For Research Requests
1. Use #runSubagent for exploration
2. Synthesize findings
3. Present options with tradeoffs
```

## Priority Routing

Route based on urgency and impact:

### Priority Matrix

| Urgency | Low Impact | High Impact |
|---------|------------|-------------|
| **High** | Fast-track to specialist | Immediate + escalate |
| **Low** | Queue for batch | Schedule for focused work |

### Priority Keywords

```markdown
## Priority Detection

### High Priority Indicators
- "urgent", "critical", "blocking", "production"
- "ASAP", "immediately", "broken"
- Mentions incident, outage, or deadline

### Discovery-Based Priority

When agents discover issues during work, classify by blocking potential:

| Priority | Description | Routing Action |
|----------|-------------|----------------|
| **P0** | Blocks all work (security vulnerability, data loss risk) | Stop immediately, escalate to human |
| **P1** | Blocks this track (missing dependency, broken contract) | Pause current task, route to specialist |
| **P2-P4** | Non-blocking issues | Log discovery, continue current work |

### Standard Priority
- Normal feature requests
- Routine maintenance
- Documentation updates

### Routing Behavior
- High priority: Single specialist, immediate attention
- Standard: May batch or queue
```

## Mode-Based Routing (RIPER Pattern)

Alternative to task-type classification—route by *mode* with strict boundaries:

| Mode | Symbol | Allowed Actions | Routing Command |
|------|--------|-----------------|-----------------|
| **Research** | 🔍 | Read files, ask questions, observe | `/research` or `/r` |
| **Innovate** | 💡 | Suggest ideas, explore options | `/innovate` or `/i` |
| **Plan** | 📝 | Create specs, sequence steps | `/plan` or `/p` |
| **Execute** | ⚙️ | Implement code, follow approved plan | `/execute` or `/e` |
| **Review** | 🔎 | Validate output, verify against plan | `/review` or `/rev` |

```markdown
## Mode-Based Routing Rules

1. Declare current mode before ANY response: `[MODE: RESEARCH 🔍]`
2. Cannot change modes without explicit user permission
3. Cannot perform actions outside current mode's allowed actions
4. Default mode is RESEARCH if no mode specified

## CRUD Permissions by Mode
- Research: Read only ✓
- Innovate: Read + conceptual ideas
- Plan: Read + create plans
- Execute: Full CRUD (with approval)
- Review: Read only ✓
```

## LLM-Powered Classification

For nuanced classification, use structured prompting:

```markdown
## Classification Prompt

Given the user request, classify into exactly one category:

Categories:
- IMPLEMENTATION: Create, modify, or fix code
- REVIEW: Analyze existing code for issues
- DOCUMENTATION: Explain or document code
- RESEARCH: Investigate unknowns, explore options
- QUESTION: Simple informational query (no action needed)

Request: {USER_REQUEST}

Respond with JSON:
{
  "category": "IMPLEMENTATION|REVIEW|DOCUMENTATION|RESEARCH|QUESTION",
  "confidence": 0.0-1.0,
  "reasoning": "Brief explanation"
}
```

### Confidence Thresholds

| Confidence | Action |
|------------|--------|
| ≥ 0.8 | Route immediately |
| 0.5 - 0.8 | Route with clarification offer |
| < 0.5 | Ask clarifying question |

```markdown
## Confidence-Based Routing

After classification:

If confidence >= 0.8:
  → Route to classified specialist

If confidence 0.5-0.8:
  → Route to classified specialist
  → Add: "I've routed this as a {CATEGORY} task. Let me know if you meant something different."

If confidence < 0.5:
  → Ask: "I want to make sure I route this correctly. Are you looking to:
    - Implement/modify code?
    - Review existing code?
    - Document something?
    - Research/investigate?"
```

## Fallback Routes

Handle unclassifiable requests:

```markdown
## Fallback Protocol

When classification fails:

1. **Default to conversation** — Answer directly if possible
2. **Ask for clarification** — One specific question
3. **Route to research** — If exploratory in nature
4. **Escalate to human** — If truly ambiguous

Never:
- Refuse without attempting to help
- Route randomly
- Ask multiple questions at once
```

## Multi-Route Scenarios

Some requests need multiple specialists:

### Sequential Multi-Route

For requests requiring multiple skills:

Example: "Add a feature and document it"

1. Route to @implementer first
2. On completion, use `send: false` to show handoff button
3. User clicks to hand off to @documenter
4. Pass implementation summary as context

```yaml
# In implementer.agent.md
handoffs:
  - label: Document This Feature
    agent: documenter
    prompt: "Document the feature we just implemented."
    send: false  # Human gate before documentation
```

### Subagent Delegation (Sequential, Not Parallel)

<!-- CORRECTED 2026-01-25: Subagents are NOT parallel per official docs -->

> **Important:** Subagents do NOT run in parallel. They run sequentially—each subagent completes before the next starts. Subagents operate autonomously without pausing for user feedback, but they don't run asynchronously or in the background. Source: [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

For delegating work to subagents:

Example: "Review the auth module and the API module"

1. Main agent invokes runSubagent for auth module review → waits for completion
2. Main agent invokes runSubagent for API module review → waits for completion  
3. Main agent aggregates findings
4. Present unified report

**Subagent characteristics:**
- Have their own isolated context window
- Cannot spawn other subagents
- Return only final result to main session
- Run autonomously (no user interaction during execution)
- Run **sequentially** (NOT parallel)

> **Constraint:** Subagents cannot spawn other subagents. All delegation must be orchestrated from the main agent.

### Subagent with Custom Agents (Experimental)

Enable `chat.customAgentInSubagent.enabled` to let subagents use specific custom agents:

```json
{
  "chat.customAgentInSubagent.enabled": true
}
```

**Requirements:**
- Enable `runSubagent` tool in tool picker
- Target agent must have `infer: true` (default) or not set `infer: false`

Source: [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_use-a-custom-agent-with-subagents-experimental)

### Preventing Subagent Usage

To prevent an agent from being used as a subagent, set `infer: false`:

```yaml
---
name: sensitive-agent
description: Should not be invoked as subagent
infer: false  # Prevents subagent invocation
---
```

## Anti-Patterns

| Anti-Pattern | Problem | Instead |
|--------------|---------|---------|
| Routing everything | Unnecessary overhead | Handle simple requests directly |
| Vague classifications | Confuses specialists | Use specific category definitions |
| No default route | Requests get stuck | Always have fallback behavior |
| Asking too many questions | Frustrates users | One clarifying question max |
| Ignoring confidence | Bad routing | Act on confidence levels |
| Peer-to-peer delegation | Architecture violation | Use hub-and-spoke only |
| Nested subagents | Not supported | Orchestrate all delegation from main agent |
| Expecting parallel subagents | Subagents run sequentially | Design for sequential execution |
| No human gates on high-risk routes | Dangerous actions proceed | Use `send: false` for implementation/deployment |

## Related

- [workflow-orchestration](workflow-orchestration.md) — Branch architecture patterns
- [handoffs-and-chains](handoffs-and-chains.md) — Handoff configuration syntax
- [subagent-isolation](../CONTEXT-ENGINEERING/subagent-isolation.md) — When to use subagent vs handoff
- [agent-file-format](../CONFIGURATION/agent-file-format.md) — Agent configuration reference
- [spec-driven](spec-driven.md) — Classify before planning
- [riper-modes](riper-modes.md) — Mode-based routing in detail

## Sources

**Official Documentation:**
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — Handoffs, infer field, agent configuration
- [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) — Subagent invocation, context isolation, sequential execution
- [VS Code Language Models](https://code.visualstudio.com/docs/copilot/customization/language-models) — Auto model selection, available models

**Community Patterns:**
<!-- NOT IN OFFICIAL DOCS: Classification strategies and RIPER are community patterns - flagged 2026-01-25 -->
- [Dify Question Classifier](https://docs.dify.ai/en/guides/workflow/node/question-classifier) — LLM-powered classification pattern
- [Dify Workflow Documentation](https://docs.dify.ai/en/guides/workflow) — DAG workflow patterns
- [System Prompts Analysis](https://github.com/asgeirtj/system_prompts_leaks) — Query complexity routing
- [CursorRIPER](https://github.com/johnpeterman72/CursorRIPER) — Mode-based routing pattern
