---
name: agent-creator
description: Creates .agent.md files from specifications. Use when asked to create an agent, build an agent, or generate agent for a domain. Produces frontmatter, identity, safety, boundaries, and modes sections.
---

# Agent Creator

Create valid, high-quality `.agent.md` files from specifications.

<workflow>

<step_1_classify>

Confirm spec describes an AGENT, not another artifact type.

**Decision gate:**
- Needs persona + cross-session consistency + handoffs? → Agent ✓
- File-pattern rules only? → Instruction (stop, wrong skill)
- Reusable procedure any agent invokes? → Skill (stop, wrong skill)
- One-shot template with placeholders? → Prompt (stop, wrong skill)

If unclear, ask user: "This sounds like [type] because [reason]. Confirm agent?"

</step_1_classify>

<step_2_extract>

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

</step_2_extract>

<step_3_decide>

Apply decision rules to fill the skeleton. Load `references/decision-rules.md` for:
- Role → Tools mapping
- Tools → Safety requirements (iron laws, red flags)
- Role → Boundaries (Do / Ask First / Don't)
- Behavioral variation → Modes inclusion

</step_3_decide>

<step_4_draft>

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

**Behavioral steering:** If agent needs proactive/conservative action modes or thinking patterns, load [decision-rules.md](references/decision-rules.md#behavioral-steering) for steering templates.

Load `references/structure-reference.md` for exact syntax.
Use `assets/example-skeleton.md` as template.

</step_4_draft>

<step_5_validate>

Self-check before delivery. Load `references/validation-checklist.md`.

**Quick 6-check (P1 blockers):**
1. [ ] `name` field present, matches filename
2. [ ] `description` is 50-150 characters, single-line
3. [ ] First paragraph starts with "You are..."
4. [ ] `<safety>` section present with NEVER/ALWAYS
5. [ ] `<boundaries>` section present with Do/Ask First/Don't
6. [ ] No placeholder text remaining (`[PLACEHOLDER]`, `TODO`)

**If tools include edit/execute/delete:**
6. [ ] `<iron_law>` section present
7. [ ] `<red_flags>` section present
8. [ ] `send: false` on all handoffs

</step_5_validate>

<step_6_integrate>

Connect agent to ecosystem. Load `references/ecosystem-integration.md` for:
- Memory-bank file paths and tiers
- Handoff payload structure
- How instructions auto-load
- How to invoke skills

</step_6_integrate>

</workflow>

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
