# D2: copilot-instructions.md Redesign

## User Requirements

1. Consolidate critical style rules (no tables, no emojis, imperative voice)
2. copilot-instructions.md should declare project scope and structure
3. Keep things simple and maintainable

---

## Analysis Summary

### D1 Recommendation: Tiered Consolidation
- Move ALL universal rules from prompting.instructions.md into copilot-instructions.md
- Result: ~2,000 token file
- Pro: Reliability — rules always load
- Con: Token bloat on every interaction

### D2 Skeptic Analysis: Lean Approach
- Keep copilot-instructions.md minimal (~500-800 tokens)
- Keep prompting.instructions.md via applyTo
- Pro: Token efficiency
- Con: Relies on applyTo mechanism

---

## Resolved Recommendation: Hybrid Consolidation

Split rules by "always-needed" vs "writing-specific":

### Into copilot-instructions.md (~1,200 tokens)

**Project Identity:**
- 2-sentence description: "Generator workspace for VS Code agentic frameworks. Creates `.github/` scaffolds via guided interview."

**Scope Declaration:**
- In scope: agents, skills, instructions, prompts
- Out of scope: runtime code, non-VS Code integrations, direct codebase modification

**Core Universal Rules:**
- XML usage (tag referencing, headers, workflow structure)
- VS Code references (#file:, #tool:, @agent syntax)
- Formatting (forbidden: tables, emojis, delimiters; permitted: headers, bold, code blocks, lists)
- Instruction writing (positive framing, tool triggers, specificity)
- Anti-patterns (overengineering, test-focused, excessive files)

**Coordination:**
- Workflow protocol (gates, phases)
- Collaboration patterns (context discovery, governance signals)

**References:**
- Official docs, community resources
- Link to architecture.md (not duplicate)

### Keep artifact-style.instructions.md (~650 tokens, unchanged)

- Scoped to `.github/**/*.md` via applyTo
- Content requirements (every file must have, templates must include, etc.)
- Artifact-specific formatting (bold labels, placeholders, backticks rule)

### Move to new skill: prompting-techniques (~600 tokens)

- Behavioral steering templates (proactive/conservative action)
- Research task patterns
- Subagent orchestration guidance
- Thinking guidance

### Remove: prompting.instructions.md

Content redistributed to copilot-instructions.md and prompting-techniques skill.

---

## What NOT to Include in copilot-instructions.md

| Content | Reason | Alternative |
|---------|--------|-------------|
| Agent list | VS Code provides via @ autocomplete | Remove |
| Skill list | VS Code surfaces via pattern matching | Remove |
| Entry point (/interview) | Workflow-specific | generator/user-manual.md |
| Full folder structure | Duplication risk | Reference architecture.md |

---

## Proposed Structure

```markdown
# copilot-instructions.md

[Project identity - 2 sentences]

<scope>
  In/out scope definition
  Architecture reference link
</scope>

<references>
  <official_documentation>
  <community_resources>
</references>

<syntax_conventions>
  Tag referencing, VS Code references
</syntax_conventions>

<formatting>
  Forbidden/permitted formats
</formatting>

<instruction_writing>
  Positive framing, tool triggers, specificity
</instruction_writing>

<anti_patterns>
  Overengineering, test-focused, file creation
</anti_patterns>

<workflow_protocol>
  Gates, phases
</workflow_protocol>

<collaboration_patterns>
  Context discovery, governance
</collaboration_patterns>
```

---

## Single Responsibility Statement

> **copilot-instructions.md defines project identity, scope, universal writing rules, and coordination protocols.**

---

## Token Cost Comparison

| Approach | Base Load | With .github/ Work |
|----------|-----------|-------------------|
| Current | ~2,200 | ~2,850 |
| Full consolidation (D1) | ~2,000 | ~2,650 |
| Lean (D2) | ~500 | ~3,050 |
| **Hybrid (Final)** | **~1,200** | **~1,850** |

Hybrid saves ~350-1,000 tokens per interaction while improving reliability.

---

## Open Questions

1. Should prompting-techniques be a skill or remain inline for always-available?
2. Is 1,200 tokens acceptable base load?
3. How to handle the broken link to knowledge-base/creator-skill-patterns.md?

---

## Iterations Completed: 3/3-4
- [x] D2.1: Project scope declaration
- [x] D2.2: Skeptic perspective
- [x] D2.3: Reconciliation of approaches
