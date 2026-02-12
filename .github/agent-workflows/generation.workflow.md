---
description: 'Generation workflow — expert interview, artifact proposal, orchestrated creation pipeline'
triggers: ['init-project']
phases: ['interview', 'research', 'plan', 'build', 'verify', 'finalize']
---

<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- INTERVIEW GUIDANCE — @brain follows this structure using askQuestions -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<interview_guidance>

Drive a multi-round expert interview to understand the project and identify artifact opportunities. The seed is a springboard — conversation is the primary knowledge source. Use `#tool:askQuestions` for all interview questions. Frame every question with at least 2 curated options + a custom input option. Allow multi-select where appropriate — phrase as "Select all that apply" with lettered options + custom.

Assess seed richness — thin seed (1-2 sentences) triggers more probing. Rich seed (detailed description) triggers fewer rounds and more confirmation.


<round_1 name="Understand the project">

Dig into the description and goal. Frame questions with curated options based on seed content.

Example question formats:

- What is your primary development workflow?
  - A) Solo developer — I build, test, and deploy everything
  - B) Team — PRs, code reviews, CI/CD pipeline
  - C) Monorepo with multiple services
  - D) Data science — notebooks, experiments, model training
  - E) Custom — describe your workflow

- What frustrates you most day-to-day? (Select all that apply)
  - A) Manual repetitive tasks
  - B) Inconsistent code quality across the team
  - C) Slow debugging cycles
  - D) Deployment and environment issues
  - E) Documentation falling out of sync
  - F) Something else — describe your pain points

Adapt options to the `tech` and `area` from the seed. If the user provided a rich description, confirm understanding with targeted options instead of broad questions.

- Tell me about your development workflow commands. For each category that applies to your project, what command(s) do you use? (Share what applies)
  - A) Environment setup — e.g., `conda activate myenv`, `nvm use 18`, `docker compose up -d`
  - B) Build / Compile — e.g., `npm run build`, `cargo build`, `go build ./...`
  - C) Test — e.g., `pytest tests/`, `npm test`, `dotnet test`
  - D) Lint / Format — e.g., `black .`, `eslint src/`, `gofmt -w .`
  - E) Run / Serve — e.g., `uvicorn main:app`, `npm run dev`, `flask run`
  - F) Deploy — e.g., `docker push`, `terraform apply`, `fly deploy`

Adapt the example commands to match the user's `tech` stack from the seed. Allow free-form input for each selected category to capture exact commands with flags and arguments. Store collected commands as `project_commands` grouped by category.

- What does an agent need to know to work smoothly in your project environment? (Select all that apply)
  - A) Virtual environment / container setup — how to activate the dev environment (e.g., `source .venv/bin/activate`, `conda activate myenv`, Docker dev container)
  - B) Environment variables — required `.env` files, variables needed for local dev, secrets handling approach
  - C) Services and prerequisites — what must be running (e.g., Docker for PostgreSQL, Redis, message broker)
  - D) Ad-hoc scripting — can agents run scripts? Conventions for one-off Python/shell/R scripts, script directories
  - E) Interpreter and runtime specifics — version pinning, PATH requirements, multiple runtime needs
  - F) Database workflow — how to get a working local DB (migrations, seed data, fixtures, test DB setup)
  - G) Custom — describe your environment details

Adapt the example options to match the user's `tech` stack from the seed. Think about what agents will need to operate autonomously in this project — environment activation, available tooling, required services, scripting conventions. Collect enough detail so that agents reading copilot-instructions.md can set up and work in the project without asking the user. Store collected data as `environment_context` with category labels.

</round_1>


<interview_pacing>

After completing the Round 1 questions, present a pacing checkpoint via `#tool:askQuestions`:

- I've gathered the core project context. Before we move to artifact exploration — is there anything else about your project I should understand?
  - A) I'm good — move on to artifact exploration
  - B) I have more to share — ask me more about the project

