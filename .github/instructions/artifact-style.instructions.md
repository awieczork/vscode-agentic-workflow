---
applyTo: ".github/**/*.md"
description: "Style rules for generated artifacts in the .github folder"
---

# Artifact Style Guide

Rules for creating and editing generated artifacts in `.github/`. These documents are reference material FOR AI agents, not human readers.

<language_rules>

**Use imperative verbs** — "Include X" not "X should be included"

**Use explicit conditionals** — "If X, then Y" not "Y when appropriate"

**Quantify guidance** — "2-3 paragraphs" not "brief", "3-5 items" not "several"

**One term per concept** — Pick one term, use it everywhere. Do not use synonyms.

**State explicit defaults** — "Default if omitted: [value]" for every optional field

</language_rules>

<forbidden_patterns>

NEVER use these patterns:

- **Hedge words:** typically, usually, often, might, probably, should consider
- **Vague quantifiers:** several, brief, appropriate, enough, some
- **Passive voice hiding actor:** "should be included" (by whom?)
- **Rhetorical questions:** Questions that don't expect answers
- **Motivational language:** "This will help you create better..."
- **Markdown tables:** Convert all tables to bullet lists
- **Emojis:** Unprofessional and reduce clarity
- **Example hedging:** "e.g.", "such as", "for example" without commitment — commit to ONE specific value (write "typescript-standards" not "e.g., typescript-standards")

**Exception:** Tables are permitted in `<outputs>` sections of agent definitions for structured report templates (build reports, inspection reports). These render for human readers, not AI parsing.

</forbidden_patterns>

<formatting_rules>

For general formatting rules, see [prompting.instructions.md](prompting.instructions.md).

## Artifact-Specific Rules

- Use `##` for major sections in knowledge-base files
- Bold labels for definitions: `**term** — definition`
- Use `[UPPERCASE_PLACEHOLDER]` format in templates
- NEVER use backticks for existing file references — use markdown links

</formatting_rules>

<content_requirements>

## Every File Must Have

- Clear title as H1 heading
- Purpose statement in first paragraph
- Cross-references section at end linking related files

## Templates Must Include

- Required vs optional marking for every section
- Default values for optional fields
- Placeholder format examples
- Minimal template variant for simple cases

## Patterns Must Include

- "When to create" decision criteria
- "When NOT to create" guidance
- Anti-patterns with explanations
- Ecosystem position (how this artifact relates to others)

## Checklists Must Include

- Priority level definitions (P1/P2/P3)
- Atomic checks (one thing per item)
- Pass/fail criteria without judgment calls
- Quick validation section (5 essential checks)

</content_requirements>
