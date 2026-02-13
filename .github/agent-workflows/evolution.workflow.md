---
description: 'Evolution workflow — adaptive interview to add or modify project artifacts using creator skills'
triggers: ['evolution']
phases: ['assess', 'interview', 'research', 'plan', 'build', 'adapt', 'verify']
---

This workflow enables incremental evolution of a working project by adding new artifacts or modifying existing ones. The governing principle is: understand the current state before changing it — assess what exists, clarify what the user needs, then apply targeted changes that preserve existing behavior.


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- SCOPE DEFINITION — what evolution supports and what it does not -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<scope_definition>

Evolution targets incremental changes to `.github/` artifacts in a working project. It handles additions and modifications — not removals or wholesale rewrites.

**Supported operations:**

- Add new artifacts — agents, skills, instructions, prompts
- Modify existing artifacts — update behavior, add capabilities, extend rules, adjust constraints, refine content

**Not supported:**

- Artifact removal — deleting agents, skills, instructions, or prompts from the project
- Core agent modifications — the 6 hub-and-spoke agents (brain, architect, build, inspect, curator, researcher) are immutable through this workflow
- Full copilot-instructions.md rewrites — minor updates like workspace map entries are handled by @curator during verification, but complete restructuring requires a separate process

When the user's request involves an unsupported operation, explain the boundary clearly and suggest alternatives:

- For removals: recommend manually deleting the file and asking @curator to sync cross-references
- For core agent changes: explain that hub-and-spoke agents are framework-level and changes risk breaking orchestration — suggest creating a domain agent that wraps the desired behavior instead
- For copilot-instructions.md rewrites: recommend running the generation workflow to produce a fresh project baseline

</scope_definition>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- ASSESSMENT — understand current state before interviewing -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<assessment>

@brain reads the current project state before engaging the user. This establishes baseline knowledge that shapes interview depth and prevents redundant questions.

<project_scan>

1. Load `copilot-instructions.md` — extract workspace structure, existing agents, project context, tech stack, development commands, environment context
2. Load `.curator-scope` — identify edit boundaries and excluded paths
3. Inventory current artifacts:
   - Agents in `agents/` — list names, profiles, and capabilities
   - Skills in `skills/` — list names and purposes
   - Instructions in `instructions/` — list names and applies-to patterns
   - Prompts in `prompts/` — list names and descriptions
4. Note any cross-references between artifacts — which agents reference which skills, which instructions target which file patterns

</project_scan>

<request_classification>

Parse the user's seed description from the `<change_request>` block and classify the request:

- `add-single` — one new artifact (e.g., "create a deployment agent")
- `add-multiple` — several related new artifacts (e.g., "create a testing skill and a test-standards instruction")
- `modify-single` — change to one existing artifact (e.g., "add a safety rule to the deploy agent")
- `modify-multiple` — changes across several existing artifacts (e.g., "update all agents to use the new logging convention")
- `mixed` — combination of adds and modifies (e.g., "create a monitoring agent and update the deploy agent to hand off to it")

The classification drives interview depth in `<adaptive_interview>`. When classification is ambiguous, default to the deeper interview path — over-clarifying is safer than under-clarifying.

</request_classification>

</assessment>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- ADAPTIVE INTERVIEW — depth scales with request complexity -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<adaptive_interview>

Interview depth adapts to the classification from `<assessment>`. Use `#tool:askQuestions` for all questions. Frame every question with at least 2 curated options plus a custom input option.

<minimal_interview applies_to="add-single, modify-single">

1-2 targeted clarifying questions to confirm understanding. Goal: fast confirmation, not deep exploration.

**For adds:**

- Confirm artifact type using the heuristic from [generation.workflow.md](generation.workflow.md) `<artifact_type_heuristic>` — present the classification with reasoning and ask the user to confirm or correct
- Ask about key capabilities or rules the artifact should encode
- Ask about safety constraints if the artifact involves mutations (file edits, command execution, deployments)

**For modifies:**

- Read the existing artifact file in full
- Present the current state and the proposed change: "Here is what the artifact currently does. You want to [change]. Is this correct?"
- Confirm what to change and what to preserve — explicit preservation prevents accidental overwrites
- If the modification could affect other artifacts that reference this one, surface those dependencies

Present a concise proposal summarizing the change, then get approval via `#tool:askQuestions`:

