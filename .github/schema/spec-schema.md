This file defines the spec schema — the contract between @interviewer (producer) and @creator (consumer) for all artifact types. The governing principle is one schema, four artifact types — shared fields are unmarked, artifact-specific fields are marked with their type.


<design_decisions>

Shared principles governing all spec files, regardless of artifact type.

- Intelligence split: @interviewer decides WHAT to build. @creator decides HOW to structure it
- @creator input: manifest path + own spec path. @creator reads manifest for relationship context, deep-reads own spec for details
- Source fetching: @creator fetches ALL sources in spec (soft cap: 5). Flags excess
- Spec language: requirements language ("validate input before processing"), not artifact body language
- No cross-references between spec files — each spec is self-contained for its @creator

**Agent-specific:**

- Profile selection: explicit — @interviewer sets it from the 6 archetypes
- Relationship data: lives in manifest orchestration section, not in individual specs

**Skill-specific:**

- No profile selection — skills have no behavioral archetypes. Structure derives from complexity signals
- Complexity drives structure: @creator decides folder organization from capability signals

**Instruction-specific:**

- No profile selection — instructions have no behavioral archetypes. Structure derives from sub-type and rule complexity
- No `mutation_level` — instructions produce no side effects. They are passive ambient constraints
- No separate `safety_rules`/`quality_rules` — instructions ARE the rules. Spec uses a single `rules` field

**Prompt-specific:**

- No profile selection — prompts have no behavioral archetypes. Structure derives from task complexity
- No `mutation_level` — prompts produce text output only. Destructive capability belongs to the agent
- No `safety_rules` — prompts have no safety surface. Safety constraints belong to the agent executing the prompt

</design_decisions>


<readiness_tiers>

Tier structure applies to all artifact types. Artifact-specific fields appear only when `artifact_type` matches.

- **Tier 1 — Required (block if missing):** `artifact_type`, `spec_version`, `name`, `purpose`, `domain`, `profile` [Agent]
- **Tier 2 — Important (default if missing):** `tech`, `capabilities` [Agent], `mutation_level` [Agent], `safety_rules` [Agent], `quality_rules` [Agent], `trigger` [Agent], `capabilities` [Skill], `complexity_signals` [Skill], `step_count` [Skill], `error_modes` [Skill], `instruction_type` [Instruction], `applies_to` [Instruction], `rules` [Instruction], `discovery_mode` [Instruction], `task_description` [Prompt], `agent_mode` [Prompt], `tools_needed` [Prompt], `variables` [Prompt], `output_format` [Prompt]
- **Tier 3 — Enrichment (skip and note if missing):** `sources`, `concepts`, `notes`, `interviewer_notes`, `stance` [Agent], `expertise` [Agent], `file_boundaries` [Agent], `confirmation_gates` [Agent], `primary_risk` [Agent], `max_iterations` [Agent], `folder_structure` [Skill], `reference_files` [Skill], `loading_strategy` [Skill], `stackability_context` [Instruction], `argument_hint` [Prompt], `example_input` [Prompt], `example_output` [Prompt]
- **Meta — Pipeline (used by @master):** `priority`

</readiness_tiers>


<field_definitions>

<tier_1>

Required fields. @creator halts and reports error to @master if any is missing.

- `artifact_type` — `"agent"` | `"skill"` | `"instruction"` | `"prompt"` — Set by @interviewer. @creator uses to select the appropriate creator skill
- `spec_version` — `integer`, currently `1` — Schema version for forward compatibility
- `name` — `string` — Artifact name, lowercase-with-hyphens. @interviewer derives from capability or task description. @creator uses for filename and frontmatter `name`
- `purpose` — `string` — One sentence: what this artifact does. @interviewer derives from user description. @creator uses for frontmatter `description`, prose intro
- `domain` — `string` — Operating area (e.g., "testing", "devops", "typescript"). From `project.domain`. @creator uses for terminology calibration
- `profile` — **[Agent]** enum: `guide` | `transformer` | `curator` | `diagnostician` | `analyst` | `operator` — @interviewer selects based on workflow behavioral shape. @creator uses to load archetype from agent-profiles.md — determines tags, tools, constraint pattern, scaling, termination inclusion

</tier_1>

<tier_2>

Important fields. @creator defaults from profile/complexity signals if missing.

**Shared:**

- `tech` — `{languages: string[], frameworks?: string[], tools?: string[]}` — Stack relevant to this artifact. @interviewer filters from project tech. @creator uses for code-aware constraints, tool selection, framework-specific rules

**[Agent] fields:**

- `capabilities` — `string[]` — Action verbs: what the agent can do (e.g., `["run migrations", "verify rollback"]`). @creator uses for Do/Ask/Don't boundaries, mode triggers
- `mutation_level` — `none` | `low` | `high` — `none` = read-only, `low` = edits files, `high` = runs commands, deletes data, deploys. @creator uses to calibrate iron law depth: `none` → 0 iron laws; `low` → 0-1; `high` → 1-3 with full rationalization tables
- `safety_rules` — `string[]` — Hard constraints from `constraints.safety`, filtered per-agent. @creator converts each to a NEVER bullet; promotes high-consequence ones to `<iron_law>`
- `quality_rules` — `string[]` — Soft rules from `constraints.quality`, filtered per-agent. @creator converts to ALWAYS bullets or behavioral guidelines
- `trigger` — `string` — What starts this agent's work. @creator uses for `argument-hint` and mode trigger phrasing

