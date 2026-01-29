---
when:
  - defining project-wide coding standards for Copilot
  - creating file-type specific instructions
  - setting up copilot-instructions.md
  - targeting instructions to specific file patterns
pairs-with:
  - file-structure
  - agent-file-format
  - prompt-files
  - settings-reference
requires:
  - none
complexity: low
---

# Instruction Files

Provide persistent rules that apply to all Copilot interactions. Use `copilot-instructions.md` for project-wide guidelines and `*.instructions.md` for file-specific rules.

## Instruction Hierarchy

Instructions combine additively. Higher priority sources take precedence when conflicts occur:

| Priority | Type | File | Location | Scope |
|----------|------|------|----------|-------|
| 1 (highest) | Personal | GitHub.com settings | GitHub.com | All repos (user) |
| 2 | Path-specific | `*.instructions.md` | `.github/instructions/` | Files matching `applyTo` |
| 3 | Repository-wide | `copilot-instructions.md` | `.github/` | All chat requests |
| 4 | Agent instructions | `AGENTS.md` | Workspace root (or subfolders) | All agents |
| 5 (lowest) | Organization | Organization settings | GitHub.com | All org repos (Enterprise) |

> **Note:** VS Code combines all instructions files and adds them to the chat context. **No specific order is guaranteed** within the workspace. Design instructions to work independently.

> **Custom Agents:** `.agent.md` files define custom agent *personas* (with tools, model selection, handoffs) — they are NOT part of the instruction precedence hierarchy. Agents can *include* instructions but are a separate concept.

