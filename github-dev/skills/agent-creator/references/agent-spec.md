Structural specification for agent artifacts (`.agent.md`). Covers frontmatter fields, body structure, positioning conventions, and design principles. Agent-only — no other artifact types.


<frontmatter>

Agent frontmatter is YAML between `---` fences. All string values use single quotes. Only `description` is required — all other fields have sensible defaults.

| Field | Type | Required | Description |
|---|---|---|---|
| `description` | string | yes | Brief description shown as placeholder in chat input. Drives discovery — include trigger words. Max 1024 chars |
| `name` | string | no | Agent name in dropdown. Lowercase alphanumeric + hyphens. Derived from filename if omitted |
| `tools` | string[] | no | Tool or tool-set names. See tool sets below |
| `model` | string | strongly recommended | LLM model. Example: `'claude-sonnet-4'` |
| `target` | string | no | Restrict to VS Code interface: `'cli'` or `'editor'` |
| `user-invokable` | boolean | no | Default `true`. Set `false` to hide from user selection (sub-agent only) |
| `disable-model-invocation` | boolean | no | When `true`, agent is only user-invokable, never auto-selected by model |
| `agents` | string[] | no | Restricts which sub-agents this agent can invoke. Example: `['researcher', 'build']` |
| `mcp-servers` | string[] | no | MCP server names to enable. Example: `['github', 'filesystem']` |
| `handoffs` | object[] | no | Suggested next-action buttons to transition between agents (VS Code 1.106+) |
| `argument-hint` | string | no | Hint text in chat input guiding user interaction |

**Handoff objects:** Each entry requires `label` (button text) and `agent` (target identifier). Optional: `prompt` (text sent to target), `send` (boolean, default `false` — auto-submit on handoff).

**Tool sets**

| Set | Includes |
|---|---|
| `search` | `codebase`, `searchSubagent`, `textSearch`, `fileSearch`, `listDirectory`, `searchResults`, `usages`, `changes` |
| `read` | `readFile`, `problems`, `terminalLastCommand`, `terminalSelection`, `getNotebookSummary` |
| `edit` | `createDirectory`, `createFile`, `createJupyterNotebook`, `editFiles`, `editNotebook` |
| `execute` | `runInTerminal`, `getTerminalOutput`, `awaitTerminal`, `killTerminal`, `createAndRunTask`, `runNotebookCell`, `runTests`, `testFailure`, `memory` |
| `agent` | `runSubagent` |
| `web` | `fetch`, `githubRepo` |
| `vscode` | `askQuestions`, `extensions`, `vscodeAPI`, `newWorkspace`, `getProjectSetupInfo`, `runCommand`, `installExtension`, `openSimpleBrowser`, `switchAgent` |

Standalone tools (not in any set): `todo`, `renderMermaidDiagram`, `context7/*` (MCP).

**Tool selection guidance**

- Use a tool set when the agent needs the full capability group
- Use individual tools to enforce boundaries (e.g., `readFile` without `codebase`)
- Combine freely: `tools: ['search', 'editFiles', 'runInTerminal']`
- Select the minimal set for the role — excess tools dilute focus

</frontmatter>


<body_structure>

Agent bodies follow a fixed sequence: identity prose → constraint bullets → `<workflow>` → domain XML tags → output template. No markdown headings (`#`) in the body.

**Identity prose** — 2-4 sentences of bare prose (no XML wrapper). First sentence declares the role in second person with an em-dash: "You are the X — a [role description]." Second sentence states a governing principle. Optional third sentence expands scope. Identity prose establishes personality and focus — keep it tight and declarative.

**Constraint bullets** — Immediately after identity prose, 5-10 bare bullets (no wrapping tag). Three layers:

1. Positive-framing principles (2-3 bullets) — absorb multiple safety rules into mindset statements
2. Domain-specific NEVER/ALWAYS (4-7 bullets) — unique to this agent's specialization, these justify the agent's existence
3. HALT (1 bullet, always last) — emergency stop for security-sensitive conditions (credentials, secrets, PII)

Bullets are imperative and binary — no hedging, no "try to", no "should."

**`<workflow>`** — Required. Opens with a prose paragraph describing the agent's execution model: stateless reception, what arrives in the task, tool priority, and what to do when context is missing. Followed by numbered steps:

- Format: `1. **Verb** — What this step does`
- Steps use the agent's domain language, not orchestration protocol
- Each step is 2-5 lines: what to do, what tools to use, what to produce
- Include decision points inline: "If X, return BLOCKED"

**Domain XML tags** — After `<workflow>`, add 1-4 XML tags named for the agent's domain. These are NOT from a fixed vocabulary — names are self-explanatory and domain-specific. Examples: `<build_guidelines>`, `<severity>`, `<verdicts>`. Content is prose and bullets — guidelines, decision rules, or domain knowledge the agent needs. A section must earn its keep: if its content can be absorbed into constraint bullets or workflow steps without loss, it doesn't need its own tag.

