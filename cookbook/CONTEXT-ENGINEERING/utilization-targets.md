---
when:
  - monitoring context window usage
  - diagnosing quality degradation in long sessions
  - planning phase-based compaction
  - deciding when to split into subagents
pairs-with:
  - compaction-patterns
  - context-quality
  - subagent-isolation
  - just-in-time-retrieval
requires:
  - none
complexity: low
---

# Context Utilization Targets

<!-- NOT IN OFFICIAL DOCS: 40-60% utilization targets - community guideline from HumanLayer ACE, not official VS Code/GitHub Copilot documentation - flagged 2026-01-25 -->

Keep context window usage between 40-60% for optimal agent performance. This prevents "context rot"—the gradual degradation of response quality as the context fills with accumulated noise.

## The 40-60% Rule

| Utilization | Status | Action |
|-------------|--------|--------|
| <40% | Underutilized | Add relevant context |
| **40-60%** | **Optimal** | **Ideal zone for complex tasks** |
| 60-80% | Heavy | Monitor for quality drop |
| >80% | Overloaded | Split into phases immediately |

> **Source:** The 40-60% utilization target comes from [HumanLayer's ACE methodology](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents), based on practitioner experience with FIC (Frequent Intentional Compaction). Anthropic's guidance is more general: "find the smallest possible set of high-signal tokens."

### Why This Range?

- **Below 40%**: Agent lacks sufficient context for complex reasoning
- **40-60%**: "Smart zone" with room for tool outputs and reasoning
- **Above 60%**: Tool results and conversation history start crowding out useful context
- **Above 80%**: Severe quality degradation, repeated suggestions, "hallucinations"

### Context Rot — Scientifically Validated

[Chroma's July 2025 research](https://research.trychroma.com/context-rot) tested 18 LLMs (GPT-4.1, Claude 4, Gemini 2.5, Qwen3) and confirmed that performance degrades as context length increases—validating the "context rot" phenomenon that these utilization targets aim to prevent.

## Why Utilization Matters

**The Leverage Model:**
```
Bad research line    → 1000s of bad code lines
Bad plan line        → 100s of bad code lines
Bad implementation   → 1 bad code line
```

Context utilization directly impacts the quality of high-leverage phases (research, planning). Overloaded context during planning cascades errors into implementation.

## What Fills Context

These accumulate quickly:

| Source | Token Impact | Example |
|--------|--------------|---------|
| File searches | 100-5000+ per file | `read_file` with large files |
| Tool outputs | 500-2000 per call | JSON responses, grep results |
| Tool definitions | Varies by MCP count | See note below |
| Conversation history | Growing | Debugging back-and-forth |
| Test/build logs | 1000+ | Verbose error stacks |
| Code flow traces | Variable | Following function calls |

> **📋 Note:** The ">10% tool definition triggers tool search" behavior is specific to Claude Code, not VS Code Copilot. VS Code Copilot uses a 128 tool limit per request instead.

### Limits to Watch

| Resource | Limit | Source | Reason |
|----------|-------|--------|--------|
| Active tools | **128 per request** | Official | Model constraint; use virtual tools to exceed |
| Instruction files | **~1000 lines** | Official | Beyond this, quality deteriorates |
| Code review instructions | **4000 chars** | Official | Hard limit for code review feature |
| Subagent context | Independent | Official | Each has own context window (size unspecified) |
| Local index files | **2500 files** | Official | Local index limitation |

## Measuring Utilization

VS Code doesn't provide direct token counts. Use these proxy signals:

### Visual Indicators

| Signal | Meaning | Action |
|--------|---------|--------|
| **Index Status** (Status Bar) | Shows Index type, indexing progress | Check if codebase is fully indexed |
| "Summarized conversation history." | Auto-compaction occurred | You're at/past 100% |
| Response slowdown | Heavy context processing | Approaching limits |
| Repeated suggestions | Memory degradation | Context too cluttered |
| "I don't have information about..." | Lost prior context | Session needs reset |

### Manual Estimation

```markdown
## Context Budget (rough estimate)
- copilot-instructions.md: ~500 tokens
- Current file (500 lines): ~2,000 tokens
- Loaded references: ~1,500 tokens
- Conversation history: ~3,000 tokens
- **Estimated total**: ~7,000 / 128,000 (~5%)
```

**Rule of thumb:** 1 line of code ≈ 4 tokens, 1 page of prose ≈ 500 tokens.

## Staying in the Zone

### Strategy 1: Phase-Based Compaction

Split work into phases, compact between each:

```
┌────────────────────────────────────┐
│ RESEARCH (Fresh Context)           │
│ → Output: research_doc.md (~200 lines)
├────────────────────────────────────┤
│ PLAN (Fresh Context)               │
│ → Input: research_doc.md           │
│ → Output: implementation_plan.md   │
├────────────────────────────────────┤
│ IMPLEMENT (Fresh Context)          │
│ → Input: implementation_plan.md    │
│ → Compact when >60%                │
└────────────────────────────────────┘
```

Each phase starts fresh, reading only the compacted output from the previous phase.

### Strategy 2: Subagent Offloading

Spawn subagents for context-heavy exploration:

```markdown
Use #runSubagent to research authentication patterns.
Return a 50-line summary, not raw findings.
```

**Impact:** Subagent uses tokens internally, returns compact summary. Parent context stays clean.

**Subagent context:** Each subagent has its own independent context window. They cannot spawn other subagents—all delegation flows through the main agent.

> **Source:** "Subagents use the same agent and have access to the same tools available to the main chat session, except for creating other subagents." — [VS Code Docs](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

### Strategy 3: Context Editing (Auto-Cleanup)

Anthropic's [context editing](https://claude.com/blog/context-management) automatically clears stale tool calls and results when approaching token limits:

- **84% token reduction** in 100-turn evaluation
- Combined with memory tool: **39% performance improvement**
- Available in Claude Code via auto-compaction

**VS Code behavior:** "If your conversation exceeds the coding agent's context window, VS Code automatically summarizes and condenses the information."

**Setting:** `github.copilot.chat.summarizeAgentConversationHistory.enabled` (Experimental) — Automatically summarizes agent conversation history when context window is full.

**CLI behavior:** GitHub Copilot CLI "automatically compresses your history when approaching 95% of the token limit."

### Strategy 4: Just-in-Time Loading

Load context only when needed:

```markdown
# Good: Progressive
1. Check #selection first
2. If unclear, read #file
3. If still unclear, search #codebase

# Avoid: Upfront loading
Read all files in src/ before starting
```

### Strategy 5: External Offloading

Move context to files, reference when needed:

```markdown
## During Research
Write findings to .github/memory-bank/sessions/_active.md

## During Implementation
Read from memory bank only what's needed:
#file:.github/memory-bank/sessions/_active.md
```

**Anthropic's Memory Tool:** Enables storing and consulting information outside the context window through a file-based system. Combined with context editing, this provides persistent knowledge across sessions.

### Strategy 6: Token-Efficient Formats

When working with structured data, format choice affects token usage:

| Format | Token Efficiency | Best For |
|--------|------------------|----------|
| **TOON** | ~40% fewer than JSON | Data structures, configs, API responses |
| Markdown | Efficient | Prose, documentation |
| YAML | Moderate | Human-readable configs |
| JSON (formatted) | Verbose | Data interchange |

## Compaction Triggers

Clear or compact when you see these signs:

| Trigger | Action |
|---------|--------|
| Completing a logical phase | Start fresh session (`Ctrl+N`) |
| "Summarized conversation history." | Already auto-compacted, consider new session |
| Quality degradation detected | New session and reload essentials |
| Switching major topics | New session with relevant context |
| >60% estimated utilization | Compact findings to file, continue fresh |

> **Note:** VS Code Copilot has no `/clear` command. To clear context, start a new chat session with `Ctrl+N` or "Chat: New Chat" command.

### Manual Compaction

```markdown
## Before Compacting
Write current state to memory:
- What's been done
- What's pending
- Key decisions made

## Compact
Start new chat session (Ctrl+N) to reset context

## After Compacting
Load only what's needed:
- Essential instructions
- Compacted state file
- Current focus area
```

## Quality vs Quantity Trade-off

When context is tight, prioritize:

```
1. ⭐⭐⭐⭐ CORRECTNESS — No false information
2. ⭐⭐⭐   COMPLETENESS — All relevant info
3. ⭐⭐     SIZE — Minimal noise (←utilization)
```

**Never sacrifice correctness for space.** Instead, split work into smaller phases where each phase fits comfortably.

## Related

- [compaction-patterns](./compaction-patterns.md) — How to compact effectively
- [subagent-isolation](./subagent-isolation.md) — Offload to isolated contexts
- [just-in-time-retrieval](./just-in-time-retrieval.md) — Progressive loading patterns
- [context-variables](./context-variables.md) — What fills context
- [memory-bank-schema](../CONFIGURATION/memory-bank-schema.md) — External context storage
- [research-plan-implement](../WORKFLOWS/research-plan-implement.md) — FIC workflow

## Sources

- [Anthropic - Effective Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) — Core principles: compaction, subagents, just-in-time retrieval
- [HumanLayer - Advanced Context Engineering (ACE)](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents) — **40-60% rule**, FIC methodology, leverage model, quality framework
- [Chroma Research - Context Rot](https://research.trychroma.com/context-rot) — July 2025 research validating degradation across 18 LLMs
- [Anthropic - Context Management (Blog)](https://claude.com/blog/context-management) — Context editing and memory tool (September 2025)
- [Ralph Playbook](https://github.com/ClaytonFarr/ralph-playbook) — Subagent context sizes, autonomous development patterns
- [VS Code Docs - Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) — Auto-summarization behavior
