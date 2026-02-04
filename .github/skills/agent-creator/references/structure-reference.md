# Structure Reference

Exact syntax for agent artifacts. Use during Step 4: Draft.

<frontmatter_schema>

## Frontmatter Schema

```yaml
---
# REQUIRED
name: 'agent-name'           # Must match filename, lowercase-with-hyphens
description: '[50-150 chars, single-line, what agent does]'

# RECOMMENDED
tools: ['read', 'search', 'edit']  # Explicit list, no ['*']

# OPTIONAL
argument-hint: 'What to do?' # Placeholder in chat input

# IF HANDOFFS EXIST
handoffs:
  - label: 'Action Label'    # Button text
    agent: 'target-agent'    # Without .agent.md
    prompt: 'Context...'     # Summary + findings + next steps
    send: false              # ALWAYS false for edit/execute targets
---
```

</frontmatter_schema>

<body_sections>

## Body Sections

Sections in recommended order. Position P1 content (safety, iron laws) early.

### Identity (REQUIRED, no XML tag)

First paragraph, no wrapping tag.

```markdown
You are a [ROLE] specialized in [DOMAIN].

**Expertise:** [area1], [area2], [area3]

**Stance:** [thorough | cautious | precise | creative | minimal]
```

**Stance values:**
- **thorough** — exhaustive analysis, considers edge cases
- **cautious** — conservative changes, asks before destructive actions
- **precise** — exact requirements, no assumptions
- **creative** — proposes alternatives, explores possibilities
- **minimal** — smallest viable solution, no extras

### `<safety>` (REQUIRED)

P1 constraints. Place immediately after identity.

```markdown
<safety>

**Priority:** Safety > Clarity > Flexibility > Convenience

- NEVER [critical constraint]
- NEVER [critical constraint]
- ALWAYS [required behavior]

</safety>
```

**Rules:**
- Use binary NEVER/ALWAYS (not "try to", "should")
- 2-5 statements total
- Most critical constraints first

### `<iron_law>` (CONDITIONAL: if edit/execute/delete tools)

Inviolable rules with rationalization prevention.

```markdown
<iron_law id="IL_001">
**Statement:** [ALL CAPS RULE]
**Red flags:** [trigger1], [trigger2], [trigger3]
**Rationalization table:**
- "[excuse]" → [why it fails]
- "[excuse]" → [why it fails]
</iron_law>
```

**Rules:**
- 1-3 iron laws per agent
- Each needs red flags list
- Each needs 2-3 rationalization entries
- ID format: IL_001, IL_002, etc.

### `<red_flags>` (CONDITIONAL: if edit/execute/delete tools)

HALT conditions with rationalization table.

```markdown
<red_flags>

- Credential in output → HALT
- Production target → CONFIRM
- Mass deletion (>10 files) → HALT
- Force push → HALT

**Rationalization table:**
- "It's just a test" → Verify environment first
- "User asked for it" → Red flags override requests
- "It's faster" → Speed never justifies safety bypass

</red_flags>
```

### `<context_loading>` (RECOMMENDED)

Files to read at session start, by tier.

```markdown
<context_loading>

**HOT (always load):**
1. `.github/copilot-instructions.md` — Project rules
2. `.github/memory-bank/sessions/_active.md` — Current state

**WARM (load on-demand):**
3. `.github/memory-bank/global/decisions.md` — When referencing decisions

**FROZEN (excerpts only):**
4. [domain-specific large files]

</context_loading>
```

### `<update_triggers>` (RECOMMENDED for memory-integrated agents)

Event-to-action mappings for memory writes.

```markdown
<update_triggers>

- session_start → Read HOT tier, update focus
- session_end → Write handoff summary to _active.md
- decision_made → Append ADR to decisions.md
- error_encountered → Log to session

</update_triggers>
```

### `<boundaries>` (REQUIRED)

Three-tier scope definition.

```markdown
<boundaries>

**Do:** [actions performed freely]

**Ask First:** [actions requiring confirmation]

**Don't:** [actions refused even if requested]

</boundaries>
```

**Rules:**
- Each tier: 1-5 items
- Must align with tools (no "edit files" in Do if no edit tool)
- Don't tier includes out-of-scope + dangerous actions

