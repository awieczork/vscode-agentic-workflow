This file defines structure and formatting rules for .md artifacts consumed by AI agents. The governing principle is: XML tags are the primary navigation system — tags are addresses to jump to; prose supplies purpose, priority, and relationships.


<structure_constraints>

- XML tags are the exclusive structural system — no markdown headings, no sections without tags, no multi-topic tags
- Limit nesting to 3 levels maximum — split into separate files rather than exceeding depth
- Reserve markdown tables for `<outputs>` and `<resources>` sections only
- One concern per file — separate files for testing, styling, documentation

</structure_constraints>


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
- Exception: Single-line directive content in `<if>` and `<on_missing>` tags may omit inner blank lines when the tag contains exactly one line of content
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

Wrong: `Here's an example of good code.` — unlabeled, no contrast pair
Correct: `<example>` tag with Wrong/Correct contrast — e.g., `const x = getValue()` → `const userAge = getUserAge()`

</example>

</tag_design>


<content_constraints>

- Never include emojis, motivational phrases ("This will help you..."), leading special characters (`---`, `#`, `*` as first character), or artificial markers (`---START`, `===END`) — each breaks parsing or adds noise
- Only reference tags that exist in the current file or linked files — no dangling pointers

</content_constraints>


<formatting_conventions>

- Label examples with contrast pairs: "Instead of... Write..." or "Wrong:... Correct:..."
- Express priority hierarchies with arrow notation: `Safety → Accuracy → Clarity → Style` (left takes precedence)
- Separate enum/status values with pipe and backticks: `success` | `partial` | `failed`
- Express thresholds consistently: `≥80%` for "at least", `50-80%` for ranges, `<50%` for "less than"
- Capitalize list items; omit trailing periods unless items are complete sentences
- Start prohibitions with "No" or "Never"; include reason after em-dash: "No emojis — break parsing in some environments"
- Format paths with forward slashes and backticks regardless of OS: `.github/instructions/*.instructions.md`

</formatting_conventions>
