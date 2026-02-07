---
applyTo: "**"
description: "XML structure and syntax conventions for AI agent consumption"
---

This file defines how to structure documents for AI agent consumption. The governing principle is: XML tags are the primary navigation system — tags are addresses to jump to; prose supplies what structure cannot: purpose, priority, relationships. Begin with `<xml_system>` for core tag rules, then apply patterns from remaining sections as needed.


<xml_system>

<rules>

- XML tags are the primary navigation system — tags are addresses; prose supplies purpose, priority, and relationships
- XML tags are the exclusive structural system — wrap every logical section in exactly one tag. No markdown headings. No sections without tags. No multi-topic tags
- Use snake_case for all tag names
- Limit nesting to 3 levels maximum — split into separate files per `<document_anatomy>` rather than exceeding depth
- Tag names are project vocabulary, not magic keywords — meaningful, consistent names matter; no canonical "best" tag names exist
- Use raw XML for structural definitions; use backticks for inline prose references

</rules>

<justification>

The agent defaults to markdown headings and freely mixes structural systems. XML exclusivity prevents reconciling competing hierarchies. Nesting beyond 3 levels exceeds scope tracking. The raw-XML-vs-backtick distinction prevents confusion between "this is the structure" and "this references the structure."

</justification>

<benefit>

Documents parse through one deterministic hierarchy with correct scope at every level.

</benefit>

<anti_patterns>

- Wrong: Using `# Heading` / `## Subheading` / `### Sub-subheading` for document structure → Correct: Using `<section_name>` XML tags for all structure

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

</anti_patterns>

</xml_system>


<document_anatomy>

<rules>

- Open every file with a prose introduction (2-5 sentences) before any XML tags — state purpose and governing principle
- Reserve markdown tables for `<outputs>` sections only
- One concern per file — separate files for testing, styling, documentation; load exactly what is needed
- Use keyword-rich descriptions in frontmatter `description` fields
- Use consistent vertical spacing: one blank line after opening tag, one before closing tag, two between major sections

</rules>

<justification>

Purpose statements enable load/skip decisions on first sentence. One-concern-per-file keeps context cost proportional to relevance. Keyword-rich frontmatter enables discovery without content parsing. These patterns prevent the agent from loading irrelevant content and from producing documents that lack navigable structure.

</justification>

<benefit>

Files load selectively, discover through metadata, and communicate purpose before detail.

</benefit>

<anti_patterns>

- Wrong: "This file contains `<safety>`, `<context>`, `<formatting>`..." (enumerating sections as intro) → Correct: "This file defines how to write content that AI agents can parse and act upon. The governing principle is..." (explaining function)

</anti_patterns>

</document_anatomy>


<tag_design>

<rules>

- Separate instructions from data using distinct tags — `<task>` for what to do, `<data>` for what to process
- Tag outputs for parseability — wrap responses in `<answer>` or `<result>` tags for machine extraction
- Design tags for modularity and reuse — standard patterns (`<context>`, `<task>`, `<constraints>`, `<examples>`) transfer understanding across files
- Include 3-5 diverse examples for complex tasks, wrapped in `<example>` tags with content in code blocks

</rules>

<justification>

When instructions and data share a tag, the agent may execute data as commands. Tagged outputs enable machine extraction without natural language parsing. Code blocks inside `<example>` tags prevent nested tag confusion.

</justification>

<benefit>

The agent switches correctly between "follow this" and "process this" modes with extractable outputs and unambiguous examples.

</benefit>

<anti_patterns>

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

</anti_patterns>

</tag_design>
