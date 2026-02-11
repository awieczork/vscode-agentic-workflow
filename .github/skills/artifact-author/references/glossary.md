This file defines canonical vocabulary for all AI agent artifacts in this repository. The governing principle is: one term per concept — aliases fragment understanding and create inconsistency across files. Reference `<canonical_terms>` for definitions and prohibited aliases. Consult `<validation>` for automated detection of non-canonical usage.


<glossary_constraints>

- Use only canonical terms defined in `<canonical_terms>` across all artifacts — applies to prose and definitions; XML tag names use snake_case with domain-specific, meaningful names
- Understand aliases in user input but respond with canonical terms only
- Consult **Conflicts** entries when terms overlap in meaning — prevents misapplication of related terms

</glossary_constraints>


<canonical_terms>

- **error** — Unexpected condition preventing normal execution. Aliases: failure, exception, fault, problem, bug, defect. Conflicts: issue (trackable item vs runtime condition)
- **rule** — Enforceable behavioral instruction within a named group. Aliases: guideline, policy, directive
- **constraint** — Hard limit that cannot be exceeded — an obligation. Aliases: restriction, limitation. Conflicts: boundary (boundary defines capability limits; constraint defines obligation limits)
- **agent** — Autonomous executor with identity and boundaries. Aliases: assistant, bot, AI
- **skill** — Reusable multi-step process with validation. Aliases: procedure, recipe. Conflicts: workflow (workflow is a composed agent sequence; skill is a reusable process)
- **workflow** — Agent orchestration sequence composed by brain. Aliases: pipeline, flow. Conflicts: skill (skill is a reusable process; workflow is a composed agent sequence)
- **prompt** — Parameterized instruction with variable slots. Aliases: template, query, request
- **instruction** — Collection of rules applying to file patterns. Aliases: guidance, rule-set, directive-file
- **artifact** — Any generated or modified content. Aliases: document, output
- **handoff** — Structured payload passing work to another agent. Aliases: delegation, transfer, dispatch, route. Conflicts: escalate (escalate interrupts for human input; handoff passes work to another agent)
- **escalate** — Interrupt execution to request human input. Aliases: interrupt. Conflicts: handoff (handoff passes work to another agent; escalate pauses for human decision)
- **fabricate** — Produce unverified claims without evidence. Aliases: hallucinate, invent
- **mode** — Named behavioral configuration within an agent. Aliases: behavior-set. Conflicts: phase (phase is a lifecycle stage; mode is a behavioral configuration)
- **context** — Information acquired and held during a session. Aliases: loaded-data
- **boundary** — Capability limit defining what an agent may access or modify. Aliases: fence, guardrail. Conflicts: constraint (constraint defines obligation limits; boundary defines capability limits)
- **phase** — Lifecycle stage in agent execution. Aliases: stage. Conflicts: mode (mode is a behavioral configuration; phase is a lifecycle stage)
- **tool** — External capability invoked by the agent
- **workspace** — Scope of file operations and agent context

</canonical_terms>


<validation>

Grep pattern to detect non-canonical alias usage across `.github/**/*.md`:

```
exception|fault|problem|bug|defect|guideline|policy|directive|restriction|limitation|assistant|bot|procedure|workflow|recipe|guidance|rule-set|directive-file|delegation|transfer|dispatch|route|interrupt|hallucinate|invent|behavior-set|loaded-data|fence|guardrail
```

**Excluded from pattern** — Common English words that produce false positives: pass, break, function, command, project, repository, codebase, state, limit, stage, stop, pause, ask, template, query, request, document, output, capability, failure ("plan failure" and "test failure" are idiomatic English distinct from canonical `error`). Review these manually when violations are suspected.

**Usage:** Apply pattern against `.github/**/*.md` files. Exclude matches inside code blocks and quoted user input.

</validation>
