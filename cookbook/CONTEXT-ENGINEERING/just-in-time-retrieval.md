---
when:
  - avoiding upfront context overload
  - implementing progressive context loading
  - keeping lightweight identifiers vs full content
  - optimizing context utilization
pairs-with:
  - context-quality
  - utilization-targets
  - subagent-isolation
  - compaction-patterns
requires:
  - none
complexity: low
---

# Just-in-Time Retrieval

Load context when needed, not upfront. Keep lightweight identifiers (file paths, queries, links) in context and retrieve full content only when the agent needs it for the current step.

## Why Just-in-Time

| Approach | Token Cost | Agent Control | Context Quality |
|----------|------------|---------------|-----------------|
| **Pre-load everything** | High upfront | None | Noisy, may miss updates |
| **Traditional RAG** | Medium, chunked | Limited | May miss relationships |
| **Just-in-Time** | Pay-as-you-go | Full | Fresh, targeted |

<!-- NOT IN OFFICIAL DOCS: 40-60% utilization target - community guideline from HumanLayer ACE - flagged 2026-01-25 -->
Just-in-time retrieval keeps utilization in the 40-60% sweet spot by loading only what's needed for the current decision. Loading too much upfront causes **stale context**—where agent performance degrades as irrelevant tokens accumulate.

