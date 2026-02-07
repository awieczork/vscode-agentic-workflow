Self-check before delivery. The governing principle is verifiability — every check must have a clear pass/fail condition without judgment calls. Begin with `<quick_validation>` for blocking issues, then proceed through P1/P2/P3 sections.


<quick_validation>

Skill is INVALID if any fails. Fix before delivery.

- [ ] `name` + `description` in frontmatter
- [ ] `name` matches parent folder exactly
- [ ] Description follows: [What it does] + [When to use it] + [Key capabilities], no negative triggers
- [ ] No unsupported frontmatter fields — VS Code supports only `name` and `description`
- [ ] No hardcoded secrets or absolute paths

</quick_validation>


<p1_blocking>

Must fix. Skill fails validation.

<naming>

- [ ] `name` uses only lowercase letters, numbers, hyphens (`[a-z0-9-]+`)
- [ ] `name` has no leading, trailing, or consecutive hyphens
- [ ] `name` is 1-64 characters
- [ ] `name` exactly matches parent folder name (enables folder-based discovery)
- [ ] Folder location is `.github/skills/[name]/SKILL.md`

</naming>

<frontmatter>

- [ ] `name` field present
- [ ] `description` field present
- [ ] Valid YAML syntax (proper quotes, indentation)
- [ ] No forbidden fields: `tools`, `handoffs`, `model`, `applyTo`, `allowed-tools`, `license`, `compatibility`, `metadata`

</frontmatter>

<content>

- [ ] Steps section present with numbered items
- [ ] Error handling section present
- [ ] No hardcoded secrets, API keys, or credentials
- [ ] No hardcoded absolute paths
- [ ] No markdown headings — XML tags are exclusive structure

</content>

</p1_blocking>


<p1_recovery>

When a P1 check fails, apply the corresponding recovery:

- **`name` missing in frontmatter** → Add `name: 'skill-name'` matching parent folder
- **`description` missing in frontmatter** → Add description following `[What] + [When] + [Capabilities]` pattern
- **`name` format invalid (uppercase, spaces)** → Convert to lowercase-with-hyphens: `My Skill` → `my-skill`
- **`name` does not match folder** → Rename folder to match `name` field, or update `name` to match folder
- **Invalid YAML syntax** → Run through YAML validator; fix quotes and indentation
- **Forbidden frontmatter field present** → Remove the field (`tools`, `handoffs`, `model`, `applyTo`, `allowed-tools`, `license`, `compatibility`, `metadata`)
- **Steps section missing** → Add `<workflow>` with numbered `<step_N_verb>` tags
- **Error handling missing** → Add `<error_handling>` section with 3-5 If/Then failure modes
- **Hardcoded secrets detected** → Replace with placeholder `[API_KEY]` or environment variable reference
- **Hardcoded absolute paths** → Convert to relative paths or `[USER_PATH]` placeholder
- **Markdown headings detected** → Replace with XML tags; tags are self-documenting

</p1_recovery>


<p2_required>

Fix before delivery for quality.

<description_quality>

- [ ] Description is 1-1024 characters, single-line
- [ ] Description follows: `[What it does] + [When to use it] + [Key capabilities]`
- [ ] Includes 2-4 trigger phrases users say in quotes
- [ ] Mentions file types if relevant
- [ ] Contains no negative triggers ("Do NOT use for...")

</description_quality>

<agent_agnostic_structure>

- [ ] No `<identity>` section
- [ ] No `<safety>` section
- [ ] No `<boundaries>` section
- [ ] No `<iron_law>` or `<iron_laws>` sections
- [ ] No `<handoffs>` section
- [ ] No `<modes>` section
- [ ] No `<stopping_rules>` section
- [ ] No `<context_loading>` section
- [ ] No `<update_triggers>` section
- [ ] No `<red_flags>` section

</agent_agnostic_structure>

<no_persona_language>

- [ ] No "You are a..." statements
- [ ] No "Your role is..." statements
- [ ] No stance words as behavioral descriptors (thorough, cautious, creative, precise, minimal)
- [ ] No first-person intent ("I will...", "I should...")

</no_persona_language>

<self_sufficiency>

- [ ] No references to `knowledge-base/` folder
- [ ] No references to `memory-bank/` folder
- [ ] No references to `.agent.md` files
- [ ] No `@agent-name` invocations
- [ ] No required `#skill:other-skill` dependencies

</self_sufficiency>

<structure_integrity>

- [ ] Single focused capability (not multiple combined)
- [ ] Reference files are single-hop (no reference → reference nesting)
- [ ] Every `Load [file]` directive points to existing file
- [ ] Every file in `references/` has at least one reference in SKILL.md
- [ ] No orphaned files in `assets/` (all referenced)
- [ ] No empty folders

</structure_integrity>

<procedure_quality>

- [ ] Steps use imperative form ("Run X" not "You should run X")
- [ ] Destructive operations have exact commands (not general guidance)
- [ ] Non-idempotent operations flagged with warnings
- [ ] Error handling covers 3-5 failure modes

</procedure_quality>

</p2_required>


<p3_optional>

Enhancements beyond minimum requirements.

- [ ] Validation section with verifiable checks
- [ ] Content over 100 lines extracted to `references/`
- [ ] Examples demonstrate expected usage
- [ ] Notes section for caveats or prerequisites

</p3_optional>


<common_mistakes>

**Description too vague:**
- Wrong: "Helps with API tasks"
- Correct: "Creates REST API endpoints. Use when user asks to 'scaffold routes' or 'add endpoint'. Produces route handlers with validation."

**Missing trigger clause:**
- Wrong: "Generate documentation"
- Correct: "Generates API documentation from source code. Use when user asks to 'extract JSDoc' or 'document functions'. Outputs Markdown with parameter descriptions."

**Agent contamination:**
- Wrong: "You are a thorough documentation expert..."
- Correct: Remove identity; write imperative steps

**Persona in error handling:**
- Wrong: "If error occurs, I will retry..."
- Correct: "If error occurs: Retry once, then abort with message"

**Knowledge-base reference:**
- Wrong: "See knowledge-base/artifacts/skill-patterns.md"
- Correct: Embed required patterns in skill's `references/` folder

**Multiple capabilities:**
- Wrong: Skill that creates AND validates AND deploys
- Correct: Split into separate skills

**Empty structure:**
- Wrong: Creating `references/` folder "just in case"
- Correct: Only create folders when content exists

</common_mistakes>


<validation_by_tools>

**If skill references `#tool:editFiles`:**
- Verify edit operations have specific file paths
- Verify no mass file operations without listing files

**If skill references `#tool:runInTerminal`:**
- Verify destructive commands have exact syntax
- Verify no commands with unverified wildcards

**If skill creates files:**
- Verify output paths are relative or use variables
- Verify no hardcoded user directories

</validation_by_tools>


<cross_references>

- [SKILL.md](../SKILL.md) — Parent skill entry point
- [structure-reference.md](structure-reference.md) — Frontmatter, patterns, exclusions
- [example-skeleton.md](../assets/example-skeleton.md) — Minimal template
- [example-api-scaffold.md](../assets/example-api-scaffold.md) — Full example

</cross_references>
