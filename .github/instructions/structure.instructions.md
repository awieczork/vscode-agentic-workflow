---
applyTo: "**"
description: "XML structure and syntax conventions for AI agent consumption"
---

This file defines how to structure documents for AI agent consumption. The governing principle is: XML tags are the primary navigation system — tags are addresses to jump to; prose supplies what structure cannot: purpose, priority, relationships. Begin with `<constraints>` for hard limits, then apply `<xml_system>` for tag rules and remaining sections as needed.


<constraints>

- XML tags are the exclusive structural system — no markdown headings, no sections without tags, no multi-topic tags
- Limit nesting to 3 levels maximum — split into separate files rather than exceeding depth
- Reserve markdown tables for `<outputs>` sections only
- One concern per file — separate files for testing, styling, documentation

</constraints>


<xml_system>

- XML tags are the primary navigation system — tags are addresses; prose supplies purpose, priority, and relationships
- Use snake_case for all tag names
- Tag names are project vocabulary, not magic keywords — meaningful, consistent names matter; no canonical "best" tag names exist
- Use raw XML for structural definitions; use backticks for inline prose references

Wrong: Using `# Heading` / `## Subheading` / `### Sub-subheading` for document structure → Correct: Using `<section_name>` XML tags for all structure

<example>

**Structural definition (raw XML):**

```
<mode name="explore">

Content defining the explore mode...

</mode>
```

**Inline prose reference (backticks):**

```
When investigation is complete, switch to `<mode name="decide">` for decision support.
```

</example>

</xml_system>


<document_anatomy>

- Open every file with a prose introduction (2-5 sentences) before any XML tags — state purpose and governing principle
- Use keyword-rich descriptions in frontmatter `description` fields
- Use consistent vertical spacing: one blank line after opening tag, one before closing tag, two between major sections
- Surround fenced code blocks with blank lines (MD031) — ensures parsers and renderers correctly detect block boundaries
- Surround lists with blank lines (MD032) — prevents list items from merging with adjacent content

Wrong: "This file contains `<safety>`, `<context>`, `<formatting>`..." (enumerating sections as intro) → Correct: "This file defines how to write content that AI agents can parse and act upon. The governing principle is..." (explaining function)

</document_anatomy>


<tag_design>

- Separate instructions from data using distinct tags (`<task>` for what to do, `<data>` for what to process) — when combined, the agent may execute data as commands
- Tag outputs for parseability — wrap responses in `<answer>` or `<result>` tags for machine extraction
- Design tags for modularity and reuse — standard patterns (`<context>`, `<task>`, `<constraints>`, `<examples>`) transfer understanding across files
- Include 3-5 diverse examples for complex tasks, wrapped in `<example>` tags with content in code blocks

<example>

**Wrong:**

```
Here's an example of good code.
```

**Correct:**

```
<example>

**Wrong:** `const x = getValue()` — unclear naming
**Correct:** `const userAge = getUserAge()` — descriptive naming

</example>
```

</example>

</tag_design>