- Review the proposed change above.
  - A) Approve — proceed to implementation
  - B) Adjust — tell me what to change
  - C) Cancel — I changed my mind

</minimal_interview>

<deeper_interview applies_to="add-multiple, modify-multiple, mixed">

Multi-round interview for complex changes. Each round builds on the previous.

<round_1 name="Clarify each artifact">

For each artifact in the request:

- What does it do? Confirm purpose and scope
- How does it relate to existing artifacts in the project?
- For adds: what problem does it solve that existing artifacts do not?
- For modifies: what specifically is insufficient about the current state?

Frame as option-based questions grounded in the project scan results from `<assessment>`.

</round_1>

<round_2 name="Explore interactions">

How do the new or modified artifacts compose with what already exists?

- For new agents: apply profile assignment from [generation.workflow.md](generation.workflow.md) `<profile_assignment>` — select the archetype that matches behavioral shape
- Explore orchestration patterns if the changes affect agent relationships — does a new agent need to be wired into existing workflows? Does a modification change how agents hand off to each other?
- For new skills: which agents will invoke them? Are there instruction bindings needed?
- For new instructions: which agents and file patterns should they target?

</round_2>

<round_3 name="Safety and approval">

Probe for constraints and compile findings into a proposal.

- Are there new safety constraints this change introduces?
- Does this change affect any existing safety rules or iron laws?

Present the full proposal table (same format as [generation.workflow.md](generation.workflow.md) Round 3):

- Name — artifact name
- Type — agent, skill, prompt, or instruction
- Operation — `add` or `modify`
- Summary — one-line description of what is created or changed

Get approval via `#tool:askQuestions`:

- Review the proposed changes above.
  - A) Approve all — proceed to implementation
  - B) Remove some — tell me which to drop
  - C) Add more — describe what is missing
  - D) Modify — tell me what to change

Iterate until user approves.

</round_3>

</deeper_interview>

<pacing_checkpoint>

After completing the clarifying questions (minimal interview) or Round 1 (deeper interview), present via `#tool:askQuestions`:

- Before I draft the proposal — is there anything else about this change I should understand?
  - A) I'm good — move on to the proposal
  - B) I have more to share

**When the user selects B:** Ask novel follow-up questions targeting uncovered aspects — side effects on existing artifacts, edge cases, integration concerns with current orchestration, backward compatibility with artifacts that reference the changed files. Adapt each follow-up to what the user just shared. Repeat the checkpoint until the user selects A.

</pacing_checkpoint>

</adaptive_interview>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- FIELD COLLECTION — what data to collect per change type -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<field_collection>

Data collection adapts to whether the operation is an add or a modify.

<new_artifacts>

For new artifacts, collect fields per artifact type as defined in [generation.workflow.md](generation.workflow.md) `<field_collection>`. The same field sets apply — `<all_types>` for every artifact, plus type-specific fields (`<agent_fields>`, `<skill_fields>`, `<instruction_fields>`, `<prompt_fields>`).

</new_artifacts>

<modified_artifacts>

For modifications to existing artifacts:

1. Read the existing artifact file in full
2. Identify what specifically changes — which sections, fields, rules, or content blocks are affected
3. Collect only the delta:
   - Fields being added — new capabilities, new rules, new sections
   - Fields being changed — current value and new value
   - Fields being removed — which content to strip (with confirmation)
4. Preserve everything not explicitly targeted for change — structure, formatting, unchanged sections, cross-references

Document the delta as a change specification: `field: current → new` for each modification point. This specification feeds into the build step to ensure precise edits.

</modified_artifacts>

</field_collection>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- EVOLUTION ROUTING — post-approval execution pipeline -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<evolution_routing>

After interview approval, execute the evolution pipeline using core spokes. Steps run sequentially unless noted otherwise.

<step_1 name="Research">

Spawn @researcher instance(s) scoped to the specific change — NOT full project-wide research. Each researcher targets a focused area:

- **Current state analysis** — for modifications, read the existing artifact and its cross-references. Identify what depends on the artifact being changed and what the change might break
- **Tech-specific patterns** — for new capabilities being added, research best practices, conventions, and common pitfalls specific to the technology or domain
- **Breaking change detection** — for modifications, assess whether the change alters the artifact's contract with other artifacts. Surface any side effects the modification might introduce

Spawn researchers in parallel when multiple independent focus areas exist. Wait for all to complete before proceeding.

