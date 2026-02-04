---
name: prompt-creator
description: Creates .prompt.md files from specifications. Use when asked to create a prompt, build a prompt, or generate prompt for a task. Produces frontmatter, variables, and structured template body.
---

# Prompt Creator

Create valid, high-quality `.prompt.md` files from specifications.

<workflow>

<step_1_classify>

Confirm spec describes a PROMPT, not another artifact type.

**Decision gate (test in order, stop at first YES):**

- Should rules auto-apply to files matching a pattern? → **Instruction** (stop, wrong skill)
- Does it need bundled scripts, references, or assets? → **Skill** (stop, wrong skill)
- Does it need persona + cross-session persistence + handoffs? → **Agent** (stop, wrong skill)
- Is it a one-shot template with variable placeholders? → **Prompt** ✓

**Key discriminators:**

- Prompts use `${input:name}` for runtime user input — instructions and agents cannot
- Prompts are stateless — each invocation starts fresh, no memory across turns
- Prompts are invoked via `/command` — agents use `@agent`
- Prompts have no identity — they delegate execution to agents

If unclear, ask user: "This sounds like [type] because [reason]. Confirm prompt?"

</step_1_classify>

<step_2_name_and_describe>

**Name:**
- Extract from: "prompt for [name]" or derive from task
- Format: lowercase-with-hyphens, 3-50 characters
- Rule: Becomes filename (`{name}.prompt.md`)

**Description:**
- Formula: `[VERB] [WHAT] [CONTEXT]`
- Length: 50-150 characters, single-line
- Must start with imperative verb (Generate, Create, Analyze, Review)
- Example: `"Generate a commit message from staged changes"`

If name unclear, ask: "What should this prompt be called?"

</step_2_name_and_describe>

<step_3_assess_complexity>

Determine template scope from task signals.

**Minimal template when:**
- Single clear task, no tool requirements
- No special output format needed
- Basic context (file or selection) is sufficient
- Only 1 logical section (task instruction alone)

**Standard template when:**
- Prompt has 2+ logical sections (context, task, format, constraints)
- Specific output format required
- Multiple variables needed

**Note:** XML tags are mandatory for prompts with 2+ sections per `<structure_hierarchy>` in copilot-instructions.md.

**Full template when:**
- Tools whitelist required for restricted access
- Custom agent delegation needed
- Constraints section adds value

</step_3_assess_complexity>

<step_4_draft>

Build the prompt using appropriate template scope.

**Frontmatter Schema:**

All fields optional. Include only what adds value.

- `description` — Short description for `/` menu (50-150 chars, single-line, verb-first) — **Required for discoverability**
- `name` — Display name (3-50 chars, lowercase-hyphens) — Default: filename
- `argument-hint` — Placeholder text in chat input (10-100 chars)
- `agent` — Execution mode (see Agent Field below)
- `model` — Language model override
- `tools` — Tool whitelist array (see Tools Syntax below)

**Tools Syntax:**

```yaml
tools: ['read', 'edit', 'search', 'execute']

```

**Tool aliases:**
- `read` — readFile, listDirectory
- `edit` — editFiles, createFile
- `search` — codebase, textSearch, fileSearch
- `execute` — runInTerminal
- `agent` — runSubagent
- `web` — fetch, WebSearch
- `todo` — manage_todo_list

**MCP tools:** Use `server/*` or `server/tool` syntax for MCP server tools.

**Priority:** Prompt tools override (not merge with) custom agent tools.

**Warning:** Unavailable tools are silently ignored — test prompt to verify tool access.

**Variable Syntax:**

Workspace variables:
- `${workspaceFolder}` — Full path to workspace root
- `${workspaceFolderBasename}` — Workspace folder name only

File variables:
- `${file}` — Full path to current file
- `${fileBasename}` — Filename with extension
- `${fileDirname}` — Directory containing file
- `${fileBasenameNoExtension}` — Filename without extension

Selection variables:
- `${selection}` — Currently selected text
- `${selectedText}` — Alias for `${selection}`

User input variables:
- `${input:name}` — Prompt user for input at runtime
- `${input:name:placeholder}` — Input with placeholder hint

**Critical:** Use `${name}` syntax, not `{name}`. Braces alone do not trigger substitution.