**Source:** [GitHub — Response Customization](https://docs.github.com/en/copilot/concepts/prompting/response-customization#precedence-of-custom-instructions)

## copilot-instructions.md (Project-Wide)

The central file for project conventions, applied to every chat request.

### Location

```
.github/
└── copilot-instructions.md
```

### Template

```markdown
# Project: [Name]

## Tech Stack
- **Language:** TypeScript 5.4
- **Runtime:** Node.js 20
- **Framework:** Express 4.x
- **Database:** PostgreSQL 16
- **Testing:** Vitest, Supertest

## Commands
- `npm run build` — Compile TypeScript
- `npm run test` — Run tests
- `npm run lint` — Check code style
- `npm run typecheck` — Type validation

## Code Style
- Use ES modules (import/export), not CommonJS
- Prefer async/await over callbacks
- Use named exports, not default exports
- Destructure imports when possible

## File Conventions
- `src/` — Application source code
- `src/routes/` — Express route handlers
- `src/services/` — Business logic
- `src/utils/` — Shared utilities
- `tests/` — Test files mirror src/ structure

## Testing Requirements
- Unit tests for all services
- Integration tests for routes
- Minimum 80% coverage

## Git Workflow
- Branch naming: `feat/`, `fix/`, `refactor/`
- Commit format: `type(scope): message`
- Always run tests before committing

## IMPORTANT
- Never commit secrets or API keys
- Never modify migration files after deployment
- Always validate user input
```

### Six Core Areas

Analysis of 2,500+ repositories shows effective instruction files cover these areas:

| Area | What to Include | Example |
|------|-----------------|--------|
| **Commands** | Executable commands (put early) | `npm test`, `pytest -v`, `make build` |
| **Testing** | Test framework, coverage requirements | "Use Vitest, maintain 80% coverage" |
| **Project Structure** | Exact file locations | `src/api/` for routes, `tests/` mirrors `src/` |
| **Code Style** | DO THIS / NOT THIS examples | "✅ `async/await` ❌ callbacks" |
| **Git Workflow** | Commit conventions, branch naming | `feat/`, `fix/`, `type(scope): msg` |
| **Boundaries** | Explicit permissions | ✅ Always do \| ⚠️ Ask first \| 🚫 Never do |

**Source:** [GitHub Blog — How to Write a Great AGENTS.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)

### Best Practices

| Practice | Rationale |
|----------|-----------|
| Keep under 300 lines | Longer files dilute focus |
| Put commands early | Most frequently referenced |
| Use emphasis for critical rules | "IMPORTANT", "NEVER", "MUST" |
| Be specific about stack | Vague = inconsistent suggestions |

## .instructions.md (File-Specific)

Apply rules only to files matching glob patterns.

### Location

```
.github/
└── instructions/
    ├── frontend.instructions.md
    ├── backend.instructions.md
    ├── database.instructions.md
    └── testing.instructions.md
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `applyTo` | No | Glob pattern for target files. If omitted, instructions won't auto-apply but can be manually attached via `Add Context > Instructions`. |
| `name` | No | Display name in VS Code UI |
| `description` | No | Purpose description |
| `excludeAgent` | No | Exclude from specific agents (`"code-review"`, `"coding-agent"`) |

**Source:** [VS Code — Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions#_instructions-file-format)

### Format

```yaml
---
applyTo: "**/*.{ts,tsx}"      # Required: glob pattern
name: "TypeScript Standards"   # Optional: display name
description: "Type safety rules for TypeScript files"
excludeAgent: "code-review"   # Optional: exclude from code review agent
---

# TypeScript Standards

## Type Safety
- Enable strict mode in tsconfig.json
- No `any` types without explicit justification
- Use `unknown` for truly unknown types
- Prefer type inference where clear

## Import Patterns
```typescript
// ✅ Preferred
import type { User } from '@/types';
import { validateUser } from '@/utils/validation';

// ❌ Avoid
import * as utils from '@/utils';
```

## Error Handling
- Use Result<T, E> pattern for expected failures
- Throw only for unexpected errors
- Always include error context
```

### applyTo Pattern Examples

```yaml
# Frontend files
applyTo: "**/*.{jsx,tsx}"

# Backend Python
applyTo: "**/*.py"

# Test files only
applyTo: "**/test/**"
applyTo: "**/*.test.{ts,js}"
applyTo: "**/*.spec.{ts,js}"

# Specific directory
applyTo: "src/api/**"

# Multiple patterns (comma-separated)
applyTo: "**/*.ts,**/*.tsx"

# Configuration files
applyTo: "**/*.{json,yaml,yml}"
```

**Source:** [GitHub — Path-specific Custom Instructions](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot#creating-path-specific-custom-instructions)

## Complete Example Set

### `.github/instructions/react.instructions.md`

```yaml
---
applyTo: "**/*.{jsx,tsx}"
name: "React Patterns"
---

# React Component Standards

## Component Structure
```tsx
// 1. Imports (React, libs, local)
import { useState, useEffect } from 'react';
import { Button } from '@/components/ui';
import type { User } from '@/types';

// 2. Types
interface Props {
  user: User;
  onUpdate: (user: User) => void;
}

// 3. Component (named export)
export function UserCard({ user, onUpdate }: Props) {
  // 4. Hooks first
  const [isEditing, setIsEditing] = useState(false);

  // 5. Handlers
  const handleSave = () => { /* ... */ };

  // 6. Render
  return ( /* ... */ );
}
```

## Hooks Rules
- Custom hooks start with `use`
- Call hooks at top level only
- Extract complex logic to custom hooks

## State Management
- Local state for UI-only concerns
- Context for cross-cutting concerns
- Server state via React Query
```

### `.github/instructions/api.instructions.md`

```yaml
---
applyTo: "src/api/**"
name: "API Route Patterns"
---

# API Route Standards

## Route Handler Structure
```typescript
export async function POST(req: Request) {
  // 1. Parse and validate input
  const body = await req.json();
  const validated = schema.parse(body);

  // 2. Business logic
  const result = await service.create(validated);

  // 3. Return response
  return Response.json(result, { status: 201 });
}
```

## Error Responses
- 400: Validation errors (include field details)
- 401: Not authenticated
- 403: Not authorized
- 404: Resource not found
- 500: Unexpected error (log, don't expose)

## Always Include
- Input validation (Zod)
- Rate limiting for public endpoints
- Request logging
```

### `.github/instructions/testing.instructions.md`

```yaml
---
applyTo: "**/*.{test,spec}.{ts,tsx,js,jsx}"
name: "Testing Standards"
---

# Test File Standards

## Test Structure
```typescript
describe('UserService', () => {
  // Setup
  beforeEach(() => { /* reset state */ });

  describe('createUser', () => {
    it('creates user with valid input', async () => {
      // Arrange
      const input = { email: 'test@example.com' };

      // Act
      const result = await service.createUser(input);

      // Assert
      expect(result.email).toBe(input.email);
    });

    it('throws on duplicate email', async () => {
      // ...
    });
  });
});
```

## Naming Conventions
- Describe: noun (class/function name)
- It: verb phrase (does what)
- Prefer "creates X" over "should create X"

## Mocking
- Mock external services, not internal modules
- Use factories for test data
- Reset mocks in beforeEach
```

## AGENTS.md (Universal Agent Instructions)

The `AGENTS.md` file provides universal instructions for all AI agents. GitHub Copilot also supports alternative files for different AI tools.

### Location

```
project-root/
├── AGENTS.md                # Root-level: applies to all agents
├── CLAUDE.md                # Alternative: Claude-specific (root only)
├── GEMINI.md                # Alternative: Gemini-specific (root only)
├── frontend/
│   └── AGENTS.md            # Subdirectory: frontend-specific (experimental)
└── backend/
    └── AGENTS.md            # Subdirectory: backend-specific (experimental)
```

> **Alternative Files:** GitHub supports `CLAUDE.md` or `GEMINI.md` stored in the root of the repository as alternatives to `AGENTS.md`. When Copilot is working, the nearest `AGENTS.md` file in the directory tree takes precedence.

**Source:** [GitHub — Adding Custom Instructions](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot#creating-custom-instructions)

### Template

```markdown
# Agent Instructions

## Project Overview
Brief description of what this project does.

## Commands
- `npm install` — Install dependencies
- `npm run dev` — Start development server
- `npm test` — Run test suite

## Code Standards
- TypeScript strict mode required
- No `any` types without documented justification
- All functions must have return types

## Boundaries
| Action | Permission |
|--------|------------|
| Read any file | ✅ Always allowed |
| Edit existing code | ✅ Allowed |
| Create new files | ⚠️ Ask first |
| Delete files | 🚫 Never |
| Run shell commands | ⚠️ Only listed commands |

## IMPORTANT
- Never commit secrets or credentials
- Always run tests before suggesting PR
```

### Cross-Tool Portability

> **📋 Note:** This soft-linking strategy is a **community practice** for multi-tool workflows, not officially documented by VS Code or GitHub. GitHub officially supports `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` as separate files.

Use soft links to maintain a single source of truth across AI tools:

```bash
# Create unified instructions file
# Then soft-link for each tool:
ln -s AGENTS.md .github/copilot-instructions.md
ln -s AGENTS.md CLAUDE.md
ln -s AGENTS.md .cursor/rules
```

## Generate Instructions File

VS Code can analyze your workspace and generate a matching `copilot-instructions.md` file:

**Method 1 — VS Code:**
1. Open Chat view
2. Click Configure Chat (gear icon)
3. Select "Generate Chat Instructions"

**Method 2 — GitHub.com:**
Use Copilot coding agent at `github.com/copilot/agents` with a specialized prompt.

**Source:** [VS Code — Generate Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions#_generate-an-instructions-file-for-your-workspace)

## Enable in VS Code

Add to `.vscode/settings.json`:

```jsonc
{
  // Enable instruction files (default: true)
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,

  // Specify locations to search (default: .github/instructions)
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    ".vscode/instructions": true
  },

  // Enable AGENTS.md file support (default: true)
  "chat.useAgentsMdFile": true,

  // Enable nested AGENTS.md in subdirectories (experimental, default: false)
  "chat.useNestedAgentsMdFiles": false
}
```

### Settings Sync

User instruction files can sync across devices:
1. Open Command Palette → "Settings Sync: Configure"
2. Enable "Prompts and Instructions"

**Source:** [VS Code — Sync User Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions#_sync-user-instructions-files-across-devices)

### Deprecated Settings

The following settings are deprecated as of VS Code 1.102. Use instruction files instead:

```jsonc
// ❌ Deprecated — migrate to .instructions.md files
"github.copilot.chat.codeGeneration.instructions": [...],
"github.copilot.chat.testGeneration.instructions": [...]
```

**Source:** [VS Code — Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)

## How Instructions Combine

When you're editing `src/components/Button.tsx`:

1. **Personal instructions** (user profile) — highest priority
2. **Path-specific** — `react.instructions.md` (`applyTo: "**/*.tsx"`)
3. **Repository-wide** — `copilot-instructions.md`
4. **AGENTS.md** — universal agent rules
5. **Selected agent** — `.agent.md` instructions

Higher-priority sources take precedence when conflicts occur. Within a priority level, VS Code combines files with no guaranteed order.

## Advanced Patterns

### Few-Shot Examples

Include Q&A pairs to guide behavior:

```markdown
<!-- testing.instructions.md -->
When asked about testing, follow this pattern:

Q: How should I test this function?
A: Create unit tests covering: happy path, edge cases, error conditions.

Q: What testing framework should I use?
A: Use the project's configured framework (Jest/Vitest/Mocha).
```

**Source:** [Prompt Engineering Guide](https://github.com/dair-ai/Prompt-Engineering-Guide)

### Response Templates

Define structured output formats:

```markdown
<!-- copilot-instructions.md -->
## Response Templates

For code explanations:
1. **Purpose**: What this code does
2. **How it works**: Step-by-step logic
3. **Key patterns**: Design patterns used
4. **Potential issues**: Edge cases or concerns

If you cannot determine the answer with confidence, respond:
"I need more context. Could you provide [specific information needed]?"
```

## Related

- [agent-file-format](agent-file-format.md) — Agents inherit from instruction files
- [settings-reference](settings-reference.md) — Settings that control instruction loading
- [constitutional-principles](../PATTERNS/constitutional-principles.md) — Use copilot-instructions.md for immutable rules
- [file-structure](file-structure.md) — Complete `.github/` folder organization
- [skills-format](skills-format.md) — SKILL.md files for specialized capabilities

## Sources

- [VS Code — Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [GitHub — Adding Custom Instructions](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)
- [GitHub — Response Customization](https://docs.github.com/en/copilot/concepts/prompting/response-customization)
- [GitHub awesome-copilot](https://github.com/github/awesome-copilot)
- [GitHub Blog — AGENTS.md Lessons](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)
