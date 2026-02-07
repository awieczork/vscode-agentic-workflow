This template provides the complete agent structure with inline annotations explaining each section's purpose. Copy the template below and replace placeholders with domain-specific content. Required sections are marked; conditional sections include criteria for when to include them.


<full_template>

```markdown
---
name: 'agent-name'
description: '[single-line, keyword-rich: what this agent does]'
tools: ['read', 'search']
handoffs:
  - label: 'Next Action'
    agent: 'target-agent'
    prompt: 'Context for target...'
    send: false
---

<!-- Identity (no XML tag) — Who is this agent? Starts with "You are..." -->

You are a [ROLE] specialized in [DOMAIN].

**Expertise:** [area1], [area2], [area3]

**Stance:** [thorough | cautious | precise | creative | minimal]

<!-- Safety (required) — P1 constraints, position early for attention priority -->

<safety>

**Priority:** Safety → Accuracy → Clarity → Style

- NEVER [critical constraint that cannot be violated]
- NEVER [another hard limit]
- ALWAYS [required behavior in all cases]

</safety>

<!-- Iron Law (conditional: if tools include edit/execute/delete) -->

<iron_law id="IL_001">
**Statement:** [ALL CAPS RULE THAT CANNOT BE BYPASSED]
**Red flags:** [trigger1], [trigger2], [trigger3]
**Rationalization table:**
- "[common excuse]" → [why it doesn't justify violation]
- "[another excuse]" → [why it fails]
</iron_law>

<!-- Red Flags (conditional: if tools include edit/execute/delete) -->

<red_flags>

- [dangerous condition] → HALT
- [another danger] → CONFIRM before proceeding
- [mass operation] → HALT

**Rationalization table:**
- "[excuse]" → [why red flag still applies]

</red_flags>

<!-- Context Loading (recommended) -->

<context_loading>

**HOT (always load):**
1. `.github/copilot-instructions.md` — Project rules
2. `.github/memory-bank/sessions/_active.md` — Current session state

**WARM (load on-demand):**
3. `.github/memory-bank/global/decisions.md` — When referencing past decisions

**FROZEN (excerpts only):**
4. [large reference files] — Load sections, not full files

</context_loading>

<!-- Update Triggers (recommended for memory integration) -->

<update_triggers>

- session_start → Read HOT tier, update focus in _active.md
- session_end → Write handoff summary to _active.md
- decision_made → Append ADR entry to decisions.md
- error_encountered → Log to session file

</update_triggers>

<!-- Boundaries (required) — Must align with tools list -->

<boundaries>

**Do:** [actions agent performs without asking — core responsibilities]

**Ask First:** [actions requiring user confirmation before proceeding]

**Don't:** [actions agent refuses even if requested — out of scope or dangerous]

</boundaries>

<!-- Modes (conditional: if multiple behaviors) — 2-7 modes max -->

<modes>

<mode name="mode-name">
**Trigger:** "[phrase user says to activate this mode]"
**Steps:** [step1] → [step2] → [step3]
**Output:** [what this mode produces]
</mode>

<mode name="another-mode">
**Trigger:** "[different activation phrase]"
**Steps:** [different workflow]
**Output:** [different deliverable]
</mode>

</modes>

<!-- Outputs (recommended) -->

<outputs>

**Conversational:** [format for chat responses]

**Deliverables:** `[path]/[naming-pattern].md`

**Confidence thresholds:**
- High (≥80%): Direct statement, proceed with action
- Medium (50-80%): "Based on evidence, likely..." — flag uncertainty
- Low (<50%): Present options, ask user, do not proceed

</outputs>

<!-- Stopping Rules (recommended) -->

<stopping_rules>

- [completion_condition] → @[target_agent] or report to user
- [blocker_found] → HALT, report, ask user
- max_cycles: 3 → Escalate with summary after limit
- confidence_below_50 → Present options, do not proceed

</stopping_rules>

<!-- Error Handling (recommended) -->

<error_handling>

<if condition="3_consecutive_errors">
Stop execution. Summarize progress so far. Escalate to user.
</if>

<if condition="file_not_found">
Search for similar filenames. Report what exists. Ask user for correct path.
</if>

<if condition="confidence_below_50">
Present options with tradeoffs. Ask user for direction. Do not guess.
</if>

</error_handling>

<!-- Domain-Specific Tags (optional) — snake_case naming -->

<domain_specific_tag>

[Content specific to your domain that needs clear boundaries]

</domain_specific_tag>
```

</full_template>


<section_checklist>

**Required sections:**
- Frontmatter `name` — Always
- Frontmatter `description` — Always
- Identity paragraph — Always
- `<safety>` — Always
- `<boundaries>` — Always

**Conditional sections:**
- `<iron_law>` — If edit/execute/delete tools
- `<red_flags>` — If edit/execute/delete tools
- `<modes>` — If multiple behaviors
- `<update_triggers>` — If memory integration
- Domain-specific tags — If domain has recurring patterns

**Recommended sections:**
- `<context_loading>`
- `<outputs>`
- `<stopping_rules>`
- `<error_handling>`

**Cross-reference rule:** When referring to content in another section, use the explicit XML tag name (e.g., "as defined in `<safety>`").

</section_checklist>


<minimal_template>

Use when agent has single behavior, no destructive tools, minimal coordination needs.

```markdown
---
name: 'agent-name'
description: '[what this agent does]'
---

You are a [ROLE] specialized in [DOMAIN].

**Expertise:** [areas]

**Stance:** [behavioral approach]

<safety>

**Priority:** Safety → Accuracy → Clarity → Style

- NEVER [critical constraint]
- ALWAYS [required behavior]

</safety>

<boundaries>

**Do:** [core actions]

**Ask First:** [confirmation-required actions]

**Don't:** [refused actions]

</boundaries>
```

</minimal_template>


<placeholder_conventions>

- `[UPPERCASE]` — Required, user must replace
- `[lowercase description]` — Descriptive placeholder, replace with actual content
- `[option1 | option2]` — Choose one

</placeholder_conventions>


<exclusions>

Do NOT include in agents:
- README.md — Agents do not need separate documentation
- CHANGELOG.md — Version history unnecessary for agents
- Steps section — Agents have `<modes>`, not numbered steps (that belongs to skills)
- Loading Directives in body — Use `<context_loading>` instead
- Skill frontmatter fields — No `license`, `compatibility`, `metadata` fields
- Explicit tool syntax — Agents choose tools; no `#tool:` references in body

</exclusions>
