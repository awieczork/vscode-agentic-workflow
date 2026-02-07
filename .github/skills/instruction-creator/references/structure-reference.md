This file defines syntax for both instruction types: Repo-Wide (global, no frontmatter) and Path-Specific (file-pattern triggered, YAML frontmatter). Start with `<two_instruction_types>` to determine which applies, then reference grouped format and glob patterns from subsequent sections.


<two_instruction_types>

**Repo-Wide** (`copilot-instructions.md`)
- **Location:** `.github/copilot-instructions.md`
- **Frontmatter:** NONE — first line must NOT be `---`
- **Scope:** All chat requests in workspace when VS Code setting enabled
- **Setting:** `github.copilot.chat.codeGeneration.useInstructionFiles`

**Path-Specific** (`*.instructions.md`)
- **Location:** `.github/instructions/*.instructions.md`
- **Frontmatter:** YAML with `description` (required), `applyTo` (optional), `name` (optional)
- **Scope:** Files matching `applyTo` glob pattern, or on-demand by task relevance
- **Auto-apply:** Only when `applyTo` is specified; instructions without `applyTo` are on-demand only

</two_instruction_types>


<frontmatter_schema>

Path-Specific only. The `description` field is required (enables on-demand discovery). The `applyTo` field is optional (enables file-triggered discovery). The `name` field is optional.

```yaml
---
description: "[PURPOSE]"     # Required, enables on-demand discovery
applyTo: "[GLOB_PATTERN]"    # Optional, enables file-triggered discovery
name: "[DISPLAY_NAME]"       # Optional, defaults to filename
---
```

**Field constraints:**
- `description` — 50-150 characters, single-line. Use "Use when [TASK]. [SUMMARY]." pattern for on-demand discovery
- `applyTo` — Valid glob pattern (see `<glob_pattern_reference>`)
- `name` — 3-50 characters

**Discovery modes:**
- **On-demand** — `description` only, no `applyTo`. Discovered by task relevance matching.
- **File-triggered** — `applyTo` only or both. Auto-loads when matching files in context.
- **Hybrid** — Both fields. Supports both discovery methods.

</frontmatter_schema>


<glob_pattern_reference>

**Operators:**
- `*` — Any characters in single path segment (`*.ts`)
- `**` — Any path segments, recursive (`**/*.ts`)
- `?` — Single character (`file?.ts`)
- `{}` — Alternatives (`*.{ts,tsx}`)
- `[]` — Character set (`file[0-9].ts`)
- `,` — Multiple patterns (`**/*.ts,**/*.tsx`)

**Common patterns:**
- All TypeScript: `**/*.ts`
- TypeScript + TSX: `**/*.{ts,tsx}`
- Specific directory: `src/**/*.ts`
- Test files: `**/*.{test,spec}.ts`
- Config files: `**/*.config.{js,ts}`
- Markdown in folder: `.github/**/*.md`

**Invalid patterns (P1 blocking):**
- `**` alone — Matches all files, defeats Path-Specific purpose
- `*` alone — Too broad, no file type constraint
- Regex syntax (`\d`, `^`, `$`) — Not supported
- Negation prefix (`!`) — Not supported

</glob_pattern_reference>


<grouped_format>

Both instruction types use named groups as their exclusive structural system. No markdown headings anywhere.

**Group structure:**

```markdown
<group_name>

<rules>

- [Rule 1 — imperative voice]
- [Rule 2 — specific, actionable]
- [Rule 3]

</rules>

<justification>

[2-4 sentences — include ONLY for rules that deviate from training defaults]

</justification>

<benefit>

[1-2 sentences stating concrete outcome]

</benefit>

<anti_patterns>

- Wrong: [bad pattern] → Correct: [good pattern]

</anti_patterns>

</group_name>
```

**Required elements:**
- `<rules>` — Always required. Bullet list of imperative rules.

