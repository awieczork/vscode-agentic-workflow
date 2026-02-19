Structural specification for instruction artifacts (`.instructions.md`). Covers frontmatter fields, discovery modes, body structure, scoping strategies, and design boundaries. Instruction-only — no other artifact types.


<frontmatter>

Instruction frontmatter is YAML between `---` fences. All string values use single quotes. Every field is optional — unique among framework artifact types. Omit frontmatter entirely for manual-only instructions.

- **`applyTo`** (string, optional) — VS Code glob pattern or comma-separated patterns. Triggers file-based discovery. Example: `'**/*.ts'`, `'src/api/**'`, `'**/*.ts,**/*.tsx'`
- **`description`** (string, optional) — Semantic matching phrase. Formula: "{verb} {scope} {concern}". Max 1024 chars. Example: `'Enforces TypeScript type-safety conventions'`
- **`name`** (string, optional) — Display name. Rarely needed — omit unless disambiguation is required. Example: `'typescript-conventions'`

**Example — both discovery modes**

```yaml
---
applyTo: '**/*.ts,**/*.tsx'
description: 'Enforces TypeScript type-safety conventions'
---
```

**Example — file-triggered only**

```yaml
---
applyTo: 'src/api/**'
---
```

**Example — on-demand only**

```yaml
---
description: 'Governs error handling patterns for REST endpoints'
---
```

</frontmatter>


<discovery_modes>

Instructions attach to conversations through four discovery modes. Choose the mode that matches how the instruction should activate.

- **File-triggered** — `applyTo` only. Auto-attaches when matching files are open. Use when rules apply to specific file types or directories regardless of task
- **On-demand** — `description` only. Semantic matching to user prompts. Use when rules are domain-specific and only relevant when the user asks about that domain
- **Both** — `applyTo` + `description`. File match OR semantic match. **Recommended default.** Use when rules are scoped to files but also relevant to domain questions
- **Manual** — No frontmatter. Only when user explicitly references the file. Use for internal instructions consumed by other artifacts, not meant for automatic discovery

Choose "Both" unless there is a specific reason to restrict. File-triggered alone misses prompt-based conversations about the domain. On-demand alone misses file-editing sessions where the rules should apply silently.

</discovery_modes>


<body_structure>

Instruction bodies provide ambient constraints — rules that apply passively throughout a conversation. No markdown headings (`#`) in the body.

**Prose intro** — 1-2 imperative sentences before any XML tag. State the instruction's purpose and governing principle. No hedging, no conditionals. Pattern: "Enforce [concern] across [scope]. [Governing principle]."

Example:

```
Enforce type-safety conventions across all TypeScript files. Every type boundary must be explicit — no implicit `any`.
```

**Custom XML groups** — Organize rules into domain-named tags. Each tag covers exactly one concern.

- Name tags after the specific domain concern: `<type_safety>`, `<naming_conventions>`, `<error_handling>`, `<import_structure>`
- NEVER use generic tag names: `<rules>`, `<guidelines>`, `<best_practices>`, `<standards>`, `<general>`
- Each XML group contains an optional explanatory sentence followed by 3-7 bullet rules
- One concern per group — do not mix error handling with naming conventions

**Rule style** — Every rule uses binary enforcement. Prefix each bullet with NEVER or ALWAYS.

- NEVER use hedging language: "should", "prefer", "consider", "try to", "ideally", "when possible"
- ALWAYS state the rule as a direct constraint the agent must follow unconditionally
- Include inline code examples within rules when the correct form is non-obvious:

```
- ALWAYS declare return types explicitly on exported functions:
  ```typescript
  export function parse(input: string): ParseResult { ... }
  ```

```

**Complete body example**

```markdown
Enforce type-safety conventions across all TypeScript files. Every type boundary must be explicit.

<type_safety>

All public API surfaces must have explicit type annotations.

- NEVER use `any` — use `unknown` and narrow with type guards
- ALWAYS declare return types on exported functions
- ALWAYS use discriminated unions over type assertions
- NEVER use non-null assertions (`!`) — handle nullability explicitly

</type_safety>

<naming_conventions>

- ALWAYS use PascalCase for types, interfaces, and enums
- ALWAYS use camelCase for variables, functions, and parameters
- NEVER abbreviate names beyond well-known domain acronyms (e.g., `URL`, `API`)
- ALWAYS suffix type guard functions with `is` or `has`: `isValid`, `hasPermission`

</naming_conventions>
```

</body_structure>


<scoping_strategies>

Match `applyTo` granularity to the instruction's actual scope. Overly broad patterns create noise; overly narrow patterns miss files.

- **Language-wide** — `'**/*.py'` — Good. Applies to all Python files
- **Directory-scoped** — `'src/api/**'` — Good. Targets a specific concern area
- **Multi-extension** — `'**/*.ts,**/*.tsx'` — Good. Covers related file types
- **Everything** — `'**'` — Too broad. Applies to every file, dilutes relevance
- **Single-widget deep** — `'src/components/dashboard/widgets/*.tsx'` — Too narrow. Breaks when files move

**Description formula:** `"{verb} {scope} {concern}"` — e.g., `'Enforces TypeScript type-safety conventions'`, `'Governs Python import ordering in library modules'`.

**File naming convention:** `{concern}.instructions.md` — e.g., `typescript-conventions.instructions.md`, `error-handling.instructions.md`, `api-security.instructions.md`. Name reflects the concern, not the target files.

</scoping_strategies>


<not_instructions>

Instructions are ambient constraints — static rules that apply passively. They are not workflows, agents, skills, or templates.

- No `<workflow>` tag — instructions do not define task procedures or execution sequences
- No `<step_N_verb>` tags — no sequential steps; every rule applies independently
- No identity prose — instructions do not define personas, roles, or agent behavior (that is an agent's job)
- No folder structure — an instruction is a single flat `.instructions.md` file, not a folder tree like skills
- No prompt variables (`{{language}}`, `{framework}`) — instructions are static, not parameterized templates
- Not for inline code completions — instructions apply to chat interactions only

</not_instructions>


<reserved_tags>

These tags are reserved by the VS Code platform. NEVER use them in instruction bodies — they will collide with runtime injection.

`<instructions>`, `<skills>`, `<modeInstructions>`, `<toolUseInstructions>`, `<toolSearchInstructions>`, `<communicationStyle>`, `<outputFormatting>`, `<repoMemory>`, `<reminderInstructions>`, `<workflowGuidance>`, `<agents>`

</reserved_tags>
