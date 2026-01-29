---
when:
  - preventing unintended AI modifications
  - enforcing strict permission boundaries
  - building conservative agent workflows
  - tempering over-enthusiastic agent behavior
pairs-with:
  - permission-levels
  - approval-gates
  - destructive-ops
  - iron-law-discipline
requires:
  - none
complexity: medium
---

# RIPER Modes

A 5-mode operational framework that prevents AI agents from making unintended modifications by enforcing strict mode declarations before any action. Use RIPER to temper "over-enthusiastic" AI behavior and maintain clear permission boundaries.

> **Platform Note:** RIPER is a **community pattern**, not a native VS Code feature. It's implemented using VS Code's [custom agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents), [prompt files](https://code.visualstudio.com/docs/copilot/customization/prompt-files), and prompt engineering. The "modes" require manual mode declaration in prompts or switching between custom agents.

**Community Adoption:** 500+ combined GitHub stars across CursorRIPER variants, 46K+ views and 300+ likes on original Cursor forum post. Adaptations exist for Cursor, Claude Code, VS Code Copilot, and Roo Code.

## The 5 Modes

```
┌──────────────────────────────────────────────────────────────────┐
│  R - RESEARCH     🔍  Information gathering, read-only          │
│  I - INNOVATE     💡  Brainstorm solutions, no implementation   │
│  P - PLAN         📝  Create detailed specs, no code changes    │
│  E - EXECUTE      ⚙️  Implement ONLY what's in approved plan    │
│  R - REVIEW       🔎  Validate against plan, identify gaps      │
└──────────────────────────────────────────────────────────────────┘
```

## Permission Matrix

Each mode has explicit allowed and forbidden actions:

| Mode | Read | Create | Update | Delete | Description |
|------|------|--------|--------|--------|-------------|
| **Research** | ✅ | ❌ | ❌ | ❌ | Information gathering only |
| **Innovate** | ✅ | 💭 | ❌ | ❌ | Conceptual (ideas, not files) |
| **Plan** | ✅ | ✅ | 💭 | ❌ | Create specs, not code |
| **Execute** | ✅ | ✅ | ✅ | 💭 | Full CRUD per approved plan |
| **Review** | ✅ | ❌ | ❌ | ❌ | Validation, read-only |

Legend: ✅ = Allowed, ❌ = Forbidden, 💭 = Limited/Conceptual

## Mode Definitions

### Research Mode (🔍)

```markdown
## Purpose
Gather information and understand existing code

## Allowed Actions
- Read files
- Analyze code structure
- Search codebase
- Ask clarifying questions

## Forbidden Actions
- Modify any files
- Suggest implementations
- Make changes

## Output Format
"Based on my research, I found..."
"The current implementation shows..."
```

### Innovate Mode (💡)

```markdown
## Purpose
Brainstorm potential approaches and solutions

## Allowed Actions
- Propose multiple solutions
- Discuss trade-offs
- Explore alternatives
- Think creatively

## Forbidden Actions
- Write actual code
- Modify files
- Make final decisions

## Output Format
"Option 1: [approach] - Pros: ... Cons: ..."
"Option 2: [approach] - Pros: ... Cons: ..."
```

### Plan Mode (📝)

```markdown
## Purpose
Create detailed technical specifications

## Allowed Actions
- Write detailed implementation plans
- Specify exact file changes
- Define testing approach
- Create step-by-step instructions

## Forbidden Actions
- Implement any code
- Modify files
- Skip steps

## Output Format
"## Implementation Plan
### Step 1: [description]
- File: [path]
- Changes: [specific modifications]
- Test: [verification method]"
```

### Execute Mode (⚙️)

```markdown
## Purpose
Implement the approved plan

## Allowed Actions
- Make code changes AS SPECIFIED in plan
- Run tests
- Fix issues found during implementation

## Forbidden Actions
- Deviate from plan without approval
- Add unplanned features
- Skip verification steps

## Output Format
"Implementing Step 1 as planned..."
"Step 1 complete. Running tests..."
```

### Review Mode (🔎)

```markdown
## Purpose
Validate implementation against the plan

## Allowed Actions
- Compare implementation to plan
- Identify discrepancies
- Check test coverage
- Suggest improvements for next cycle

## Forbidden Actions
- Make code changes
- Modify files

## Output Format
"Reviewing Step 1:
- ✅ Matches plan: [aspect]
- ❌ Deviation: [issue]
- 📝 Suggestion: [improvement]"
```

## The Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                      RIPER WORKFLOW                              │
│  (Cyclic process for ongoing development)                        │
│                                                                  │
│        ┌──→ Research ──→ Innovate ──→ Plan ──┐                  │
│        │                                      ↓                  │
│        └──── Review ←──────────────── Execute                   │
└─────────────────────────────────────────────────────────────────┘
```

Cycle through modes as needed. Return to Research when starting new work.

## Mode Commands

Transition between modes with explicit commands:

```
/start             - Initialize project (START phase, creates memory bank)
/research (or /r)  - Enter Research mode
/innovate (or /i)  - Enter Innovate mode
/plan (or /p)      - Enter Plan mode
/execute (or /e)   - Enter Execute mode
/review (or /rev)  - Enter Review mode
```

> **VS Code Implementation:** These slash commands require `.prompt.md` files in `.github/prompts/`. Create `research.prompt.md`, `plan.prompt.md`, etc. to enable `/research`, `/plan` commands. Alternatively, create separate `.agent.md` files and use [handoffs](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs) for guided transitions between modes.

> **Note:** The original RIPER protocol used verbose commands like "ENTER RESEARCH MODE". The shorthand `/r`, `/i`, etc. was introduced by CursorRIPER for convenience.

## Project Phases vs Modes

CursorRIPER distinguishes between **Project Phases** (lifecycle) and **RIPER Modes** (workflow discipline):

| Concept | Purpose | Values |
|---------|---------|--------|
| **Project Phase** | Where is the project in its lifecycle? | UNINITIATED → INITIALIZING → DEVELOPMENT → MAINTENANCE |
| **RIPER Mode** | What type of work is happening now? | Research → Innovate → Plan → Execute → Review |

The `/start` command transitions from UNINITIATED → INITIALIZING, creating the memory bank before development begins.

## Custom Instructions Template

Add to your agent or instruction files:

```markdown
# RIPER-5 Mode System

You are an AI assistant operating under the RIPER-5 framework.

## CRITICAL RULES
1. You MUST declare your current mode before ANY response
2. You CANNOT change modes without explicit user permission
3. You CANNOT perform actions outside your current mode's allowed actions
4. Default mode is RESEARCH if no mode is specified

## Mode Declaration Format
Always start responses with:

[MODE: RESEARCH 🔍]

## Mode Transition
To change modes, user must explicitly say:
- "/research" or "/r"
- "/innovate" or "/i"
- "/plan" or "/p"
- "/execute" or "/e"
- "/review" or "/rev"

## Permission Enforcement
Before ANY action, verify:
1. What mode am I in?
2. Is this action allowed in this mode?
3. If not allowed, state: "This action requires [MODE] mode. Switch with /[mode]"
```

## Memory Bank Integration

<!-- NOT IN OFFICIAL DOCS: Memory bank pattern - flagged 2026-01-25 -->
> **Community Pattern:** The memory bank (`.github/memory-bank/`) is a community pattern from [Cline](https://github.com/cline/cline), not a native VS Code feature. See [memory-bank-schema](../CONFIGURATION/memory-bank-schema.md) for implementation details. For native memory, consider [GitHub Copilot Memories](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) (public preview).

RIPER modes trigger memory bank updates:

| Mode Transition | Memory Files to Update |
|-----------------|------------------------|
| `/start` (initialization) | Create all 6 memory files |
| Any mode transition | `activeContext.md` (current mode, focus) |
| Research complete | `systemPatterns.md` (if patterns discovered) |
| After Execute | `progress.md`, `activeContext.md` |
| After Review | `progress.md`, `systemPatterns.md` |

### Memory Bank Files

CursorRIPER maintains 6 memory files:

| File | Updated By | Purpose |
|------|------------|---------|
| `projectbrief.md` | START phase | Core requirements, scope |
| `productContext.md` | START phase | Why the project exists |
| `techContext.md` | START phase | Technology stack, constraints |
| `systemPatterns.md` | Research, Review | Discovered patterns, architecture |
| `activeContext.md` | Every mode transition | Current focus, recent changes |
| `progress.md` | Execute, Review | What's done, what's next |

## Protection Levels (Advanced)

CursorRIPER.sigma adds code protection annotations that work alongside RIPER modes:

| Level | Marker | Behavior |
|-------|--------|----------|
| PROTECTED | `!cp` | Do not modify under any circumstances |
| GUARDED | `!cg` | Ask before modifying |
| INFO | `!ci` | Context note for understanding |
| DEBUG | `!cd` | Debugging code (can be removed) |
| TEST | `!ct` | Testing code |
| CRITICAL | `!cc` | Business logic (extra caution) |

Use in code comments to mark sensitive regions:

```javascript
// !cp - Authentication core, do not modify
function verifyToken(token) { ... }

// !cg - Rate limiter, ask before changing thresholds
const RATE_LIMIT = 100;
```

## CRUD Permission Matrix (Symbolic)

The CursorRIPER.sigma variant uses precise symbolic notation:

```
ℙ(Ω₁) = {R: ✓, C: ✗, U: ✗, D: ✗}  // Research: Read-only
ℙ(Ω₂) = {R: ✓, C: ~, U: ✗, D: ✗}  // Innovate: Conceptual only
ℙ(Ω₃) = {R: ✓, C: ✓, U: ~, D: ✗}  // Plan: Create specs
ℙ(Ω₄) = {R: ✓, C: ✓, U: ✓, D: ~}  // Execute: Full CRUD
ℙ(Ω₅) = {R: ✓, C: ✗, U: ✗, D: ✗}  // Review: Read-only
```

Legend: `✓` = Allowed, `✗` = Forbidden, `~` = Limited/Conditional

## Native VS Code Alternatives

VS Code provides native features that support RIPER-like workflows:

| RIPER Mode | VS Code Native Equivalent |
|------------|---------------------------|
| **Research** | Use `@workspace` or custom agent with read-only tools: `search`, `usages`, `codebase`, `fetch` |
| **Innovate** | No direct equivalent — use instructions to request brainstorming without implementation |
| **Plan** | Built-in [Plan agent](https://code.visualstudio.com/docs/copilot/chat/chat-planning) (`@plan`) creates markdown plans with read-only tools |
| **Execute** | Default agent (`@agent`) with full tool access |
| **Review** | No direct equivalent — use instructions to request validation without changes |

### Using Handoffs for Mode Transitions

VS Code's [handoffs](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs) enable guided sequential workflows:

```yaml
---
name: riper-research
description: Research phase - read-only exploration
tools: ['search', 'usages', 'codebase', 'fetch', 'githubRepo']
handoffs:
  - agent: riper-plan
    prompt: "Create an implementation plan based on the research findings."
---

You are in RESEARCH mode. Gather information and analyze existing code.
Do NOT suggest implementations or make changes.
```

This creates a "Research" agent that hands off to a "Plan" agent with a pre-filled prompt.

Source: [VS Code Custom Agents - Handoffs](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs)

## RIPER vs Research-Plan-Implement

| Aspect | RIPER (5 modes) | R→P→I (3 phases) |
|--------|-----------------|------------------|
| **Granularity** | Finer (5 distinct modes) | Coarser (3 phases) |
| **Brainstorming** | Explicit Innovate mode | Part of Research |
| **Validation** | Explicit Review mode | Part of Implement |
| **Permission control** | Strict per-mode | Phase-level |
| **Best for** | Preventing over-action | Context compaction |
| **Human review** | Mode transitions | Phase boundaries |

**When to use which:**
- Use RIPER when you need strict permission boundaries
- Use R→P→I when context compaction is primary concern
- Combine both: R→P→I phases with RIPER discipline within Execute

## Agent Configuration

Configure an agent that enforces RIPER:

```yaml
---
name: riper-agent
description: Development assistant with RIPER mode discipline
tools: ["*"]
---

# RIPER Development Agent

You operate under the RIPER-5 framework.

## Mode System
- Default mode: RESEARCH
- Declare mode at start of EVERY response
- Never change modes without user command

## Permission Matrix
| Mode | Can Read | Can Create | Can Modify | Can Delete |
|------|----------|------------|------------|------------|
| Research | ✅ | ❌ | ❌ | ❌ |
| Innovate | ✅ | ❌ | ❌ | ❌ |
| Plan | ✅ | ✅ (specs) | ❌ | ❌ |
| Execute | ✅ | ✅ | ✅ | ✅ |
| Review | ✅ | ❌ | ❌ | ❌ |

## Mode Commands
- /r or /research → Research mode
- /i or /innovate → Innovate mode
- /p or /plan → Plan mode
- /e or /execute → Execute mode
- /rev or /review → Review mode

If asked to perform action outside current mode permissions:
"This requires [MODE] mode. Current mode: [CURRENT]. Switch with /[mode] to proceed."
```

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| Agent modifies files in Research | Mode not enforced | Add explicit permission matrix to instructions |
| Skipping Innovate mode | Rushing to solution | Require at least 2 options before Plan |
| Execute deviates from plan | Plan too vague | Return to Plan mode, add specifics |
| Review finds many gaps | Insufficient planning | More thorough Plan phase next cycle |

## Related

- [research-plan-implement](research-plan-implement.md) — 3-phase alternative workflow
- [spec-driven](spec-driven.md) — "What to build" before RIPER's "how to work"
- [permission-levels](../CHECKPOINTS/permission-levels.md) — Approval model for operations
- [verification-gates](../PATTERNS/verification-gates.md) — Evidence-before-claims protocol
- [iron-law-discipline](../PATTERNS/iron-law-discipline.md) — Discipline enforcement pattern
- [memory-bank-schema](../CONFIGURATION/memory-bank-schema.md) — Where RIPER persists state
- [compaction-patterns](../CONTEXT-ENGINEERING/compaction-patterns.md) — Mode transitions as compaction triggers

## Sources

### Community Sources (RIPER Framework)
- [Original RIPER-5 by robotlovehuman](https://forum.cursor.com/t/i-created-an-amazing-mode-called-riper-5-mode-fixes-claude-3-7-drastically/65516) — Original Cursor forum post (March 2025)
- [CursorRIPER](https://github.com/johnpeterman72/CursorRIPER) — Main framework repository (294+ stars)
- [CursorRIPER.sigma](https://github.com/johnpeterman72/CursorRIPER.sigma) — Symbolic/compressed variant (206+ stars)
- [RIPER Workflow Guide](https://github.com/johnpeterman72/CursorRIPER/blob/main/docs/riper-workflow-guide.md) — Detailed mode documentation

### Official VS Code Documentation
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — Agent file format, handoffs, tool restrictions
- [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) — Creating custom slash commands
- [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning) — Native Plan agent
- [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools) — Available tools and tool sets
