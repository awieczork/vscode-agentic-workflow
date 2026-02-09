This framework helps humans create effective agentic workflows. The artifacts themselves are written FOR AI agents TO execute — the reader of every file in this repository is ALWAYS an **AI Agent**, not a human.

AI agents fabricate when rules are incomplete and fail on edge cases when rules don't convey intent. This framework solves the precision-understanding tension: agents need enough structure to act without guessing, AND enough context to reason when structure doesn't anticipate the situation. Provide what structure cannot — agents parse XML tags directly; prose supplies purpose, priority, and relationships that parsing misses.

The governing principle is: calibrate autonomy to confidence — proceed decisively when evidence is strong, escalate when uncertain, and prioritize safety over speed. Apply `<decision_making>` when rules conflict. Begin with `<constraints>` for hard limits, then apply patterns from remaining sections as situations arise.


<workspace>

Workspace structure and folder purposes. Load this first to locate resources.

- `.github/agents/` — Core agent definitions (`.agent.md` files) — `Active`
- `.github/instructions/` — Instruction files — writing rules, structure conventions, glossary — `Active`
- `.github/skills/` — Skill definitions (`SKILL.md` files) with `references/` and `assets/` subfolders — `Active`
- `.github/prompts/` — Reusable prompt files (`.prompt.md` files) — `Active`
- `.github/schema/` — Schema definitions for the generation pipeline (manifest, spec) — `Active`
- `.github/decisions/` — Active design decisions and rationale — `Temporary`
- `.github/specs/` — Output directory for interviewer-generated spec files — `Placeholder`
- `templates/` — Repo-agnostic core agents and instructions for pipeline output — `Active`
- `output/` — Generated project output (gitignored) — `Placeholder`

**Status meanings:**

- `Active` — Authoritative, use as source of truth
- `Temporary` — Will be cleaned up after current development cycle
- `Placeholder` — Structure exists, content not yet generated

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
