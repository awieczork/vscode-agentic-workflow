This reference provides exact syntax for skill artifacts. Load during Step 4 when constructing frontmatter, folder structure, or procedure sections. Each section defines field limits, creation triggers, and syntax patterns that ensure consistent skill output.


<frontmatter_schema>

VS Code supports only `name` and `description` for skill frontmatter. No other fields are recognized.

```yaml
---
name: 'skill-name'              # Required: must match folder, lowercase-with-hyphens
description: '[What it does]. Use when [trigger phrases]. [Key capabilities].'  # Required
---
```

**Field limits:**
- `name` — 1-64 characters, pattern `[a-z0-9]+(-[a-z0-9]+)*`
- `description` — 1-1024 characters, single-line. Structure: `[What it does] + [When to use it] + [Key capabilities]`. Include 2-4 trigger phrases in quotes. Never include "when not to use" guidance.

</frontmatter_schema>


<folder_structure>

```
skill-name/
├── SKILL.md           # Required: entry point
├── scripts/           # Optional: executable code
├── references/        # Optional: JIT-loaded documentation
└── assets/            # Optional: templates, configs, examples
```

**Folder creation triggers:**

**Create `scripts/` when:**
- Code exceeds 20 lines
- Requires specific shell (bash, PowerShell)
- Called 2+ times across steps
- Needs deterministic execution

**Create `references/` when:**
- Documentation exceeds 100 lines
- Content is JIT-loaded (not always needed)
- Decision rules exceed 30 lines of conditional logic
- Patterns exceeding 30 lines benefit from isolation

**Create `assets/` when:**
- Steps use templates or boilerplate
- Config files need to be copied/modified
- Non-markdown resources required (JSON, YAML)
- Examples intended for user modification

**Create folders only when:**
- Content already exists for the folder
- Actual need justifies the structure

</folder_structure>


<procedure_design>

**Use imperative form:**
- "Run tests" not "You should run tests"
- "Check configuration" not "Configuration should be checked"

**Match precision to risk:**

**High freedom (text instructions):**
- 2+ valid approaches exist
- Decisions depend on context
- Non-destructive operations

**Medium freedom (pseudocode):**
- Preferred pattern exists
- Minor variation acceptable
- Configuration affects behavior

**Low freedom (exact commands):**
- Destructive operations (delete, overwrite)
- Sequence-sensitive steps
- Fragile or error-prone operations

Never use general guidance for destructive operations — provide exact commands.

</procedure_design>


<progressive_disclosure_patterns>

Skills use folder structure for context efficiency.

**Pattern 1 — Loading directive:**
```markdown
Load [decision-rules.md](references/decision-rules.md) for:
- Input validation patterns
- Error code mappings
- Edge case handling
```

**Pattern 2 — Conditional loading:**
```markdown
If REST API: Load [rest-patterns.md](references/rest-patterns.md)
If GraphQL: Load [graphql-patterns.md](references/graphql-patterns.md)
```

**Pattern 3 — Asset reference:**
```markdown
Use template from [endpoint-template.md](assets/endpoint-template.md)
Customize for the specific route and method.
```

**Cross-reference style:**
- Loading directive: `Load [file] for:` (imperative, agent reads file)
- Informational link: `See [file](path/file.md)` (optional, navigation)

**Single-hop rule** — Reference files link only to SKILL.md or external URLs. Never reference → reference. Exception: Scripts in `scripts/` may reference files in `assets/` directly.

</progressive_disclosure_patterns>


<tool_reference_syntax>

Reference tools using `#tool:name` syntax when a specific tool is required.

**Examples:**
- `Use #tool:editFiles to update the configuration`
- `Run #tool:runInTerminal with the build command`

When any approach works, describe the action without tool reference (e.g., "Update the configuration file").

**Tool aliases:**
- **`execute`** — Run shell commands
- **`read`** — Read file contents
- **`edit`** — Edit files
- **`search`** — Search files or text
- **`agent`** — Invoke custom agents as subagents
- **`web`** — Fetch URLs and web search
- **`todo`** — Manage task lists

