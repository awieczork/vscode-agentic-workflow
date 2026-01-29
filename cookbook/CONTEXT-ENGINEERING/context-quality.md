---
when:
  - diagnosing poor agent responses
  - prioritizing what context to include
  - evaluating correctness vs completeness tradeoffs
  - verifying context before major decisions
pairs-with:
  - utilization-targets
  - compaction-patterns
  - just-in-time-retrieval
  - hallucination-reduction
requires:
  - none
complexity: low
---

# Context Quality

Not all context is equal. Prioritize correctness over completeness, and completeness over size. The right context at the right time beats comprehensive context that buries the signal.

## Why Context Quality Matters

Think of context as an **attention budget**—a finite resource with diminishing returns. Like human working memory, models have limited capacity to attend to information. As context grows, the ability to recall and reason about information degrades—what VS Code docs call "stale context" that "leads to outdated or incorrect suggestions." Research shows this degradation emerges across all models, though the severity varies.

> Source: [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

<!-- COMMUNITY PATTERN: "leverage model" concept from HumanLayer ACE - not in official docs -->
Critically, quality issues compound through the "leverage model":

```
Bad research line    → 1000s of bad lines of code
Bad plan line        → 100s of bad lines of code
Bad code line        → 1 bad line of code

∴ Review ~400 lines of specs > Review 2000 lines of code
```

A correctness issue in context creates multiplicative downstream errors. This is why the quality hierarchy isn't just preference—it's damage mitigation.

## The Quality Hierarchy

<!-- COMMUNITY PATTERN: Quality hierarchy from HumanLayer ACE - not in official VS Code docs -->
```
Priority Order:
1. ⭐⭐⭐⭐ CORRECTNESS — No false information
2. ⭐⭐⭐   COMPLETENESS — All relevant info included
3. ⭐⭐     SIZE — Minimal noise
4. ⭐       TRAJECTORY — Heading in right direction
```

This hierarchy guides every context decision: when you must trade off, always sacrifice lower-priority concerns first.

## The Worst-to-Best Scale

Quality threats ranked from most damaging to least:

| Threat | Impact | Why |
|--------|--------|-----|
| **Incorrect information** | Catastrophic | Agent acts on false premises, compounds errors |
| **Missing information** | Serious | Agent makes uninformed decisions, may ask |
| **Too much noise** | Moderate | Agent slows down, may miss signal in noise |

**Key insight:** Too much noise is the *least bad* problem. When uncertain, include context rather than risk missing something critical—the agent can filter noise, but can't recover from missing data or false beliefs.

## Quality Components Explained

### Correctness

The context must be true and current.

**Failure modes:**
- Stale file contents (file changed since read)
- Hallucinated patterns from training data
- Cached information that's no longer accurate
- Assumptions stated as facts

**Solutions:**
- Read files fresh when making decisions
- Ground claims in actual code/docs
- Allow uncertainty: "I don't have enough information"
- Verify before committing to a path

See [hallucination-reduction](../PATTERNS/hallucination-reduction.md) for detailed techniques.

### Completeness

All information needed for the current decision is present.

**Failure modes:**
- Missing edge cases
- Incomplete understanding of dependencies
- Skipped files that matter
- Assumptions about what's "obvious"

**Solutions:**
- Use progressive disclosure (start narrow, expand)
- Ask clarifying questions when uncertain
- Cross-reference related files
- Load context just-in-time rather than guessing upfront

See [just-in-time-retrieval](just-in-time-retrieval.md) for loading strategies.

### Size

Minimal noise in context—everything present serves a purpose.

**Failure modes:**
- Full files when only a function matters
- Stale conversation history
- Redundant information
- Boilerplate crowding out signal

**Solutions:**
- Keep utilization at 40-60% <!-- COMMUNITY GUIDELINE: from HumanLayer ACE -->
- Compact between phases
- Read specific line ranges
- Use subagents for exploration (official: "Subagents...have their own context window...helps to manage context window limitations" — [VS Code 1.107](https://code.visualstudio.com/updates/v1_107))

See [utilization-targets](utilization-targets.md) and [compaction-patterns](compaction-patterns.md) for techniques.

### Trajectory

Context is leading toward the goal, not just accurate/complete/small.

**Failure modes:**
- Correct information about the wrong thing
- Complete context for an abandoned approach
- Perfectly sized context for a tangent

**Solutions:**
- Periodically verify: "Does this context serve the current goal?"
- Align context with active task <!-- COMMUNITY PATTERN: "memory bank" from Cline - not official VS Code -->
- Prune context that served past decisions but not current ones

## Quality Degradation Signals

Watch for these indicators that context quality is declining:

| Signal | Likely Issue | Response |
|--------|--------------|----------|
| "I don't have information about X" | COMPLETENESS gap | Load the relevant context |
| Agent suggests already-rejected approach | CORRECTNESS issue | Context has stale info |
| Repeated similar suggestions | Missing TRAJECTORY | Context doesn't reflect decision |
| Response noticeably slower | SIZE bloat | Compact or use subagent |
| Agent asks questions you already answered | COMPLETENESS gap | Information lost in compaction |
| "Summarized conversation history" message | SIZE threshold | Session approaching limits |

> **Official behavior:** When conversation or context gets very large, VS Code displays "Summarized conversation history" and "compress[es] the conversation so far into a summary of the most important information and the current state of your task."
> — [VS Code 1.100 Release Notes](https://code.visualstudio.com/updates/v1_100)

<!-- COMMUNITY PATTERN: Specific token numbers and percentage thresholds from research - not in official VS Code docs -->
> **Research note:** While models advertise large context windows (128K-200K tokens), empirical testing shows reliability degrades well before theoretical limits. Most models become unreliable around 60-70% of stated capacity. This is why the 40-60% utilization target isn't conservative—it's the optimal operating range.

## Quality Verification Questions

Before major decisions, verify context quality:

```markdown
## Context Quality Check

### Correctness
- [ ] Have I read (not assumed) the relevant files?
- [ ] Is my understanding based on current code, not memory?
- [ ] Have I acknowledged what I don't know?

### Completeness
- [ ] Do I have all information needed for THIS decision?
- [ ] Have I checked for edge cases and dependencies?
- [ ] Am I missing context I should ask about?

### Size
- [ ] Is everything in context relevant to current task?
- [ ] Have I removed information from completed phases?
- [ ] Am I under 60% context utilization?

### Trajectory
- [ ] Does this context serve the CURRENT goal?
- [ ] Have I removed context from abandoned approaches?
- [ ] Is the agent heading in the right direction?
```

## Quality Trade-off Examples

### Example 1: Correctness vs Size

```markdown
# Situation
You have a 500-line config file. You need to understand the auth settings.

# Bad: Sacrifice correctness for size
"I'll summarize from memory—auth is probably in the middleware section"

# Good: Accept size cost for correctness
Read the config file. grep for auth patterns. Read the specific sections.
→ More tokens, but accurate understanding.
```

### Example 2: Completeness vs Size

```markdown
# Situation
Implementing a new API endpoint. Related files: routes.ts, controllers/, models/, tests/

# Bad: Sacrifice completeness for size
Only read routes.ts—assume other patterns from one file.

# Good: Accept size cost for completeness
Read routes.ts + one controller + one model + one test.
→ Pattern understanding from multiple examples.
```

### Example 3: Trajectory Correction

```markdown
# Situation
Started implementing Feature A. Discovered it requires Feature B first.
Context is full of Feature A details.

# Bad: Keep Feature A context
Continue referencing Feature A while working on Feature B.

# Good: Correct trajectory
Compact Feature A context. Load Feature B context.
Note current state: "Feature A blocked on Feature B"
→ Fresh context aligned with current work.
```

> **Tip:** Use a new chat session for different work types. Official guidance: "Maintain context isolation: Keep different types of work (planning, coding, testing, debugging) in separate chat sessions to prevent context mixing and confusion." — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

## Related

- [utilization-targets](utilization-targets.md) — Managing the SIZE component
- [compaction-patterns](compaction-patterns.md) — Reducing noise while preserving quality
- [just-in-time-retrieval](just-in-time-retrieval.md) — COMPLETENESS via on-demand loading
- [subagent-isolation](subagent-isolation.md) — Quality via controlled summarization
- [hallucination-reduction](../PATTERNS/hallucination-reduction.md) — CORRECTNESS techniques
- [verification-gates](../PATTERNS/verification-gates.md) — Validating quality at checkpoints

## Official Context Handling Behaviors

These behaviors are documented in VS Code official docs:

| Behavior | Description | Source |
|----------|-------------|--------|
| **File outline fallback** | If full file too large, an outline with functions and descriptions (without implementations) is included | [Copilot Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) |
| **Automatic relevance filtering** | "If the resulting context is too large to fit in the context window, only the most relevant parts are kept" | [Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context) |
| **Workspace index limits** | <750 files: auto-indexed; 750-2500: manual build; >2500: basic index only | [Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context) |
| **Subagent isolation** | "Subagents operate independently...have their own context window...helps to manage context window limitations" | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| **Context summarization** | `github.copilot.chat.summarizeAgentConversationHistory.enabled` auto-summarizes when context window is full | [Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings) |

## Anti-Patterns (Official)

Avoid these patterns documented in VS Code's Context Engineering Guide:

- **Context dumping** — "Avoid providing excessive, unfocused information that doesn't directly help with decision-making"
- **Stale context** — "Regularly audit and update your project documentation...Stale context leads to outdated or incorrect suggestions"
- **Context mixing** — Use separate chat sessions for different work types (planning, coding, testing, debugging)

> Source: [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

## Sources

### Official Documentation
- [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) — Context isolation, anti-patterns, stale context
- [VS Code Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context) — Index limits, relevance filtering
- [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) — Subagent context isolation
- [VS Code 1.100 Release Notes](https://code.visualstudio.com/updates/v1_100) — "Summarized conversation history" feature

### Community Research
- [HumanLayer: Advanced Context Engineering](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents) — Quality hierarchy, leverage model, 40-60% target
- [Anthropic: Effective Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) — Attention budget concept, compaction strategies
- [Anthropic: Reduce Hallucinations](https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/reduce-hallucinations) — Correctness techniques
- [Chroma Research: Lost in the Middle](https://research.trychroma.com/evaluating-chunking) — Context degradation empirical studies