**Optional elements:**
- `<justification>` — Include only when rules deviate from training defaults. 2-4 sentences.
- `<benefit>` — 1-2 sentences stating concrete outcome. Include for non-obvious benefits.
- `<anti_patterns>` — Wrong/Correct pairs with em-dash. Include for ambiguous rules.

**Tag naming:**
- Use domain-specific, descriptive names: `<type_safety>`, `<migration_rules>`, `<api_conventions>`
- Avoid overly generic names that conflict when instructions stack: `<rules>` alone, `<examples>` alone
- Pattern: `<{domain}_{concern}>` or `<{specific_concept}>`

</grouped_format>


<section_patterns>

**Repo-Wide body:** Opening prose paragraph, then named groups. No frontmatter.

```markdown
Opening prose paragraph stating project purpose and governing principle.


<project_context>

<rules>

- [Project] uses [tech stack with versions]
- Build: `[command]`
- Test: `[command]`

</rules>

</project_context>


<code_style>

<rules>

- [Rule 1]
- [Rule 2]

</rules>

<anti_patterns>

- Wrong: [bad pattern] → Correct: [good pattern]

</anti_patterns>

</code_style>


<safety_constraints>

<rules>

- NEVER [constraint]
- ALWAYS [behavior]

</rules>

</safety_constraints>
```

**Path-Specific body:** Frontmatter, opening prose paragraph, then named groups.

```markdown
---
applyTo: "**/*.ts"
description: "TypeScript coding standards for all TypeScript files"
---

Opening prose paragraph stating purpose and governing principle.


<type_safety>

<rules>

- Use `interface` for object shapes that may be extended
- Use `type` for unions, intersections, and mapped types
- Prefer `unknown` over `any` — narrow types explicitly

</rules>

<justification>

Strict typing prevents runtime errors that TypeScript is designed to catch at compile time. The interface/type distinction follows TypeScript team recommendations.

</justification>

<benefit>

Type errors surface during development instead of production.

</benefit>

<anti_patterns>

- Wrong: `function process(input: any)` → Correct: `function process(input: unknown)`
- Wrong: `as Type` assertion → Correct: Type guard with narrowing

</anti_patterns>

</type_safety>
```

</section_patterns>


<layer_system>

Match output depth to specification complexity.

**L0 — Valid (minimum viable):**
- Correct location and filename
- Frontmatter format matches type (none for Repo-Wide)
- Basic rules present (3+ items)

**L1 — Good (production-ready):**
- L0 + discovery mode configured (`applyTo` for file-triggered, description for on-demand)
- Imperative voice throughout
- Rules are specific and actionable
- ALWAYS/NEVER for safety-critical rules

**L2 — Excellent (full quality):**
- L1 + Wrong/Correct example pairs for ambiguous rules
- Stackability verified (no conflicts with existing instructions)
- Optimized token economy (no redundant content)

</layer_system>


<size_thresholds>

**Path-Specific:** Target up to 100 lines. Evaluate split at 100 lines. Maximum 150 lines.

**Repo-Wide:** Target 100-150 lines. Evaluate split at 150 lines. Maximum 200 lines.

**Splitting guidance:**
- Split by file type when rules serve different extensions
- Split by concern when rules cover distinct domains (security vs style)
- Extract to Repo-Wide when rule applies to ≥3 file types

</size_thresholds>


<loading_behavior>

Instructions auto-load based on:

**Repo-Wide:** VS Code setting `github.copilot.chat.codeGeneration.useInstructionFiles` enabled.

**Path-Specific:** Files matching `applyTo` pattern are in context (open, attached, or referenced).

**Stacking:** Multiple instructions load simultaneously. Order is non-deterministic. Design rules to be self-contained.

</loading_behavior>


<references>

- [SKILL.md](../SKILL.md) — Parent skill entry point
- [validation-checklist.md](validation-checklist.md) — P1/P2/P3 checks

</references>
