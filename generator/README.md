# Generator

Automated creation of `.github/` frameworks for new projects.

<overview>

## Overview

This folder documents the generation pipeline that transforms user requirements into validated Copilot artifacts through an interview-driven workflow.

</overview>

<quick_start>

## Quick Start

1. Open any VS Code workspace
2. Run `/interview` prompt
3. Fill the XML questionnaire
4. Review recommended artifacts
5. Approve to generate

</quick_start>

<architecture>

## Three-Agent Architecture

- **Interview** — Collects requirements, recommends artifacts. Status: Implemented.
- **Master** — Validates, orders, orchestrates creation. Status: Planned.
- **Creator** — Follows skills, produces artifacts. Status: Planned.

</architecture>

<documentation>

## Documentation

- [user-manual.md](user-manual.md) — Detailed interview guide
- [prerequisites.md](prerequisites.md) — VS Code requirements
- [generator.md](generator.md) — Pipeline technical details

</documentation>

<cross_references>

## Cross-References

- Interview agent: [interview.agent.md](../.github/agents/interview.agent.md)
- Interview prompt: [interview.prompt.md](../.github/prompts/interview.prompt.md)

</cross_references>
