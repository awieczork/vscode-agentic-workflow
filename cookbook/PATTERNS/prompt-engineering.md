---
when:
  - writing effective agent instructions
  - improving prompt clarity and specificity
  - structuring complex prompts
  - applying prompting best practices
pairs-with:
  - instruction-files
  - agent-file-format
  - prompt-files
  - context-variables
requires:
  - none
complexity: low
---

# Prompt Engineering

> Patterns for writing effective instructions in agent files, prompts, and system configurations.

These techniques apply wherever you write instructions: `.agent.md`, `.instructions.md`, `.prompt.md`, and `copilot-instructions.md`.

## 4-Element Prompt Structure

Every effective prompt contains these elements:

| Element | Purpose | Example |
|---------|---------|---------|
| **Instruction** | What to do | "Refactor this code to improve readability" |
| **Context** | Background info | "Project uses TypeScript 5.x with strict mode" |
| **Input** | Data to process | `${selection}` or `#src/auth.ts` |
| **Output** | Expected format | "Return refactored code with explanation" |

**Template:**
```markdown
## Instruction
{Specific task to perform}

## Context
{External information to guide response}
- Project uses [framework/language]
- Follow [conventions/standards]

## Input
{The content to process}

## Expected Output
{Format and structure of response}
```

**Full Example (.prompt.md):**
```markdown
---
agent: agent
tools: ['editFiles', 'fetch', 'search']
---
## Instruction
Refactor this code to improve readability and performance.

## Context
- Project uses TypeScript 5.x with strict mode
- Follow existing naming conventions in the codebase
- Prefer immutable patterns

## Input
${selection}

## Expected Output
- Refactored code block
- Brief explanation of changes made
- Any performance implications
```

See [context-variables.md](../CONTEXT-ENGINEERING/context-variables.md) for injecting context elements.

## The 4 Ss Framework

<!-- NOT IN OFFICIAL DOCS: "4 Ss" as named Microsoft framework - flagged 2026-01-25 -->
> **Note:** This mnemonic synthesizes guidance from Microsoft Learn prompt engineering modules. The individual principles (be specific, keep prompts simple, provide context) are documented; the "4 Ss" name is a cookbook simplification.

Mnemonic for prompt crafting:

| S | Principle | Example |
|---|-----------|--------|
| **Single** | One task per prompt | "Refactor this function" not "Refactor and add tests and document" |
| **Specific** | Precise requirements | "Use async/await with error handling" not "Make it better" |
| **Short** | Concise but complete | Remove fluff, keep context |
| **Surround** | Provide context | Open relevant files, reference patterns |

**Application:**
- Before writing a prompt, check all 4 Ss
- Break multi-task prompts into sequential Single prompts
- Add Specific constraints to reduce ambiguity
- Keep prompts Short by linking to external docs instead of embedding
- Surround the task with open files and `#file` references

## ReAct Pattern

<!-- NOT IN OFFICIAL DOCS: "ReAct" pattern by name - flagged 2026-01-25 -->
> **Note:** ReAct (Reason + Act) is a research pattern from Yao et al. (2022), not specific VS Code/Copilot terminology. The underlying practice of gathering context before acting is supported by official guidance to "iterate" and "ask follow-up questions."

Think → Act → Observe cycles for complex tasks.

```markdown
## Execution Pattern

When given a task:

1. **Thought**: State what you need to understand
2. **Action**: Use appropriate tool (read_file, grep_search, etc.)
3. **Observation**: Analyze results
4. **Repeat** until sufficient context gathered
5. **Execute**: Perform the requested changes
6. **Verify**: Confirm changes meet requirements
```

**Implementation in .agent.md:**
```markdown
<execution_pattern>
Before making any changes:
1. THINK: What do I need to understand? State your reasoning.
2. ACT: Gather information using available tools
3. OBSERVE: What did I learn? Is it sufficient?
4. REPEAT until you have complete understanding
5. EXECUTE: Make changes only after full context
6. VERIFY: Confirm changes work as expected
</execution_pattern>
```

