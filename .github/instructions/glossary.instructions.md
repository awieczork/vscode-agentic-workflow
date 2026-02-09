---
applyTo: "**"
description: "Canonical vocabulary and term definitions for consistent AI agent communication"
---

This file defines canonical vocabulary for all AI agent artifacts in this repository. The governing principle is: one term per concept — aliases fragment understanding and create inconsistency across files. Begin with `<constraints>` for usage obligations, then reference `<canonical_terms>` for definitions and prohibited aliases. Consult `<validation>` for automated detection of non-canonical usage.


<constraints>

- Use only canonical terms defined in `<canonical_terms>` across all artifacts — applies to prose and definitions; XML tag names follow `<xml_system>` in `structure.instructions.md`
- Understand aliases in user input but respond with canonical terms only
- Consult **Conflicts** entries when terms overlap in meaning — prevents misapplication of related terms

</constraints>


<canonical_terms>

<term id="error">

`error` — Unexpected condition preventing normal execution

**Aliases** — failure, exception, fault, problem, bug, defect

**Conflicts** — `issue`: Issue implies a trackable item; error implies a runtime condition

</term>

<term id="rule">

`rule` — Enforceable behavioral instruction within a named group

**Aliases** — guideline, policy, directive

</term>

<term id="constraint">

`constraint` — Hard limit that cannot be exceeded — an obligation

**Aliases** — restriction, limitation

**Conflicts** — `boundary`: Boundary defines capability limits (what MAY be accessed); constraint defines obligation limits (what MUST be obeyed)

</term>

<term id="agent">

`agent` — Autonomous executor with identity and boundaries

**Aliases** — assistant, bot, AI

</term>

<term id="skill">

`skill` — Reusable multi-step process with validation

**Aliases** — procedure, workflow, recipe

</term>

<term id="prompt">

`prompt` — Parameterized instruction with variable slots

**Aliases** — template, query, request

</term>

<term id="instruction">

`instruction` — Collection of rules applying to file patterns

**Aliases** — guidance, rule-set, directive-file

</term>

<term id="artifact">

`artifact` — Any generated or modified content

**Aliases** — document, output

</term>

<term id="handoff">

`handoff` — Structured payload passing work to another agent

**Aliases** — delegation, transfer, dispatch, route

**Conflicts** — `escalate`: Escalate interrupts for human input; handoff passes work to another agent

</term>

<term id="escalate">

`escalate` — Interrupt execution to request human input

**Aliases** — interrupt

**Conflicts** — `handoff`: Handoff passes work to another agent; escalate pauses for human decision

</term>

<term id="fabricate">

`fabricate` — Produce unverified claims without evidence

**Aliases** — hallucinate, invent

</term>

<term id="mode">

`mode` — Named behavioral configuration within an agent

**Aliases** — behavior-set

**Conflicts** — `phase`: Phase is a lifecycle stage (when); mode is a behavioral configuration (how)

</term>

<term id="context">

`context` — Information acquired and held during a session

**Aliases** — loaded-data

</term>

<term id="boundary">

`boundary` — Capability limit defining what an agent may access or modify

**Aliases** — fence, guardrail

**Conflicts** — `constraint`: Constraint defines obligation limits (what MUST be obeyed); boundary defines capability limits (what MAY be accessed)

</term>

<term id="phase">

`phase` — Lifecycle stage in agent execution

**Aliases** — stage

**Conflicts** — `mode`: Mode is a behavioral configuration (how); phase is a lifecycle stage (when)

</term>

<term id="tool">

`tool` — External capability invoked by the agent

</term>

<term id="workspace">

`workspace` — Scope of file operations and agent context

</term>

</canonical_terms>


<validation>

Grep pattern to detect non-canonical alias usage across `.github/**/*.md`:

```
failure|exception|fault|problem|bug|defect|guideline|policy|directive|restriction|limitation|assistant|bot|procedure|workflow|recipe|guidance|rule-set|directive-file|delegation|transfer|dispatch|route|interrupt|hallucinate|invent|behavior-set|loaded-data|fence|guardrail
```

**Excluded from pattern** — Common English words that produce false positives: pass, break, function, command, project, repository, codebase, state, limit, stage, stop, pause, ask, template, query, request, document, output, capability. Review these manually when violations are suspected.

**Usage:** Apply pattern against `.github/**/*.md` files. Exclude matches inside code blocks and quoted user input.

</validation>
