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

</flow>

<resources>

## Resources

- **Interview agent** — `.github/agents/interview.agent.md`. Status: Implemented.
- **Interview prompt** — `.github/prompts/interview.prompt.md`. Status: Implemented.
- **User manual** — `generator/user-manual.md`. Status: Implemented.
- **Generator prompts** — `.github/prompts/generator/`. Status: Implemented.

</resources>

<cross_references>

## Cross-References

- [README.md](README.md) — Generator overview and quick start
- [user-manual.md](user-manual.md) — Detailed interview guide
- [prerequisites.md](prerequisites.md) — VS Code requirements

</cross_references>
