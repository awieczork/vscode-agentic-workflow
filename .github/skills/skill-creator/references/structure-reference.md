# Structure Reference

Exact syntax for skill artifacts. Use during Step 4: Draft.

---

## Frontmatter Schema

```yaml
---
# REQUIRED
name: 'skill-name'              # Must match folder, lowercase-with-hyphens
description: '[VERB] [WHAT] when [TRIGGER]'

# OPTIONAL
license: 'MIT'                  # License identifier
compatibility: 'Requires X'     # Environment requirements
metadata:
  author: 'org-name'
  version: '1.0.0'
  tags: ['category', 'domain']
---
```

**Field limits:**
- `name`: 1-64 characters, pattern `[a-z0-9]+(-[a-z0-9]+)*`
- `description`: 1-1024 characters
- `compatibility`: 1-500 characters

---

## Folder Structure

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
- Called multiple times across steps
- Needs deterministic execution

**Create `references/` when:**
- Documentation exceeds 100 lines
- Content is JIT-loaded (not always needed)
- Decision rules need separation from main flow
- Detailed patterns benefit from isolation

**Create `assets/` when:**
- Steps use templates or boilerplate
- Config files need to be copied/modified
- Non-markdown resources required (JSON, YAML)
- Examples intended for user modification

**Do NOT create folders:**
- For potential future content (no empty folders)
- To "look complete" (structure matches need)

---

## Procedure Design

**Use imperative form:**
- "Run tests" not "You should run tests"
- "Check configuration" not "Configuration should be checked"

**Match precision to risk:**

**High freedom (text instructions):**
- Multiple approaches valid
- Decisions depend on context
- Non-destructive operations

**Medium freedom (pseudocode):**
- Preferred pattern exists
- Some variation acceptable
- Configuration affects behavior

**Low freedom (exact commands):**
- Destructive operations (delete, overwrite)
- Sequence-sensitive steps
- Fragile or error-prone operations

**Rule:** Destructive operations require exact commands, not general guidance.

---

## Progressive Disclosure Patterns

Skills use folder structure for context efficiency.

**Pattern 1: Loading directive**
```markdown
### Step 3: Apply Rules
Load `references/decision-rules.md` for:
- Input validation patterns
- Error code mappings
- Edge case handling
```

**Pattern 2: Conditional loading**
```markdown
### Step 4: Handle Variants

If REST API: Load `references/rest-patterns.md`
If GraphQL: Load `references/graphql-patterns.md`
```

**Pattern 3: Asset reference**
```markdown
### Step 5: Generate Output
Use template from `assets/endpoint-template.md`
Customize for the specific route and method.
```

**Cross-reference style:**
- Loading directive: `Load [file] for:` (imperative, agent reads file)
- Informational link: `See [file](path/file.md)` (optional, navigation)

**Single-hop rule:** Reference files link only to SKILL.md or external URLs. Never reference → reference.

---

## Tool Reference Syntax

Skills can reference tools using `#tool:<tool-name>` syntax.

**When to use explicit references:**
- Specific tool is REQUIRED for the step
- Tool parameters need documentation
- Disambiguation between similar tools

**When to use implicit description:**
- Any of several tools could work
- Agent should choose approach
- Flexibility is preferred

**Examples:**
- Explicit: `Use #tool:editFiles to update the configuration`
- Explicit: `Run #tool:runInTerminal with the build command`
- Implicit: `Update the configuration file`
- Implicit: `Execute the build command`

---

## Exclusion Rules

Skills are agent-agnostic procedures. These patterns must NOT appear.

### Forbidden XML Tags

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

### Forbidden Language

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

### Forbidden References

**External paths that break self-sufficiency:**
- `knowledge-base/` — Embed required content instead
- `memory-bank/` — Skills are stateless
- `.agent.md` files — Skills are agent-agnostic
- `@agent-name` — Skills don't invoke agents
- `#skill:other-skill` as required dependency — Keep skills atomic

### Forbidden Frontmatter Fields

- `tools:` — Tool permissions belong to agents
- `handoffs:` — Skills don't transfer to agents
- `model:` — Model selection is agent/user decision
- `allowed-tools:` — Not supported in VS Code
- `applyTo:` — Auto-apply patterns define instructions

### Recovery Actions

When exclusion detected:

- **Agent XML tag** — Remove section; move safety-relevant content to Error Handling
- **Identity language** — Rewrite as procedural description
- **Stance words** — Delete; make steps explicit enough to not need stance
- **External references** — Embed required content in skill's `references/` folder
- **Forbidden frontmatter** — Remove the field

---

## Size Limits

**SKILL.md:**
- Target: 50-150 lines
- Maximum: 500 lines

**Reference files:**
- Target: 100-300 lines each
- Maximum: 500 lines each

**If exceeding limits:** Extract content to `references/` folder.

---

## Cross-References

- [validation-checklist.md](validation-checklist.md) — P1/P2 validation checks
- [example-skeleton.md](../assets/example-skeleton.md) — Minimal template
- [example-api-scaffold.md](../assets/example-api-scaffold.md) — Full example
