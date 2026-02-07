# Rules Reference

A human-friendly listing of all rules across instruction files.

---

## Canonical Terms (`glossary.instructions.md`)

| Term | Definition |
|------|------------|
| error | Unexpected condition preventing normal execution |
| rule | Enforceable instruction with justification and benefit |
| constraint | Hard limit that cannot be exceeded — an obligation |
| agent | Autonomous executor with identity and boundaries |
| skill | Reusable multi-step process with validation |
| prompt | Parameterized instruction with variable slots |
| instruction | Collection of rules applying to file patterns |
| artifact | Any generated or modified content |
| handoff | Structured payload passing work to another agent |
| escalate | Interrupt execution to request human input |
| fabricate | Produce unverified claims without evidence |
| mode | Named behavioral configuration within an agent |
| context | Information acquired and held during a session |
| boundary | Capability limit defining what an agent may access or modify |
| phase | Lifecycle stage in agent execution |
| tool | External capability invoked by the agent |
| workspace | Scope of file operations and agent context |

---

## Glossary Rules (`glossary.instructions.md`)

| ID | Rule |
|----|------|
| G_10 | Use only canonical terms defined in `<canonical_terms>` across all artifacts. Applies to prose and definitions; XML tag names follow S_50. |
| G_20 | Understand aliases in user input but respond with canonical terms only. |
| G_30 | Consult `<conflicts>` entries when terms overlap in meaning. |

---

## Structure (`structure.instructions.md`)

| ID | Rule |
|----|------|
| S_10 | XML tags are the AI Agent's primary navigation system. |
| S_20 | XML tags are the exclusive structural system. No markdown headings. |
| S_30 | Use snake_case for all tag names. |
| S_40 | Limit nesting to maximum 3 levels. |
| S_50 | Tag names are project vocabulary, not magic keywords. |
| S_60 | Use raw XML for structural definitions; use backticks for inline prose references. |
| S_70 | Open every file with a prose introduction (2–5 sentences) before any XML tags. |
| S_80 | Reserve markdown tables for `<outputs>` sections only. |
| S_90 | One concern per file. |
| S_100 | Use keyword-rich descriptions in frontmatter. |
| S_110 | Use consistent vertical spacing around XML tags. |
| S_120 | Separate instructions from data using distinct tags. |
| S_130 | Tag outputs for parseability. |
| S_140 | Name workflow phases as `<phase_N_name>` and skill steps as `<step_N_verb>`. |
| S_150 | Design tags for modularity and reuse. |
| S_160 | Include 3–5 diverse examples for complex tasks, wrapped in `<example>` tags with content in code blocks. |
| S_170 | Structure iron laws with statement, red flags, and rationalization counters. |
| S_180 | Format error handling with `<if condition="error_type">` followed by action. |
| S_190 | Define stopping rules with separate handoff and escalation triggers. |

---

## Writing (`writing.instructions.md`)

| ID | Rule |
|----|------|
| W_10 | Use one term per concept throughout every document. See G_10 for the canonical term list. |
| W_20 | Eliminate vagueness: explicit conditionals and precise quantities. |
| W_30 | Write directly: active voice, positive framing, action verbs, no hedging. |
| W_50 | Never include content that breaks parsing or degrades focus (no emojis, no motivational phrases, no leading special characters). |
| W_60 | Reference tools, agents, files, and code elements with consistent notation (`#tool:name`, `@agent`, markdown links, backticks). |
| W_70 | Format definitions with bold term and em-dash: **term** — definition. Use backticks for code identifiers. |
| W_80 | Format placeholders as `[UPPERCASE_PLACEHOLDER]`. |
| W_90 | Format line references as markdown links to specific lines. |
| W_100 | Only reference tags that exist in the current file or linked files. |
| W_110 | Choose format by content structure: prose for causal links, bullets for parallel items, numbers for sequences. |
| W_130 | Refer to tag content by name in prose, not by position ("above"/"below"). |
| W_140 | Label examples with "Instead of… Write…" or "Wrong:… Correct:…" patterns. |
| W_150 | Express priority hierarchies with arrow notation (e.g., Safety → Accuracy → Clarity → Style). |
| W_160 | Separate status values with pipe and backticks (`success` \| `partial` \| `failed`). |
| W_170 | Express threshold ranges with consistent notation (≥80%, 50–80%, <50%). |
| W_180 | Capitalize list items; omit trailing periods unless items are complete sentences. |
| W_190 | Start prohibitions with "No" or "Never" and include the reason after em-dash. |
| W_200 | Format paths with forward slashes and backticks. |

---

## Project-Wide (`copilot-instructions.md`)

| ID | Rule |
|----|------|
| P_10 | When rules overlap across instruction files, copilot-instructions.md takes precedence. |
| P_20 | Structure every rule with statement, justification, benefit, and optional anti-pattern/example; wrap in `<rule id="X_NN">` tags. |
| P_30 | When conflicts occur, apply the priority hierarchy: Safety → Accuracy → Clarity → Style. |
| P_40 | Classify issues by impact: P1 blocks completion, P2 degrades quality, P3 is optional. |
| P_50 | Calibrate decisions to confidence level: ≥80% proceed, 50–80% flag and ask, <50% stop and clarify. |
| P_60 | When resources are unavailable, state the gap, provide explicit workaround, continue. |
| P_70 | Delegate when expertise differs or parallelism saves time; retain when it doesn't. |
| P_80 | Make every handoff payload self-contained. |
| P_90 | Load context in priority order: global rules first, then session state, then files on demand. |
| P_100 | Trust documented structure; verify facts before citing or describing. |
| P_110 | Do only what's requested or clearly necessary; treat undocumented features as unsupported. |
| P_120 | Include type-specific requirements for each document (files need purpose statements, templates need required/optional marking, etc.). |
| P_130 | Execute independent tool calls in parallel. |
| P_140 | Process "Iterate x{N}" by running N passes and aggregating findings. |
| P_150 | Report errors using the standard format: status, error_code, message, recovery. |
