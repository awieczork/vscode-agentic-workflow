This checklist validates agent artifacts before delivery. The governing principle is severity-ordered checking — run P1 checks first (blocking issues that invalidate the agent), then P2 (quality issues that degrade effectiveness), then P3 (optional enhancements). Use this during `<step_5_validate>` to catch issues before handoff.


<quick_6_check>

Agent is INVALID if any fails. Fix before delivery.

- [ ] `name` field present, matches filename (lowercase-with-hyphens)
- [ ] `description` is single-line, keyword-rich
- [ ] First paragraph starts with "You are..."
- [ ] `<safety>` section present with at least one NEVER or ALWAYS
- [ ] `<boundaries>` section present with Do / Ask First / Don't
- [ ] No placeholder text remaining (`[PLACEHOLDER]`, `{placeholder}`, `TODO`)

</quick_6_check>


<p1_blocking>

Must fix. Agent fails validation.

<naming>

- [ ] Filename not reserved: `ask`, `edit`, `agent`, `plan`, `workspace`, `terminal`, `vscode`
- [ ] Filename uses lowercase-with-hyphens (e.g., `code-reviewer.agent.md`)

</naming>

<frontmatter>

- [ ] `name` field present and matches filename (lowercase-with-hyphens)
- [ ] `description` field present
- [ ] `description` is single-line, keyword-rich
- [ ] Valid YAML syntax (proper quotes, indentation)
- [ ] No unsupported fields (check against [structure-reference.md](structure-reference.md) `<frontmatter_schema>`)

</frontmatter>

<structure>

- [ ] File content NOT wrapped in markdown codeblock (no leading/trailing backticks)
- [ ] Identity statement starts with "You are..."
- [ ] `<safety>` section present
- [ ] `<boundaries>` section present
- [ ] All XML tags properly closed
- [ ] No markdown headings — XML tags are exclusive structure

</structure>

<safety_checks>

If tools include edit/execute/delete:
- [ ] `<iron_law>` section present with 1-3 laws
- [ ] `<red_flags>` section present with HALT conditions
- [ ] Each iron law has rationalization table
- [ ] `send: false` on all handoffs

</safety_checks>

</p1_blocking>


<p2_required>

Fix before delivery for quality.

<tools_checks>

- [ ] `tools` field explicitly listed (not omitted)
- [ ] Tools match boundaries (no `edit` if "Don't modify files")
- [ ] No `tools: ['*']` without documented justification
- [ ] Tool aliases ≤5 (warn if >5, block if >8) — prevents "Swiss-army agents" anti-pattern

</tools_checks>

<description_quality>

- [ ] `description` contains ≥2 action verbs or domain terms — enables subagent discovery via keyword matching

</description_quality>

<content_quality>

- [ ] `<context_loading>` specifies files with tiers
- [ ] `<stopping_rules>` defines handoff conditions
- [ ] `<error_handling>` covers 3+ consecutive errors
- [ ] Handoff targets exist as agent files (if handoffs used)

</content_quality>

<quality_standards>

- [ ] No vague instructions: "be helpful", "as appropriate", "be careful"
- [ ] Safety rules are binary NEVER/ALWAYS (not "try to avoid")
- [ ] No conflicting guidance between sections
- [ ] Priority hierarchy stated in `<safety>`
- [ ] Cross-references use explicit XML tag names (e.g., "as defined in `<safety>`")
- [ ] Domain-specific tags use `snake_case` naming

</quality_standards>

<memory_checks>

If memory integration:
- [ ] Tier hierarchy specified: HOT/WARM/FROZEN
- [ ] `<update_triggers>` section present
- [ ] Session handoff writes to `_active.md`

</memory_checks>

<orchestration_checks>

If agent tool:
- [ ] `max_cycles` defined (default: 3)
- [ ] Subagent depth = 1 only
- [ ] Escalation path specified

</orchestration_checks>

</p2_required>


<p3_optional>

Enhancements for excellence.

- [ ] `name` field provides display name
- [ ] `argument-hint` provides input guidance
- [ ] Expertise areas listed (2-5 items)
- [ ] Stance explicitly defined
- [ ] Confidence thresholds in `<outputs>`
- [ ] Modes count 2-5 (if `<modes>` present)

</p3_optional>


<tools_boundaries_alignment_check>

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

**`description` missing action verbs:**
- Wrong: "Helps with code tasks"
- Correct: Add verbs describing what agent does (creates, reviews, generates, validates)

**Vague boundary: "appropriate actions":**
- Correct: Replace with specific actions

**Missing iron law for builder agent:**
- Correct: Add destructive command protection

**`send: true` to agent with edit tools:**
- Correct: Change to `send: false`

**Modes with overlapping triggers:**
- Correct: Make triggers distinct

**No stopping rules:**
- Correct: Add completion + blocker + error conditions

**Missing `name` field:**
- Correct: Add `name` matching filename in lowercase-with-hyphens

</common_mistakes>


<cross_references>

- [SKILL.md](../SKILL.md) — Parent skill entry point

</cross_references>
