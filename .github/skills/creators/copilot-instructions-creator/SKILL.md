---
name: 'copilot-instructions-creator'
description: 'Generates project-level copilot-instructions.md files for output projects. Use when asked to "create copilot-instructions", "generate project instructions", or "scaffold workspace config". Produces workspace map, project context, project constraints, decision framework, development commands, environment context, and agent listing.'
---

This skill produces the `.github/copilot-instructions.md` file for generated output projects. The governing principle is fixed structure with project-specific content — the file is a repo-wide instruction that VS Code loads on every chat request, providing all agents with workspace awareness, project context, project constraints, decision-making guidance, development commands, and environment context. Begin with `<step_1_analyze>` to validate inputs and load section definitions.


<use_cases>

- Generation workflow producing a new project's workspace configuration
- Scaffolding a complete `.github/` folder for a repository
- Updating an existing project's copilot-instructions after adding new artifacts
- Migrating a project to the hub-and-spoke agent model

</use_cases>


<workflow>

Execute steps sequentially. Each step produces content that feeds the next.


<step_1_analyze>

Validate required and optional inputs before generating content.

Required inputs:

- `artifact_proposal` — list of artifacts with name, type, path, description
- `project_name` — identifier for the output project
- `project_area` — domain or functional area of the project
- `tech_stack` — technologies and frameworks used
- `domain_agents` — list with name, profile, description, tools

Optional inputs:

- `project_commands` — collected from interview — categorized development commands for the project's tech stack
- `environment_context` — collected from interview — runtime environment details: interpreter conventions, package management, ad-hoc scripting, environment variables, prerequisites, common development patterns
- `safety_constraints` — from interview Round 3
- `quality_rules` — project-specific quality standards
- `approval_requirements` — approval gates or review requirements

Load [section-schema.md](./references/section-schema.md) for: section definitions, field specifications, and output structure.

</step_1_analyze>


<step_2_generate_workspace>

Load [settings-readme.md](../../../templates/vscode/settings-readme.md) for: VS Code settings template purpose and key discovery configuration guidance.

Generate the `<workspace>` section with project structure placeholders and agent infrastructure entries. Apply format from `<workspace_section>` in [section-schema.md](./references/section-schema.md).

- Write prose intro: brief statement about the workspace structure and folder purposes (1-2 sentences)

**Project structure placeholders:**

- Generate HTML comment separator: `<!-- Project structure — update these entries to match your project layout -->`
- Add static placeholder entries for users to replace with their actual project paths:
  - `src/` — `<!-- TODO: Describe your main source directory -->` — `Placeholder`
  - `tests/` — `<!-- TODO: Describe your test directory -->` — `Placeholder`
  - `docs/` — `<!-- TODO: Describe your documentation directory -->` — `Placeholder`
  - `dist/` — `<!-- TODO: Describe your build output directory -->` — `Placeholder`

**Agent infrastructure entries:**

- Generate HTML comment separator: `<!-- Agent infrastructure — generated, no changes needed -->`
- Build entries from `artifact_proposal` and `domain_agents`:
  - `.github/agents/core/` — "{project_name} core agents (hub-and-spoke lifecycle)" — `Active` (single consolidated entry for all core agents)
  - For each domain agent: `.github/agents/{name}.agent.md` — "{description}" — `Active`
  - For each skill: `.github/skills/{name}/` — "{description}" — status per artifact
  - For each instruction: `.github/instructions/{name}.instructions.md` — "{description}" — status per artifact
  - For each prompt: `.github/prompts/{name}.prompt.md` — "{description}" — status per artifact
- Apply status markers: `Active` for content-bearing artifacts, `Placeholder` for structure-only
- Sort agent infrastructure entries: agents → skills → instructions → prompts
- Close with `</workspace>` tag

</step_2_generate_workspace>


<step_3_generate_project_context>

Generate the `<project_context>` section with all 5 sub-areas. This section is always present — not conditional. Apply format from `<project_context_section>` in [section-schema.md](./references/section-schema.md).

