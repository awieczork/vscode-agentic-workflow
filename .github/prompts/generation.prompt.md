---
description: 'Generates a project-specific .github/ folder — agents, skills, instructions, prompts, and copilot-instructions tailored to the user project'
agent: 'brain'
argument-hint: 'Describe your project — what it does, its tech stack, and what you want AI agents to help with'
---

This prompt overlays brain's standard lifecycle with generation-specific guidance. Given a user's project context, it produces a tailored `.github/` orchestration layer: project-specific agents, skills, instructions, prompts, and copilot-instructions. Core agents remain generic; all project specificity flows through generated artifacts.

```yaml
name: ""              # Project name
area: ""              # e.g. "fintech", "data science", "devops"
goal: ""              # One sentence: what does this project achieve?
tech: []              # Languages, frameworks, DBs, libraries, tools
sources:              # Optional — URLs for deep research
  - url: ""
    title: ""
commands:             # Optional — known development commands
  build: ""
  test: ""
  lint: ""
  run: ""
constraints: []       # Optional — things agents must NEVER do
```

<description>

Write freely here: business context, problems you face, what you want agents to help with, domain concepts, team practices — anything relevant. This feeds an expert interview that produces your project's `.github/` folder. One sentence or ten paragraphs — the interview adapts.

</description>


<interview_overlay>

Generation-specific guidance for brain's discovery phase. Drive a multi-round expert interview using option-based questions — max 3 per batch, 2-5 options each, pre-select recommended where applicable.

<seed_adaptive_depth>
Calibrate interview depth from the seed:

- Rich seed (detailed description, tech stack, requirements) — reduce rounds, confirm with targeted options, skip covered areas
- Thin seed (1-2 sentences, vague scope) — probe deeper, more rounds, explore adjacent dimensions
- Medium seed — standard 2-3 rounds with follow-ups as needed

Adapt options to the seed's tech stack and domain. Never re-ask what the seed already answers.
</seed_adaptive_depth>

<question_topics>
Cover these areas across rounds, adapting order and depth to uncovered gaps:

- Project type and domain — what the project does, who it serves, primary workflows
- Tech stack — languages, frameworks, infrastructure, runtime environment
- Team workflow — solo vs team, PR process, CI/CD, deployment strategy
- Development commands — build, test, lint, run, deploy grouped by category
- Environment context — virtual environments, required services, secrets handling
- Domain concepts — terms, entities, and relationships agents need to understand
- Agent specializations — where dedicated AI assistance would reduce friction
- Constraints and safety — what agents must NEVER do, what requires explicit approval
</question_topics>

<proactive_suggestion>
After gathering context, suggest artifacts the user likely hasn't considered. Ground every suggestion in interview findings, map each to a specific artifact type with a one-line justification, and present as option-based questions the user selects from.
</proactive_suggestion>

<finalization>
Compile findings into a proposal table (name, type, justification). Present totals: N artifacts (X agents, Y skills, Z instructions, W prompts). Get explicit approval before generation begins — iterate until approved.
</finalization>

</interview_overlay>


<research_overlay>

Generation-specific guidance for brain's research phase. Translate seed `sources` URLs into structured @researcher delegations.

<source_routing>

- Group seed `sources` URLs by domain, subdivide by content type when a domain contributes many URLs
- Cap each @researcher spawn at 3-5 URLs with specific research questions per spawn
- Dispatch all URL-group researchers in parallel
- Skip URL-based spawns entirely when no sources are provided

</source_routing>

<deep_crawl_strategy>
Two-pass approach per spawn:

- Pass 1 (shallow scan) — fetch URL, understand structure, catalog outgoing links
- Pass 2 (deep dive) — follow most relevant links, justify relevance before following each
- Depth bounds: 2 levels for docs/API references, 1 for articles, 3 for architecture references
- Match extraction to content type: structured for API docs, narrative for guides, pattern-based for architecture
</deep_crawl_strategy>

<free_exploration>
Always spawn at least one @researcher with no pre-assigned URLs — only domain keywords and project goal. Targets: best practices, design patterns, common pitfalls, alternative approaches. Frame scope to complement URL-based spawns.
</free_exploration>

<research_synthesis>
Post-completion merge checklist:

- Coverage — verify every seed source URL is accounted for; flag unreachable URLs
- Conflicts — flag contradictions between sources; present both positions with context
- Gap-fill — re-spawn targeted @researcher(s) for any uncovered dimension
- Source coverage table — URL | Spawn | Key Findings (1-liner)
</research_synthesis>

</research_overlay>


<artifact_heuristic>

Four-type classification driving skill routing. Classification determines creation path — each type has a distinct purpose and mis-classification produces artifacts that don't fit their context.

- **Agent** — recurring multi-step workflows needing a dedicated persona → route to `.github/skills/agent-creator/SKILL.md`
- **Skill** — domain knowledge multiple agents might invoke, repeatable process → route to `.github/skills/skill-creator/SKILL.md`
- **Instruction** — path-scoped coding standards, ambient constraints → route to `.github/skills/instruction-creator/SKILL.md`
- **Prompt** — one-shot task templates with parameterized input → author directly (no creator skill exists)

