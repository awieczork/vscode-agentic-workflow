**Exemplar — Gold Reference Instruction**

> Study the embedded instruction below alongside the annotations that follow. Every structural observation refers to sections within this file. Observe the patterns, then apply them to your own instruction.


## Embedded Exemplar: sql-conventions.instructions.md

````markdown
---
applyTo: '**/*.sql'
description: 'Enforces SQL query style, schema design, and safety conventions for all SQL files'
---

Write predictable, reviewable SQL. The governing principle is explicit contracts — every query states its intent, every schema change is reversible, every operation guards against data loss.


<query_style>

Query formatting rules enforce readability and consistent review diffs.

- ALWAYS place each column in a SELECT on its own line — one column per line, no comma-first formatting
- NEVER use `SELECT *` in application queries — enumerate columns explicitly to prevent silent schema-drift breakage
- ALWAYS alias every subquery and every joined table — bare table references in multi-table queries are ambiguous
- ALWAYS use ANSI JOIN syntax (`JOIN ... ON`) — NEVER place join conditions in the WHERE clause
- NEVER rely on implicit column ordering in INSERT statements — ALWAYS specify the column list explicitly

</query_style>


<schema_design>

Schema and DDL rules enforce safe, self-documenting table structures.

- ALWAYS define a primary key on every table — no heap tables in production
- NEVER use generic column names (`data`, `value`, `info`) — name columns after the business concept they represent
- ALWAYS add a NOT NULL constraint unless the column has a documented reason for allowing nulls
- ALWAYS include `created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP` on every new table — omit only with explicit justification

</schema_design>


<safety_guards>

Safety and performance rules prevent destructive operations and slow queries.

- NEVER execute DELETE or UPDATE without a WHERE clause — wrap data-modifying statements in a transaction with a preceding SELECT count to verify scope
- ALWAYS add IF EXISTS / IF NOT EXISTS guards to DDL statements — migrations must be re-runnable without failure
- NEVER add an index on a high-write table without confirming the index does not already exist and documenting the expected read pattern it serves
- ALWAYS use parameterized queries — NEVER interpolate user input into SQL strings, regardless of sanitization

</safety_guards>
````


## Structural Annotations

**Frontmatter choices** — Two fields: `applyTo` and `description`. Notice there is no `name` field — instruction names are optional and rarely needed because VS Code derives identity from file name and location. The `description` follows the "{verb} {scope} {concern}" formula: "Enforces" (verb) "SQL query style, schema design, and safety conventions" (scope) "for all SQL files" (concern). Both fields are single-quoted strings.

**Discovery mode** — This instruction uses the "both" discovery mode — the recommended default for most instruction files. "Both" means the instruction activates in two ways: (1) file-triggered, when any file matching the `applyTo` glob (`**/*.sql`) enters the AI's context, and (2) on-demand, when the AI's semantic matching determines the `description` text is relevant to the current task. Using both fields gives maximum coverage — the instruction fires automatically when editing SQL files and is also discoverable when discussing SQL topics without a file open.

**Prose intro** — Two imperative sentences between frontmatter and the first XML group. The first sentence states the directive ("Write predictable, reviewable SQL"). The second states the governing principle ("explicit contracts") and expands it into three concrete commitments that preview the groups below. This prose grounds the AI's behavior before it encounters specific rules — establishing intent so edge cases not covered by individual bullets still get handled in the right spirit.

**XML group naming** — Groups are named after the specific concern they address: `<query_style>`, `<schema_design>`, `<safety_guards>`. Notice these are domain terms a SQL developer would recognize, not generic labels like `<rules>` or `<guidelines>`. Each group covers exactly one concern — formatting goes in `query_style`, DDL conventions in `schema_design`, defensive patterns in `safety_guards`. One concern per group makes it possible to add, remove, or reorder groups without side effects.

**Group structure** — Each XML group opens with a brief explanatory sentence that states the group's purpose and rationale, then provides 3–5 NEVER/ALWAYS bullet rules. The opening sentence is not a rule itself — it frames why the rules exist, giving the AI context for edge-case reasoning. Rules within a group are ordered from most common scenario to least common.

**Rule style** — Every rule uses NEVER or ALWAYS — no "should", "prefer", "consider", or "try to". Binary enforcement produces higher LLM compliance than graduated guidance because it eliminates the ambiguity of when to follow versus when to deviate. Notice that some rules include inline code examples (`JOIN ... ON`, `IF EXISTS`) — these anchor abstract instructions to concrete syntax, reducing misinterpretation. Each rule states one prohibition or mandate; compound rules are split into separate bullets.

**Scoping decisions** — The `applyTo` glob `**/*.sql` targets all SQL files at any depth. This is the right granularity for language-convention instructions: broad enough to cover the entire SQL surface area, narrow enough to avoid firing on unrelated file types. A broader glob like `**` would attach these rules to every file. A narrower glob like `src/db/migrations/*.sql` would miss ad-hoc query files. When conventions apply to a language, scope to the language's file extension.

**What's absent** — Notice what this instruction does not contain: no `<workflow>` or `<step_N_verb>` tags (those belong in skills, which orchestrate multi-step processes), no identity prose or persona ("You are a SQL expert..."), no markdown headings in the body (the prose intro and XML groups provide all necessary structure), and no prompt variables or template placeholders (instructions are static artifacts). This is the key structural difference between instructions and skills — instructions are ambient constraints that shape behavior; skills are procedural workflows that direct action.
