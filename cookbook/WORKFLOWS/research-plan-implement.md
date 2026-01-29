---
when:
  - starting complex feature development
  - working on unfamiliar codebase
  - maximizing human review leverage
  - structuring multi-session work
pairs-with:
  - spec-driven
  - task-tracking
  - compaction-patterns
  - subagent-isolation
requires:
  - file-write
  - terminal-access
complexity: high
---

# Research → Plan → Implement

> **Platform Note:** VS Code Copilot provides native support for this workflow through the built-in **Plan agent** (`@plan`) and the **Context Engineering** workflow documented in [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide). The human leverage model and specific metrics (~200 lines, 40-60% utilization) are community guidelines from [HumanLayer ACE](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents), not official VS Code documentation.

A three-phase workflow that maximizes human review leverage by compacting context between phases. Each phase produces a ~200 line document that the next phase loads into fresh context—catching errors early where they cost the least.

## Why Three Phases

<!-- NOT IN OFFICIAL DOCS: "Human leverage model" concept is from HumanLayer ACE - flagged 2026-01-25 -->

The human leverage principle:

```
Bad research line  → 1000s of bad lines of code
Bad plan line      → 100s of bad lines of code
Bad code line      → 1 bad line of code

∴ Review ~400 lines of specs (10 minutes) beats reviewing 2000 lines of code (hours)
```

By forcing human review at phase boundaries, you catch fundamental misunderstandings in research (10 lines to fix) rather than in finished code (hundreds of lines to rewrite).

## The Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│  RESEARCH PHASE (Fresh Context)                                 │
│  ├─ Spawn subagents for file discovery                         │
│  ├─ Subagents return ~50 line summaries (not 5000)             │
│  └─ Output: research_doc.md (~200 lines)                       │
├─────────────────────────────────────────────────────────────────┤
│  HUMAN REVIEW (5 minutes) ← Highest leverage point             │
├─────────────────────────────────────────────────────────────────┤
│  PLAN PHASE (Fresh Context)                                     │
│  ├─ Reads research_doc.md                                       │
│  ├─ Creates numbered implementation steps                       │
│  └─ Output: implementation_plan.md (~200 lines)                │
├─────────────────────────────────────────────────────────────────┤
│  HUMAN REVIEW (5 minutes)                                       │
├─────────────────────────────────────────────────────────────────┤
│  IMPLEMENT PHASE (Fresh Context)                                │
│  ├─ Reads implementation_plan.md                                │
│  ├─ Executes steps sequentially                                 │
│  ├─ Compacts progress back to plan when >60%                   │
<!-- NOT IN OFFICIAL DOCS: >60% compaction threshold is a community guideline - flagged 2026-01-25 -->
│  └─ Output: Code + Tests + Updated Plan                        │
└─────────────────────────────────────────────────────────────────┘
```

## Phase Metrics

<!-- NOT IN OFFICIAL DOCS: Context utilization percentages (40-60%), ~200 line outputs, and ~50 line summaries are HumanLayer ACE community guidelines - flagged 2026-01-25 -->

| Phase | Time* | Context Usage | Output |
|-------|-------|---------------|--------|
| Research | ~20 min | 40-60% → compacted to 10% | ~200 lines |
| Plan | ~15 min | 40-50% → compacted to 10% | ~200 lines |
| Implement | Variable | 40-60% (with ongoing compaction) | Code + Tests |

*Time estimates are experiential guidelines, not hard requirements.

## Directory Structure

```
project-root/
├── .github/
│   └── prompts/
│       ├── research-codebase.prompt.md    # Phase 1
│       ├── create-plan.prompt.md          # Phase 2
│       └── implement-plan.prompt.md       # Phase 3
└── thoughts/
    └── shared/
        ├── research/
        │   └── 2026-01-23_authentication-refactor.md
        └── plans/
            └── 2026-01-23_authentication-plan.md
```

## Research Phase Template

```markdown
---
agent: agent
tools: ["search", "read_file", "grep_search"]
---

# Research: {{TOPIC}}

## Objective
Understand the codebase structure related to: {{PROBLEM}}

## Instructions
1. Use #runSubagent for broad file searches (keeps parent context clean)
2. Request summaries from subagents, not raw file contents
3. Target ~200 lines for final output

## Output Format

### Problem Understanding
[2-3 sentence summary of the issue]

### Relevant Files
| File | Purpose | Key Functions |
|------|---------|---------------|
| path/to/file.ts | Description | func1(), func2() |

### Information Flow
[How data moves through the system for this feature]

### Key Findings
- Finding 1
- Finding 2

### Recommended Approach
[High-level strategy—do NOT specify implementation details yet]

### Open Questions
[Anything that needs clarification before planning]
```

## Plan Phase Template

```markdown
---
agent: agent
tools: ["read_file"]
---

# Plan: {{FEATURE/BUG}}

## Input
Read research doc at: thoughts/shared/research/{{RESEARCH_FILE}}

## Instructions
1. Read the research document thoroughly
2. Define numbered, sequential steps
3. Each step must be independently testable
4. Specify exact file paths and function names

## Output Format

### Overview
**Goal:** [One sentence]
**Approach:** [Strategy summary]

### Prerequisites
- [ ] Dependency 1
- [ ] Dependency 2

### Implementation Steps

#### Step 1: [Title]
**Files:** `path/to/file.ts`
**Changes:**
- Add function `foo()` that does X
- Modify `bar()` to call `foo()`

**Test:** `npm test path/to/file.test.ts`
**Verify:** [Expected outcome]

#### Step 2: [Title]
[Same structure...]

