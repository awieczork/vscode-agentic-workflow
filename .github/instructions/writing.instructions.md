---
applyTo: "**"
description: "Writing rules for AI agent consumption"
---

# Writing for AI Agents

Apply priority hierarchy from `<foundation>` before writing. Follow mechanics in `<writing_mechanics>` for sentence-level patterns, then compose prose introductions per `<prose_composition>`. Use syntax from `<reference_syntax>` for tools, agents, and files. Format outputs per `<formatting>` and structure artifacts per `<artifact_requirements>`. Handle uncertainty via `<uncertainty_handling>`, validate via `<quality_gates>`, manage context via `<operational>`, and maintain simplicity per `<simplicity>`.

<core_principal>

All content in this repository is FOR AI agents. Readers are ALWAYS AI agents. Optimize for parseability, unambiguous execution, and machine-verifiable compliance.

</core_principal>

<foundation>

## Priority and Language

**Priority hierarchy:** If rules conflict, apply in this order:
1. **Safety** — Never expose secrets, credentials, or destructive operations
2. **Accuracy** — Correct information over stylistic compliance
3. **Clarity** — Unambiguous meaning over elegant phrasing
4. **Style** — Language and formatting rules

**One term per concept** — Pick one term, use it everywhere. Avoid synonyms.

**Explicit defaults** — "Default if omitted: [value]" for every optional field.

**Explicit conditionals** — Use direct conditional statements.
<example>
- Correct: "If X, then Y"
- Incorrect: "Y when appropriate"
</example>

</foundation>

<writing_mechanics>

## Writing Patterns

**Evidence-based statements** — State facts with source.
<example>
- Correct: "Per [source], X does Y" or "In 3/4 tested cases, X"
- Incorrect: "X usually does Y" or "X tends to work"
</example>

**Precise quantifiers** — Use specific numbers.
<example>
- Correct: "2-3 items", "5 checks", "1 paragraph"
- Incorrect: "several items", "some checks", "a few paragraphs"
</example>

**Active voice with explicit actor** — Name the agent performing the action.
<example>
- Correct: "The validator checks X"
- Incorrect: "X should be checked"
</example>

**Direct statements** — State the answer directly.
<example>
- Correct: "The correct approach is X"
- Incorrect: "What if we tried X?" (rhetorical)
</example>

**Bullet lists for structured data** — Convert tabular data to hierarchical bullet lists.

**Committed examples** — Choose ONE specific value.
<example>
- Correct: "typescript-standards"
- Incorrect: "e.g., typescript-standards" or "such as typescript-standards"
</example>

**Positive framing** — Tell the model what to do instead of what not to do.
<example>
- Instead of: "Do not use markdown in your response"
- Write: "Compose your response in flowing prose paragraphs"
</example>

**Tool trigger language** — Use normal prompting language for tool triggers.
<example>
- Instead of: "CRITICAL: You MUST use this tool when..."
- Write: "Use this tool when..."
</example>

Modern LLMs respond well to direct instructions. Aggressive emphasis causes overtriggering.

**Specificity with context** — Provide context explaining WHY, not just WHAT.
<example>
- Instead of: "NEVER use ellipses"
- Write: "Avoid ellipses — text-to-speech engines cannot pronounce them"
</example>

## Hard Constraints

- **NEVER use emojis** — Break parsing in some environments
- **NEVER use markdown tables** — Except in `<outputs>` sections per `<permitted_exceptions>`
- **NEVER use motivational language** — "This will help you..." breaks agent focus

<permitted_exceptions>

These exceptions override hard constraints:

- **Tables in `<outputs>` sections** — Permitted for agent report templates (build reports, inspection reports). These render for human readers.
- **Tables in `<criteria_checklist>` sections** — Permitted in audit/plan files for criteria matrices. Columns: ID, Criterion, Pass Condition.
- **Tables in verification summaries** — Permitted for pass/fail status matrices in inspection reports.

</permitted_exceptions>

</writing_mechanics>

<prose_composition>

## Prose Introduction Rules

Write 3-5 sentences of flowing prose (not a disguised list). Use imperative verbs. Write TO the agent, not ABOUT the file.

**Verb selection by tag purpose:**
- Constraint tags → **Apply**, **Enforce**, **Verify**
- Context tags → **Load**, **Initialize**
- Operation tags → **Select from**, **Execute**, **Follow**
- Scope tags → **Observe**, **Respect**
- Output tags → **Format using**, **Deliver per**
- Lifecycle tags → **Apply**, **Follow**, **Use**

**Sentence order by priority:**
1. Constraints and safety (what limits behavior)
2. Context and initialization (what to load first)
3. Operations and workflows (what to execute)
4. Outputs and lifecycle (how to deliver and exit)

**Example:**
```markdown
Apply constraints from `<safety>` and `<iron_laws>` before any action—halt immediately on `<red_flags>`. Load context per `<context_loading>`, then select operational behavior from `<modes>`. Observe scope limits in `<boundaries>` and format deliverables using `<outputs>`. For handoffs apply `<stopping_rules>`; for failures follow `<error_handling>`; for blocks use `<when_blocked>`.
```

