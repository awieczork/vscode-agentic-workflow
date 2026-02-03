---
applyTo: "**"
description: "Prompting rules for Claude 4.x models — applies to all files"
---

# Prompting Rules

Rules for writing effective prompts and instructions for Claude 4.x models. Apply when creating agent definitions, instructions, prompts, and skills.

<xml_usage>

## Tag Referencing

Reference previously defined tags by name in subsequent sections.

**Patterns:**
- "Using the contract in `<contract>` tags above..."
- "Based on the analysis in `<analysis>` tags..."
- "Reference specific files from `<data_collection>`"
- "Switch to <mode name="research"> for detailed lookup"

**Rules:**
- Use consistent tag names throughout the artifact
- Reference tags explicitly when their content informs later sections
- Use descriptive tag names that make references natural

## Tags with Headers

Combine XML tags with markdown headers for hierarchical structure.

**Rules:**
- Use single space after `#` symbols
- Leave blank lines before and after headers
- Place headers inside or outside tags based on semantic grouping

**Example:**

```markdown
<workflow>

## Phase 1: Analysis

<instructions>
Review the codebase for issues.
</instructions>

## Phase 2: Implementation

<steps>
1. Fix critical issues first
2. Address warnings next
</steps>

</workflow>
```

## Workflow Structure

Structure multi-phase workflows using numbered phase tags.

**Pattern:** `<phase_N_name>` where N is sequence number and name describes the phase

**Rules:**
- Number phases sequentially (1, 2, 3...)
- Use descriptive phase names after the number
- Contain all phases within a parent `<workflow>` tag

</xml_usage>

<vscode_references>

## Reference Syntax

VS Code chat supports special reference syntax for files, tools, and agents.

**File attachment (`#file:`):**
- `#file:filename.md` — Attach file to chat context by name
- `#file:path/to/file.md` — Attach file by path
- Use when: Injecting file content into chat messages
- Caution: Ambiguous if duplicate filenames exist (e.g., multiple `SKILL.md` files)

**Tool reference (`#tool:`):**
- `#tool:<tool-name>` — Reference a tool in documentation
- Example: "Use #tool:fetch to retrieve web content"
- Example: "Use #tool:githubRepo to access repository data"
- Use when: Documenting which tools to use in instructions or skills

**Agent reference (`@`):**
- `@agent-name` — Reference or invoke an agent
- Example: "Hand off to @architect for planning"
- Example: "@build executes approved plans"
- Use when: Describing agent handoffs or delegation

**Markdown links (for cross-references):**
- `[display text](relative/path.md)` — Clickable documentation link
- Use when: Cross-referencing files within documentation
- Preferred over `#file:` for explicit paths and navigation

**Rules:**
- Use `#tool:` for tool references in all artifact types
- Use `@agent` for agent references consistently
- Use markdown links for documentation cross-references
- Use `#file:` only when attaching files to chat context
- Avoid `#file:` with ambiguous filenames (e.g., `SKILL.md`)

</vscode_references>

<formatting>

## Forbidden Formats

- **Markdown tables** — Convert to bullet lists. Tables break rendering.
- **Starting with delimiters** — First character must be a letter (A-Z, a-z), not `---` or markers.
- **System parsing markers** — Do not output `---START` and `---END` markers.

## Permitted Formats

- **Headers** — Use freely with XML tags for additional structure.
- **Bold and italic** — Use for emphasis within content.
- **Code blocks** — Use for examples and code samples.
- **Bullet and numbered lists** — Use for discrete items and sequential steps.

</formatting>

<instruction_writing>

## Positive Framing

Tell the model what to do instead of what not to do.

- **Instead of:** "Do not use markdown in your response"
- **Write:** "Compose your response in flowing prose paragraphs"

## Tool Trigger Language

Use normal prompting language for tool triggers. Avoid aggressive emphasis.

- **Instead of:** "CRITICAL: You MUST use this tool when..."
- **Write:** "Use this tool when..."

Modern LLMs are highly responsive to prompts. Aggressive language causes overtriggering.

## Specificity with Context

Provide context explaining WHY, not just WHAT.

- **Instead of:** "NEVER use ellipses"
- **Write:** "Your response will be read aloud by a text-to-speech engine, so avoid ellipses since the engine cannot pronounce them"

</instruction_writing>

<behavioral_steering>

## Proactive Action

To make the model implement changes by default:

```markdown
<default_to_action>
By default, implement changes rather than only suggesting them. 
If the user's intent is unclear, infer the most useful likely action and proceed,
using tools to discover any missing details instead of guessing.
</default_to_action>
```

## Conservative Action

To make the model gather information before acting:

```markdown
<do_not_act_before_instructions>
Do not jump into implementation or change files unless clearly instructed.
When the user's intent is ambiguous, default to providing information, doing research,
and providing recommendations rather than taking action.
</do_not_act_before_instructions>
```

## Verbosity Control

LLMs optimized for efficiency may skip summaries after tool calls. To increase visibility:

```markdown
After completing a task that involves tool use, provide a quick summary of the work you've done.
```

## Code Exploration

Prevent speculation about uninspected code:

```markdown
<investigate_before_answering>
Never speculate about code you have not opened. 
If the user references a specific file, you MUST read the file before answering. 
Investigate and read relevant files BEFORE answering questions about the codebase.
</investigate_before_answering>
```

</behavioral_steering>

<anti_patterns>

## Overengineering

LLMs tend to add unnecessary abstractions and flexibility.

**Prevention prompt:**

```markdown
Avoid over-engineering. Only make changes that are directly requested or clearly necessary. 
Keep solutions simple and focused.

Do not add features, refactor code, or make improvements beyond what was asked. 
Do not add error handling for scenarios that cannot happen. 
Do not create helpers or abstractions for one-time operations.
```

## Test-Focused Solutions

LLMs may hard-code values to pass tests instead of implementing general solutions.

**Prevention prompt:**

```markdown
Implement a solution that works correctly for all valid inputs, not just the test cases. 
Do not hard-code values or create solutions that only work for specific test inputs.
Tests verify correctness; they do not define the solution.
```

## Excessive File Creation

LLMs may create temporary files during iteration for testing purposes.

**Cleanup prompt:**

```markdown
If you create any temporary files, scripts, or helper files for iteration, clean up these files when done.
```

</anti_patterns>

<research_tasks>

For complex research tasks, use structured hypothesis tracking:

```markdown
Search for this information in a structured way. 
As you gather data, develop competing hypotheses. 
Track confidence levels in your progress notes. 
Regularly self-critique your approach and plan. 
Update a hypothesis tree or research notes file to persist information.
```

</research_tasks>

<subagent_orchestration>

Advanced LLMs recognize when tasks benefit from subagent delegation and can act proactively.

**Rules:**
- Define subagent tools clearly in tool definitions
- Let the model orchestrate naturally without explicit instruction
- Add conservative prompting only if delegation is excessive

**Conservative delegation prompt:**

```markdown
Only delegate to subagents when the task clearly benefits from a separate agent with a new context window.
```

</subagent_orchestration>

<thinking_guidance>

Guide reflection after tool use for better multi-step reasoning:

```markdown
After receiving tool results, carefully reflect on their quality and determine optimal next steps before proceeding. 
Use your thinking to plan and iterate based on this new information, and then take the best next action.
```

</thinking_guidance>
