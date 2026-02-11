---
name: 'artifact-author'
description: 'Writes properly-structured .md artifacts for the agentic framework. Use when asked to "write a document", "create a markdown file", "refactor an artifact", or "update a framework file". Applies XML structure conventions, canonical vocabulary, formatting rules, and document anatomy patterns.'
---

This skill writes properly-structured .md artifacts for the agentic framework. The governing principle is structure for navigation, prose for understanding — XML tags provide addresses, prose supplies purpose and relationships. Begin with `<step_1_orient>` to determine the artifact type and applicable rules.


<use_cases>

- Author new .md files that follow framework XML structure and formatting conventions
- Restructure existing framework files to comply with structure and writing rules
- Apply canonical vocabulary to artifact content, replacing aliases with standard terms
- Verify artifact compliance with document anatomy, tag design, and formatting rules

</use_cases>


<workflow>

Execute steps sequentially. Each step verifies its own output before proceeding to the next.


<step_1_orient>

Verify this request involves framework document quality (structure, formatting, terminology). If it requires creating a specific artifact type, route to the type-specific creator skill instead.

Determine artifact type: agent (.agent.md), skill (SKILL.md), instruction (.instructions.md), prompt (.prompt.md), contract, or other .md file. Each type has its own creator skill for type-specific structure — this skill handles cross-cutting writing quality.

Load [artifact-structure.md](./references/artifact-structure.md) for: `<structure_constraints>`, `<document_anatomy>`, `<xml_system>`.

Verify the target file context: new file (apply all rules from scratch) or existing file (identify violations to fix).

</step_1_orient>


<step_2_plan_structure>

Apply XML structure rules from [artifact-structure.md](./references/artifact-structure.md):

1. Select tag names using snake_case — domain-specific, meaningful names
2. Enforce 3-level nesting maximum — split into separate files if exceeded
3. Plan document anatomy: prose intro (2-5 sentences with governing principle) → tagged sections
4. Apply `<tag_design>` rules: separate instructions from data, design for modularity and reuse
5. Reserve markdown tables for `<outputs>` and `<resources>` sections only — use bullet lists elsewhere

</step_2_plan_structure>


<step_3_draft>

Write content applying formatting conventions. Load [artifact-structure.md](./references/artifact-structure.md) for: `<content_constraints>`, `<formatting_conventions>`.

Load [example-artifact.md](./assets/example-artifact.md) for: annotated reference output.

Apply all rules from `<content_constraints>` and `<formatting_conventions>` in [artifact-structure.md](./references/artifact-structure.md).

</step_3_draft>


<step_4_verify_terminology>

Verify canonical vocabulary. Load [glossary.md](./references/glossary.md) for: `<canonical_terms>`, `<validation>`.

1. Scan draft for non-canonical terms using the grep pattern in `<validation>`
2. Replace each alias with its canonical term (e.g., "workflow" → "skill", "guideline" → "rule")
3. Check conflict entries when terms overlap — apply the correct term for the context
4. Exclude matches inside code blocks and quoted user input

</step_4_verify_terminology>


<step_5_verify>

Final compliance check against all rules:

1. Prose intro present before first XML tag, contains governing principle
2. XML tags as exclusive structure — zero markdown headings (`#`, `##`, etc.)
3. All XML tag names use snake_case
4. Tag references use correct form: same-file in backticks only, cross-file with backticks plus markdown link
5. Consistent spacing: blank line after opening tag, before closing tag, two between major sections
6. Fenced code blocks and lists surrounded by blank lines
7. No dangling tag references — every referenced tag exists in current or linked file

</step_5_verify>


</workflow>


<error_handling>

- If markdown headings found in artifact, then replace with XML tags using snake_case naming
- If non-canonical term detected, then consult `<canonical_terms>` in [glossary.md](./references/glossary.md) and substitute the canonical term
- If nesting exceeds 3 levels, then extract nested content into a separate reference file with relative path link
- If cross-file tag reference missing markdown link, then locate target file and add linked-file form: backticks plus `[file](path)`
- If file exceeds 500 lines, then split into primary file + reference files
- If orphaned tag references found (tags referenced in prose but no matching XML tag), then add the tag or remove the reference
- If cross-file link references a path that doesn't exist, then verify the path and fix
- If markdown table used outside `<outputs>` or `<resources>`, then convert to prose or bullet list

</error_handling>


<validation>

P1 (blocking — must fix before delivery):

- Correct XML tag structure as exclusive structural element — no markdown headings
- No `@agentname` references — artifact is agent-agnostic
- Required formatting: em-dash definitions, no emojis outside code blocks

P2 (quality — fix before final review):

- Canonical vocabulary compliance — no non-canonical aliases per [glossary.md](./references/glossary.md)
- Cross-file reference integrity — all referenced tags exist in target files
- YAML string values in single quotes
- No secrets, absolute paths, or environment-specific values
- No markdown tables outside `<outputs>` and `<resources>` zones

P3 (polish — fix when time permits):

- Active voice throughout, no hedging language
- Every file opens with prose intro containing governing principle

</validation>


<resources>

- [glossary.md](./references/glossary.md) — Canonical vocabulary with 17 term definitions, aliases, conflicts, and grep validation pattern
- [artifact-structure.md](./references/artifact-structure.md) — XML structure rules, document anatomy patterns, tag design principles, content constraints, and formatting conventions
- [example-artifact.md](./assets/example-artifact.md) — Demonstrates correctly structured framework artifact

</resources>
