# Instruction Template

Format specification and templates for instruction files.

---

## Frontmatter Schema (Path-Specific Only)

```yaml
---
applyTo: "**/*.ts"           # Optional: glob pattern for auto-apply
name: "Display Name"         # Optional: shown in UI (defaults to filename)
description: "Short desc"    # Optional: UI description
excludeAgent: "code-review"  # GitHub.com only: "code-review" | "coding-agent"
---
```

**Note:** Frontmatter is for `*.instructions.md` files only. `copilot-instructions.md` uses NO frontmatter.

---

## Path-Specific Template (Full)

```markdown
---
applyTo: "{glob_pattern}"
name: "{Display Name}"
description: "{50-150 char purpose}"
---

# {Display Name}

> {One-line summary of what these rules cover}

## Core Rules

- {Rule 1 — specific, actionable}
- {Rule 2 — use ALWAYS/NEVER for emphasis}
- {Rule 3 — include versions when relevant}

## Code Standards

### Good Example

```{language}
// ✅ Recommended approach
{correct_code_example}
```

### Bad Example

```{language}
// ❌ Avoid this pattern
{incorrect_code_example}
```

## Anti-Patterns

- ❌ {What NOT to do}
- ❌ {Another anti-pattern}
```

---

## Path-Specific Template (Minimal)

For focused, single-purpose instruction files:

```markdown
---
applyTo: "{glob_pattern}"
---

# {Title}

- {Rule 1}
- {Rule 2}
- {Rule 3}
```

---

## Repo-Wide Template

**File:** `.github/copilot-instructions.md`

**⚠️ NO FRONTMATTER** — plain Markdown only.

```markdown
## Project Context

{Project name} uses {tech stack with versions}.

## Code Style

- {Style rule 1}
- {Style rule 2}

## Commands

- Build: `{build_command}`
- Test: `{test_command}`
- Lint: `{lint_command}`

## Safety Rules

- **NEVER** {critical constraint}
- **ALWAYS** {required behavior}
```

---

## Placeholders

| Placeholder | Example Values |
|-------------|----------------|
| `{glob_pattern}` | `**/*.ts`, `src/**/*.py`, `**/*.{ts,tsx}` |
| `{Display Name}` | TypeScript Rules, Python Standards |
| `{language}` | typescript, python, javascript |

---

## Cross-References

- [README.md](README.md) — Quick start guide
- [PATTERNS.md](PATTERNS.md) — Rules and best practices
- [CHECKLIST.md](CHECKLIST.md) — Validation checklist
- [TAGS-INSTRUCTION.md](../TAGS-INSTRUCTION.md) — Tag vocabulary
