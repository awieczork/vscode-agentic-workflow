# Skill Patterns

Rules and best practices for `SKILL.md` files.

---

## When to Use Skills

Skills are **portable procedures** loaded on-demand, not pre-loaded.

**Use skills for:**
- Reusable procedures any agent can invoke
- Multi-step workflows that cross file types
- Capabilities that should work across projects
- Context-efficient loading (JIT, not pre-loaded)

**Don't use skills for:**
- Always-on rules for file types → use Instructions
- Persistent personas with handoffs → use Agents
- One-shot templates with variables → use Prompts

---

## Design Questions

### First: Is This Really a Skill?

Test capabilities in priority order. **Stop at first YES.**

| Capability Test | If YES → | Why Not Skill |
|-----------------|----------|---------------|
| Rules for specific file patterns? | **Instruction** | Auto-applies, no invocation |
| Needs persistent persona + handoffs? | **Agent** | Identity required |
| One-shot template with placeholders? | **Prompt** | Single-use, no procedure |
| Reusable procedure, any agent? | **Skill** | Portable capability |

**Rule:** Default to Instructions if behavior can auto-apply to file types.

---

## Required Sections

Every skill needs these:

| Section | Purpose |
|---------|---------|
| YAML Frontmatter | `name` + `description` for discovery |
| H1 Title | Human-readable name |
| Overview | What + when (1-2 sentences) |
| Steps | Numbered execution sequence |
| Error Handling | Failure modes + recovery |

---

## Recommended Sections ⭐

| Section | When to Include |
|---------|-----------------|
| Reference Files | Content exceeds ~100 lines (JIT loading) |
| Validation | Success is verifiable with checks |
| Notes | Idempotency warnings, prerequisites |

**Section Order:** Frontmatter → Title → Overview → Steps → Error Handling → Reference Files → Validation

---

## Naming Rules

| Rule | Valid | Invalid |
|------|-------|---------|
| 1-64 characters | `fix-issue` | `fix-the-really-long-issue-that-needs-descriptive-name-here` |
| Lowercase + hyphens only | `database-migration` | `Database_Migration` |
| No consecutive hyphens | `fix-issue` | `fix--issue` |
| No leading/trailing hyphens | `fix-issue` | `-fix-issue-` |
| Must match folder name | `fix-issue/` + `name: fix-issue` | `fix-issue/` + `name: fixIssue` |

---

## Description Rules

**Formula:** `{Verb} {what} when {trigger/context}`

| Component | Purpose | Examples |
|-----------|---------|----------|
| **Verb** | Action performed | Fix, Run, Create, Review, Deploy |
| **What** | Capability delivered | GitHub issue, database migrations, API endpoint |
| **When** | Invocation trigger | when asked to resolve a bug, when schema changes |

**Valid:**
```
✅ "Fix a GitHub issue when asked to resolve a bug or feature request"
✅ "Run Prisma migrations when schema changes need to be applied"
✅ "Review code changes when PRs are opened or commits need verification"
```

**Invalid:**
```
❌ "Fixes issues"          → Missing WHEN trigger
❌ "Database helper"       → Missing action verb and trigger
❌ "Useful for migrations" → Vague, no clear capability
```

**Keyword Tips:** Include domain-specific keywords to improve agent matching:
- If processing PDFs → mention "PDF", "document", "extraction"
- If using specific tools → mention "Prisma", "Docker", "git"
- Include trigger phrases → "when asked to", "when user says"

---

## Writing Style

- **Use imperative form** — "Run tests", not "You should run tests"
- **Be specific** — Include exact commands for destructive operations
- **Assume intelligence** — Add only context Claude doesn't have
- **Match precision to fragility** — See Degree of Freedom below

---

## Degree of Freedom

Match instruction precision to task fragility:

| Freedom | When to Use | Format | Example |
|---------|-------------|--------|---------|
| **High** | Multiple valid approaches | Text instructions | "Handle errors appropriately" |
| **Medium** | Preferred pattern exists | Pseudocode steps | "1. Check X 2. If Y then Z" |
| **Low** | Destructive/sequence-sensitive | Exact commands | `` `npm run db:migrate` `` |

