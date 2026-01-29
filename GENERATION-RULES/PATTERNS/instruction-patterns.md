---
type: patterns
version: 1.0.0
purpose: Define HOW to create instruction files that provide project-wide and file-specific rules
applies-to: [generator, build, inspect]
last-updated: 2026-01-28
---

# Instruction Patterns

> **Instruction files provide persistent rules that shape Copilot interactions. They are NOT personas, roles, or agent definitions.**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
1. Use DECISION TREE to determine which instruction file type to create
2. Follow STRUCTURE requirements for chosen file type
3. Apply AUTHORING RULES during content creation
4. Validate output against VALIDATION CHECKLIST

**For Build Agents:**
1. Reference STRUCTURE when implementing instruction files
2. Use EXAMPLES as starting templates
3. Apply constraint priority (P1-P4) when writing rules

**For Inspect Agents:**
1. Verify all VALIDATION CHECKLIST items
2. Flag ANTI-PATTERN violations
3. Confirm NO ROLES prohibition is followed

---

## PURPOSE

**Problem Solved:** Without instructions, Copilot responses are generic and inconsistent across sessions.

**Instruction files provide:**
- Persistent, project-aware rules for ALL Copilot interactions
- File-specific rules via glob pattern targeting
- Team-wide consistency through shared configuration
- Safety boundaries that constrain agent behavior

**CRITICAL DISTINCTION:**
| Component | Contains | Does NOT Contain |
|-----------|----------|------------------|
| **Instructions** | Rules, constraints, standards, boundaries | Roles, personas, identity, tool access |
| **Agents** | Roles, personas, tools, handoffs, model selection | (inherits instructions) |

---

## THE FRAMEWORK APPROACH

### Single Rule: Instructions Define Rules, Not Identity

Instructions MUST contain project rules and constraints.
Instructions MUST NOT define who the agent is — that's `.agent.md` only.

### Two File Types with Clear Separation

| File Type | Location | Scope | When to Use |
|-----------|----------|-------|-------------|
| `copilot-instructions.md` | `.github/copilot-instructions.md` | All chat requests | Project-wide standards |
| `*.instructions.md` | `.github/instructions/*.instructions.md` | Files matching `applyTo` | File-type or directory rules |

### Decision Tree: Which File Type?

```
Does the rule apply to ALL project code?
├─ YES → copilot-instructions.md
└─ NO → Does it apply to specific file types?
         ├─ YES → *.instructions.md with applyTo pattern
         └─ NO → Does it apply to specific directories?
                  ├─ YES → *.instructions.md with directory pattern
                  └─ NO → Probably belongs in copilot-instructions.md
```

---

## STRUCTURE

### copilot-instructions.md — Required Sections

| Section | Purpose | Required |
|---------|---------|----------|
| Project Context | Tech stack, runtime, frameworks | ✅ Yes |
| Commands | Build, test, lint commands | ✅ Yes |
| Code Style | DO/DON'T patterns | ✅ Yes |
| File Conventions | Directory structure | ⚠️ Recommended |
| Testing Requirements | Framework, coverage | ⚠️ Recommended |
| Git Workflow | Branch naming, commits | ⚠️ Recommended |
| IMPORTANT (P1) | Safety constraints | ✅ Yes |

**Section Order:**
```
1. Project Context (tech stack)
2. Commands (most referenced — put early)
3. Code Style
4. File Conventions
5. Testing Requirements
6. Git Workflow
7. IMPORTANT (P1 safety rules)
```

### *.instructions.md — Required Format

**Frontmatter (YAML):**
```yaml
---
applyTo: "**/*.{ts,tsx}"      # Glob pattern (required for auto-apply)
name: "TypeScript Standards"   # Display name (optional)
description: "Type safety rules for TypeScript files"
excludeAgent: "code-review"   # Exclude from specific agents (optional)
---
```

**Body:** Markdown content with rules specific to matched files.

