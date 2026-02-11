This framework helps humans create effective agentic workflows. The artifacts themselves are written FOR AI agents TO execute — the reader of every file in this repository is ALWAYS an **AI Agent**, not a human.

AI agents fabricate when rules are incomplete and fail on edge cases when rules don't convey intent. This framework solves the precision-understanding tension: agents need enough structure to act without guessing, AND enough context to reason when structure doesn't anticipate the situation. Provide what structure cannot — agents parse XML tags directly; prose supplies purpose, priority, and relationships that parsing misses.

The governing principle is: calibrate autonomy to confidence — proceed decisively when evidence is strong, escalate when uncertain, and prioritize safety over speed. Apply `<decision_making>` when rules conflict. Begin with `<constraints>` for hard limits, then apply patterns from remaining sections as situations arise.


<workspace>

Workspace structure and folder purposes. Load this first to locate resources.

- `.github/agents/core/` — Hub-and-spoke agent definitions (brain, researcher, architect, build, inspect, curator) — `Active`
- `.github/agents/generation/` — Generation pipeline agents (creator, interviewer, master) — `Active`
- `.github/instructions/` — Reserved for future instruction files — `Empty`
- `.github/skills/` — Skill definitions (`SKILL.md` files) with `references/` and `assets/` subfolders — `Active`
- `.github/prompts/` — Reusable prompt files (`.prompt.md` files) — `Active`
- `.github/schema/` — Schema definitions for the generation pipeline (manifest, spec) — `Active`
- `.github/decisions/` — Active design decisions and rationale — `Temporary`
- `.github/specs/` — Output directory for interviewer-generated spec files — `Placeholder`
- `templates/` — Repo-agnostic templates for pipeline output — `Placeholder`
- `output/` — Generated project output (gitignored) — `Placeholder`

**Status meanings:**

- `Active` — Authoritative, use as source of truth
- `Temporary` — Will be cleaned up after current development cycle
- `Placeholder` — Structure exists, content not yet generated
- `Removed` — Previously existed, content redistributed to other files

</workspace>


<constraints>

- Framework instructions apply to workspace artifacts — files created or edited in this workspace
- copilot-instructions.md takes precedence over domain instruction files — without explicit precedence, conflicts cause paralysis
- Trust documented structure without re-verification; verify all facts, file contents, and citations before citing — never fabricate sources, file paths, or quotes
- Do only what is requested or clearly necessary; treat undocumented features as unsupported
- Include type-specific requirements for each document type: purpose statements for files, required/optional marking for templates, when-to-create criteria for patterns, P1/P2/P3 severity for checklists

Wrong: Citing a source without retrieval, describing file contents without reading → Correct: Read the file, then cite specific content
Wrong: Adding features "while we're here", future-proofing not requested → Correct: Deliver exactly what was requested; note potential improvements only if asked

</constraints>


<decision_making>

- When rules conflict, apply: Safety → Accuracy → Clarity → Style — the first dimension that distinguishes options wins
- Classify issues by impact: P1 blocks completion, P2 degrades quality, P3 is optional
- Calibrate decisions to confidence: high confidence → proceed; medium confidence → flag uncertainty, ask; low confidence → stop, request clarification
- When resources are unavailable, state the gap, provide an explicit workaround, continue

Wrong: "I'm not sure about this, but I'll proceed anyway." (no confidence signal) → Correct: "Confidence is medium on this dependency. Flagging: [specific uncertainty]. Proceeding with [explicit assumption]. Correct me if wrong."
Wrong: "I can't find the config file, so I'll stop." (halt on missing resource) → Correct: "Config file not found. Workaround: using default values [X, Y]. Run `command` to generate the config if needed."

</decision_making>


<collaboration>

- Delegate when expertise differs or parallelism saves time; retain when handoff overhead exceeds task cost
- Make every handoff payload self-contained: summary of completed work, key decisions, explicit next steps
- Load context in priority order: global rules first, then session state, then files on demand
- Process "Iterate x{N}" by running N passes and aggregating findings with iteration attribution

</collaboration>


<error_reporting>

- Report errors using the standard format: `status` (`success` | `partial` | `failed` | `blocked`), `error_code` (kebab-case), `message` (human explanation), `recovery` (next action)

</error_reporting>


<voice_and_precision>

- Use one term per concept; consult `<canonical_terms>` in [glossary.md](.github/skills/artifact-author/references/glossary.md)
- Replace vague language with explicit conditionals (`If X, then Y`) and precise quantities (`2-3 items`, not "several")
- Write in active voice with positive framing and action verbs — no hedging or passive constructions. Prohibitions are the exception: use "No"/"Never" per `<formatting_conventions>` in [artifact-structure.md](.github/skills/artifact-author/references/artifact-structure.md)
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
- Agent files (`.agent.md`) use `{descriptive_lowercase}` placeholders in spawn templates and output formats — these describe contextual values shared between agents. `[UPPERCASE_PLACEHOLDER]` applies to documentation templates and user-facing instructions
- Format line references as markdown links: single `[file.ts](file.ts#L10)`, range `[file.ts](file.ts#L10-L12)`; non-contiguous lines require separate links; no URI schemes like `file://` or `vscode://`
- Reference XML tags in backticks with angle brackets: `<tag_name>`. Two forms:
  - **Same file** — backticks only: "Begin with `<constraints>` for hard limits"
  - **Linked file** — backticks plus markdown file link: "Follow `<canonical_terms>` in [glossary.md](.github/skills/artifact-author/references/glossary.md)"

</reference_notation>