</prose_composition>

<reference_syntax>

## Tool, Agent, and File References

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

</reference_syntax>

<formatting>

## Format Rules

### Forbidden Formats

- **Markdown tables** — Convert to bullet lists. Tables break rendering.
- **Starting with delimiters** — First character must be a letter (A-Z, a-z), not `---` or markers.
- **System parsing markers** — Do not output `---START` and `---END` markers.

### Permitted Formats

- **Headers** — Use freely with XML tags for additional structure.
- **Bold and italic** — Use for emphasis within content.
- **Code blocks** — Use for examples and code samples.
- **Bullet and numbered lists** — Use for discrete items and sequential steps.

### Artifact-Specific Conventions

- Use `##` for major sections in reference files
- Bold labels for definitions: `**term** — definition`
- Use `[UPPERCASE_PLACEHOLDER]` format in templates
- **File references** — Use markdown links `[file.md](path/file.md)`, never backticks
- **Inline code** — Backticks permitted for code snippets, variables, command names

</formatting>

<artifact_requirements>

## Artifact-Specific Rules

### Every File

- Clear title as H1 heading
- Purpose statement in first paragraph
- Cross-references section at end linking related files

### Templates

- Required vs optional marking for every section
- Default values for optional fields
- Placeholder format examples
- Minimal template variant for simple cases

### Patterns

- "When to create" decision criteria
- Anti-patterns with explanations
- Ecosystem position (how this artifact relates to others)

### Checklists

- Priority level definitions (P1/P2/P3)
- Atomic checks (one thing per item)
- Pass/fail criteria without judgment calls
- Quick validation section (5 essential checks)

</artifact_requirements>

<uncertainty_handling>

## Errors and Confidence

### Error Response Structure

When reporting errors, use this format:

- **status:** `success` | `partial` | `failed` | `blocked`
- **error_code:** kebab-case identifier (e.g., `file-not-found`, `validation-failed`)
- **message:** Human-readable explanation
- **recovery:** Suggested next action

### Severity Levels

- **P1:** Blocks completion — requires immediate fix
- **P2:** Degrades quality — should fix before delivery
- **P3:** Minor issue — optional improvement

### Confidence Thresholds

- **High (≥80%):** Proceed with implementation
- **Medium (50-80%):** Flag uncertainty, ask if should proceed
- **Low (<50%):** Stop — request clarification before continuing

### Reporting Format

When confidence is not high, state:
- What was decided
- Why this interpretation was chosen
- Confidence level

</uncertainty_handling>

<quality_gates>

## Delegation and Validation

### Handoff Payload Requirements

Include in every handoff:
- Summary of completed work
- Key findings or decisions made
- Explicit next steps for receiving agent

Handoffs must be self-contained — no "see above" references.

### Delegation Boundaries

**Delegate when:**
- Task requires different expertise (e.g., @architect for planning)
- Parallel execution reduces total time

**Retain when:**
- Single tool call suffices
- Context already fully loaded

### Pre-Output Verification

Before delivering output, verify:
- "Executable by agent without human interpretation?"
- "Do all cross-references resolve?"
- "Are there any placeholder values remaining?"

### Spawn Validation

For complex artifacts, spawn sub-agent with #tool:runSubagent to test:
- "Is this content clear to another agent?"
- "Can the structure be navigated without ambiguity?"

</quality_gates>

<operational>

## Context and Fallbacks

### Loading Tiers

**HOT (always load first):**
- `copilot-instructions.md` — Global project rules
- Active session state files in `.github/memory-bank/sessions/`

**WARM (load when referenced):**
- Documentation files mentioned in conversation
- Source files under active investigation

**On missing files:** Note absence, continue with available context. State assumption if proceeding without expected file.

### Token Budget

Estimate artifact size before generation. For manifests with 10+ artifacts, summarize completed items to conserve context.

### Tool Fallbacks

If a required tool is unavailable:
1. State which tool is unavailable
2. Provide manual alternative (e.g., command to run, content to paste)
3. Continue with available tools

**Common Fallbacks:**
- **execute unavailable:** Report command as markdown code block
- **fetch unavailable:** Request user to paste content
- **agent unavailable:** Provide handoff context inline for manual routing

</operational>

<simplicity>

## Avoid Overengineering

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

</simplicity>

<references>

## External Documentation

Use #tool:fetch to link to official documentation:

- https://code.visualstudio.com/docs/copilot/customization/custom-agents — agents
- https://code.visualstudio.com/docs/copilot/customization/prompt-files — prompts
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions — instructions
- https://code.visualstudio.com/docs/copilot/customization/agent-skills — skills
- https://agentskills.io/specification — skills open format specification

Use #tool:githubRepo to link to community resources:

- `anthropics/skills` — anthropic skills repo
- `github/awesome-copilot` — community collection of skills, custom agents, instructions, and prompts

</references>

## Cross-References

- [copilot-instructions.md](../copilot-instructions.md) — Core rules
- [xml-structure.instructions.md](xml-structure.instructions.md) — XML syntax
