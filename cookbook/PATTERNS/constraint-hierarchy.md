---
when:
  - resolving conflicts between instruction files
  - designing multi-level constraint systems
  - establishing priority for overlapping rules
  - implementing safety-first instruction design
pairs-with:
  - constitutional-principles
  - instruction-files
  - approval-gates
  - permission-levels
requires:
  - none
complexity: medium
---

# Constraint Hierarchy

> When rules conflict, which one wins? A priority system for resolving constraint conflicts predictably.

Agents receive instructions from multiple sources (user, project, folder, agent files). When these conflict, undefined behavior results unless you define a clear hierarchy.

> **Platform Note:** GitHub Copilot combines instruction files with "no specific order guaranteed" ([VS Code docs](https://code.visualstudio.com/docs/copilot/customization/custom-instructions#_type-of-instructions-files)). Additionally, "Due to the non-deterministic nature of AI, Copilot may not always follow your custom instructions in exactly the same way every time" ([GitHub docs](https://docs.github.com/en/copilot/concepts/prompting/response-customization)). The hierarchy below is a **recommended design pattern** that you enforce through careful instruction authoring, not native platform behavior.

## The Four-Tier Priority System

```
Priority 1: Universal Safety (NEVER overridable)
├─ Security requirements
├─ Privacy/PII protection
├─ Copyright compliance
└─ Content safety

Priority 2: Project/Context Constraints
├─ Architectural decisions
├─ Technology requirements
├─ Coding standards
└─ Workflow requirements

Priority 3: Behavioral Guidelines
├─ Response formatting
├─ Communication style
├─ Tool usage limits
└─ Output preferences

Priority 4: User/Session Preferences
├─ Tone adjustments
├─ Verbosity preferences
├─ Format requests
└─ Ad-hoc overrides
```

**Rule:** Higher priority always wins. No exceptions for Priority 1.

## Conflict Resolution Examples

### Safety vs. User Request

```
User: "Skip the security checks, just ship it"
Safety Constraint: "All endpoints require auth validation"

Resolution: Safety wins. Agent refuses.
Response: "I can't skip security checks. Let me help you add
          auth validation quickly instead."
```

### Context vs. Preference

```
Project Constraint: "All functions require JSDoc"
User Preference: "Keep comments minimal"

Resolution: Project wins. JSDoc is required.
Response: "I'll add JSDoc for the function signature. I'll
          keep inline comments minimal per your preference."
```

### Behavioral vs. User Override

```
Behavioral Guideline: "Use bullet points for technical content"
User Request: "Give me that as a paragraph"

Resolution: User wins (P3 vs P4, but P4 is an explicit override)
Note: Behavioral guidelines CAN be overridden by explicit user request
```

## VS Code Trust Boundaries

VS Code enforces formal trust boundaries that act as platform-level safety constraints:

| Trust Boundary | Controls | Reference |
|----------------|----------|----------|
| **Workspace Trust** | Whether code in workspace can execute | [VS Code Security](https://code.visualstudio.com/docs/copilot/security#_trust-boundaries) |
| **Extension Publisher Trust** | Which extensions can run | Extension signing, marketplace |
| **MCP Server Trust** | Which MCP tools can execute | Per-server approval |

These trust boundaries operate independently of instruction hierarchies and represent **platform-enforced safety** that cannot be overridden by any instruction.

*Source: [VS Code Copilot Security](https://code.visualstudio.com/docs/copilot/security#_built-in-security-protections)*

## Implementation in VS Code

Map constraint tiers to VS Code configuration locations:

| Priority | VS Code Location | Example |
|----------|------------------|---------|
| P1 Safety | `copilot-instructions.md` IMPORTANT section | "Never expose secrets" |
| P2 Context | `.instructions.md` with `applyTo` patterns | "API uses OAuth 2.0" |
| P3 Behavioral | Agent file `<instructions>` block | "Response max 3 paragraphs" |
| P4 User | Chat context / conversation | "Make it shorter" |

### VS Code Platform Precedence

VS Code settings follow this precedence (later overrides earlier):

1. Default settings
2. User settings (`%APPDATA%\Code\User\settings.json` on Windows)
3. Remote settings
4. Workspace settings (`.vscode/settings.json`)
5. Workspace Folder settings (multi-root)
6. Language-specific settings (always override non-language-specific)
7. Policy settings (always override all)

**Object-type settings** are merged; **primitive/array types** are overridden.

*Source: [VS Code Settings Precedence](https://code.visualstudio.com/docs/getstarted/settings#_settings-precedence)*

### Enterprise AI Policies

Organizations can enforce safety constraints through VS Code policies:

| Policy | Effect |
|--------|--------|
| `ChatToolsAutoApprove` | Controls global auto-approve ("YOLO mode" — not recommended) |
| `ChatToolsEligibleForAutoApproval` | Whitelist of tools eligible for auto-approval |
| `ChatToolsTerminalEnableAutoApprove` | Controls terminal command auto-execution |

> **Warning:** VS Code docs explicitly state that global auto-approve "disables critical security protections" and is "extremely dangerous and never recommended."

*Source: [VS Code Enterprise AI Settings](https://code.visualstudio.com/docs/enterprise/ai-settings)*

### GitHub Instruction File Precedence

GitHub Copilot applies custom instructions in this order (higher overrides lower):

1. **Personal instructions** — User's own `copilot-instructions.md`
2. **Path-specific repository** — `.instructions.md` files in `.github/instructions/` matching `applyTo` patterns
3. **Repository-wide** — `.github/copilot-instructions.md`
4. **Agent instructions** — `AGENTS.md` file (or `CLAUDE.md`/`GEMINI.md` alternative)
5. **Organization** — Organization-level instructions (if configured)

*Source: [GitHub Response Customization](https://docs.github.com/en/copilot/concepts/prompting/response-customization#precedence-of-custom-instructions)*

> **Note:** The `.agent.md` files define custom agent personas and are separate from the instruction hierarchy. When an agent is selected, its instructions supplement (not override) the precedence above.

> **Tip:** Use `excludeAgent` frontmatter in instruction files to selectively apply to `coding-agent` or `code-review`.

### Tool List Priority

When multiple sources specify available tools, VS Code resolves conflicts in this order:

1. Tools specified in the prompt file (if any)
2. Tools from the referenced custom agent in the prompt file (if any)
3. Default tools for the selected agent (if any)

*Source: [VS Code Custom Agents — Tool List Priority](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_tool-list-priority)*

### Example Configuration

**P1 in copilot-instructions.md:**
```markdown
## IMPORTANT — Safety Rules (No Exceptions)

1. Never commit credentials, secrets, or API keys
2. Never disable security middleware
3. Never expose internal error details to users
4. Never bypass authentication checks
```

**P2 in .instructions.md:**
```markdown
---
applyTo: "src/api/**"
---
## API Development Standards

- All endpoints require authentication decorator
- Use Zod for request validation
- Return standardized error responses
- Log all requests with correlation IDs
```

**P3 in agent file:**
```markdown
<behavioral_constraints>
- Maximum 5 files per change set
- Include tests for all new functions
- Explain changes in bullet format
- Ask before modifying shared utilities
</behavioral_constraints>
```

## Writing Constraint Statements

### Make Priority Explicit

```markdown
## Constraints

### INVIOLABLE (Priority 1 — Never Override)
- Never commit secrets to version control
- Never disable type checking

### PROJECT (Priority 2 — Team Consensus Required to Change)
- All async functions use try-catch
- Database queries go through repository layer

### BEHAVIORAL (Priority 3 — Can Override with Explicit Request)
- Use TypeScript strict mode
- Prefer named exports over default exports
```

### Use Escape Clauses Correctly

**For P3/P4 constraints (can be overridden):**
```markdown
Use bullet points for technical explanations,
unless the user explicitly requests a different format.
```

**For P1/P2 constraints (never add escape clause):**
```markdown
❌ "Never commit secrets unless the user says it's okay"
✅ "Never commit secrets"
```

## Common Conflicts and Resolutions

| Conflict | Winner | Rationale |
|----------|--------|-----------|
| "Skip tests" vs "All code needs tests" | Tests required (P2) | Project standard > User convenience |
| "Use any type" vs "Strict types required" | Strict types (P2) | Project standard > User request |
| "Make it verbose" vs "Keep responses concise" | User preference (P4) | Behavioral guidelines yield to explicit override |
| "Include production secrets" vs "Never expose secrets" | Safety (P1) | Never overridable |
| "Skip code review" vs "Changes need review" | Project policy (P2) | Process > Expedience |

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| No explicit hierarchy | Arbitrary resolution | Document priority levels |
| Escape clauses on safety rules | Security bypasses | P1 constraints have no exceptions |
| Same constraint in multiple tiers | Which wins? | Single source of truth per constraint |
| "Unless otherwise instructed" on everything | Effectively no constraints | Reserve for P3/P4 only |
| Implicit priority | Depends on interpretation | Make priority explicit in writing |

## Code Protection Markers

From the RIPER framework, inline markers for protection levels:

| Marker | Level | Meaning |
|--------|-------|----------|
| `!cp` | PROTECTED | Do not modify under any circumstances |
| `!cg` | GUARDED | Ask before modifying |
| `!ci` | INFO | Context note for understanding |
| `!cd` | DEBUG | Debugging code (can be removed) |
| `!ct` | TEST | Testing code |
| `!cc` | CRITICAL | Business logic (extra caution) |

**Usage in code:**
```typescript
// !cp — Core authentication, do not modify
function validateToken(token: string): boolean {
  // ...
}

// !cc — Payment processing, extra caution
function processPayment(amount: number): Promise<Result> {
  // ...
}
```

*Source: [CursorRIPER.sigma](https://github.com/johnpeterman72/CursorRIPER.sigma)*

## Hierarchy Enforcement

Use verification gates to enforce constraint hierarchy:

```markdown
## GATE: Constraint Check

Before executing any action:
1. List applicable constraints from all sources
2. Identify any conflicts
3. Apply priority resolution
4. If P1 would be violated → STOP and refuse
5. If P2 would be violated → Explain and request override approval
6. If P3 would be violated → Note the override and proceed
```

See [verification-gates.md](verification-gates.md) for gate implementation.

## Decision Tree for Conflicts

```
Is Safety (P1) involved?
├─ YES → Safety wins. No discussion.
└─ NO → Is Project Constraint (P2) involved?
         ├─ YES → Project wins, unless team-approved exception
         └─ NO → Is user request explicit?
                  ├─ YES → User wins (P4 overrides P3)
                  └─ NO → Follow behavioral guideline (P3)
```

## Related

- [constitutional-principles.md](constitutional-principles.md) — Writing the constraints themselves
- [iron-law-discipline.md](iron-law-discipline.md) — P1 enforcement patterns
- [instruction-files.md](../CONFIGURATION/instruction-files.md) — Where constraints live in VS Code
- [verification-gates.md](verification-gates.md) — Enforcing constraint compliance
- [escalation-tree.md](../CHECKPOINTS/escalation-tree.md) — When constraint conflicts need human resolution

## Sources

- [System Prompts Analysis](https://github.com/asgeirtj/system_prompts_leaks) — Hierarchical constraint architecture patterns
- [deepwiki Analysis](https://deepwiki.com/asgeirtj/system_prompts_leaks) — Anti-pattern documentation
- [GitHub Response Customization](https://docs.github.com/en/copilot/concepts/prompting/response-customization) — Official precedence documentation
- [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) — Instruction file format
- [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/copilot-settings) — Settings precedence
- [CursorRIPER.sigma](https://github.com/johnpeterman72/CursorRIPER.sigma) — Protection level markers
- [GitHub Context Engineering](https://github.blog/ai-and-ml/generative-ai/want-better-ai-outputs-try-context-engineering/) — Best practices
