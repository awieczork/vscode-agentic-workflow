# Instruction Structure Reference

Syntax and format specifications for instruction files.

---

## Two Instruction Types

### Repo-Wide (`copilot-instructions.md`)

**Location:** `.github/copilot-instructions.md`

**Frontmatter:** NONE — plain Markdown only. First line must NOT be `---`.

**Scope:** All chat requests in workspace when VS Code setting enabled.

**Setting:** `github.copilot.chat.codeGeneration.useInstructionFiles`

**Size:** Target 100-150 lines, maximum 200 lines.

### Path-Specific (`*.instructions.md`)

**Location:** `.github/instructions/*.instructions.md`

**Frontmatter:** Optional YAML with `applyTo`, `name`, `description` fields.

**Scope:** Files matching `applyTo` glob pattern.

**Auto-apply:** Only when `applyTo` is specified.

**Size:** Target 50-100 lines, maximum 150 lines.

---

## Frontmatter Schema (Path-Specific Only)

All fields are optional, but `applyTo` is required for auto-apply behavior.

```yaml
---
applyTo: "[GLOB_PATTERN]"    # Required for auto-apply
name: "[DISPLAY_NAME]"       # Optional, defaults to filename
description: "[PURPOSE]"     # Optional, 50-150 characters
---
```

**Field constraints:**
- `applyTo` — Valid glob pattern (see Glob Reference below)
- `name` — 3-50 characters
- `description` — 50-150 characters

---

## Glob Pattern Reference

### Operators

- `*` — Any characters in single path segment (`*.ts`)
- `**` — Any path segments, recursive (`**/*.ts`)
- `?` — Single character (`file?.ts`)
- `{}` — Alternatives (`*.{ts,tsx}`)
- `[]` — Character set (`file[0-9].ts`)
- `,` — Multiple patterns (`**/*.ts,**/*.tsx`)

### Common Patterns

- All TypeScript: `**/*.ts`
- TypeScript + TSX: `**/*.{ts,tsx}`
- Specific directory: `src/**/*.ts`
- Test files: `**/*.{test,spec}.ts`
- Config files: `**/*.config.{js,ts}`
- Markdown in folder: `.github/**/*.md`

### Invalid Patterns (P1 Blocking)

- `**` alone — Matches all files, defeats Path-Specific purpose
- `*` alone — Too broad, no file type constraint
- Regex syntax (`\d`, `^`, `$`) — Not supported
- Negation prefix (`!`) — Not supported

---

## Layer System

Match output depth to specification complexity.

### L0 — Valid (Minimum Viable)

- Correct location and filename
- Frontmatter format matches type (none for Repo-Wide)
- Basic rules present (3+ items)

**Use when:** Simple, focused rules for one concern.

### L1 — Good (Production-Ready)

L0 requirements plus:
- `applyTo` specified (Path-Specific)
- Imperative voice throughout
- Rules are specific and actionable
- ALWAYS/NEVER for safety-critical rules
- Size within limits

**Use when:** Standard instruction file for team use.

### L2 — Excellent (Full Quality)

L1 requirements plus:
- Code examples (correct/incorrect pairs) for ambiguous rules
- Anti-patterns section for common mistakes
- Stackability verified (no conflicts with existing instructions)
- Optimized token economy (no redundant content)

**Use when:** Complex standards, multiple team members, high visibility.

---

## Size Thresholds

**Path-Specific:**
- Target: 50-100 lines (optimal)
- Recommend split: 100 lines (evaluate by concern)
- Maximum: 150 lines (mandatory split)

**Repo-Wide:**
- Target: 100-150 lines (optimal)
- Recommend split: 150 lines (evaluate by concern)
- Maximum: 200 lines (mandatory split)

**Splitting guidance:**
- Split by file type when rules serve different extensions
- Split by concern when rules cover distinct domains (security vs style)
- Extract to Repo-Wide when rule applies to 3+ file types

---

## Section Patterns

### Repo-Wide Sections

```markdown
## Project Context
[Project] uses [tech stack with versions].

## Code Style
- [Rule 1]
- [Rule 2]

## Commands
- Build: `[command]`
- Test: `[command]`

## Safety Rules
- NEVER [constraint]
- ALWAYS [behavior]
```

### Path-Specific Sections

```markdown
# [Title]

[One-line summary]

## Core Rules
- [Rule 1]
- [Rule 2]
- [Rule 3]

## Code Standards

### Correct
```[language]
[correct example]
```

### Incorrect
```[language]
[incorrect example]
```

## Anti-Patterns
- [Pattern to avoid]: [Why]
```

---

## Loading Directives

Instructions auto-load based on:

**Repo-Wide:** VS Code setting `github.copilot.chat.codeGeneration.useInstructionFiles` enabled.

**Path-Specific:** Files matching `applyTo` pattern are in context (open, attached, or referenced).

**Stacking:** Multiple instructions load simultaneously. Order is non-deterministic. Design rules to be self-contained.

---

## Cross-References

- [validation-checklist.md](validation-checklist.md) — P1/P2/P3 checks
- [instruction-template.md](../../../knowledge-base/artifacts/instruction-template.md) — Base templates
- [instruction-patterns.md](../../../knowledge-base/artifacts/instruction-patterns.md) — Design decisions
