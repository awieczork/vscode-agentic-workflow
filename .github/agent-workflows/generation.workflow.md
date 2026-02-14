---
name: 'generation'
description: 'Project generation guidance — expert interview, artifact heuristic, orchestrated creation via @brain lifecycle'
version: '2.0.0'
tags: ['generation', 'interview', 'artifact-creation', 'project-scaffolding']
---

This workflow provides generation-specific guidance that @brain applies during its standard lifecycle phases. Generation is not a separate process — it is @brain orchestrating project-specific artifact creation through the same hub-and-spoke pattern used for all tasks. Each section below maps to a phase @brain already executes: interview maps to discovery, research guidance maps to research, heuristic maps to analysis, output and adaptation map to planning, build directives map to execution, and verification maps to inspection.


<interview_guidance>

Drive a multi-round expert interview to understand the project and identify artifact opportunities. Use option-based questions — max 3 questions per batch, each with 2-5 options. Pre-select one option as recommended where applicable. Allow multi-select with lettered options where appropriate.


<seed_adaptive_depth>

Assess the user's initial seed to calibrate interview depth:

- **Rich seed** (detailed description, tech stack, requirements, workflow details) — reduce rounds, confirm understanding with targeted options rather than broad questions. Skip areas already covered
- **Thin seed** (1-2 sentences, vague scope) — probe deeper, ask more rounds, explore adjacent dimensions before moving to artifact exploration
- **Medium seed** — standard depth, 2-3 rounds with follow-up batches as needed

Adapt question options to the seed's tech stack and domain. Never ask questions the seed already answers.

</seed_adaptive_depth>


<question_topics>

Cover these areas across interview rounds, adapting order and depth to what the seed leaves uncovered:

- **Project type and domain** — what the project does, who it serves, primary workflows
- **Tech stack** — languages, frameworks, infrastructure, services, runtime environment
- **Team workflow** — solo vs team, PR process, CI/CD, deployment strategy
- **Development commands** — build, test, lint, run, deploy commands grouped by category
- **Environment context** — virtual environments, required services, secrets handling, prerequisites
- **Key domain concepts** — terms, entities, and relationships agents need to understand
- **Agent specializations** — where dedicated AI assistance would reduce friction
- **Constraints and safety** — what agents must NEVER do, what requires explicit approval

</question_topics>


<proactive_suggestion>

After gathering project context, proactively suggest artifacts the user likely has not considered. Ground suggestions in interview findings:

- "Your e-commerce project would benefit from a checkout-flow skill and an API-design instruction set"
- "Given your team's PR workflow, a code-review agent and a PR-conventions instruction could enforce consistency"
- "Your data pipeline has migration risks — a safety-gated deployment prompt and a migration-testing skill would reduce incidents"

Present suggestions as option-based questions — the user selects which to include. Each suggestion must map to a specific artifact type with a one-line justification.

</proactive_suggestion>


<finalization>

Compile all findings into a proposal table before proceeding:

- **Name** — artifact name (lowercase-with-hyphens)
- **Type** — agent, skill, instruction, or prompt
- **Justification** — one-line reason this artifact exists

Present the total: N artifacts (X agents, Y skills, Z instructions, W prompts). Get explicit approval before generation begins. Iterate until the user approves.

</finalization>

</interview_guidance>


<research_guidance>

Translate the seed's `sources` URLs into structured @researcher delegation prompts so @brain's Phase 2 research spawns perform deep, parallel external analysis rather than surface-level fetches. When the seed includes external references, apply the routing, crawl, exploration, and synthesis patterns below to formulate each @researcher spawn prompt.


<source_routing>

Group seed `sources` URLs before dispatching @researcher spawns:

- **Domain grouping** — cluster URLs that share a domain (e.g., all `docs.example.com` links together), then subdivide by content type (API reference, guide, blog) when a single domain contributes many URLs
- **Spawn sizing** — cap each @researcher spawn at 3-5 URLs to keep context windows focused and findings coherent. Split larger clusters into multiple spawns
- **Spawn prompt contents** — every @researcher spawn prompt must include: the session ID, a research focus statement derived from the project goal, the assigned URL list, depth bounds (from `<deep_crawl_strategy>`), and specific questions to answer (e.g., "What patterns does this library recommend?", "What are the API conventions?", "What constraints does this framework impose?")
- **Parallel dispatch** — spawn all URL-group researchers simultaneously; do not serialize them
- **No sources provided** — when the seed omits `sources` entirely, skip URL-based spawns and rely on free exploration alone

</source_routing>


<deep_crawl_strategy>

Instruct each URL-group @researcher to analyze assigned URLs in two passes rather than treating each URL as a single-page fetch:

