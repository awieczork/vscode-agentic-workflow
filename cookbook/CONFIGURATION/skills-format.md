---
when:
  - packaging reusable agent capabilities
  - creating portable tool packages with scripts
  - setting up project or personal skills
  - organizing complex multi-step workflows
pairs-with:
  - file-structure
  - agent-file-format
  - prompt-files
requires:
  - terminal-access
complexity: medium
---

# Skills Format (SKILL.md)

Package reusable capabilities as portable skills. Skills are loaded on-demand when referenced, keeping context budgets lean while providing specialized workflows, scripts, and templates.

## What Skills Are

Skills follow the [agentskills.io](https://agentskills.io/specification) open standard, adopted by VS Code Copilot, Claude Code, and Cursor. Each skill is a folder containing:

- **SKILL.md** — Instructions and metadata (required)
- **scripts/** — Executable code (optional)
- **references/** — Documentation (optional)
- **assets/** — Templates, data files (optional)

## Folder Structure

```
.github/skills/
├── fix-issue/
│   ├── SKILL.md              # Required
│   ├── scripts/
│   │   └── validate.sh
│   └── references/
│       └── CONTRIBUTING.md
│
├── create-component/
│   ├── SKILL.md
│   └── assets/
│       └── component-template.tsx
│
└── database-migration/
    ├── SKILL.md
    └── scripts/
        ├── migrate-up.sh
        └── migrate-down.sh
```

**Locations:**
- **Project skills:** `.github/skills/` (shared with team)
- **Personal skills:** `~/.copilot/skills/` (user-specific)

## SKILL.md Format

```yaml
---
# Required fields
name: fix-issue                    # 1-64 chars, lowercase alphanumeric + hyphens
                                   # No consecutive hyphens, can't start/end with hyphen
                                   # Should typically match parent folder name
description: Fix a GitHub issue by number  # 1-1024 chars, describe capability AND when to use

# Optional fields
license: Apache-2.0
compatibility: Requires git, gh CLI  # Max 500 chars
allowed-tools: Read, Grep, Glob, Bash, Edit  # Experimental
metadata:
  author: your-org
  version: "1.0"
  tags: [github, workflow]
---

# Fix GitHub Issue

Fix the specified issue by reading it, implementing the fix, and creating a commit.

## Steps

1. Read issue details: `gh issue view $ARGUMENTS`
2. Understand requirements and acceptance criteria
3. Find relevant code locations
4. Implement the fix
5. Write or update tests
6. Run tests: `npm test`
7. Create commit with conventional format

## Reference Files
- [Contributing Guide](references/CONTRIBUTING.md)

## Validation
Run `scripts/validate.sh` before committing.
```

### Frontmatter Field Reference

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | Yes | 1-64 chars, lowercase alphanumeric + hyphens, should typically match folder |
| `description` | Yes | 1-1024 chars, describe capability AND trigger |
| `license` | No | License name or path to bundled file |
| `compatibility` | No | 1-500 chars, environment requirements |
| `allowed-tools` | No | Space-delimited tool list (experimental, **not supported in VS Code**) |
| `metadata` | No | Arbitrary key-value pairs for extensions |

## Best Practices

### 1. Keep Skills Concise

Context window is shared across system prompt, conversation history, active skills, and your request.

| Guideline | Reason |
|-----------|--------|
| **Under 500 lines / 5000 tokens** | Optimal performance, preserves context budget |
| **Assume intelligence** | Claude is smart — only add context it doesn't have |
| **One capability per skill** | Single responsibility, easier to compose |

### 2. Set Appropriate Degrees of Freedom

Match instruction precision to task fragility:

| Freedom Level | Format | When to Use |
|---------------|--------|-------------|
| **High** | Text instructions | Multiple valid approaches, context-dependent |
| **Medium** | Pseudocode | Preferred pattern exists, some variation OK |
| **Low** | Specific scripts | Fragile operations, exact sequence required |

**Example — High Freedom:**
```markdown
## Error Handling
Handle errors appropriately for the context. Log errors with sufficient
detail for debugging. Consider retry logic for transient failures.
```

**Example — Low Freedom:**
```markdown
## Database Migration
Execute exactly:
1. `npm run db:backup` — Create backup first
2. `npm run db:migrate` — Run migrations
3. `npm run db:verify` — Verify schema
4. If verify fails: `npm run db:rollback`
```

### 3. Progressive Disclosure

SKILL.md serves as an overview. Load detailed materials on demand.

```markdown
# Component Generator

Generate React components following project patterns.

## Quick Reference
- Functional components only
- Named exports
- Props interface required

## Detailed Patterns
See [Component Patterns](references/patterns.md) for extended examples.
See [Testing Guide](references/testing.md) for test structure.
```

**Rules:**
- SKILL.md = overview and entry point
- Reference files = detailed materials loaded when needed
- Keep references one level deep (no nested reference chains)

## Complete Examples

### Code Review Skill

```yaml
---
name: code-review
description: Review code changes for quality, security, and best practices
allowed-tools: Read, Grep, Search
metadata:
  version: "1.0"
---

# Code Review

Perform thorough code review focusing on correctness, security, and maintainability.

## Review Checklist

### Correctness
- [ ] Logic handles edge cases
- [ ] Error handling is appropriate
- [ ] Types are correct and complete

### Security
- [ ] No hardcoded secrets
- [ ] Input is validated
- [ ] SQL queries are parameterized
- [ ] User input is sanitized

### Maintainability
- [ ] Code is readable without comments
- [ ] Functions have single responsibility
- [ ] No code duplication

## Output Format

```markdown
## Review Summary
**Overall:** ✅ Approve | ⚠️ Request Changes | ❌ Reject

## Issues Found
### [Severity] Title
**File:** `path/to/file.ts:42`
**Issue:** Description
**Suggestion:** How to fix
```
```

### API Endpoint Skill

```yaml
---
name: create-api-endpoint
description: Create a new REST API endpoint with validation and tests
compatibility: Express, TypeScript
allowed-tools: Read, Edit, Bash
---

# Create API Endpoint

Generate a complete API endpoint with route handler, validation, service layer, and tests.

## Generated Files

| File | Purpose |
|------|---------|
| `src/routes/{resource}.ts` | Route handler |
| `src/services/{resource}Service.ts` | Business logic |
| `src/validators/{resource}Schema.ts` | Zod validation |
| `tests/routes/{resource}.test.ts` | Integration tests |

## Route Handler Template
```typescript
import { Router } from 'express';
import { z } from 'zod';
import { {Resource}Service } from '../services/{resource}Service';
import { {Resource}Schema } from '../validators/{resource}Schema';

const router = Router();

router.post('/', async (req, res, next) => {
  try {
    const validated = {Resource}Schema.parse(req.body);
    const result = await {Resource}Service.create(validated);
    res.status(201).json(result);
  } catch (error) {
    next(error);
  }
});

export default router;
```

## After Generation
1. Register route in `src/routes/index.ts`
2. Run tests: `npm test -- {resource}`
3. Update API documentation
```

### Database Migration Skill

```yaml
---
name: database-migration
description: Create and run database migrations safely
compatibility: PostgreSQL, Prisma
allowed-tools: Bash, Read, Edit
---

# Database Migration

Create and execute database migrations with safety checks.

## ⚠️ Safety Protocol

**Before ANY migration:**
1. Backup: `scripts/backup.sh`
2. Review: Check migration SQL
3. Test: Run on staging first

## Creating a Migration

```bash
# Generate migration from schema changes
npx prisma migrate dev --name {migration_name}

# Create empty migration for custom SQL
npx prisma migrate dev --create-only --name {migration_name}
```

## Migration Script Template

```sql
-- Migration: {name}
-- Description: {what this migration does}

-- Up
ALTER TABLE users ADD COLUMN email_verified BOOLEAN DEFAULT false;
CREATE INDEX idx_users_email ON users(email);

-- Down (for rollback)
DROP INDEX idx_users_email;
ALTER TABLE users DROP COLUMN email_verified;
```

## Rollback Procedure

If migration fails:
```bash
# Check migration status
npx prisma migrate status

# Rollback last migration
npx prisma migrate reset --skip-seed

# Restore from backup if needed
scripts/restore.sh
```
```

## Enable Skills in VS Code

Add to `.vscode/settings.json`:

```jsonc
{
  // Enable agent skills (Experimental feature)
  "chat.useAgentSkills": true
}
```

**Status:** Agent Skills support in VS Code is currently in **preview** (experimental). The feature is available in VS Code Insiders; stable VS Code support is coming soon. Skill locations are fixed at `.github/skills/` (project) and `~/.copilot/skills/` (personal).

**Validate Skills:** Use the official validation tool:
```bash
# Install the skills reference library (Python)
pip install skills-ref

# Validate a skill
skills-ref validate ./my-skill
```

## Asset Size Limits

| Constraint | Limit | Source |
|------------|-------|--------|
| Total skill size | No hard limit | agentskills.io spec |
| SKILL.md body | < 500 lines / 5000 tokens | agentskills.io spec |

## Platform Adoption

The agentskills.io standard is adopted by multiple platforms:

| Category | Platforms |
|----------|----------|
| **Microsoft** | VS Code, GitHub Copilot CLI, GitHub Copilot Coding Agent |
| **Third-Party Agents** | Cursor, Goose, Amp, OpenCode, Letta |

<!-- NOT IN OFFICIAL DOCS: 15+ platforms claim - actual documented adopters ~7-8 - flagged 2026-01-24 -->

**Organization/Enterprise Skills:** Coming soon per [GitHub docs](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills).

## Related

- [agent-file-format](agent-file-format.md) — Agents can reference skills
- [file-structure](file-structure.md) — Complete `.github/` folder organization
- [settings-reference](settings-reference.md) — Settings that enable skills
- [collections-format](../REFERENCE/collections-format.md) — Bundle skills for distribution
- [just-in-time-retrieval](../CONTEXT-ENGINEERING/just-in-time-retrieval.md) — Progressive disclosure pattern

## Sources

- [agentskills.io Specification](https://agentskills.io/specification)
- [VS Code - Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [Claude Agent Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [github/awesome-copilot](https://github.com/github/awesome-copilot)
