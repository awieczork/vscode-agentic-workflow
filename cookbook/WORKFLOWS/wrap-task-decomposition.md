---
when:
  - preparing work for AI agents
  - writing effective issues for Copilot
  - breaking down large tasks into atomic units
  - refining backlog items for agent execution
pairs-with:
  - task-tracking
  - spec-driven
  - research-plan-implement
  - instruction-files
requires:
  - none
complexity: medium
---

# WRAP Task Decomposition

A four-step framework for preparing work that AI agents can execute effectively. WRAP transforms vague requests into atomic, actionable tasks that leverage what humans and agents each do best.

> **Platform Note:** WRAP is an official GitHub framework documented in ["WRAP Up Your Backlog with GitHub Copilot Coding Agent"](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/). The patterns below are adapted for VS Code workflows.

## The WRAP Framework

```
┌─────────────────────────────────────────────────────────────────┐
│  W - WRITE       📝  Write effective issues                     │
│  R - REFINE      🔧  Refine with custom instructions            │
│  A - ATOMIC      ⚛️   Break into atomic tasks                    │
│  P - PAIR        🤝  Pair human judgment with agent execution   │
└─────────────────────────────────────────────────────────────────┘
```

## Write: Effective Issue Writing

Write issues as if for someone brand new to the codebase.

### Bad vs Good Issues

```markdown
❌ Instead of:
"Update the entire repository to use async/await"

✅ Better:
"Update the authentication middleware to use the newer async/await
pattern, as shown in the example below. Add unit tests for verification,
ensuring edge cases are considered."

## Example Implementation
```typescript
// Current (callback-based)
function authenticate(token, callback) {
  verifyToken(token, (err, user) => {
    if (err) callback(err);
    else callback(null, user);
  });
}

// Desired (async/await)
async function authenticate(token) {
  return await verifyToken(token);
}
```

## Acceptance Criteria
1. WHEN valid token provided, THE SYSTEM SHALL return user object
2. WHEN invalid token provided, THE SYSTEM SHALL throw AuthError
3. WHEN token expired, THE SYSTEM SHALL throw ExpiredTokenError
```

### Issue Writing Checklist

- [ ] Title explains WHERE work occurs
- [ ] Description explains WHAT to do, not just WHAT'S WRONG
- [ ] Includes code examples of desired implementation
- [ ] Specifies acceptance criteria (EARS format preferred)
- [ ] Mentions edge cases to consider
- [ ] Links to relevant existing code

## Refine: Using Custom Instructions

Layer instructions from broad to specific:

| Level | Scope | Example Content |
|-------|-------|-----------------|
| **Enterprise** | All enterprise repos | "Security review required for auth changes" |
| **Organization** | All org repos | "All PRs require 80% test coverage" |
| **Repository** | All repo work | "Use Go coding conventions, run `go fmt` before commits" |
| **Custom Agent** | Specific task type | "Integration Agent: Focus on API contracts, mock external services" |

### Refinement Examples

**Repository-level** (`.github/copilot-instructions.md`):
```markdown
# Code Style
- Use TypeScript strict mode
- Prefer async/await over callbacks
- Maximum function length: 50 lines

# Testing
- Write unit tests for all public functions
- Use Jest with coverage > 80%
```

**Task-specific** (`.github/agents/migration.agent.md`):
```yaml
---
name: migration-agent
description: Handles code migration tasks
tools: ["read", "edit", "search", "terminal"]
---

# Migration Agent

You specialize in code migration tasks.

## Approach
1. Read existing implementation thoroughly
2. Identify all call sites before modifying
3. Update incrementally, test after each change
4. Preserve external API contracts
```

### Three-Tier Boundaries Pattern