**When the user selects B:** Probe areas Round 1 did not cover or only touched lightly. Generate novel questions — do not repeat Round 1 questions in different wording. Instead, explore adjacent dimensions: architecture decisions and tradeoffs the user has made, team conventions that aren't captured in tooling, past failures or incidents that shaped current practices, integration points with external systems, performance or scale requirements, monitoring and observability patterns, or anything the user's responses hinted at but didn't fully develop. Adapt each follow-up batch to what the user just shared — dig deeper, not wider, when the user signals depth in a specific area. Repeat the checkpoint after each follow-up batch until the user selects A.

</interview_pacing>


<round_2 name="Explore artifact opportunities">

Proactively suggest artifacts using expertise in agentic workflows. Apply the artifact type heuristic to identify opportunities across ALL 4 types. Present as option-based questions.

Example format:

- I identified these potential artifacts based on your project. Which interest you? (Select all that apply)
  - A) Code review agent — reviews PRs for style and logic
  - B) Test creation skill — generates test files for [framework]
  - C) Deployment operator — automates your deploy pipeline
  - D) [framework]-standards instruction — enforces coding conventions
  - E) Quick-review prompt — one-shot lightweight code check
  - F) Something else — describe what you need

Generate options grounded in the user's tech stack and description. Push beyond what the user explicitly asked for — surface 2-3 opportunities they likely did not consider. Each option should map to a specific artifact type.

For each selected option, follow up to refine scope:

- For the code review agent — what should it focus on?
  - A) Style and formatting only
  - B) Logic errors and edge cases
  - C) Security vulnerabilities
  - D) All of the above
  - E) Custom focus — describe what matters most


<artifact_type_heuristic>

Apply during Round 2 to classify artifact opportunities:

- Agent — Ongoing interactive assistance, multi-turn conversations, stateful workflows. "Help me debug", "Review this PR", "Guide me through deployment"
- Skill — Repeatable multi-step procedure with validation. Clear inputs, steps, and a verifiable output. "Create unit tests for X", "Generate API client from spec", "Set up CI pipeline"
- Prompt — One-shot parameterized task. No multi-turn conversation needed. "Summarize this file", "Generate commit message", "Quick code review"
- Instruction — Cross-cutting conventions that multiple agents follow. Coding standards, documentation rules, naming conventions. Applied globally via file patterns

</artifact_type_heuristic>


<orchestration_composition>

After identifying individual artifacts, explore how they compose into orchestration systems. The artifacts being created will work alongside core spokes (@brain, @architect, @build, @inspect, @curator, @researcher) in the user's project. Understanding composition patterns ensures the right relationships are built in.

Present orchestration patterns as options after artifact selection using `#tool:askQuestions`:

- Looking at your selected artifacts, I see potential orchestration patterns. Which composition patterns match your project? (Select all that apply)
  - A) Advisory + Build loop — domain agent advises before planning, reviews after build, feeds corrections back (e.g., code reviewer that shapes plans and reviews output)
  - B) Safety-gated execution — domain agent executes high-risk operations with dry-run → approval → apply ceremony (e.g., deployment, database migration)
  - C) Multi-agent pipeline — multiple domain agents at different stages: one advises, another transforms, instructions enforce conventions silently (e.g., designer + generator + standards)
  - D) Standalone expert — domain agents answer questions independently, no build cycle needed (e.g., "what's the best pattern for X?")
  - E) None of these — my artifacts work independently
  - F) Custom — describe how your artifacts should work together

For each selected pattern, ask about domain-specific adaptations:

- For Advisory + Build loop: which agent advises pre-planning vs post-build? What does it review for?
- For Safety-gated execution: what's the dry-run step? What requires user approval? What's the rollback strategy?
- For Multi-agent pipeline: what's the sequence? Where do instructions auto-load? Where does the user approve?
- For Standalone expert: what kinds of questions? Does the expert ever feed into a build cycle?

