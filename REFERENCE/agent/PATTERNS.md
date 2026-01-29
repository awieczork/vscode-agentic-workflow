# Agent Patterns

Rules and best practices for `.agent.md` files.

---

## When to Use Agents

Agents are **specialized chat personas** with defined expertise, tools, and behavioral modes.

**Use agents for:**
- Embodying specialized roles (architect, researcher, builder)
- Maintaining consistent behavior across sessions
- Accessing specific tool subsets based on role
- Handing off to other agents in workflows

**Don't use agents for:**
- Portable procedures → use Skills
- Persistent rules without persona → use Instructions  
- One-shot templates → use Prompts

---

## Design Questions

### First: Is This Really an Agent?

Test capabilities in priority order. **Stop at first YES.**

| Capability Test | If YES → | Why Not Agent |
|-----------------|----------|---------------|
| Applies rules to specific files/folders? | **Instruction** | No persona needed, just scoped behavior |
| Reusable procedure any agent could invoke? | **Skill** | Composable capability, not identity |
| One-shot template with variable placeholders? | **Prompt** | Single-use generation, no persistence |
| Needs persona + cross-session consistency + handoffs? | **Agent** | Full autonomous identity justified |

**Rule:** Default to lower-weight artifacts. An Instruction that "feels like an agent" is still an Instruction if it only modifies behavior for specific files.

### Then: Map Questions to Sections

**Principle:** Every design question must have a destination field in the agent file.

| You're Defining... | Answers Go To | Key Considerations |
|--------------------|---------------|-------------------|
| Who is this agent? | `role`, `description` | Persona, expertise, stance |
| What can't it do? | `safety`, `boundaries` | P1 hard limits, ask-first rules |
| What tools does it need? | `tools` (frontmatter) | Principle of least privilege |
| How does behavior vary? | `modes` | Triggers, steps, outputs per mode |
| What does it read first? | `context_loading` | Session start files, conditional files |
| What does it produce? | `outputs` | Formats, naming, locations |
| When does it stop/hand off? | `stopping_rules` | Conditions → target mappings |

**Anti-patterns in design questions:**
- ❌ Questions with no destination field ("What's the vibe?")
- ❌ Same question answered in two sections (handoff in both `boundaries` and `stopping_rules`)
- ❌ Characteristic-based gates ("Does it feel autonomous?")

> **Detailed prompts:** See [TEMPLATE.md](TEMPLATE.md) for section-by-section design prompts.

---

## Required Sections

Every agent needs these three:

**1. Identity** — First paragraph defines who the agent is
- Start with "You are a {role}..."
- Include expertise areas
- Define behavioral stance (curious, precise, thorough)

**2. Safety** — P1 constraints that can't be overridden
- Priority hierarchy (Safety > Clarity > Flexibility > Convenience)
- Hard limits as NEVER statements
- Required behaviors as ALWAYS statements

**3. Boundaries** — Three-tier scope definition
- ✅ **Do:** allowed actions
- ⚠️ **Ask First:** conditional actions
- 🚫 **Don't:** prohibited actions

---

## Recommended Sections ⭐

These make agents significantly more effective:

**context_loading** — What to read at session start
- Ordered file list with priorities
- On-demand triggers for conditional files

**modes** — Behavioral variations
- Each mode: trigger → steps → output
- Clear activation phrases

**outputs** — What the agent produces
- Conversational format
- Deliverable naming conventions

**stopping_rules** — When to hand off
- Condition → target agent mappings
- Prevents scope creep

---

## Reserved Names

These names conflict with VS Code built-ins — don't use them:

| Name | Reason | Source |
|------|--------|--------|
| `ask` | Built-in chat mode | ChatModeKind enum |
| `edit` | Built-in chat mode | ChatModeKind enum |
| `agent` | Built-in chat mode | ChatModeKind enum |
| `plan` | Built-in VS Code agent | Official docs |
| `workspace` | VS Code setup agent | VS Code source |
| `terminal` | VS Code setup agent | VS Code source |
| `vscode` | VS Code setup agent | VS Code source |

**Symptom:** Agent not appearing in `@` menu or unexpected behavior.

---

## Tool Configuration

### Tool Aliases (Official)