- **Project overview** — fully placeholder:
  - `<!-- TODO: Describe what the project does, its architecture, and how components relate -->`

- **Tech stack** — partially filled from `tech_stack` input when provided:
  - Populate languages, frameworks, and core tools from `tech_stack` input
  - Leave library versions and secondary tools as placeholders with `<!-- TODO: Add version -->` or `<!-- TODO: Add secondary tools -->` hints
  - If `tech_stack` is not provided, entire sub-area is placeholder: `<!-- TODO: List languages, frameworks, key libraries with versions -->`

- **Naming conventions** — fully placeholder:
  - `<!-- TODO: Describe file naming, class/function/variable patterns, module organization -->`

- **Key abstractions** — fully placeholder:
  - `<!-- TODO: Describe domain model, core interfaces/types, architectural patterns -->`

- **Testing strategy** — fully placeholder:
  - `<!-- TODO: Describe test types, locations, coverage expectations, test framework -->`

- Each sub-area has a bold header followed by placeholder bullet(s) or populated content
- Close with `</project_context>` tag

</step_3_generate_project_context>


<step_4_generate_constraints>

Generate the `<constraints>` section with standard and project-specific rules. Apply format from `<constraints_section>` in [section-schema.md](./references/section-schema.md).

- Start with 3 standard rules (always include, exact text):
  - "copilot-instructions.md takes precedence over domain instruction files"
  - "Trust documented structure without re-verification; verify all facts, file contents, and citations before citing — never fabricate sources, file paths, or quotes"
  - "Do only what is requested or clearly necessary; treat undocumented features as unsupported"
- Append project-specific constraints from `safety_constraints`, `quality_rules`, and `approval_requirements` if provided
- Each constraint is a bullet point, imperative voice
- Close with `</constraints>` tag

</step_4_generate_constraints>


<step_5_generate_decision_making>

Generate the `<decision_making>` section with standard content. Apply format from `<decision_making_section>` in [section-schema.md](./references/section-schema.md).

- Include 4 standard bullets (always include verbatim):
  - "When rules conflict, apply: Safety → Accuracy → Clarity → Style — the first dimension that distinguishes options wins"
  - "Classify issues by impact: P1 blocks completion, P2 degrades quality, P3 is optional"
  - "Calibrate decisions to confidence: high confidence → proceed; medium confidence → flag uncertainty, ask; low confidence → stop, request clarification"
  - "When resources are unavailable, state the gap, provide an explicit workaround, continue"
- Close with `</decision_making>` tag

</step_5_generate_decision_making>


<step_6_generate_commands>

Generate the `<commands>` section from `project_commands` input. Apply format from `<commands_section>` in [section-schema.md](./references/section-schema.md).

- If `project_commands` is empty or not provided, SKIP this step entirely — no `<commands>` section in output
- Group commands by category: Environment setup, Build, Test, Lint / Format, Run, Deploy
- Each category as a plain text header line, followed by command bullets with inline code + annotation
- Only include categories where commands were provided — omit empty categories
- Entry format per command: `- \`command\` — brief description`
- Close with `</commands>` tag

</step_6_generate_commands>


<step_7_generate_environment>

Generate the `<environment>` section from `environment_context` input. Apply format from `<environment_section>` in [section-schema.md](./references/section-schema.md).

- If `environment_context` is empty or not provided, SKIP this step entirely — no `<environment>` section in output
- Group content by sub-area: Runtime environment, Package management, Ad-hoc scripting, Environment variables, Prerequisites, Common development patterns
- Each sub-area as a bold header line, followed by prose bullets describing the context
- Only include sub-areas where context was provided — omit empty sub-areas
- Entry format: prose bullets (NOT command format — this describes how the environment works, not commands to run)
- Close with `</environment>` tag

</step_7_generate_environment>


<step_8_write>

Assemble and write the output file.

Load [example-copilot-instructions.md](./assets/example-copilot-instructions.md) for: annotated reference output.

