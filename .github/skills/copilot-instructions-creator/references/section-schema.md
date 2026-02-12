This file defines the output sections for project-level copilot-instructions.md files. The governing principle is fixed structure with project-specific content — the section order and standard rules are closed, project extension happens through workspace entries and custom constraints.


<workspace_section>

Directory listing of project artifacts. Provides all agents with workspace awareness.

- Entry format: `- \`.github/{path}\` — {description} — \`{status}\``
- Status values: `Active` (authoritative, use as source of truth), `Placeholder` (structure exists, content not yet generated)
- Required entry: `.github/agents/core/` — always present in every project
- Domain agents listed individually as flat entries: `.github/agents/{name}.agent.md`
- Skills listed by folder: `.github/skills/{name}/`
- Instructions listed by file: `.github/instructions/{name}.instructions.md`
- Prompts listed by file: `.github/prompts/{name}.prompt.md`
- Sort order: agents → skills → instructions → prompts

</workspace_section>


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

- Brief description of each core agent (brain, researcher, architect, build, inspect, curator) and each domain agent
- Purpose: cross-agent awareness — agents understand who else exists and what they do
- Format: prose paragraph or bullet list
- Content derived from `domain_agents` input and standard core agent descriptions

</agent_listing>