### Rollback Plan
[How to revert if something goes wrong]
```

## Implement Phase Template

```markdown
---
agent: agent
tools: ["*"]
---

# Implement: {{PLAN_FILE}}

## Instructions
1. Read the plan at: thoughts/shared/plans/{{PLAN_FILE}}
2. Execute steps IN ORDER
3. Run tests after EACH step
4. Pause for manual verification after completing automated checks for a phase
5. If context exceeds 60%, save progress and request compaction

## Progress Tracking

When context fills, update the plan with current status:

### Step Status
- [x] Step 1: Complete
- [~] Step 2: In Progress — [current status]
- [ ] Step 3: Not Started

### Current Issue
[What's blocking or being worked on]

### Next Actions
[Immediate next steps when resuming]

### Manual Verification Points
After completing automated verification for each major phase:
1. Pause and inform human of results
2. Request review before proceeding to next phase
3. Document any manual verification decisions
```

## Human Review Checklist

### Research Review (5 min)

```markdown
## Research Review Checklist
- [ ] Problem statement matches my understanding
- [ ] All relevant files identified (nothing missing?)
- [ ] Information flow is accurate
- [ ] Recommended approach makes sense
- [ ] No major blind spots or wrong assumptions
```

### Plan Review (5 min)

```markdown
## Plan Review Checklist
- [ ] Steps are in correct order
- [ ] Each step is atomic and testable
- [ ] File paths are correct
- [ ] Test commands will work
- [ ] Rollback plan is viable
- [ ] Nothing over-engineered
```

## When to Use R→P→I

| Scenario | Use R→P→I? | Why |
|----------|------------|-----|
| Complex feature touching 5+ files | ✅ Yes | High leverage from research |
| Bug fix in known location | ❌ No | Overhead not worth it |
| Refactoring across codebase | ✅ Yes | Research prevents missed dependencies |
| Adding new endpoint to existing pattern | ❌ Maybe | Quick if pattern is clear |
| Unfamiliar codebase | ✅ Yes | Research phase essential |

## Integration with Other Patterns

### With Spec-Driven Development

R→P→I executes after specs are approved:

```
Spec-Driven:  Specify → [SPEC APPROVED]
R→P→I:                 → Research → Plan → Implement
```

The spec answers "what to build"; R→P→I answers "how to build it safely."

### With Subagent Isolation

Research phase uses subagents heavily. The hub-and-spoke architecture applies—only the lead agent spawns subagents, and subagents cannot spawn other subagents:

```markdown
Use #runSubagent to survey authentication patterns in src/auth/.
Return: file list, key functions, current auth flow.
Do NOT return file contents—I'll read what I need.
```

Parent context stays clean while subagent does the heavy exploration. Use a dedicated `codebase-locator` agent for comprehensive file discovery tasks:

<!-- NOT IN OFFICIAL DOCS: "codebase-locator" is a custom agent pattern, not a built-in VS Code agent - flagged 2026-01-25 -->

```markdown
Use the codebase-locator agent to find WHERE files and components live.
Spawn parallel sub-agent tasks for comprehensive research.
Return only summaries (~50 lines), not raw file contents.
```

### With Compaction Patterns

Phase transitions are natural compaction points:

- End of Research → Save research_doc.md, clear context
- End of Plan → Save implementation_plan.md, clear context
- During Implement → Save progress to plan when >60%

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| Research output >500 lines | Too much detail | Use subagents, request summaries not contents |
| Plan steps too vague | Skipped research details | Review research doc, identify missing context |
| Implementation stalls | Step too large | Break into smaller substeps |
| Losing progress during implement | No progress tracking | Update plan with step status before compaction |

## Related

- [spec-driven](spec-driven.md) — The "what" before R→P→I's "how"
- [compaction-patterns](../CONTEXT-ENGINEERING/compaction-patterns.md) — Techniques for phase transitions
- [utilization-targets](../CONTEXT-ENGINEERING/utilization-targets.md) — Why 40-60% target matters
- [subagent-isolation](../CONTEXT-ENGINEERING/subagent-isolation.md) — Research phase exploration
- [riper-modes](riper-modes.md) — Alternative 5-mode workflow

## VS Code Native Support

VS Code Copilot provides built-in features that implement this workflow natively:

| Feature | Purpose | How to Use |
|---------|---------|------------|
| **Plan Agent** | Creates structured implementation plans before coding | Use `@plan` in chat or select "Plan" from agent picker |
| **Context Engineering Workflow** | Three-phase workflow: Curate → Plan → Implement | See [VS Code Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) |
| **Handoffs** | Guided transitions between agents | Define `handoffs:` in custom agent frontmatter |
| **Subagents** | Isolated context for research tasks | Use `#runSubagent` tool |
| **Auto-Summarization** | Summarizes when context window fills | Enable `github.copilot.chat.summarizeAgentConversationHistory.enabled` |
| **Todo Lists** | Track implementation progress | Built into Plan agent |

**Native Plan Agent Workflow:**
```
1. Start with @plan agent
2. Plan agent researches using read-only tools
3. Plan agent creates structured implementation plan
4. Review plan, then handoff to implementation agent
5. Implementation agent follows plan, updates progress
```

> **Tip:** You can define custom agents with `handoffs:` to create explicit Research → Plan → Implement transitions:
> ```yaml
> handoffs:
>   - label: Start Implementation
>     agent: implementation
>     prompt: Now implement the plan outlined above.
> ```

Source: [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning), [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

## Sources

- [HumanLayer: Advanced Context Engineering](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents)
- [Anthropic: Effective Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [wshobson/agents: Phased Workflow Patterns](https://github.com/wshobson/agents)