- **Pass 1 (shallow scan)** — fetch the provided URL, understand its structure and purpose, extract all outgoing links on the page. Catalog what each link likely covers based on anchor text and URL path
- **Pass 2 (deep dive)** — follow the most relevant child and internal links discovered in Pass 1. Require @researcher to justify relevance before following each link (e.g., "Following /auth/oauth2 BECAUSE it documents the authentication patterns relevant to the project's auth goal"). Skip links that lead to unrelated content, changelogs, or marketing pages
- **Depth bounds** — 2 levels for documentation and API reference sites, 1 level for articles and blog posts, 3 levels for complex reference architectures. State the applicable bound in each spawn prompt
- **Extraction mode awareness** — match extraction strategy to content type: structured extraction for API docs (endpoints, parameters, schemas, error codes), narrative extraction for guides and tutorials (step-by-step procedures, code examples, caveats), pattern extraction for architecture references (component relationships, data flow, integration points)

</deep_crawl_strategy>


<free_exploration>

Always spawn at least one @researcher with no pre-assigned URLs, regardless of whether the seed includes `sources`:

- **Inputs** — provide only the project's domain keywords (derived from seed `area`, `tech`, and interview findings) and a research focus statement derived from the project goal. Do not constrain this spawn to specific URLs
- **Target areas** — best practices for the project's domain and stack, design patterns and architectural patterns applicable to the stated requirements, common pitfalls and anti-patterns, alternative approaches the user may not have considered
- **Independent discovery** — the free explorer searches the web autonomously, discovers relevant resources, and returns findings using the same structured template as URL-based spawns
- **Complementary scope** — frame the free explorer's focus to cover ground the URL-based spawns are unlikely to reach (community conventions, cross-cutting concerns, ecosystem tooling)

</free_exploration>


<research_synthesis>

After all parallel @researcher spawns complete, run a merge checklist before feeding results downstream:

- **Coverage** — verify every seed `sources` URL is accounted for in at least one researcher's findings. Flag any URL that was unreachable or returned no actionable content
- **Integration** — incorporate free explorer findings alongside URL-based findings into a unified research summary. Do not treat free exploration as secondary
- **Conflicts** — explicitly flag contradictions between sources (e.g., two libraries recommending incompatible auth patterns). Do not silently resolve conflicts; present both positions with context so @planner can make an informed decision
- **Gap-fill** — if the checklist fails on any dimension, re-spawn targeted @researcher(s) with refined focus statements addressing the specific gap
- **Source coverage table** — include a summary table in the synthesis: URL | Researcher Spawn | Key Findings (1-liner) — so nothing falls through the cracks
- **Downstream output** — the merged synthesis feeds the problem_statement_template's `Research Findings` field, enriching what @planner and @builder receive for planning and implementation

</research_synthesis>

</research_guidance>


<artifact_heuristic>

Apply this 4-type heuristic to classify every artifact opportunity. Classification drives creation — each type has a distinct purpose, and mis-classification produces artifacts that do not fit their context.

- **Agent** — For recurring multi-step workflows that benefit from a dedicated persona. The agent receives tasks, applies domain expertise across multiple turns, and produces structured output. Examples: @api-planner for API architecture guidance, @test-strategist for test planning and coverage analysis, @security-inspector for vulnerability assessment
- **Skill** — For domain-specific knowledge that multiple agents might invoke. A repeatable process with clear inputs, steps, and verifiable output. Examples: database-optimization skill, accessibility-audit skill, migration-testing skill
- **Instruction** — For path-scoped coding standards and conventions that auto-attach based on file patterns. Ambient constraints that shape behavior without explicit invocation. Examples: "all files in src/api/ must include error handling middleware", "TypeScript files follow strict null checks"
- **Prompt** — For one-shot task templates users trigger directly. No multi-turn conversation needed — parameterized input, focused output. Examples: "generate a migration script", "scaffold a new endpoint", "run a quick security check"


<when_not_to_create>

Avoid over-generation. Do NOT create an artifact when:

- The capability is already covered by a core agent's existing behavior
- A single instruction rule would suffice instead of a full agent
- The use case is too narrow for a skill — a prompt handles it better
- Two proposed artifacts overlap significantly — merge them or pick the stronger fit

</when_not_to_create>


<minimum_viable_set>

The smallest useful artifact set for any project is:

1. Project-specific `copilot-instructions.md` — provides workspace context that makes core agents effective
2. 1-2 domain instructions — codifies the project's most important conventions
3. 1-2 prompts — automates the most common one-shot tasks

Domain agents and skills are added only when interview findings reveal workflows that core agents cannot cover with general-purpose behavior.

</minimum_viable_set>

</artifact_heuristic>


<output_structure>

Generated projects are self-contained — a user copies the `.github/` folder into their project and it works immediately. All output goes to `output/{projectName}/.github/`.


<directory_layout>

