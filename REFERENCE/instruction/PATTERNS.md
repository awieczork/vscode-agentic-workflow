# Instruction Patterns

Rules and best practices for GitHub Copilot instruction files.

---

## When to Use Instructions

Instructions are **persistent behavioral rules** that auto-apply to matching files.

**Use instructions for:**
- Language/framework coding standards (TypeScript, Python, React)
- Project-wide safety rules (never commit secrets)
- File-type conventions (test patterns, API standards)
- Rules that should apply WITHOUT user action

**Don't use instructions for:**
- Personas with identity → use **Agents**
- Reusable procedures with scripts → use **Skills**
- One-shot templates with variables → use **Prompts**

---

## Component Selection

Test in order. **Stop at first YES.**

| Test | If YES → | Why Not Instruction |
|------|----------|---------------------|
| Needs runtime variables (`${input:}`)? | **Prompt** | Instructions can't accept parameters |
| Needs bundled scripts/assets? | **Skill** | Instructions are text-only |
| Needs persona, tools, or handoffs? | **Agent** | Instructions have no identity |
| Auto-applies rules to file types? | **Instruction** | ✅ Correct choice |

**Rule:** Default to Instruction. Only escalate if you need capabilities instructions lack.

---

## Two Instruction Types

### Type 1: Repo-Wide (`copilot-instructions.md`)

**Location:** `.github/copilot-instructions.md`

| Aspect | Detail |
|--------|--------|
| Frontmatter | ❌ **None** — plain Markdown only |
| Scope | ALL chat requests in workspace |
| Auto-apply | Yes, when setting enabled |
| Setting | `github.copilot.chat.codeGeneration.useInstructionFiles` |
| Use for | Project context, tech stack, shared standards |

### Type 2: Path-Specific (`*.instructions.md`)

**Location:** `.github/instructions/*.instructions.md`

| Aspect | Detail |
|--------|--------|
| Frontmatter | ✅ YAML supported (`applyTo`, `name`, `description`) |
| Scope | Files matching `applyTo` glob pattern |
| Auto-apply | Only when `applyTo` is specified |
| Use for | Language rules, folder conventions, test standards |

---

## Design Questions

| You're Defining... | Answers Go To | Key Considerations |
|--------------------|---------------|-------------------|
| What files does this apply to? | `applyTo` frontmatter | Glob pattern targeting |
| What should Copilot always do? | Body content | Positive, imperative rules |
| What should Copilot never do? | Body content | Strong language (NEVER) |
| Is this code review or coding? | `excludeAgent` | GitHub.com only |

---

## Glob Pattern Reference

### Operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `*` | Any characters in single segment | `*.ts` |
| `**` | Any path segments (recursive) | `**/*.ts` |
| `?` | Single character | `file?.ts` |
| `{}` | Alternatives | `*.{ts,tsx}` |
| `[]` | Character set | `file[0-9].ts` |
| `,` | Multiple patterns | `**/*.ts,**/*.tsx` |

### Common Patterns

| Use Case | Pattern |
|----------|---------|
| All files | `**` or `**/*` |
| Single extension | `**/*.ts` |
| Multiple extensions | `**/*.{ts,tsx}` |
| Specific directory | `src/**/*.ts` |
| Test files | `**/*.{test,spec}.ts` |
| Any named folder | `**/components/**/*.tsx` |

### Limitations

| Feature | Status |
|---------|--------|
| `!` negation prefix | ❌ Not supported |
| Exclude patterns | ❌ Not available |
| Regex | ❌ Not supported |
| Brace sequences (`{1..5}`) | ❌ Not supported |

---

## Frontmatter Schema (Path-Specific Only)

```yaml
---
applyTo: "**/*.ts"           # Optional: glob for auto-apply
name: "TypeScript Rules"     # Optional: display name
description: "..."           # Optional: UI description
excludeAgent: "code-review"  # GitHub.com ONLY
---
```

### `excludeAgent` Values (GitHub.com)

| Value | Effect |
|-------|--------|
| `"code-review"` | Exclude from Copilot code review |
| `"coding-agent"` | Exclude from Copilot coding agent |

**Note:** This field is GitHub.com-only. VS Code ignores it.

---

## Content Structure

**Effective sections:**
1. Purpose/context (1-2 sentences)
2. Core rules (bullet list)
3. Code examples (good/bad pairs)
4. Anti-patterns (optional)

**Format:**
- Use markdown headings, lists, tables
- Include code examples with language hints
- Use ✅/❌ for quick scanning

---

## Size Limits

| Limit | Recommended | Maximum |
|-------|-------------|---------|
| Repo-wide | 100-200 lines | ~2 pages |
| Path-specific | 50-100 lines | 150 lines |

**When to split:** If file exceeds 150 lines, split by file type or concern.

---

## Anti-Patterns

```yaml
- dont: "Frontmatter in copilot-instructions.md"
  instead: Plain markdown, no YAML header
  why: Repo-wide file doesn't support frontmatter

- dont: "Path-specific without applyTo"
  instead: Always include applyTo for auto-apply
  why: Without it, instructions require manual attachment

- dont: "Persona/identity in instructions"
  instead: Use Agent for roles with persona
  why: Instructions are rules, not identities

- dont: "Vague guidance ('be helpful', 'modern practices')"
  instead: Specific actionable rules with versions
  why: LLMs ignore vague instructions

- dont: "All rules in one copilot-instructions.md"
  instead: Split by file type using path-specific files
  why: Better targeting, less noise per request

- dont: "Secrets, internal URLs, proprietary info"
  instead: Reference by name ('use API_KEY from .env')
  why: Instructions are sent to LLM — exposure risk
```

---

## Platform Support

| Feature | VS Code | GitHub.com | JetBrains |
|---------|:-------:|:----------:|:---------:|
| Repo-wide | ✅ | ✅ | ✅ |
| Path-specific | ✅ | ✅* | ✅ |
| `excludeAgent` | ❌ | ✅ | ❌ |
| Auto-apply | ✅ | ✅ | ✅ |

*GitHub.com path-specific only for Coding Agent and Code Review, not Chat.

---

## Cross-References

- [README.md](README.md) — Quick start guide
- [TEMPLATE.md](TEMPLATE.md) — Format and structure
- [CHECKLIST.md](CHECKLIST.md) — Validation checklist
- [TAGS-INSTRUCTION.md](../TAGS-INSTRUCTION.md) — Tag vocabulary
