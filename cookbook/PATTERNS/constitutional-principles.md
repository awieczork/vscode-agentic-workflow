---
when:
  - defining inviolable rules for agents
  - establishing security and safety constraints
  - creating project-wide behavioral boundaries
  - preventing agent rationalization of shortcuts
pairs-with:
  - constraint-hierarchy
  - iron-law-discipline
  - iron-law-verification
  - instruction-files
requires:
  - none
complexity: low
---

# Constitutional Principles

> Immutable rules that govern all agent behavior. Principles that cannot be overridden, rationalized away, or compromised for convenience.

> **Platform Note:** VS Code Copilot combines all instruction files into the chat context with **no specific order guaranteed**. The constraint hierarchy described here is a **design pattern** for writing effective instructions, not native platform behavior. When conflicting instructions exist, the LLM decides which to follow. To enforce determinism, avoid conflicting instructions and use clear priority language in your prompts.
>
> *Source: [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)*

Constitutional principles are the non-negotiable foundation of your agent system. They define what the agent **must always do** and **must never do**, regardless of user requests or situational pressure.

## Why Constitutions Matter

Without explicit principles, agents will:
- Rationalize shortcuts under time pressure
- Drift from standards across sessions
- Agree with user requests that violate best practices (sycophancy)
- Find creative interpretations that technically comply but miss the spirit

A constitution makes expectations **explicit and enforceable**.

## Anatomy of a Constitution

A project constitution typically lives in `.github/copilot-instructions.md` or a dedicated `memory/constitution.md` file.

