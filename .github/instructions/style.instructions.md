---
applyTo: "**"
description: "Style rules for all artifacts in this AI-agent-focused repository"
---

# Artifact Style Guide

**Scope:** These rules apply to ALL files in this repository. This project is dedicated to AI agents — all generated content must be optimized for AI agent consumption.

Rules for creating and editing generated artifacts. These documents are reference material FOR AI agents, not human readers.

**Prerequisite:** Apply `<critical_rules>` from [copilot-instructions.md](../copilot-instructions.md) first.

<tag_index>

**Sections in this file:**

- `<language_rules>` — Term consistency and explicit defaults
- `<rule_priority>` — Conflict resolution hierarchy
- `<writing_patterns>` — Sentence-level writing conventions
- `<permitted_exceptions>` — Overrides to writing patterns
- `<general_formatting>` — Markdown format rules
- `<artifact_formatting>` — Artifact-specific conventions
- `<file_requirements>` — Universal file structure
- `<template_requirements>` — Template-specific rules
- `<pattern_requirements>` — Pattern file rules
- `<checklist_requirements>` — Checklist file rules

</tag_index>

<language_rules>

**One term per concept** — Pick one term, use it everywhere. Avoid synonyms.

**Explicit defaults** — "Default if omitted: [value]" for every optional field.

**Explicit conditionals** — Use direct conditional statements.
<example>
- Correct: "If X, then Y"
- Incorrect: "Y when appropriate"
</example>

</language_rules>

<rule_priority>

If rules conflict, apply in this order:

1. **Safety** — Never expose secrets, credentials, or destructive operations
2. **Accuracy** — Correct information over stylistic compliance
3. **Clarity** — Unambiguous meaning over elegant phrasing
4. **Style** — Language and formatting rules

</rule_priority>

<writing_patterns>

**Evidence-based statements** — State facts with source.
<example>
- Correct: "Per [source], X does Y" or "In 3/4 tested cases, X"
- Incorrect: "X usually does Y" or "X tends to work"
</example>

**Precise quantifiers** — Use specific numbers.
<example>
- Correct: "2-3 items", "5 checks", "1 paragraph"
- Incorrect: "several items", "some checks", "a few paragraphs"
</example>

**Active voice with explicit actor** — Name the agent performing the action.
<example>
- Correct: "The validator checks X"
- Incorrect: "X should be checked"
</example>

**Direct statements** — State the answer directly.
<example>
- Correct: "The correct approach is X"
- Incorrect: "What if we tried X?" (rhetorical)
</example>

**Bullet lists for structured data** — Convert tabular data to hierarchical bullet lists.

**Committed examples** — Choose ONE specific value.
<example>
- Correct: "typescript-standards"
- Incorrect: "e.g., typescript-standards" or "such as typescript-standards"
</example>

## Hard Constraints

- **NEVER use emojis** — Break parsing in some environments
- **NEVER use markdown tables** — Except in `<outputs>` sections per `<permitted_exceptions>`
- **NEVER use motivational language** — "This will help you..." breaks agent focus

</writing_patterns>

<permitted_exceptions>

These exceptions override `<writing_patterns>` rules:

- **Tables in `<outputs>` sections** — Permitted for agent report templates (build reports, inspection reports). These render for human readers.
- **Tables in `<criteria_checklist>` sections** — Permitted in audit/plan files for criteria matrices. Columns: ID, Criterion, Pass Condition.
- **Tables in verification summaries** — Permitted for pass/fail status matrices in inspection reports.

</permitted_exceptions>

<general_formatting>

## Forbidden Formats

- **Markdown tables** — Convert to bullet lists. Tables break rendering.
- **Starting with delimiters** — First character must be a letter (A-Z, a-z), not `---` or markers.
- **System parsing markers** — Do not output `---START` and `---END` markers.

## Permitted Formats

- **Headers** — Use freely with XML tags for additional structure.
- **Bold and italic** — Use for emphasis within content.
- **Code blocks** — Use for examples and code samples.
- **Bullet and numbered lists** — Use for discrete items and sequential steps.

</general_formatting>

**Instruction Writing:** See `<instruction_writing>` in [copilot-instructions.md](../copilot-instructions.md)

<artifact_formatting>

## Artifact-Specific Rules

- Use `##` for major sections in reference files
- Bold labels for definitions: `**term** — definition`
- Use `[UPPERCASE_PLACEHOLDER]` format in templates
- **File references** — Use markdown links `[file.md](path/file.md)`, never backticks
- **Inline code** — Backticks permitted for code snippets, variables, command names

</artifact_formatting>

<file_requirements>

## Every File Must Have

- Clear title as H1 heading
- Purpose statement in first paragraph
- Cross-references section at end linking related files

</file_requirements>

<template_requirements>

## Templates Must Include

- Required vs optional marking for every section
- Default values for optional fields
- Placeholder format examples
- Minimal template variant for simple cases

</template_requirements>

<pattern_requirements>

## Patterns Must Include

- "When to create" decision criteria
- Anti-patterns with explanations
- Ecosystem position (how this artifact relates to others)

</pattern_requirements>

<checklist_requirements>

## Checklists Must Include

- Priority level definitions (P1/P2/P3)
- Atomic checks (one thing per item)
- Pass/fail criteria without judgment calls
- Quick validation section (5 essential checks)

</checklist_requirements>
