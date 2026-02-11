---
description: 'Tracked follow-up items from agent refactors — structural gaps, missing documentation, consistency issues'
---

Open items discovered during agent refactoring. Each item includes origin (which refactor surfaced it), impact, and suggested action.


<items>

- **`<verification>` tag not in closed vocabulary**
  - Origin: inspect.agent.md refactor (2026-02-11)
  - Context: Both architect.agent.md (`<planning>`) and inspect.agent.md (`<verification>`) use semantic sub-tags under `<behaviors>` for single-mode agents — replacing `<mode name="...">` wrappers per the "single-mode agents don't need `<mode>` wrappers" pattern
  - Impact: P3 — functional, but technically outside the closed tag vocabulary defined in agent-skeleton.md's `<tag_vocabulary>`
  - Action: Update `<tag_vocabulary>` in [agent-skeleton.md](../.github/skills/agent-creator/references/agent-skeleton.md) to document semantic sub-tags as an accepted pattern for single-behavior agents. Add guidance: "For single-mode agents, use a domain-verb sub-tag (e.g., `<planning>`, `<verification>`) directly under `<behaviors>` instead of wrapping in `<mode>`"

- ~~**agent-frontmatter-contract.md missing fields**~~ — RESOLVED (skill-audit-20260211)
  - Origin: inspect.agent.md refactor (2026-02-11), pre-existing gap
  - Resolution: Build added `user-invokable`, `disable-model-invocation`, `agents`, `model`, `mcp-servers`, and `target` fields to `<frontmatter_fields>` in [agent-frontmatter-contract.md](../.github/skills/agent-creator/references/agent-frontmatter-contract.md). Also documented `infer` deprecation

</items>
