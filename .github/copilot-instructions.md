This project is dedicated specifically for AI agents, all generated content must be optimized for AI agent consumption.

**ALWAYS** ask yourself:

**Pre-generation:**
- Is this content clear and unambiguous for an AI agent?
- Can an AI agent parse and act on this content without human interpretation?

**During generation:**
- Have I used XML tags per `<xml_usage>` to structure the content?
- Does each rule use imperative verbs per `<critical_rules>`?
- Have I avoided all patterns in `<forbidden_structures>`?

**Post-generation:**
- Can the AI agent easily identify and locate specific content when needed?
- Would another AI agent understand this without additional context?

<tag_index>

**Sections in this file:**

- `<critical_rules>` — Core rules for AI-optimized content generation
- `<forbidden_structures>` — Human-centric patterns to avoid
- `<xml_usage>` — XML tag conventions and examples
- `<artifact_types>` — Artifact type decision order and paths

**Extended patterns:** See [patterns.instructions.md](instructions/patterns.instructions.md) for:
- `<instruction_writing>` — Positive framing and prompt authoring
- `<tool_and_file_references>` — Syntax for referencing tools, agents, files
- `<avoid_overengineering>` — Simplicity principles
- `<context_management>` — File loading tiers and token budgets
- `<error_documentation>` — Error reporting format
- `<confidence_signaling>` — Uncertainty thresholds
- `<delegation_patterns>` — Agent handoff conventions
- `<self_validation>` — Pre-output verification
- `<tool_fallbacks>` — Graceful degradation when tools unavailable
- `<references>` — External documentation links

</tag_index>

<critical_rules>

Before output: "Executable by agent without human interpretation?" No → revise.

1. **Imperative verbs only** — "Include X" not "X should be included"
2. **No hedge words** — State facts with evidence basis, not "typically" or "probably"
3. **Quantify all guidance** — "2-3 items" not "several"
4. **Emojis prohibited** — Never use emojis in any generated content
5. **XML tags are golden standard** — Use XML tags everywhere to allow AI agents to easily parse and navigate instructions. 
  - IF you generate content or edit files **always** structure it with XML tags
  - Follow `<xml_usage>` guidelines for tag referencing and examples

Before creating or editing any content:
- **SPAWN** sub-agent with #tool:runSubagent to test if content is clear and easly understood by an AI agent

</critical_rules>

<forbidden_structures>

These human-centric patterns break agent parseability. Use the positive alternatives:

**Start with actionable content** — Begin files directly with purpose statement and rules.
<example>
- Avoid: "## Introduction\n\nThis guide will help you..."
- Use: "## Purpose\n\nThis file defines validation rules for..."
</example>

**Write section content directly** — Each section starts with its content, not commentary.
<example>
- Avoid: "This section covers the key patterns..."
- Use: "Key patterns:\n- Pattern 1..."
</example>

**Present information upfront** — State all required context at the start.
<example>
- Avoid: Revealing constraints gradually through the document
- Use: List all constraints in a `<constraints>` section at the top
</example>

**State purpose factually** — Describe what the artifact does, not how it helps.
<example>
- Avoid: "This will help you create better agents..."
- Use: "This file contains agent templates for..."
</example>

</forbidden_structures>

<xml_usage>

**CORE IDEA:** XML tags are the PRIMARY structure for ALL artifact files in this project.

<structure_hierarchy>

**Primary:** XML tags define logical sections and enable agent navigation/parsing.

**Supplementary:** Markdown headings (`##`) provide human readability INSIDE XML tags.

**Pattern:**
```markdown
<section_name>

## Human-Readable Heading

Content here...

</section_name>
```

**Applies to:** Agents, prompts, instructions, skills, and all reference/asset files.

**Rule:** Any content with 2+ logical sections MUST use XML tags as the primary grouping mechanism.

</structure_hierarchy>

## Tag Referencing

Reference previously defined tags by name in subsequent sections.

**Patterns:**
- "Apply rules from `<critical_rules>` when generating content..."
- "Avoid patterns listed in `<forbidden_structures>`..."
- "Follow syntax from `<tool_and_file_references>` for links..."
- "Switch to <mode name="research"> for detailed lookup"

**Rules:**
- Use consistent tag names throughout the artifact
- Reference tags explicitly when their content informs later sections
- Use descriptive tag names that make references natural

## Tags with Headers

Combine XML tags with markdown headers for hierarchical structure.

**Rules:**
- Use single space after `#` symbols
- Leave blank lines before and after headers
- Place headers inside or outside tags based on semantic grouping

**Example:**

```markdown
<section_name>

## Subsection Header

Content for this subsection.

## Another Subsection

More content here.

</section_name>
```

## Workflow Structure

Structure multi-phase workflows using numbered phase tags.

**Pattern:** `<phase_N_name>` where N is sequence number and name describes the phase

**Rules:**
- Number phases sequentially (1, 2, 3...)
- Use descriptive phase names after the number
- Contain all phases within a parent `<workflow>` tag

**Example:**

```markdown
<workflow>

<phase_1_research>
Gather requirements and existing patterns.
</phase_1_research>

<phase_2_design>
Create solution architecture.
</phase_2_design>

<phase_3_implementation>
Build and test the solution.
</phase_3_implementation>

</workflow>
```

## Naming Standards

**Convention:** Use `snake_case` for all XML tag names.

<example>
- Correct: `<context_loading>`, `<error_handling>`, `<step_1_classify>`
- Incorrect: `<contextLoading>`, `<ErrorHandling>`, `<Step1Classify>`
</example>

**Nesting:** Maximum 1 level of nesting.

<example>
- Permitted: `<modes>` containing `<mode name="x">`
- Permitted: `<workflow>` containing `<step_N_verb>`
- Avoid: `<section><subsection><item>` (3 levels)
</example>

**Cross-file references:** Use file link + backtick tag name.

<example>
- Same file: "Apply rules from `<critical_rules>`"
- Cross-file: "See `<language_rules>` in [style.instructions.md](instructions/style.instructions.md)"
</example>

</xml_usage>

<artifact_types>

## Artifact Types

Select type using decision order. Prefer lightweight option.

**Decision order:** Instruction → Skill → Prompt → Agent

- **Instruction** — Rules for file patterns. Path: `.github/instructions/*.instructions.md`. Auto-applies via `applyTo` glob.
- **Skill** — Reusable procedures. Path: `.github/skills/{name}/SKILL.md`. Explicit invocation required.
- **Prompt** — One-shot templates. Path: `.github/prompts/*.prompt.md`. Manual attachment required.
- **Agent** — Specialized personas with tools. Path: `.github/agents/*.agent.md`. Explicit `@agent` required.

</artifact_types>

**KEEP IN MIND:** Everything generated in this project is for other **AI AGENTS** - NOT humans
