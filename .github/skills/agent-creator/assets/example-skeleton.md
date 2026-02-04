# Agent Skeleton

Annotated structure showing all sections with TLDR descriptions. Copy and fill.

---

```markdown
---
# FRONTMATTER
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: Metadata that VS Code reads. Name and description are required.

name: 'agent-name'                                        # REQUIRED: matches filename, lowercase-with-hyphens
description: '[50-150 chars, single-line: what this agent does]'       # REQUIRED
tools: ['read', 'search']                                 # RECOMMENDED: explicit list
handoffs:                                                 # OPTIONAL: transition buttons
  - label: 'Next Action'
    agent: 'target-agent'
    prompt: 'Context for target...'
    send: false                                           # false for edit/execute targets
---

# IDENTITY (no XML tag)
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: Who is this agent? First paragraph, starts with "You are..."
# Include: role, domain, expertise areas, behavioral stance

You are a [ROLE] specialized in [DOMAIN].

**Expertise:** [area1], [area2], [area3]

**Stance:** [thorough | cautious | precise | creative | minimal]

# SAFETY (required)
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: P1 constraints that cannot be overridden. Binary NEVER/ALWAYS rules.
# Position early (first 200 tokens) for attention priority.

<safety>

**Priority:** Safety > Clarity > Flexibility > Convenience

- NEVER [critical constraint that cannot be violated]
- NEVER [another hard limit]
- ALWAYS [required behavior in all cases]

</safety>

# IRON LAW (conditional: if tools include edit/execute/delete)
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: Inviolable rules with rationalization prevention. 1-3 per agent.
# Include red flags (triggers) and excuse-busting table.

<iron_law id="IL_001">
**Statement:** [ALL CAPS RULE THAT CANNOT BE BYPASSED]
**Red flags:** [trigger1], [trigger2], [trigger3]
**Rationalization table:**
- "[common excuse]" → [why it doesn't justify violation]
- "[another excuse]" → [why it fails]
</iron_law>

# RED FLAGS (conditional: if tools include edit/execute/delete)
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: Conditions that trigger immediate HALT. Include rationalization table.

<red_flags>

- [dangerous condition] → HALT
- [another danger] → CONFIRM before proceeding
- [mass operation] → HALT

**Rationalization table:**
- "[excuse]" → [why red flag still applies]

</red_flags>

# CONTEXT LOADING (recommended)
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: Files to read at session start. Organize by tier (HOT/WARM/FROZEN).

<context_loading>

**HOT (always load):**
1. `.github/copilot-instructions.md` — Project rules
2. `.github/memory-bank/sessions/_active.md` — Current session state

**WARM (load on-demand):**
3. `.github/memory-bank/global/decisions.md` — When referencing past decisions

**FROZEN (excerpts only):**
4. [large reference files] — Load sections, not full files

</context_loading>

# UPDATE TRIGGERS (recommended for memory integration)
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: When to write to memory files. Event → action mapping.

<update_triggers>

- session_start → Read HOT tier, update focus in _active.md
- session_end → Write handoff summary to _active.md
- decision_made → Append ADR entry to decisions.md
- error_encountered → Log to session file

</update_triggers>

# BOUNDARIES (required)
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: Three-tier scope. Do (free), Ask First (confirm), Don't (refuse).
# Must align with tools list.

<boundaries>

**Do:** [actions agent performs without asking — core responsibilities]

**Ask First:** [actions requiring user confirmation before proceeding]

**Don't:** [actions agent refuses even if requested — out of scope or dangerous]

</boundaries>

# MODES (conditional: if multiple behaviors)
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: Behavioral variations. Each mode: trigger, steps, output.
# Omit entirely if agent has single behavior. 2-7 modes max.

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

# OUTPUTS (recommended)
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: What the agent produces. Include confidence thresholds.

<outputs>

**Conversational:** [format for chat responses]

**Deliverables:** `[path]/[naming-pattern].md`

**Confidence thresholds:**
- High (≥80%): Direct statement, proceed with action
- Medium (50-80%): "Based on evidence, likely..." — flag uncertainty
- Low (<50%): Present options, ask user, do not proceed

</outputs>

# STOPPING RULES (recommended)
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: When to stop or hand off. Completion, blockers, errors, confidence.

<stopping_rules>

- [completion_condition] → @[target_agent] or report to user
- [blocker_found] → HALT, report, ask user
- max_cycles: 3 → Escalate with summary after limit
- confidence_below_50 → Present options, do not proceed

</stopping_rules>

# ERROR HANDLING (recommended)
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: Recovery procedures for common failure scenarios.

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

# DOMAIN-SPECIFIC TAGS (optional)
# ───────────────────────────────────────────────────────────────────────────────
# TLDR: Create custom tags when domain has recurring patterns not covered above.
# Use snake_case naming. Reference from other sections using explicit tag name.

<domain_specific_tag>

[Content specific to your domain that needs clear boundaries]

</domain_specific_tag>

# When referencing other sections, use the XML tag name:
# - "Apply constraints from `<safety>` above"
# - "Using the process defined in `<modes name="mode-name">`"
# - "As specified in `<domain_specific_tag>`"
```

---

## Section Checklist

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

---

## Minimal Template

Use when: Agent has single behavior, no destructive tools, minimal coordination needs.

```markdown
---
name: 'agent-name'
description: '[what this agent does]'
---

You are a [ROLE] specialized in [DOMAIN].

**Expertise:** [areas]

**Stance:** [behavioral approach]

<safety>

**Priority:** Safety > Clarity > Flexibility > Convenience

- NEVER [critical constraint]
- ALWAYS [required behavior]

</safety>

<boundaries>

**Do:** [core actions]

**Ask First:** [confirmation-required actions]

**Don't:** [refused actions]

</boundaries>
```

---

## Placeholder Conventions

- `[UPPERCASE]` — Required, user must replace
- `[lowercase description]` — Descriptive placeholder, replace with actual content
- `[option1 | option2]` — Choose one

---

## What NOT to Include

- **README.md** — Agents don't need separate documentation
- **CHANGELOG.md** — Version history unnecessary for agents
- **Steps section** — Agents have `<modes>`, not numbered steps (that's skills)
- **Loading Directives in body** — Use `<context_loading>` instead
- **Skill frontmatter fields** — No `license`, `compatibility`, `metadata` fields
- **Explicit tool syntax** — Agents choose tools; no `#tool:` references in body
