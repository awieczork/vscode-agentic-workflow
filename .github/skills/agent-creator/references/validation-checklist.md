# Validation Checklist

Self-check before delivery. Use during Step 5: Validate.

<quick_6_check>

## Quick 6-Check (P1 Blockers)

Agent is INVALID if any fails. Fix before delivery.

- [ ] `name` field present, matches filename (lowercase-with-hyphens)
- [ ] `description` is 50-150 characters, single-line
- [ ] First paragraph starts with "You are..."
- [ ] `<safety>` section present with at least one NEVER or ALWAYS
- [ ] `<boundaries>` section present with Do / Ask First / Don't
- [ ] No placeholder text remaining (`[PLACEHOLDER]`, `{placeholder}`, `TODO`)

</quick_6_check>

<p1_blocking>

## P1 — Blocking

Must fix. Agent fails validation.

### Naming
- [ ] Filename not reserved: `ask`, `edit`, `agent`, `plan`, `workspace`, `terminal`, `vscode`
- [ ] Filename uses lowercase-with-hyphens (e.g., `code-reviewer.agent.md`)

### Frontmatter
- [ ] `name` field present and matches filename (lowercase-with-hyphens)
- [ ] `description` field present
- [ ] `description` is 50-150 characters, single-line
- [ ] Valid YAML syntax (proper quotes, indentation)

### Structure
- [ ] File content NOT wrapped in markdown codeblock (no leading/trailing backticks)
- [ ] Identity statement starts with "You are..."
- [ ] `<safety>` section present
- [ ] `<boundaries>` section present
- [ ] All XML tags properly closed

### Safety (if edit/execute/delete tools)
- [ ] `<iron_law>` section present with 1-3 laws
- [ ] `<red_flags>` section present with HALT conditions
- [ ] Each iron law has rationalization table
- [ ] `send: false` on all handoffs

### Size
- [ ] Total characters ≤30,000
- [ ] Total lines ≤500

</p1_blocking>

<p2_required>

## P2 — Required

Fix before delivery for quality.

### Tools
- [ ] `tools` field explicitly listed (not omitted)
- [ ] Tools match boundaries (no `edit` if "Don't modify files")
- [ ] No `tools: ['*']` without documented justification
- [ ] Tool count ≤15

### Content
- [ ] `<context_loading>` specifies files with tiers
- [ ] `<stopping_rules>` defines handoff conditions
- [ ] `<error_handling>` covers 3+ consecutive errors
- [ ] Handoff targets exist as agent files (if handoffs used)

### Quality
- [ ] No vague instructions: "be helpful", "as appropriate", "be careful"
- [ ] Safety rules are binary NEVER/ALWAYS (not "try to avoid")
- [ ] No conflicting guidance between sections
- [ ] Priority hierarchy stated in `<safety>`
- [ ] Cross-references use explicit XML tag names (e.g., "as defined in `<safety>`")
- [ ] Domain-specific tags use `snake_case` naming

### Memory (if memory integration)
- [ ] Tier hierarchy specified: HOT/WARM/FROZEN
- [ ] `<update_triggers>` section present
- [ ] Session handoff writes to `_active.md`

### Orchestration (if agent tool)
- [ ] `max_cycles` defined (default: 3)
- [ ] Subagent depth = 1 only
- [ ] Escalation path specified

</p2_required>

<p3_optional>

## P3 — Optional

Enhancements for excellence.

- [ ] `name` field provides display name
- [ ] `argument-hint` provides input guidance
- [ ] Expertise areas listed (2-5 items)
- [ ] Stance explicitly defined
- [ ] Confidence thresholds in `<outputs>`
- [ ] Total lines ≤300 (recommended)
- [ ] Total characters ≤25,000 (recommended)
- [ ] Modes count 2-5 (if `<modes>` present)

</p3_optional>

<tools_boundaries_alignment_check>

## Tools-Boundaries Alignment Check

Verify no conflicts:

**If tools include → Boundaries must allow:**
- `edit` → "Create/modify files" in Do or Ask First
- `execute` → "Run commands" in Do or Ask First
- `agent` → "Spawn subagents" in Do or Ask First

**If boundaries say "Don't" → Tools must NOT include:**
- "Don't modify files" → Remove `edit`
- "Don't execute commands" → Remove `execute`
- "Don't access external" → Remove `web`

</tools_boundaries_alignment_check>

<safety_requirements_by_tools>

## Safety Requirements by Tools

**Any agent:**
- Required: `<safety>`, `<boundaries>`

**If tools include `edit`:**
- Add: `<iron_law>`, `<red_flags>`

**If tools include `execute`:**
- Add: `<iron_law>`, `<red_flags>`

**If tools include `delete`:**
- Add: `<iron_law>`, `<red_flags>`

**If tools include `agent`:**
- Add: `max_cycles` in `<stopping_rules>`

</safety_requirements_by_tools>

<common_mistakes>

## Common Mistakes

**`description` too short (<50 chars):**
- Fix: Add context — what domain, what outcome

**`description` too long (>150 chars):**
- Fix: Extract detail to identity paragraph

**Vague boundary: "appropriate actions":**
- Fix: Replace with specific actions

**Missing iron law for builder agent:**
- Fix: Add destructive command protection

**`send: true` to agent with edit tools:**
- Fix: Change to `send: false`

**Modes with overlapping triggers:**
- Fix: Make triggers distinct

**No stopping rules:**
- Fix: Add completion + blocker + error conditions

**Missing `name` field:**
- Fix: Add `name` matching filename in lowercase-with-hyphens

</common_mistakes>

<cross_references>

## Cross-References

- [SKILL.md](../SKILL.md) — Parent skill entry point

</cross_references>
