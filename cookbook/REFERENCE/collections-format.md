---
when:
  - bundling prompts, agents, and skills for sharing
  - creating shareable asset packages
  - organizing team-wide Copilot resources
  - publishing to awesome-copilot
pairs-with:
  - agent-file-format
  - prompt-files
  - skills-format
  - instruction-files
requires:
  - none
complexity: medium
---

# Collections Format

Bundle prompts, instructions, agents, and skills as shareable packages using `.collection.yml` files. Collections are a community-defined format used by [github/awesome-copilot](https://github.com/github/awesome-copilot) for organizing and sharing Copilot assets.

> **Platform Note:** The `.collection.yml` format is defined by the [awesome-copilot repository](https://github.com/github/awesome-copilot), not official GitHub/VS Code documentation. VS Code docs reference awesome-copilot for community examples. Since VS Code 1.102, individual items can be imported via `vscode://` links. The collection manifest itself is for organization and discovery — VS Code does not natively parse `.collection.yml` files.
>
> **Sources:** [awesome-copilot collection.schema.json](https://github.com/github/awesome-copilot/blob/main/.schemas/collection.schema.json), [VS Code 1.102 Release Notes](https://code.visualstudio.com/updates/v1_102)

## Format Schema

```yaml
# .collection.yml
id: my-collection-id           # Unique identifier (kebab-case, max 50 chars)
name: My Collection Name       # Display name
description: A brief description of what this collection provides  # Max 500 chars
tags: [tag1, tag2, tag3]       # Discoverable categories (max 10)

items:                          # Max 50 items per collection
  - path: prompts/my-prompt.prompt.md
    kind: prompt

  - path: instructions/my-instructions.instructions.md
    kind: instruction

  - path: agents/my-agent.agent.md
    kind: agent
    usage: |
      Recommended usage notes for this agent.
      Describe when to use it and any prerequisites.

  - path: skills/my-skill/SKILL.md
    kind: skill

display:
  ordering: alpha              # alpha | manual (default)
  show_badge: true             # Display featured badge
  featured: false              # Highlight in listings
```

## Item Kinds

| Kind | File Extension | Description |
|------|----------------|-------------|
| `prompt` | `.prompt.md` | Reusable prompt templates invoked with `/` |
| `instruction` | `.instructions.md` | Context injection files for automatic or manual inclusion |
| `agent` | `.agent.md` | Chat participants with custom behaviors |
| `skill` | `SKILL.md` (in folder) | Self-contained capabilities with bundled assets |

## Field Reference

| Field | Required | Constraints | Description |
|-------|----------|-------------|-------------|
| `id` | Yes | lowercase + numbers + hyphens, max 50 chars | Unique identifier (pattern: `^[a-z0-9-]+$`) |
| `name` | Yes | Max 100 chars | Human-readable display name |
| `description` | Yes | Max 500 chars | Brief explanation of collection purpose |
| `tags` | No | Max 10 tags, each max 30 chars, pattern `^[a-z0-9-]+$` | Array of discovery tags |
| `items` | Yes | Max 50 items | Array of bundled assets |
| `items[].path` | Yes | Must match pattern | Relative path to asset file |
| `items[].kind` | Yes | prompt/instruction/agent/skill | Asset type |
| `items[].usage` | No | Markdown supported | Usage notes (agents/skills only) |
| `display.ordering` | No | alpha/manual | Sort order (default: manual) |
| `display.show_badge` | No | boolean | Display featured badge |
| `display.featured` | No | boolean | Highlight in listings |

### Path Validation

Item paths must match this pattern:
```
^(?:skills/[^/]+/SKILL\.md|(prompts|instructions|agents)/[^/]+\.(prompt|instructions|agent)\.md)$
```

Examples:
- ✅ `prompts/my-prompt.prompt.md`
- ✅ `agents/my-agent.agent.md`
- ✅ `skills/my-skill/SKILL.md`
- ❌ `.github/prompts/my-prompt.prompt.md` (no nested paths)
- ❌ `my-prompt.md` (wrong extension)

## Example: Framework Toolkit

Bundle framework-specific prompts, instructions, and agents:

```yaml
# collections/react-typescript-toolkit.collection.yml
id: react-typescript-toolkit
name: React + TypeScript Toolkit
description: Prompts, instructions, and agents for React/TypeScript development
tags: [react, typescript, frontend, components]

items:
  # Prompts for common tasks
  - path: prompts/create-component.prompt.md
    kind: prompt
  - path: prompts/add-tests.prompt.md
    kind: prompt
  - path: prompts/refactor-hooks.prompt.md
    kind: prompt

  # Instructions for automatic context
  - path: instructions/react-patterns.instructions.md
    kind: instruction
  - path: instructions/typescript-strict.instructions.md
    kind: instruction

  # Specialized agents
  - path: agents/component-architect.agent.md
    kind: agent
    usage: |
      Use for designing component hierarchies.
      Start with: "Design a component structure for [feature]"
  
  # Bundled skill
  - path: skills/react-testing/SKILL.md
    kind: skill
    usage: |
      Testing utilities and patterns for React components.

display:
  ordering: manual
```

## Example: Team Workflow Collection

Bundle a multi-agent workflow for team use:

```yaml
# collections/feature-workflow.collection.yml
id: feature-workflow
name: Feature Development Workflow
description: Research → Plan → Implement → Review agent chain
tags: [workflow, team, feature-development]

items:
  # Phase agents (ordered manually)
  - path: agents/research.agent.md
    kind: agent
    usage: |
      Start here. Investigates requirements, constraints, prior art.
      Hands off to planner when research complete.

  - path: agents/planner.agent.md
    kind: agent
    usage: |
      Creates implementation plan from research.
      Breaks work into testable increments.
      Hands off to implementer.

  - path: agents/implementer.agent.md
    kind: agent
    usage: |
      Executes plan, creates files, runs tests.
      Hands off to reviewer when implementation complete.

  - path: agents/reviewer.agent.md
    kind: agent
    usage: |
      Final quality gate. Reviews code, tests, documentation.
      Approves or requests changes.

  # Supporting instructions
  - path: instructions/code-standards.instructions.md
    kind: instruction
  - path: instructions/test-requirements.instructions.md
    kind: instruction

display:
  ordering: manual
  featured: true
```

## Directory Structure

Collections in awesome-copilot reference assets from repository root directories:

```
awesome-copilot/
├── collections/                # Collection manifests
│   ├── react-toolkit.collection.yml
│   └── team-workflow.collection.yml
├── prompts/                    # .prompt.md files
│   ├── create-component.prompt.md
│   └── add-tests.prompt.md
├── instructions/               # .instructions.md files (100+)
│   ├── react-patterns.instructions.md
│   └── code-standards.instructions.md
├── agents/                     # .agent.md files (70+)
│   ├── research.agent.md
│   ├── planner.agent.md
│   └── implementer.agent.md
└── skills/                     # SKILL.md folders
    └── react-testing/
        └── SKILL.md
```

### Local Project Structure

When adapting collections for your own project:

```
your-project/
├── .github/
│   ├── prompts/
│   ├── instructions/
│   └── agents/
└── ...
```

> **Note:** awesome-copilot uses root-level directories for community sharing. For project-specific assets, the `.github/` prefix is conventional.

## Collections vs Skills

| Aspect | Collections | Skills |
|--------|-------------|--------|
| **Purpose** | Organizing/sharing multiple assets | Single capability with bundled resources |
| **Format** | `.collection.yml` manifest | `SKILL.md` + folder assets |
| **Contains** | References to files (paths) | Self-contained capability |
| **Loading** | Manual copy from awesome-copilot | Agent requests dynamically |
| **Scope** | Multiple prompts/agents/instructions | One specific capability |
| **Use case** | Share curated asset sets | Add tool abilities to agents |

**When to use which:**
- **Collections** — Organize and share your prompts/agents with others via awesome-copilot
- **Skills** — Give agents new capabilities (scripts, tools, data)
- **Skills IN Collections** — Include skill references alongside prompts/agents in a collection

## Using Collections

Collections are **organizational manifests**. To use items from a collection:

### VS Code Link Import (v1.102+)

Since VS Code 1.102, you can import prompts, instructions, and agents via `vscode://` links directly from awesome-copilot:

1. Browse [github/awesome-copilot](https://github.com/github/awesome-copilot)
2. Click the "Install in VS Code" badge on any item
3. VS Code opens and imports the file to your workspace

> Source: [VS Code 1.102 Release Notes](https://code.visualstudio.com/updates/v1_102#_import-modes-prompts-and-instructions-via-a-vscode-link)

### Manual Copy

1. Browse [github/awesome-copilot/collections](https://github.com/github/awesome-copilot/tree/main/collections)
2. Find a collection matching your needs
3. Copy referenced files to your project's `.github/` directories
4. Adapt paths and configurations as needed

## Contributing to awesome-copilot

To publish your collection:

1. Fork [github/awesome-copilot](https://github.com/github/awesome-copilot)
2. Add your assets to appropriate directories (`prompts/`, `agents/`, etc.)
3. Create collection file in `collections/` (not `.github/collections/`)
4. Ensure paths follow validation pattern (see Path Validation above)
5. Run validation: `npm run validate` (uses `validate-collections.mjs`)
6. Submit PR with description of what your collection provides

### Contribution Guidelines

From [CONTRIBUTING.md](https://github.com/github/awesome-copilot/blob/main/CONTRIBUTING.md):
- Follow the schema strictly — validation enforces constraints
- Keep descriptions under 500 characters
- Use max 10 tags per collection
- Max 50 items per collection
- Include meaningful `usage` for agents and skills

## Related

- [agent-file-format](../CONFIGURATION/agent-file-format.md) — Format for `kind: agent` items
- [prompt-files](../CONFIGURATION/prompt-files.md) — Format for `kind: prompt` items
- [instruction-files](../CONFIGURATION/instruction-files.md) — Format for `kind: instruction` items
- [skills-format](../CONFIGURATION/skills-format.md) — Format for `kind: skill` items
- [file-structure](../CONFIGURATION/file-structure.md) — Directory conventions
- [handoffs-and-chains](../WORKFLOWS/handoffs-and-chains.md) — Multi-agent workflow configuration

## Sources

- [github/awesome-copilot](https://github.com/github/awesome-copilot) — Community repository with 115+ agents, 140+ instructions (as of Jan 2026)
- [collection.schema.json](https://github.com/github/awesome-copilot/blob/main/.schemas/collection.schema.json) — Official schema definition
- [awesome-copilot CONTRIBUTING.md](https://github.com/github/awesome-copilot/blob/main/CONTRIBUTING.md) — Contribution guidelines
- [GitHub Docs: Response Customization](https://docs.github.com/en/copilot/concepts/prompting/response-customization) — References awesome-copilot for examples
- [meta-agentic-framework-research-extended.md](../../research/meta-agentic-framework-research-extended.md) — Primary research source