**Output template** — A dedicated XML tag (e.g., `<build_summary_template>`, `<findings_template>`) containing the agent's required output format. Structure: prose intro, then a fenced code block with Status / Session ID / Summary header followed by structured sections. Include a "When BLOCKED" variant. Close with an `<example>` sub-tag containing a realistic fenced code block. The output template is the agent's delivery contract — it must be machine-parseable and consistent.

</body_structure>


<positioning>

Domain agents extend the core agent pool as specialized alternatives. They follow the `{domain}-{core-role}` naming pattern — the domain prefix describes the specialization, the suffix maps to the core role being extended. Examples: `python-developer`, `security-inspector`, `api-planner`, `docs-curator`.

**Role definition** — Define the agent's role relative to a core agent. A `python-developer` replaces `developer` for Python projects; a `security-inspector` extends `inspector` with security focus. Include selection criteria in the identity prose or guidelines — when the orchestrator should prefer this agent over the core alternative.

**Interface contract** — Domain agents inherit the interface contract of the core agent they extend. Follow the same output patterns so routing is seamless:

| Inherited element | Override when |
|---|---|
| Status codes (`COMPLETE` / `BLOCKED` / `PARTIAL`) | Never — orchestrator depends on these |
| Session ID echo | Never — required for tracking |
| Output template structure | Only to add domain-specific sections |
| Workflow step format | Only when domain steps differ significantly |
| Constraint bullet style | Only to add domain-specific constraints |

**Self-containment** — Every agent is spawned with a clean context window. It never sees other agents or prior context. Every safety rail, interface contract, and behavioral constraint must be present in the agent's own body.

**Cross-agent references** — Subagents never reference other agents by name (`@developer`, `@researcher`). They focus on their own task. When describing delegation, use role descriptions ("the orchestrator", "the implementing agent") not `@`-prefixed names. Only the brain/orchestrator agent may reference subagents by name. Agent bodies never mention "spawn prompts", "the orchestrator", or sibling agents — output conventions exist because they're professional delivery practice, not because an orchestrator expects them.

</positioning>


<design_guidelines>

Principles that govern well-crafted agent artifacts. These are not a checklist — they are the design philosophy behind every decision.

**Voice over function** — Identity prose uses character voice, not functional description. How the agent thinks and operates communicates role more effectively than listing capabilities. Short punchy sentences build personality through rhythm.

**Layered constraints** — Constraint bullets follow a three-layer structure: positive-framing principles that absorb generic safety rules into mindset statements, domain-specific NEVER/ALWAYS rules unique to the specialization, and a final HALT rule for emergency stops.

**Self-contained agents** — Every agent is spawned into a clean context window with no knowledge of other agents or prior context. Every rail, contract, and constraint must live in the agent's own body. Positive-framing principles absorb generic constraints without bloating the bullet list.

**Domain vocabulary in workflows** — Workflow steps use the agent's domain language, not orchestration protocol. A developer understands and implements; a researcher investigates and synthesizes. The agent is written from its own perspective — it doesn't know it's part of a larger system.

**Separation of concerns** — Coding standards and language conventions belong in `.instructions.md`, not in the agent body. Agent bodies contain how to behave — identity, workflow, interface contract, guardrails. The agent loads instructions when they arrive with the task.

**Documentation over memory** — Before doing work, the agent identifies external tools, libraries, and APIs the task touches, then looks up current docs. LLM training data goes stale — documentation doesn't. This is a tool-usage discipline baked into the workflow.

**Craft vs. protocol** — Workflow describes how to do the work in domain terms. Session IDs, status codes, and output formats are interface protocol — they belong in the output template and constraint bullets, not in the workflow narrative.

**Principles over enumerations** — Constraint bullets, workflow steps, and identity prose express durable principles rather than listing specific tools, files, or commands. Principles survive tool changes; enumerations tie the agent to today's ecosystem. Let the agent discover the environment.

**Independent contractors** — Subagents know nothing about each other, the delegation chain, or the orchestration model. They receive a task, do their craft, deliver results. Output conventions exist because they're professional delivery practice.

**Project context lives elsewhere** — Agent bodies are project-agnostic and portable. They describe how to practice a craft, not how a specific project works. Project-specific facts live in `copilot-instructions.md`, which loads automatically.

**Extend before creating** — When implementing, check whether existing content already handles part of the task. Adjust or extend before adding new sections. But don't turn a task into a refactor — improve locally, stay within scope.

**Sections earn their keep** — If a domain XML section's content can be absorbed into constraint bullets or workflow steps without loss, it doesn't need its own tag. Separate sections are for structurally distinct content — tables, templates, examples.

**Conditional output fields** — Interface fields like Session ID and task ID may or may not arrive with the task. Templates use `{echo if provided}` / `{task ID if provided}` to stay flexible without assuming protocol structure. The agent echoes what it received.

</design_guidelines>
