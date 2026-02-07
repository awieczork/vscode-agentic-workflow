---
name: prompt-creator
description: Creates .prompt.md files from specifications. Use when asked to create a prompt, build a prompt, or generate prompt for a task. Produces frontmatter, variables, and structured template body.
---

This skill produces `.prompt.md` files — one-shot templates with variable placeholders for runtime customization. Prompts differ from instructions (which auto-apply) and agents (which persist across sessions) by being stateless and explicitly invoked via `/command`. Start at `<step_1_classify>` to confirm the spec describes a prompt.


<workflow>

<step_1_classify>

Confirm spec describes a prompt, not another artifact type.

**Decision gate (test in order, stop at first YES):**
- Should rules auto-apply to files matching a pattern? → Instruction (stop, use instruction-creator)
- Does it need bundled scripts, references, or assets? → Skill (stop, use skill-creator)
- Does it need persona + cross-session persistence + handoffs? → Agent (stop, use agent-creator)
- Is it a one-shot template with variable placeholders? → **Prompt** (continue)

**Key discriminators:**
- Prompts use `${input:name}` for runtime user input — instructions and agents cannot
- Prompts are stateless — each invocation starts fresh, no memory across turns
- Prompts are invoked via `/command` — agents use `@agent`
- Prompts have no identity — they delegate execution to agents

If unclear, ask: "This sounds like [type] because [reason]. Confirm prompt?"

</step_1_classify>


<step_2_name_and_describe>

**Name:**
- Extract from: "prompt for [name]" or derive from task
- Format: lowercase-with-hyphens — matches VS Code prompt discovery conventions
- Becomes filename: `{name}.prompt.md`

**Description:**
- Formula: `[VERB] [WHAT] [CONTEXT]`
- Length: 50-150 characters, single-line — fits menu display without truncation
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

**Standard template when:**
- Prompt has 2+ logical sections (context, task, format, constraints)
- Specific output format required
- Multiple variables needed

**Full template when:**
- Tools whitelist required for restricted access
- Custom agent delegation needed
- Constraints section adds value

XML tags are mandatory for prompts with 2+ sections — structure improves parseability and allows section-specific instructions.

</step_3_assess_complexity>


<step_4_draft>

Build the prompt using appropriate template scope. Load [frontmatter-reference.md](references/frontmatter-reference.md) for: frontmatter fields, tool aliases, agent modes, variable syntax.

**Body structure:**

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

**Minimal:**
```markdown
---
description: "[VERB] [WHAT]"
---

[Task instructions with variables]
```

**Standard** — adds XML sections for structure.

**Full** — adds `agent`, `tools`, `argument-hint`, and all XML sections.

**Rule writing guidance:**
- Place `<task>` before `<context>` if task is complex (critical instruction first)
- Use `${name}` syntax, not `{name}` — braces alone do not trigger substitution
- Reference instruction files via markdown links instead of copying content
- If body >300 tokens, verify reusable patterns reference instruction files

See [example-skeleton.md](assets/example-skeleton.md) for annotated templates.

</step_4_draft>


<step_5_validate>

Self-check before delivery.

**P1 checks (blocking — prompt errors if violated):**
- [ ] File location is `.github/prompts/`
- [ ] File extension is `.prompt.md`
- [ ] Frontmatter YAML is valid (if present)
- [ ] No placeholder text remaining (`{...}`, `TODO`, `[PLACEHOLDER]`)
- [ ] No secrets or credentials in content

**P2 checks (required — effectiveness compromised if violated):**
- [ ] `description` field is present
- [ ] `description` is 50-150 characters, single-line, starts with verb
- [ ] Task is single-purpose (one clear goal)
- [ ] Variables use correct syntax (`${name}` not `{name}`)
- [ ] No hardcoded workspace-specific paths
- [ ] Body uses XML tags for prompts with 2+ logical sections
- [ ] `tools` array ≤4 items (warn if >4, review if >6)

**Quick 5-check:**
1. File in `.github/prompts/` with `.prompt.md` extension?
2. `description` present and starts with verb?
3. Single clear task (not multiple goals)?
4. Variables use `${name}` syntax?
5. No placeholder text remaining?

</step_5_validate>


<step_6_integrate>

Place prompt in correct location.

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


<when_to_ask>

- Name is ambiguous → "What should this prompt be called?"
- Artifact type unclear → "Should this auto-apply to files (instruction) or require explicit `/command` (prompt)?"
- Mode unclear → "Should this modify files (edit) or just analyze (ask)?"
- Tools needed → "Does this need access to specific tools? Which ones?"
- Complexity ceiling → "This has >3 tools and agent mode. Should this be an agent instead of a prompt?"

</when_to_ask>


<quality_signals>

**Good prompt:**
- `description` present, 50-150 chars, verb-first
- Single clear task
- Correct variable syntax
- Appropriate agent selected
- XML body structure for 2+ sections

**Excellent prompt:**
- Tools whitelisted to minimum necessary
- Variables used instead of hardcoded values
- Under 500 tokens total
- `<task>` section placed before `<context>` (critical instruction first)
- References instruction files via markdown links instead of copying content
- If task produces structured output, includes `<format>` section

</quality_signals>


<prompt_anti_patterns>

- **Omitting description** — Prompt won't appear in `/` menu
- **Hardcoding file paths** — Breaks portability; use `${file}`, `${workspaceFolder}`
- **One prompt doing many things** — Reduces reliability; split into focused prompts
- **Using `{name}` instead of `${name}`** — Variables won't resolve
- **Specifying tools without agent field** — Mode may not auto-switch; set `agent: agent`
- **Using invalid tool names** — Only use valid tools from [frontmatter-reference.md](references/frontmatter-reference.md)
- **Using server name alone in tools** — Ambiguous; use `server/*` or `server/tool`

</prompt_anti_patterns>


<loading_directives>

**HOT (always load at skill start):**
- This SKILL.md
- Spec or requirements from user

**WARM (load when drafting):**
- [frontmatter-reference.md](references/frontmatter-reference.md) — Frontmatter fields, tool aliases, agent modes, variable syntax
- [example-skeleton.md](assets/example-skeleton.md) — Annotated templates

**JIT (load on demand):**
- [example-code-review.md](assets/example-code-review.md) — Full working example

</loading_directives>


<references>

- [frontmatter-reference.md](references/frontmatter-reference.md) — Frontmatter fields, tools, agents, variables
- [example-skeleton.md](assets/example-skeleton.md) — Annotated template with minimal variant
- [example-code-review.md](assets/example-code-review.md) — Full working prompt

</references>