When defining custom agents, structure boundaries clearly. This pattern emerged from [GitHub's analysis of 2,500+ repositories](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/):

| Tier | Purpose | Example |
|------|---------|--------|
| **✅ Always do** | Mandatory behaviors | "Run tests before committing" |
| **⚠️ Ask first** | Requires confirmation | "Before modifying public APIs" |
| **🚫 Never do** | Hard boundaries | "Never commit secrets or credentials" |

### Copilot Memory (Public Preview)

Copilot Memory enhances the Refine step by remembering repository context across sessions. When enabled, the coding agent retains knowledge about your codebase patterns, reducing the need for repeated instructions.

Cross-agent memory allows agents to remember and learn from experiences across your development workflow—coding agent, CLI, and code review share learned context. Memory uses just-in-time verification with citations rather than offline curation.

Source: [Building an Agentic Memory System for GitHub Copilot](https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/)

> **Tip:** Generating custom repository instructions is itself a good first task for the coding agent. (Confirmed in [GitHub Blog WRAP article](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/))

## Atomic: Breaking Down Tasks

Each task should equal one commit's worth of changes.

### Bad vs Good Task Breakdown

```markdown
❌ Too Large:
"Rewrite 3M lines from Java to Golang"

✅ Atomic:
1. Migrate authentication module
2. Convert data validation utilities
3. Rewrite user management controllers
4. Update API gateway routing
5. Migrate database access layer
```

### Atomic Task Format

```markdown
- [ ] Task 1: Migrate auth middleware (M)
  - Depends on: none
  - Files: src/middleware/auth.ts
  - Verify: `npm test src/middleware/auth.test.ts`

- [ ] Task 2: Update user routes (S)
  - Depends on: Task 1
  - Files: src/routes/users.ts
  - Verify: `npm run test:integration`

- [ ] Task 3: Add error handling (S)
  - Depends on: Task 1, Task 2
  - Files: src/middleware/errors.ts
  - Verify: Error responses match API spec
```

Size indicators: (S) Small, (M) Medium, (L) Large

### Atomicity Checklist

- [ ] Task is completable in one session
- [ ] Task produces one logical commit
- [ ] Task can be tested independently
- [ ] Dependencies are explicit
- [ ] Rollback is straightforward

## Pair: Human + Agent Strengths

Leverage what each does best. From the [official WRAP article](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/):

| Humans Excel At | Agents Excel At |
|-----------------|-----------------|
| Understanding "why" behind tasks | Tireless execution (assign 10 tasks at once) |
| Navigating ambiguity | Repetitive tasks (naming conventions, etc.) |
| Cross-system thinking | Exploring possibilities (try multiple approaches simultaneously) |
| Prioritization decisions | Consistent code style application |
| Architecture judgment | Comprehensive test case generation |
| Security-critical decisions | Parallel experimentation (multiple solutions at once) |

### Pairing Workflow

```
Human: Define → Review → Approve
       ↓         ↑         ↓
Agent: Execute → Report → Iterate
```

1. **Human defines** - Write issue, refine instructions, break into atomic tasks
2. **Agent executes** - Implement task, run tests, create PR
3. **Human reviews** - Check implementation, approve or request changes
4. **Agent iterates** - Address feedback, update implementation
5. **Human approves** - Merge when satisfied

### What to Delegate

| Delegate to Agent | Keep for Human |
|-------------------|----------------|
| Code migrations (well-defined) | Architecture decisions |
| Adding tests for existing code | Security-critical changes |
| Applying consistent formatting | External API design |
| Documentation generation | Prioritization |
| Dependency updates | Complex debugging |

## Complete WRAP Example

### Starting Point: Vague Request

```
"Make our API faster"
```

### After WRAP

**W - Write:**
```markdown
# Optimize User API Response Time

## Problem
The `/api/users` endpoint returns in 800ms average.
Target: < 200ms.

## Current State
- Fetches all user fields from database
- No caching layer
- N+1 query for user preferences

## Proposed Solution
- Add Redis caching with 5-minute TTL
- Select only required fields
- Eager load preferences in single query

## Example
[Include code snippets of current vs desired implementation]
```

**R - Refine:**
```markdown
# Custom instructions added

## Performance Work
- Use Redis for caching (connection in src/lib/redis.ts)
- Run `npm run benchmark` before and after changes
- Target: p95 latency < 200ms
```

**A - Atomic:**
```markdown
- [ ] Task 1: Add Redis caching layer (M)
  - Files: src/lib/cache.ts
  - Verify: Cache hit/miss metrics in logs

- [ ] Task 2: Optimize user query (S)
  - Depends on: none
  - Files: src/repositories/users.ts
  - Verify: Single query in SQL logs

- [ ] Task 3: Eager load preferences (S)
  - Depends on: Task 2
  - Files: src/repositories/users.ts
  - Verify: No N+1 in query logs

- [ ] Task 4: Benchmark and document (S)
  - Depends on: Task 1, 2, 3
  - Verify: p95 < 200ms in benchmark output
```

**P - Pair:**
- Human: Reviewed caching strategy, approved Redis approach
- Agent: Implemented Tasks 1-3, ran benchmarks
- Human: Reviewed results, merged PR

## Integration with Other Workflows

| WRAP Step | Connects To |
|-----------|-------------|
| Write | [spec-templates](spec-templates.md) — Full issue template format |
| Refine | [instruction-files](../CONFIGURATION/instruction-files.md) — Hierarchy of instructions |
| Atomic | [spec-driven](spec-driven.md) — Phase 3 task breakdown |
| Pair | [riper-modes](riper-modes.md) — Execute mode for agent work |

## Recommended Agent Personas

From [GitHub's analysis of 2,500+ repositories](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/), six agent types appear most frequently:

| Agent | Purpose |
|-------|---------|
| `docs-agent` | Documentation generation and updates |
| `test-agent` | Test creation and coverage |
| `lint-agent` | Code style and linting enforcement |
| `api-agent` | API design and implementation |
| `dev-deploy-agent` | Development and deployment workflows |
| `security-agent` | Security scanning and fixes |

## Related

- [spec-driven](spec-driven.md) — Full Specify→Plan→Tasks→Implement workflow
- [spec-templates](spec-templates.md) — Issue and task template formats
- [instruction-files](../CONFIGURATION/instruction-files.md) — Custom instructions hierarchy
- [task-tracking](task-tracking.md) — Tracking atomic task progress
- [twelve-factor-agents](../PATTERNS/twelve-factor-agents.md) — "Small, focused agents" principle

## Sources

- [GitHub Blog: WRAP Framework](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/) — Official WRAP methodology
- [GitHub Blog: How to Write a Great AGENTS.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/) — Three-tier boundaries, six agent personas
- [GitHub Blog: Building an Agentic Memory System](https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/) — Copilot Memory architecture
