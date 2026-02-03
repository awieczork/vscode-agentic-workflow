---
name: agent-creator
description: >
  Creates .agent.md files from specifications. Use when asked to "create an agent",
  "build an agent", "generate agent for [domain]", or when spec describes a persona
  with tools and cross-session behavior. Do NOT use for file-pattern rules (use
  instruction-creator), reusable procedures (use skill-creator), or one-shot
  generation (use prompt-creator).
---

# Agent Creator

Create valid, high-quality `.agent.md` files from specifications.

## Process

Follow these 6 steps in order. Load references as needed.

### Step 1: Classify

Confirm spec describes an AGENT, not another artifact type.

**Decision gate:**
- Needs persona + cross-session consistency + handoffs? → Agent ✓
- File-pattern rules only? → Instruction (stop, wrong skill)
- Reusable procedure any agent invokes? → Skill (stop, wrong skill)
- One-shot template with placeholders? → Prompt (stop, wrong skill)

If unclear, ask user: "This sounds like [type] because [reason]. Confirm agent?"

### Step 2: Extract

Pull these elements from the spec:

**Role:**
- Extract from: "agent for [role]"
- Default if missing: Ask user

**Domain:**
- Extract from: Context clues
- Default if missing: Infer from role

**Tools needed:**
- Extract from: Actions described
- Default if missing: Match to role (see `references/decision-rules.md`)

**Constraints:**
- Extract from: "must", "never", "always"
- Default if missing: None

**Handoff targets:**
- Extract from: "hands off to", "then [agent]"
- Default if missing: None

If role is unclear, ask user before proceeding.

### Step 3: Decide

Apply decision rules to fill the skeleton. Load `references/decision-rules.md` for:
- Role → Tools mapping
- Tools → Safety requirements (iron laws, red flags)
- Role → Boundaries (Do / Ask First / Don't)
- Behavioral variation → Modes inclusion

### Step 4: Draft

Build the agent in layers. Start with L0, add L1/L2 as needed.

**L0 — Valid (minimum viable agent):**
- Frontmatter: `name`, `description`, `tools`
- Body: Identity paragraph, `<safety>`, `<boundaries>`

**L1 — Good (production-ready):**
- Add: `<context_loading>`, `<stopping_rules>`, `<error_handling>`
- Add: `handoffs` in frontmatter if targets identified

**L2 — Excellent (full integration):**
- Add: `<iron_law>` with rationalization tables (if destructive tools)
- Add: `<red_flags>` with HALT conditions (if destructive tools)
- Add: `<modes>` (if multiple behaviors)
- Add: `<update_triggers>` for memory integration
- Add: `<outputs>` with confidence thresholds

Load `references/structure-reference.md` for exact syntax.
Use `assets/example-skeleton.md` as template.

### Step 5: Validate

Self-check before delivery. Load `references/validation-checklist.md`.

**Quick 6-check (P1 blockers):**
1. [ ] `name` field present, matches filename
2. [ ] `description` is 50-150 characters
3. [ ] First paragraph starts with "You are..."
4. [ ] `<safety>` section present with NEVER/ALWAYS
5. [ ] `<boundaries>` section present with Do/Ask First/Don't
6. [ ] No placeholder text remaining (`[PLACEHOLDER]`, `TODO`)

**If tools include edit/execute/delete:**
6. [ ] `<iron_law>` section present
7. [ ] `<red_flags>` section present
8. [ ] `send: false` on all handoffs

### Step 6: Integrate

Connect agent to ecosystem. Load `references/ecosystem-integration.md` for:
- Memory-bank file paths and tiers
- Handoff payload structure
- How instructions auto-load
- How to invoke skills

---

## When to Ask User

- Role is ambiguous → "What is the primary responsibility?"
- Multiple domains possible → "Which domain: [A] or [B]?"
- Unclear if destructive → "Will this agent modify/delete files?"
- Handoff targets unknown → "Which agents should this hand off to?"

## Quality Signals

**Good agent:**
- Identity is specific (not "helpful assistant")
- Boundaries match tools (no `edit` tool if "Don't modify files")
- Safety rules are binary NEVER/ALWAYS (not "try to avoid")
- Stopping rules have clear targets

**Excellent agent:**
- Iron laws have rationalization tables
- Handoff payloads include Summary + Findings + Next Steps
- Error handling covers 3+ scenarios
- Context loading specifies HOT/WARM/FROZEN tiers

---

## References

- [decision-rules.md](references/decision-rules.md) — Spec→decisions mappings
- [structure-reference.md](references/structure-reference.md) — Frontmatter, body, XML tags
- [ecosystem-integration.md](references/ecosystem-integration.md) — Memory, handoffs, connections
- [validation-checklist.md](references/validation-checklist.md) — P1/P2 checks

## Assets

- [example-skeleton.md](assets/example-skeleton.md) — Annotated structure template
- [example-devops-deployer.md](assets/example-devops-deployer.md) — Full working agent
