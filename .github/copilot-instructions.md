Knowledge base and generation pipeline for VS Code agentic frameworks.

<references>

These references support consistent creation of skills, instructions, and prompts.

<official_documentation>

Use #tool:fetch to link to official documentation.

- https://code.visualstudio.com/docs/copilot/customization/custom-agents - agents
- https://code.visualstudio.com/docs/copilot/customization/prompt-files - prompts 
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions - instructions
- https://code.visualstudio.com/docs/copilot/customization/agent-skills - skills
- https://agentskills.io/specification - skills open format specification

</official_documentation>

<inspirations>

Use #tool:githubRepo to link to community resources and inspiration.

- anthropics/skills - anthropic skills repo
- github/awesome-copilot - community collection of skills, custom agents, instructions, and prompts

</inspirations>

<instructions>

**Formatting:** [prompting.instructions.md](instructions/prompting.instructions.md)
**Style:** [artifact-style.instructions.md](instructions/artifact-style.instructions.md)
**Creator skills:** [creator-skill-patterns.md](../knowledge-base/references/creator-skill-patterns.md)

</instructions>

</references>

<workflow_protocol>

**Phase transitions:** Use `[Status]. [Next action].` pattern between workflow phases.

**Gates:**
- **HARD** — Stop and wait for user approval before proceeding
- **SOFT** — Warn and continue unless user intervenes

**Iteration defaults:** Agent proposes iteration count, user approves or adjusts. Do not loop indefinitely.

</workflow_protocol>

<collaboration_patterns>

**Context discovery:** When uncertain about requirements, ask "What do I need to succeed at this task?" to surface missing context, constraints, and success criteria.

**Governance signal:** When a pattern proves useful across 2+ artifacts, flag it as a candidate for extraction to shared reference.

</collaboration_patterns>
