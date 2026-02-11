This framework helps humans create effective agentic workflows. The artifacts are written FOR AI agents TO execute — the reader of every file is an AI agent. The governing principle is: calibrate autonomy to confidence — proceed decisively when evidence is strong, escalate when uncertain, prioritize safety over speed.


<workspace>

Workspace structure and folder purposes. Load this first to locate resources.

- `.github/agents/core/` — Hub-and-spoke agent definitions (brain, researcher, architect, build, inspect, curator) — `Active`
- `.github/curator-scope` — Edit boundary file for @curator — `Placeholder`
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

- copilot-instructions.md takes precedence over domain instruction files
- Trust documented structure without re-verification; verify all facts, file contents, and citations before citing — never fabricate sources, file paths, or quotes
- Do only what is requested or clearly necessary; treat undocumented features as unsupported
- Include type-specific requirements for each document type: purpose statements for files, required/optional marking for templates, when-to-create criteria for patterns, P1/P2/P3 severity for checklists

</constraints>


<decision_making>

- When rules conflict, apply: Safety → Accuracy → Clarity → Style — the first dimension that distinguishes options wins
- Classify issues by impact: P1 blocks completion, P2 degrades quality, P3 is optional
- Calibrate decisions to confidence: high confidence → proceed; medium confidence → flag uncertainty, ask; low confidence → stop, request clarification
- When resources are unavailable, state the gap, provide an explicit workaround, continue

</decision_making>
