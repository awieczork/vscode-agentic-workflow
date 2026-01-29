---
type: patterns
version: 1.0.0
purpose: Define THE framework approach for creating prompt files
applies-to: [generator, build, inspect]
last-updated: 2026-01-28
---

# Prompt Patterns

> **Reusable prompt templates with parameters, tool configuration, and context loading for repeated workflows**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
1. Use STRUCTURE section to create prompt file skeleton
2. Apply AUTHORING RULES for each section
3. Validate against VALIDATION CHECKLIST before output

**For Build Agents:**
1. Reference STRUCTURE for required sections
2. Use EXAMPLES as implementation guides
3. Follow AUTHORING RULES for content

**For Inspect Agents:**
1. Verify all VALIDATION CHECKLIST items pass
2. Flag ANTI-PATTERNS violations
3. Confirm frontmatter fields are complete

---

## PURPOSE

**Prompt files eliminate repetition** by encapsulating reusable workflows with:
- Dynamic parameters (`${input:name}`)
- Context injection (`${file}`, `${selection}`)
- Tool permissions (`tools: [...]`)
- Agent targeting (`agent: plan`)

**Use prompt files for:**
- Code review workflows
- Feature specification generation
- Refactoring patterns
- API endpoint creation
- Any workflow repeated 3+ times

**Do NOT use prompt files for:**
- One-off queries (use chat directly)
- Agent behavior definition (use `.agent.md`)
- Persistent instructions (use `.instructions.md` or `copilot-instructions.md`)

---

## THE FRAMEWORK APPROACH

**Single source of truth:** Prompt files are templates invoked by users. They target agents but cannot receive agent handoffs.

**Direction of invocation:**
```
User → Prompt → Agent (via frontmatter)  ✅
Agent handoff → Prompt                    ❌ (agents handoff to agents, not prompts)
```

**File extension:** `.prompt.md`

**Location hierarchy:**

| Location | Path | Scope | Sync |
|----------|------|-------|------|
| Workspace | `.github/prompts/` | Per-project | Git |
| User profile | VS Code profile storage | Cross-workspace | Settings Sync |

**Enable workspace discovery:**
```json
{
  "chat.promptFilesLocations": { ".github/prompts": true }
}
```

---

## STRUCTURE

### Required Sections

| Section | Purpose | Required |
|---------|---------|----------|
| YAML Frontmatter | Agent, tools, description | ⚠️ Spec-optional, pattern-RECOMMENDED |
| Title (`# Heading`) | Prompt identification | ✅ |
| Body Content | Task instructions | ✅ |

### Section Order

```
1. YAML frontmatter (---)
2. Title (# Prompt Name)
3. Body content (instructions, context, input, output)
```

### Frontmatter Fields

| Field | Type | Default | Purpose |
|-------|------|---------|---------|
| `agent` | `ask` \| `edit` \| `agent` \| `<custom-name>` | Current mode | Agent to run prompt |
| `model` | string | Picker selection | Model override |
| `tools` | string[] | Agent default | Tool access list |
| `description` | string | — | Shows in VS Code picker |
| `name` | string | Filename | Identifier after `/` in chat |
| `argument-hint` | string | — | Input field hint text |

**Tool array formats:**
```yaml
tools: ['*']                    # All available tools
tools: ['read_file', 'edit_file']  # Specific tools
tools: ['github/*']             # MCP server wildcard
tools: []                       # Disable tools (ask-only mode)
```

**Tool priority order (immutable):**
1. Prompt `tools:` (highest)
2. Agent tools (if `agent:` specified)
3. Default agent tools (lowest)

### Body Structure: Four-Element Pattern

The four-element pattern maximizes clarity and LLM comprehension:

| Element | Purpose | Example |
|---------|---------|---------|
| **Instruction** | Specific task to perform | "Review this code for security issues" |
| **Context** | External constraints/information | "Follow project conventions" + file links |
| **Input** | Dynamic content | `${selection}` or `${input:data}` |
| **Output** | Expected format/structure | "Provide line-by-line feedback" |

**Template:**
```markdown
## Instruction
{Specific task}

## Context
{Background, constraints, reference links}

## Input
${selection}

## Expected Output
{Format specification}
```

---

## CONTEXT VARIABLES

