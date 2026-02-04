# Validation Checklist

Self-check before delivery. Use during Step 5: Validate.

---

<quick_validation>

## Quick Validation (5 Essential Checks)

Skill is INVALID if any fails. Fix before delivery.

- [ ] `name` + `description` in frontmatter
- [ ] `name` matches parent folder exactly
- [ ] Description follows: [What it does] + [When to use it] + [Key capabilities], no negative triggers
- [ ] SKILL.md ≤500 lines
- [ ] No hardcoded secrets or absolute paths

</quick_validation>

---

<p1_blocking>

## P1 — Blocking

Must fix. Skill fails validation.

### Naming

- [ ] `name` uses only lowercase letters, numbers, hyphens (`[a-z0-9-]+`)
- [ ] `name` has no leading, trailing, or consecutive hyphens
- [ ] `name` is 1-64 characters
- [ ] `name` exactly matches parent folder name
- [ ] Folder location is `.github/skills/[name]/SKILL.md`

### Frontmatter

- [ ] `name` field present
- [ ] `description` field present
- [ ] Valid YAML syntax (proper quotes, indentation)
- [ ] No forbidden fields: `tools`, `handoffs`, `model`, `applyTo`, `allowed-tools`

### Content

- [ ] Steps section present with numbered items
- [ ] Error Handling section present
- [ ] No hardcoded secrets, API keys, or credentials
- [ ] No hardcoded absolute paths
- [ ] SKILL.md under 500 lines

</p1_blocking>

---

<p2_required>

## P2 — Required

Fix before delivery for quality.

### Description Quality

- [ ] Description is 1-1024 characters, single-line
- [ ] Description follows: `[What it does] + [When to use it] + [Key capabilities]`
- [ ] Includes 2-4 trigger phrases users say in quotes
- [ ] Mentions file types if relevant
- [ ] Contains NO negative triggers ("Do NOT use for...")

### No Agent Contamination

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

### No Persona Language

- [ ] No "You are a..." statements
- [ ] No "Your role is..." statements
- [ ] No stance words as behavioral descriptors (thorough, cautious, creative, precise, minimal)
- [ ] No first-person intent ("I will...", "I should...")

### Self-Sufficiency

- [ ] No references to `knowledge-base/` folder
- [ ] No references to `memory-bank/` folder
- [ ] No references to `.agent.md` files
- [ ] No `@agent-name` invocations
- [ ] No required `#skill:other-skill` dependencies

### Structure Integrity

- [ ] Single focused capability (not multiple combined)
- [ ] Reference files are single-hop (no reference → reference nesting)
- [ ] Every `Load [file]` directive points to existing file
- [ ] Every file in `references/` has at least one reference in SKILL.md
- [ ] No orphaned files in `assets/` (all referenced)
- [ ] No empty folders

### Procedure Quality

- [ ] Steps use imperative form ("Run X" not "You should run X")
- [ ] Destructive operations have exact commands (not general guidance)
- [ ] Non-idempotent operations flagged with warnings
- [ ] Error handling covers 3-5 failure modes

</p2_required>

---

<p3_optional>

## P3 — Optional

Enhancements beyond minimum requirements.

- [ ] `license` field specifies licensing
- [ ] `compatibility` documents environment requirements
- [ ] `metadata` includes author, version, tags
- [ ] Validation section with verifiable checks
- [ ] Content over 100 lines extracted to `references/`
- [ ] Examples demonstrate expected usage
- [ ] Notes section for caveats or prerequisites

</p3_optional>

---

<common_mistakes>

## Common Mistakes

**Description too vague:**
- Bad: "Helps with API tasks"
- Fix: "Creates REST API endpoints. Use when user asks to 'scaffold routes' or 'add endpoint'. Produces route handlers with validation."

**Missing trigger clause:**
- Bad: "Generate documentation"
- Fix: "Generates API documentation from source code. Use when user asks to 'extract JSDoc' or 'document functions'. Outputs Markdown with parameter descriptions."

**Agent contamination:**
- Bad: "You are a thorough documentation expert..."
- Fix: Remove identity; write imperative steps

**Persona in error handling:**
- Bad: "If error occurs, I will retry..."
- Fix: "If error occurs: Retry once, then abort with message"

**Knowledge-base reference:**
- Bad: "See knowledge-base/artifacts/skill-patterns.md"
- Fix: Embed required patterns in skill's `references/` folder

**Multiple capabilities:**
- Bad: Skill that creates AND validates AND deploys
- Fix: Split into separate skills

**Empty structure:**
- Bad: Creating `references/` folder "just in case"
- Fix: Only create folders when content exists

</common_mistakes>

---

<validation_by_tools>

## Validation by Tools

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

---

<cross_references>

## Cross-References

- [SKILL.md](../SKILL.md) — Parent skill entry point
- [structure-reference.md](structure-reference.md) — Frontmatter, patterns, exclusions
- [example-skeleton.md](../assets/example-skeleton.md) — Minimal template
- [example-api-scaffold.md](../assets/example-api-scaffold.md) — Full example

</cross_references>