**[Skill] fields:**

- `capabilities` — `string[]` — Action verbs: what the skill enables (e.g., `["scaffold endpoints", "generate validation"]`). @creator uses for step design, description trigger phrases
- `complexity_signals` — `string[]` — Indicators of structural needs (e.g., `["needs shell scripts", "has decision rules"]`). @creator uses for folder structure decisions — `scripts/`, `references/`, `assets/`
- `step_count` — `integer` — Estimated number of workflow steps. @creator uses as starting point (may adjust during drafting)
- `error_modes` — `string[]` — Known failure scenarios. @creator converts to If/Then entries in `<error_handling>`

**[Instruction] fields:**

- `instruction_type` — enum: `repo-wide` | `path-specific-triggered` | `path-specific-on-demand` — @creator uses for sub-type decision: `repo-wide` → no frontmatter, fixed filename; `path-specific-triggered` → `applyTo` + `description`; `path-specific-on-demand` → `description` only
- `applies_to` — `{agents?: string[], file_patterns?: string[]}` — @creator uses `file_patterns` for frontmatter `applyTo` pattern generation. `agents` identifies which agents this instruction targets
- `rules` — `{safety?: string[], quality?: string[], conventions?: string[]}` — The rules to encode. @creator converts: `safety` → ALWAYS/NEVER bullets, `quality` → imperative bullets, `conventions` → Wrong/Correct pairs
- `discovery_mode` — enum: `file-triggered` | `on-demand` | `hybrid` — @creator uses for frontmatter configuration

**[Prompt] fields:**

- `task_description` — `string` — Detailed description of what the prompt instructs the agent to do. @creator uses for body content
- `agent_mode` — `string`, optional — Custom agent name for execution. Built-in names (`ask`, `edit`, `agent`) are not allowed. If omitted, the current agent handles the prompt. @creator uses for frontmatter `agent` field
- `tools_needed` — `string[]` — Tools the prompt references. @creator uses for body `#tool:<name>` inline references (not frontmatter — `tools` frontmatter field is not used)
- `variables` — `string[]` — Variables the prompt uses. @creator uses for `${variable}` placement in body
- `output_format` — `string` — Expected output shape. @creator uses for format instructions in body

</tier_2>

<tier_3>

Enrichment fields. @creator skips if missing, flags `enrichment_skipped: true` in output.

**Shared:**

- `sources` — `[{url: string, about: string, relevance: string}]` — URLs routed from questionnaire. @creator fetches all (soft cap: 5) for grounded content writing
- `concepts` — `[{name: string, relevance: string}]` — Domain terms. @creator uses for accurate vocabulary
- `notes` — `string[]` — Free-text context routed per-artifact. @creator integrates into most relevant section
- `interviewer_notes` — `string` — @interviewer's reasoning for proposing this artifact. Tiebreaker for @creator when ambiguity arises

**[Agent] fields:**

- `stance` — `string` — Tone/posture (e.g., "cautious", "proactive", "strict"). @creator uses for identity prose tone, constraint density calibration
- `expertise` — `string[]` — Domain knowledge areas. @creator uses for identity prose "Expert in..."
- `file_boundaries` — `{include?: string[], exclude?: string[]}` — File/directory scope. @creator converts to Do/Don't boundary items
- `confirmation_gates` — `string[]` — Actions requiring user confirmation. @creator converts to "Ask First" items
- `primary_risk` — `string` — Single highest-consequence failure scenario. @creator uses in `<constraints>` prose intro
- `max_iterations` — `integer` — Maximum cycles before escalation. @creator uses in `<termination>`. Relevant for multi-mode agents only

**[Skill] fields:**

- `folder_structure` — `string[]` — Suggested subfolders (e.g., `["scripts/", "references/"]`). @creator validates against actual content needs — may override
- `reference_files` — `string[]` — Suggested reference documents. @creator creates if content justifies extraction
- `loading_strategy` — `string` — Suggested loading approach (e.g., `"JIT for decision rules, eager for templates"`). @creator implements via loading directives

**[Instruction] fields:**

- `stackability_context` — `string[]` — Existing instruction files that may overlap. @creator checks for contradictions and duplications before delivery

**[Prompt] fields:**

- `argument_hint` — `string` — Suggested hint text for chat input. @creator uses for frontmatter `argument-hint`
- `example_input` — `string` — Example invocation showing how user triggers the prompt. @creator uses to validate variable design
- `example_output` — `string` — Expected output sample. @creator uses for output format instructions in body

</tier_3>

<meta>

Pipeline fields used by @master for sequencing. @creator reads but does not act on.

