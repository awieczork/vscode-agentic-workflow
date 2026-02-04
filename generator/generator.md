# Generation Pipeline

Automated creation of `.github/` frameworks for new projects.

<status>

**Status:** Interview agent implemented. Master and Creator agents planned.

</status>

<overview>

## Overview

The `generator/` folder provides automated `.github/` framework creation through user interviews that transform requirements into validated artifacts.

</overview>

<architecture>

## Three-Agent Architecture

- **Interview** — Clarifies requirements, synthesizes brief. Input: Questionnaire. Output: Project brief + manifest. Status: Implemented.
- **Master** — Validates, orders, spawns Creator. Input: Brief + manifest. Output: Validated artifacts. Status: Planned.
- **Creator** — Follows skills, produces artifacts. Input: Spec + skill. Output: Artifact + report. Status: Planned.

</architecture>

<flow>

## Generation Flow

1. **User Input** — Run `/interview` prompt, fill XML questionnaire
2. **Validation** — Interview checks required fields, identifies gaps
3. **Reference Summary** — Interview spawns @brain to summarize linked sources
4. **Clarification** — Interview asks follow-up questions if ambiguities exist
5. **Synthesis** — Interview generates project brief + artifact manifest
6. **User Approval** — Review recommendations before proceeding
7. **Handoff** — To @architect for planning or direct generation

**7b. Refactor Flow (alternative to 7a):**
When `operation_mode: refactor`, Master reads existing artifact and Creator iterates on it rather than creating from scratch.

</flow>

<resources>

## Resources

- **Interview agent** — `.github/agents/interview.agent.md`. Status: Implemented.
- **Interview prompt** — `.github/prompts/interview.prompt.md`. Status: Implemented.
- **User manual** — `generator/user-manual.md`. Status: Implemented.
- **Generator prompts** — `.github/prompts/generator/`. Status: Implemented.

</resources>

<interview_handoff_schema>

## InterviewHandoff Contract

Interview agent produces this structure for Master agent consumption.

**project_brief:**
- `name` — Project identifier (string, required)
- `description` — Project purpose (string, required)
- `tech_stack` — Technologies involved (array of strings)
- `workflows` — Key user workflows (array of strings)
- `constraints` — Project limitations (array of strings)

**execution_manifest:**
Array of artifacts to generate, each containing:
- `name` — Artifact identifier (string, required)
- `type` — One of: agent, instruction, prompt, skill (string, required)
- `path` — Target file path (string, required)
- `skill` — Creator skill to invoke (string, required)
- `description` — What this artifact does (string, required)
- `dependencies` — Other artifacts this depends on (array of strings)
- `tools` — Tools this artifact needs (array of strings, for agents only)
- `constraints` — Artifact-specific limitations (array of strings)
- `complexity` — S/M/L estimate (string)

**constraint_propagation:**
- Global constraints from project_brief apply to all artifacts
- Artifact-specific constraints override globals
- Dependencies must be generated before dependents

</interview_handoff_schema>

<cross_references>

## Cross-References

- [README.md](README.md) — Generator overview and quick start
- [user-manual.md](user-manual.md) — Detailed interview guide
- [prerequisites.md](prerequisites.md) — VS Code requirements

</cross_references>
