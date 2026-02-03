# Core Agent Customization Guide

How to extend core agents with project-specific behavior without forking.

---

## Customization Mechanisms

VS Code provides four mechanisms for extending agent behavior:

| Mechanism | Scope | When to Use |
|-----------|-------|-------------|
| Instruction overlays | Augment specific agents | Add constraints, context, quality checks |
| Specialized agents | New agents that delegate to core | Domain-specific workflow variants |
| Skills | Invocable procedures | Reusable operations agents can call |
| copilot-instructions.md | Global project rules | Cross-cutting standards all agents inherit |

---

## Pattern 1: Instruction Overlays

**Use for:** Adding project-specific constraints to core agents without modification.

**Mechanism:** Create `.instructions.md` files in `.github/instructions/` that target agent files via `applyTo`.

**How it works:** VS Code automatically injects matching instruction files into agent context. Agents see their base definition PLUS any overlay content.

### Scenario: Add project-specific quality checks to @inspect

**Problem:** "Always check for SQL injection in this project"

**Solution:** Create an instruction overlay targeting inspect.

```markdown
# .github/instructions/inspect.project.instructions.md
---
applyTo: "**/inspect.agent.md"
description: "Project-specific quality checks for inspect agent"
---

<project_quality_checks>

## Security Checks (REQUIRED for this project)

Every inspection MUST verify:

1. **SQL Injection Prevention**
   - All database queries use parameterized statements
   - No string concatenation in SQL construction
   - No raw user input in queries

2. **Authentication Boundaries**
   - All API endpoints require authentication
   - No sensitive data in URL parameters
   - Session tokens use HttpOnly cookies

3. **Input Validation**
   - All user inputs sanitized before use
   - File uploads validate MIME type AND content
   - JSON payloads validated against schema

</project_quality_checks>

<severity_adjustments>

For this project, elevate to CRITICAL:
- Any SQL injection vulnerability
- Missing authentication on endpoints
- Hardcoded credentials

</severity_adjustments>
```

**File location:** `.github/instructions/inspect.project.instructions.md`

### Scenario: Add planning constraints to @architect

**Problem:** "Never propose changes to legacy/ folder"

**Solution:** Create an instruction overlay targeting architect.

```markdown
# .github/instructions/architect.project.instructions.md
---
applyTo: "**/architect.agent.md"
description: "Project-specific planning constraints for architect agent"
---

<project_constraints>

## Protected Zones (DO NOT PLAN CHANGES)

These directories are frozen and must not appear in any plan:

- `legacy/` — Legacy code scheduled for removal Q3. Read-only access.
- `vendor/` — Third-party code. Changes require procurement review.
- `generated/` — Auto-generated files. Changes overwritten on build.

If a requirement touches protected zones:
1. STOP planning
2. Surface the constraint to user
3. Request guidance on workaround approach

## Mandatory Plan Sections

Every plan for this project MUST include:

1. **Migration impact** — Does this affect database schema?
2. **Feature flag** — Is this behind a feature flag?
3. **Rollback steps** — How to revert if deployment fails?

</project_constraints>
```

**File location:** `.github/instructions/architect.project.instructions.md`

---

## Pattern 2: copilot-instructions.md for Global Rules

**Use for:** Cross-cutting standards that ALL agents should follow.

**Mechanism:** All core agents load `.github/copilot-instructions.md` on startup (if present).

### Scenario: Add domain knowledge to @brain (and all agents)

**Problem:** "This is a React project, prefer hooks over class components"

**Solution:** Add to copilot-instructions.md — applies to all agents.

```markdown
# .github/copilot-instructions.md

<project_context>

## Technology Stack

- **Frontend:** React 18 with TypeScript
- **State:** Zustand for global state, React Query for server state
- **Testing:** Vitest + React Testing Library
- **Build:** Vite with pnpm

## Code Standards

- Prefer React hooks over class components
- Use functional components exclusively
- Extract custom hooks for reusable logic
- Colocate tests with components (ComponentName.test.tsx)

</project_context>

<terminology>

Use these terms consistently:
- "widget" (not "component") for UI building blocks
- "store" (not "state container") for Zustand stores
- "query" (not "fetch hook") for React Query usage

</terminology>
```