Reference patterns in `<orchestration_design>` → `<reference_patterns>` provide concrete examples for each composition. Use them to ground the conversation.

</orchestration_composition>

</round_2>


<round_3 name="Boundaries, safety, and finalize">

Probe for constraints and risk tolerance, then compile findings into a final artifact proposal for approval.

Constraint questions:

- What should agents NEVER do in this project? (Select all that apply)
  - A) Delete or overwrite files without confirmation
  - B) Execute shell commands without approval
  - C) Push directly to main/production branches
  - D) Access or modify environment variables or secrets
  - E) Make external API calls or network requests
  - F) Additional restrictions — describe them

- Which actions need your explicit approval before executing?
  - A) Any file modification
  - B) Only destructive operations (delete, overwrite, deploy)
  - C) Operations affecting production environments only
  - D) No approval needed — agents can act autonomously
  - E) Custom approval policy — describe it

Adapt options to the user's area and selected artifacts. Higher-risk domains (devops, fintech) should front-load more safety options.

Present the final artifact proposal table:

- Name — artifact name
- Type — agent, skill, prompt, or instruction
- Profile — archetype (agents only, em-dash for non-agents)
- Justification — one-line reason this artifact exists

Example:

- deployer — agent — operator — Deployment process with safety gates
- test-shiny — skill — — — Repeatable shinytest2 test creation
- r-standards — instruction — — — R coding conventions across all R agents
- quick-deploy — prompt — — — One-shot deployment checklist

Total: N artifacts (X agents, Y skills, Z instructions, W prompts)

Get approval via `#tool:askQuestions`:

- Review the proposed artifacts above.
  - A) Approve all — proceed to generation
  - B) Remove some — tell me which to drop
  - C) Add more — describe what is missing
  - D) Modify — tell me what to change

Iterate until user approves.

</round_3>

</interview_guidance>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- PROFILE ASSIGNMENT — for agent artifacts -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<profile_assignment>

When assigning profiles to agent artifacts, select from the 6 archetypes defined in [agent-profiles.md](../skills/creators/agent-creator/references/agent-profiles.md):

- Guide — Linear teaching/onboarding, step-by-step guidance. Keywords: teach, learn, help me understand, walk through
- Transformer — Input-to-output conversion, format migration, deterministic mapping. Keywords: convert, migrate, transform, map
- Curator — Collection management, organization, maintenance. Keywords: organize, maintain, inventory, clean up
- Diagnostician — Troubleshooting, root cause analysis, read-only investigation. Keywords: debug, investigate, diagnose, find why
- Analyst — Data analysis, metrics, reporting, evaluation. Keywords: analyze, measure, report, evaluate
- Operator — Procedural execution with safety gates, deployments, migrations. Keywords: deploy, run, execute, migrate data

Match the profile to the behavioral shape of the workflow, not the domain. An agent that guides users through deployment is a Guide, not an Operator. An agent that executes deployment pipelines autonomously is an Operator.

</profile_assignment>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- FIELD COLLECTION — what data to collect per artifact type -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<field_collection>

During the interview, collect the following data per artifact type. These fields feed directly into downstream creation tasks.

<all_types>

Required for every artifact regardless of type:

- name — lowercase-with-hyphens, derived from capability or task description
- purpose — one sentence: what this artifact does
- domain — operating area (translated from seed `area`)
- tech — subset of seed `tech` relevant to this specific artifact
- sources — URLs routed per-artifact with relevance notes
- concepts — domain terms with relevance context

</all_types>

<agent_fields>

Additional fields for agent artifacts:

- profile — one of the 6 archetypes (see `<profile_assignment>`)
- capabilities — action verbs: what the agent can do
- mutation_level — `none` (read-only), `low` (edits files), `high` (runs commands, deletes data, deploys)
- safety_rules — hard constraints (NEVER bullets), promote high-consequence ones to iron laws
- quality_rules — soft rules (ALWAYS bullets)
- trigger — what starts this agent's work
- stance — tone/posture (cautious, proactive, strict)
- expertise — domain knowledge areas

