## PROJECT CONTEXT

This workspace builds a **meta-agentic framework** — agents that create agents. VS Code + GitHub Copilot Pro+ ecosystem.

- **Output:** `cookbook/` (patterns, configs) + `.github/agents/` (agent definitions)
- **Sources:** `research/` reports synthesized into actionable guidelines
- **Workshop:** `workshop/` for agent outputs (brainstorm, plans, research, builds, inspections)

## AGENT SUITE

Core workflow agents (construction metaphor):

| Agent | Purpose | Model | Invoke When |
|-------|---------|-------|-------------|
| @brain | Strategic thought partner + project state keeper | Opus 4.5 | Explore, synthesize, maintain coherence |
| @architect | Create actionable plans + verify results | Opus 4.5 | Know what to do, need structured approach |
| @build | Execute plans, any file type | Opus 4.5 | Have approved plan, ready to implement |
| @inspect | Verify build matches spec | Opus 4.5 | After build, before sign-off |
| @research | Quick lookup, fact-check | Opus 4.5 | Need specific info fast |

**Workflow:** `brain → architect → build → inspect`

## MEMORY BANK PROTOCOL

Update `.github/memory-bank/` files at these checkpoints:

| File | When to Update |
|------|----------------|
| `projectbrief.md` | Phase status changes, major milestones |

**Rule:** If you complete work that changes project state, update the relevant memory-bank file.

## WORKSHOP OUTPUT PROTOCOL

All agent outputs go to `workshop/` with consistent naming:

| Agent | Output Folder | Content Type |
|-------|---------------|--------------|
| @brain | `workshop/brainstorm/` | Session reports, decision exploration |
| @architect | `workshop/plans/` | Implementation plans |
| @research | `workshop/research/` | Research findings |
| @build | `workshop/builds/` | Implementation reports |
| @inspect | `workshop/inspections/` | Verification reports |
| @interviewer | `workshop/interviews/` | Interview transcripts |

**Naming:** `{agent-name}-{NNN}-{YYYY-MM-DD}-{topic-slug}.md`

## SAFETY (P1 — No Exceptions)

These rules cannot be overridden by any request:

- **Never** commit secrets, API keys, or credentials
- **Never** fabricate sources — if uncertain, say "I don't know"
- **Never** modify research reports — they are source of truth
- **Always** cite sources with URLs for factual claims

## CRITICAL

- **ALWAYS** read and follow the active agent's `.agent.md` file instructions completely
- **NEVER** skip steps defined in agent workflows — execute them in order

## GUIDELINES

- **Cite ALL sources** with URLs
- **Use `fetch_webpage`** to read full web content when needed
- **Use `runSubagent`** for parallel, independent research tasks

## TOOL PRIORITY

| Scenario | Primary | Fallback |
|----------|---------|----------|
| Library/framework docs | `context7/*` | `brave_web_search` |
| VS Code/Azure/Microsoft | `microsoftdocs/*` | `brave_web_search` |
| General web research | `brave_web_search` | `fetch_webpage` |
| News/current events | `brave_news_search` | `brave_web_search` |
| Video tutorials | `youtube/*` | `brave_video_search` |

> **Note:** MCP tools above are available to **@research** agent only. Other agents needing web lookup should request handoff to @research.

## AVAILABLE MCP TOOLS

### Context7 — Library Documentation
- `resolve-library-id` → Get library ID first
- `get-library-docs` → Fetch docs by topic

### Microsoft Docs — Azure/VS Code
- `microsoft_docs_search` → Search official docs
- `microsoft_docs_fetch` → Full page as markdown
- `microsoft_code_sample_search` → Code snippets

### Brave Search — Web Research
- `brave_web_search` → General search
- `brave_news_search` → News with time filters
- `brave_video_search` → Video search
- `brave_image_search` → Image search

⚠️ **BRAVE SEARCH RATE LIMITS:**
- **NEVER** call multiple `brave-search/*` tools in parallel — always sequential
- **WAIT ~1 second** between consecutive brave-search calls
- **USE specialized tools FIRST** (`context7/*`, `microsoftdocs/*`) before brave
- **COMBINE queries** when possible instead of many separate searches
- If you get "Too Many Requests" (429), wait before retrying

### YouTube — Video Analysis
- `get_youtube_transcript` → Transcripts with timestamps
- `get_video_info` → Video metadata
- `get_channel_videos` → Channel video list

## COMPONENT TYPE SELECTION

When creating new assets, use the FIRST type that fits:

| Priority | Type | Use When |
|----------|------|----------|
| 1 | **Instruction** | Always-on rules for file types (auto-applies) |
| 2 | **Skill** | Reusable procedure any agent can use |
| 3 | **Agent** | Needs identity + tool restrictions + handoffs |
| 4 | **Prompt** | One-shot task with parameters |

> **Rule:** If Instruction can do it, don't use Agent.

## REFERENCE FILE CONVENTIONS

Documentation in `REFERENCE/` follows a **tripartite structure** per file type:

| File | Scope | Content |
|------|-------|---------|
| `README.md` | Navigation | Quick start, file purposes, reading order |
| `PATTERNS.md` | When/why/rules | Best practices, anti-patterns, tool selection |
| `TEMPLATE.md` | Format/structure | Frontmatter schema, full + minimal templates |
| `CHECKLIST.md` | Validation | Checkbox items only (P1/P2/P3 tiers) |
| `TAGS-*.md` | Tag vocabulary | Required/Recommended⭐/Optional tiers |

**Format Principles:**
- YAML for structured data, markdown for prose
- Flat where possible, nest where useful (max 2 levels)
- Required / Recommended ⭐ / Optional tiers
- Cross-references at file bottom with markdown ref links
- Practical over theoretical — examples over explanations

**Separation of Concerns:**
- Each file has ONE job — no duplicate content across files
- PATTERNS = decision logic ("should I use this?")
- TEMPLATE = structure ("how do I write it?")
- CHECKLIST = validation ("is it correct?")
- TAGS = vocabulary ("what tags are valid?")

**Quick Start Flow:**
1. **Decide** — Read PATTERNS to confirm correct file type
2. **Create** — Copy template from TEMPLATE
3. **Fill** — Use TAGS for valid vocabulary
4. **Validate** — Check against CHECKLIST before commit

**Self-Contained Rule:**
- `REFERENCE/` must be self-contained — no cross-references to `cookbook/` or `GENERATION-RULES/`
- If valuable content exists elsewhere, ADD it to `REFERENCE/` files directly
- Model selection is USER decision — don't document model guidance