<!-- NOT IN OFFICIAL DOCS: `memory/constitution.md` is a community pattern from Cline Memory Bank, not an official VS Code location. Official locations are: .github/copilot-instructions.md, .github/instructions/*.instructions.md, .github/agents/*.agent.md - flagged 2026-01-25 -->

**Structure:**
```markdown
# Project Constitution

## Inviolable Principles

These rules have NO exceptions. Any request that violates them is refused.

### Security
1. Never commit secrets, tokens, or credentials
2. Never disable security features without security team approval
3. Never expose internal endpoints publicly

### Quality
4. All new code requires tests
5. No skipping type checking
6. No suppressing linter errors without justification

### Process
7. Changes require spec before implementation
8. Breaking changes require migration plan
9. Production changes require approval gate
```

## Constraint Hierarchy

<!-- NOT IN OFFICIAL DOCS: VS Code Copilot does not implement a deterministic constraint hierarchy. The platform combines instructions with "no specific order guaranteed." This section describes a DESIGN PATTERN for writing instructions, not platform behavior. - flagged 2026-01-25 -->

When principles conflict, use this priority order as a **writing guideline** (not enforced by platform):

```
Priority 1: Universal Safety (non-overridable)
├─ Copyright protection
├─ Content safety
├─ Privacy/PII protection
├─ Security requirements
│
Priority 2: Project Constraints
├─ Architectural decisions
├─ Technology choices
├─ Coding standards
│
Priority 3: Behavioral Guidelines
├─ Response formatting
├─ Workflow preferences
├─ Communication style
│
Priority 4: User Preferences
└─ Tone, verbosity, etc.
```

**Important:** This hierarchy is a **design pattern** to help you write non-conflicting instructions. VS Code Copilot does NOT enforce semantic priority between instruction files — it combines them and leaves conflict resolution to the LLM.

**Example Conflict:**
- User requests: "Skip the tests, just ship it"
- Principle: "All new code requires tests"
- Resolution: Principle wins. Agent refuses.

### Hard Constraints vs Contextual Guidelines

<!-- NOT IN OFFICIAL DOCS: "Hard constraints" vs "contextual guidelines" distinction is a design pattern, not a platform feature. VS Code Copilot does not distinguish between constraint types. - flagged 2026-01-25 -->

Not all principles are equal. Distinguish between:

| Type | Behavior | Example |
|------|----------|--------|
| **Hard Constraints** | Cannot be overridden by ANY context | Never expose credentials, never disable auth |
| **Contextual Guidelines** | Can be adjusted based on situation | Code style preferences, documentation depth |
| **Defaults** | Apply unless user explicitly overrides | Response format, verbosity level |

> Hard constraints are absolute. They cannot be rationalized away, user-requested away, or contextually adjusted. — *Anthropic Constitution (Jan 2026)*

## Example Domain Principles

### Security-Focused Project

```markdown
## Security Constitution

1. **Secrets**: Never hardcode credentials. Use environment variables or secret managers.
2. **Dependencies**: Pin all versions. No `latest` tags in production.
3. **Inputs**: Validate and sanitize all user inputs without exception.
4. **Outputs**: Never expose stack traces, internal paths, or system info to users.
5. **Auth**: All endpoints require authentication unless explicitly marked public.
```

### Quality-Focused Project

```markdown
## Quality Constitution

1. **Test-First**: Write tests before implementation (TDD).
2. **Type Safety**: No `any` types. All functions have explicit signatures.
3. **Documentation**: Public APIs require JSDoc/docstrings.
4. **Simplicity**: Functions ≤25 lines. No nested conditionals >2 levels.
5. **Dependencies**: Justify every new dependency. Prefer standard library.
```

### Workflow-Focused Project

```markdown
## Workflow Constitution

1. **Spec-First**: No implementation without approved specification.
2. **Incremental**: Maximum 5 files changed per commit.
3. **Reviewable**: Changes must be understandable in <10 minutes.
4. **Reversible**: Every change has a rollback plan.
5. **Observable**: All operations produce logs sufficient for debugging.
```

## Spec-Kit Constitutional Principles

<!-- NOT IN OFFICIAL DOCS: Spec-Kit is an external CLI toolkit from GitHub (github.com/github/spec-kit), not a native VS Code Copilot feature. Requires separate installation via `uv tool install spec-kit`. - flagged 2026-01-25 -->

GitHub's Spec-Kit suggests these foundational principles:

| Principle | Description |
|-----------|-------------|
| **Library-First** | Features begin as standalone libraries |
| **CLI Interface Mandate** | All libraries expose CLI functionality |
| **Test-First Imperative** | No code before tests |
| **Simplicity Gates** | Maximum 3 projects for initial scope |
| **Anti-Abstraction** | Use frameworks directly, no wrappers |
| **Integration-First Testing** | Real databases over mocks |

## Protection Levels (Code Regions)

<!-- NOT IN OFFICIAL DOCS: Protection level markers (!cp, !cg, etc.) are from CursorRIPER.sigma, not VS Code Copilot. VS Code has no inline code protection markers. Content exclusion exists at org/repo level via settings, not inline comments. - flagged 2026-01-25 -->

For fine-grained control, mark code regions with protection markers:

| Marker | Level | Behavior |
|--------|-------|----------|
| `!cp` | PROTECTED | Do not modify under any circumstances |
| `!cg` | GUARDED | Ask before modifying |
| `!ci` | INFO | Context note for understanding |
| `!cd` | DEBUG | Debugging code (can be removed) |
| `!ct` | TEST | Testing code |
| `!cc` | CRITICAL | Business logic (extra caution) |

**Usage in code:**
```typescript
// !cp - Authentication flow - DO NOT MODIFY
function authenticateUser(token: string): User {
  // ... critical auth logic
}

// !cg - Rate limiting - ask before changes
const RATE_LIMIT = 100; // requests per minute
```

Track protected regions in a `memory/protection.md` file listing what's protected and why.

<!-- NOT IN OFFICIAL DOCS: `memory/protection.md` is from CursorRIPER.sigma, not VS Code Copilot. - flagged 2026-01-25 -->

*Source: [CursorRIPER.sigma](https://github.com/johnpeterman72/CursorRIPER.sigma)*

## Writing Effective Principles

### Use Positive Framing

| ❌ Negative | ✅ Positive |
|-------------|-------------|
| "Don't skip tests" | "Write tests for all new code" |
| "Never use any types" | "Use explicit types for all declarations" |
| "Don't commit broken code" | "Verify all tests pass before committing" |

### Make Them Specific and Measurable

| ❌ Vague | ✅ Specific |
|----------|-------------|
| "Keep functions small" | "Functions ≤25 lines" |
| "Write good documentation" | "Public APIs require JSDoc with @param and @returns" |
| "Handle errors properly" | "Wrap async operations in try-catch with typed errors" |

### Include the "Why"

```markdown
## Principle: No Direct Database Queries in Controllers

**Rule**: Controllers call service methods. Services call repositories. Only repositories execute queries.

**Why**: Enables testing controllers without database. Enables swapping database implementations. Centralizes query optimization.
```

## Enforcement Mechanisms

Principles without enforcement are suggestions. See these patterns:

| Pattern | Purpose |
|---------|---------|
| [Permission Levels](../CHECKPOINTS/permission-levels.md) | 0-3 approval model for operations |
| [Iron Law](iron-law-discipline.md) | Single inviolable rule with Red Flags |
| [Verification Gates](verification-gates.md) | Checkpoints that validate compliance |
| [Red Team](../RED-TEAM/iron-law-verification.md) | Active challenge of decisions |

### Iron Law Verification Checklist

Before accepting agent decisions, verify principles were followed correctly:

| Check | Question |
|-------|----------|
| **Principle-First** | Was a relevant guideline cited BEFORE the decision? |
| **Conflict Detection** | Were ALL relevant principles considered (not just supporting ones)? |
| **Sycophancy Detection** | Would the decision change if user expressed opposite preferences? |
| **Counterfactual Test** | Would a different user get the same output for the same request? |

**Verdict outcomes:**
- ✅ **PASS** — Principles clearly guided decision
- ⚠️ **WARN** — Potential rationalization detected, requires review
- ❌ **FAIL** — Clear violation, decision must be revised

*Source: [obra/superpowers](https://github.com/obra/superpowers), [Anthropic sycophancy research](https://arxiv.org/abs/2411.15287)*

## Deployment Locations

| Location | Scope | When to Use |
|----------|-------|-------------|
| `.github/copilot-instructions.md` | All Copilot interactions | Universal project rules |
| `.github/instructions/*.instructions.md` | Targeted files (via `applyTo` glob) | Context-specific rules |
| `.github/agents/{name}.agent.md` | Single agent | Agent-specific constraints |
| `AGENTS.md` | All agents in workspace | Multi-agent shared rules |
| `memory/constitution.md` | Memory bank | Persistent cross-session rules (community pattern) |

> **Native VS Code Instruction Files:** VS Code officially supports `.github/copilot-instructions.md`, `.github/instructions/*.instructions.md`, `.github/agents/*.agent.md`, and `AGENTS.md`. The `memory/` folder patterns are community conventions (from Cline Memory Bank), not native platform features.
>
> *Source: [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)*

See [instruction-files.md](../CONFIGURATION/instruction-files.md) for file format details.

## How VS Code Handles Instructions

When multiple instruction files exist, VS Code:

1. **Combines all instructions** into the chat context
2. **Does NOT enforce priority** — "no specific order is guaranteed"
3. **Relies on LLM** to resolve any conflicts
4. **Recommends avoiding conflicts** in your instruction design

**Implications for Constitutional Design:**
- Write instructions that don't conflict with each other
- Use clear, absolute language for critical rules ("NEVER", "ALWAYS")
- Don't rely on file location to determine priority
- Test instructions by deliberately trying to violate them

*Source: [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)*

## Platform-Level Safety (GitHub)

GitHub implements a **platform-level safety pipeline** that applies to all Copilot interactions, regardless of your custom instructions:

1. **Input Filtering**: Toxic language, relevance checks, prompt hacking detection
2. **Output Filtering**: Code quality, unique identifiers, public code matching
3. **Content Safety**: Violence, hate speech, self-harm, sexual content blocked
4. **Responsible AI Standard**: Fairness, Reliability, Safety, Privacy, Inclusiveness, Transparency

These platform-level filters operate **above** your custom instructions and cannot be overridden.

*Source: [GitHub Copilot Data Handling](https://resources.github.com/learn/pathways/copilot/essentials/how-github-copilot-handles-data/)*

## Constitutional Review Checklist

Before finalizing a constitution:

- [ ] Each principle is specific and measurable
- [ ] Principles use positive framing
- [ ] Priority hierarchy is clear for conflicts
- [ ] No principle contradicts another
- [ ] Enforcement mechanism exists for each principle
- [ ] "Why" is documented for non-obvious principles
- [ ] Principles are achievable (not aspirational)

## Related

- [iron-law-discipline.md](iron-law-discipline.md) — Single-rule enforcement pattern
- [constraint-hierarchy.md](constraint-hierarchy.md) — Priority resolution for conflicts
- [instruction-files.md](../CONFIGURATION/instruction-files.md) — Where to place constitutions
- [verification-gates.md](verification-gates.md) — Gate patterns for enforcement
- [spec-driven.md](../WORKFLOWS/spec-driven.md) — Spec-Kit constitutional workflow

## Sources

### Official VS Code / GitHub Documentation
- [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) — Instruction file types, locations, combination behavior
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — Agent file format, frontmatter fields
- [GitHub Copilot Data Handling](https://resources.github.com/learn/pathways/copilot/essentials/how-github-copilot-handles-data/) — Platform-level safety filters, responsible AI
- [GitHub Copilot Responsible Use](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-your-ide) — Content filtering, red teaming
- [MCP Security Specification](https://modelcontextprotocol.io/specification/2025-11-25) — User consent, data privacy, tool safety principles

### External Tools & Frameworks (Not Native VS Code)
- [GitHub Spec-Kit](https://github.com/github/spec-kit) — Constitutional foundation and `/speckit.constitution` command (requires separate installation)
- [GitHub Blog — Spec-Driven Development](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/) — Six principles, validation gates
- [Anthropic Constitution (Jan 2026)](https://www.anthropic.com/constitution) — Hard constraints, hierarchy (Safe > Ethical > Guidelines > Helpful)
- [obra/superpowers](https://github.com/obra/superpowers) — Iron Law, Red Flags, Rationalization Tables, verification patterns
- [CursorRIPER.sigma](https://github.com/johnpeterman72/CursorRIPER.sigma) — Protection Levels, CRUD Permission Matrix, `protection.md`
- [12-Factor Agents](https://github.com/humanlayer/12-factor-agents) — Human escalation as first-class principle
- [System Prompts Analysis](https://github.com/asgeirtj/system_prompts_leaks) — Hierarchical constraint architecture (Safety > Context > Persona)