</agent_fields>

<skill_fields>

Additional fields for skill artifacts:

- capabilities — action verbs: what the skill enables
- complexity_signals — indicators of structural needs (needs templates, has decision rules)
- step_count — estimated number of workflow steps
- error_modes — known failure scenarios

</skill_fields>

<instruction_fields>

Additional fields for instruction artifacts:

- instruction_type — `path-specific-triggered` or `path-specific-on-demand`
- applies_to — agents and file patterns this instruction targets
- rules — safety rules, quality rules, and conventions to encode
- discovery_mode — `file-triggered` or `on-demand`

</instruction_fields>

<prompt_fields>

Additional fields for prompt artifacts:

- task_description — detailed description of what the prompt instructs
- agent_mode — custom agent name for execution (if any)
- tools_needed — tools the prompt references
- variables — variables the prompt uses
- output_format — expected output shape

</prompt_fields>

</field_collection>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- ORCHESTRATION DESIGN — agent relationships and workflows -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<orchestration_design>

After artifact approval, collect information about how domain agents connect to each other and to core spokes.

<reference_patterns>

For detailed pattern specifications with architecture diagrams, see `<reference_patterns>` in [generation-workflow.model.md](../models/generation-workflow.model.md).

Use these reference patterns to help users visualize how their artifacts will compose. Present relevant patterns during the interview when users select composition options in Round 2.

<pattern name="E-commerce Platform">

- Composition: @fraud-analyst (Analyst, read-only), @checkout-flow (Operator, safety-gated), checkout-conventions (instruction)
- How it works: Analyst advises @brain pre-planning with domain-specific risk analysis. @build creates the implementation. Operator validates post-build with a dry-run of the full pipeline — if the dry-run fails, @brain loops fixes through @build until it passes. Instruction silently enforces conventions on all @build output.
- What to collect if selected: What domain risks need pre-planning analysis? What's the full pipeline the Operator should dry-run? What constitutes a pass/fail? What conventions should the instruction enforce?

</pattern>

<pattern name="Data Pipeline">

- Composition: @terraform-ops (Operator, appears twice), terraform-patterns (instruction)
- How it works: @build creates infrastructure-as-code files while the instruction auto-enforces patterns via `applyTo`. Operator runs a read-only dry-run to verify. @brain asks user for approval. Operator then executes with safety gates (rollback on failure). @build wires application config.
- What to collect if selected: What's the dry-run command? What requires user approval before execution? What's the rollback strategy? What file patterns trigger the instruction?

</pattern>

<pattern name="API Platform">

- Composition: @api-designer (Guide, read-only), @schema-gen (Transformer, scoped-write), api-conventions (instruction)
- How it works: Guide produces an upfront design that the user approves before any building starts. @build implements while instruction enforces conventions. Transformer generates derived artifacts (e.g., OpenAPI spec) from the implementation. Guide returns for post-build review against the original design — issues loop through @build.
- What to collect if selected: What should the Guide design upfront? What derived artifacts does the Transformer produce? What source does it transform from? What conventions should the instruction enforce? What does the Guide's review check for?

</pattern>

</reference_patterns>

<entry_points>

Which agents do users invoke directly? Define the trigger intent for each:

- agent — agent name from the approved list
- trigger — what user intent routes here

</entry_points>

<workflows>

Named sequences of agents that execute together:

- name — workflow identifier
- sequence — ordered list of agent names
- style — `checkpoint` (pause for approval between steps) or `autonomous` (run without pauses)
- core_touchpoints — where core agents integrate (after which domain agent, to which core agent, why)

</workflows>

<handoffs>

Explicit edges between agents:

- from — source agent name
- to — target agent name
- when — condition that triggers the handoff

</handoffs>

<instruction_bindings>