**File location:** `.github/copilot-instructions.md`

**Why here instead of overlay?**
- Technology stack applies to ALL agents, not just @brain
- @build needs to know "use pnpm" when running commands
- @inspect needs to know "hooks not classes" when reviewing code
- @architect needs to know conventions when planning

---

## Pattern 3: Instruction Overlays for Build Configuration

**Use for:** Build-specific commands, scripts, and tooling.

### Scenario: Add build scripts to @build

**Problem:** "Use pnpm not npm, run tests with vitest not jest"

**Solution:** Create an instruction overlay targeting build.

```markdown
# .github/instructions/build.project.instructions.md
---
applyTo: "**/build.agent.md"
description: "Project-specific build configuration"
---

<build_commands>

## Package Manager

This project uses **pnpm**. NEVER use npm or yarn.

- Install: `pnpm install`
- Add package: `pnpm add <package>`
- Add dev dependency: `pnpm add -D <package>`
- Run script: `pnpm run <script>`

## Test Runner

This project uses **Vitest**. NEVER use Jest.

- Run all tests: `pnpm test`
- Run single file: `pnpm test <path>`
- Run with coverage: `pnpm test --coverage`
- Watch mode: `pnpm test --watch`

## Common Scripts

| Task | Command |
|------|---------|
| Development server | `pnpm dev` |
| Production build | `pnpm build` |
| Type check | `pnpm typecheck` |
| Lint | `pnpm lint` |
| Format | `pnpm format` |

## Pre-Commit Checklist

Before reporting build complete:
1. `pnpm typecheck` — Must pass with no errors
2. `pnpm lint` — Must pass with no errors
3. `pnpm test` — All tests must pass

</build_commands>
```

**File location:** `.github/instructions/build.project.instructions.md`

---

## Pattern 4: Specialized Agents (Delegation Pattern)

**Use for:** Domain-specific workflows that need their own identity.

**Mechanism:** Create new agents that delegate to core agents for execution.

### When to use specialized agents vs overlays

| Signal | Use Overlay | Use Specialized Agent |
|--------|-------------|----------------------|
| Same workflow, different checks | ✓ | |
| Same workflow, different commands | ✓ | |
| Different workflow entirely | | ✓ |
| Needs custom handoffs | | ✓ |
| Domain requires unique identity | | ✓ |

### Example: Security-focused inspector

```markdown
# .github/agents/security.agent.md
---
description: 'Security-focused code review — penetration testing mindset'
name: 'security'
tools: ['read', 'search', 'execute']
handoffs:
  - label: 'Full Inspection'
    agent: inspect
    prompt: 'Security review complete. Run full quality inspection.'
    send: false
  - label: 'Fix Security Issue'
    agent: build
    prompt: 'Security vulnerability found. Implement fix per recommendations.'
    send: false
---

You are a security reviewer — you think like an attacker.

**Expertise:** OWASP Top 10, penetration testing, secure coding patterns

**Stance:** Adversarial. Assume all inputs are malicious. Trust nothing.

<security_checklist>

Every review MUST check:
1. Injection vulnerabilities (SQL, XSS, Command)
2. Authentication/Authorization flaws
3. Sensitive data exposure
4. Security misconfigurations
5. Cryptographic weaknesses

</security_checklist>

When security review passes, hand off to @inspect for general quality.
```

---

## Pattern 5: Skills for Reusable Operations

**Use for:** Procedures that multiple agents might need to invoke.

**Mechanism:** Create skills in `.github/skills/` that agents discover and use.

### When to use skills vs instruction overlays

| Signal | Use Overlay | Use Skill |
|--------|-------------|-----------|
| Passive context (rules, standards) | ✓ | |
| Active procedure (steps to execute) | | ✓ |
| Agent-specific behavior | ✓ | |
| Cross-agent reusable operation | | ✓ |