</step_1>

<step_2 name="Plan">

Send approved changes, research findings, and the change specification from `<field_collection>` to @architect. The plan specifies:

- Which creator skill per artifact — same mapping as generation (reference [generation.workflow.md](generation.workflow.md) `<skill_mapping>`)
- For new artifacts: standard creator skill execution with collected fields
- For modifications: read existing file → identify change points → apply changes preserving unchanged content. The plan includes the explicit delta from field collection
- Task dependencies — modifications to artifacts that reference each other must be ordered correctly
- If new domain agents are added: include a brain adaptation task (see `<step_4>`)

</step_2>

<step_3 name="Build">

Execute via @build instances, parallel where possible. Each @build instance receives only its assigned tasks from the plan.

- **New artifacts** — creator skill produces the file. Same skill mapping as generation: agent → agent-creator, skill → skill-creator, prompt → prompt-creator, instruction → instruction-creator
- **Modified artifacts** — @build reads the existing file, applies the planned changes from the delta specification, preserves structure and all unchanged sections. Modifications are surgical — only the targeted content changes

</step_3>

<step_4 name="Adapt">

Brain adaptation — runs ONLY when new domain agents are added. Skip this step entirely for modifications to existing artifacts or for non-agent additions.

When triggered:

1. Read the project's `brain.agent.md`
2. Locate the `<!-- DOMAIN_AGENT_POOL -->` marker — insert a new domain agent entry before it, following the 3-field pattern: Strengths, Tools, Leverage
3. Locate the `<!-- DOMAIN_SPAWN_TEMPLATES -->` marker — insert a spawn example for the new agent before it
4. Read the created domain agent file to extract capabilities, tools, and leverage patterns for the entries

If multiple new agents are added in a single evolution, batch all brain adaptation entries into one edit operation to maintain consistency.

</step_4>

<step_5 name="Verify">

@inspect verifies all created and modified artifacts against requirements from the approved proposal. Additionally check:

- **Cross-reference integrity** — no broken references introduced by additions or modifications. Every tag reference, file link, and agent mention resolves to an existing target
- **Backward compatibility** — modified artifacts maintain compatibility with existing orchestration patterns. Agents that previously referenced the modified artifact still function correctly
- **Brain wiring** — if new agents were added, verify they appear in `brain.agent.md` domain pool and spawn templates (from `<step_4>`)
- **Dependent artifact consistency** — existing artifacts that reference modified files still work correctly. If a modification changed a skill's interface, agents invoking that skill must be checked
- **Workspace sync** — @curator updates `copilot-instructions.md` workspace map entries and `.curator-scope` if new artifact paths were introduced

Findings route back through @brain for rework if needed.

</step_5>

</evolution_routing>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- OUTPUT FORMAT — what @brain presents after evolution completes     -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<output_format>

Present the evolution outcome to the user in this structure:

- **Session summary** — Session ID, number of rework cycles completed

- **Artifacts** — One row per artifact, as a table:
  - Path — file path relative to workspace root
  - Action — `Created` | `Modified`
  - Verification — `Passed` | `Failed` | `Skipped`

- **Verification outcome** — @inspect verdict (`Passed` | `Failed`), any notes or caveats from the inspection

- **Open items** — Items deferred or flagged during evolution that require future attention (or "None")

</output_format>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- SCOPE BOUNDARY — hard limits on what evolution touches -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<scope_boundary>

Evolution operates exclusively on `.github/` artifacts — agents, skills, instructions, prompts, and their supporting files (references, assets, templates).

**Evolution does NOT:**

- Modify project source code, tests, or infrastructure files
- Touch core agent definitions — brain, architect, build, inspect, curator, researcher are immutable through this workflow
- Rewrite copilot-instructions.md entirely — minor updates like adding a workspace map entry for a new artifact are handled by @curator during `<step_5>`, but structural changes to sections like `<constraints>` or `<decision_making>` are out of scope

**Source-code implications:** When the user's request implies changes to project source code (e.g., "create an agent that uses a new API endpoint"), surface implied source-code changes as actionable recommendations:

- File path where the change would be made
- Description of what needs to change
- Why the change is needed to support the new or modified artifact

Present these as a "Recommended source-code changes" section in the build summary. Do not execute them — the user or a separate workflow handles source-code modifications.

</scope_boundary>