Which instructions apply to which agents and file patterns:

- instruction — instruction artifact name
- agents — list of agent names this instruction applies to
- file_patterns — glob patterns for file-triggered discovery

</instruction_bindings>

<core_integration>

How domain agents connect to core spokes — define the fixed mapping:

- @brain — routes user requests to domain agent entry points
- @architect — plans multi-agent sequences and phased creation
- @build — handles implementation tasks domain agents identify
- @inspect — verifies domain agent outputs and created artifacts

</core_integration>

</orchestration_design>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- WORKFLOW ROUTING — post-approval generation pipeline -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<workflow_routing>

After interview approval, execute the generation pipeline using core spokes.

<step_1 name="Research">

Spawn parallel @researcher instances to analyze the project domain and enrich collected data. Three categories of researchers run simultaneously:

**Per-URL researchers** — For EACH URL in the user's `sources` list, spawn a dedicated @researcher instance:

- Focus: scoped to that specific URL and its subpages
- Instructions: Use `#tool:web` to fetch the URL. Identify relevant subpages, navigation links, and documentation sections. Follow each subpage that could inform artifact generation — API references, configuration guides, best practices, migration guides, tutorials, and examples. Do NOT stop at the landing page
- Return: structured findings tagged with the source URL — conventions, patterns, API details, configuration requirements, warnings, and gotchas discovered
- Mode: research, Variant: deep

**Exploratory researchers** — Spawn at least 2 additional @researcher instances with focus areas derived from the project's tech stack, area, and goal:

- @brain synthesizes focus areas from interview data. Each exploratory researcher gets a distinct, non-overlapping focus area (e.g., for a FastAPI project: one on "FastAPI production best practices, async patterns, common pitfalls, project structure conventions" and another on "SQLAlchemy async session management, Alembic migration strategies, testing patterns with pytest")
- Instructions: Use `#tool:web` and `#tool:context7` to discover information beyond user-provided sources. Look for: community conventions, recommended project structures, common anti-patterns, production readiness patterns, testing strategies
- Return: structured findings with source citations — focus on actionable patterns and conventions that should inform artifact generation
- Mode: research, Variant: deep

Wait for ALL researcher instances (per-URL + exploratory) to complete before proceeding. Merge all findings — per-URL findings provide depth on user sources, exploratory findings provide breadth beyond them. Pass combined findings to @architect in `<step_2>`.

</step_1>

<step_2 name="Plan">

Send approved artifacts + interview data + merged research findings (per-URL + exploratory) to @architect for phased creation planning. @architect produces a plan that specifies per creation task:

- Which skill to use (see `<skill_mapping>`)
- Output path for the created artifact
- Requirements data collected during interview
- Sources to fetch via `#tool:context7` or `#tool:web`

</step_2>

<step_3 name="Build">

Execute the plan via @build instances — parallel instances per phase as specified by @architect.

<skill_mapping>

Each artifact type maps to a creator skill:

- agent → agent-creator skill
- skill → skill-creator skill
- prompt → prompt-creator skill
- instruction → instruction-creator skill
- copilot-instructions → copilot-instructions-creator skill _(pipeline artifact — generated via template_tasks, not user-proposed)_

</skill_mapping>

<template_tasks>

Include in the @architect plan as generation pipeline tasks. These tasks run as @build instances and produce the self-contained output project.