</tool_reference_syntax>


<exclusion_rules>

Skills are agent-agnostic procedures — they define WHAT to do, while agents define WHO does it and with what constraints. Separating procedure from persona enables skill reuse across different agents.

<forbidden_xml_tags>

Skills must NOT contain these agent-specific sections:

- `<identity>` — Skills have no persona
- `<safety>` — Safety rules belong to invoking agent
- `<iron_law>` — Iron laws govern agent behavior
- `<boundaries>` — Scope boundaries define agent role
- `<handoffs>` — Skills complete or fail, no transfers
- `<modes>` — Skills have one execution path
- `<stopping_rules>` — Skills complete when steps finish
- `<context_loading>` — Memory tiers are agent-level
- `<update_triggers>` — Session events are agent-level
- `<red_flags>` — HALT conditions are agent behavior

</forbidden_xml_tags>

<forbidden_language>

**Identity phrases:**
- "You are a..." (skills have no identity)
- "Your role is..." (skills are procedures)
- "As a [role]..." (skills are agent-agnostic)

**Stance descriptors:**
- thorough, cautious, precise, creative, minimal (as behavioral descriptors)
- These govern agent decision-making, not skill execution

**Agent verbs:**
- "I will..." / "I should..." (use imperative form)
- "Consider..." / "Think about..." (give concrete steps)
- "Decide whether..." (specify action or branch)

**Scope language:**
- "In scope" / "Out of scope" (skill scope = steps)
- "Ask First" (permission tiers are agent-level)

</forbidden_language>

<forbidden_references>

**External paths that break self-sufficiency:**
- `knowledge-base/` — Embed required content instead
- `memory-bank/` — Skills are stateless
- `.agent.md` files — Skills are agent-agnostic
- `@agent-name` — Skills do not invoke agents
- `#skill:other-skill` as required dependency — Keep skills atomic

</forbidden_references>

<forbidden_frontmatter>

- `tools:` — Tool permissions belong to agents
- `handoffs:` — Skills do not transfer to agents
- `model:` — Model selection is agent/user decision
- `allowed-tools:` — Not supported in VS Code
- `applyTo:` — Auto-apply patterns define instructions
- `license:` — Not a VS Code-supported field
- `compatibility:` — Not a VS Code-supported field
- `metadata:` — Not a VS Code-supported field

</forbidden_frontmatter>

<recovery_actions>

When exclusion detected:

- **Agent XML tag** — Remove section; move safety-relevant content to error handling
- **Identity language** — Rewrite as procedural description
- **Stance words** — Delete; make steps explicit enough to not need stance
- **External references** — Embed required content in skill's `references/` folder
- **Forbidden frontmatter** — Remove the field

</recovery_actions>

</exclusion_rules>


<size_limits>

**SKILL.md:**
- Target: 150-300 lines
- Use opening prose paragraph, not a heading

**Reference files:**
- Target: 100-300 lines each

**If exceeding limits:** Extract content to `references/` folder.

</size_limits>


<token_budget>

Skills use progressive loading to minimize context consumption.

**Discovery phase (~100 tokens):**
- Agent reads frontmatter only (name + description)
- Determines if skill matches current task
- Low cost enables scanning many skills quickly

**Instruction phase:**
- Agent loads SKILL.md body when skill is invoked
- Contains workflow steps, error handling, quality signals
- Budget constraint keeps skills focused and scannable

**Resource phase (on-demand):**
- Reference files loaded via `Load [file] for:` directives
- Assets loaded when step requires them
- Only consumes tokens when actually needed

</token_budget>


<cross_references>

- [SKILL.md](../SKILL.md) — Parent skill entry point
- [validation-checklist.md](validation-checklist.md) — P1/P2 validation checks
- [example-skeleton.md](../assets/example-skeleton.md) — Minimal template
- [example-api-scaffold.md](../assets/example-api-scaffold.md) — Full example

</cross_references>