**Body Structure:**

Use XML tags for structured prompts:

```markdown
<context>
Background information with variables.
Working in ${workspaceFolder} with ${fileBasename}.
</context>

<task>
Clear imperative instruction. Verb-first, single goal.
</task>

<format>
Expected output structure.
</format>

<constraints>
- Constraint 1
- Constraint 2
</constraints>
```

**Drafting by template scope:**

Minimal:
```markdown
---
description: "[VERB] [WHAT]"
---

# [Title]

[Task instructions with variables]
```

Standard — adds XML sections for structure.

Full — adds `agent`, `tools`, `argument-hint`, and all XML sections.

See `assets/example-skeleton.md` for annotated templates.

</step_4_draft>

<step_5_validate>

Self-check before delivery.

**P1 Checks (Blocking — prompt fails if violated):**

- [ ] File location is `.github/prompts/`
- [ ] File extension is `.prompt.md`
- [ ] Frontmatter YAML is valid (if present)
- [ ] No placeholder text remaining (`{...}`, `TODO`, `[PLACEHOLDER]`)
- [ ] No secrets or credentials in content

**P2 Checks (Required — effectiveness compromised if violated):**

- [ ] `description` field is present
- [ ] `description` is 50-150 characters, single-line, starts with verb
- [ ] Task is single-purpose (one clear goal)
- [ ] Variables use correct syntax (`${name}` not `{name}`)
- [ ] No hardcoded workspace-specific paths
- [ ] Body uses XML tags (`<context>`, `<task>`, `<format>`, `<constraints>`) for prompts with 2+ logical sections

**Quick 5-check before commit:**

1. File in `.github/prompts/` with `.prompt.md` extension?
2. `description` present and starts with verb?
3. Single clear task (not multiple goals)?
4. Variables use `${name}` syntax?
5. No placeholder text remaining?

</step_5_validate>

<step_6_integrate>

Place prompt in ecosystem.

**File location:**
- Workspace scope: `.github/prompts/{name}.prompt.md`
- User profile scope: VS Code profile folder

**Invocation:**
- User runs `/prompt-name` in chat
- Variables resolve at invocation time
- Execution delegates to specified agent mode

**Ecosystem connections:**
- Instructions auto-apply when file patterns match — prompt inherits these rules
- Custom agent delegation via `agent: [name]` runs in that agent's context
- Prompts cannot invoke skills directly — delegate to agent if skill access needed

</step_6_integrate>

</workflow>

---

## When to Ask User

- Name is ambiguous → "What should this prompt be called?"
- Artifact type unclear → "Should this auto-apply to files (instruction) or require explicit `/command` (prompt)?"
- Mode unclear → "Should this modify files (edit) or just analyze (ask)?"
- Tools needed → "Does this need access to specific tools? Which ones?"
- Complexity ceiling → "This has >3 tools and agent mode. Should this be an agent instead of a prompt?"

## Quality Signals

**Good prompt:**
- `description` present, 50-150 chars, verb-first
- Single clear task
- Correct variable syntax
- Appropriate agent mode selected
- XML body structure (`<context>`, `<task>`, `<format>`, `<constraints>`) for 2+ sections

**Excellent prompt:**
- Tools whitelisted to minimum necessary
- Variables used instead of hardcoded values
- Under 500 tokens total
- `<task>` section placed before `<context>` (critical instruction first)

---

## Anti-Patterns

- **Omitting description** — Prompt won't appear in `/` menu
- **Hardcoding file paths** — Breaks portability; use `${file}`, `${workspaceFolder}`
- **One prompt doing many things** — Reduces reliability; split into focused prompts
- **Using `{name}` instead of `${name}`** — Variables won't resolve
- **Specifying tools without agent field** — Mode may not auto-switch; set `agent: agent`
- **Using invalid tool names** — Only use valid tools: `read`, `edit`, `search`, `web`, `execute`, `todo`, `agent`, or MCP syntax
- **Using server name alone in tools** — Ambiguous; use `server/*` or `server/tool`

---

## Assets

- [example-skeleton.md](assets/example-skeleton.md) — Annotated template with minimal variant
- [example-code-review.md](assets/example-code-review.md) — Full working prompt demonstrating tools and agent modes
