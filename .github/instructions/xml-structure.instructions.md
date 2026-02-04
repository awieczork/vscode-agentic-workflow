---
applyTo: "**"
description: "XML structure and syntax conventions for AI agent consumption"
---

# XML Structure Conventions

Wrap all logical sections in XML tags per `<xml_structure>`, using naming conventions from `<naming_standards>`. Introduce tags in an opening prose paragraph per `<prose_introduction>`. Reference tags using formats in `<tag_referencing>`. Structure multi-phase work per `<workflow_structure>`. Avoid patterns in `<anti_patterns>`.

<xml_structure>

## XML Tags as Primary Structure

Wrap every logical section in XML tags. Markdown headings are supplementary inside tags.

**Pattern:**
```markdown
<section_name>

## Human-Readable Heading

Content here...

</section_name>
```

**Naming:** Use `snake_case` for all tag names — `<core_rules>`, `<error_handling>`, `<context_loading>`.

**Nesting:** Maximum 1 level. Parent tag may contain child tags with attributes.
```markdown
<modes>

<mode name="explore">
...
</mode>

<mode name="decide">
...
</mode>

</modes>
```

**Coverage:** Every distinct topic gets its own tag. If content has 2+ logical sections, wrap each in XML.

</xml_structure>

<naming_standards>

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

</naming_standards>

<prose_introduction>

## Prose Introduction Block

**Purpose:** Replace bullet-list tag indexes with instructional prose referencing all major XML tags.

**Location:** First paragraph after frontmatter (agents) or title (instructions), BEFORE any XML tags.

**Structural requirements:**
- Reference every major XML tag using backtick format `<tag_name>`
- Place OUTSIDE/BEFORE the XML-tagged sections
- Use imperative verbs (Apply, Follow, Consult, Use)

**Example:**
```markdown
# Title

Apply constraints from `<safety>` before any action. Load context per `<context_loading>`, then select behavior from `<modes>`.

<safety>
...
</safety>

<context_loading>
...
</context_loading>
```

For composition rules (verb selection, sentence count, ordering): See `<prose_composition>` in [writing.instructions.md](writing.instructions.md).

</prose_introduction>

<self_reference>

## Self-Reference Format

When referencing XML tags within the same file body, use consistent formatting.

**Inline prose references:** Backticks around the tag — `<tag_name>`
```markdown
Delegate implementation per `<boundaries>`.
Apply rules from `<safety>` before proceeding.
Switch to `<mode name="decide">` for decision support.
```

**Structural tags defining blocks:** Raw XML (no backticks)
```markdown
<mode name="explore">
...
</mode>
```

**Tags with attributes in prose:** Include attribute in backticks
```markdown
Per `<iron_law id="IL_001">`, never cite unverified sources.
```

**Cross-section references:** Always use backtick format
- In tables: "→ `<safety>` over convenience"
- In conditions: "Per `<iron_law id="IL_004">`"
- In exits: "switch to `<mode name="research">`"

</self_reference>

<workflow_structure>

## Workflow Tags

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

</workflow_structure>

<anti_patterns>

## Anti-Patterns

**Missing XML structure** — Sections without tags
- Wrong: `## Safety Rules` (heading only)
- Correct: `<safety>` wrapping the section

**Bullet-list tag index** — Mechanical enumeration
- Wrong: `- <safety> — Priority hierarchy`
- Correct: Prose: "Apply constraints from `<safety>`..."

**Plain text self-references** — Tag names without formatting
- Wrong: "Delegate per boundaries"
- Correct: "Delegate per `<boundaries>`"

**Descriptive voice** — Describes instead of instructs
- Wrong: "This section contains safety rules"
- Correct: "Apply rules from `<safety>` before acting"

**Orphan references** — Referencing tags that don't exist in the file
- Wrong: "See `<validation>` for checks" (tag not defined)
- Correct: Only reference tags that exist in the current file

</anti_patterns>

## Cross-References

- [copilot-instructions.md](../copilot-instructions.md) — Core project rules
- [writing.instructions.md](writing.instructions.md) — Writing style and prose composition