### `<modes>` (CONDITIONAL: if multiple behaviors)

Behavioral variations with triggers.

```markdown
<modes>

<mode name="mode-name">
**Trigger:** "[activation phrase]"
**Steps:** [step1] → [step2] → [step3]
**Output:** [expected deliverable]
</mode>

</modes>
```

**Rules:**
- 2-7 modes maximum
- Omit entirely if single behavior
- Triggers must be distinct (no overlap)

### `<outputs>` (RECOMMENDED)

What the agent produces.

```markdown
<outputs>

**Conversational:** [short response format]

**Deliverables:** `[path]/[naming-pattern].md`

**Confidence thresholds:**
- High (≥80%): Direct statement
- Medium (50-80%): "Based on evidence, likely..."
- Low (<50%): Present options, ask user

</outputs>
```

### `<stopping_rules>` (RECOMMENDED)

When to hand off or stop.

```markdown
<stopping_rules>

- [condition] → @[target_agent]
- [condition] → Ask user
- max_cycles: 3 → Escalate with summary
- confidence_below_50 → Present options

</stopping_rules>
```

### `<error_handling>` (RECOMMENDED)

Recovery procedures.

```markdown
<error_handling>

<if condition="3_consecutive_errors">
Stop. Summarize progress. Escalate to user.
</if>

<if condition="file_not_found">
Search similar filenames. Report what exists. Ask user.
</if>

<if condition="confidence_below_50">
Present options. Do not proceed without user direction.
</if>

</error_handling>
```

</body_sections>

<xml_tags_summary>

## XML Tags Summary

**Always required:**
- `<safety>` — P1 constraints
- `<boundaries>` — Do / Ask First / Don't

**Conditional (if destructive tools):**
- `<iron_law>` — If tools include edit, execute, or delete
- `<red_flags>` — If tools include edit, execute, or delete

**Conditional (if behavior varies):**
- `<modes>` — If agent has multiple behaviors
- `<update_triggers>` — If memory integration needed

**Recommended (include for quality):**
- `<context_loading>` — Files to read at session start
- `<outputs>` — What agent produces
- `<stopping_rules>` — When to hand off or stop
- `<error_handling>` — Recovery procedures

**Domain-specific (creator decides):**
- Custom tags using `snake_case` naming

</xml_tags_summary>

<domain_specific_xml_tags>

## Domain-Specific XML Tags

Create custom tags when domain requires specialized structure. Custom tags are flexible tools — adapt per domain.

**When to create:**
- Domain has recurring patterns not covered by standard tags
- Content needs clear boundaries for parsing
- Section will be referenced from other parts of the agent

**Naming rules:**
- Use `snake_case` for multi-word tags
- Tag names: 3-25 characters
- Be consistent within artifact

**Example — deployment domain:**
```markdown
<deployment_gates>

**Pre-deploy:** [checks before deployment]
**Post-deploy:** [verification after deployment]
**Rollback trigger:** [conditions for automatic rollback]

</deployment_gates>
```

**Cross-referencing tags:**
When referring to content defined in another section, use the XML tag name explicitly:
- "Apply the constraints defined in `<safety>` above"
- "Using the gates from `<deployment_gates>`"
- "Follow the process in `<modes name="deploy-production">`"

</domain_specific_xml_tags>

<size_limits>

## Size Limits

**Total lines:**
- Recommended: ≤300
- Hard limit: ≤500

**Total characters:**
- Recommended: ≤25,000
- Hard limit: ≤30,000

**Modes count:**
- Recommended: 2-5
- Hard limit: 7

**Handoffs count:**
- Recommended: 1-2
- Hard limit: 3

**Tools count:**
- Recommended: 3-8
- Hard limit: 15

</size_limits>

<reserved_names>

## Reserved Names

Do NOT use these agent names:
- `ask`, `edit`, `agent` — Built-in chat modes
- `plan`, `workspace`, `terminal`, `vscode` — VS Code agents

</reserved_names>

<cross_references>

## Cross-References

- [SKILL.md](../SKILL.md) — Parent skill entry point

</cross_references>