> **Note:** Official VS Code docs refer to "stale context" rather than "context rot." The docs advise: "Keep context fresh: Regularly audit and update your project documentation... Stale context leads to outdated or incorrect suggestions." — [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

## JIT vs Traditional RAG

```
Traditional RAG:
[Embed everything] → [Retrieve chunks] → [Load into context]
Problem: Agent has no control over what chunks are selected

Just-In-Time:
[Keep file paths] → [Agent decides what to read] → [Load specific files]
Benefit: Agent uses judgment about what's actually relevant
```

## Hybrid Strategy

The most effective agents combine upfront loading with JIT retrieval:

| Approach | When to Use | Example |
|----------|-------------|---------|
| **Upfront** | Small, stable, frequently-needed | CLAUDE.md, copilot-instructions.md |
| **JIT** | Large, dynamic, task-specific | Source files, test results, logs |
| **Hybrid** | Mixture | Instructions upfront + code on-demand |

```
Hybrid pattern:
1. Load project instructions upfront (always needed)
2. Keep file paths as lightweight identifiers (cheap)
3. Let agent decide what to read based on current task (JIT)
```

This hybrid approach is recommended by [Anthropic's Context Engineering guide](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents): retrieve some data upfront for speed, while pursuing further autonomous exploration as needed.

## Progressive Disclosure Stack

Load context in layers, from lightweight to detailed:

```
┌─────────────────────────────────────────────────────────────┐
│ Layer 1: METADATA                                           │
│ • File names, paths, directory structure                    │
│ • Timestamps, folder hierarchies (implicit signals)         │
│ • Always available, near-zero token cost                    │
├─────────────────────────────────────────────────────────────┤
│ Layer 2: INSTRUCTIONS                                       │
│ • SKILL.md overview, prompt file headers                    │
│ • Loaded when skill/prompt invoked                          │
├─────────────────────────────────────────────────────────────┤
│ Layer 3: RESOURCES                                          │
│ • Full file contents, reference docs, data files            │
│ • Loaded only on explicit request                           │
└─────────────────────────────────────────────────────────────┘
```

**Metadata signals:** File names, timestamps, and folder hierarchies provide important contextual signals for JIT decisions—they help the agent decide *what* to load without loading the actual content.

**Rule:** Keep references one level deep from the entry point. SKILL.md points to files; files don't point to more files.

## Tool Patterns for JIT

Use narrow tools first, expand only when needed:

| Pattern | Tool Sequence | When to Use |
|---------|---------------|-------------|
| **Narrow first** | `#selection` → `#<filename>` → `#codebase` | Unknown scope |
| **Path discovery** | `#listDirectory` → `#fileSearch` → `#readFile` | Exploring structure |
| **Content search** | `#textSearch` → `#readFile` | Finding patterns |
| **Semantic lookup** | `#codebase` (semantic search) → `#readFile` | Conceptual queries |

> **Tool naming:** VS Code Copilot uses camelCase tool names prefixed with `#`. See [VS Code Copilot Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) for the complete list.

### Path Discovery Example

```markdown
## Task: Find authentication middleware

1. #listDirectory("src/") → see structure
2. #listDirectory("src/middleware/") → find auth-related files
3. #textSearch("authenticate|authorize") → locate usage
4. #readFile("src/middleware/auth.ts") → read the relevant file
```

### Content Search Example

```markdown
## Task: Understand error handling pattern

1. #textSearch("catch|throw|Error") → find error handling locations
2. Identify most relevant file from results
3. #readFile(relevant file) → read the file content
```

## Lightweight Identifiers

Keep pointers in context instead of content:

| Instead of | Keep |
|------------|------|
| Full file contents | File path: `src/auth/middleware.ts` |
| Database results | Query: `SELECT * FROM users WHERE active` |
| API documentation | URL: `https://api.example.com/docs` |
| Search results | Search term: `"authentication flow"` |

When you need the content, retrieve it fresh—you get current state, not stale cache.

## Anti-Patterns

### ❌ Pre-loading Everything

```markdown
# Bad: Front-loads irrelevant context
Read all files in src/api/ before analyzing the authentication bug.
```

### ✅ JIT Approach

```markdown
# Good: Load only what's relevant
1. Read the bug report to understand the symptom
2. Search for "authentication" in src/api/
3. Read only the files that appear in stack traces
```

### ❌ Eager Full-File Reads

```markdown
# Bad: Wastes tokens on unchanged boilerplate
Read the entire 500-line config file.
```

### ✅ Targeted Line Reads

```markdown
# Good: Read what matters
1. #textSearch for the specific setting
2. #readFile on the file containing the match
```

## Integration Patterns

### With Subagents

Subagents implement JIT at the session level:

```markdown
Use #runSubagent to research payment integrations.
Return only: file paths, key functions, integration points.
Do NOT return file contents—I'll read what I need.
```

Parent context receives a lightweight summary. If specific files matter, parent reads them directly with fresh JIT calls.

### With Memory Bank

<!-- NOT IN OFFICIAL DOCS: memory-bank pattern is a community pattern (from Cline) - flagged 2026-01-25 -->

> **Community Pattern:** The memory bank pattern is not part of official VS Code Copilot documentation. Official VS Code stores preferences in `.editorconfig`, `CONTRIBUTING.md`, and `README.md`. See [VS Code Copilot Context](https://learn.microsoft.com/en-us/visualstudio/ide/copilot-context-overview).

Memory files are lightweight identifiers:

```markdown
# In activeContext.md
## Current Focus
- Authentication refactor: src/auth/*.ts
- Related tests: tests/auth/*.test.ts
- API docs: https://docs.auth.example.com/v2
```

The paths exist in context; full content is loaded only when needed.

### With Skills

Skills use progressive disclosure by design:

```
skill-name/
├── SKILL.md         # Layer 2: Loaded when skill invoked
├── references/      # Layer 3: Loaded only if explicitly needed
└── scripts/         # Layer 3: Loaded when running specific script
```

SKILL.md serves as the overview. Reference files are retrieved just-in-time when the agent needs specifics.

## Measuring JIT Effectiveness

<!-- NOT IN OFFICIAL DOCS: Context percentage targets are community guidelines - flagged 2026-01-25 -->

| Metric | Good JIT | Poor JIT |
|--------|----------|----------|
| Files read per task | 3-5 targeted | 10+ exploratory |
| Lines read per file | Specific ranges | Full files |
| Context at task end | <60% utilized | >80% utilized |
| Stale content issues | Rare (fresh reads) | Common (cached) |

> **Note:** The context utilization percentages are community guidelines from HumanLayer ACE, not official VS Code targets. GitHub Copilot CLI warns at <20% remaining and auto-compresses at 95%. Source: [GitHub Copilot CLI Context Management](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli#context-management)

## Related

- [context-variables](context-variables.md) — Tool syntax for JIT retrieval (`#<filename>`, `#textSearch`)
- [utilization-targets](utilization-targets.md) — Why JIT keeps context usage efficient
- [subagent-isolation](subagent-isolation.md) — Session-level JIT via delegation
- [compaction-patterns](compaction-patterns.md) — What to do after loading (clear when done)
- [skills-format](../CONFIGURATION/skills-format.md) — Progressive disclosure in skill design

## Sources

- [VS Code Copilot Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) — Official tool names and capabilities
- [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) — Context management principles
- [VS Code Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) — Progressive disclosure in skills
- [GitHub Copilot CLI Context Management](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli#context-management) — Official context thresholds
- [Anthropic: Effective Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) — Hybrid retrieval strategies
- [HumanLayer ACE](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents) — Community context guidelines
