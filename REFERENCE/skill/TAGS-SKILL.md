# Skill Tags

Tag vocabulary for SKILL.md metadata — portable, reusable capabilities.

---

## Frontmatter Fields

### Required ✅

| Field | Type | Constraints | Example |
|-------|------|-------------|---------|
| `name` | string | 1-64 chars, lowercase alphanumeric + hyphens, matches folder | `database-migration` |
| `description` | string | 1-1024 chars, WHAT + WHEN formula | `Run migrations when schema changes` |

### Recommended ⭐

| Field | Type | When to Use | Example |
|-------|------|-------------|---------|
| `license` | string | Distributing skill | `MIT`, `Apache-2.0` |
| `compatibility` | string | Platform-specific requirements | `Requires Node.js 18+` |

### Optional

| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `metadata` | object | Arbitrary key-value pairs | See below |
| `metadata.author` | string | Creator attribution | `your-org` |
| `metadata.version` | string | Semantic version | `"1.0.0"` |
| `metadata.tags` | array | Discovery keywords | `[database, devops]` |

**Note:** `allowed-tools` is NOT supported in VS Code — use agent-level tool restrictions.

---

## Description Tags (Keywords)

Include these keywords in your description for better discovery:

### Action Verbs

```yaml
# What the skill DOES
- fix, resolve, repair
- create, generate, scaffold
- run, execute, deploy
- review, inspect, validate
- migrate, convert, transform
- configure, setup, initialize
```

### Trigger Contexts

```yaml
# WHEN to invoke
- when...is requested
- when...needs to be applied
- when...are opened/created
- when...fails/breaks
- when asked to...
```

### Domain Keywords

```yaml
# Typical skill domains
- database: migration, schema, backup, rollback
- testing: test, verify, coverage, assertion
- deployment: deploy, release, publish, staging
- code-gen: component, template, scaffold, boilerplate
- review: code-review, pr, pull-request, changes
- documentation: docs, readme, api-docs
```

---

## Metadata Tags

Common `metadata.tags` values for skill discovery:

### By Domain

| Domain | Tags |
|--------|------|
| Development | `code`, `refactor`, `debug`, `lint` |
| Testing | `test`, `e2e`, `unit-test`, `coverage` |
| Database | `database`, `migration`, `prisma`, `sql` |
| DevOps | `deploy`, `ci-cd`, `docker`, `kubernetes` |
| Documentation | `docs`, `readme`, `changelog`, `api` |
| Git/Version Control | `git`, `github`, `pr`, `commit` |

### By Platform

| Platform | Tags |
|----------|------|
| Node.js | `nodejs`, `npm`, `yarn`, `pnpm` |
| Python | `python`, `pip`, `poetry` |
| React | `react`, `nextjs`, `component` |
| Azure | `azure`, `az-cli`, `deployment` |
| GitHub | `github`, `gh-cli`, `actions` |

---

## Section Headers

Standard sections for SKILL.md body:

### Required Sections

| Section | Purpose | Format |
|---------|---------|--------|
| `# {Title}` | Skill name | H1 heading |
| `## Steps` | Execution procedure | Numbered list |
| `## Error Handling` | Failure recovery | "If {X}: {Y}" format |

### Recommended Sections

| Section | Purpose | When to Include |
|---------|---------|-----------------|
| `## Reference Files` | JIT-loaded docs | When using references/ folder |
| `## Validation` | Success criteria | When output is verifiable |
| `## Notes` | Prerequisites, warnings | When non-obvious requirements |

### Optional Sections

| Section | Purpose | When to Include |
|---------|---------|-----------------|
| `## Troubleshooting` | Common issues | Complex skills with known failure modes |
| `## After Running` | User manual steps | When skill needs post-execution action |

---

## Error Handling Format

Standard format for error documentation:

```markdown
## Error Handling

If {condition}: {recovery action}
If {condition}: {recovery action}
```

### Error Severity Keywords

| Severity | When to Use | Example |
|----------|-------------|---------|
| `STOP` | Cannot continue | "Report error and stop" |
| `RETRY` | Transient failure | "Wait 5s and retry" |
| `FALLBACK` | Alternative available | "Use backup method" |
| `WARN` | Recoverable issue | "Log warning, continue" |
| `ASK` | User decision needed | "Confirm with user" |

---

## Examples

### Minimal Frontmatter

```yaml
---
name: run-tests
description: Run project test suite and report failures when tests need verification
---
```

### Full Frontmatter

```yaml
---
name: database-migration
description: Run Prisma database migrations safely with automatic backup and rollback when schema changes need to be applied to development or production databases
license: MIT
compatibility: Requires Node.js, Prisma CLI, and database access
metadata:
  author: your-org
  version: "1.0.0"
  tags: [database, prisma, migration, devops]
---
```

### Description Formula Examples

```yaml
# Pattern: {Verb} {what} when {trigger}

✅ "Fix a GitHub issue when asked to resolve a bug or feature request"
✅ "Run Prisma migrations when schema changes need to be applied"
✅ "Review code changes when PRs are opened or commits need verification"
✅ "Create React components when new UI features are requested"

❌ "Fixes issues"                    # Missing WHEN
❌ "Database helper"                 # Missing verb and trigger
❌ "Useful for migrations"           # Vague, no capability
```

---

## Cross-References

- [skill/PATTERNS.md](skill/PATTERNS.md) — When/why/rules for skills
- [skill/TEMPLATE.md](skill/TEMPLATE.md) — Skill file structure
- [skill/CHECKLIST.md](skill/CHECKLIST.md) — Validation checklist
