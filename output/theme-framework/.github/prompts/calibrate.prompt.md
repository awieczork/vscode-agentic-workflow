---
description: 'Scan workspace and update copilot-instructions.md to match the target project structure'
agent: 'brain'
argument-hint: 'Optionally describe any project context, conventions, or areas to focus on'
---

<!-- Run once after copying generated artifacts to a target workspace. Provide project context if available. -->

Scan the current workspace and update `.github/copilot-instructions.md` so it accurately reflects the target project.


<scan_directive>

Handoff to @researcher to scan the workspace filesystem and gather evidence for calibration:

- **Directory structure** — map top-level and key nested directories, note purpose of each
- **Tech stack indicators** — detect from manifest files (package.json, Cargo.toml, pyproject.toml, go.mod, etc.)
- **Build and test commands** — extract from scripts, CI configs, Makefiles, or manifest files
- **Existing documentation** — README, CONTRIBUTING, architecture docs, inline conventions
- **Agent inventory** — list agents present in `.github/agents/` and verify against copilot-instructions.md

Scan evidence drives every update — never fabricate entries from assumptions.

</scan_directive>


<update_scope>

ONLY `.github/copilot-instructions.md` is modified. No other files are created, deleted, or changed.

Update these sections using scan evidence:

- **`<workspace>`** — Replace directory map with actual project structure. Include brief descriptions derived from scan
- **`<agents>`** — Verify agent listing matches agents found in `.github/agents/`. Add missing entries, flag removed ones
- **`<conventions>`** — Add project-specific conventions discovered from scan (linting configs, naming patterns, tech stack). Preserve existing framework conventions
- **`<rules>`** — Add project-specific rules discovered from CI pipelines, linting configs, or documentation. Preserve existing core rules

Every addition must cite scan evidence. Every removal must state the reason.

</update_scope>


<preserve_rules>

- NEVER remove the 4 core XML sections: `<workspace>`, `<agents>`, `<conventions>`, `<rules>`
- NEVER remove core agent references (@brain, @researcher, @architect, @build, @inspect, @curator) from the agent listing
- NEVER modify framework conventions or rules unless they conflict with verified workspace evidence
- Preserve the intro prose paragraph at the top of copilot-instructions.md
- Additions and corrections only — do not strip existing valid content

</preserve_rules>


<output_format>

Handoff to @curator to write the updated `.github/copilot-instructions.md`.

After the update, report:

- Sections modified and what changed in each
- Entries added or removed, with the scan evidence that justified each change
- Any conflicts detected between existing content and workspace evidence

</output_format>