### Template Variables (`${}`)

Variables substitute at prompt invocation time:

| Variable | Resolved To | Example |
|----------|-------------|---------|
| `${file}` | Current file path | `/src/app/page.tsx` |
| `${fileBasename}` | Filename | `page.tsx` |
| `${fileBasenameNoExtension}` | Name without ext | `page` |
| `${fileDirname}` | File directory | `/src/app` |
| `${selection}` | Selected text | Highlighted code |
| `${selectedText}` | Alias for `${selection}` | Highlighted code |
| `${workspaceFolder}` | Workspace root | `/Users/dev/project` |
| `${workspaceFolderBasename}` | Folder name | `project` |
| `${input:name}` | User dialog | Runtime value |
| `${input:name:placeholder}` | Dialog with hint | Runtime value |

**⚠️ Undefined Variable Behavior:**
- Undefined variables render as literal strings (silent failure)
- `${typo}` → outputs `${typo}` literally, no error
- Generator MUST use only documented variables

**⚠️ Selection Availability:**
- `${selection}` = empty string if nothing selected
- Prompts invoked via Command Palette may have no selection
- Design prompts to handle empty selection gracefully

### Context Loading

**Markdown links load file content:**
```markdown
Review [project conventions](../docs/conventions.md) before proceeding.
```

**Path resolution:**
- Paths relative to prompt file location
- Use `${workspaceFolder}` for absolute paths: `[arch](${workspaceFolder}/docs/arch.md)`

**⚠️ Context Budget Warning:**
- Large linked files consume context budget
- Prefer specific file sections over entire files
- Split into phases for multiple large files

### Tool References in Body

**`#tool:<name>` instructs tool usage:**
```markdown
Use #tool:semantic_search to find similar implementations.
Then use #tool:read_file to examine the matches.
```

**`#filename.ext` adds file context:**
```markdown
Review #routes.ts for the current implementation.
```

**Distinction:**
- `#tool:X` = instruction to use a specific tool
- `#filename` = add file to context (VS Code autocomplete after `#`)

---

## INVOCATION METHODS

| Method | How | When |
|--------|-----|------|
| Chat | Type `/promptname` | Quick access |
| Command Palette | `Chat: Run Prompt` | Browse all prompts |
| Editor | Open `.prompt.md` → play button | Test during authoring |

---

## AUTHORING RULES

```
RULE_001: Frontmatter minimum
  REQUIRE: `agent` AND `description` fields
  REJECT_IF: Empty frontmatter in generated prompts
  RATIONALE: Spec allows omission but prompts without these are unusable
  EXAMPLE_VALID:
    ---
    agent: agent
    description: Review code for security issues
    ---
  EXAMPLE_INVALID:
    ---
    ---
```

```
RULE_002: Single-purpose prompts
  REQUIRE: One workflow per prompt file
  REJECT_IF: Prompt performs multiple unrelated tasks
  RATIONALE: Multi-purpose prompts are harder to reuse and predict
  EXAMPLE_VALID: code-review.prompt.md (reviews code)
  EXAMPLE_INVALID: review-and-deploy.prompt.md (two workflows)
```

```
RULE_003: Positive instructions
  REQUIRE: State what TO DO
  REJECT_IF: Instructions framed as "don't" or "avoid"
  RATIONALE: LLMs follow positive framing more reliably
  EXAMPLE_VALID: "Write functions under 20 lines"
  EXAMPLE_INVALID: "Don't write long functions"
```

```
RULE_004: Validation gates for complex workflows
  REQUIRE: 🚨 STOP checkpoint before destructive/irreversible actions
  REJECT_IF: Complex multi-step prompt with no checkpoints
  RATIONALE: Prevents runaway execution
  EXAMPLE_VALID:
    🚨 **STOP**: Review plan before implementation.
    [ ] Requirements verified
    [ ] Approach approved
  EXAMPLE_INVALID: (20-step workflow with no pauses)
```

```
RULE_005: Explicit variable usage
  REQUIRE: Document which variables prompt depends on
  REJECT_IF: Prompt uses `${selection}` without handling empty case
  RATIONALE: Undefined/empty variables cause silent failures
  EXAMPLE_VALID:
    ## Input
    ${selection}
    (If no selection, operates on current file)
  EXAMPLE_INVALID:
    Refactor ${selection}
    (Fails silently if nothing selected)
```

