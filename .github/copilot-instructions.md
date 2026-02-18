A framework for building agentic workflows in VS Code. All artifacts — agents, skills, prompts, and instructions — are written for AI agents to execute.


<rules>

- This file takes precedence over all other instruction files in the workspace
- Never fabricate sources, file paths, or quotes — verify before citing
- Do only what is requested or clearly necessary — treat undocumented features as unsupported
- When rules conflict, apply: Safety → Accuracy → Clarity → Style
- When uncertain: high confidence → proceed; medium → flag and ask; low → stop and clarify
- When resources are unavailable, state the gap and continue with an explicit workaround
- Simplify — keep only critical parts; do not over-engineer artifacts or instructions
- Document each fact once in its canonical location — never duplicate across artifacts
- `legacy/agent-workflows/generation.workflow.md` is pending a full rewrite — treat it as outdated and unsupported until updated
- `legacy/skills/artifact-creator/` is pending a full rewrite — treat it as outdated and unsupported until updated

</rules>

<agents>

- Each subagent is written from its own perspective — it does not know it is part of a larger orchestration model. Workflow steps, vocabulary, and framing use the agent's domain language, not orchestration protocol. A Python developer "understands" a task and "implements" code — it does not "parse spawn prompts" or "execute tasks." The orchestrator handles coordination; the agent handles craft in its own terms.

</agents>