- `priority` — `P1` | `P2` | `P3` — P1 = blocks other artifacts or core workflow. P2 = enhances quality. P3 = nice-to-have. @master uses for sequencing; P1 failure halts pipeline

</meta>

</field_definitions>


<example_specs>

One example per artifact type demonstrating field usage.

**Agent example:**

```yaml
artifact_type: agent
spec_version: 1
name: deployer
purpose: "Executes deployment pipelines to staging and production environments"
domain: devops
profile: operator
priority: P1

capabilities:
  - "run deployment scripts"
  - "verify environment state before deploy"
  - "execute rollback procedures"
  - "check service health post-deploy"

mutation_level: high
safety_rules:
  - "never deploy to production without explicit approval"
  - "never skip pre-deployment health checks"
  - "always have a rollback plan before deploying"
quality_rules:
  - "log every deployment action with timestamps"
  - "verify all environment variables are set before deploy"
trigger: "deployment requested or PR merged to main"

tech:
  languages: [Python, Bash]
  frameworks: [Ansible]
  tools: [GitHub Actions, Docker]

sources:
  - url: "https://docs.company.com/deploy-runbook"
    about: "Internal deployment runbook"
    relevance: "Defines deployment steps, rollback procedures, and health check endpoints"

concepts:
  - name: "blue-green deployment"
    relevance: "Primary deployment strategy — agent must understand switchover and rollback"

stance: cautious
primary_risk: "failed production deployment with no rollback path"
max_iterations: 5
interviewer_notes: "User described a manual deployment process with frequent rollback needs."
```

**Skill example:**

```yaml
artifact_type: skill
spec_version: 1
name: api-scaffold
purpose: "Scaffolds REST API endpoints with routing, validation, and error handling"
domain: api-development
priority: P1

capabilities:
  - "generate route handlers from OpenAPI or description"
  - "add input validation middleware"
  - "create standardized error responses"
  - "produce TypeScript types from schema"

complexity_signals:
  - "needs code templates for route handlers"
  - "has decision rules for framework detection"
  - "requires validation schema examples"

step_count: 6
error_modes:
  - "unsupported framework detected"
  - "OpenAPI spec has validation errors"
  - "conflicting route patterns"

tech:
  languages: [TypeScript, JavaScript]
  frameworks: [Express, Fastify]
  tools: [OpenAPI]

sources:
  - url: "https://expressjs.com/en/guide/routing.html"
    about: "Express routing documentation"
    relevance: "Route handler patterns and middleware chaining for Express-based scaffolding"

concepts:
  - name: "middleware chain"
    relevance: "Core pattern for validation and error handling"

folder_structure:
  - "references/"
  - "assets/"
reference_files:
  - "framework-patterns.md"
  - "validation-schemas.md"
loading_strategy: "JIT for framework patterns, eager for validation schemas"
interviewer_notes: "User described manual endpoint creation with repeated boilerplate."
```

**Instruction example:**

```yaml
artifact_type: instruction
spec_version: 1
name: typescript-standards
purpose: "TypeScript coding standards for type safety, naming, and error handling"
domain: typescript
priority: P2

instruction_type: path-specific-triggered
applies_to:
  file_patterns: ["**/*.ts", "**/*.tsx"]
rules:
  safety:
    - "never use any type without explicit narrowing"
    - "always handle Promise rejections"
  quality:
    - "use interface for extensible object shapes, type for unions and intersections"
  conventions:
    - "use PascalCase for types and interfaces"
    - "use camelCase for variables and functions"
discovery_mode: file-triggered

tech:
  languages: [TypeScript]
  frameworks: [React]

sources:
  - url: "https://www.typescriptlang.org/docs/"
    about: "TypeScript official documentation"
    relevance: "Canonical type system patterns and best practices"

concepts:
  - name: "type narrowing"
    relevance: "Core safety practice — rules must explain narrowing patterns"

stackability_context:
  - "general-coding.instructions.md applies to ** — check for contradictions"
interviewer_notes: "User wants strict type safety. Team has history of any-type overuse."
```

**Prompt example:**

```yaml
artifact_type: prompt
spec_version: 1
name: generate-tests
purpose: "Generate comprehensive test cases for selected code"
domain: testing
priority: P2

task_description: "Analyze the selected code, identify edge cases, error scenarios, and happy paths, then generate test cases following existing patterns in the codebase"
agent_mode: agent
tools_needed: ["search/codebase"]
variables: ["selection", "file"]
output_format: "code block with test file contents"

tech:
  languages: [TypeScript]
  frameworks: [Jest, Vitest]

sources:
  - url: "https://jestjs.io/docs/getting-started"
    about: "Jest documentation"
    relevance: "Test syntax and assertion patterns for generated tests"

concepts:
  - name: "boundary testing"
    relevance: "Prompt must instruct to test boundary conditions"

argument_hint: "Select code to generate tests for"
example_input: "/generate-tests"
example_output: "TypeScript test file with describe/it blocks"
interviewer_notes: "User wants consistent test generation. Tests should follow existing patterns."
```

</example_specs>