### Frontmatter Field Reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `applyTo` | ⚠️* | glob | Files to target. If omitted, must be manually attached. |
| `name` | No | string | Display name in VS Code UI |
| `description` | No | string | Purpose description |
| `excludeAgent` | No | string | Exclude from `"code-review"` or `"coding-agent"` |

*Required for auto-application; optional if manually attached via "Add Context"

### applyTo Pattern Syntax

```yaml
# Single extension
applyTo: "**/*.py"

# Multiple extensions
applyTo: "**/*.{jsx,tsx}"

# Directory targeting
applyTo: "src/api/**"

# Test files
applyTo: "**/*.test.{ts,js}"
applyTo: "**/*.spec.{ts,js}"

# Multiple patterns (comma-separated)
applyTo: "**/*.ts,**/*.tsx"

# Configuration files
applyTo: "**/*.{json,yaml,yml}"
```

---

## CONSTRAINT PRIORITY SYSTEM

### Four-Tier Priority (P1 > P2 > P3 > P4)

| Priority | Name | Override Rule | Location |
|----------|------|---------------|----------|
| **P1** | Safety | NEVER overridable | `copilot-instructions.md` IMPORTANT section |
| **P2** | Project | Team consensus required | `copilot-instructions.md` main content |
| **P3** | Behavioral | Explicit user request OK | `*.instructions.md`, agent instructions |
| **P4** | User/Session | Most flexible | Chat context, ad-hoc requests |

### Priority Indicator Patterns

**P1 (Safety) — Use IMPORTANT header:**
```markdown
## IMPORTANT — Safety Rules (No Exceptions)

- **Never** commit credentials, secrets, or API keys
- **Never** disable security middleware
- **Never** expose internal errors to users
```

**P2 (Project) — Use standard headers:**
```markdown
## Code Style

- Use ES modules (import/export)
- Prefer async/await over callbacks
- Use named exports, not default exports
```

**P3 (Behavioral) — Use conditional language:**
```markdown
Use bullet points for technical explanations,
unless the user explicitly requests a different format.
```

### Escape Clause Rules

| Priority | Escape Clause Allowed? | Example |
|----------|------------------------|---------|
| P1 | ❌ NEVER | "Never commit secrets" (NO "unless...") |
| P2 | ❌ No | "All functions require JSDoc" (team standard) |
| P3 | ✅ Yes | "...unless the user requests otherwise" |
| P4 | ✅ Yes | User preferences are always flexible |

---

## AUTHORING RULES

```
RULE_001: NO ROLES IN INSTRUCTIONS
  REQUIRE: Instructions contain only rules, constraints, standards
  REJECT_IF: File contains role definitions, persona descriptions, "You are..."
  RATIONALE: Roles belong in .agent.md files only
  EXAMPLE_VALID: "Use TypeScript strict mode"
  EXAMPLE_INVALID: "You are a senior TypeScript developer"

RULE_002: SELF-CONTAINED FILES
  REQUIRE: Each instruction file works independently
  REJECT_IF: File assumes another instruction file is loaded
  RATIONALE: No guaranteed load order; composition is unreliable
  EXAMPLE_VALID: Repeats critical context if needed
  EXAMPLE_INVALID: "See copilot-instructions.md for details"

RULE_003: LINE LIMIT GUIDELINE
  REQUIRE: Target ≤300 lines per instruction file
  REJECT_IF: File exceeds 500 lines without justification
  RATIONALE: Longer files dilute focus, waste context window
  EXAMPLE_VALID: 150-line focused instruction file
  EXAMPLE_INVALID: 800-line kitchen-sink file

RULE_004: SPECIFIC STACK DECLARATIONS
  REQUIRE: Explicit versions and frameworks
  REJECT_IF: Vague descriptions like "modern practices"
  RATIONALE: Vague = inconsistent suggestions
  EXAMPLE_VALID: "TypeScript 5.4, React 18, Vitest 1.x"
  EXAMPLE_INVALID: "Use latest technologies"

RULE_005: COMMANDS EARLY
  REQUIRE: Commands section appears in first third of file
  REJECT_IF: Commands buried at end
  RATIONALE: Most frequently referenced by agents
  EXAMPLE_VALID: Commands after Project Context
  EXAMPLE_INVALID: Commands in appendix

RULE_006: POSITIVE FRAMING
  REQUIRE: State what TO do, not what NOT to do
  REJECT_IF: Majority negative framing
  RATIONALE: Positive framing is clearer and more actionable
  EXAMPLE_VALID: "Write tests for all new code"
  EXAMPLE_INVALID: "Don't skip tests"

RULE_007: NO DUPLICATE RULES
  REQUIRE: Each rule has single source of truth
  REJECT_IF: Same rule appears in multiple files
  RATIONALE: Prevents drift, reduces maintenance, avoids conflicts
  EXAMPLE_VALID: Global rule in copilot-instructions.md only
  EXAMPLE_INVALID: Same rule in both global and targeted files

RULE_008: EMPHASIS FOR SAFETY
  REQUIRE: Use **Never**, **Always**, **MUST** for P1 rules
  REJECT_IF: P1 constraints use weak language
  RATIONALE: Salience affects LLM compliance
  EXAMPLE_VALID: "**Never** commit secrets"
  EXAMPLE_INVALID: "Try to avoid committing secrets"
```

