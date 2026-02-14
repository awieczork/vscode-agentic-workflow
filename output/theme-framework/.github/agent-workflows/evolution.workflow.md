---
name: 'evolution'
description: 'Evolution workflow guidance — assessment, adaptive interview, delta-based modification via @brain lifecycle'
version: '2.0.0'
tags: ['evolution', 'interview', 'artifact-modification', 'artifact-creation']
---

This workflow provides evolution-specific guidance that @brain applies during its standard lifecycle phases. Evolution is not a separate process — it is @brain orchestrating targeted additions and modifications through the same hub-and-spoke pattern used for all tasks. Each section maps to a @brain phase: assessment maps to orientation, interview maps to discovery, change planning maps to analysis, build directives map to execution, verification maps to inspection. Governing principle: understand the current state before changing it.


<assessment_guidance>

Establish baseline knowledge of the project before engaging the user. Assessment shapes interview depth and prevents redundant questions.


<project_scan>

@brain executes these steps before any user interaction:

1. Load the project's `copilot-instructions.md` — extract workspace map, agents, tech stack, development commands
2. Inventory current artifacts: agents (names, capabilities), skills (names, purposes), instructions (names, applyTo patterns), prompts (names, descriptions)
3. Note cross-references between artifacts — which agents reference which skills, which instructions target which file patterns, which prompts invoke which tools

</project_scan>


<request_classification>

Parse the user's `<change_request>` and classify into one of five types:

- **add-single** — one new artifact (e.g., "create a deployment agent")
- **add-multiple** — several related new artifacts (e.g., "create a testing skill and a test-standards instruction")
- **modify-single** — change to one existing artifact (e.g., "add a safety rule to the deploy agent")
- **modify-multiple** — changes across several existing artifacts (e.g., "update all agents to use the new logging convention")
- **mixed** — combination of adds and modifies (e.g., "create a monitoring agent and update the deploy agent to hand off to it")

Classification drives interview depth. When ambiguous, default to the deeper interview path — over-clarifying is safer than under-clarifying.

</request_classification>

</assessment_guidance>


<interview_guidance>

Drive an adaptive interview to clarify the change request. Use option-based questions — max 3 per batch, 2-5 options each. Pre-select one option as recommended where applicable.


<request_adaptive_depth>

Calibrate interview depth using two dimensions — request classification and seed richness:

- **add-single** or **modify-single** → minimal (1-2 targeted questions, fast confirmation)
- **add-multiple** or **modify-multiple** → standard (2-3 rounds, explore interactions between artifacts)
- **mixed** → deep (multi-round, explore interactions, safety implications, ordering)

Within each tier, adapt further based on the change request's richness:

- **Rich seed** (detailed description, specific files, clear constraints) — reduce rounds, confirm rather than explore
- **Thin seed** (vague scope, no specifics) — probe deeper, ask more rounds before moving to proposal
- **Medium seed** — standard depth for the tier

</request_adaptive_depth>


<question_patterns>

Frame every question with 2-5 curated options plus a custom input option.

For adds:

- Confirm artifact type using `<artifact_heuristic>` from [generation.workflow.md](generation.workflow.md) — present the classification with reasoning and ask the user to confirm or correct
- Ask about capabilities and constraints the artifact should encode
- Probe safety constraints for mutation-capable artifacts (file edits, command execution, deployments)

For modifies:

- Read the existing artifact file in full before asking questions
- Present the current state alongside the proposed change: "Here is what the artifact currently does. You want to [change]. Is this correct?"
- Confirm what to change versus what to preserve — explicit preservation prevents accidental overwrites
- Surface dependencies: identify other artifacts that reference or depend on the one being modified

For mixed:

- Address each artifact individually using the appropriate add or modify pattern above
- Then explore interactions between the planned changes — ordering, shared dependencies, potential conflicts

</question_patterns>


<proactive_suggestions>

After gathering context, suggest related changes grounded in assessment findings. Present as option-based questions with justification.

Examples:

- "Modifying agent X would also benefit from updating instruction Y that targets the same files"
- "Adding this skill would pair well with an instruction that enforces its conventions in the relevant file paths"
- "This agent modification changes its interface — the instruction that references it may need a corresponding update"

Each suggestion must map to a specific artifact with a one-line justification. The user selects which to include.

</proactive_suggestions>


<pacing_checkpoint>

After completing questions (minimal tier) or Round 1 (standard/deep tier), present:

- Before I draft the proposal — anything else I should understand about this change?
  - A) Move on to proposal
  - B) I have more to share

When the user selects B: ask follow-up questions targeting uncovered aspects — side effects on existing artifacts, edge cases, integration concerns with current orchestration, backward compatibility with artifacts that reference the changed files. Adapt each follow-up to what the user just shared. Repeat the checkpoint until the user selects A.

</pacing_checkpoint>


After all rounds complete, compile findings into a proposal table:

- **Name** — artifact name
- **Type** — agent, skill, instruction, or prompt
- **Operation** — `add` or `modify`
- **Summary** — one-line description of what is created or changed

Get explicit approval. Iterate until the user approves.

</interview_guidance>


<change_planning>

Translate the approved proposal into an executable specification. This section covers what evolution can touch, how to collect change data, and how to order multi-artifact changes.


<scope_boundaries>

What evolution can and cannot touch:

