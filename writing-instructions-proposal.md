---
applyTo: "**"
description: "Writing rules for AI agent consumption"
---

This file defines how to write content that AI agents can parse and act upon. The governing principle is: provide what structure cannot — agents read XML tags directly, so prose supplies purpose, priority, and relationships that parsing misses. Begin with `<voice_and_precision>` for foundational writing patterns, then apply rules from remaining sections as needed.


<voice_and_precision>

<rules>

- Use one term per concept; consult `<canonical_terms>` in `glossary.instructions.md`
- Replace vague language with explicit conditionals (`If X, then Y`) and precise quantities (`2-3 items`, not "several")
- Write in active voice with positive framing and action verbs — no hedging or passive constructions. Prohibitions are the exception: use "No"/"Never" per `<formatting_conventions>`
- Match format to content: prose for causally linked ideas, bullets for parallel unordered items, numbered lists for sequential steps
- Reference tag content by name (`"the schema in <contract>"`) — never by position ("above", "below")

</rules>

<justification>

Ambiguity enters prose through multiple channels: synonyms that fracture terminology, vague qualifiers that defer decisions, passive constructions that obscure responsibility, mismatched formatting that fights content structure, and positional references that require backward search. These rules close each channel — lexical consistency, explicit conditionals, direct voice, structure-matched format, and named references together ensure every sentence resolves to exactly one interpretation.

</justification>

<benefit>

Instructions parse to deterministic actions on first read, without disambiguation, inference, or backward scanning.

</benefit>

<anti_patterns>

- Passive voice: "Input should be checked" → "Check input"
- Third-person: "Agents should apply" → "Apply"
- Hedging: "Perhaps we could try" → "Use"
- Negative framing outside prohibitions: "Don't use bullets" → "Use numbered lists for sequential steps"

</anti_patterns>

</voice_and_precision>


<prohibitions>

<rules>

- Never include emojis, motivational phrases ("This will help you..."), leading special characters (`---`, `#`, `*` as first character), or artificial markers (`---START`, `===END`) — each breaks parsing or adds noise without information

</rules>

<justification>

Emojis fail in rendering environments, motivational phrases add noise without information, leading special characters trigger parser edge cases, and artificial markers conflict with structural delimiters. Each item is plausible in human-to-human writing but actively harmful in instruction files where every token is processed, not skimmed.

</justification>

<benefit>

Content parses cleanly without edge-case rendering or parsing errors.

</benefit>

</prohibitions>


<reference_notation>

<rules>

- Reference tools as `#tool:toolname`, agents as `@agentname`, files as markdown links `[display](path/file.md)`, code elements in backticks
- Format definitions as `**term** — definition` (bold + em-dash); use backticks instead of bold for code identifiers: `` `term` — definition ``; use em-dash (—) not hyphen (-)
- Format placeholders as `[UPPERCASE_PLACEHOLDER]` — brackets plus uppercase signal "replace this" distinctly from literal content
- Format line references as markdown links: single `[file.ts](file.ts#L10)`, range `[file.ts](file.ts#L10-L12)`; non-contiguous lines require separate links; no URI schemes like `file://` or `vscode://`
- Only reference tags that exist in the current file or linked files — no dangling pointers

</rules>

<justification>

Documents reference many artifact types — tools, agents, files, definitions, placeholders, code elements, line numbers, tags — and without distinct notation per type, the same backticked term could be a variable, a command, a file path, or a placeholder. These rules establish a type system for references: each artifact kind has exactly one visual signature, definitions follow a discoverable pattern, placeholders are visually distinct from literals, line references are navigable links, and every tag reference resolves to something that exists.

</justification>

<benefit>

Reference type is determined from syntax alone, eliminating context-dependent guessing and ensuring every reference resolves to a real target.

</benefit>

</reference_notation>


<formatting_conventions>

<rules>

- Label examples with contrast pairs: "Instead of... Write..." or "Wrong:... Correct:..."
- Express priority hierarchies with arrow notation: `Safety → Accuracy → Clarity → Style` (left takes precedence)
- Separate enum/status values with pipe and backticks: `success` | `partial` | `failed`
- Express thresholds consistently: `≥80%` for "at least", `50-80%` for ranges, `<50%` for "less than"
- Capitalize list items; omit trailing periods unless items are complete sentences
- Start prohibitions with "No" or "Never"; include reason after em-dash: "No emojis — break parsing in some environments"
- Format paths with forward slashes and backticks regardless of OS: `.github/instructions/*.instructions.md`

</rules>

<justification>

Recurring micro-patterns — examples, priority orderings, enum values, thresholds, list punctuation, prohibitions, paths — appear throughout every instruction file. Without conventions each occurrence becomes a per-instance formatting decision. These rules convert those decisions into lookups: arrows for precedence, pipes for alternatives, range notation for thresholds, labeled pairs for examples. Arrow notation for ordered precedence complements pipe notation for unordered alternatives, teaching the distinction between "sequence matters" and "pick one" by shape alone.

</justification>

<benefit>

Formatting is parsed through pattern recognition rather than interpretation, and new documents achieve visual consistency without per-instance design choices.

</benefit>

</formatting_conventions>
