This file defines the output sections for project-level copilot-instructions.md files. The governing principle is fixed structure with project-specific content — the section order and standard rules are closed, project extension happens through workspace entries and custom constraints.


<workspace_section>

Directory listing of project structure and agent infrastructure. Provides all agents with workspace awareness. Two groups appear in order: project structure first, then agent infrastructure.

- Entry format: `- \`{path}\` — {description} — \`{status}\``
- Status values: `Active` (authoritative, use as source of truth), `Placeholder` (structure exists, content not yet generated)

<project_structure>

User-completed entries describing the project's source directories, config files, and build output paths. These entries appear first in the workspace listing. Each entry includes a `<!-- TODO: ... -->` HTML comment hint guiding the user to fill in the correct path and description.

- Placeholder entries at generation time — users replace with their actual project paths
- Example placeholder entries: `src/`, `tests/`, `docs/`, `dist/`
- Any relative path is valid — not restricted to `.github/`

</project_structure>

<agent_infrastructure>

Generated entries describing the agent framework artifacts. These entries appear after project structure entries.

- `.github/agents/core/` as a single consolidated entry — not individual core agent files
- Domain agents listed individually: `.github/agents/{name}.agent.md`
- Skills listed by folder: `.github/skills/{name}/`
- Instructions listed by file: `.github/instructions/{name}.instructions.md`
- Prompts listed by file: `.github/prompts/{name}.prompt.md`

</agent_infrastructure>

- Sort order: project directories → agents → skills → instructions → prompts

</workspace_section>


<project_context_section>

Project-specific context that agents need to operate effectively. Section is always present — not conditional. Contains 5 sub-areas, each with a bold header and prose bullets.

- `tech_stack` input partially fills the Tech stack sub-area at generation time
- All other sub-areas are placeholder at generation time with `<!-- TODO: ... -->` HTML comment guidance
- Each placeholder includes a brief HTML comment hint explaining what to fill in

5 sub-areas:

- **Project overview** — what the project does, high-level architecture, how components relate
- **Tech stack** — languages, frameworks, key libraries with versions. Partially filled from `tech_stack` input; remaining items are placeholder
- **Naming conventions** — file naming, class/function/variable naming patterns, module organization
- **Key abstractions** — domain model, core interfaces/types, architectural patterns in use
- **Testing strategy** — test types (unit/integration/e2e), file locations, coverage expectations, test framework

</project_context_section>


<constraints_section>

Project rules applied to all agents. Combines standard rules with project-specific constraints.

3 standard rules (always included — exact text):

- "copilot-instructions.md takes precedence over domain instruction files"
- "Trust documented structure without re-verification; verify all facts, file contents, and citations before citing — never fabricate sources, file paths, or quotes"
- "Do only what is requested or clearly necessary; treat undocumented features as unsupported"

Project-specific rules are appended after standard rules. Each rule is a bullet point in imperative voice, no sub-bullets.

</constraints_section>


<decision_making_section>

Priority framework for all agents. Content is fixed — no project-specific additions.

4 standard bullets (always included verbatim):

- "When rules conflict, apply: Safety → Accuracy → Clarity → Style — the first dimension that distinguishes options wins"
- "Classify issues by impact: P1 blocks completion, P2 degrades quality, P3 is optional"
- "Calibrate decisions to confidence: high confidence → proceed; medium confidence → flag uncertainty, ask; low confidence → stop, request clarification"
- "When resources are unavailable, state the gap, provide an explicit workaround, continue"

</decision_making_section>


<commands_section>

Project-specific development commands for all agents. Ensures every agent can build, test, lint, and run the project.

- Format: grouped by category, each command as a bullet with inline code and brief annotation
- Categories (include only applicable ones): Environment setup, Build, Test, Lint / Format, Run, Deploy
- Entry format: `- \`command here\` — brief description`
- Each category is a plain text header line followed by its command bullets
- Section is required when `project_commands` input is provided, omitted when not provided

</commands_section>


<environment_section>

Runtime environment context for all agents. Describes how the project's development environment works — interpreter versions, package management, scripting conventions, and prerequisites — so agents can operate correctly without guessing.

- Entry format: prose bullets grouped by sub-area (NOT command format — this is context about how the environment works, not commands to run)
- Sub-areas (include only applicable ones):

  **Runtime environment** — interpreter paths, version requirements (e.g., Python 3.12+, Node 20 LTS), virtual environment activation conventions, container usage (Docker, devcontainers), platform expectations

  **Package management** — which package manager is authoritative (pip, uv, poetry, npm, pnpm), lock file conventions and whether lock files are committed, how to add or remove dependencies, monorepo package boundaries if applicable

  **Ad-hoc scripting** — whether agents may run Python/shell/R/PowerShell scripts for one-off tasks, conventions for script location (e.g., `scripts/` directory), cleanup expectations, language preference for ad-hoc work

  **Environment variables** — naming conventions, `.env` file patterns and whether `.env` is committed or gitignored, required variables for local development, secrets handling approach (vault, environment injection, never hardcoded)

  **Prerequisites** — what must be running before agents can work (Docker containers, databases, message queues, external services), startup order if relevant, health-check conventions

  **Common development patterns** — hot reload conventions, database seeding and fixture setup, migration workflow (auto-apply vs. manual), testing patterns (unit/integration/e2e separation), log levels and observability conventions

- Each sub-area is a bold header followed by its prose bullets
- Section is required when `environment_context` input is provided, omitted when not provided

</environment_section>


<agent_listing>

Optional prose section after `</decision_making>`. Not wrapped in an XML tag in the output file.

- One-line cross-reference to `.github/agents/core/` naming all 6 core agents (brain, researcher, architect, build, inspect, curator) — no individual core agent descriptions
- Followed by individual bullet entries for domain agents only (name + one-line description)
- Purpose: cross-agent awareness — agents understand who else exists and what they do
- Content derived from `domain_agents` input; core agents referenced as a group

</agent_listing>
