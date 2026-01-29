---
when:
  - creating reusable prompt templates
  - building parameterized workflows
  - setting up code review or feature spec prompts
  - organizing repeated prompt patterns
pairs-with:
  - file-structure
  - instruction-files
  - context-variables
  - agent-file-format
requires:
  - none
complexity: low
---

# Prompt Files (.prompt.md)

Reusable prompt templates with parameters, tool configuration, and context loading. Use for workflows you repeat: code review, feature specs, refactoring patterns.

## Location

### Workspace Prompts (Per-Project)
```
.github/prompts/
├── code-review.prompt.md
├── feature-spec.prompt.md
├── refactor.prompt.md
└── create-api.prompt.md
```

Enable discovery:
```json
{
  "chat.promptFilesLocations": { ".github/prompts": true }
}
```

### User Prompts (Cross-Workspace)
Prompts stored in your VS Code profile are available across all workspaces:

1. In Chat view, select **Configure Chat** (gear icon) > **Prompt Files** > **New prompt file**
2. Or use Command Palette → `Chat: New Prompt File` (select "User profile" location)
3. These sync across devices via **Settings Sync** (enable "Prompts and Instructions" sync category)

**Use for:** Personal workflows, boilerplate prompts, organization-wide standards.

## Format

```markdown
---
agent: agent
model: Claude Sonnet 4
tools: ['read_file', 'edit_file', 'search']
description: Brief description shown in prompt picker
---

# Prompt Title

Your prompt content with ${variables} and context loading.
```

### Frontmatter Fields

| Field | Type | Purpose |
|-------|------|---------|
| `agent` | `ask` \| `edit` \| `agent` \| `<custom-agent-name>` | Agent used for running the prompt. Use `ask` for Q&A, `edit` for code changes, `agent` for multi-step tasks, or name of a custom agent |
| `model` | string | Optional model override (defaults to current picker selection) |
| `tools` | string[] | Tools the prompt can use. Supports: `["*"]` for all, specific names, or MCP server wildcards like `["github/*"]` |
| `description` | string | Shows in VS Code prompt picker |
| `name` | string | Identifier used after typing `/` in chat. Defaults to filename if not specified |
| `argument-hint` | string | Hint text shown in chat input field to guide users (e.g., "Describe the feature to implement") |

**Tool Priority Order:** When tools are specified:
1. Prompt file `tools` (highest priority)
2. Custom agent tools (if `agent` specified)
3. Default agent tools (lowest priority)

## Context Variables

Inject dynamic content with variable syntax:

| Variable | Description | Example |
|----------|-------------|---------|
| `${file}` | Current file path | `/src/app/page.tsx` |
| `${fileBasename}` | Current file name | `page.tsx` |
| `${fileBasenameNoExtension}` | File name without extension | `page` |
| `${fileDirname}` | Directory of current file | `/src/app` |
| `${selection}` | Selected text/code | User's highlighted code |
| `${selectedText}` | Alias for `${selection}` | User's highlighted code |
| `${workspaceFolder}` | Workspace root path | `/Users/dev/my-project` |
| `${workspaceFolderBasename}` | Workspace folder name | `my-project` |
| `${input:varName}` | Prompt user for input | Dialog asks for value |
| `${input:varName:placeholder}` | User input with placeholder | Dialog shows hint text |

## Invoking Prompt Files

### From Chat
Type `/` in chat to see available prompts, or reference directly:

```
/code-review
```

### From Command Palette
Use `Chat: Run Prompt` command to select and run any prompt file.

### From Editor
Open a `.prompt.md` file and click the **play button** in the editor title bar to run it.

### Reference Tools in Body
Use `#tool:<tool-name>` syntax to reference agent tools within the prompt body:

```markdown
Use #tool:semantic_search to find similar implementations.
Then use #tool:read_file to examine the matches.
```

### Via Agent Field
Prompts can invoke specific agents:

```yaml
# In .prompt.md frontmatter
agent: plan  # Uses the 'plan' custom agent
```

> **Note:** Agent handoffs (in `.agent.md` files) target other **agents**, not prompt files. Use the `agent` frontmatter field in prompts to specify which agent should run the prompt.

### Context Loading via Markdown Links
Load additional files into context:

```markdown
Review [project conventions](../docs/conventions.md) and
[API patterns](../src/api/README.md) before proceeding.
```

## Examples

### Code Review Prompt