```
RULE_006: Context budget awareness
  REQUIRE: Phase large context loads
  REJECT_IF: >3 file links without phases
  RATIONALE: Large context degrades response quality
  EXAMPLE_VALID:
    ## Phase 1: Architecture
    Review [architecture.md]
    
    ## Phase 2: Implementation
    Now review [implementation.md]
  EXAMPLE_INVALID:
    Review [a.md], [b.md], [c.md], [d.md], [e.md] simultaneously
```

```
RULE_007: Description required for discoverability
  REQUIRE: `description` field with clear purpose
  REJECT_IF: Missing or vague description
  RATIONALE: Shows in VS Code picker; enables prompt discovery
  EXAMPLE_VALID: description: Review code for security vulnerabilities
  EXAMPLE_INVALID: description: Does stuff
```

---

## VALIDATION CHECKLIST

```
VALIDATE_PROMPT:
  □ Has YAML frontmatter with `agent` and `description`
  □ Has `# Title` heading
  □ Has body content with clear instruction
  □ Uses only documented `${}` variables
  □ Handles empty `${selection}` gracefully (if used)
  □ File links use relative paths or `${workspaceFolder}`
  □ Complex workflows have 🚨 STOP checkpoints
  □ Instructions are positive ("do X" not "don't Y")
  □ Single purpose (one workflow)
  □ Context budget considered (<3 large files per phase)
```

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| Empty frontmatter | Include `agent` + `description` | Prompt unusable without agent, invisible without description |
| Multi-purpose prompts | Split into separate files | Unpredictable behavior, poor reusability |
| Negative instructions ("don't...") | Positive instructions ("do...") | LLMs follow positive framing better |
| Assume `${selection}` exists | Handle empty selection case | Command Palette invocation has no selection |
| Use `${undocumentedVar}` | Use only documented variables | Undefined vars render literally (silent failure) |
| Use `#file:path` syntax | Use `#filename.ext` | VS Studio syntax, not VS Code |
| Load 5+ large files at once | Phase context loading | Context overload degrades quality |
| Hardcode absolute paths | Use `${workspaceFolder}` prefix | Breaks portability across machines |
| Use prompts as handoff targets | Define agent handoffs in `.agent.md` | Prompts invoke agents, not vice versa |
| Skip validation gates | Add 🚨 STOP checkpoints | Runaway execution on complex workflows |

---

## EXAMPLES

### Minimal Valid Example

```markdown
---
agent: agent
description: Quick code review
---

# Code Review

Review ${selection} for issues and suggest improvements.
```

### Full Example

```markdown
---
agent: agent
model: Claude Sonnet 4
tools: ['read_file', 'grep_search']
description: Comprehensive security-focused code review
name: security-review
argument-hint: Select code to review
---

# Security Code Review

## Instruction

Perform a security-focused review of the selected code.

## Context

Follow [security guidelines](${workspaceFolder}/docs/security.md).

Check for:
- Input validation and sanitization
- Authentication/authorization gaps
- SQL injection, XSS vulnerabilities
- Sensitive data exposure

## Input

${selection}

(If no selection, review the current file)

## Expected Output

Provide:
1. Security risk summary (🔴 High, 🟡 Medium, 🟢 Low)
2. Line-by-line findings with severity
3. Specific fix recommendations

🚨 **STOP**: Review findings with user before suggesting automated fixes.
```

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| `PATTERNS/agent-patterns.md` | Agents that prompts invoke via `agent:` field |
| `PATTERNS/instruction-patterns.md` | Persistent instructions vs one-shot prompts |
| `COMPONENT-MATRIX.md` | When to use prompts vs other components |
| `RULES.md` | Cross-cutting rules applied to prompts |

---

## SOURCES

- [prompt-files.md](../../cookbook/CONFIGURATION/prompt-files.md) — Prompt file format, frontmatter, invocation
- [context-variables.md](../../cookbook/CONTEXT-ENGINEERING/context-variables.md) — Variable syntax, tool references
- [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) — Official specification
- [Prompt Engineering Guide](https://github.com/dair-ai/Prompt-Engineering-Guide) — Four-element pattern source
