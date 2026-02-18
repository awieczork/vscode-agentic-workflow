# Patterns Log

Patterns emerging from iterative refinement of agent artifacts. Each entry captures a convention discovered through hands-on polishing — not prescribed upfront.

---

- **Identity prose uses character voice, not functional description.** Describe how the agent *thinks and operates* rather than what it *is*. Short punchy sentences build personality through rhythm. The agent's mindset — what it prioritizes, what it treats as non-negotiable — communicates role more effectively than listing capabilities.

- **Constraint bullets use a three-layer structure: principles → domain guardrails → HALT.** Layer 1: positive-framing principles (2-3 bullets) that absorb multiple safety rules into mindset statements. Layer 2: domain-specific NEVER/ALWAYS (4-7 bullets) unique to this agent's specialization — these justify the agent's existence. Layer 3: HALT (1 bullet) for emergency stops, always last. This structure applies to all agents — core and domain alike.

- **Agents must be self-contained — no inheritance assumed.** Every agent is spawned with a clean context window. It never sees other agents or prior context. Every safety rail, every interface contract, every behavioral constraint must be present in the agent's own body. Positive-framing principles are the mechanism for absorbing generic constraints without bloating the bullet list.

- **Workflow steps use the agent's domain language, not orchestration protocol.** Each subagent is written from its own perspective — it does not know it is part of a larger orchestration model. Step names should feel natural to a practitioner of that domain — a developer *understands* and *implements*, a researcher *investigates* and *synthesizes*. Orchestration verbs like "parse," "execute," and "report" belong to the coordinator, not the agent.

- **Coding standards belong in `.instructions.md`, not in the agent body.** Language- and framework-specific conventions are *how to write code in that ecosystem* — they apply to any agent touching those files, not just one specialized agent. Agent bodies contain *how to behave* — identity, workflow, interface contract, and behavioral guardrails. The agent loads instructions when provided with the task — it doesn't hardcode references to specific instruction files.

- **Agents code against documentation, not memory.** Before doing the work, the agent identifies external tools, libraries, and APIs the task touches, then looks up current docs via `#tool:context7` or `#tool:web`. LLM training data goes stale — documentation doesn't. This is a tool-usage discipline: discover what you're working with, read its docs, then act.

- **Workflow describes craft; interface contract describes communication.** Session IDs, BLOCKED status codes, and build summary formats are *interface protocol* — how the agent communicates results back. They belong in the output template and constraint bullets, not in the workflow narrative. The workflow describes *how to do the work* in domain terms: understand the task, orient in the codebase, implement, test, deliver. Mixing protocol into workflow breaks the agent's self-perspective.

- **State principles, not enumerations.** Constraint bullets, workflow steps, and identity prose should express durable principles rather than listing specific tools, files, or commands. Principles survive tool changes; enumerations tie the agent to today's ecosystem. "Find the project's configuration" lets the agent discover what's there; naming specific files assumes a setup. Let the agent be the expert who discovers the environment.

- **Only @brain holds the full picture — subagents are independent contractors.** @brain is the ORCHESTRATOR: it sees the pipeline, knows every agent, routes tasks. Subagents know nothing about each other, the delegation chain, or the orchestration model. They receive a task, do their craft, deliver results. Agent bodies never reference "@brain", "the orchestrator", "spawn prompts", or sibling agents. Output conventions (build summary, BLOCKED status) exist because they're professional delivery practice — not because "the orchestrator expects it."

- **`copilot-instructions.md` owns project context; agents own domain expertise.** Agent bodies are project-agnostic and portable — they describe *how to practice a craft*, not *how this specific project works*. Project-specific facts (toolchain choices, version targets, env setup, build commands) live in `copilot-instructions.md`, which loads automatically for every agent. This is why agents generalize instead of enumerating — the project context fills in the specifics.

- **Extend before creating.** When implementing, check whether existing code already handles part of the task — adjust or extend what's there before adding new files or modules. But don't turn a task into a refactor — improve locally, stay within scope. This applies to the agent itself too: prefer folding new guidance into existing sections over creating new XML tags.

- **Domain XML sections must earn their keep.** If a section's content can be absorbed into constraint bullets or workflow steps without loss, it doesn't need its own XML tag. Separate sections are for structurally distinct content — tables, templates, examples — not for restating principles in longer form.

- **Output templates use conditional fields.** Interface fields like Session ID and task ID may or may not arrive with the task. Templates use `{echo if provided}` / `{task ID if provided}` to stay flexible without assuming protocol structure. The agent echoes what it received — it doesn't demand fields it wasn't given.

- **Skills instruct, they don't act.** A skill is a recipe, not a chef — it guides the AI through a process but does not perform the work itself. Prose voice is imperative ("Follow these steps to create…") not declarative ("This skill generates…"). The subject is the AI agent executing the skill, not the skill document. Descriptions follow the same rule: "Guides creation of…" not "Creates…".

- **Artifacts must be self-contained — no external file references.** Skills, agents, and other artifacts can only reference files within their own folder. A skill that points to files outside its directory tree creates a fragile dependency and breaks portability. If content is needed, embed it — don't link to it. Runtime workspace reads (searching for project files during execution) are acceptable when paired with a fallback to internal references.

- **Descriptions are semantic triggers, not metadata.** VS Code matches descriptions to user intent via LLM semantic similarity — not exact string matching. Descriptions must use the words users actually say ("create an agent") not framework jargon ("extend core archetypes"). Follow the three-part formula: what it does, when to use it (2-4 quoted trigger phrases), and what it produces. Keywords are semantic anchors that increase match probability.

- **User requests are problems to decompose, not tasks to execute.** When the orchestrator receives "Create X" or "Fix Y", the action is to identify the problem, select the right specialist, and delegate — never to attempt the work directly. This principle prevents the coordinator from drifting into implementation. Every user-facing verb maps to a delegation decision, not a tool call.