---

## VALIDATION CHECKLIST

```
VALIDATE_instruction_file:
  □ Has correct file location (.github/ or .github/instructions/)
  □ Has YAML frontmatter (for *.instructions.md)
  □ applyTo pattern is valid glob syntax
  □ Contains NO role/persona definitions
  □ Contains NO tool specifications
  □ Contains NO handoff rules
  □ Line count ≤300 (or justified)
  □ Commands appear in first third
  □ P1 rules use IMPORTANT header + emphasis
  □ No escape clauses on P1/P2 rules
  □ Stack versions are explicit
  □ No duplicate rules across files
  □ Self-contained (no cross-file dependencies)
```

---

## LIMITATIONS

> **CRITICAL:** Priority is design discipline, NOT platform enforcement.

**What the platform does:**
- Loads instruction files based on file location and applyTo patterns
- Combines all matching instructions into context
- Sends combined context to LLM

**What the platform does NOT do:**
- Enforce priority ordering between instruction files
- Prevent LLM from ignoring constraints
- Guarantee any specific load order within a priority level

**Implication:** Write non-conflicting instructions. Do not rely on precedence to resolve conflicts. The LLM decides arbitrarily when rules conflict.

**Defense in Depth:**
1. Use strong language (NEVER, MUST) for critical rules
2. Repeat critical constraints in multiple places
3. Verify behavior through testing, not assumption

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| Define personas in instructions | Put personas in `.agent.md` | Instructions are rules, not identity |
| Specify tools in instructions | Put tools in `.agent.md` `tools:` field | Instructions don't control tool access |
| Create files >300 lines | Split into targeted `.instructions.md` files | Dilutes focus, wastes context |
| Write vague stack descriptions | Explicit: "TypeScript 5.4, React 18" | Vague = inconsistent suggestions |
| Assume load order | Design self-contained files | No guaranteed order within priority |
| Add escape clauses to P1 rules | P1 rules have NO exceptions | Security cannot be rationalized away |
| Duplicate rules across files | Single source of truth per rule | Prevents drift and conflicts |
| Use negative framing | "Write tests" not "Don't skip tests" | Positive framing is clearer |
| Reference other instruction files | Make each file self-contained | Composition is unreliable |
| Bury commands at end | Commands in first third | Most frequently referenced |

---

## EXAMPLES

### Minimal copilot-instructions.md

```markdown
# Project: Example App

## Tech Stack
- TypeScript 5.4, Node.js 20, Express 4.x

## Commands
- `npm run build` — Compile TypeScript
- `npm test` — Run tests
- `npm run lint` — Check style

## Code Style
- Use ES modules (import/export)
- Use async/await, not callbacks
- Use named exports

## IMPORTANT
- **Never** commit secrets or API keys
- **Never** disable type checking
```

### Minimal *.instructions.md