<when_not_to_create>
Do NOT create an artifact when:

- The capability is already covered by a core agent's existing behavior
- A single instruction rule suffices instead of a full agent
- The use case is too narrow for a skill — a prompt handles it better
- Two proposed artifacts overlap significantly — merge or pick the stronger fit
</when_not_to_create>

<minimum_viable_set>
Smallest useful set for any project:

1. `copilot-instructions.md` via `.github/skills/copilot-instructions-creator/SKILL.md` — workspace context making core agents effective
2. 1-2 domain instructions — codify the project's most important conventions
3. 1-2 prompts — automate the most common one-shot tasks

Agents and skills are added only when interviews reveal workflows core agents cannot cover.
</minimum_viable_set>

</artifact_heuristic>


<output_structure>

Generated projects are self-contained — copy the `.github/` folder into a project and it works immediately. All output goes to `output/{projectName}/.github/`.

<directory_layout>

```text
output/{projectName}/
├── .github/
│   ├── agents/
│   │   ├── core/               # COPIED — all 6 core agents
│   │   └── {name}.agent.md     # GENERATED — supplementary agents (flat)
│   ├── skills/
│   │   ├── agent-creator/      # COPIED
│   │   ├── skill-creator/      # COPIED
│   │   ├── instruction-creator/        # COPIED
│   │   ├── copilot-instructions-creator/ # COPIED
│   │   ├── plan-visualization/ # COPIED
│   │   └── {domain-skill}/     # GENERATED — per interview findings
│   ├── instructions/           # GENERATED
│   ├── prompts/                # GENERATED
│   └── copilot-instructions.md # GENERATED
└── README.md                   # GENERATED — ≤80 lines
```

</directory_layout>

<copy_rules>
Copied verbatim — no modifications:

- Core agents — all 6 from `.github/agents/core/`
- Creator skills — agent-creator, skill-creator, instruction-creator, copilot-instructions-creator (full directories)
- plan-visualization skill — required by brain's planning phase
</copy_rules>

<generation_rules>
Created fresh based on interview findings:

- `copilot-instructions.md` — via copilot-instructions-creator skill, tailored to project stack and conventions
- Supplementary agents — via agent-creator skill, flat in `agents/` alongside `agents/core/`
- Domain skills — via skill-creator skill, in `skills/{skill-name}/`
- Domain instructions — via instruction-creator skill, in `instructions/`
- Domain prompts — authored directly, one task per file in `prompts/`
- `README.md` — at project root, hub-and-spoke explanation, 2-3 quick-start examples, ≤80 lines
</generation_rules>

</output_structure>


<brain_adaptation>

Runs only when supplementary agents were generated — skip entirely if none exist.

For each supplementary agent:

- Read its definition to extract description and delegation details
- Add entry to output brain.agent.md's `<agent_pool>` following existing entry format
- Add entry to `<delegation_rules>` with context guidance and selection criteria
- Use `{domain}-{core-role}` naming, role-relative positioning, matching interface patterns (status codes, session ID echo)
- Delegate actual editing to @developer — this section defines WHAT to add, not HOW to edit

</brain_adaptation>


<build_directives>

Execution order for generation. Each artifact is a separate @developer delegation with: artifact type, purpose, domain context, and relevant creator skill reference.

Skill routing: agent → `.github/skills/agent-creator/SKILL.md`, skill → `.github/skills/skill-creator/SKILL.md`, instruction → `.github/skills/instruction-creator/SKILL.md`, copilot-instructions → `.github/skills/copilot-instructions-creator/SKILL.md`, prompt → direct authoring.

Five-phase parallel execution:

1. Copy operations — core agents, creator skills, plan-visualization skill (no dependencies)
2. Generate supplementary artifacts — agents, skills, instructions, prompts (independent, parallel within phase)
3. Brain adaptation — update output brain's `<agent_pool>` and `<delegation_rules>` (depends on phase 2)
4. Generate `copilot-instructions.md` (depends on phase 2 artifact inventory)
5. Generate `README.md` (depends on phases 2-4)

@inspector runs after each phase. Findings route back through brain for rework — @developer fixes flagged issues, @inspector re-verifies.

</build_directives>


<verification_criteria>

What @inspector checks — each criterion is PASS or FAIL.

<artifact_quality>
- XML tags use snake_case, YAML frontmatter valid with single-quoted strings
- No hardcoded secrets, credentials, or absolute paths
- No artifact overlap — each has a distinct purpose
- Type-specific checks: agents have identity prose + workflow + output template; skills have workflow + resources; instructions use NEVER/ALWAYS rules; prompts have one task per file

</artifact_quality>

<structural_integrity>
- Directory layout matches `<directory_layout>` specification
- All 6 core agents present in `agents/core/`
- All 4 creator skills + plan-visualization present in `skills/`
- No circular dependencies; all cross-references resolve
- Brain `<agent_pool>` updated for all supplementary agents

</structural_integrity>

<self_containment>
- Output `.github/` works immediately when copied — no external dependencies
- `copilot-instructions.md` provides sufficient context for core agents
- `README.md` explains the system for developers unfamiliar with the framework

</self_containment>

</verification_criteria>
