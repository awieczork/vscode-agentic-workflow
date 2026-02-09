---
applyTo: "**"
description: "Canonical vocabulary and term definitions for consistent AI agent communication"
---

This file defines canonical vocabulary for all AI agent artifacts. The governing principle is: one term per concept — aliases fragment understanding and create inconsistency across files. Begin with `<constraints>` for usage obligations, then reference `<canonical_terms>` for definitions and prohibited aliases. Consult `<validation>` for automated detection of non-canonical usage.


<constraints>

- Use only canonical terms defined in `<canonical_terms>` across all artifacts — applies to prose and definitions; XML tag names follow `<xml_system>` in structure instructions
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

`rule` — Enforceable behavioral statement within a defined section

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

<term id="artifact">

`artifact` — Any generated or modified content

**Aliases** — document, output

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
failure|exception|fault|problem|bug|defect|guideline|policy|directive|restriction|limitation|assistant|bot|loaded-data|fence|guardrail
```

**Excluded from pattern** — Common English words that produce false positives: document, output, pass, break, function, command, project, repository, codebase, state, limit, stop, pause, ask, capability. Review these manually when violations are suspected.

**Usage:** Apply pattern against `.github/**/*.md` files. Exclude matches inside code blocks and quoted user input.

</validation>