### Example: Database migration skill

```markdown
# .github/skills/db-migrate/SKILL.md
---
name: 'db-migrate'
description: 'Run database migrations safely with rollback capability'
tools: ['execute', 'read']
---

## When to Use

Invoke this skill when:
- Creating or modifying database schema
- Running pending migrations
- Rolling back failed migrations

## Procedure

1. Check current migration status: `pnpm prisma migrate status`
2. Create migration: `pnpm prisma migrate dev --name <name>`
3. Verify migration applied: Check `_prisma_migrations` table
4. If rollback needed: `pnpm prisma migrate reset` (CAUTION: data loss)

## Safety Checks

- ALWAYS backup before migration in production
- NEVER run `migrate reset` on production database
- ALWAYS verify migration is reversible before applying
```

**File location:** `.github/skills/db-migrate/SKILL.md`

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: Forking agents

**Wrong:** Copy architect.agent.md to my-architect.agent.md and modify.

**Why bad:**
- Loses upstream updates
- Maintenance burden doubles
- Divergence causes confusion

**Instead:** Use instruction overlays to augment behavior.

### Anti-Pattern 2: Overloading copilot-instructions.md

**Wrong:** Put all customizations in copilot-instructions.md.

**Why bad:**
- Grows unbounded
- Agent-specific rules pollute all agents
- Hard to maintain

**Instead:** Use copilot-instructions.md for TRUE cross-cutting concerns. Use overlays for agent-specific customizations.

### Anti-Pattern 3: Using overlays for active procedures

**Wrong:** Put step-by-step procedures in instruction overlays.

**Why bad:**
- Instructions are passive context, not invocable
- Agents can't "call" an instruction
- Creates confusion about when procedure applies

**Instead:** Create skills for procedures that agents invoke on-demand.

### Anti-Pattern 4: Creating specialized agents for minor tweaks

**Wrong:** Create react-inspect.agent.md just to add "check for hooks."

**Why bad:**
- Agent proliferation
- Users must remember which agent to use
- Handoff graph becomes complex

**Instead:** Use overlays. Create new agents only when workflow differs fundamentally.

### Anti-Pattern 5: Duplicating rules across overlays

**Wrong:** Add "use pnpm" to architect overlay, build overlay, and inspect overlay.

**Why bad:**
- Maintenance nightmare
- Rules drift apart
- Updates require touching multiple files

**Instead:** Put shared rules in copilot-instructions.md.

---

## Recommended File Structure

```
.github/
├── copilot-instructions.md           # Global rules (all agents)
├── agents/
│   ├── architect.agent.md            # Core (unchanged)
│   ├── brain.agent.md                # Core (unchanged)
│   ├── build.agent.md                # Core (unchanged)
│   ├── inspect.agent.md              # Core (unchanged)
│   └── security.agent.md             # Specialized (if needed)
├── instructions/
│   ├── architect.project.instructions.md   # Architect overlay
│   ├── build.project.instructions.md       # Build overlay
│   └── inspect.project.instructions.md     # Inspect overlay
└── skills/
    ├── db-migrate/
    │   └── SKILL.md
    └── deploy/
        └── SKILL.md
```

---

## Quick Reference: Which Pattern to Use

| Scenario | Pattern | File |
|----------|---------|------|
| Add quality checks to @inspect | Instruction overlay | `instructions/inspect.project.instructions.md` |
| Add domain knowledge to all agents | copilot-instructions.md | `copilot-instructions.md` |
| Configure build commands | Instruction overlay | `instructions/build.project.instructions.md` |
| Add planning constraints | Instruction overlay | `instructions/architect.project.instructions.md` |
| Create domain-specific workflow | Specialized agent | `agents/domain.agent.md` |
| Add reusable procedure | Skill | `skills/procedure/SKILL.md` |

---

## Cross-References

- [agent-reference.md](agent-reference.md) — What each core agent does
- [../README.md](../README.md) — Installation guide
- [../CHANGELOG.md](../CHANGELOG.md) — Version history