```
output/{projectName}/
├── .github/
│   ├── agent-workflows/
│   │   └── evolution.workflow.md  # COPIED — artifact evolution workflow
│   ├── agents/
│   │   ├── core/               # COPIED — all 6 core agents
│   │   │   ├── brain.agent.md
│   │   │   ├── researcher.agent.md
│   │   │   ├── planner.agent.md
│   │   │   ├── builder.agent.md
│   │   │   ├── inspector.agent.md
│   │   │   └── curator.agent.md
│   │   └── {name}.agent.md     # GENERATED — supplementary agents (flat)
│   ├── skills/
│   │   ├── artifact-creator/   # COPIED — full skill with references + examples
│   │   │   ├── SKILL.md
│   │   │   ├── references/
│   │   │   └── assets/
│   │   └── {domain-skill}/     # GENERATED — per interview findings
│   │       └── SKILL.md
│   ├── instructions/           # GENERATED — domain instructions
│   ├── prompts/
│   │   ├── calibrate.prompt.md # COPIED — single-run workspace calibration
│   │   ├── evolve.prompt.md    # COPIED — evolution entry point
│   │   └── {domain}.prompt.md  # GENERATED — domain prompts
│   └── copilot-instructions.md # GENERATED — project-specific workspace context
└── README.md                   # GENERATED — human-friendly project guide
```

</directory_layout>


<copy_rules>

These are copied verbatim — no modifications:

- **Core agents** — copy all 6 from `.github/agents/core/` to `output/{projectName}/.github/agents/core/`. Core agents are generic by design and work across any project
- **Artifact-creator skill** — copy the entire `.github/skills/artifact-creator/` directory (SKILL.md, all references, all example assets). This enables the output project to create new artifacts post-generation
- **Evolution workflow** — copy `.github/agent-workflows/evolution.workflow.md` to `output/{projectName}/.github/agent-workflows/`. Enables artifact evolution in the output project
- **Evolve prompt** — copy `.github/prompts/evolve.prompt.md` to `output/{projectName}/.github/prompts/`. Entry point for the evolution workflow
- **Calibrate prompt** — copy `.github/prompts/calibrate.prompt.md` to `output/{projectName}/.github/prompts/`. Single-run prompt to align copilot-instructions.md with the target workspace

</copy_rules>


<generation_rules>

These are created fresh based on interview findings:

- **copilot-instructions.md** — tailored to the project's tech stack, conventions, domain context, development commands, environment setup, and agent listing. Every line must earn its token cost
- **Supplementary agents** — placed flat in `agents/` alongside `agents/core/`. Each gets positioning guidance relative to core agents
- **Domain skills** — placed in `skills/{skill-name}/` with SKILL.md. Create `references/` subdirectory only if the skill requires reference materials
- **Domain instructions** — placed in `instructions/`. File-triggered via `applyTo` patterns where applicable
- **Domain prompts** — placed in `prompts/`. One task per prompt file
- **README.md** — placed at project root. Explains what was generated, how the hub-and-spoke model works, and provides 2-3 concrete quick-start examples tailored to the project domain. Under 80 lines, written for developers unfamiliar with the framework

</generation_rules>

</output_structure>


<core_agent_adaptation>

Core agents are copied as-is — they are generic and project-agnostic by design. The one exception is `brain.agent.md`, which is adapted post-copy via `<brain_adaptation>` to include explicit entries for supplementary agents. All other core agents remain unmodified. Project specificity comes from three sources that shape core agent behavior:


<project_context_layer>

The generated `copilot-instructions.md` provides the project context that makes core agents effective. It includes:

- Workspace map with project source directories (from interview findings) as primary entries, followed by a compact summary of generated `.github/` infrastructure — NOT an exhaustive artifact-by-artifact listing
- Tech stack, conventions, and domain concepts from interview findings
- Development commands grouped by category (build, test, lint, deploy)
- Environment context (runtime, prerequisites, services)
- Agent references inline after the workspace section — one line for core agents as a group (e.g., "Core agents … are defined in `.github/agents/core/`"), individual entries only for supplementary agents

This file loads on every request — core agents read it and adapt their behavior to the project without needing project-specific modifications.

</project_context_layer>


<supplementary_agent_positioning>

Supplementary agents extend the core set. Each supplementary agent must be positioned relative to a core agent following the guidance in `body-patterns.md` → `<positioning>`:

- Domain agents MUST follow `{domain}-{core-role}` naming — `{domain}` is the project domain (theme, python, security, api), `{core-role}` is the core agent being extended (planner, builder, inspector, researcher, curator). Examples: theme-builder, security-inspector, api-planner
- Define the role relative to an existing core agent — a `@python-builder` replaces `@builder` for Python projects, a `@security-inspector` extends `@inspector` with security focus
- Specify when @brain should prefer this agent over the core alternative — include selection criteria in identity prose
- Follow the same interface patterns as the core agent being extended — status codes (`COMPLETE` | `BLOCKED`), session ID echo, output template structure — so @brain routes seamlessly
- Supplementary agents never modify core agents — they provide alternative handoff targets that @brain selects based on task context

