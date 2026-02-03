---
name: skill-creator
description: >
  Creates SKILL.md files from specifications. Use when asked to "create a skill",
  "build a skill", "generate skill for [domain]", or when spec describes a reusable
  procedure any agent can invoke. Do NOT use for personas with tools (use agent-creator),
  file-pattern rules (use instruction-creator), or one-shot templates (use prompt-creator).
---

# Skill Creator

Create valid, high-quality `.github/skills/{name}/SKILL.md` files from specifications.

## Process

Follow these 6 steps in order. Load references as needed.

### Step 1: Classify

Confirm spec describes a SKILL, not another artifact type.

**Decision gate:**
- Reusable procedure any agent invokes? → Skill ✓
- Needs persona + tools + cross-session behavior? → Agent (stop, wrong skill)
- File-pattern rules that auto-apply? → Instruction (stop, wrong skill)
- One-shot template with placeholders? → Prompt (stop, wrong skill)

If unclear, ask user: "This sounds like [type] because [reason]. Confirm skill?"

### Step 2: Name and Describe

**Name:**
- Extract from: "skill for [name]" or derive from capability
- Format: lowercase-with-hyphens, 1-64 characters
- Rule: Must match parent folder name exactly

**Description:**
- Formula: `[VERB] [WHAT] when [TRIGGER]`
- Include trigger phrases users would say
- Include negative triggers: "Do NOT use for..."

If name unclear, ask: "What should this skill be called?"

### Step 3: Assess Complexity

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

### Step 4: Draft

Build the skill using these sections. Load `references/structure-reference.md` for:
- Frontmatter schema
- Procedure design patterns
- "Load X when Y" syntax
- Exclusion rules (what skills must NOT contain)

**Required sections:**
1. YAML Frontmatter (`name`, `description`)
2. H1 Title
3. Overview (1-2 sentences)
4. Steps (numbered, imperative)
5. Error Handling (If X: Y format)

**Optional sections:**
- Reference Files (if using `references/`)
- Validation (if success is verifiable)
- Notes (for caveats, prerequisites)

### Step 5: Validate

Self-check before delivery. Load `references/validation-checklist.md` for full checks.

**Quick 5-check (P1 blockers):**
1. [ ] `name` + `description` in frontmatter
2. [ ] `name` matches parent folder exactly
3. [ ] Description has verb + "when [trigger]"
4. [ ] SKILL.md ≤500 lines
5. [ ] No hardcoded secrets or absolute paths

**Exclusion check (skills must NOT contain):**
- XML tags: `<identity>`, `<safety>`, `<boundaries>`, `<iron_law>`, `<handoffs>`
- Phrases: "You are a...", stance words (thorough, cautious, creative)
- References: knowledge-base/, memory-bank/, .agent.md files
- Frontmatter: `tools:`, `handoffs:`, `model:`, `applyTo:`

### Step 6: Integrate

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

**Good skill:**
- Description has specific trigger phrases
- Steps are numbered and imperative
- Error handling covers predictable failures
- Single focused capability

**Excellent skill:**
- Progressive disclosure for complex content
- Loading directives point to real files
- Validation section with verifiable checks
- No agent contamination (identity, safety, boundaries)

---

## References

- [structure-reference.md](references/structure-reference.md) — Frontmatter, patterns, exclusions
- [validation-checklist.md](references/validation-checklist.md) — P1/P2 checks

## Assets

- [example-skeleton.md](assets/example-skeleton.md) — Annotated minimal template
- [example-api-scaffold.md](assets/example-api-scaffold.md) — Full working skill
