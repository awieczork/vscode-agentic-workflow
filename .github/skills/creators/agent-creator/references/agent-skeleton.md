This file is the structural reference for building `.agent.md` artifacts. The governing principle is fixed shapes with open content — the tag vocabulary and section order are closed, domain extension happens through attribute values and prose content.


<tag_vocabulary>

Tags are the agent's structural skeleton. 4 structural tags (fixed, closed) define agent anatomy. 7+ recognized sub-tag patterns (open, extensible) provide domain-specific structure within those boundaries. 4 attributes.

**Structural tags** (fixed — exactly these four):

- `<constraints>` — Required. Hard limits and iron laws
- `<behaviors>` — Required. Behavioral rules, modes, execution logic
- `<outputs>` — Required. Deliverables and return formats
- `<termination>` — Optional. Session-ending conditions

**Domain sub-tags** (open — agents introduce sub-tags as needed within structural boundaries):

Recognized patterns:

- `<iron_law>` — Numbered constraint with rationale (inside `<constraints>`)
- `<context_loading>` — Input processing rules (inside `<behaviors>`)
- `<on_missing>` — Fallback behavior for missing context (inside `<behaviors>`)
- `<mode>` — Behavioral variant with activation criteria (inside `<behaviors>`)
- `<verification>` — Domain-specific verification rules (inside `<behaviors>`)
- `<if>` / `<when_blocked>` — Conditional behavior (inside `<behaviors>`)
- `<example>` — Annotated output sample (inside `<outputs>`)
- `<return_format>` — Structured return contract (inside `<outputs>`)

For single-mode agents, use a domain-verb sub-tag (e.g., `<planning>`, `<verification>`) directly under `<behaviors>` instead of wrapping in `<mode>`.

Agents may introduce additional domain sub-tags not listed here. Sub-tags must nest inside structural tags. Name sub-tags with snake_case.

</tag_vocabulary>


<attributes>

Attributes address specific instances within tags. 4 names are closed (only these four exist); values are open (any kebab-case domain term).

- `name` — Labels instances. Used on `<mode>`. Domain verb as value (e.g., `explore`, `triage`, `deploy`). Agent-scoped — other artifact types (workflows, models) use `name` freely on tags like `<step_N>`, `<round_N>`, `<pattern>`
- `id` — References instances. Used on `<iron_law>`. Sequential identifier (e.g., `IL_001`)
- `condition` — Conditional logic key. Used on `<if>`. Error type as value (e.g., `3-consecutive-errors`, `confidence-below-50`)
- `context` — Scopes fallback behavior. Used on `<on_missing>`. Resource name as value (e.g., `copilot-instructions`, `session-state`)

</attributes>


<prose_intro_pattern>

Every agent file opens with identity prose before the first tag. All top-level tags open with 1-3 sentences of prose before structured content. These intros orient the agent at runtime — scope, trigger, principle.

- **Identity** (no tag, 2-4 paragraphs) — Write in second person: "You are [role] who [primary action]. Your expertise spans [domains]." Paragraph 1: role and expertise. Paragraph 2: approach and methodology. Paragraph 3: anti-identity and handoff pointers. Each paragraph is 2-3 sentences. The identity prose is the agent's self-model — direct, specific, no hedging. Identity prose length is constant across all scaling tiers — it is the agent's core self-model
- **`<constraints>`** — "Priority: {hierarchy}. Primary risk: {domain}. Constraints override all behavioral rules."
- **`<behaviors>`** — "Apply `<constraints>` first. {Load context if applicable}. Select behavior from {modes or bullets}."
- **`<outputs>`** — "Deliverables follow templates below. Confidence below {N}% triggers {action}."
- **`<termination>`** — "Terminate when {criteria}. Hand off to peers; escalate to humans. Max {N} cycles before escalation."

</prose_intro_pattern>


<anti_patterns>

Common mistakes that produce agents that appear functional but fail in practice. Check the final agent against this list before delivery.

- Swiss-army agents — too many tools, tries to do everything
- Vague descriptions — "A helpful agent" doesn't guide handoff
- Role confusion — description doesn't match body persona
- Circular handoffs — A → B → A without progress criteria
- Hedge safety language — using "try to avoid", "should", "be careful" instead of binary NEVER/ALWAYS
- Overlapping mode triggers — multiple modes with ambiguous or identical activation phrases
- Scope bleed — agent performs work outside its declared role instead of delegating
- Monologue agents — never clarifies with user, makes large assumptions instead of asking

</anti_patterns>