```markdown
---
agent: agent
tools: ['read_file', 'grep_search']
description: Comprehensive code review with security focus
---

# Code Review

Review ${selection} for:

## Security
- Input validation and sanitization
- Authentication/authorization checks
- SQL injection, XSS vulnerabilities

## Performance
- Unnecessary iterations or computations
- Memory leaks or resource cleanup
- N+1 query patterns

## Maintainability
- Clear naming and documentation
- Single responsibility adherence
- Test coverage gaps

Provide specific line-by-line feedback with suggested fixes.
```

### Feature Specification Prompt

```markdown
---
agent: plan
model: Claude Sonnet 4
tools: ['read_file', 'search']
description: Create detailed feature specification
---

# Feature Specification: ${input:featureName}

## Context Loading
1. Review [project architecture](../docs/architecture.md)
2. Check [existing patterns](../src/patterns/)
3. Analyze related code via search

## Specification Template

### Overview
- **Goal**: What problem does this solve?
- **Users**: Who benefits?
- **Scope**: What's included/excluded?

### Requirements
- Functional requirements
- Non-functional requirements (performance, security)

### Technical Approach
- Architecture changes needed
- API surface
- Database changes
- Integration points

### Tasks
Break into implementable units with estimates.

🚨 **STOP**: Review specification before implementation.
```

### Refactoring Prompt

```markdown
---
agent: agent
tools: ['read_file', 'edit_file', 'grep_search']
description: Refactor code for readability and performance
---

# Refactoring

Refactor ${selection}:

## Goals
- Improve readability and clarity
- Follow [project conventions](../docs/conventions.md)
- Maintain existing behavior (no functional changes)

## Approach
1. Identify code smells and complexity
2. Extract methods for reuse
3. Simplify conditionals
4. Improve naming
5. Add missing documentation

## Output
- Refactored code block
- Brief explanation of each change
- Any risks or concerns
```

### API Endpoint Prompt

```markdown
---
agent: agent
tools: ['read_file', 'edit_file', 'search']
description: Create new API endpoint following patterns
---

# Create API Endpoint: ${input:endpointPath}

## Context
1. Review [API conventions](../docs/api-conventions.md)
2. Check existing endpoints in [routes/](../src/routes/)
3. Follow authentication patterns

## Implementation Checklist
- [ ] Route handler with proper HTTP method
- [ ] Input validation with schema
- [ ] Authentication/authorization middleware
- [ ] Error handling with standard responses
- [ ] OpenAPI documentation
- [ ] Unit tests

## Request Specification
**Path**: ${input:endpointPath}
**Method**: ${input:httpMethod}
**Purpose**: ${input:purpose}

Generate complete implementation following project patterns.
```

## Best Practices

### Structure for Clarity
Use the four-element pattern:

```markdown
## Instruction
Specific task to perform

## Context
External information and constraints

## Input
${selection} or ${input:data}

## Expected Output
Format and structure of response
```

### Include Validation Gates
For complex workflows, add checkpoints:

```markdown
🚨 **STOP**: Review the plan before proceeding.
[ ] Requirements match user intent
[ ] Approach follows conventions
[ ] No missing edge cases
```

### Keep Prompts Focused
One prompt = one workflow. If a prompt does multiple unrelated things, split it.

### Use Positive Instructions
Say what to do, not what to avoid:

```markdown
# ✅ Good
Write concise functions under 20 lines
Use explicit types for all parameters

# ❌ Avoid
Don't write long functions
Don't use any types
```

## Settings Reference

| Setting | Default | Description |
|---------|---------|-------------|
| `chat.promptFilesLocations` | `{".github/prompts": true}` | Folders to search for prompt files |
| `chat.promptFilesRecommendations` | `true` | Show prompts as recommended actions when starting new chat |

## Related

- [context-variables](../CONTEXT-ENGINEERING/context-variables.md) — Full variable reference
- [agent-file-format](./agent-file-format.md) — Agents that invoke prompts
- [settings-reference](./settings-reference.md) — All Copilot settings
- [prompt-engineering](../PATTERNS/prompt-engineering.md) — Prompt authoring patterns
- [collections-format](../REFERENCE/collections-format.md) — Bundle prompts for distribution

## Sources

- [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) — Official specification
- [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) — Workflow patterns
- [Prompt Engineering Guide](https://github.com/dair-ai/Prompt-Engineering-Guide) — Four-element pattern source
- [awesome-copilot prompts](https://github.com/github/awesome-copilot/tree/main/prompts) — Community examples