Use these portable aliases in `tools:` frontmatter:

| Alias | Maps To | Use For |
|-------|---------|----------|
| `read` | readFile, listDirectory | File reading |
| `edit` | editFiles, createFile | File writing |
| `search` | codebase, textSearch, fileSearch | Code search |
| `execute` | runInTerminal | Shell commands |
| `agent` | runSubagent | Subagent invocation |
| `web` | fetch, WebSearch | Web content (VS Code only) |
| `todo` | TodoWrite | Task lists (VS Code only) |

**Source:** [GitHub Tool Aliases](https://docs.github.com/en/copilot/reference/custom-agents-configuration#tool-aliases)

### Role-Based Tool Sets

Match tools to role (principle of least privilege):

```yaml
planner_researcher: ['read', 'search', 'web']
implementer_builder: ['read', 'edit', 'search', 'execute']
reviewer: ['read', 'search']
orchestrator: ['read', 'search', 'agent']
full_access: ['*']  # only when justified
```

### MCP Tool Syntax

Reference tools from MCP servers using `server/*` or `server/tool`:

```yaml
tools:
  - 'github/*'              # All tools from server
  - 'context7/*'            # Wildcard access
  - 'playwright/navigate'   # Specific tool only
```

**Out-of-box servers:** `github`, `playwright`

### Input Guidance

Use `argument-hint` to prompt user input:

```yaml
argument-hint: 'What would you like me to research?'
```

Shown as placeholder in chat when agent is invoked.

---

## Handoff Behavior

Handoffs create **new sessions** with conversation history carried over.

### The `send` Field

| Value | Behavior | When to Use |
|-------|----------|-------------|
| `false` (default) | Pre-fills prompt, waits for user | Human review needed |
| `true` | Auto-submits immediately | Trusted low-risk transitions |

**Security Rule:** Default to `send: false`. Use `send: true` only for:
- Well-tested, low-risk transitions
- Read-only target agents
- Never for agents with `edit` or `execute` tools

### Common Patterns

| Pattern | Flow | Use Case |
|---------|------|----------|
| Planning → Implementation | `planner` → `build` | Feature development |
| Implementation → Review | `build` → `inspect` | Quality gates |
| Research → Planning | `research` → `architect` | Complex tasks |

### Anti-Patterns

```yaml
- dont: "send: true to agents with edit/execute tools"
  instead: Use send: false for human review
  why: Prevents unreviewed destructive operations

- dont: "Generic prompts like 'Continue'"
  instead: Include specific context summary
  why: Target agent needs relevant state
```

---

## Size Limits

| Limit | Max | Recommended |
|-------|-----|-------------|
| Total characters | 30,000 | ≤25,000 |
| Total lines | 500 | ≤300 |
| Modes | 10 | 3-7 |
| Handoffs | 5 | 2-3 |

---

## Anti-Patterns

```yaml
- dont: "Be helpful and thorough"
  instead: Specific behavioral rules
  why: Vague instructions get ignored

- dont: Role without boundaries
  instead: Always include <boundaries>
  why: Scope creep

- dont: "tools: ['*']" without reason
  instead: Explicit minimal set
  why: Security, focus

- dont: ">300 lines"
  instead: Split into agent + skills
  why: Maintainability

- dont: No stopping rules
  instead: Define handoff triggers
  why: Prevents infinite loops
```

---

## Cross-References

- [README.md](README.md) — Quick start guide
- [TEMPLATE.md][template] — Format and structure
- [CHECKLIST.md][checklist] — Validation checklist
- [TAGS-AGENT.md][tags] — Tag vocabulary

---

## Sources

- [VS Code Custom Agents][vscode-docs] — Official docs
- [GitHub Custom Agents][github-docs] — 30K char limit
- [awesome-copilot agents][awesome] — Community examples

<!-- Reference Links -->
[template]: TEMPLATE.md
[checklist]: CHECKLIST.md
[tags]: TAGS-AGENT.md
[vscode-docs]: https://code.visualstudio.com/docs/copilot/customization/custom-agents
[github-docs]: https://docs.github.com/en/copilot/reference/custom-agents-configuration
[awesome]: https://github.com/github/awesome-copilot/tree/main/agents
