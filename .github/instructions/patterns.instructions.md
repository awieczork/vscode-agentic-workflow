---
applyTo: "**"
description: "Behavioral patterns for AI agent generation"
---

# Behavioral Patterns

Reusable patterns for agent behavior, error handling, and delegation. Apply after `<critical_rules>` from [copilot-instructions.md](../copilot-instructions.md).

<tag_index>

**Sections in this file:**

- `<instruction_writing>` — Positive framing and prompt authoring
- `<tool_and_file_references>` — Syntax for referencing tools, agents, files
- `<avoid_overengineering>` — Simplicity principles
- `<context_management>` — File loading tiers and token budgets
- `<error_documentation>` — Error reporting format
- `<confidence_signaling>` — Uncertainty thresholds
- `<delegation_patterns>` — Agent handoff conventions
- `<self_validation>` — Pre-output verification
- `<tool_fallbacks>` — Graceful degradation when tools unavailable
- `<references>` — External documentation links

</tag_index>

<instruction_writing>

## Positive Framing

Tell the model what to do instead of what not to do.

<example>
- Instead of: "Do not use markdown in your response"
- Write: "Compose your response in flowing prose paragraphs"
</example>

## Tool Trigger Language

Use normal prompting language for tool triggers.

<example>
- Instead of: "CRITICAL: You MUST use this tool when..."
- Write: "Use this tool when..."
</example>

Modern LLMs respond well to direct instructions. Aggressive emphasis causes overtriggering.

## Specificity with Context

Provide context explaining WHY, not just WHAT.

<example>
- Instead of: "NEVER use ellipses"
- Write: "Avoid ellipses — text-to-speech engines cannot pronounce them"
</example>

</instruction_writing>

<tool_and_file_references>

**Tool reference (`#tool:`):**
- `#tool:<tool-name>` — Reference a tool by name
- Example: "Use #tool:fetch to retrieve web content"
- Example: "Use #tool:githubRepo to access repository data"
- Use when: Documenting which tools to use

**Agent reference (`@`):**
- `@agent-name` — Reference an agent
- Example: "Hand off to @architect for planning"
- Example: "@build executes approved plans"
- Use when: Describing agent handoffs or delegation

**Markdown links:**
If you refer to an existing file, **always** use markdown links:
- `[display text](relative/path.md)`

</tool_and_file_references>

<avoid_overengineering>

**Principle:** Make only changes that are directly requested or clearly necessary. Prefer simple, focused solutions.

**Anti-Patterns:**
- Adding "future-proofing" code not requested
- Creating abstractions for single-use cases
- Implementing features "while we're here"
- Adding configuration options without requirements
- Building frameworks when scripts suffice
- Preemptive optimization without measured need

**Validation Checks:**
- Does every change trace to a specific request?
- Can you remove any part without breaking requirements?
- Is this the simplest solution that works?
- Would a junior developer understand this in 5 minutes?

</avoid_overengineering>

<context_management>

## Loading Tiers

**HOT (always load first):**
- `copilot-instructions.md` — Global project rules
- Active session state files in `.github/memory-bank/sessions/`

**WARM (load when referenced):**
- Documentation files mentioned in conversation
- Source files under active investigation

**On missing files:** Note absence, continue with available context. State assumption if proceeding without expected file.

## Token Budget

Estimate artifact size before generation. For manifests with 10+ artifacts, summarize completed items to conserve context.

</context_management>

<error_documentation>

## Error Response Structure

When reporting errors, use this format:

- **status:** `success` | `partial` | `failed` | `blocked`
- **error_code:** kebab-case identifier (e.g., `file-not-found`, `validation-failed`)
- **message:** Human-readable explanation
- **recovery:** Suggested next action

## Severity Levels

- **P1:** Blocks completion — requires immediate fix
- **P2:** Degrades quality — should fix before delivery
- **P3:** Minor issue — optional improvement

</error_documentation>

<confidence_signaling>

## Confidence Thresholds

- **High (≥80%):** Proceed with implementation
- **Medium (50-80%):** Flag uncertainty, ask if should proceed
- **Low (<50%):** Stop — request clarification before continuing

## Reporting Format

When confidence is not high, state:
- What was decided
- Why this interpretation was chosen
- Confidence level

</confidence_signaling>

<delegation_patterns>

## Handoff Payload Requirements

Include in every handoff:
- Summary of completed work
- Key findings or decisions made
- Explicit next steps for receiving agent

Handoffs must be self-contained — no "see above" references.

## Delegation Boundaries

**Delegate when:**
- Task requires different expertise (e.g., @architect for planning)
- Parallel execution reduces total time

**Retain when:**
- Single tool call suffices
- Context already fully loaded

</delegation_patterns>

<self_validation>

## Pre-Output Verification

Before delivering output, verify:
- "Executable by agent without human interpretation?"
- "Do all cross-references resolve?"
- "Are there any placeholder values remaining?"

## Spawn Validation

For complex artifacts, spawn sub-agent with #tool:runSubagent to test:
- "Is this content clear to another agent?"
- "Can the structure be navigated without ambiguity?"

</self_validation>

<tool_fallbacks>

## When Tools Are Unavailable

If a required tool is unavailable:
1. State which tool is unavailable
2. Provide manual alternative (e.g., command to run, content to paste)
3. Continue with available tools

## Common Fallbacks

- **execute unavailable:** Report command as markdown code block
- **fetch unavailable:** Request user to paste content
- **agent unavailable:** Provide handoff context inline for manual routing

</tool_fallbacks>

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

- `anthropics/skills` - anthropic skills repo
- `github/awesome-copilot` - community collection of skills, custom agents, instructions, and prompts

</inspirations>

</references>

## Cross-References

- [copilot-instructions.md](../copilot-instructions.md) — Core rules this file extends
- [style.instructions.md](style.instructions.md) — Sentence-level style conventions