**Where ReAct Appears:**
- [just-in-time-retrieval.md](../CONTEXT-ENGINEERING/just-in-time-retrieval.md) — Progressive disclosure is ReAct for context gathering
- [verification-gates.md](verification-gates.md) — Evidence-before-claims enforces the Observe step

## Positive Framing

Write rules as "do this" not "don't do that."

**❌ Negative (Avoid):**
```markdown
❌ Don't write verbose code
❌ Don't use any types
❌ Don't skip error handling
❌ Never make changes without asking
```

**✅ Positive (Use):**
```markdown
✅ Write concise, focused functions under 20 lines
✅ Use explicit types for all function parameters and returns
✅ Handle all potential errors with try-catch or Result types
✅ Ask before making changes outside the specified scope
```

**Why Positive Works Better:**
- Clearer mental model (what TO do, not what to avoid)
- Reduces ambiguity (negative rules have infinite interpretations)
- More actionable (positive rules are executable)

**Examples in This Cookbook:**
- [hallucination-reduction.md](hallucination-reduction.md): "Say I don't know" vs "Don't fabricate"
- [iron-law-discipline.md](iron-law-discipline.md): Rationalization Tables reframe excuses positively

## Chain-of-Thought

Add "think step by step" for complex reasoning.

```markdown
<reasoning>
When solving complex problems:
1. Break the problem into smaller parts
2. Solve each part explicitly
3. Show your reasoning at each step
4. Combine partial solutions into final answer

Use this for: architecture decisions, debugging, refactoring
</reasoning>
```

**When to Use:**
- Multi-step calculations
- Architectural trade-offs
- Debugging complex issues
- Tasks with multiple valid approaches

**Claude-Specific Thinking Notes:**