- Location: `output/{project_name}/.github/copilot-instructions.md`
- Format: NO frontmatter (no `---` YAML block). Content begins immediately with prose
- Write prose intro (1-3 sentences): describes the project and its governing framework principle
- Append sections in order: `<workspace>`, `<project_context>`, `<constraints>`, `<decision_making>`, `<commands>` (if `project_commands` provided), `<environment>` (if `environment_context` provided)
- Agent listing: place after `</decision_making>` and before `<commands>` (or before `<environment>` if no commands, or at end if neither). Follow `<agent_listing>` in [section-schema.md](./references/section-schema.md):
  - One-line cross-reference to `.github/agents/core/` naming all 6 core agents (brain, researcher, architect, build, inspect, curator)
  - Individual bullet entries for domain agents only (name + one-line description)
- Validate output:
  - File starts with prose (no `---` at line 1)
  - Minimum 4 sections: `<workspace>`, `<project_context>`, `<constraints>`, `<decision_making>` (always present)
  - Maximum 6 sections: + `<commands>` + `<environment>` (when inputs provided)
  - `<project_context>` always present (not conditional)
  - Workspace listing includes both project structure placeholder entries and agent infrastructure entries from `artifact_proposal`
  - All artifacts from `artifact_proposal` listed in `<workspace>`
  - Standard constraint rules present (3 required bullets)
  - Standard `<decision_making>` content present verbatim (4 required bullets)

</step_8_write>


</workflow>


<error_handling>

- If `artifact_proposal` is missing, then STOP and request artifact list from caller
- If `project_name` is missing, then STOP and request project identifier from caller
- If `domain_agents` list is empty, then PROCEED — generate workspace with core agents only (valid for projects with no domain agents)
- If safety constraints are not provided, then PROCEED — use standard rules only, note omission in build summary
- If `project_commands` is empty or missing, then PROCEED — omit `<commands>` section entirely, note omission in build summary
- If `environment_context` is empty or missing, then PROCEED — omit `<environment>` section entirely, note omission in build summary
- If `tech_stack` is not provided, then PROCEED — Tech stack sub-area in `<project_context>` is fully placeholder with `<!-- TODO -->` hint

</error_handling>


<validation>

Load [shared-validation-rules.md](../artifact-author/references/shared-validation-rules.md) for: shared P1/P2/P3 validation rules

**P1 (blocking):**

- Output file has NO frontmatter (no `---` at line 1)
- Required sections: `<workspace>`, `<project_context>`, `<constraints>`, `<decision_making>` (always). Optional sections: `<commands>` (when `project_commands` provided), `<environment>` (when `environment_context` provided). Total: 4 to 6 sections depending on optional inputs
- Every artifact from `artifact_proposal` appears in `<workspace>` listing
- Standard constraint rules present (3 required bullets with exact text)
- Standard `<decision_making>` content present verbatim (4 required bullets)

**P2 (quality):**

- Prose intro present before first XML tag
- All workspace entries have status markers (`Active` or `Placeholder`)
- `<project_context>` section contains all 5 sub-areas (Project overview, Tech stack, Naming conventions, Key abstractions, Testing strategy)
- Workspace section contains project structure placeholder entries before agent infrastructure entries
- Tech stack sub-area is partially filled from `tech_stack` input when provided
- Project-specific constraints from interview included when provided
- Environment context sub-areas use prose format (not command format)

**P3 (polish):**

- Sort order: project directories → agents → skills → instructions → prompts
- Path format uses forward slashes, no drive letters

</validation>


<resources>

- [section-schema.md](./references/section-schema.md) — Section field definitions and output format specification. Load for `<step_1_analyze>`, `<step_2_generate_workspace>`, `<step_3_generate_project_context>`, `<step_4_generate_constraints>`, `<step_5_generate_decision_making>`, `<step_6_generate_commands>`, `<step_7_generate_environment>`, `<step_8_write>`
- [example-copilot-instructions.md](./assets/example-copilot-instructions.md) — Annotated reference output
- [settings-readme.md](../../../templates/vscode/settings-readme.md) — Documents the VS Code settings template structure and key purposes for framework workspace discovery configuration

</resources>
