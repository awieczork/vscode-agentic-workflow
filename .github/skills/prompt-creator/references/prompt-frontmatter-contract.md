This file defines YAML frontmatter fields for `.prompt.md` files. The governing principle is action-oriented discovery — every field either enables `/` command matching or configures prompt execution context. Wrap all string values in single quotes.


<frontmatter_fields>

- `description` — string, required. Short description for `/` command discovery. Verb-first, 50-150 chars. Drives task-relevance matching when users type `/` in chat. Derive from prompt purpose — rephrase as imperative action per `<description_rules>`. Single-line only
- `name` — string, optional. Name shown after `/` in chat input. If omitted, then VS Code derives from filename. Use camelCase or lowercase-with-hyphens. Single-line only
- `agent` — string, optional. Target custom agent for running the prompt. If omitted, then uses the current agent. Never use built-in agent names (`ask`, `edit`, `agent`). See `<agent_mode_guidance>` for selection rules
- `argument-hint` — string, optional. Hint text shown in the chat input field to guide user interaction. Derive from the prompt's expected input. Single-line only
- `tools` — array, optional. Restricts tool availability for the prompt. Example: `tools: ['codebase', 'terminal']`. When omitted, the agent's default tools apply
- `model` — string, optional. Specifies the LLM model to use. Example: `model: 'claude-sonnet-4'`. When omitted, uses the agent's default model

</frontmatter_fields>


<description_rules>

**Length:** 50-150 characters. **Style:** Verb-first, specific, action-oriented.

- Correct: `'Generate comprehensive test cases for selected code'` — Specific task, clear scope
- Correct: `'Perform a REST API security review and list issues'` — Action + output shape
- Correct: `'Scaffold a React form component from design system templates'` — Clear deliverable
- Wrong: `'Help with testing'` — Vague, no specific action
- Wrong: `'A prompt for code review'` — Noun-first, passive
- Wrong: `'This prompt generates tests and also reviews code quality and suggests refactoring'` — Multi-task, too long

</description_rules>


<agent_mode_guidance>

Select `agent` field based on task characteristics. Only two options exist — omit the field or specify a custom agent name.

- **Omit** — Works with any agent. Most common for general-purpose prompts. The current agent handles the prompt
- **Custom agent name** — Designed for a specific custom agent. Use when the prompt relies on that agent's identity, instructions, or specialized behavior. Example: `agent: 'architect'`, `agent: 'test-engineer'`

Never use built-in agent names (`ask`, `edit`, `agent`) in the `agent` field.

</agent_mode_guidance>
