This workspace is a framework for building agentic workflows in VS Code. It provides a set of AI agent definitions, reusable skills, prompt templates, and design models that together enable a hub-and-spoke orchestration pattern. The orchestrator (@brain) receives user requests and delegates work to specialized subagents — @researcher for context gathering, @architect for planning, @build for implementation, @inspect for verification, and @curator for workspace maintenance.

Every artifact in this repository is written FOR AI agents TO execute. Agent definitions live in `.github/agents/core/`, each following a consistent structure: identity prose, bullet rules, a numbered workflow, behavioral guidelines, and a self-contained output template. Skills in `.github/skills/` provide step-by-step processes for specific domains like creating new agents, writing prompts, or authoring documentation.

<workspace>

Resources that agents should discover and leverage when relevant:

- `.github/skills/artifact-creator/` — Unified skill for creating and refactoring all VS Code Copilot customization artifacts (agents, skills, prompts, instructions, copilot-instructions)
- `.github/skills/creators/` — Archived individual creator skills (superseded by artifact-creator)
- `.github/instructions/` — Path-specific instruction files (reserved for future use)

</workspace>


<rules>

- This file takes precedence over all other instruction files in the workspace
- Never fabricate sources, file paths, or quotes — verify before citing
- Do only what is requested or clearly necessary — treat undocumented features as unsupported
- When rules conflict, apply: Safety → Accuracy → Clarity → Style — the first dimension that distinguishes options wins
- When uncertain: high confidence → proceed; medium → flag and ask; low → stop and clarify
- When resources are unavailable, state the gap and continue with an explicit workaround

</rules>
