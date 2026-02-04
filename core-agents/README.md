# Core Agents

Four reusable agents for VS Code Copilot workflows.

<agents>

## Included Agents

- **architect** — Plans implementation, creates technical specs
- **brain** — Researches, explores, analyzes options
- **build** — Executes plans, implements changes
- **inspect** — Validates quality, audits artifacts

</agents>

<prerequisites>

## Prerequisites

- VS Code 1.99+
- GitHub Copilot extension
- GitHub Copilot Chat extension

</prerequisites>

<installation>

## Installation

1. Copy `agents/` folder to your project's `.github/agents/`
2. (Optional) Add `copilot-instructions.md` for project context
3. Invoke agents via `@architect`, `@brain`, `@build`, `@inspect`

</installation>

<portability>

## Portability Notes

These agents are optimized for Claude 4.x models and include fallbacks for:
- Missing tools (provides manual alternatives)
- Missing handoff targets (outputs context for manual transfer)
- Missing copilot-instructions.md (operates with general practices)

**Known limitations:**
- Agent handoffs assume target agents exist (fallback: manual context transfer)
- Some features degrade gracefully when tools unavailable
- Model-specific optimizations may vary on other models

</portability>

<customization>

## Customization

Add project-specific behavior via:
1. `copilot-instructions.md` — Project context loaded by all agents
2. `.instructions.md` files — File-pattern rules for specific contexts
3. Agent overlays — Copy and modify agent files directly

See [docs/customization.md](docs/customization.md) for detailed patterns.

</customization>

<changelog_ref>

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

</changelog_ref>
