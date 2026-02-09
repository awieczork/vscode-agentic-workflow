---
applyTo: "**"
description: "Writing rules for AI agent consumption"
---

This file defines how to write content that AI agents can parse and act upon. The governing principle is: provide what structure cannot — agents read XML tags directly, so prose supplies purpose, priority, and relationships that parsing misses. Begin with `<constraints>` for hard limits, then apply `<voice_and_precision>` for foundational writing patterns and remaining sections as needed.


<constraints>

- Never include emojis, motivational phrases ("This will help you..."), leading special characters (`---`, `#`, `*` as first character), or artificial markers (`---START`, `===END`) — each breaks parsing or adds noise
- Only reference tags that exist in the current file or linked files — no dangling pointers

</constraints>


<voice_and_precision>

- Use one term per concept; consult `<canonical_terms>` in `glossary.instructions.md`
- Replace vague language with explicit conditionals (`If X, then Y`) and precise quantities (`2-3 items`, not "several")
- Write in active voice with positive framing and action verbs — no hedging or passive constructions. Prohibitions are the exception: use "No"/"Never" per `<formatting_conventions>`
- Match format to content: prose for causally linked ideas, bullets for parallel unordered items, numbered lists for sequential steps
- Reference tag content by name (`"the schema in <contract>"`) — never by position ("above", "below")

Wrong: "Input should be checked" (passive voice) → Correct: "Check input"
Wrong: "Agents should apply" (third-person) → Correct: "Apply"
Wrong: "Perhaps we could try" (hedging) → Correct: "Use"
Wrong: "Don't use bullets" (negative framing outside prohibitions) → Correct: "Use numbered lists for sequential steps"

</voice_and_precision>


<reference_notation>

- Reference tools as `#tool:toolname`, agents as `@agentname`, files as markdown links `[display](path/file.md)`, code elements in backticks
- Format definitions as `**term** — definition` (bold + em-dash); use backticks instead of bold for code identifiers: `` `term` — definition ``; use em-dash (—) not hyphen (-)
- Format placeholders as `[UPPERCASE_PLACEHOLDER]` — brackets plus uppercase signal "replace this" distinctly from literal content
- Format line references as markdown links: single `[file.ts](file.ts#L10)`, range `[file.ts](file.ts#L10-L12)`; non-contiguous lines require separate links; no URI schemes like `file://` or `vscode://`
- Reference XML tags in backticks with angle brackets: `<tag_name>`. Two forms:
  - **Same file** — backticks only: "Begin with `<constraints>` for hard limits"
  - **Linked file** — backticks plus markdown file link: "Follow `<reference_notation>` in [writing instructions](.github/instructions/writing.instructions.md)"

</reference_notation>


<formatting_conventions>

- Label examples with contrast pairs: "Instead of... Write..." or "Wrong:... Correct:..."
- Express priority hierarchies with arrow notation: `Safety → Accuracy → Clarity → Style` (left takes precedence)
- Separate enum/status values with pipe and backticks: `success` | `partial` | `failed`
- Express thresholds consistently: `≥80%` for "at least", `50-80%` for ranges, `<50%` for "less than"
- Capitalize list items; omit trailing periods unless items are complete sentences
- Start prohibitions with "No" or "Never"; include reason after em-dash: "No emojis — break parsing in some environments"
- Format paths with forward slashes and backticks regardless of OS: `.github/instructions/*.instructions.md`

</formatting_conventions>
