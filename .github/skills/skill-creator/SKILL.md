---
name: skill-creator
description: Creates SKILL.md files from specifications. Use when user asks to "create a skill", "build a skill", "make a reusable procedure", or "generate skill for [domain]". Produces folder structure, frontmatter, numbered steps, error handling, and validation checks.
---

# Skill Creator

Create valid, high-quality `.github/skills/{name}/SKILL.md` files from specifications.

<defaults>

When specification omits details, use these values:

- **Structure:** Single SKILL.md, no subfolders
- **Description length:** under 1024 characters
- **Steps count:** 3-7 numbered steps
- **Error handling:** 3-5 failure modes with If/Then format
- **Reference file threshold:** Extract content >100 lines
- **Validation checks:** 3-5 verifiable conditions
- **XML structure:** Content with 2+ sections uses XML tags as primary structure per `<structure_hierarchy>` in copilot-instructions.md

</defaults>

<workflow>

<step_1_classify>

Confirm spec describes a SKILL, not another artifact type.

**Decision gate:**
- Reusable procedure any agent invokes? → Skill ✓
- Needs persona + tools + cross-session behavior? → Agent (stop, wrong skill)
- File-pattern rules that auto-apply? → Instruction (stop, wrong skill)
- One-shot template with placeholders? → Prompt (stop, wrong skill)

If unclear, ask user: "This sounds like [type] because [reason]. Confirm skill?"

</step_1_classify>

<step_2_name_and_describe>

**Name:**
- Extract from: "skill for [name]" or derive from capability
- Format: lowercase-with-hyphens, 1-64 characters
- Rule: Must match parent folder name exactly

**Description:**
- Structure: `[What it does]. Use when [trigger phrases]. [Key capabilities].`
- Include 2-4 specific tasks users say in quotes
- Mention file types if relevant (SKILL.md, .agent.md)
- Under 1024 characters, no XML tags

**Do NOT include:** Negative triggers ("Do NOT use for...") or "when not to use" guidance.

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

Build the skill using these sections. Load `references/structure-reference.md` for:
- Frontmatter schema
- Procedure design patterns
- "Load X when Y" syntax
- Exclusion rules (what skills must NOT contain)

**Required sections (wrapped in XML tags):**
1. YAML Frontmatter (`name`, `description`)
2. H1 Title
3. Overview (1-2 sentences)
4. `<workflow>` containing `<step_N_verb>` tags (numbered, imperative)
5. Error Handling in `<error_handling>` tag (If X: Y format)

**Optional sections:**
- Reference Files (if using `references/`)
- Validation (if success is verifiable)
- Notes (for caveats, prerequisites)

</step_4_draft>

<step_5_validate>

Self-check before delivery. Load `references/validation-checklist.md` for full checks.

**Quick 5-check (P1 blockers):**
1. [ ] `name` + `description` in frontmatter
2. [ ] `name` matches parent folder exactly
3. [ ] Description follows: [What it does] + [When to use it] + [Key capabilities], no negative triggers
4. [ ] SKILL.md ≤500 lines
5. [ ] No hardcoded secrets or absolute paths

**Exclusion check (skills must NOT contain):**
- XML tags: `<identity>`, `<safety>`, `<boundaries>`, `<iron_law>`, `<handoffs>`
- Phrases: "You are a...", stance words (thorough, cautious, creative)
- References: knowledge-base/, memory-bank/, .agent.md files
- Frontmatter: `tools:`, `handoffs:`, `model:`, `applyTo:`

### XML Structure (P2)
- [ ] Content with 2+ logical sections uses XML tags as primary structure
- [ ] Markdown headings (`##`) used inside XML tags for human readability

</step_5_validate>

<step_6_integrate>

Connect skill to ecosystem.

**Folder placement:**
- Project-specific: `.github/skills/[name]/`
- Personal (all projects): `~/.copilot/skills/[name]/`

**Cross-references:**
- Use markdown links: `[file.md](references/file.md)`
- Use loading directives: `Load [file] for:`

**Tool references:**
- Explicit need: `Use #tool:editFiles to update config`
- Implicit (agent chooses): `Update the configuration file`

</step_6_integrate>

</workflow>

---

## Loading Directives

Use explicit loading directives in steps to trigger JIT context loading.

**Syntax patterns:**
- `Load [file] for:` — Imperative load at this step
- `Use template from [file]` — Load asset for output
- `See [file](path)` — Cross-reference only, no automatic load

---

## When to Ask User

- Capability unclear → "What does this skill do?"
- Multiple domains → "Should this be one skill or separate skills?"
- Triggers ambiguous → "When should agents invoke this?"

## Quality Signals

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

---

## References

- [structure-reference.md](references/structure-reference.md) — Frontmatter, patterns, exclusions
- [validation-checklist.md](references/validation-checklist.md) — P1/P2 checks

## Assets

- [example-skeleton.md](assets/example-skeleton.md) — Annotated minimal template
- [example-api-scaffold.md](assets/example-api-scaffold.md) — Full working skill
