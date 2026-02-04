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

## Self-Maintenance

The generator can maintain this framework's own artifacts.

<self_bootstrap>

**Use cases:**
- Improve existing agents (refactor mode)
- Create new skills following established patterns
- Update instructions for consistency
- Generate documentation artifacts

**How to invoke:**
1. Use the [self-bootstrap prompt](../.github/prompts/self-bootstrap.prompt.md)
2. Or invoke @interview directly with this repository as target

**Constraints:**
- Preserve contract schemas in `audit/contract-specifications.md`
- Follow `copilot-instructions.md` conventions
- Use refactor mode for existing artifacts
- Record outcomes in `generation-feedback.md`

**Candidates for self-generation:**
- Core agents in `.github/agents/`
- Creator skills in `.github/skills/`
- Instruction files in `.github/instructions/`
- Documentation prompts in `.github/prompts/`

</self_bootstrap>

<cross_references>

## Cross-References

- Interview agent: [interview.agent.md](../.github/agents/interview.agent.md)
- Interview prompt: [interview.prompt.md](../.github/prompts/interview.prompt.md)

</cross_references>
