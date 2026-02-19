An orchestration model for agentic workflows in VS Code. Core agents, coordinated by a central orchestrator, execute tasks across the development lifecycle; creator skills encode the methodology for authoring each artifact type. The model is generative — given a user's project context, it produces a tailored orchestration layer: project-specific instructions, domain agents, specialized skills, and scoped conventions. Core agents remain generic; all project specificity flows through generated artifacts. Core agents live in `.github/agents/core/`, creator skills in `.github/skills/`.


<rules>

- This file takes precedence over all other instruction files in the workspace
- When rules conflict, apply: Safety → Accuracy → Clarity → Style
- When uncertain: high confidence → proceed; medium → flag and ask; low → stop and clarify
- When resources are unavailable, state the gap and continue with an explicit workaround
- `legacy/` is pending a full rewrite — treat everything in it as outdated and unsupported until updated

</rules>

<behavior>

- Never fabricate sources, file paths, or quotes — verify before citing
- Do only what is requested or clearly necessary — treat undocumented features as unsupported
- Code against documentation, not memory — identify external tools, libraries, or APIs, look up current docs, then act
- Extend before creating — check whether existing code or content already handles part of the task; adjust or extend before adding new files

</behavior>

<authoring>

- Simplify — keep only critical parts; do not over-engineer artifacts or instructions
- Document each fact once in its canonical location — never duplicate across artifacts
- State principles, not enumerations — express durable rules rather than listing specific tools, files, or commands; let the agent discover the environment
- Artifacts must be self-contained — no static cross-references outside their own folder tree; runtime workspace reads are acceptable
- `copilot-instructions.md` owns project context; agents own domain expertise — project-specific facts live here, agent bodies are project-agnostic and portable
- Agent bodies address the agent in second person — write "you must", "your tools", not "the agent must" or "its tools"
- Markdown tables and headings (`#`) are reserved for user-visible output only — use XML tags as the primary structuring mechanism in all artifacts

</authoring>

<architecture>

- Hub-and-spoke: brain is the sole user-facing agent; all others are brain-spawned subagents that never interact with users
- Subagents are stateless task receivers — they accept a problem statement and return structured results
- User interaction patterns (questions, iterative refinement, handoffs) belong exclusively to brain
- Creator skills produce subagent artifacts only — never user-facing agents

</architecture>

<markdown_guidelines>

- Fenced code blocks and lists must be surrounded by blank lines
- URLs and paths to existing resources must use markdown link syntax — `[text](url)`; non-existing paths must use backticks — `` `path` ``
- Code blocks must specify a language
- Files must end with a single newline character
- Tag references — same-file: backticks only (`<tag_name>`); cross-file: backticks + markdown link (`<tag>` in [file.md](path))

</markdown_guidelines>