**Rule:** Destructive operations OR sequence-sensitive tasks → use LOW freedom.

---

## Folder Structure

**One skill = One capability** per [agentskills.io](https://agentskills.io/specification) standard.

```
{skill-name}/
├── SKILL.md          # REQUIRED — entry point
├── scripts/          # Optional — executable code >20 lines
├── references/       # Optional — docs >100 lines for JIT
└── assets/           # Optional — templates, data files
```

**Decision Tree:**

| Create Folder | When |
|---------------|------|
| `scripts/` | Code block >20 lines OR runs in specific shell OR called multiple times |
| `references/` | Docs >100 lines OR detailed guide not needed every run |
| `assets/` | Templates, configs, or non-markdown resources |

**Location by Scope:**

| Scope | Path |
|-------|------|
| Project-specific | `.github/skills/{skill-name}/` |
| Personal (all projects) | `~/.copilot/skills/{skill-name}/` |
| Distribution | `skills/{skill-name}/` (root) |

---

## Size Limits

| Component | Ideal | Maximum | If Exceeded |
|-----------|-------|---------|-------------|
| Frontmatter | ~100 tokens | 200 tokens | Trim description |
| SKILL.md body | 50-150 lines | 500 lines | Extract to references/ |
| SKILL.md tokens | 500-2000 | 5000 tokens | Decompose to subfolders |
| Single reference | 100-300 lines | 500 lines | Split into multiple files |

**Progressive Disclosure:**

| Location | Load Time | Token Budget |
|----------|-----------|--------------|
| Frontmatter | Always (discovery) | ~100 tokens |
| SKILL.md body | On invoke | <5000 tokens |
| references/ | JIT on demand | Unlimited |
| scripts/ | When executed | N/A |

---

## Anti-Patterns

```yaml
- dont: "Pre-load all content in SKILL.md"
  instead: Link to references/, load JIT
  why: Wastes context budget

- dont: "Vague description ('Helps with issues')"
  instead: State capability + trigger
  why: Agent can't determine when to invoke

- dont: "Multiple responsibilities in one skill"
  instead: One capability per skill
  why: Hard to compose

- dont: "Skip error handling"
  instead: Document failure modes
  why: Silent failures corrupt state

- dont: "Use allowed-tools in frontmatter"
  instead: Agent-level tool restrictions
  why: Not supported in VS Code

- dont: "Exceed 500 lines"
  instead: Decompose to scripts/references/
  why: Starves other context

- dont: "Nest references (file → file → file)"
  instead: One level deep only
  why: Complexity explosion

- dont: "Hardcode paths or secrets"
  instead: Environment variables
  why: Not portable, security risk
```

---

## Cross-References

- [README.md](README.md) — Quick start guide
- [TEMPLATE.md](TEMPLATE.md) — Format, structure, examples
- [CHECKLIST.md](CHECKLIST.md) — Validation checklist
- [TAGS-SKILL.md](../TAGS-SKILL.md) — Tag vocabulary

---

## Validation

Use the official CLI tool to validate skills:

```bash
# Install skills-ref
npm install -g @agentskills/skills-ref

# Validate a skill
skills-ref validate ./my-skill
```

---

## Sources

- [VS Code Agent Skills][vscode-docs] — Official docs (preview feature)
- [agentskills.io Specification][agentskills] — Open standard
- [skills-ref CLI][skills-ref] — Validation tool
- [github/awesome-copilot][awesome-copilot] — Community examples
- [skills-format.md][skills-format] — Core structure, frontmatter

<!-- Reference Links -->
[vscode-docs]: https://code.visualstudio.com/docs/copilot/customization/agent-skills
[agentskills]: https://agentskills.io/specification
[skills-ref]: https://github.com/agentskills/agentskills/tree/main/skills-ref
[awesome-copilot]: https://github.com/github/awesome-copilot
[skills-format]: ../../cookbook/CONFIGURATION/skills-format.md
