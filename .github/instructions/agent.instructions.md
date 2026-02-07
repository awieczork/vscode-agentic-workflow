---
applyTo: ".github/agents/**"
description: "Structure and safety patterns for agent artifact files"
---

This file defines structural patterns for agent artifacts — behavioral frames that give agents persistent identity, safety constraints, and deterministic error recovery. Apply `<artifact_structure>` for body organization, `<safety_patterns>` for constraint enforcement, and `<stopping_rules>` for termination logic.


<artifact_structure>

<rules>

- Name workflow phases as `<phase_N_name>` and skill steps as `<step_N_verb>` — numbered prefix enables iteration, suffix provides context
- Wrap all phases within a parent `<workflow>` tag
- Include 3-5 diverse examples per complex task using Wrong/Correct pairs

</rules>

<justification>

Agent workflows require programmatic iteration over behavioral stages. Numbered naming enables `for i in 1..N` patterns while retaining semantic meaning. Without parent `<workflow>` wrappers, phases float as disconnected blocks.

</justification>

<benefit>

The agent iterates phases programmatically while retaining human-readable semantics.

</benefit>

<anti_patterns>

- Wrong: `<explore>`, `<decide>`, `<implement>` (unnumbered, no parent wrapper) → Correct: `<workflow>` containing `<phase_1_explore>`, `<phase_2_decide>`, `<phase_3_implement>`

</anti_patterns>

</artifact_structure>


<safety_patterns>

<rules>

- Structure iron laws with: statement (what must never happen), red flags (warning signs of approaching violation), rationalization counters (counter-responses to self-justification)
- Format error handling as `<if condition="error_type">` followed by deterministic action

</rules>

<justification>

Iron laws prevent the "this time is different" reasoning that causes constraint violations. The three-part structure (statement → red flags → rationalization counters) catches the agent before violation, not after. Explicit condition-action pairs make error recovery deterministic — lookup, not reasoning.

</justification>

<benefit>

The agent catches itself before violating absolute constraints and recovers from errors through pattern matching.

</benefit>

<anti_patterns>

- Wrong: "Never edit source code." (statement only, no red flags) → Correct: "NEVER edit source code. Red flags: editing `src/`, `lib/`, `app/`. Rationalization: 'It's a small fix' → Architect plans, @build executes."
- Wrong: "If something goes wrong, handle the error." (vague) → Correct: `<if condition="3_consecutive_errors">` Pause execution. Summarize progress. Ask user. `</if>` (deterministic)

</anti_patterns>

</safety_patterns>


<stopping_rules>

<rules>

- Define handoff triggers separately from escalation triggers — handoff passes work to another agent; escalation pauses for human input
- Report errors using the standard format: `status` | `error_code` | `message` | `recovery` (as defined in `<error_reporting>` in `copilot-instructions.md`)

</rules>

<justification>

Separate triggers prevent confusion between "give this to someone else" (handoff) and "stop and get help" (escalation). Mixed triggers cause the agent to halt when it should delegate, or delegate when it should halt.

</justification>

<benefit>

The agent distinguishes delegation from interruption and terminates through explicit triggers rather than ambiguous judgment.

</benefit>

<anti_patterns>

- Wrong: "If you can't do it, stop or hand off." (merged triggers) → Correct: "Handoff: implementation needed → @build. Escalation: 3 consecutive errors → stop, summarize, ask user." (separate triggers)

</anti_patterns>

</stopping_rules>