> ⚠️ **Important:** Phrases like "think", "think hard", "ultrathink", and "think more" are interpreted as **regular prompt instructions** and do NOT allocate thinking tokens. Extended thinking requires explicit API configuration, not prompt keywords.
> 
> Source: [Claude Code Common Workflows](https://code.claude.com/docs/en/common-workflows#use-extended-thinking-thinking-mode)

When extended thinking is disabled, Claude Opus 4.5 is particularly sensitive to the word "think" and its variants. Use alternative words:

| Instead of | Use |
|------------|-----|
| "think" | "consider", "evaluate", "assess" |
| "think about" | "reflect on", "analyze" |
| "think through" | "work through", "reason about" |

## Role Prompting

Instruct the agent to adopt a specific expert persona.

```markdown
## Identity
You are a senior security engineer specializing in web application security.
Review code with focus on OWASP Top 10 vulnerabilities.
```

**Common Roles for Coding Agents:**

| Role | Focus Area |
|------|------------|
| Security Engineer | Vulnerabilities, input validation, auth |
| Performance Engineer | Runtime efficiency, memory, caching |
| Testing Specialist | Edge cases, coverage, test design |
| Code Reviewer | Readability, maintainability, patterns |
| DevOps Engineer | CI/CD, deployment, infrastructure |

**Implementation in .agent.md:**
```markdown
---
name: security-reviewer
description: Expert security code reviewer
---

## Identity
You are a senior security engineer. Focus on:
- Input validation and sanitization
- Authentication and authorization flaws
- Injection vulnerabilities (SQL, XSS, command)
- Sensitive data exposure

## Review Checklist
1. Check all user inputs are validated
2. Verify authentication on sensitive endpoints
3. Ensure parameterized queries for database access
4. Confirm secrets are not hardcoded
```

## Few-Shot Examples

Provide examples to guide behavior patterns.

```markdown
<!-- .instructions.md -->
When asked about testing, follow this pattern:

Q: How should I test this function?
A: Create unit tests covering: happy path, edge cases, error conditions.

Q: What testing framework should I use?
A: Use the project's configured framework (Jest/Vitest/Mocha).

Q: Should I mock this dependency?
A: Mock external services; use real implementations for internal modules.
```

**Use Few-Shot For:**
- Response formatting
- Decision patterns
- Domain-specific conventions
- Tone/style guidance

## Output Templates

Specify exact response formats.

```markdown
## Response Templates

### For Code Explanations
1. **Purpose**: What this code does
2. **How it works**: Step-by-step logic
3. **Key patterns**: Design patterns used
4. **Potential issues**: Edge cases or concerns

### For Errors
- **Error type**: [Classification]
- **Root cause**: [Explanation]
- **Fix**: [Code solution]

### When Uncertain
"I need more context. Could you provide [specific information needed]?"
```

## Tree of Thoughts

<!-- NOT IN OFFICIAL DOCS: "Tree of Thoughts" pattern - flagged 2026-01-25 -->
> **Note:** Tree of Thoughts is a research prompting technique (Yao et al., 2023). VS Code Copilot docs don't specifically mention this pattern, but the practice of considering multiple perspectives is general prompt engineering guidance.

Multiple perspectives for complex decisions.

```markdown
<!-- For architecture decisions in .prompt.md -->
Consider this problem from three perspectives:

**Performance Expert**: Focus on runtime efficiency and memory
**Maintainability Expert**: Focus on readability and future changes
**Security Expert**: Focus on vulnerabilities and data safety

Each perspective should:
1. Evaluate the current approach
2. Identify concerns
3. Propose improvements

Then synthesize the best solution addressing all three perspectives.
```

## Query Complexity Routing

<!-- NOT IN OFFICIAL DOCS: Query complexity routing levels - flagged 2026-01-25 -->
> **Note:** This routing framework is synthesized from community practices and research literature. VS Code Copilot doesn't prescribe specific routing levels, but does support tool selection via `tools:` frontmatter.

Match tool usage to query complexity.

| Level | Tool Count | When to Apply |
|-------|------------|---------------|
| **NEVER SEARCH** | 0 | Stable info: syntax, concepts, math |
| **OFFER TO SEARCH** | 0 + offer | Annual updates, known entities |
| **SINGLE SEARCH** | 1 | Real-time data, unknown terms |
| **RESEARCH** | 2-20 | Multi-source analysis, comprehensive tasks |

```markdown
<query_routing>
Before responding, classify the query:
- STABLE (syntax, algorithms, concepts) → Answer directly
- SEMI-STABLE (libraries, APIs) → Check if recent, offer search
- TEMPORAL (current versions, news) → Search first
- COMPLEX (analysis, comparison) → Multi-source research
</query_routing>
```

## Quantified Limits

Use numbers, not vague words.

| Vague | Quantified |
|-------|------------|
| "Keep responses short" | "Maximum 3 paragraphs" |
| "Limit code examples" | "Max 4 code blocks per response" |
| "Don't quote too much" | "Quotes ≤15 words each" |
| "Keep functions small" | "Functions under 20 lines" |

```markdown
## Constraints
- Maximum 3 files modified per task
- Functions must be under 25 lines
- Each response includes at most 2 code examples
- Quote sources in ≤15 words
```

## Anti-Patterns to Avoid

Common prompt engineering failures:

| Anti-Pattern | Why It Fails | Better Alternative |
|--------------|--------------|-------------------|
| Duplicating constraints | Maintenance risk | Single source of truth, use `applyTo` |
| Vague quantifiers | "Be concise" is ambiguous | Specific limits: "Max 3 bullets", "≤100 words" |
| Unbounded tool calls | Infinite loops possible | Hard limits: "Max 4 code steps" |
| No fallback for missing info | Agent freezes | "Proceed with available context" |
| Over-reliance on disclaimers | "I cannot..." breaks flow | Refuse succinctly, continue |
| Inconsistent formatting | Lists vs prose confusion | Explicit format routing by query type |
| No priority hierarchy | Conflicting rules | Establish precedence: Safety > Context > Persona |

**Claude Opus 4.5 Specific Pitfalls:**

> Source: [Claude 4 Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices)

| Behavior | Issue | Fix |
|----------|-------|-----|
| Over-engineering | Creates more than requested | Add: "Only make changes directly requested" |
| Aggressive tool use | System prompt sensitivity | Dial back language like "CRITICAL: You MUST" |
| File creation | May create temp files | Prompt to clean up if undesired |
| Conservative exploration | Won't read files | "Read and understand files before proposing edits" |

## Chat History Management

Maintain clean conversation context:

```markdown
## Thread Hygiene
1. Start new chat threads for unrelated tasks
2. Remove irrelevant context by starting fresh
3. Reference previous work via files, not conversation history
4. For long tasks: summarize progress, start new thread
```

**When to Start a New Thread:**
- Task domain changes significantly
- Accumulated context causes confusion
- Agent references outdated information
- You want to test different approaches

## Combining Techniques

Real agent files combine multiple patterns:

```markdown
# Implementation Agent

## Identity (Role Definition)
You implement features following existing patterns.

## Execution (ReAct Pattern)
1. THINK: What files do I need to understand?
2. ACT: Read existing implementations
3. OBSERVE: Document the patterns found
4. EXECUTE: Implement following those patterns
5. VERIFY: Run tests to confirm

## Constraints (Quantified + Positive)
- Modify at most 5 files per task
- Write tests for all new functions
- Match existing code style exactly
- Ask before changing shared utilities

## Response Format (Output Template)
For each file changed:
1. **File**: path/to/file
2. **Changes**: bullet list
3. **Why**: brief rationale
```

## Additional Official Guidance

These tips come directly from VS Code and Microsoft official documentation:

### Iteration is Key
> "Iterate on your prompt to refine the results. Follow up with clarifying questions."
> — [VS Code Copilot Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features)

### Prime with Sample Code
> "One trick to get AI on the right page, is to copy and paste sample code that is close to what you are looking for into your open editor."
> — [VS Code Prompt Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/prompt-engineering-guide)

### Project Context Documents
Create these files for better AI context (from [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)):
- `PRODUCT.md` — Project purpose and key features
- `ARCHITECTURE.md` — System design overview
- `CONTRIBUTING.md` — Development guidelines

### Tool Limits
- Maximum **128 tools** per chat request
- Use tool sets to organize related tools
> — [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools)

### Subagent Isolation
> "A subagent enables you to delegate tasks to an isolated agent... has its own context window."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

## Related

- [instruction-files.md](../CONFIGURATION/instruction-files.md) — Where to write prompts
- [agent-file-format.md](../CONFIGURATION/agent-file-format.md) — Agent-specific prompt containers
- [context-variables.md](../CONTEXT-ENGINEERING/context-variables.md) — Injecting context into prompts
- [hallucination-reduction.md](hallucination-reduction.md) — Grounding techniques
- [riper-modes.md](../WORKFLOWS/riper-modes.md) — Mode constraints as prompt boundaries

## Sources

### Official Documentation (Validated 2026-01-25)
- [VS Code Prompt Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/prompt-engineering-guide) — Core prompt crafting guidance
- [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) — Role prompting, output templates
- [VS Code Copilot Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) — `#`-mentions, file references
- [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) — `.prompt.md` format, frontmatter
- [GitHub Copilot Best Practices](https://docs.github.com/en/copilot/using-github-copilot/best-practices-for-using-github-copilot)
- [Microsoft Learn: Prompt Engineering](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/prompt-engineering) — Chain-of-thought documentation
- [Claude Opus 4 Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices) — Model-specific behaviors
- [Claude Code Common Workflows](https://code.claude.com/docs/en/common-workflows) — Extended thinking clarification

### Research & Community
- [Prompt Engineering Guide — DAIR.AI](https://github.com/dair-ai/Prompt-Engineering-Guide)
- [System Prompts Analysis](https://github.com/asgeirtj/system_prompts_leaks)
- [Anthropic Prompt Engineering Overview](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview)
