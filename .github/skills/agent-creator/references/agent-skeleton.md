This file is the structural reference for building `.agent.md` artifacts. The governing principle is fixed shapes with open content — the tag vocabulary and section order are closed, domain extension happens through attribute values and prose content.


<tag_vocabulary>

Tags are the agent's structural skeleton — fixed shapes filled with domain content. Domain extension happens through attribute values and prose content, not new tags. 4 top-level tags, 6 sub-tags, 4 attributes.

- `<constraints>` — Required. Prohibitions, limits, safety priority. Prose intro states priority hierarchy and primary risk
  - `<iron_law id="IL_NNN">` — Optional. High-consequence non-negotiable rules with statement, red flags, rationalization counters. Use only for agents with destructive tools, citation authority, or approval authority
- `<behaviors>` — Required. Everything the agent actively does. Prose intro states execution sequence
  - `<context_loading>` — Optional. Initialization / boot sequence with load order and fallbacks
    - `<on_missing context="[RESOURCE]">` — Optional. Fallback behavior for missing resources
  - `<mode name="[DOMAIN_VERB]">` — Optional. Named behavioral configuration with trigger, steps, exit. Use only for multi-behavior agents
- `<outputs>` — Required. Deliverable formats, confidence thresholds, handoff payload templates. Prose intro states consumer expectations
- `<termination>` — Optional. Stopping conditions, handoff/escalation triggers, error recovery. Omit for solo agents. Prose intro states completion criteria and max cycles
  - `<if condition="[ERROR_TYPE]">` — Optional. Deterministic condition-action pair for runtime recovery
  - `<when_blocked>` — Optional. Structured template for reporting blocked state

</tag_vocabulary>


<attributes>

Attributes address specific instances within tags. 4 names are closed (only these four exist); values are open (any kebab-case domain term).

- `name` — Labels instances. Used on `<mode>`. Domain verb as value (e.g., `explore`, `triage`, `deploy`)
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
