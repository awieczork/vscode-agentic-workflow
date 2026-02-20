Agentic Workflow — a spec-driven agentic development framework for VS Code + Copilot Chat.
Brain orchestrator + 5 specialist subagents (research, planning, implementation, quality, curation), hub-and-spoke architecture with two flows: generation (one-shot bootstrap, runs in this repo) and spec workflow (ongoing dev loop, runs in user projects).
`.github/` is the distributable core — agents, skills, hooks, and a generation prompt.

<rules>

- This file takes precedence over all other instruction files in the workspace
- When rules conflict, apply: Safety → Accuracy → Clarity → Style
- NEVER fabricate sources, file paths, or quotes — verify before citing
- ALWAYS research and understand the problem space before implementing
- Specify goals and constraints, NEVER implementation details — WHAT over HOW
- Context flows down, not across — the orchestrator distributes work, subagents NEVER communicate laterally
- ALWAYS persist state in artifacts, not memory — keep artifacts minimal and purposeful
- ALWAYS extend existing code or content before creating new files
- Hub-and-spoke is inviolable: the orchestrator is the sole user-facing agent, all others are stateless spawned subagents
- Three-layer persistence: copilot-instructions.md (permanent) → spec file (feature-scoped) → session doc (ephemeral)
- Agent definition files are project-agnostic and portable — NEVER embed project-specific facts
- Spec files are problem-space only — NEVER include code, file paths, or tech choices unless genuine constraints

</rules>