</supplementary_agent_positioning>


<brain_adaptation>

Runs after Phase 2 whenever supplementary agents are created. If no supplementary agents were generated, skip this section entirely.

When triggered:

1. Read the output project's `brain.agent.md`
2. For each supplementary agent created in Phase 2, read its definition file to extract the description from its frontmatter and delegation details from its identity prose
3. Add a new entry to the `<agent_pool>` section following the existing entry format — `- **@{agent-name}** — {capability description from agent frontmatter}`
4. Add a new entry to the `<delegation_rules>` section following the existing entry format — `- **@{agent-name}** — {delegation guidance: what context to provide, what to expect back, when to prefer over core agents}`
5. If multiple supplementary agents exist, batch all entries into one edit operation per section

No injection markers are used — entries are added to the `<agent_pool>` and `<delegation_rules>` lists directly, following the pattern of existing entries. For supplementary agent positioning guidance, reference `<supplementary_agent_positioning>`.

</brain_adaptation>

</core_agent_adaptation>


<build_directives>

Instructions for @brain when orchestrating artifact creation during generation. @builder is stateless — it receives WHAT to create, never HOW.


<handoff_pattern>

- @builder uses the artifact-creator skill (`.github/skills/artifact-creator/SKILL.md`) for all artifact creation. The skill handles classify-then-specialize — @builder does not need type-specific creation instructions
- Each artifact is a separate @builder handoff with clear scope: artifact type, purpose, domain context, and relevant interview findings
- @builder receives the artifact-creator skill reference and the specific artifact requirements — the skill provides structure, conventions, and validation
- After each @builder batch completes, @inspector verifies all created artifacts before @brain proceeds to the next batch

</handoff_pattern>


<parallel_execution>

Batch independent @builder spawns into parallel tool-call blocks. Never spawn them sequentially when they have non-overlapping file sets:

1. **Phase 1** — Copy operations (core agents, artifact-creator skill, evolution workflow, evolve prompt, calibrate prompt) — these have no dependencies
2. **Phase 2** — Generate supplementary artifacts (agents, skills, instructions, prompts) — independent of each other, parallel within this phase
3. **Phase 3** — Brain adaptation — inject supplementary agent entries into output brain's `<agent_pool>` and `<delegation_rules>`. Depends on Phase 2 supplementary agents being complete. Reference `<brain_adaptation>` for the procedure
4. **Phase 4** — Generate copilot-instructions.md — depends on all artifacts from Phase 2 being complete (references them in workspace map and agent listing)
5. **Phase 5** — Generate README.md — depends on copilot-instructions.md and full artifact inventory

@inspector runs after each phase. Findings route back through @brain for rework — @builder fixes only the flagged issues, then @inspector re-verifies.

</parallel_execution>

</build_directives>


<verification_criteria>

What @inspector checks for generated projects. Each criterion is binary — PASS or FAIL with specific details.


<artifact_quality>

- All artifacts follow framework conventions: XML tags (snake_case, domain-specific), canonical terms (constraint, skill, handoff, escalate, fabricate), no markdown headings inside artifact bodies
- YAML frontmatter parses correctly with single-quoted string values
- No hardcoded secrets, credentials, or absolute paths
- Each artifact has a clear purpose that does not overlap with other artifacts
- Agent artifacts include identity prose, bullet constraints, `<workflow>`, domain tags, and output template
- Skill artifacts include prose intro, `<workflow>` with numbered steps, and `<resources>` linking all subfiles
- Instruction artifacts use domain-specific XML groups with imperative NEVER/ALWAYS rules
- Prompt artifacts have one task per file with verb-first heading

</artifact_quality>


<structural_integrity>

- Output directory structure matches the `<directory_layout>` specification
- All 6 core agents are present in `agents/core/`
- Artifact-creator skill is present with all references and example assets
- Evolution workflow is present in `agent-workflows/`
- Evolve prompt is present in `prompts/`
- Calibrate prompt is present in `prompts/`
- No circular dependencies between generated artifacts
- copilot-instructions.md workspace map covers project source directories and provides a compact summary of generated `.github/` infrastructure — not an exhaustive artifact listing
- All cross-references between artifacts resolve to existing files
- Supplementary agents follow positioning guidance — defined relative to core agents with matching interface patterns
- Brain agent's `<agent_pool>` includes entries for all supplementary agents created in Phase 2

</structural_integrity>


<self_containment>

- The output `.github/` folder works immediately when copied into a project — no external dependencies on the source framework
- copilot-instructions.md provides sufficient project context for core agents to operate without additional setup
- README.md explains the system in plain language for developers unfamiliar with the framework

</self_containment>

</verification_criteria>