Supported operations:

- Add new artifacts — agents, skills, instructions, prompts
- Modify existing artifacts — update behavior, add capabilities, extend rules, adjust constraints, refine content

Not supported:

- **Artifact removal** — deleting agents, skills, instructions, or prompts
- **Core agent modifications** — brain, researcher, planner, builder, inspector, curator are immutable through this workflow
- **Full copilot-instructions.md rewrites** — minor updates like workspace map entries are handled by @curator during verification, but structural changes require the generation workflow

For unsupported operations, explain the boundary and suggest alternatives:

- Removal → recommend manual delete followed by @curator sync of cross-references
- Core agent changes → suggest creating a wrapping domain agent that extends the core agent's capabilities
- copilot-instructions.md rewrite → recommend the generation workflow

Evolution operates on `.github/` artifacts only — source-code implications are surfaced as recommendations, not executed.

</scope_boundaries>


<delta_specification>

How to collect change data for each operation type:

For new artifacts:

- Collect fields per artifact type: name, type, purpose, capabilities, constraints, relationships to existing artifacts
- Classification drives which fields are required — use `<artifact_heuristic>` from [generation.workflow.md](generation.workflow.md) for type determination

For modified artifacts:

1. Read the existing artifact file in full
2. Identify affected sections, fields, or rules
3. Collect only the delta: `field: current → new` for each modification point
4. Preserve everything not explicitly targeted for change — structure, formatting, unchanged sections, cross-references

The delta specification feeds into the build step for precise, surgical edits.

</delta_specification>


<dependency_ordering>

When multiple changes are approved, order execution correctly:

- Modifications to artifacts that reference each other must be sequenced — modify the dependency before the dependent
- New artifacts that reference each other: create the dependency first
- If a new agent needs wiring into @brain's agent pool: schedule brain adaptation after agent creation
- Independent changes can execute in parallel

</dependency_ordering>

</change_planning>


<build_directives>

Instructions for @brain when orchestrating artifact creation and modification. @builder is stateless — it receives WHAT to create or change, never HOW.


<handoff_pattern>

@builder uses the artifact-creator skill (`.github/skills/artifact-creator/SKILL.md`) for ALL artifact creation and modification. The skill handles classify-then-specialize — @builder does not need type-specific creation instructions.

Each artifact is a separate @builder handoff containing: artifact type, purpose, domain context, interview findings, and (for modifications) the delta specification from `<delta_specification>`.

For modifications: @builder reads the existing file, applies the planned delta, and preserves all unchanged structure. Modifications are surgical — only the targeted content changes.

</handoff_pattern>


<parallel_execution>

Batch independent @builder spawns into parallel execution:

1. **Phase 1** — Create or modify artifacts with no inter-dependencies (parallel)
2. **Phase 2** — Create or modify artifacts that depend on Phase 1 outputs (sequential within phase, parallel where possible)
3. **Phase 3** — Brain adaptation (only if new agents added), then @curator copilot-instructions.md update if new paths were introduced

@inspector runs after each phase. Findings route back through @brain for rework — @builder fixes only the flagged issues, then @inspector re-verifies.

</parallel_execution>


<brain_adaptation>

Runs ONLY when new domain agents are added. Skip entirely for modifications to existing artifacts or for non-agent additions.

When triggered:

1. Read the project's `brain.agent.md`
2. Add a new entry to the `<agent_pool>` section following the existing entry format — bold name, dash, capability description
3. Read the created domain agent file to extract capabilities for the entry
4. If multiple new agents are added in a single evolution, batch all entries into one edit operation

No injection markers are used — the entry is added to the `<agent_pool>` list directly, following the pattern of existing entries. For supplementary agent positioning guidance, reference `<supplementary_agent_positioning>` in [generation.workflow.md](generation.workflow.md).

</brain_adaptation>

</build_directives>


<verification_criteria>

What @inspector checks after each phase. Each criterion is binary — PASS or FAIL with specific details.


<artifact_quality>

- All artifacts follow framework conventions: XML tags (snake_case, domain-specific), canonical terms (constraint, skill, handoff, escalate, fabricate), no markdown headings inside artifact bodies
- YAML front-matter parses correctly with single-quoted string values
- No hardcoded secrets, credentials, or absolute paths
- Each artifact has a clear, non-overlapping purpose

</artifact_quality>


<cross_reference_integrity>

- No broken references introduced by additions or modifications
- Every tag reference, file link, and agent mention resolves to an existing target
- Existing artifacts that reference modified files still function correctly
- If a modification changed an artifact's interface, all dependents are checked and updated

</cross_reference_integrity>


<backward_compatibility>

- Modified artifacts maintain compatibility with existing orchestration patterns
- Agents that previously referenced modified artifacts still function correctly
- New agents appear in brain's agent pool (from `<brain_adaptation>`)
- @curator updates copilot-instructions.md workspace map if new paths were introduced

</backward_compatibility>


After verification passes, @brain presents the session outcome:

- **Session summary** — session ID, number of rework cycles completed
- **Artifacts table** — one row per artifact: path, action (`Created` | `Modified`), verification status (`Passed` | `Failed` | `Skipped`)
- **Inspection verdict** — @inspector overall verdict with any notes or caveats
- **Open items** — items deferred or flagged during evolution that require future attention, or "None"

</verification_criteria>