```yaml
---
applyTo: "**/*.{ts,tsx}"
name: "TypeScript Standards"
---

# TypeScript Standards

## Type Safety
- Enable strict mode
- No `any` without justification
- Prefer type inference where clear

## Imports
- Use `import type` for type-only imports
- Destructure when importing multiple items
```

### Full copilot-instructions.md

```markdown
# Project: Production API

## Tech Stack
- **Language:** TypeScript 5.4
- **Runtime:** Node.js 20 LTS
- **Framework:** Express 4.x
- **Database:** PostgreSQL 16
- **ORM:** Prisma 5.x
- **Testing:** Vitest, Supertest
- **Auth:** JWT + OAuth 2.0

## Commands
- `npm run build` — Compile TypeScript
- `npm run dev` — Start dev server (watch mode)
- `npm test` — Run test suite
- `npm run lint` — ESLint check
- `npm run typecheck` — TypeScript validation
- `npm run db:migrate` — Run migrations

## Code Style
- ✅ ES modules (import/export)
- ✅ async/await
- ✅ Named exports
- ✅ Destructure imports
- ❌ CommonJS (require)
- ❌ Callbacks for async
- ❌ Default exports

## File Conventions
- `src/` — Application source
- `src/routes/` — Express route handlers
- `src/services/` — Business logic
- `src/repositories/` — Database access
- `src/utils/` — Shared utilities
- `tests/` — Test files (mirror src/ structure)

## Testing Requirements
- Unit tests for all services
- Integration tests for routes
- Minimum 80% coverage
- Use factories for test data

## Git Workflow
- Branch: `feat/`, `fix/`, `refactor/`
- Commit: `type(scope): message`
- Always run tests before commit

## Boundaries
| Action | Permission |
|--------|------------|
| Read any file | ✅ Always |
| Edit existing code | ✅ Allowed |
| Create new files | ⚠️ Ask first |
| Delete files | 🚫 Never |
| Run shell commands | ⚠️ Listed only |

## IMPORTANT — Safety Rules (No Exceptions)
- **Never** commit secrets, API keys, or credentials
- **Never** disable security middleware
- **Never** expose internal error details to users
- **Never** bypass authentication checks
- **Never** modify migration files after deployment
- **Always** validate user input with Zod
```

### Full *.instructions.md

```yaml
---
applyTo: "src/api/**"
name: "API Route Standards"
description: "Patterns for Express route handlers"
---

# API Route Standards

## Route Handler Structure

```typescript
export async function POST(req: Request) {
  // 1. Parse and validate input
  const body = await req.json();
  const validated = schema.parse(body);

  // 2. Business logic (call service)
  const result = await service.create(validated);

  // 3. Return response
  return Response.json(result, { status: 201 });
}
```

## Error Response Codes
- 400 — Validation errors (include field details)
- 401 — Not authenticated
- 403 — Not authorized
- 404 — Resource not found
- 500 — Unexpected error (log, don't expose)

## Required Patterns
- ✅ Input validation with Zod
- ✅ Rate limiting for public endpoints
- ✅ Request logging with correlation IDs
- ✅ Typed error responses

## Response Format

```typescript
// Success
{ data: T, meta?: { pagination } }

// Error
{ error: { code: string, message: string, details?: any } }
```
```

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [agent-patterns.md](agent-patterns.md) | Agents inherit instructions; agents define personas |
| [COMPONENT-MATRIX.md](../COMPONENT-MATRIX.md) | Decision matrix includes instructions |
| [SETTINGS.md](../SETTINGS.md) | Settings that control instruction loading |
| [skill-patterns.md](skill-patterns.md) | Skills provide procedures; instructions provide rules |

---

## SOURCES

- [instruction-files.md](../../cookbook/CONFIGURATION/instruction-files.md) — Primary structure reference
- [constraint-hierarchy.md](../../cookbook/PATTERNS/constraint-hierarchy.md) — Priority system
- [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [GitHub Response Customization](https://docs.github.com/en/copilot/concepts/prompting/response-customization)
- [GitHub Blog — AGENTS.md Lessons](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)
