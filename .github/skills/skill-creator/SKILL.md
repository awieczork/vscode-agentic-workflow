---
name: skill-creator
description: Creates SKILL.md files from specifications. Use when user asks to "create a skill", "build a skill", "make a reusable procedure", or "generate skill for [domain]". Produces folder structure, frontmatter, numbered steps, error handling, and validation checks.
---

This skill creates well-structured SKILL.md files that define reusable procedures for AI agents. The governing principle is single-focused capability — each skill solves one specific problem within a standard folder structure. Begin with `<step_1_classify>` to confirm the request is a skill, not another artifact type.

<defaults>

When specification omits details, use these values:

- **Structure** — Single SKILL.md, no subfolders
- **Description length** — Under 1024 characters
- **Steps count** — 3-7 numbered steps
- **Error handling** — 3-5 failure modes with If/Then format
- **Reference file threshold** — Extract content >100 lines
- **Validation checks** — 3-5 verifiable conditions
- **XML structure** — Content with 2+ sections uses XML tags as primary structure (snake_case, max 3 levels nesting)

</defaults>

<workflow>

<step_1_classify>

Confirm spec describes a skill, not another artifact type.

- Reusable procedure any agent invokes? → Skill (continue)
- Needs persona, tools, cross-session behavior? → Agent (stop, use agent-creator)
- File-pattern rules that auto-apply? → Instruction (stop, use instruction-creator)
- One-shot template with placeholders? → Prompt (stop, use prompt-creator)

If unclear, ask: "This sounds like [type] because [reason]. Confirm skill?"

</step_1_classify>

<step_2_name_and_describe>

**Name:**
- Extract from "skill for [name]" or derive from capability
- Format: lowercase-with-hyphens, 1-64 characters
- Must match parent folder name exactly

**Description:**
- Structure: `[What it does]. Use when [trigger phrases]. [Key capabilities].`
- Include 2-4 specific tasks users say in quotes
- Mention file types if relevant (SKILL.md, .agent.md)
- Under 1024 characters, no XML tags

**Examples:**
- `Creates REST API endpoints. Use when user asks to "scaffold routes", "add endpoint", or "create controller". Produces route handlers with validation and TypeScript types.`
- `Manages sprint workflows. Use when user mentions "sprint", "Linear tasks", or asks to "create tickets". Supports bulk operations and status tracking.`

If name unclear, ask: "What should this skill be called?"

</step_2_name_and_describe>

<step_3_assess_complexity>

Determine structure from content signals, not size labels.

**Create `references/` when:**
- A step requires detailed guidance (>20 lines)
- Documentation is JIT-loaded (not needed every run)
- Decision rules or patterns need separation

**Create `assets/` when:**
- Steps use templates, configs, or boilerplate
- Non-markdown resources required

**Create `scripts/` when:**
- Code exceeds 20 lines
- Shell-specific or platform-dependent execution

**Default to single SKILL.md when:**
- All steps are inline-explainable
- No JIT content separation benefits

</step_3_assess_complexity>

<step_4_draft>

Build the skill using these sections. Load [structure-reference.md](references/structure-reference.md) for: frontmatter schema, procedure design patterns, loading directive syntax, exclusion rules.

**Progressive loading design:**
Skills load in three phases to minimize context consumption:
1. **Discovery (~100 tokens)** — Agent reads name + description to match skill to task
2. **Instruction** — Agent loads SKILL.md body when skill invoked
3. **Resource (on-demand)** — Reference files load via `Load [file] for:` directives

Design skill structure so discovery is cheap, instructions are self-contained, and resources load only when needed.

**Required sections (wrapped in XML tags):**
1. YAML frontmatter (`name`, `description` — VS Code supports only these two fields)
2. Opening prose paragraph (2-3 sentences stating purpose and governing principle)
3. `<workflow>` containing `<step_N_verb>` tags (numbered, imperative)
4. `<error_handling>` (If X: Y format)

**Optional sections:**
- `<validation>` (if success is verifiable)
- `<loading_directives>` (if using references/)
- `<notes>` (for caveats, prerequisites)

</step_4_draft>

<step_5_validate>

Self-check before delivery. Load [validation-checklist.md](references/validation-checklist.md) for full checks.

**Quick 5-check (P1 blockers):**
1. [ ] `name` + `description` in frontmatter
2. [ ] `name` matches parent folder exactly
3. [ ] Description follows: [What it does] + [When to use it] + [Key capabilities], no negative triggers
4. [ ] No unsupported frontmatter fields — VS Code supports only `name` and `description`
5. [ ] No hardcoded secrets or absolute paths

**Exclusion check (skills must NOT contain):**
- XML tags: `<identity>`, `<safety>`, `<boundaries>`, `<iron_law>`, `<handoffs>`
- Phrases: "You are a...", stance words (thorough, cautious, creative)
- References: knowledge-base/, memory-bank/, .agent.md files
- Frontmatter: `tools:`, `handoffs:`, `model:`, `applyTo:`

**Structure check (P2):**
- [ ] No markdown headings — XML tags are exclusive structure
- [ ] Content with 2+ logical sections uses XML tags
- [ ] Every `Load [file]` directive points to existing file

</step_5_validate>

<step_6_integrate>

Connect skill to ecosystem.

**Folder placement:** `.github/skills/[name]/`

**Cross-references:** Use markdown links `[file.md](references/file.md)` and loading directives `Load [file] for:`

**Tool references:** Use `#tool:name` when specific tool required. Describe action when any approach works.

</step_6_integrate>

</workflow>

<error_handling>

If spec is ambiguous about artifact type: Ask "This sounds like [type] because [reason]. Confirm skill?"

If name format is invalid: Suggest corrected format using lowercase-with-hyphens

If description exceeds 1024 characters: Trim to essential content or ask user to shorten

If referenced file does not exist: Create the file or update reference path

If agent contamination detected (identity, safety, boundaries tags): Remove offending content and warn user

</error_handling>

<loading_directives>

Use explicit loading directives in steps to trigger JIT context loading.

**Syntax patterns:**
- `Load [file] for:` — Imperative load at this step
- `Use template from [file]` — Load asset for output
- `See [file](path)` — Cross-reference only, no automatic load

</loading_directives>

<when_to_ask>

- Capability unclear → "What does this skill do?"
- Multiple domains → "Should this be one skill or separate skills?"
- Triggers ambiguous → "When should agents invoke this?"

</when_to_ask>

<quality_signals>

**Minimum quality:**
- Description follows [What it does] + [When to use it] + [Key capabilities]
- Description includes 2-4 quoted user phrases
- Steps are numbered and imperative
- Error handling covers 3-5 failure modes
- Single focused capability

**High quality (additional):**
- Progressive disclosure for content exceeding 50 lines
- Loading directives point to existing files
- Validation section with 3-5 verifiable checks
- No agent contamination (identity, safety, boundaries)

</quality_signals>

<references>

- [structure-reference.md](references/structure-reference.md) — Frontmatter, patterns, exclusions
- [validation-checklist.md](references/validation-checklist.md) — P1/P2 checks

</references>

<assets>

- [example-skeleton.md](assets/example-skeleton.md) — Annotated minimal template
- [example-api-scaffold.md](assets/example-api-scaffold.md) — Full working skill

</assets>