- Copy core agents — copy `.github/templates/agents/` to `output/${input:projectName}/.github/agents/core/`. These are the 6 core hub-and-spoke agents. Brain template contains injection markers (`<!-- DOMAIN_AGENT_POOL -->`, `<!-- DOMAIN_SPAWN_TEMPLATES -->`) for the adaptation step
- Copy creator skills — copy all 6 creator skill folders from `.github/skills/creators/` to `output/${input:projectName}/.github/skills/creators/`: agent-creator, artifact-author, instruction-creator, prompt-creator, skill-creator, copilot-instructions-creator. These enable the project to self-evolve by creating new artifacts
- Scaffold domain skill directories — for each domain skill in the artifact proposal, create `output/${input:projectName}/.github/skills/{skill-name}/` with `SKILL.md` and `references/` subdirectory
- Scaffold prompts directory — ensure `output/${input:projectName}/.github/prompts/` exists for generated prompt files
- Place domain agents — create domain agent files using flat convention: `output/${input:projectName}/.github/agents/{name}.agent.md` alongside `agents/core/`. Domain agents are NOT nested in a subdirectory
- Generate copilot-instructions.md — use the copilot-instructions-creator skill to produce `output/${input:projectName}/.github/copilot-instructions.md`. Pass to the skill: artifact_proposal (all approved artifacts), project_name, project_area, tech_stack, domain_agents list (with name, profile, description, tools), safety_constraints and quality_rules from interview Round 3, project_commands (categorized development commands collected during interview). Note: `.github/templates/instructions/` is intentionally empty — domain instructions are interview-driven, generated per-project by instruction-creator skill
- Generate .curator-scope — create `output/${input:projectName}/.github/.curator-scope` as a plain text file with two sections: `include:` section with glob patterns for domain agent paths (`agents/*.agent.md`), instruction files (`instructions/*.instructions.md`), skill definitions (`skills/*/SKILL.md`), and `copilot-instructions.md`. `exclude:` section with glob patterns for project source directories, dependency directories (`node_modules/`, `.venv/`, `__pycache__/`), and build output (`dist/`, `build/`). Derive specific patterns from interview data
- Brain adaptation — LAST task, runs after ALL domain artifacts are created. Locate injection markers in `output/${input:projectName}/.github/agents/core/brain.agent.md`: find `<!-- DOMAIN_AGENT_POOL -->` and insert domain agent entries before it (each entry follows the 3-field pattern: Strengths, Tools, Leverage); find `<!-- DOMAIN_SPAWN_TEMPLATES -->` and insert at least one spawn example per domain agent before it. Read created domain agent files to extract capabilities, tools, and leverage patterns for the entries
- Copy VS Code settings — copy `.github/templates/vscode/settings.json` to `output/${input:projectName}/.vscode/settings.json`. This ensures VS Code discovers agents in `agents/core/`, skills in `skills/creators/`, and enables subagent delegation. No content modifications needed — copy as-is
- Generate README.md — create `output/${input:projectName}/README.md` as a human-friendly project guide. This is the user's entry point to understanding what was generated. Content structure:
  - **What's inside** — brief explanation of each `.github/` folder and what it contains (agents, skills, prompts, instructions). List domain-specific agents by name with one-line descriptions. List domain skills and prompts similarly. Keep it scannable — use a table or short bullet list, not paragraphs
  - **How it works** — explain the hub-and-spoke model in plain language: @brain is the entry point, user talks to @brain, @brain delegates to core spokes (@researcher, @architect, @build, @inspect, @curator) and domain-specific agents. Include a simple text diagram or mermaid block showing the flow. Explain that domain agents are specialists that plug into the same orchestration — user never invokes them directly
  - **Quick start** — 2-3 concrete examples of how to use the system: (1) ask @brain a question about the project, (2) request a feature implementation showing how @brain routes through architect→build→inspect, (3) use a generated prompt via `/prompt-name`. Tailor examples to the project's actual domain and tech stack from interview data
  - Keep the entire README under ~80 lines. Write for a developer who has never seen the framework — no jargon about spokes, artifacts, or generation pipelines. Use friendly, direct language

</template_tasks>

</step_3>

<step_4 name="Verify">

@inspect verifies all created artifacts against their requirements and the skill validation checklists. Findings route back through @brain for rework if needed.

</step_4>

<step_5 name="Finalize">

@curator performs final workspace sync — ensures output directory structure is consistent, no orphaned files, all cross-references resolve.

</step_5>

</workflow_routing>
