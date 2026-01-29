# Official Docs Validation Tracker

> **Purpose:** Track validation of cookbook files against official VS Code/GitHub Copilot documentation. This tracker also serves as a **knowledge base** capturing key findings from official docs — usable as a cookbook reference after completion.

**Started:** 2026-01-24
**Platform:** VS Code + GitHub Copilot
**Models Used:** Claude Opus 4.5, Gemini 3 Pro

---

## Tier 1 URLs (Must Read)

⚠️ **Review and modify before first run.**

| # | URL | Topics Covered |
|---|-----|----------------|
| D1 | https://code.visualstudio.com/docs/copilot/customization/custom-agents | Agent files, frontmatter, model, handoffs |
| D2 | https://code.visualstudio.com/docs/copilot/customization/prompt-files | Prompt files, variables |
| D3 | https://code.visualstudio.com/docs/copilot/customization/custom-instructions | Instruction files, scoping |
| D4 | https://code.visualstudio.com/docs/copilot/customization/mcp-servers | MCP configuration |
| D5 | https://code.visualstudio.com/docs/copilot/chat/chat-tools | Tools, tool sets |
| D6 | https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context | Context management |
| D7 | https://code.visualstudio.com/docs/copilot/chat/chat-sessions | Sessions, subagents |
| D8 | https://docs.github.com/en/copilot/customizing-copilot | GitHub customization |
| D9 | https://modelcontextprotocol.io/docs/learn/architecture | MCP architecture |
| D10 | https://modelcontextprotocol.io/docs/learn/server-concepts | MCP primitives |

---

## Validation Status

| # | File | Section | Status | Corrections | Additions | Silent | Conflicts | Validated |
|---|------|---------|--------|-------------|-----------|--------|-----------|-----------|
| 1 | agent-file-format.md | CONFIGURATION | ✅ | 4 | 3 | 3 | 0 | 2026-01-24 |
| 2 | instruction-files.md | CONFIGURATION | ✅ | 3 | 2 | 2 | 0 | 2026-01-24 |
| 3 | skills-format.md | CONFIGURATION | ✅ | 5 | 1 | 2 | 0 | 2026-01-24 |
| 4 | prompt-files.md | CONFIGURATION | ✅ | 4 | 2 | 0 | 0 | 2026-01-24 |
| 5 | settings-reference.md | CONFIGURATION | ✅ | 5 | 8 | 1 | 0 | 2026-01-24 |
| 6 | mcp-servers.md | CONFIGURATION | ✅ | 2 | 5 | 3 | 0 | 2026-01-24 |
| 7 | file-structure.md | CONFIGURATION | ✅ | 1 | 4 | 2 | 0 | 2026-01-24 |
| 8 | memory-bank-schema.md | CONFIGURATION | ✅ | 1 | 5 | 3 | 0 | 2026-01-24 |
| 9 | context-variables.md | CONTEXT-ENGINEERING | ✅ | 4 | 8 | 2 | 1 | 2026-01-25 |
| 10 | utilization-targets.md | CONTEXT-ENGINEERING | ✅ | 5 | 6 | 3 | 0 | 2026-01-25 |
| 11 | compaction-patterns.md | CONTEXT-ENGINEERING | ✅ | 2 | 2 | 4 | 0 | 2026-01-25 |
| 12 | subagent-isolation.md | CONTEXT-ENGINEERING | ✅ | 3 | 4 | 2 | 0 | 2026-01-25 |
| 13 | just-in-time-retrieval.md | CONTEXT-ENGINEERING | ✅ | 6 | 3 | 4 | 1 | 2026-01-25 |
| 14 | context-quality.md | CONTEXT-ENGINEERING | ✅ | 4 | 5 | 5 | 0 | 2026-01-25 |
| 15 | spec-driven.md | WORKFLOWS | ✅ | 4 | 2 | 3 | 0 | 2026-01-25 |
| 16 | spec-templates.md | WORKFLOWS | ✅ | 0 | 1 | 6 | 0 | 2026-01-25 |
| 17 | research-plan-implement.md | WORKFLOWS | ✅ | 3 | 1 | 5 | 0 | 2026-01-25 |
| 18 | riper-modes.md | WORKFLOWS | ✅ | 3 | 2 | 2 | 0 | 2026-01-25 |
| 19 | wrap-task-decomposition.md | WORKFLOWS | ✅ | 3 | 4 | 0 | 0 | 2026-01-25 |
| 20 | handoffs-and-chains.md | WORKFLOWS | ✅ | 4 | 1 | 2 | 0 | 2026-01-25 |
| 21 | workflow-orchestration.md | WORKFLOWS | ✅ | 4 | 5 | 0 | 0 | 2026-01-25 |
| 22 | conditional-routing.md | WORKFLOWS | ✅ | 3 | 6 | 4 | 0 | 2026-01-25 |
| 23 | task-tracking.md | WORKFLOWS | ✅ | 4 | 5 | 2 | 0 | 2026-01-25 |
| 24 | iron-law-discipline.md | PATTERNS | ✅ | 1 | 5 | 4 | 0 | 2026-01-25 |
| 25 | verification-gates.md | PATTERNS | ✅ | 3 | 6 | 3 | 0 | 2026-01-25 |
| 26 | hallucination-reduction.md | PATTERNS | ✅ | 8 | 6 | 5 | 0 | 2026-01-25 |
| 27 | twelve-factor-agents.md | PATTERNS | ✅ | 3 | 5 | 4 | 0 | 2026-01-25 |
| 28 | prompt-engineering.md | PATTERNS | ✅ | 4 | 5 | 4 | 0 | 2026-01-25 |
| 29 | constitutional-principles.md | PATTERNS | ✅ | 2 | 3 | 6 | 0 | 2026-01-25 |
| 30 | constraint-hierarchy.md | PATTERNS | ✅ | 2 | 4 | 2 | 0 | 2026-01-25 |
| 31 | memory-bank-files.md | CONTEXT-MEMORY | ✅ | 2 | 5 | 4 | 0 | 2026-01-26 |
| 32 | tiered-memory.md | CONTEXT-MEMORY | ✅ | 3 | 5 | 4 | 0 | 2026-01-26 |
| 33 | conflict-resolution.md | CONTEXT-MEMORY | ✅ | 2 | 3 | 6 | 0 | 2026-01-26 |
| 34 | session-handoff.md | CONTEXT-MEMORY | ✅ | 5 | 4 | 3 | 0 | 2026-01-26 |
| 35 | telos-goals.md | CONTEXT-MEMORY | ✅ | 0 | 2 | 6 | 0 | 2026-01-26 |
| 36 | permission-levels.md | CHECKPOINTS | ✅ | 3 | 8 | 4 | 0 | 2026-01-26 |
| 37 | destructive-ops.md | CHECKPOINTS | ✅ | 3 | 6 | 2 | 1 | 2026-01-26 |
| 38 | escalation-tree.md | CHECKPOINTS | ✅ | 2 | 2 | 8 | 0 | 2026-01-26 |
| 39 | approval-gates.md | CHECKPOINTS | ✅ | 4 | 8 | 2 | 1 | 2026-01-26 |
| 40 | four-modes.md | RED-TEAM | ✅ | 2 | 3 | 4 | 0 | 2026-01-26 |
| 41 | iron-law-verification.md | RED-TEAM | ⏳ | - | - | - | - | - |
| 42 | critique-template.md | RED-TEAM | ⏳ | - | - | - | - | - |
| 43 | keyboard-shortcuts.md | REFERENCE | ⏳ | - | - | - | - | - |
| 44 | mcp-server-stacks.md | REFERENCE | ⏳ | - | - | - | - | - |
| 45 | vision-capabilities.md | REFERENCE | ⏳ | - | - | - | - | - |
| 46 | collections-format.md | REFERENCE | ⏳ | - | - | - | - | - |
| 47 | spec-template.md | TEMPLATES | ⏳ | - | - | - | - | - |
| 48 | validation-checklist.md | TEMPLATES | ⏳ | - | - | - | - | - |
| 49 | constitution-template.md | TEMPLATES | ⏳ | - | - | - | - | - |

**Legend:** ⏳ Pending | ✅ Complete | ⚠️ Has Flags

---

## Silent Flags (User Review Required)

Items where official docs don't mention what cookbook claims. User decides: keep, remove, or add caveat.

| # | File | Claim | Added Date | Decision | Resolved |
|---|------|-------|------------|----------|----------|
| 1 | agent-file-format.md | `permissions` field with mode/allow/deny/ask | 2026-01-24 | PENDING | ⏳ |
| 2 | agent-file-format.md | `checkpoints` frontmatter field | 2026-01-24 | PENDING | ⏳ |
| 3 | agent-file-format.md | `escalation` frontmatter field | 2026-01-24 | PENDING | ⏳ |
| 4 | instruction-files.md | Negation patterns in `applyTo` (e.g., `!**/node_modules/**`) | 2026-01-24 | PENDING | ⏳ |
| 5 | instruction-files.md | Cross-tool soft-linking strategy (AGENTS.md → CLAUDE.md, etc.) | 2026-01-24 | PENDING | ⏳ |
| 6 | skills-format.md | `chat.agentSkillsLocations` setting for custom skill locations | 2026-01-24 | ✅ CONFIRMED | ✅ |
| 7 | skills-format.md | Single asset file < 5 MB limit | 2026-01-24 | PENDING | ⏳ |
| 8 | settings-reference.md | `chat.restoreLastPanelSession` setting | 2026-01-24 | PENDING | ⏳ |
| 9 | mcp-servers.md | `disabledMcpServers` setting for disabling specific servers | 2026-01-24 | PENDING | ⏳ |
| 10 | mcp-servers.md | Audit log event `copilot.swe_agent_mcp_config_updated` | 2026-01-24 | PENDING | ⏳ |
| 11 | mcp-servers.md | MCP tools have no VS Code API access | 2026-01-24 | PENDING | ⏳ |
| 12 | file-structure.md | `chat.agentSkillsLocations` setting for configuring skill paths | 2026-01-24 | PENDING | ⏳ |
| 13 | file-structure.md | `memory-bank/` folder pattern | 2026-01-24 | PENDING | ⏳ |
| 14 | memory-bank-schema.md | `.github/memory-bank/` folder structure | 2026-01-24 | KEEP (community pattern, clearly documented) | ✅ |
| 15 | memory-bank-schema.md | Manifest file pattern | 2026-01-24 | KEEP (extended pattern, documented) | ✅ |
| 16 | memory-bank-schema.md | Tiered memory architecture (Hot/Warm/Cold/Frozen) | 2026-01-24 | KEEP (extended pattern from mem0, documented) | ✅ |
| 17 | context-variables.md | Context budget percentages (40-60% optimal, >80% overloaded) | 2026-01-25 | PENDING (community guidelines, not official) | ⏳ |
| 18 | context-variables.md | `#file:path` shorthand syntax | 2026-01-25 | See CONFLICT #1 | ⏳ |
| 19 | utilization-targets.md | 40-60% context utilization targets | 2026-01-25 | PENDING (HumanLayer ACE community guideline) | ⏳ |
| 20 | utilization-targets.md | >10% tool definition triggers tool search (Claude Code specific) | 2026-01-25 | PENDING (Claude Code, not VS Code Copilot) | ⏳ |
| 21 | utilization-targets.md | MCP servers <10 per project recommendation | 2026-01-25 | PENDING (community recommendation) | ⏳ |
| 22 | compaction-patterns.md | >60% context utilization as compaction trigger | 2026-01-25 | KEEP (community guideline, clearly attributed to HumanLayer ACE) | ✅ |
| 23 | compaction-patterns.md | ~200 lines research output guideline | 2026-01-25 | KEEP (community pattern from FIC, flagged in file) | ✅ |
| 24 | compaction-patterns.md | `search.exclude` affects Copilot indexing | 2026-01-25 | PENDING (only `files.exclude` documented, not `search.exclude`) | ⏳ |
| 25 | compaction-patterns.md | Context quality priority hierarchy (Correctness > Completeness > Size > Trajectory) | 2026-01-25 | KEEP (community pattern, clearly attributed to HumanLayer ACE) | ✅ |
| 26 | subagent-isolation.md | ~156kb context window size | 2026-01-25 | KEEP (flagged as community guideline from Ralph Playbook) | ✅ |
| 27 | subagent-isolation.md | ~50 lines recommended summary output | 2026-01-25 | KEEP (flagged as community guideline from FIC) | ✅ |
| 28 | just-in-time-retrieval.md | 40-60% context utilization target | 2026-01-25 | KEEP (flagged as community guideline from HumanLayer ACE) | ✅ |
| 29 | just-in-time-retrieval.md | Memory Bank pattern (`.github/memory-bank/`) | 2026-01-25 | KEEP (flagged as community pattern from Cline) | ✅ |
| 30 | just-in-time-retrieval.md | "Context rot" terminology | 2026-01-25 | CORRECTED to "stale context" (official VS Code term) | ✅ |
| 31 | just-in-time-retrieval.md | <60%/>80% context thresholds | 2026-01-25 | KEEP (flagged as community guidelines) | ✅ |
| 32 | context-quality.md | "context rot" terminology | 2026-01-25 | CORRECTED to "stale context" (official VS Code term) | ✅ |
| 33 | context-quality.md | Quality hierarchy (Correctness > Completeness > Size > Trajectory) | 2026-01-25 | KEEP (flagged as community pattern from HumanLayer ACE) | ✅ |
| 34 | context-quality.md | "leverage model" for error propagation | 2026-01-25 | KEEP (flagged as community pattern from HumanLayer ACE) | ✅ |
| 35 | context-quality.md | 40-60% utilization target | 2026-01-25 | KEEP (flagged as community guideline from HumanLayer ACE) | ✅ |
| 36 | context-quality.md | 128K-200K token window sizes | 2026-01-25 | KEEP (flagged as research note, not official) | ✅ |
| 37 | spec-driven.md | Spec-Kit commands (`/speckit.specify`, `/speckit.plan`, etc.) | 2026-01-25 | KEEP (flagged as external toolkit, not native VS Code) | ✅ |
| 38 | spec-driven.md | Spec-driven development phases (Specify → Plan → Tasks → Implement) | 2026-01-25 | KEEP (flagged as Spec-Kit methodology) | ✅ |
| 39 | spec-driven.md | EARS (Easy Approach to Requirements Syntax) notation | 2026-01-25 | KEEP (flagged as external standard with attribution) | ✅ |
| 40 | spec-templates.md | `.spec.md` file extension | 2026-01-25 | KEEP (Spec-Kit convention, clearly attributed) | ✅ |
| 41 | spec-templates.md | TELOS framework (Mission/Goals/Problems/Challenges) | 2026-01-25 | KEEP (external framework, flagged with attribution) | ✅ |
| 42 | spec-templates.md | TELOS-Lite questionnaire | 2026-01-25 | KEEP (cookbook adaptation, flagged as such) | ✅ |
| 43 | spec-templates.md | EARS notation for acceptance criteria | 2026-01-25 | KEEP (external standard, flagged with attribution) | ✅ |
| 44 | spec-templates.md | 5-Gate validation checklist | 2026-01-25 | KEEP (cookbook pattern, self-contained) | ✅ |
| 45 | spec-templates.md | Leverage model concept (bad research → bad code) | 2026-01-25 | KEEP (HumanLayer ACE, flagged with attribution) | ✅ |
| 46 | research-plan-implement.md | Human leverage model (bad research → 1000s bad code) | 2026-01-25 | KEEP (HumanLayer ACE, flagged with attribution) | ✅ |
| 47 | research-plan-implement.md | ~200 line document output per phase | 2026-01-25 | KEEP (community guideline, flagged) | ✅ |
| 48 | research-plan-implement.md | ~50 line subagent summaries | 2026-01-25 | KEEP (community guideline, flagged) | ✅ |
| 49 | research-plan-implement.md | 40-60% context utilization target | 2026-01-25 | KEEP (HumanLayer ACE guideline, flagged) | ✅ |
| 50 | research-plan-implement.md | >60% triggers compaction | 2026-01-25 | KEEP (community guideline, flagged) | ✅ |
| 51 | research-plan-implement.md | `codebase-locator` custom agent pattern | 2026-01-25 | KEEP (custom pattern example, flagged) | ✅ |
| 52 | riper-modes.md | RIPER 5-mode framework | 2026-01-25 | KEEP (community pattern, platform note added) | ✅ |
| 53 | riper-modes.md | Memory bank integration (`.github/memory-bank/`) | 2026-01-25 | KEEP (community pattern, flagged with note) | ✅ |
| 54 | handoffs-and-chains.md | `escalation:` frontmatter field | 2026-01-25 | KEEP (flagged as community pattern with alternative approach) | ✅ |
| 55 | handoffs-and-chains.md | Beads dependency notation (blocks, related, parent, discovered-from) | 2026-01-25 | KEEP (flagged as community pattern with source attribution) | ✅ |
| 56 | conditional-routing.md | RIPER mode-based routing | 2026-01-25 | KEEP (community pattern from CursorRIPER, flagged in Sources) | ✅ |
| 57 | conditional-routing.md | LLM-powered classification with confidence thresholds | 2026-01-25 | KEEP (community pattern from Dify, flagged in Sources) | ✅ |
| 58 | conditional-routing.md | Keyword matching routing strategy | 2026-01-25 | KEEP (general pattern, no official guidance) | ✅ |
| 59 | conditional-routing.md | Complexity scoring (Never/Offer/Single/Research) | 2026-01-25 | KEEP (community pattern, flagged) | ✅ |
| 60 | task-tracking.md | `.github/memory-bank/features/auth/tasks.yaml` folder pattern | 2026-01-25 | KEEP (community pattern from Cline/Roo Code, flagged in file) | ✅ |
| 61 | task-tracking.md | Beads dependency notation (blocks, blocked-by, discovered-from, related) | 2026-01-25 | KEEP (external tool pattern, clearly attributed with source) | ✅ |
| 62 | iron-law-discipline.md | "Iron Law" pattern terminology | 2026-01-25 | KEEP (obra/superpowers pattern, platform note added) | ✅ |
| 63 | iron-law-discipline.md | "Red Flags" stop conditions pattern | 2026-01-25 | KEEP (obra/superpowers pattern, platform note added) | ✅ |
| 64 | iron-law-discipline.md | "Rationalization Prevention Table" pattern | 2026-01-25 | KEEP (obra/superpowers pattern, platform note added) | ✅ |
| 65 | iron-law-discipline.md | `.critique.md` file format | 2026-01-25 | KEEP (cookbook-defined format, HTML comment added) | ✅ |
| 66 | iron-law-discipline.md | Severity levels (None/Low/Medium/High/Critical) | 2026-01-25 | KEEP (cookbook design pattern, HTML comment added) | ✅ |
| 67 | iron-law-discipline.md | Self-verification checklist pattern | 2026-01-25 | KEEP (implementation pattern, no VS Code equivalent) | ✅ |
| 68 | iron-law-discipline.md | 12-Factor Agents references | 2026-01-25 | KEEP (HumanLayer framework, HTML comment added) | ✅ |
| 69 | verification-gates.md | Test coverage thresholds (80% general, 100% security) | 2026-01-25 | KEEP (community guideline, HTML comment + note added) | ✅ |
| 70 | verification-gates.md | "Dual review pattern" (spec compliance then code quality) | 2026-01-25 | KEEP (obra/superpowers pattern, HTML comment added) | ✅ |
| 71 | verification-gates.md | "Backpressure testing" terminology | 2026-01-25 | KEEP (community pattern from Claude Code, HTML comment added) | ✅ |
| 72 | hallucination-reduction.md | "I Don't Know" pattern (explicitly permitting uncertainty) | 2026-01-25 | KEEP (MS UX guidance confirms: "Withhold outputs when necessary") | ✅ |
| 73 | hallucination-reduction.md | Direct Quote Grounding pattern | 2026-01-25 | KEEP (MS UX guidance confirms: "direct quotes from the source") | ✅ |
| 74 | hallucination-reduction.md | Citation Verification self-retraction pattern | 2026-01-25 | KEEP (flagged as community pattern, HTML comment added) | ✅ |
| 75 | hallucination-reduction.md | Best-of-N Verification pattern | 2026-01-25 | KEEP (flagged as prompt engineering research, not official) | ✅ |
| 76 | hallucination-reduction.md | Chain-of-Verification (CoVe) methodology | 2026-01-25 | KEEP (flagged as Meta/ACL research, HTML comment added) | ✅ |
| 77 | twelve-factor-agents.md | "Dumb Zone" 40-60% utilization thresholds | 2026-01-25 | KEEP (HumanLayer ACE, flagged with HTML comment + note) | ✅ |
| 78 | twelve-factor-agents.md | WRAP pattern (Wholistic, Research, Atomic, Present) | 2026-01-25 | KEEP (community pattern, HTML comment added) | ✅ |
| 79 | twelve-factor-agents.md | Stateless reducer model | 2026-01-25 | KEEP (conceptual model from HumanLayer, platform note added) | ✅ |
| 80 | twelve-factor-agents.md | Memory bank as persistence layer | 2026-01-25 | KEEP (community pattern, official uses sessions/checkpoints) | ✅ |
| 81 | prompt-engineering.md | "4 Ss Framework" named as Microsoft's mnemonic | 2026-01-25 | KEEP (individual principles confirmed, mnemonic name flagged in file) | ✅ |
| 82 | prompt-engineering.md | "ReAct Pattern" as VS Code terminology | 2026-01-25 | KEEP (research pattern, flagged with note in file) | ✅ |
| 83 | prompt-engineering.md | "Tree of Thoughts" pattern | 2026-01-25 | KEEP (research pattern, flagged with note in file) | ✅ |
| 84 | prompt-engineering.md | Query Complexity Routing levels | 2026-01-25 | KEEP (community pattern, flagged with note in file) | ✅ |
| 85 | constitutional-principles.md | `memory/constitution.md` location | 2026-01-25 | KEEP (flagged as community pattern from Cline Memory Bank) | ✅ |
| 86 | constitutional-principles.md | Constraint priority hierarchy (Safety > Project > Behavioral > User) | 2026-01-25 | CORRECTED (platform note: VS Code combines with "no specific order guaranteed") | ✅ |
| 87 | constitutional-principles.md | Hard constraints vs contextual guidelines distinction | 2026-01-25 | KEEP (flagged as design pattern, not platform feature) | ✅ |
| 88 | constitutional-principles.md | Protection Level markers (!cp, !cg, etc.) | 2026-01-25 | KEEP (flagged as CursorRIPER.sigma pattern, not VS Code) | ✅ |
| 89 | constitutional-principles.md | Spec-Kit constitutional principles | 2026-01-25 | KEEP (flagged as external CLI tool, not native VS Code) | ✅ |
| 90 | constitutional-principles.md | `memory/protection.md` file pattern | 2026-01-25 | KEEP (flagged as CursorRIPER.sigma pattern, not VS Code) | ✅ |
| 91 | constraint-hierarchy.md | Four-tier priority system (Safety > Context > Behavioral > User) | 2026-01-25 | KEEP (flagged as design pattern, platform note exists) | ✅ |
| 92 | constraint-hierarchy.md | Protection level markers (!cp, !cg, !ci, !cd, !ct, !cc) | 2026-01-25 | KEEP (flagged as CursorRIPER.sigma pattern in file) | ✅ |
| 93 | memory-bank-files.md | `.github/memory-bank/` folder pattern | 2026-01-26 | KEEP (platform note added, community pattern from Cline) | ✅ |
| 94 | memory-bank-files.md | 6-file core pattern (projectbrief, productContext, etc.) | 2026-01-26 | KEEP (platform note added, Cline origin documented) | ✅ |
| 95 | memory-bank-files.md | `manifest.yaml` file | 2026-01-26 | KEEP (community extension, schema documented separately) | ✅ |
| 96 | memory-bank-files.md | Update triggers and file dependencies | 2026-01-26 | KEEP (implementation pattern, no official equivalent) | ✅ |
| 97 | tiered-memory.md | Hot/Warm/Cold/Frozen tier terminology | 2026-01-26 | KEEP (platform note exists, synthesized from mem0/CrewAI/Azure) | ✅ |
| 98 | tiered-memory.md | <40%, 40-60%, >60%, >80% utilization thresholds | 2026-01-26 | KEEP (flagged as HumanLayer ACE community guideline) | ✅ |
| 99 | tiered-memory.md | 70% and 85% compaction triggers | 2026-01-26 | KEEP (flagged as community guidelines, VS Code native summarization added) | ✅ |
| 100 | tiered-memory.md | `.github/memory-bank/` folder pattern | 2026-01-26 | KEEP (community pattern, consistent with memory-bank-files.md) | ✅ |
| 101 | conflict-resolution.md | ADD/UPDATE/DELETE/NOOP model | 2026-01-26 | KEEP (flagged as mem0 research pattern, HTML comment added) | ✅ |
| 102 | conflict-resolution.md | Conflict resolution strategies (append_only, last_write_wins, semantic_merge, frozen) | 2026-01-26 | KEEP (flagged as cookbook design patterns, HTML comment added) | ✅ |
| 103 | conflict-resolution.md | Conflict markers format (`<!-- CONFLICT: ... -->`) | 2026-01-26 | KEEP (flagged as cookbook design pattern, HTML comment added) | ✅ |
| 104 | conflict-resolution.md | Git push session completion protocol | 2026-01-26 | KEEP (flagged as community pattern, HTML comment added) | ✅ |
| 105 | conflict-resolution.md | Hash-based IDs (`[bd-xxxxxx]`) from Beads | 2026-01-26 | KEEP (flagged as steveyegge/beads pattern, HTML comment added) | ✅ |
| 106 | conflict-resolution.md | manifest.yaml conflict_resolution config | 2026-01-26 | KEEP (flagged as cookbook extension, HTML comment added) | ✅ |
| 107 | session-handoff.md | `.github/memory-bank/sessions/_active.md` pattern | 2026-01-26 | KEEP (flagged as Cline community pattern, HTML comment + note added) | ✅ |
| 108 | session-handoff.md | Session storage path `workspaceStorage/[workspace-id]/chatSessions/` | 2026-01-26 | KEEP (flagged as undocumented, HTML comment added) | ✅ |
| 109 | session-handoff.md | >60%/>80% context triggers for handoff | 2026-01-26 | KEEP (flagged as community guideline, consistent with other files) | ✅ |
| 110 | telos-goals.md | TELOS framework (10-file system from danielmiessler) | 2026-01-26 | KEEP (external framework, clearly attributed in Platform Note) | ✅ |
| 111 | telos-goals.md | `.github/copilot/USER/TELOS/` location | 2026-01-26 | KEEP (flagged as cookbook adaptation, HTML comment added) | ✅ |
| 112 | telos-goals.md | TELOS-Lite 5-file variant | 2026-01-26 | KEEP (flagged as cookbook adaptation, note already present) | ✅ |
| 113 | telos-goals.md | `.github/copilot/goals/` location | 2026-01-26 | KEEP (flagged as cookbook suggestion, HTML comment added) | ✅ |
| 114 | telos-goals.md | FROZEN tier integration | 2026-01-26 | KEEP (flagged as Cline community pattern, HTML comment added) | ✅ |
| 115 | telos-goals.md | Memory bank file references (projectbrief.md, activeContext.md, progress.md) | 2026-01-26 | KEEP (community pattern, consistent with memory-bank-files.md) | ✅ |
| 116 | permission-levels.md | 4-Level model terminology (Level 0-3) | 2026-01-26 | KEEP (design pattern, flagged with Platform Note) | ✅ |
| 117 | permission-levels.md | `permissions:` frontmatter with mode/allow/deny/ask | 2026-01-26 | KEEP (Claude Code syntax, flagged with Platform Note) | ✅ |
| 118 | permission-levels.md | Permission modes (acceptEdits, bypassPermissions) | 2026-01-26 | KEEP (Claude Code modes, flagged with Platform Note + table) | ✅ |
| 119 | permission-levels.md | Pattern syntax (Bash(), Read, Write, Grep, Edit) | 2026-01-26 | KEEP (Claude Code format, flagged + VS Code equivalent added) | ✅ |
| 120 | destructive-ops.md | Detection categories table (file deletion, network, etc.) | 2026-01-26 | KEEP (cookbook design pattern, cross-platform categories) | ✅ |
| 121 | destructive-ops.md | Four-tier permission model (Level 0-3) | 2026-01-26 | KEEP (design pattern, flagged as multi-platform synthesis) | ✅ |
| 122 | escalation-tree.md | `checkpoints:` YAML frontmatter field in `.agent.md` | 2026-01-26 | KEEP (flagged as proposed design pattern, HTML comment + Platform Note added) | ✅ |
| 123 | escalation-tree.md | `escalation:` YAML frontmatter with `fallback_agent`, `confidence_threshold` | 2026-01-26 | KEEP (flagged as proposed design pattern, native `handoffs` alternative documented) | ✅ |
| 124 | escalation-tree.md | Red Flags stop conditions terminology | 2026-01-26 | KEEP (flagged as obra/superpowers pattern, VS Code native `chat.tools.terminal.autoApprove` alternative added) | ✅ |
| 125 | escalation-tree.md | Retry config with exponential backoff | 2026-01-26 | KEEP (flagged as community design pattern, HTML comment added) | ✅ |
| 126 | escalation-tree.md | Severity-to-action mapping (None/Low/Medium/High/Critical) | 2026-01-26 | KEEP (flagged as cookbook design pattern from obra/superpowers, HTML comment added) | ✅ |
| 127 | escalation-tree.md | Error handling modes (terminated, continue-on-error, remove-abnormal-output) | 2026-01-26 | KEEP (flagged as Dify platform feature, not VS Code Copilot, Platform Note added) | ✅ |
| 128 | escalation-tree.md | Workflow status states (RUNNING → SUCCEEDED | FAILED | STOPPED | PARTIAL_SUCCEEDED) | 2026-01-26 | KEEP (flagged as Dify platform concept, not VS Code, Platform Note added) | ✅ |
| 129 | approval-gates.md | `checkpoints:` YAML frontmatter schema | 2026-01-26 | KEEP (flagged as proposed design pattern in Platform Note, clearly not native) | ✅ |
| 130 | approval-gates.md | `escalation:` YAML frontmatter schema | 2026-01-26 | KEEP (flagged as proposed design pattern in Platform Note, clearly not native) | ✅ |
| 131 | four-modes.md | Four Modes framework (Security, Logic, Bias, Completeness) | 2026-01-26 | KEEP (platform note added, community pattern from Constitutional AI/MS AI Red Team/OWASP) | ✅ |
| 132 | four-modes.md | Iron Law Violation Detection (post-hoc justification, sycophancy) | 2026-01-26 | KEEP (community patterns from obra/superpowers, LLM research) | ✅ |
| 133 | four-modes.md | Critique Severity Levels (Critical/High/Medium/Low/Pass) | 2026-01-26 | KEEP (cookbook design pattern, no VS Code equivalent) | ✅ |
| 134 | four-modes.md | Red-teaming tools (PyRIT, DeepEval, Garak) | 2026-01-26 | KEEP (external tools, clearly attributed with GitHub links) | ✅ |

---

## Conflicts (User Review Required)

Items where subagents disagreed. User reviews and makes final decision.

| # | File | Claim | Opus Says | Gemini Says | Decision | Resolved |
|---|------|-------|-----------|-------------|----------|----------|
| 1 | context-variables.md | `#file:path` syntax (e.g., `#file:gameReducer.js`) | CONFIRMED (GitHub docs show this syntax) | CONTRADICTED (VS Code docs use `#filename` not `#file:path`) | PENDING - Using VS Code syntax in cookbook | ⏳ |
| 2 | just-in-time-retrieval.md | `#readFile` supports line ranges | CONFIRMED (blog shows `startLineNumberBaseZero`/`endLineNumberBaseZero`) | SILENT (not documented in feature reference) | PENDING - Line ranges exist in implementation but not in ref docs | ⏳ |
| 3 | destructive-ops.md | `chat.tools.terminal.autoApproveWorkspaceNpmScripts` setting | SILENT (not in settings reference) | CONFIRMED (found in v1.108 updates) | ✅ CONFIRMED - Added to cookbook | ✅ |
| 4 | approval-gates.md | Setting name: `chat.tools.autoApprove` vs `chat.tools.global.autoApprove` | CONTRADICTED (`chat.tools.global.autoApprove` per VS Code settings ref) | CONTRADICTED (says `chat.tools.autoApprove` correct per MS Learn SQL docs) | ✅ Using VS Code settings reference — `chat.tools.global.autoApprove` | ✅ |

---

## Per-Topic Knowledge Base

> **Purpose:** Detailed findings from official docs for each cookbook file. Includes quoted excerpts with source URLs. Becomes a reusable reference document after validation completes.

---

### 1. agent-file-format.md (CONFIGURATION)

**Topic:** Agent file format, frontmatter fields, model selection, handoffs

**Status:** ✅ Complete (2026-01-24)

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `.github/agents/` discovery | CONFIRMED | VS Code docs |
| `.agent.md` extension | CONFIRMED | VS Code docs |
| `description` is required | **CORRECTED** → optional | VS Code docs (listed under "Header (optional)") |
| `name` defaults to filename | CONFIRMED | VS Code docs |
| `tools: ["*"]` wildcard | CONFIRMED | GitHub docs |
| `tools: []` no tools | CONFIRMED | GitHub docs |
| `model` field | CONFIRMED | VS Code docs |
| `argument-hint` field | CONFIRMED | VS Code docs |
| `infer` field | CONFIRMED | VS Code docs |
| `target` field | CONFIRMED | VS Code docs |
| `mcp-servers` field | **CLARIFIED** → github-copilot target, org/enterprise | GitHub docs |
| `handoffs` field | CONFIRMED | VS Code docs |
| `metadata` field | **CLARIFIED** → GitHub only, not VS Code | GitHub docs |
| 30,000 char limit | CONFIRMED | GitHub docs |
| Tool aliases | CONFIRMED | GitHub docs |
| `permissions` field | **SILENT** → flagged | Not in official docs |
| `checkpoints` field | **SILENT** → flagged | Not in official docs |
| `escalation` field | **SILENT** → flagged | Not in official docs |
| Legacy `.chatmode.md` | CONFIRMED | VS Code docs |
| VS Code 1.106 rename | CONFIRMED | VS Code docs |
| `.github-private` repo | CONFIRMED | GitHub docs |

#### Excerpts from Official Docs

> "VS Code detects any `.md` files in the `.github/agents` folder of your workspace as custom agents."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_custom-agent-file-structure)

> "Custom agent files are Markdown files and use the `.agent.md` extension"
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_custom-agent-file-structure)

> "The name of the custom agent. If not specified, the file name is used."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_header-optional)

> "Enable all available tools: Omit the `tools` property entirely or use `tools: ["*"]` to enable all available tools."
> — [GitHub Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration#tools)

> "Disable all tools: Use an empty list (`tools: []`) to disable all tools for the agent."
> — [GitHub Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration#tools)

> "The prompt can be a maximum of 30,000 characters."
> — [GitHub Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration#yaml-frontmatter-properties)

> "Organization and enterprise owners can create organization and enterprise-level custom agents in a `.github-private` repository"
> — [GitHub Create Custom Agents](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/customization/mcp-servers
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://docs.github.com/en/copilot/reference/custom-agents-configuration
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents

---

### 2. instruction-files.md (CONFIGURATION)

**Topic:** Instruction files, scoping rules, file patterns

**Status:** ✅ Complete (2026-01-24)

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| Instruction hierarchy order | **CORRECTED** → Personal > Path-specific > Repo-wide > Agent (AGENTS.md) > Organization | GitHub docs |
| `.agent.md` in hierarchy | **CORRECTED** → NOT part of instruction hierarchy; defines custom agent personas | VS Code docs |
| `copilot-instructions.md` location | CONFIRMED | `.github/copilot-instructions.md` |
| `.instructions.md` location | CONFIRMED | `.github/instructions/` folder |
| `applyTo` is required | **CORRECTED** → OPTIONAL; instructions can be manually attached without it | VS Code docs |
| `applyTo` glob syntax | CONFIRMED | GitHub docs |
| `applyTo` comma-separated patterns | CONFIRMED | GitHub docs |
| `applyTo` negation patterns | **SILENT** → flagged | Not documented |
| `name` frontmatter field | CONFIRMED | VS Code docs |
| `description` frontmatter field | CONFIRMED | VS Code docs |
| `excludeAgent` frontmatter field | CONFIRMED | GitHub docs (values: `"code-review"`, `"coding-agent"`) |
| `AGENTS.md` at workspace root | CONFIRMED | VS Code/GitHub docs |
| `chat.useAgentsMdFile` setting | CONFIRMED | VS Code settings (default: `true`) |
| `chat.useNestedAgentsMdFiles` setting | CONFIRMED | VS Code settings (experimental, default: `false`) |
| `CLAUDE.md` and `GEMINI.md` alternatives | **ADDED** → Supported as alternatives to AGENTS.md (root only) | GitHub docs |
| Deprecated codeGeneration/testGeneration | CONFIRMED | Deprecated since VS Code 1.102 |
| Six Core Areas (2,500+ repos) | CONFIRMED | GitHub Blog post (not official docs) |
| Cross-tool soft-linking | **SILENT** → flagged | Community pattern, not in official docs |
| Generate Instructions feature | **ADDED** → Configure Chat > Generate Chat Instructions | VS Code docs |
| Settings Sync for instructions | **ADDED** → Enable "Prompts and Instructions" in Settings Sync | VS Code docs |

#### Excerpts from Official Docs

> "If you have multiple types of instructions files in your project, VS Code combines and adds them to the chat context, **no specific order is guaranteed**."
> — [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions#_type-of-instructions-files)

> "Multiple types of custom instructions can apply to a request sent to Copilot. Personal instructions take the highest priority, followed by repository instructions, with organization instructions prioritized last."
> — [GitHub Response Customization](https://docs.github.com/en/copilot/concepts/prompting/response-customization#precedence-of-custom-instructions)

> "applyTo: Optional glob pattern that defines which files the instructions should be applied to automatically... If no value is specified, the instructions are not applied automatically - you can still add them manually to a chat request."
> — [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions#_instructions-file-format)

> "Alternatively, you can use a single `CLAUDE.md` or `GEMINI.md` file stored in the root of the repository."
> — [GitHub Adding Custom Instructions](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot#creating-custom-instructions)

> "Optionally, to prevent the file from being used by either Copilot coding agent or Copilot code review, add the `excludeAgent` keyword to the frontmatter block. Use either `"code-review"` or `"coding-agent"`."
> — [GitHub Path-specific Instructions](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot#creating-path-specific-custom-instructions)

> "Cover six core areas: Commands, testing, project structure, code style, git workflow, and boundaries."
> — [GitHub Blog AGENTS.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/customization/overview
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot
- https://docs.github.com/en/copilot/concepts/prompting/response-customization
- https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/
- https://code.visualstudio.com/updates/v1_102
- https://code.visualstudio.com/updates/v1_106

---

### 3. skills-format.md (CONFIGURATION)

**Topic:** Skills format, skill packages, reusable instructions

**Status:** ✅ Complete (2026-01-24)

**Note:** Skills feature is in Preview/Insiders. Some claims verified against agentskills.io specification.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| agentskills.io open standard | CONFIRMED | VS Code docs, agentskills.io |
| `.github/skills/` project location | CONFIRMED | VS Code docs |
| `~/.copilot/skills/` personal location | CONFIRMED | VS Code docs |
| `name` field 1-64 chars | CONFIRMED | VS Code docs, agentskills.io |
| `name` must match folder | **CORRECTED** → "should typically match" | VS Code docs |
| `description` 1-1024 chars | CONFIRMED | VS Code docs, agentskills.io |
| `license` optional field | CONFIRMED | GitHub docs |
| `compatibility` 1-500 chars | CONFIRMED | agentskills.io spec |
| `allowed-tools` experimental | CONFIRMED | agentskills.io spec |
| `allowed-tools` in VS Code | **CORRECTED** → NOT supported in VS Code | VS Code release notes |
| `metadata` field | CONFIRMED | agentskills.io spec |
| SKILL.md required | CONFIRMED | VS Code docs, GitHub docs |
| 500 lines / 5000 tokens | CONFIRMED | agentskills.io spec |
| `chat.useAgentSkills` setting | CONFIRMED | VS Code docs |
| `chat.agentSkillsLocations` setting | **SILENT** → flagged | Doesn't exist in official docs |
| 5 MB asset limit | **SILENT** → flagged | Not documented anywhere |
| VS Code 1.108 stable | **CORRECTED** → still Preview/Insiders only | VS Code docs |
| 15+ platforms | **CORRECTED** → ~7-8 documented | VentureBeat, news sources |
| Org/Enterprise coming soon | CONFIRMED | GitHub docs |
| `skills-ref` from npm | **CORRECTED** → Python (pip install) | GitHub repo |
| Legacy `.claude/skills/` path | **ADDED** | VS Code docs |
| 3-level progressive loading | **ADDED** | VS Code docs |

#### Excerpts from Official Docs

> "Agent Skills is an open standard that works across multiple AI agents, including GitHub Copilot in VS Code, GitHub Copilot CLI, and GitHub Copilot coding agent."
> — [VS Code Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)

> "Agent Skills support in VS Code is currently in preview. Enable the `chat.useAgentSkills` setting to use Agent Skills."
> — [VS Code Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)

> "Project skills, stored in your repository: `.github/skills/` (recommended) or `.claude/skills/` (legacy, for backward compatibility)"
> — [VS Code Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)

> "The optional `compatibility` field: Must be 1-500 characters if provided."
> — [agentskills.io Specification](https://agentskills.io/specification)

> "The optional `allowed-tools` field: A space-delimited list of tools that are pre-approved to run. Experimental. Support for this field may vary between agent implementations"
> — [agentskills.io Specification](https://agentskills.io/specification)

> "Instructions (< 5000 tokens recommended): Keep your main `SKILL.md` under 500 lines."
> — [agentskills.io Specification](https://agentskills.io/specification)

> "Support for organization-level and enterprise-level skills is coming soon."
> — [GitHub About Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/customization/agent-skills
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/overview
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/updates/v1_107
- https://code.visualstudio.com/updates/v1_108
- https://docs.github.com/en/copilot/concepts/agents/about-agent-skills
- https://agentskills.io/specification
- https://github.com/agentskills/agentskills/tree/main/skills-ref

---

### 4. prompt-files.md (CONFIGURATION)

**Topic:** Prompt files, variables, agent reference, metadata

**Status:** ✅ Complete (2026-01-24)

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `.github/prompts/` location | CONFIRMED | VS Code docs |
| `chat.promptFilesLocations` setting | CONFIRMED | VS Code docs |
| "Prompts: Open User Prompts" command | **CORRECTED** → `Chat: Configure Prompt Files`, `Chat: New Prompt File` | VS Code docs |
| Settings Sync "Prompts and Instructions" | CONFIRMED | VS Code docs |
| `mode` frontmatter field | **CORRECTED** → field is `agent`, not `mode` | VS Code docs |
| `mode` values | **CORRECTED** → `agent` field accepts: `ask`, `edit`, `agent`, or custom agent name | VS Code docs |
| `tools` wildcards `["github/*"]` | CONFIRMED | VS Code docs |
| Tool Priority Order | CONFIRMED | VS Code docs |
| Context variables (all listed) | CONFIRMED | VS Code docs |
| `/` in chat shows prompts | CONFIRMED | VS Code docs |
| `Chat: Run Prompt` command | CONFIRMED | VS Code docs |
| Play button in editor | CONFIRMED | VS Code docs |
| `#tool:<tool-name>` syntax | CONFIRMED | VS Code docs |
| Handoffs to prompts | **CORRECTED** → Handoffs target agents only, not prompts. Prompts use `agent` field to invoke agents | VS Code docs |
| Markdown links load context | CONFIRMED | VS Code docs |
| `chat.promptFilesRecommendations` setting | CONFIRMED | VS Code docs |
| User prompts in VS Code profile | **ADDED** | VS Code docs |
| `/savePrompt` command | **ADDED** | VS Code docs |

#### Excerpts from Official Docs

> "Workspace prompt files: Are only available within the workspace and are stored in the `.github/prompts` folder of the workspace."
> — [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files)

> "The header is formatted as YAML frontmatter with the following fields: `description`, `name`, `argument-hint`, `agent`, `model`, `tools`."
> — [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files#_header-optional)

> "`agent`: The agent used for running the prompt: `ask`, `edit`, `agent`, or the name of a custom agent."
> — [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files#_header-optional)

> "To include all tools of an MCP server, use the `<server name>/*` format."
> — [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files#_header-optional)

> "Tool list priority: 1. Tools specified in the prompt file (if any) 2. Tools from the referenced custom agent in the prompt file (if any) 3. Default tools for the selected agent (if any)"
> — [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files#_tool-list-priority)

> "In the Chat view, select **Configure Chat** (gear icon) > **Prompt Files**... Alternatively, use the **Chat: Configure Prompt Files** command."
> — [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files#_create-a-prompt-file)

> "Select **Prompts and Instructions** from the list of settings to sync."
> — [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files#_sync-user-prompt-files-across-devices)

> "Each handoff specifies the target **agent**, the button label, and an optional prompt to send."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/customization/mcp-servers
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://docs.github.com/en/copilot/customizing-copilot
- https://docs.github.com/en/copilot/reference/custom-agents-configuration

---

### 5. settings-reference.md (CONFIGURATION)

**Topic:** VS Code Copilot settings, configuration options

**Status:** ✅ Complete (2026-01-24)

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `chat.agent.enabled` default = `true` | CONFIRMED | VS Code settings reference |
| `chat.agent.maxRequests` default = `25` | CONFIRMED | VS Code settings reference |
| `chat.mcp.access` default = `true` | CONFIRMED | VS Code settings reference |
| `chat.mcp.discovery.enabled` default = `false` | CONFIRMED | VS Code settings reference |
| `chat.viewSessions.enabled` default = `true` | CONFIRMED | VS Code settings reference |
| `chat.viewSessions.orientation` default = `"auto"` | CONFIRMED | VS Code settings reference |
| `chat.restoreLastPanelSession` default = `true` | **SILENT** → flagged | Not in settings reference |
| `github.copilot.chat.codeGeneration.useInstructionFiles` default = `true` | CONFIRMED | VS Code settings reference |
| `chat.instructionsFilesLocations` default = `{".github/instructions": true}` | CONFIRMED | VS Code settings reference |
| `chat.promptFilesLocations` default = `{".github/prompts": true}` | CONFIRMED | VS Code settings reference |
| `chat.promptFilesRecommendations` default = `true` | **CORRECTED** → `[]` | VS Code settings reference |
| `chat.useAgentsMdFile` default = `true` | CONFIRMED | VS Code settings reference |
| `chat.useNestedAgentsMdFiles` default = `false` | CONFIRMED | VS Code settings reference |
| `chat.useAgentSkills` default = `false` | CONFIRMED | VS Code settings reference |
| `chat.useClaudeSkills` default = `false` | CONFIRMED | v1.107 release notes |
| `chat.agentSkillsLocations` setting exists | CONFIRMED | v1.109 Insiders notes |
| `chat.customAgentInSubagent.enabled` default = `false` | CONFIRMED | VS Code settings reference |
| Terminal deny patterns (rm, rmdir, etc.) | CONFIRMED | VS Code settings reference |
| `chat.tools.terminal.autoApprove` default = `[]` | **CORRECTED** → object with deny patterns | VS Code settings reference |
| `chat.tools.terminal.autoApproveWorkspaceNpmScripts` | CONFIRMED | v1.108 release notes |
| `chat.tools.terminal.preventShellHistory` | CONFIRMED | v1.108 release notes |
| `chat.tools.terminal.blockDetectedFileWrites` default = `true` | **CORRECTED** → `"outsideWorkspace"` | VS Code settings reference |
| `chat.tools.terminal.outputLocation` default = `"panel"` | CONFIRMED (mentioned) | v1.106 release notes |
| `chat.tools.terminal.ignoreDefaultAutoApproveRules` default = `false` | CONFIRMED | VS Code settings reference |
| `github.copilot.chat.githubMcpServer.enabled` | CONFIRMED | v1.107 release notes |
| `github.copilot.chat.githubMcpServer.toolsets` | **CORRECTED** → default is `["default"]` | v1.107 release notes |
| `github.copilot.chat.githubMcpServer.readonly` | CONFIRMED | v1.107 release notes |
| `github.copilot.chat.githubMcpServer.lockdown` | CONFIRMED | v1.107 release notes |
| `github.copilot.chat.anthropic.thinking.budgetTokens` default = `8000` | **CORRECTED** → `4000` | v1.107 release notes |
| `chat.tools.edits.autoApprove` | CONFIRMED | v1.107 release notes |
| `chat.tools.urls.autoApprove` default = `[]` | CONFIRMED | VS Code settings reference |
| `inlineChat.enableV2` | CONFIRMED | v1.107 release notes |
| `.copilotignore` exists | CONFIRMED | v1.84 release notes |
| `github.copilot.chat.customAgents.showOrganizationAndEnterpriseAgents` | CONFIRMED | VS Code custom agents docs |
| `chat.tools.eligibleForAutoApproval` | CONFIRMED | VS Code settings reference |
| `chat.tools.terminal.shellIntegrationTimeout` deprecated | CONFIRMED | v1.106 release notes |
| `github.copilot.chat.codeGeneration.instructions` deprecated | CONFIRMED | VS Code custom instructions docs |
| `github.copilot.chat.testGeneration.instructions` deprecated | CONFIRMED | VS Code custom instructions docs |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| `chat.tools.global.autoApprove` | VS Code settings reference | Advanced Settings |
| `github.copilot.chat.virtualTools.threshold` | VS Code settings reference | Advanced Settings |
| `chat.mcp.autoStart` | VS Code settings reference | Advanced Settings |
| `github.copilot.chat.agent.autoFix` | VS Code settings reference | Advanced Settings |
| `chat.checkpoints.enabled` | VS Code settings reference | Advanced Settings |
| `github.copilot.chat.summarizeAgentConversationHistory.enabled` | VS Code settings reference | Advanced Settings |
| PowerShell Remove-Item deny pattern | VS Code settings reference | Terminal Auto-Approve |
| Source citations for GitHub MCP Server | v1.107 release notes | GitHub MCP Server section |

#### Excerpts from Official Docs

> "chat.tools.terminal.autoApprove Control which terminal commands are auto-approved when using agents. Commands can be set to true (auto-approve) or false (require approval). Regular expressions can be used by wrapping patterns in / characters. { "rm": false, "rmdir": false, "del": false, "kill": false, "curl": false, "wget": false, "eval": false, "chmod": false, "chown": false, "/^Remove-Item\\b/i": false }"
> — [VS Code Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_agent-settings)

> "chat.promptFilesRecommendations Enable or disable prompt file recommendations when opening a new chat session. List of key-value pairs of prompt file name and boolean or when clause. []"
> — [VS Code Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_reusable-prompt-files-settings)

> "The default thinking budget is set to 4,000 tokens. You can customize this budget by modifying the github.copilot.chat.anthropic.thinking.budgetTokens setting... To turn off extended thinking entirely, set the budget to 0."
> — [VS Code 1.107 Release Notes](https://code.visualstudio.com/updates/v1_107#_anthropic-models-extended-thinking-support)

> "chat.tools.terminal.blockDetectedFileWrites (Experimental) Require user approval for terminal commands that perform file writes. outsideWorkspace"
> — [VS Code Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_agent-settings)

> "The @workspace agent respects the .gitignore and .copilotignore when deciding which files from the workspace to index."
> — [VS Code 1.84 Release Notes](https://code.visualstudio.com/updates/v1_84#_workspace)

> "We now have one unified configurable setting, terminal.integrated.shellIntegration.timeout... chat.tools.terminal.shellIntegrationTimeout has been deprecated in favor of this consolidation."
> — [VS Code 1.106 Release Notes](https://code.visualstudio.com/updates/v1_106#_consolidated-shell-integration-timeout-setting)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/agent-skills
- https://code.visualstudio.com/docs/copilot/customization/mcp-servers
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/reference/workspace-context
- https://code.visualstudio.com/updates/v1_84
- https://code.visualstudio.com/updates/v1_106
- https://code.visualstudio.com/updates/v1_107
- https://code.visualstudio.com/updates/v1_108
- https://code.visualstudio.com/updates/v1_109
- https://docs.github.com/en/copilot/customizing-copilot

---

### 6. mcp-servers.md (CONFIGURATION)

**Topic:** MCP server configuration, tool naming, server types

**Status:** ✅ Complete (2026-01-24)

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| MCP is GA since VS Code 1.102 | CONFIRMED | VS Code docs |
| Configuration file location: `.vscode/mcp.json` | CONFIRMED | VS Code docs |
| camelCase naming for server names | CONFIRMED | VS Code docs |
| `type: "stdio"` transport | CONFIRMED | VS Code docs, MCP spec |
| `command`, `args`, `env` properties | CONFIRMED | VS Code docs |
| Python UV-based configuration with `uvx` | CONFIRMED | VS Code docs CLI example |
| Docker-based server pattern | CONFIRMED | VS Code docs |
| HTTP/SSE transport with fallback | CONFIRMED | VS Code docs |
| Bearer token authentication via `headers` | CONFIRMED | VS Code docs |
| Unix socket/named pipe URLs with fragments | CONFIRMED | VS Code docs |
| `${env:VAR}` syntax for environment variables | CONFIRMED | VS Code variables reference |
| `envFile` property for `.env` files | CONFIRMED | VS Code docs |
| Input prompts with `inputs` array | CONFIRMED | VS Code docs |
| `password: true` for sensitive inputs | CONFIRMED | VS Code docs |
| Development mode with `dev.watch`, `dev.debug` | CONFIRMED | VS Code docs |
| GitHub MCP Registry via `@mcp` search | CONFIRMED | VS Code docs |
| `MCP: Browse Servers` command | CONFIRMED | VS Code docs |
| `chat.mcp.gallery.enabled` setting | CONFIRMED | VS Code docs |
| Enterprise `serviceUrl` setting | **CORRECTED** → `chat.mcp.gallery.serviceUrl` (not `github.copilot.chat.mcp.gallery.serviceUrl`) | VS Code enterprise policies |
| GitHub MCP Server toolsets | **EXPANDED** → Many more toolsets documented | GitHub MCP Server repo |
| `X-MCP-Toolsets` header | CONFIRMED | GitHub MCP Server docs |
| MCP Resources via `Add Context > MCP Resources` | CONFIRMED | VS Code docs |
| MCP Prompts as `/mcp.servername.promptname` | CONFIRMED | VS Code docs |
| Capacity limits <10 servers, <80 tools | **CORRECTED** → Only 128 max tools documented | VS Code docs |
| `disabledMcpServers` setting | **SILENT** → flagged | Not in official docs |
| `github.copilot.chat.virtualTools.threshold` | CONFIRMED | VS Code docs |
| Audit log event | **SILENT** → flagged | Not in official docs |
| Debugging commands | CONFIRMED | VS Code docs |
| Settings: `chat.mcp.access`, `discovery.enabled`, `gallery.enabled`, `autostart` | CONFIRMED | VS Code docs |
| MCP tools have no VS Code API access | **SILENT** → flagged | Not explicitly stated |
| `mcp-servers:` frontmatter field | CONFIRMED | VS Code/GitHub docs |

#### Excerpts from Official Docs

> "MCP support in VS Code is generally available starting from VS Code 1.102."
> — [VS Code MCP Servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)

> "Create a `.vscode/mcp.json` file in your workspace."
> — [VS Code MCP Servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers#_add-an-mcp-server-to-a-workspace)

> "Use camelCase for the server name, such as 'uiTesting' or 'githubIntegration'"
> — [VS Code MCP Servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers#_server-naming-conventions)

> "VS Code first tries the HTTP Stream transport and falls back to SSE if HTTP is not supported."
> — [VS Code MCP Servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers#_http-and-server-sent-events-sse-servers)

> "A chat request can have a maximum of 128 tools enabled at a time due to model constraints."
> — [VS Code MCP Servers FAQ](https://code.visualstudio.com/docs/copilot/customization/mcp-servers#_faq)

> "You can reference environment variables with the ${env:Name} syntax."
> — [VS Code Variables Reference](https://code.visualstudio.com/docs/reference/variables-reference#_environment-variables)

> "X-MCP-Toolsets: Comma-separated list of toolsets to enable. E.g. 'repos,issues'. Equivalent to GITHUB_TOOLSETS env var"
> — [GitHub MCP Server Remote Docs](https://github.com/github/github-mcp-server/blob/main/docs/remote-server.md#optional-headers)

> "McpGalleryServiceUrl | chat.mcp.gallery.serviceUrl | Configure the MCP Gallery service URL"
> — [VS Code Enterprise Policies](https://code.visualstudio.com/docs/enterprise/policies)

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| Dev Container support via `devcontainer.json` | VS Code docs | New "Dev Container Support" section |
| Settings Sync for MCP configurations | VS Code docs | Server Discovery section |
| Command line installation with `--add-mcp` | VS Code docs | Server Discovery section |
| One-click install URL handler `vscode:mcp/install` | VS Code MCP developer guide | New "One-Click Installation" section |
| Expanded GitHub MCP toolsets (20+ toolsets) | GitHub MCP Server repo | GitHub MCP Server Toolsets section |
| Additional headers: X-MCP-Tools, X-MCP-Readonly, X-MCP-Lockdown, X-MCP-Insiders | GitHub MCP Server docs | GitHub MCP Server Toolsets section |

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/customization/mcp-servers
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/guides/mcp-developer-guide
- https://code.visualstudio.com/docs/copilot/security
- https://code.visualstudio.com/docs/enterprise/ai-settings
- https://code.visualstudio.com/docs/enterprise/policies
- https://code.visualstudio.com/docs/reference/variables-reference
- https://docs.github.com/en/copilot/customizing-copilot
- https://docs.github.com/en/copilot/reference/custom-agents-configuration
- https://docs.github.com/en/copilot/reference/agentic-audit-log-events
- https://github.com/github/github-mcp-server
- https://github.com/github/github-mcp-server/blob/main/docs/remote-server.md
- https://modelcontextprotocol.io/docs/learn/architecture
- https://modelcontextprotocol.io/docs/learn/server-concepts

---

### 7. file-structure.md (CONFIGURATION)

**Topic:** File structure conventions, folder organization, file locations

**Status:** ✅ Complete (2026-01-24)

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `.github/copilot-instructions.md` is global repository rules location | CONFIRMED | VS Code/GitHub docs |
| `.github/instructions/` is targeted instructions location | CONFIRMED | VS Code/GitHub docs |
| `.github/agents/*.agent.md` is custom agents location | CONFIRMED | VS Code docs |
| `.github/prompts/*.prompt.md` is prompt templates location | CONFIRMED | VS Code docs |
| `.github/skills/*/SKILL.md` is project skills location | CONFIRMED | VS Code docs |
| `~/.copilot/skills/` is personal skills location | CONFIRMED | VS Code docs |
| `.vscode/mcp.json` is MCP configuration location | CONFIRMED | VS Code docs, v1.99 release notes |
| `AGENTS.md` at root for universal agent instructions | CONFIRMED | VS Code/GitHub docs |
| `chat.instructionsFilesLocations` setting | CONFIRMED | VS Code settings reference |
| `chat.promptFilesLocations` setting | CONFIRMED | VS Code settings reference |
| `chat.useAgentsMdFile` setting (default: true) | CONFIRMED | VS Code settings reference |
| `chat.useNestedAgentsMdFiles` setting (experimental, default: false) | CONFIRMED | VS Code settings reference |
| `chat.useAgentSkills` setting (experimental, default: false) | CONFIRMED | VS Code settings reference |
| `chat.agentSkillsLocations` setting for configuring skill paths | **SILENT** → flagged | Not in official docs - paths are hardcoded |
| `chat.mcp.gallery.enabled` setting | CONFIRMED | VS Code docs |
| No `.copilotignore` file exists | CONFIRMED | GitHub content exclusion docs |
| `files.exclude` affects Copilot context | CONFIRMED | Workspace context docs |
| `.gitignore` respected for workspace indexing | CONFIRMED | Workspace context docs |
| Content Exclusion in GitHub Repository Settings (Business/Enterprise) | CONFIRMED | GitHub content exclusion docs |
| `memory-bank/` folder is community pattern | **SILENT** → flagged | Not in official docs |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| `chat.agentSkillsLocations` in settings example | Included in example | **Removed** — setting doesn't exist | VS Code settings reference, agent-skills docs |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| MCP Configuration Locations (4 options: user settings, .code-workspace, .vscode/mcp.json, remote settings) | VS Code v1.99 Release Notes | .vscode/ Folder |
| Skill Locations table (recommended vs legacy paths) | VS Code agent-skills docs | skills/ Folder |
| Content exclusion limitation (doesn't work in Edit/Agent modes) | GitHub content exclusion docs | Content Exclusion |
| `.gitignore` bypass caveat (files accessible if open/selected) | Workspace context docs | Content Exclusion |

#### Excerpts from Official Docs

> "MCP servers can be configured under the `mcp` section in your user, remote, or `.code-workspace` settings, or in `.vscode/mcp.json` in your workspace."
> — [VS Code v1.99 Release Notes](https://code.visualstudio.com/updates/v1_99#_model-context-protocol-server-support)

> "Project skills, stored in your repository: `.github/skills/` (recommended) or `.claude/skills/` (legacy, for backward compatibility). Personal skills, stored in your user profile: `~/.copilot/skills/` (recommended) or `~/.claude/skills/` (legacy, for backward compatibility)"
> — [VS Code Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills#_create-a-skill)

> "Content exclusion is currently not supported in Edit and Agent modes of Copilot Chat in Visual Studio Code and other editors."
> — [GitHub Content Exclusion](https://docs.github.com/en/copilot/concepts/context/content-exclusion)

> "The workspace index also excludes any files that are excluded from VS Code using the `files.exclude` setting or that are part of the `.gitignore` file."
> — [VS Code Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context#_what-content-is-included-in-the-workspace-index)

> "`.gitignore` is bypassed if you have a file open or have text selected within an ignored file."
> — [VS Code Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context#_what-sources-are-used-for-context)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/customization/agent-skills
- https://code.visualstudio.com/docs/copilot/customization/mcp-servers
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/reference/workspace-context
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/updates/v1_99
- https://code.visualstudio.com/updates/v1_108
- https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot
- https://docs.github.com/en/copilot/concepts/context/content-exclusion
- https://learn.microsoft.com/en-us/visualstudio/ide/mcp-servers

---

### 8. memory-bank-schema.md (CONFIGURATION)

**Topic:** Memory bank patterns, persistent context, GitHub Agentic Memory

**Status:** ✅ Complete (2026-01-24)

**Note:** This file primarily documents a **community pattern** (Cline Memory Bank) rather than official VS Code/Copilot features. The file already clearly documents this distinction.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| GitHub Copilot has native "Agentic Memory" in public preview | CONFIRMED | GitHub docs |
| Personal memory settings at github.com/settings/copilot | CONFIRMED | GitHub docs |
| Organization memory settings in Copilot policy settings | CONFIRMED | GitHub docs |
| Repository memory settings in Settings → Copilot → Memory | CONFIRMED | GitHub how-to docs |
| 28-day retention cycle for Agentic Memory | CONFIRMED | GitHub docs |
| Cross-agent memory sharing (coding agent, code review, CLI) | CONFIRMED | GitHub docs |
| Memory stored as repository-scoped cloud storage | CONFIRMED | GitHub docs |
| Just-in-time verification of memories against codebase | CONFIRMED | GitHub docs |
| Automatic learning with citations | CONFIRMED | GitHub docs |
| `#file:` syntax for referencing files in agent definitions | **CORRECTED** → Use `#` followed by filename | VS Code chat context docs |
| `.github/memory-bank/` is recognized/recommended location | **SILENT** → community pattern | Not in official docs - this is Cline pattern |
| MCP Memory server `@modelcontextprotocol/server-memory` | CONFIRMED | MCP servers repo |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| File reference syntax | `#file:.github/memory-bank/...` | `#.github/memory-bank/...` (just `#` prefix) | [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context#_add-files-as-context) |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| Copilot Memory requires **write permission** to repository | GitHub Memory docs | GitHub Agentic Memory table |
| Repository owners can **manually delete** memories | GitHub Memory how-to | GitHub Agentic Memory section |
| Available for **Copilot Pro/Pro+/Business/Enterprise** plans | GitHub Memory docs | GitHub Agentic Memory table |
| Current platform support: GitHub website PRs + CLI (VS Code coming soon) | GitHub Memory docs | GitHub Agentic Memory section |
| Organization enablement path: Copilot policy settings → Features | GitHub Memory how-to | Enable Agentic Memory section |

#### Excerpts from Official Docs

> "This feature is currently in public preview and is subject to change."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

> "Memories are repository scoped, not user scoped, so all memories stored for a repository are available for use in Copilot operations initiated by any user who has access to Copilot Memory for that repository."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#how-memories-are-stored-retained-and-used)

> "memories are automatically deleted after 28 days to avoid stale information adversely affecting agentic decision making. If a memory is validated and used by Copilot, then a new memory with the same details may be stored, which increases the longevity of that memory."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#how-memories-are-stored-retained-and-used)

> "Each memory that Copilot generates is stored with citations. These are references to specific code locations that support the memory. When Copilot finds a memory that relates to the work it is doing, it checks the citations against the current codebase to validate that the information is still accurate and is relevant to the current branch."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#how-memories-are-stored-retained-and-used)

> "Currently Copilot Memory is used by Copilot coding agent and Copilot code review when these features are working on pull requests on the GitHub website, and by Copilot CLI."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#where-is-copilot-memory-used)

> "#-mention the file, folder, or symbol in your chat message by typing `#` followed by the name of the file, folder, or symbol."
> — [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context#_add-files-as-context)

> "Memory - Knowledge graph-based persistent memory system."
> — [MCP Servers Repository](https://github.com/modelcontextprotocol/servers)

#### Sources Consulted

- https://docs.github.com/en/copilot/concepts/agents/copilot-memory
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/copilot-memory
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://github.com/modelcontextprotocol/servers
- https://modelcontextprotocol.io/docs/learn/server-concepts

---

### 9. context-variables.md (CONTEXT-ENGINEERING)

**Topic:** Context variables, chat tools, chat participants, prompt variables

**Status:** ✅ Complete (2026-01-25)

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `#` prefix for chat tools | CONFIRMED | VS Code Chat Tools docs |
| `#file`, `#selection`, `#codebase` | CONFIRMED | GitHub Cheat Sheet, VS Code docs |
| `#block`, `#function`, `#class`, `#line` | CONFIRMED | GitHub Cheat Sheet |
| `#sym`, `#comment`, `#path`, `#project` | CONFIRMED | GitHub Cheat Sheet |
| `#textSearch`, `#fileSearch`, `#usages`, `#searchResults` | CONFIRMED | VS Code Chat Tools docs |
| `#fetch`, `#githubRepo` | CONFIRMED | VS Code Chat Tools docs |
| `#problems`, `#testFailure`, `#changes`, `#todos` | CONFIRMED | VS Code Chat Tools docs |
| `#terminalLastCommand`, `#terminalSelection` | CONFIRMED | VS Code Chat Tools docs |
| `#runSubagent` | CONFIRMED | VS Code Chat Tools docs |
| `#extensions`, `#VSCodeAPI` | CONFIRMED | VS Code Chat Tools docs |
| `#file:path` syntax | **CONFLICT** | GitHub docs show it, VS Code docs use `#filename` |
| Tool Sets `#edit`, `#search`, `#runCommands` | CONFIRMED | VS Code Chat Tools docs |
| Tool Sets `#runNotebooks`, `#runTasks` | **ADDITION** | VS Code Chat Tools docs |
| `@` prefix for participants | CONFIRMED | VS Code Chat Context docs |
| `@workspace`, `@terminal`, `@github`, `@vscode` | CONFIRMED | VS Code docs |
| `@azure` participant | CONFIRMED (preview, extension required) | VS Code Azure blog |
| `${variable}` prompt file syntax | CONFIRMED | VS Code Prompt Files docs |
| `${file}`, `${selection}`, `${workspaceFolder}`, etc. | CONFIRMED | VS Code Prompt Files docs |
| `${input:name}`, `${input:name:placeholder}` | CONFIRMED | VS Code Prompt Files docs |
| `#tool:<name>` syntax in prompts | CONFIRMED | VS Code Prompt Files docs |
| Built-in tool naming (snake_case) | **CORRECTED** → camelCase | VS Code docs use camelCase |
| `<server>/*` MCP tool syntax | CONFIRMED | VS Code Custom Agents docs |
| `${env:VAR}` in MCP configs | **CORRECTED** → Use `${input:}` | MCP uses input variables, not env syntax |
| Context budget percentages | **SILENT** | Not in official docs |

#### Excerpts from Official Docs

> "You can explicitly reference tools in your prompts by typing `#` followed by the tool name."
> — [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools#_use-tools-in-your-prompts)

> "A tool set is a collection of tools that you can reference as a single entity... such as `#edit` and `#search`."
> — [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools#_tool-sets)

> "#file - Includes the current file's content in the prompt."
> — [GitHub Copilot Cheat Sheet](https://docs.github.com/en/copilot/reference/cheat-sheet?tool=vscode)

> "Chat participants are prefixed with @ and can be used to ask questions"
> — [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context)

> "To reference agent tools in the body text, use the `#tool:<tool-name>` syntax."
> — [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files#_body)

> "GitHub Copilot for Azure is currently in preview"
> — [VS Code Azure Blog](https://code.visualstudio.com/blogs/2024/11/15/introducing-github-copilot-for-azure)

> "To include all tools of an MCP server, use the `<server name>/*` format."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_header-optional)

#### Corrections Applied

1. **File reference syntax**: Changed `#file:path` to `#filename` format per VS Code docs
2. **Built-in tool naming**: Changed snake_case to camelCase (`readFile`, `editFiles`, etc.)
3. **Environment variables in MCP**: Changed `${env:VAR}` to `${input:variable-id}` pattern
4. **@azure participant**: Added "(preview, requires extension)" clarification

#### Additions Made

1. Added `#runNotebooks` and `#runTasks` tool sets
2. Added additional VS Code tools: `#new`, `#newWorkspace`, `#newJupyterNotebook`, `#openSimpleBrowser`, `#runVscodeCommand`, `#installExtension`
3. Added source citations throughout the document
4. Added note about camelCase vs snake_case tool naming
5. Added input variables section for MCP sensitive data

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/mcp-servers
- https://code.visualstudio.com/docs/reference/variables-reference
- https://code.visualstudio.com/blogs/2024/11/15/introducing-github-copilot-for-azure
- https://code.visualstudio.com/updates/v1_105
- https://code.visualstudio.com/updates/v1_106
- https://docs.github.com/en/copilot/reference/cheat-sheet?tool=vscode
- https://docs.github.com/copilot/get-started/getting-started-with-prompts-for-copilot-chat

---

### 10. utilization-targets.md (CONTEXT-ENGINEERING)

**Topic:** Context window utilization, token management

**Status:** ✅ Complete (2026-01-25)

**Note:** Mix of community guidelines (40-60% rule from HumanLayer ACE) and official VS Code features (auto-summarization, tool limits).

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| 40-60% utilization optimal | **SILENT** → flagged | Community guideline (HumanLayer ACE), not in official docs |
| VS Code auto-summarizes when context full | CONFIRMED | VS Code settings reference |
| Subagent ~156kb context | **CORRECTED** → size unspecified | Official docs say "own context window", no size given |
| Subagents can't spawn subagents | CONFIRMED | VS Code chat sessions docs |
| /clear command exists | **CORRECTED** → Use `Ctrl+N` (new session) | No /clear command; new session clears context |
| Index Status in Status Bar | CONFIRMED | VS Code workspace context docs |
| MCP servers <10 | **SILENT** → flagged | Community recommendation, not in official docs |
| Active tools <80 | **CORRECTED** → 128 limit | Official limit is 128 per request |
| Instruction files <300 lines | **CORRECTED** → ~1000 lines | GitHub docs say ~1000 lines max |
| >10% tool definition triggers tool search | **SILENT** → flagged | Claude Code specific, not VS Code Copilot |
| Auto-compaction/context editing | CONFIRMED | `github.copilot.chat.summarizeAgentConversationHistory.enabled` setting |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| Active tools limit | <80 | **128 per request** (official) | [chat-tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools) |
| Instruction file limit | <300 lines | **~1000 lines** (official) | [GitHub tutorials](https://docs.github.com/en/copilot/tutorials/use-custom-instructions) |
| Subagent context size | ~156kb | **unspecified** (own window) | [chat-sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| Context clearing | /clear command | **Ctrl+N** (new session) | [chat-sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| Setting name | summarizeAgentConversationHistoryThreshold | `github.copilot.chat.summarizeAgentConversationHistory.enabled` (boolean) | [copilot-settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings) |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| Virtual tools setting for >128 tools | [copilot-settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings) | Limits to Watch table |
| Local index 2500 file limit | [workspace-context](https://code.visualstudio.com/docs/copilot/reference/workspace-context) | Limits to Watch table |
| Code review 4000 char limit | [GitHub docs](https://docs.github.com/en/copilot/concepts/prompting/response-customization) | Limits to Watch table |
| CLI 95% auto-compress | [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli) | Context editing section |
| Official setting name | [copilot-settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings) | Context editing section |
| Subagent official quote | [chat-sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) | Subagent Offloading section |

#### Excerpts from Official Docs

> "A chat request can have a maximum of 128 tools enabled at a time due to model constraints."
> — [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools#_frequently-asked-questions)

> "Subagents use the same agent and have access to the same tools available to the main chat session, **except for creating other subagents**."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

> "github.copilot.chat.summarizeAgentConversationHistory.enabled (Experimental) Automatically summarize the agent conversation history when the context window is full."
> — [VS Code Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings)

> "Limit any single instruction file to a maximum of about 1,000 lines. Beyond this, the quality of responses may deteriorate."
> — [GitHub Custom Instructions Tutorial](https://docs.github.com/en/copilot/tutorials/use-custom-instructions)

> "Copilot code review only reads the first 4,000 characters of any custom instruction file."
> — [GitHub Response Customization](https://docs.github.com/en/copilot/concepts/prompting/response-customization)

> "GitHub Copilot CLI automatically compresses your history when approaching 95% of the token limit."
> — [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli)

> "You can view the type of index that is being used and its indexing status in the Copilot status dashboard in the VS Code Status Bar."
> — [VS Code Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context)

> "Currently, local indexes are limited to 2500 indexable files."
> — [VS Code Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/reference/workspace-context
- https://code.visualstudio.com/docs/copilot/customization/mcp-servers
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/agents/overview
- https://code.visualstudio.com/updates/v1_105
- https://code.visualstudio.com/updates/v1_107
- https://code.visualstudio.com/updates/v1_108
- https://docs.github.com/en/copilot/tutorials/use-custom-instructions
- https://docs.github.com/en/copilot/concepts/prompting/response-customization
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli

---

### 11. compaction-patterns.md (CONTEXT-ENGINEERING)

**Topic:** Context compaction, summarization strategies

**Status:** ✅ Complete (2026-01-25)

**Note:** Mix of official VS Code features (auto-summarization, file outlines) and community patterns (FIC, HumanLayer ACE quality hierarchy).

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `/clear` command resets context | CONFIRMED | [VS Code Features](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features#slash-commands) |
| `#file:path` syntax | **CORRECTED** → `#filename` | Official syntax is `#filename.ts` not `#file:path` |
| `#runSubagent` tool exists | CONFIRMED | [VS Code Features](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features#chat-tools) |
| `files.exclude` affects indexing | CONFIRMED | [Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context) |
| `search.exclude` affects indexing | **SILENT** → flagged | Only `files.exclude` documented for Copilot |
| Phase-based compaction | CONFIRMED (concept) | [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) |
| ~200 lines research output | **SILENT** → flagged | Community guideline (FIC), not in official docs |
| Subagents return only final result | CONFIRMED | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| >60% utilization trigger | **SILENT** → flagged | Community guideline (HumanLayer ACE) |
| Auto-summarization setting | CONFIRMED | `summarizeAgentConversationHistory.enabled` setting |
| Tool outputs can be discarded | **SILENT** | No specific guidance on discarding tool outputs |
| Workspace indexing affects context | CONFIRMED | [Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context) |
| Progressive disclosure pattern | CONFIRMED | [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) |
| Context quality priority hierarchy | **SILENT** → kept with attribution | HumanLayer ACE pattern, not official |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| File reference syntax | `#file:path` | `#filename` or `#path/to/file` | [Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) |
| Commands Reference table | `#file:path` | `#<filename>` with note | [Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| Automatic Compaction by VS Code section | [Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) | New section |
| File outline fallback for large files | [Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) | Automatic Compaction table |
| Comments clarifying files.exclude vs search.exclude | [Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context) | Workspace Indexing config |

#### Excerpts from Official Docs

> "/clear - Start a new chat session."
> — [VS Code Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features#slash-commands)

> "#runSubagent - Run a task in an isolated subagent context. Helps to improve the context management of the main agent thread."
> — [VS Code Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features#chat-tools)

> "If possible, the full contents of the file will be included when you attach a file. If that is too large to fit into the context window, an outline of the file will be included that includes functions and their descriptions without implementations."
> — [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context)

> "The workspace index also excludes any files that are excluded from VS Code using the files.exclude setting or that are part of the .gitignore file."
> — [VS Code Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context)

> "Use progressive context building: Start with high-level concepts and progressively add detail rather than overwhelming the AI with comprehensive information upfront."
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

> "When a subagent completes its task, it returns only the final result to the main chat session, keeping the main context window focused on the primary conversation."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

> "When you create a new chat session, the previous conversation history is cleared, and a fresh context window is established for the new session."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/reference/workspace-context
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/customization/overview
- https://docs.github.com/en/copilot/reference/cheat-sheet?tool=vscode

---

### 12. subagent-isolation.md (CONTEXT-ENGINEERING)

**Topic:** Subagent context isolation, runSubagent tool, invocation methods

**Status:** ✅ Complete (2026-01-25)

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| Introduced in VS Code v1.105 (September 2025) | CONFIRMED | [v1.105 Release Notes](https://code.visualstudio.com/updates/v1_105) |
| Subagents have their own context window | CONFIRMED | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| ~156kb context window size | **SILENT** → flagged | Community guideline (Ralph Playbook), not in official docs |
| ~50 lines recommended summary output | **SILENT** → flagged | Community guideline (FIC), not in official docs |
| Automatic delegation based on agent descriptions | CONFIRMED | [GitHub Docs](https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide) |
| `@agent-name` syntax for subagent invocation | **CONTRADICTED** → corrected | Use natural language, not `@` syntax |
| `#runSubagent` tool call | CONFIRMED | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| Handoffs create new sessions, don't return | CONFIRMED | [Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) |
| Hub-and-spoke architecture (one-level depth) | CONFIRMED | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| No nesting - subagent cannot call `#runSubagent` | CONFIRMED | [GitHub Docs](https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide) |
| Parallel subagent support in v1.107 | **CONTRADICTED** → corrected | v1.107 added parallel *background agents*, not subagents |
| Tool inheritance except `runSubagent` | CONFIRMED | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| `chat.customAgentInSubagent.enabled` setting | CONFIRMED | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| Custom agents can be invoked within subagents | CONFIRMED | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| `handoffs:` field in agent files | CONFIRMED | [Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) |
| Subagents run synchronously | CONFIRMED | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| `infer` property controls subagent eligibility | CONFIRMED | [Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| Invocation method | "use @research-agent to..." | "use the research subagent to..." | [GitHub Docs](https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide) |
| Parallel execution | "Parallel subagent support in v1.107" | Subagents are synchronous; v1.107 added parallel *background agents* | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| Custom agent invocation | "`@docs-agent`, `@test-agent`" | Natural language invocation | [GitHub Docs](https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide) |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| Subagents run synchronously (not async) | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) | Critical Constraints |
| Model inheritance (same AI model as main session) | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) | Critical Constraints |
| Local sessions only limitation | [Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview) | Critical Constraints |
| `infer` property documentation | [Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) | New section: Controlling Subagent Eligibility |

#### Excerpts from Official Docs

> "A subagent enables you to delegate tasks to an isolated, autonomous agent within your chat session. Subagents operate independently from the main chat session and have their own context window."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

> "Subagents don't run asynchronously or in the background, however, they operate autonomously without pausing for user feedback. When a subagent completes its task, it returns only the final result to the main chat session, keeping the main context window focused on the primary conversation."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

> "Subagents use the same agent and have access to the same tools available to the main chat session, except for creating other subagents."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

> "Automatic delegation. Copilot will analyze the description of your request, the description field of your configured custom agents, and the current context and available tools to automatically choose a subagent."
> — [GitHub Docs](https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide#invoking-subagents)

> "`infer` - Optional boolean flag to enable use of the custom agent as a subagent (default is true)."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_header-optional)

> "Subagents are currently only supported in local agent sessions in VS Code."
> — [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/agents/overview
- https://code.visualstudio.com/updates/v1_105
- https://code.visualstudio.com/updates/v1_107
- https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context

---

### 13. just-in-time-retrieval.md (CONTEXT-ENGINEERING)

**Topic:** Just-in-time context retrieval, tool patterns for dynamic loading

**Status:** ✅ Complete (2026-01-25)

**Note:** Mix of official VS Code tool features and community patterns (HumanLayer ACE utilization targets, Cline memory bank).

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `#selection` context variable | CONFIRMED | [VS Code Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) |
| `#file` context variable | **CONTRADICTED** → `#<filename>` | Official syntax is `#filename.ts` not `#file` |
| `#codebase` context variable | CONFIRMED | [VS Code Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) |
| `list_dir` tool | **CONTRADICTED** → `#listDirectory` | Official name is camelCase with # prefix |
| `file_search` tool | **CONTRADICTED** → `#fileSearch` | Official name is camelCase with # prefix |
| `read_file` tool | **CONTRADICTED** → `#readFile` | Official name is camelCase with # prefix |
| `grep_search` tool | **CONTRADICTED** → `#textSearch` | Official name is `#textSearch` not `grep_search` |
| `semantic_search` tool | **CONFIRMED** | [v1_98 Release Notes](https://code.visualstudio.com/updates/v1_98) — "Embeddings-based semantic search" |
| `#runSubagent` syntax | CONFIRMED | [VS Code Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) |
| Memory Bank pattern (`.github/memory-bank/`) | **SILENT** → flagged | Community pattern from Cline, not in official docs |
| Skills progressive disclosure | CONFIRMED | [Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) |
| 40-60% context utilization target | **SILENT** → flagged | HumanLayer ACE community guideline |
| >80% utilization warning | **SILENT** → flagged | Community guideline, not official |
| "Context rot" terminology | **CORRECTED** → "stale context" | Official docs use "stale context" |
| `#readFile` line range support | **CONFLICT** | Opus found blog showing line ranges; Gemini found no documentation |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| Tool names throughout | `list_dir`, `file_search`, `read_file`, `grep_search` | `#listDirectory`, `#fileSearch`, `#readFile`, `#textSearch` | [VS Code Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) |
| File reference syntax | `#file` | `#<filename>` | [VS Code Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) |
| Terminology | "context rot" | "stale context" | [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) |
| Semantic search tool | `semantic_search` | `#codebase` (includes semantic search) | [v1_98 Release Notes](https://code.visualstudio.com/updates/v1_98) |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| Tool naming convention note | [VS Code Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) | Tool Patterns for JIT |
| Official "stale context" quote | [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) | Why Just-in-Time |
| Memory Bank community pattern note | [Cline Memory Bank](https://github.com/cline/memory-bank) | With Memory Bank section |
| Official context threshold (95% auto-compress, <20% warning) | [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli#context-management) | Measuring JIT Effectiveness |

#### Excerpts from Official Docs

> "#listDirectory - List files in a directory in the workspace."
> "#fileSearch - Search for files in the workspace by using glob patterns and returns their path."
> "#textSearch - Find text in files."
> "#readFile - Read the content of a file in the workspace."
> — [VS Code Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features#_chat-tools)

> "#runSubagent - Run a task in an isolated subagent context. Helps to improve the context management of the main agent thread."
> — [VS Code Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features#_chat-tools)

> "The full list of tools is: Embeddings-based semantic search, Text search, File search, Git modified files, Project structure, Read file, Read directory, Workspace symbol search"
> — [VS Code v1.98 Release Notes](https://code.visualstudio.com/updates/v1_98#more-advanced-codebase-search)

> "Keep context fresh: Regularly audit and update your project documentation... Stale context leads to outdated or incorrect suggestions."
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide#_context-management-principles)

> "Skills use progressive disclosure to efficiently load content only when needed. This three-level loading system ensures you can install many skills without consuming context."
> — [VS Code Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills#_how-copilot-uses-skills)

> "GitHub Copilot CLI automatically compresses your history when approaching 95% of the token limit. When you have less than 20% of a model's token limit remaining, a warning will be displayed."
> — [GitHub Copilot CLI Context Management](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli#context-management)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/customization/agent-skills
- https://code.visualstudio.com/docs/copilot/reference/workspace-context
- https://code.visualstudio.com/updates/v1_98
- https://code.visualstudio.com/updates/v1_100
- https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli
- https://learn.microsoft.com/en-us/visualstudio/ide/copilot-context-overview

---

### 14. context-quality.md (CONTEXT-ENGINEERING)

**Topic:** Context quality patterns, quality hierarchy, degradation signals

**Status:** ✅ Complete (2026-01-25)

**Note:** Primarily community patterns from HumanLayer ACE and Anthropic research. Official docs confirm context behavior but not specific metrics/hierarchies.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| "context rot" terminology | **CORRECTED** → "stale context" | [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) |
| Quality hierarchy (Correctness > Completeness > Size > Trajectory) | **SILENT** → flagged | Not in official docs; community pattern from HumanLayer ACE |
| "leverage model" for error propagation | **SILENT** → flagged | Not in official docs; community pattern from HumanLayer ACE |
| 40-60% context utilization target | **SILENT** → flagged | Not in official docs; community guideline |
| 128K-200K token window sizes | **SILENT** → flagged | Specific token numbers not documented |
| 60-70% capacity degradation threshold | **SILENT** → flagged | Not documented in official sources |
| "Summarized conversation history" message | **CONFIRMED** | [VS Code 1.100 Release Notes](https://code.visualstudio.com/updates/v1_100) |
| `activeContext.md` file pattern | **CORRECTED** → removed | Not official; replaced with general guidance |
| Subagents for context management | **CONFIRMED** | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| Context isolation principle | **CONFIRMED** | [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) |
| Context dumping anti-pattern | **CONFIRMED** | [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) |
| File outline fallback (large files) | **CONFIRMED** | [Copilot Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) |
| Relevance filtering for large context | **CONFIRMED** | [Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context) |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| Degradation terminology | "context rot" | "stale context" | [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) |
| Example 3 file reference | `activeContext.md` | Removed; using general guidance | Not an official pattern |
| Subagent guidance | Informal mention | Added official citation | [VS Code 1.107](https://code.visualstudio.com/updates/v1_107) |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| Official "Summarized conversation history" behavior | [VS Code 1.100 Release Notes](https://code.visualstudio.com/updates/v1_100) | Quality Degradation Signals |
| Context isolation tip (separate sessions) | [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) | Example 3: Trajectory Correction |
| Official Context Handling Behaviors table | Multiple sources | New section added |
| Anti-Patterns (Official) section | [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) | New section added |
| File outline fallback behavior | [Copilot Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) | Official Context Handling Behaviors |

#### Excerpts from Official Docs

> "Keep context fresh: Regularly audit and update your project documentation (using the agent) as the codebase evolves. **Stale context leads to outdated or incorrect suggestions.**"
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

> "When your conversation gets long, or your context gets very large, you might see a 'Summarized conversation history' message in the Chat view. This means we compress the conversation so far into a summary of the most important information and the current state of your task."
> — [VS Code 1.100 Release Notes](https://code.visualstudio.com/updates/v1_100)

> "Context dumping: Avoid providing excessive, unfocused information that doesn't directly help with decision-making."
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

> "Maintain context isolation: Keep different types of work (planning, coding, testing, debugging) in separate chat sessions to prevent context mixing and confusion."
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

> "Subagents work independently from the main chat session and have their own context window. This helps the main conversation to stay focused on the high-level objective and helps to manage context window limitations."
> — [VS Code 1.107 Release Notes](https://code.visualstudio.com/updates/v1_107)

> "If possible, the full contents of the file will be included when you attach a file. If that is too large to fit into the context window, an outline of the file will be included that includes functions and their descriptions without implementations."
> — [VS Code Copilot Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context)

> "If the resulting context is too large to fit in the context window, only the most relevant parts are kept."
> — [VS Code Workspace Context Reference](https://code.visualstudio.com/docs/copilot/reference/workspace-context)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/reference/workspace-context
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://code.visualstudio.com/updates/v1_100
- https://code.visualstudio.com/updates/v1_105
- https://code.visualstudio.com/updates/v1_106
- https://code.visualstudio.com/updates/v1_107
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli
- https://docs.github.com/en/copilot/concepts/prompting/prompt-engineering

---

### 15. spec-driven.md (WORKFLOWS)

**Topic:** Spec-driven development workflow

**Status:** ✅ Complete (2026-01-25)

**Note:** Spec-driven development is implemented via GitHub Spec-Kit (open-source toolkit), not a native VS Code feature. VS Code provides native planning via the Plan agent.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `/speckit.specify`, `/speckit.plan`, etc. commands | **SILENT** → flagged | Not in official VS Code docs; Spec-Kit is external toolkit |
| `#file:path` syntax (e.g., `#file:docs/feature.spec.md`) | **CONTRADICTED** → corrected to `#<filename>` | [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) |
| Agent YAML frontmatter (`name`, `description`, `tools`) | **CONFIRMED** | [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) |
| Spec-driven development phases (Specify → Plan → Tasks → Implement) | **SILENT** → flagged | Not in official docs; Spec-Kit methodology |
| EARS (Easy Approach to Requirements Syntax) notation | **SILENT** → flagged | External requirements engineering standard |
| `.spec.md` file extension | **SILENT** → flagged | Spec-Kit convention, not VS Code standard |
| Context engineering at different phases | **CONFIRMED** | [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) |
| Planning-first workflow recommended | **CONFIRMED** | [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning) |
| Built-in Plan agent | **CONFIRMED** | [VS Code Chat](https://code.visualstudio.com/docs/copilot/chat/copilot-chat) |
| Handoffs for workflow transitions | **CONFIRMED** | [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| File reference syntax | `#file:docs/feature-name.spec.md` | `#feature-name.spec.md` | [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) |
| Native planning workflow | Not mentioned | Added VS Code Native Planning section | [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning) |
| Spec-Kit attribution | Implicit | Explicit platform note added | [GitHub Blog](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/) |
| EARS attribution | Requirements standard | Flagged as external standard with link | [EARS Notation](https://alistairmavin.com/ears/) |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| Platform Note clarifying Spec-Kit is external toolkit | [GitHub Blog](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/) | Document header |
| VS Code Native Planning section with `@plan` agent | [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning) | New section before Context Engineering |
| Syntax Note clarifying `#<filename>` | [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) | Quick Start section |

#### Excerpts from Official Docs

> "The built-in plan agent collaborates with you to create detailed implementation plans before executing them. This ensures that all requirements are considered and addressed before any code changes are made."
> — [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning)

> "VS Code provides four built-in agents: Agent, Plan, Ask, and Edit."
> — [VS Code Copilot Chat](https://code.visualstudio.com/docs/copilot/chat/copilot-chat)

> "Add context with `#`-mentions: reference specific files (`#file`), your codebase (`#codebase`), or terminal output (`#terminalSelection`). Type `#` in the chat input field to view all available context items."
> — [VS Code Copilot Chat](https://code.visualstudio.com/docs/copilot/chat/copilot-chat)

> "#-mention the file, folder, or symbol in your chat message by typing `#` followed by the name of the file, folder, or symbol."
> — [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context)

> "The high-level workflow for context engineering in VS Code consists of the following steps: 1. Curate project-wide context 2. Generate implementation plan 3. Generate implementation code"
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

> "Spec Kit, our new open sourced toolkit for spec-driven development, provides a structured process to bring spec-driven development to your coding agent workflows with tools including GitHub Copilot, Claude Code, and Gemini CLI."
> — [GitHub Blog: Spec-Driven Development](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/overview
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/chat/chat-planning
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/guides/prompt-engineering-guide
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide
- https://code.visualstudio.com/updates/v1_86
- https://code.visualstudio.com/updates/v1_94
- https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/
- https://github.com/github/spec-kit
- https://docs.github.com/en/copilot/reference/custom-agents-configuration

---

### 16. spec-templates.md (WORKFLOWS)

**Topic:** Specification templates, TELOS framework, EARS notation

**Status:** ✅ Complete (2026-01-25)

**Note:** Templates are from external community sources (Spec-Kit, TELOS, EARS, HumanLayer ACE), NOT native VS Code features. VS Code provides native planning via the Plan agent and Context Engineering workflow.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `.spec.md` file extension | **SILENT** → flagged | Not in VS Code docs; Spec-Kit convention only |
| TELOS framework (Mission/Goals/Problems/Challenges) | **SILENT** → flagged | External framework by Daniel Miessler, not VS Code native |
| TELOS-Lite questionnaire | **SILENT** → flagged | Cookbook adaptation of TELOS, not official |
| EARS notation (Easy Approach to Requirements Syntax) | **SILENT** → flagged | External requirements engineering standard by Alistair Mavin |
| 5-Gate validation checklist | **SILENT** → flagged | Cookbook pattern, not in official docs |
| Leverage model (bad research → 1000s bad code lines) | **SILENT** → flagged | HumanLayer ACE concept, not VS Code native |
| BDD Given/When/Then format | **CONFIRMED** (external) | VS Code blogs mention "Gherkin specs" as option; Spec-Kit uses BDD |
| User story format (As a/I want/So that) | **CONFIRMED** (external) | Microsoft Copilot Studio docs recommend user stories |
| Plan template structure | **CONFIRMED** | VS Code Context Engineering Guide has `plan-template.md` |
| Spec-Kit toolkit | **CONFIRMED** (external) | GitHub open-source toolkit, not VS Code native feature |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| N/A | N/A | N/A | No direct contradictions; all flagged as SILENT |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| VS Code Native Alternatives section with Plan agent, Context Engineering, Prompt Files, Custom Agents, Todo Lists | [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning), [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) | Before Sources |

#### Excerpts from Official Docs

> "The built-in plan agent collaborates with you to create detailed implementation plans before executing them. This ensures that all requirements are considered and addressed before any code changes are made."
> — [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning)

> "Create a planning document template `plan-template.md` that defines the structure and sections of the implementation plan document. By using a template, you ensure that the agent collects all necessary information and presents it in a consistent format."
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

> "The high-level workflow for context engineering in VS Code consists of the following steps: 1. Curate project-wide context 2. Generate implementation plan 3. Generate implementation code"
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

> "We've even seen people add Gherkin specs as custom instructions!"
> — [VS Code Blog: Custom Instructions](https://code.visualstudio.com/blogs/2025/03/26/custom-instructions)

> "Spec-Driven Development flips the script on traditional software development... specifications become executable, directly generating working implementations rather than just guiding them."
> — [GitHub Spec-Kit](https://github.com/github/spec-kit)

> "Adopt a user story-driven approach... 'As an employee, I want the agent to retrieve my remaining leave balance so that I can plan vacations.'"
> — [Microsoft Copilot Studio Planning](https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/project-getting-started)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/overview
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat
- https://code.visualstudio.com/docs/copilot/chat/chat-planning
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide
- https://code.visualstudio.com/blogs/2025/03/26/custom-instructions
- https://docs.github.com/en/copilot/reference/custom-agents-configuration
- https://docs.github.com/en/copilot/tutorials/customization-library/custom-agents/implementation-planner
- https://github.com/github/spec-kit
- https://github.com/github/spec-kit/blob/main/spec-driven.md
- https://github.com/github/spec-kit/blob/main/templates/spec-template.md
- https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/project-getting-started
- https://learn.microsoft.com/en-us/visualstudio/modeling/model-user-requirements

---

### 17. research-plan-implement.md (WORKFLOWS)

**Topic:** Research-plan-implement workflow pattern, context engineering

**Status:** ✅ Complete (2026-01-25)

**Note:** VS Code provides native support through the Plan agent and Context Engineering workflow. Specific metrics (40-60% utilization, ~200 lines, ~50 lines) are community guidelines from HumanLayer ACE.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| Human leverage model (bad research → bad code) | **SILENT** → flagged | HumanLayer ACE concept, not in official docs |
| ~200 line document output per phase | **SILENT** → flagged | Community guideline, not documented |
| ~50 line subagent summaries | **SILENT** → flagged | Community guideline, not documented |
| `#runSubagent` tool | **CONFIRMED** | [VS Code Features](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) |
| 40-60% context utilization | **SILENT** → flagged | Community guideline, not documented |
| >60% triggers compaction | **SILENT** → flagged | Community guideline, not documented |
| Subagents cannot spawn subagents | **CONFIRMED** | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| `mode: agent` frontmatter | **CONTRADICTED** → corrected to `agent: agent` | [Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) |
| `tools` frontmatter | **CONFIRMED** | [Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) |
| Research → Plan → Implement workflow | **CONFIRMED** (as "Context Engineering") | [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) |
| `codebase-locator` agent | **SILENT** → flagged | Custom agent pattern, not built-in |
| Phase transitions as compaction points | **SILENT** → flagged | Community pattern, not documented |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| Frontmatter field | `mode: agent` | `agent: agent` | [Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) |
| 3 occurrences in templates | `mode: agent` | `agent: agent` | Official frontmatter format |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| Platform Note with VS Code native equivalents | Multiple sources | Document header |
| VS Code Native Support section (Plan agent, Context Engineering, Handoffs, Subagents, Auto-Summarization) | [Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning), [Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) | Before Sources |

#### Excerpts from Official Docs

> "The high-level workflow for context engineering in VS Code consists of the following steps: 1. Curate project-wide context... 2. Generate implementation plan... 3. Generate implementation code."
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

> "The built-in plan agent collaborates with you to create detailed implementation plans before executing them."
> — [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning)

> "#runSubagent - Run a task in an isolated subagent context. Helps to improve the context management of the main agent thread."
> — [VS Code Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features)

> "Subagents use the same agent and have access to the same tools available to the main chat session, except for creating other subagents."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

> "When a subagent completes its task, it returns only the final result to the main chat session, keeping the main context window focused on the primary conversation."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

> "Handoffs enable you to create guided sequential workflows that transition between agents with suggested next steps."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/overview
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/chat/chat-planning
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/agents/overview
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://docs.github.com/en/copilot/tutorials/enhancing-copilot-agent-mode-with-mcp
- https://docs.github.com/en/copilot/tutorials/customization-library/custom-agents/implementation-planner

---

### 18. riper-modes.md (WORKFLOWS)

**Topic:** RIPER 5-mode workflow framework (Research, Innovate, Plan, Execute, Review)

**Status:** ✅ Complete (2026-01-25)

**Note:** RIPER is a **community pattern** from Cursor ecosystem, not a native VS Code feature. The cookbook file correctly attributes it to CursorRIPER. Platform notes and VS Code native alternatives have been added.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| RIPER 5-mode framework | **SILENT** | Not in official docs - community pattern |
| `/research`, `/plan`, etc. commands | **CLARIFIED** | Can be implemented via `.prompt.md` files; not built-in |
| Agent YAML frontmatter format | **CONFIRMED** | [Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) |
| Native mode/state tracking | **CONTRADICTED** | No native state tracking between messages |
| Memory bank pattern | **SILENT** | Community pattern from Cline |
| Tool restrictions for read-only | **CONFIRMED** | Via `tools` field in custom agents |
| Handoffs for mode transitions | **CONFIRMED** (ADDITION) | [Custom Agents - Handoffs](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs) |
| Plan agent as native equivalent | **CONFIRMED** (ADDITION) | [Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning) |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| Mode commands | Presented as VS Code feature | Added implementation note (requires `.prompt.md` files) | [Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) |
| Memory bank | No attribution | Added community pattern note with link to Cline | Community attribution |
| Overall framework | No platform note | Added platform note clarifying community pattern | All docs reviewed |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| Platform Note (community pattern disclaimer) | All docs reviewed | Document header |
| VS Code implementation note for slash commands | [Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) | Mode Commands section |
| Memory bank community pattern attribution | Cline documentation | Memory Bank Integration section |
| Native VS Code Alternatives section | Multiple sources | New section |
| Official VS Code sources | All URLs | Sources section |

#### Excerpts from Official Docs

> "Custom agents consist of a set of instructions and tools that are applied when you switch to that agent. For example, a 'Plan' agent could include instructions for generating an implementation plan and only use read-only tools."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

> "Handoffs enable you to create guided sequential workflows that transition between agents with suggested next steps. After a chat response completes, handoff buttons appear that let users move to the next agent with relevant context and a pre-filled prompt."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs)

> "In the Chat view, type `/` followed by the prompt name in the chat input field."
> — [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files)

> "The plan agent does not make any code changes until the plan is reviewed and approved by you."
> — [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning)

> "tools: ['fetch', 'githubRepo', 'search', 'usages']... You are in planning mode. Your task is to generate an implementation plan... Don't make any code edits, just generate a plan."
> — [VS Code Custom Agents - Plan Example](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_custom-agent-example)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/chat/chat-planning
- https://code.visualstudio.com/docs/copilot/overview
- https://code.visualstudio.com/docs/copilot/getting-started
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features

---

### 19. wrap-task-decomposition.md (WORKFLOWS)

**Topic:** WRAP task decomposition framework (Write-Refine-Atomic-Pair)

**Status:** ✅ Complete (2026-01-25)

**Note:** WRAP is an **official GitHub framework** documented in GitHub Blog. The cookbook file correctly references the source and adapts patterns for VS Code workflows.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| WRAP framework (Write-Refine-Atomic-Pair) | **CONFIRMED** | [GitHub Blog WRAP](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/) |
| Instruction hierarchy (Enterprise → Org → Repo → Agent) | **CONFIRMED** | [GitHub Custom Agents Config](https://docs.github.com/en/copilot/reference/custom-agents-configuration#processing-of-custom-agents) |
| `.github/copilot-instructions.md` location | **CONFIRMED** | [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) |
| `.github/agents/*.agent.md` format | **CONFIRMED** | [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) |
| Three-Tier Boundaries (Always/Ask/Never) | **CONFIRMED** | [GitHub Blog 2500+ Repos](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/) |
| Copilot Memory (Public Preview) | **CONFIRMED** | [GitHub Blog Memory System](https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/) |
| Generate instructions as first task | **CONFIRMED** | [GitHub Blog WRAP - Refine](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/) |
| Human vs Agent strengths table | **CONFIRMED** | [GitHub Blog WRAP - Pair](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/#h-pair-with-coding-agent) |
| Atomic task concept (one commit each) | **CONFIRMED** | [GitHub Blog WRAP - Atomic](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/#h-atomic-tasks) |
| Pairing workflow diagram | **NUANCED** | Official WRAP is Write→Refine→Atomic→Pair sequence; cookbook adds implementation detail |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| WRAP source attribution | Generic mention | Added platform note with official source URL | [GitHub Blog WRAP](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/) |
| Three-Tier Boundaries | Unattributed pattern | Added source from 2500+ repo analysis | [GitHub Blog 2500+ Repos](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/) |
| Copilot Memory | Brief mention | Expanded with cross-agent memory details and source | [GitHub Blog Memory](https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/) |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| Platform Note (WRAP is official GitHub framework) | GitHub Blog | Document header |
| Three-Tier Boundaries source attribution | GitHub Blog 2500+ repos | Three-Tier Boundaries section |
| Cross-agent memory details | GitHub Blog Memory | Copilot Memory section |
| Human vs Agent strengths source | GitHub Blog WRAP | Pair section |
| Recommended Agent Personas table (6 types) | GitHub Blog 2500+ repos | New section |
| Expanded Sources section | All GitHub Blog URLs | Sources section |

#### Excerpts from Official Docs

> "WRAP, which stands for: W – Write effective issues, R – Refine your instructions, A – Atomic tasks, P – Pair with the coding agent"
> — [GitHub Blog: WRAP Up Your Backlog](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/)

> "Three-tier boundaries: Set clear rules using always do, ask first, never do. Prevents destructive mistakes."
> — [GitHub Blog: How to Write a Great AGENTS.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)

> "Coding agent is very good at handling small, atomic, and well-defined tasks... the trick is to break that large problem down into multiple, independent, smaller tasks."
> — [GitHub Blog: WRAP - Atomic Tasks](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/#h-atomic-tasks)

> "Note: This is a great first use case for GitHub Copilot coding agent! Try asking it to generate custom repository instructions for your repository."
> — [GitHub Blog: WRAP - Refine](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/)

> "Humans are very good at: Understanding the 'Why'... Navigating ambiguity... Cross-system thinking. On the other hand, coding agent is very good at: Tireless execution... Repetitive tasks... Exploring possibilities."
> — [GitHub Blog: WRAP - Pair](https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/#h-pair-with-coding-agent)

> "Cross-agent memory allows agents to remember and learn from experiences across your development workflow, without relying on explicit user instructions."
> — [GitHub Blog: Building an Agentic Memory System](https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/)

#### Sources Consulted

- https://github.blog/ai-and-ml/github-copilot/wrap-up-your-backlog-with-github-copilot-coding-agent/
- https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/
- https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://docs.github.com/en/copilot/reference/custom-agents-configuration

---

### 20. handoffs-and-chains.md (WORKFLOWS)

**Topic:** Agent handoffs, workflow chaining, subagent vs handoff patterns

**Status:** ✅ Complete (2026-01-25)

**Note:** Core handoffs/subagents features are official VS Code. Escalation patterns and dependency notation are community patterns (flagged in file).

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `handoffs:` VS Code/IDE-specific | **CONFIRMED** | [GitHub Custom Agents Config](https://docs.github.com/en/copilot/reference/custom-agents-configuration#yaml-frontmatter-properties) |
| GitHub.com ignores `handoffs:` property | **CONFIRMED** | [GitHub Custom Agents Config](https://docs.github.com/en/copilot/reference/custom-agents-configuration#yaml-frontmatter-properties) |
| `#runSubagent` returns results inline to parent | **CONFIRMED** | [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents) |
| Handoffs create new session (original archived) | **CONFIRMED** | [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview#_hand-off-a-session-to-another-agent) |
| `chat.customAgentInSubagent.enabled` setting | **CONFIRMED** | [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_use-a-custom-agent-with-subagents-experimental) |
| `infer: false` prevents subagent use | **CONFIRMED** | [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_use-a-custom-agent-with-subagents-experimental) |
| Handoff fields: label, agent, prompt, send | **CONFIRMED** | [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs) |
| `send: false` is default (pre-fill for review) | **CONFIRMED** | [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_header-optional) |
| `send: true` auto-submits immediately | **CONFIRMED** | [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs) |
| One-level depth constraint (no nested subagents) | **CONFIRMED** | [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents) |
| Subagents cannot spawn subagents | **CONFIRMED** | [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents) |
| `escalation:` frontmatter field | **SILENT** | Not in official docs — flagged as community pattern |
| `checkpoints:` frontmatter field | **CONTRADICTED** | Checkpoints are runtime settings (`chat.checkpoints.enabled`), not frontmatter — corrected |
| No native conditional handoffs | **CONFIRMED** | Agent presents buttons, user selects — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs) |
| Beads dependency notation | **SILENT** | Community pattern — flagged with attribution |

#### Corrections Applied

| Claim | Was | Now | Source |
|-------|-----|-----|--------|
| Session archival on handoff | "new session, doesn't return" | "new session (original archived), doesn't return" with official quote | [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview#_hand-off-a-session-to-another-agent) |
| `escalation:` frontmatter | Presented as native feature | Flagged as community pattern with alternative instruction-based approach | Tier 2 search confirmed not in official docs |
| `checkpoints:` frontmatter | Presented as frontmatter config | Corrected: VS Code checkpoints are runtime settings, not agent config | [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) |
| Beads dependency notation | Presented as technique | Flagged as community pattern with source attribution | Tier 2 search confirmed not in official docs |

#### Additions Made

| New Content | Source | Added To Section |
|-------------|--------|------------------|
| GitHub Hooks section (lifecycle events) | [GitHub Copilot Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks) | After Escalation Configuration |
| Session archival quote | VS Code Agents Overview | Subagents vs Handoffs section |
| Expanded Sources (4 new URLs) | Official docs | Sources section |

#### Silent Flags (Community Patterns)

| Item | Flagged Date | Status |
|------|--------------|--------|
| `escalation:` frontmatter field | 2026-01-25 | KEEP as community pattern with clear flag |
| Beads dependency notation | 2026-01-25 | KEEP as community pattern with attribution |

#### Excerpts from Official Docs

> "VS Code creates a new agent session when you hand off, carrying over the full conversation history and context. The original session is archived after handoff."
> — [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview#_hand-off-a-session-to-another-agent)

> "Subagents use the same agent and have access to the same tools available to the main chat session, except for creating other subagents."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

> "When a subagent completes its task, it returns only the final result to the main chat session, keeping the main context window focused on the primary conversation."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

> "The `model`, `argument-hint`, and `handoffs` properties from VS Code and other IDE custom agents are currently not supported for Copilot coding agent on GitHub.com. They are ignored to ensure compatibility."
> — [GitHub Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration#yaml-frontmatter-properties)

> "Handoffs enable you to create guided sequential workflows that transition between agents with suggested next steps. After a chat response completes, handoff buttons appear that let users move to the next agent with relevant context and a pre-filled prompt."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs)

> "If `send: true`, the prompt automatically submits to start the next workflow step."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs)

> "Hooks enable you to execute custom shell commands at strategic points in an agent's workflow, such as when an agent session starts or ends, or before and after a prompt is entered or a tool is called."
> — [GitHub Copilot Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks)

> "When checkpoints are enabled, VS Code automatically creates snapshots of your files at key points during chat interactions, allowing you to return to a known good state if the changes made by chat requests are not what you expected."
> — [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/agents/overview
- https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://docs.github.com/en/copilot/reference/custom-agents-configuration
- https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks

---

### 21. workflow-orchestration.md (WORKFLOWS)

**Topic:** Multi-agent workflow orchestration

**Status:** ✅ Complete (2026-01-25)

**Note:** Combines official features (background agents, Mission Control) with community patterns.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| Parallel subagents via `#runSubagent` | **CONTRADICTED** → Subagents run synchronously | VS Code Chat Sessions |
| Background agents with Git worktree isolation | CONFIRMED | VS Code 1.107 Release Notes |
| `chat.customAgentInSubagent.enabled` setting | CONFIRMED | VS Code Copilot Settings |
| "Copilot: Agent HQ" command | **CONTRADICTED** → Use Chat: New Background Agent, etc. | VS Code 1.107 Release Notes |
| Mission Control at github.com/copilot/mission-control | **CONTRADICTED** → URL is github.com/copilot/agents | GitHub Blog |
| Mission Control on GitHub Mobile | CONFIRMED | GitHub Blog Changelog |
| `send: false` creates review checkpoint | CONFIRMED | VS Code Custom Agents |
| Subagents can't spawn subagents (one-level) | CONFIRMED | VS Code Chat Sessions |
| No native DAG editor | CONFIRMED (by omission) | All VS Code docs |
| No conditional routing syntax | CONFIRMED (by omission) | VS Code Custom Agents |

#### Corrections Applied

| Was | Now | Source |
|-----|-----|--------|
| "VS Code 1.107+ supports parallel `#runSubagent` execution" | Subagents run synchronously; use background agents for parallel | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| "github.com/copilot/mission-control" | "github.com/copilot/agents" | [GitHub Blog](https://github.blog/ai-and-ml/github-copilot/how-to-orchestrate-agents-using-mission-control/) |
| "Agent HQ" with "Copilot: Agent HQ" command | "Agent Sessions view" with `Chat: New Background Agent` commands | [VS Code 1.107](https://code.visualstudio.com/updates/v1_107) |
| "Available on github.com, VS Code, and GitHub Mobile" | Added JetBrains IDEs, GitHub CLI | [GitHub Blog](https://github.blog/news-insights/product-news/agents-panel-launch-copilot-coding-agent-tasks-anywhere-on-github/) |

#### Additions Made

| New Content | Source | Section Added |
|-------------|--------|---------------|
| Agent Sessions view settings (`chat.viewSessions.orientation`, `chat.agentSessionsViewLocation`) | [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings) | Agent Sessions View |
| Quick Open access (type "agent" in Ctrl+P) | [VS Code 1.108](https://code.visualstudio.com/updates/v1_108) | Agent Sessions View |
| @cli and @cloud mentions for delegation | [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview) | Agent Sessions View |
| /task command in github.com/copilot chat | [GitHub Blog](https://github.blog/news-insights/product-news/agents-panel-launch-copilot-coding-agent-tasks-anywhere-on-github/) | Mission Control |
| Background agents cannot access MCP servers | [VS Code Background Agents](https://code.visualstudio.com/docs/copilot/agents/background-agents) | (Note in file) |

#### Excerpts from Official Docs

> "Subagents don't run asynchronously or in the background, however, they operate autonomously without pausing for user feedback."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

> "Subagents use the same agent and have access to the same tools available to the main chat session, except for creating other subagents."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

> "This iteration, we enhanced the isolation of background agents by introducing support for Git worktrees."
> — [VS Code 1.107 Release Notes](https://code.visualstudio.com/updates/v1_107#_isolate-background-agents-with-git-worktrees)

> "Mission control changes this. You can kick off multiple tasks in minutes—across one repo or many."
> — [GitHub Blog](https://github.blog/ai-and-ml/github-copilot/how-to-orchestrate-agents-using-mission-control/)

> "Hand off tasks from anywhere: GitHub.com, GitHub Mobile, Copilot Chat, VS Code, or MCP-enabled tools."
> — [GitHub Blog](https://github.blog/news-insights/product-news/agents-panel-launch-copilot-coding-agent-tasks-anywhere-on-github/)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/agents/background-agents
- https://code.visualstudio.com/docs/copilot/agents/overview
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://code.visualstudio.com/updates/v1_107
- https://code.visualstudio.com/updates/v1_108
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent
- https://github.blog/ai-and-ml/github-copilot/how-to-orchestrate-agents-using-mission-control/
- https://github.blog/news-insights/product-news/agents-panel-launch-copilot-coding-agent-tasks-anywhere-on-github/
- https://github.blog/changelog/2025-10-28-a-mission-control-to-assign-steer-and-track-copilot-coding-agent-tasks/

---

### 22. conditional-routing.md (WORKFLOWS)

**Topic:** Conditional routing between agents/workflows

**Status:** ✅ Complete (2026-01-25)

**Note:** Combines official VS Code handoff features with community classification patterns (Dify, CursorRIPER).

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| No conditional syntax in handoffs | CONFIRMED | VS Code Custom Agents (by omission) |
| Hub-and-spoke constraint (no nested subagents) | CONFIRMED | VS Code Chat Sessions |
| `infer: true` default for subagent eligibility | CONFIRMED | VS Code Custom Agents |
| Handoff properties (label, agent, prompt, send) | CONFIRMED | VS Code Custom Agents |
| `send: false` creates review gate (default) | CONFIRMED | VS Code Custom Agents |
| `send: true` auto-submits | CONFIRMED | VS Code Custom Agents |
| Subagents run in parallel | **CONTRADICTED** → Sequential only | VS Code Chat Sessions |
| `chat.customAgentInSubagent.enabled` setting | CONFIRMED | VS Code Copilot Settings |
| Model tiers (Haiku/Sonnet/Opus) | **OUTDATED** → Now Claude Sonnet 4, GPT-5, GPT-5 mini | VS Code Language Models |
| Subagents can't spawn subagents | CONFIRMED | VS Code Chat Sessions |
| RIPER mode-based routing | SILENT → Community pattern | CursorRIPER |
| LLM-powered classification | SILENT → Community pattern | Dify |

#### Corrections Applied

| Was | Now | Source |
|-----|-----|--------|
| "Parallel Multi-Route (via subagents)" | "Subagent Delegation (Sequential, Not Parallel)" | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents) |
| Model tiers "Haiku → Sonnet → Opus" | Auto uses "Claude Sonnet 4, GPT-5, GPT-5 mini" | [Language Models](https://code.visualstudio.com/docs/copilot/customization/language-models#_auto-model-selection) |
| "for specialized parallel work" | "for specialized work" (removed parallel claim) | VS Code Chat Sessions |

#### Additions Made

| New Content | Source | Section Added |
|-------------|--------|---------------|
| Handoff Configuration Reference table (defaults for label/agent/prompt/send) | [Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_header-optional) | After Classifier Agent Pattern |
| `infer: false` to prevent subagent usage | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_use-a-custom-agent-with-subagents-experimental) | New "Preventing Subagent Usage" section |
| Subagent characteristics list (isolated context, sequential, etc.) | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents) | Subagent Delegation section |
| Enable runSubagent in tool picker requirement | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_invoke-a-subagent) | Subagent with Custom Agents |
| `model` field in custom agent frontmatter | [Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_header-optional) | Model Routing section |
| Anti-pattern: "Expecting parallel subagents" | VS Code Chat Sessions | Anti-Patterns table |

#### Excerpts from Official Docs

> "Subagents don't run asynchronously or in the background, however, they operate autonomously without pausing for user feedback."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

> "Subagents use the same agent and have access to the same tools available to the main chat session, except for creating other subagents."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

> "handoffs.send: Optional boolean flag to auto-submit the prompt (default is false)"
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_header-optional)

> "infer: Optional boolean flag to enable use of the custom agent as a subagent (default is true)."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_header-optional)

> "Currently, auto chooses between Claude Sonnet 4, GPT-5, GPT-5 mini and other models."
> — [VS Code Language Models](https://code.visualstudio.com/docs/copilot/customization/language-models#_auto-model-selection)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/customization/language-models
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/updates/v1_107

---

### 23. task-tracking.md (WORKFLOWS)

**Topic:** Task tracking in agent workflows

**Status:** ✅ Complete (2026-01-25)

**Note:** File primarily covers Beads (community pattern). VS Code native todo list feature documented in separate section. Memory bank folder pattern is community (Cline/Roo Code), not official.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| Agent mode creates todo lists | CONFIRMED | VS Code Chat Planning |
| Task lists in chat for complex requests | CONFIRMED | VS Code Chat Planning |
| Tasks checked off/updated as agent completes | CONFIRMED | VS Code Chat Planning |
| State lives in chat session | CONFIRMED | VS Code Chat Sessions |
| Lost when session ends | **CONTRADICTED** → Sessions are saved in history | VS Code Chat Sessions |
| Chat Planning URL valid | CONFIRMED | URL exists and covers feature |
| `.github/memory-bank/` folder | **SILENT** → Community pattern from Cline/Roo Code | Not in official docs |
| `#todos` tool reference | **SILENT** → No such hashtag tool; internal "Todo List tool" | VS Code Updates v1.104 |
| Beads integration | **SILENT** → External pattern, not VS Code native | Not in official docs |

#### Corrections Applied

| Was | Now | Source |
|-----|-----|--------|
| "Tasks are checked off as the agent completes them" | "Tasks update automatically as the agent completes each step" | [Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning#_track-progress-with-the-todo-list) |
| "state lives in the chat session" | "Todo list appears in Todo control at top of Chat view" | [Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning#_track-progress-with-the-todo-list) |
| "Lost when session ends (use Memory Bank for persistence)" | "Session history is preserved — all chat sessions are saved and can be resumed later" | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_chat-session-history) |
| Single source link | Multiple official sources with features table | Multiple VS Code docs |

#### Additions Made

| New Content | Source | Section Added |
|-------------|--------|---------------|
| Platform Note distinguishing native vs community patterns | Official docs review | Top of file |
| Todo control at top of Chat view | [Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning#_track-progress-with-the-todo-list) | VS Code Native Todo Lists |
| Natural language updates ("revise step 1") | [Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning#_track-progress-with-the-todo-list) | VS Code Native Todo Lists |
| Checkpoints feature for workspace restore | [Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) | Related Native Features table |
| Todo List tool history (v1.103 experimental, v1.104 default) | [v1.104 Release Notes](https://code.visualstudio.com/updates/v1_104#_todo-list-tool) | VS Code Native Todo Lists |
| Related Native Features table (Todo, Checkpoints, Sessions, Export, Plan) | Multiple docs | VS Code Native Todo Lists |

#### Silent Flags

| Claim | Flagged | Reason |
|-------|---------|--------|
| `.github/memory-bank/` folder | 2026-01-25 | Community pattern from Cline/Roo Code, not official VS Code |
| Beads patterns (hierarchy, dependencies) | 2026-01-25 | External tool, clearly attributed in file |

#### Excerpts from Official Docs

> "When working on complex tasks, VS Code's agent will create a todo list to track progress. The todo list breaks down your request into individual tasks and updates automatically as the AI completes each step."
> — [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning#_track-progress-with-the-todo-list)

> "All your chat sessions are saved in the session history, allowing you to return to previous conversations and continue where you left off."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_chat-session-history)

> "The todo list tool helps agents break down complex multi-step tasks into smaller tasks and report progress to help you track individual items. We've made improvements to this tool, which is now enabled by default."
> — [VS Code v1.104 Release Notes](https://code.visualstudio.com/updates/v1_104#_todo-list-tool)

> "You can update the todo list using natural language like 'revise step 1 to do x' or 'add another task'. If the agent's todos are not as expected, you can clear the list, but otherwise the agent manages the updates automatically."
> — [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning#_track-progress-with-the-todo-list)

> "Chat checkpoints provide a way to restore the state of your workspace to a previous point in time, and are useful when chat interactions resulted in changes across multiple files."
> — [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints#_use-checkpoints-to-revert-file-changes)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/chat/chat-planning
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints
- https://code.visualstudio.com/updates/v1_103
- https://code.visualstudio.com/updates/v1_104
- https://docs.github.com/en/copilot/concepts/agents/copilot-memory

---

### 24. iron-law-discipline.md (PATTERNS)

**Topic:** Iron Law discipline pattern — inviolable rules with Red Flags and Rationalization Prevention

**Status:** ✅ Complete (2026-01-25)

**Note:** "Iron Law", "Red Flags", and "Rationalization Prevention" are **community patterns** from [obra/superpowers](https://github.com/obra/superpowers), not native VS Code/Copilot features. However, VS Code's TDD Guide aligns with these concepts through agent handoffs and documented pitfalls. Patterns are implemented via agent instructions.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| Agent frontmatter format (name, description, tools) | CONFIRMED | VS Code Custom Agents |
| Tool name `terminal` | **CORRECTED** → Use `execute` (aliases: shell, Bash, powershell) | [GitHub Tool Aliases](https://docs.github.com/en/copilot/reference/custom-agents-configuration#tool-aliases) |
| "Iron Law" terminology | **SILENT** → Community pattern from obra/superpowers | Not in official docs |
| "Red Flags" stop conditions | **SILENT** → Community pattern from obra/superpowers | Not in official docs |
| "Rationalization Prevention Table" | **SILENT** → Community pattern from obra/superpowers | Not in official docs |
| `.critique.md` file format | **SILENT** → Cookbook-defined, not a recognized VS Code extension | Not in official docs |
| Severity levels (None/Low/Medium/High/Critical) | **SILENT** → Cookbook design pattern | Not in official docs |
| Self-verification checklist | **SILENT** → Implementation pattern, no VS Code equivalent | Not in official docs |
| 12-Factor Agents references (Factor 6, 7, 8) | **SILENT** → HumanLayer community framework | Not in official docs |
| TDD workflow alignment | **CONFIRMED** → VS Code TDD Guide uses red-green-refactor with handoffs | [VS Code TDD Guide](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide) |
| Security "NEVER COMMIT SECRETS" example | CONFIRMED (aligned) | [GitHub Best Practices](https://docs.github.com/en/copilot/tutorials/use-custom-instructions) |

#### Corrections Applied

| Was | Now | Source |
|-----|-----|--------|
| `tools: ["read", "edit", "terminal", "search"]` | `tools: ["read", "edit", "execute", "search"]` | [GitHub Tool Aliases](https://docs.github.com/en/copilot/reference/custom-agents-configuration#tool-aliases) |

#### Additions Made

| New Content | Source | Section Added |
|-------------|--------|---------------|
| Platform Note explaining community vs native patterns | Official docs review | Top of file |
| Additional TDD Pitfalls table (official VS Code pitfalls) | [VS Code TDD Guide](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide#_troubleshooting-and-best-practices) | Rationalization Prevention |
| Official VS Code TDD Integration section | VS Code TDD Guide | New section before Related |
| TDD agent with handoffs example | VS Code TDD Guide | Official VS Code TDD Integration |
| Official Documentation sources subsection | Multiple official docs | Sources |
| Comment in agent example explaining tool aliases | GitHub docs | Complete Agent Example |

#### Silent Flags Added

| Claim | Decision | Reason |
|-------|----------|--------|
| "Iron Law" pattern terminology | KEEP | Community pattern clearly attributed to obra/superpowers via platform note |
| "Red Flags" stop conditions | KEEP | Community pattern clearly attributed via platform note |
| "Rationalization Prevention Table" | KEEP | Community pattern clearly attributed via platform note |
| `.critique.md` file format | KEEP | Cookbook-defined format, HTML comment added noting not official |
| Severity levels (None/Low/Medium/High/Critical) | KEEP | Cookbook design pattern, HTML comment added noting not official |
| Self-verification checklist | KEEP | Useful implementation pattern with no VS Code equivalent |
| 12-Factor Agents (Factor 6, 7, 8) | KEEP | HumanLayer framework, HTML comment added noting not official |

#### Excerpts from Official Docs

> "TDD follows a three-phase cycle known as red-green-refactor and repeats for each small increment of functionality. Red phase: Write a failing test for the functionality you want to develop."
> — [VS Code TDD Guide](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide)

> "Common TDD pitfalls with AI: Skipping the red phase: AI might suggest implementing code before writing tests. Over-implementation: AI might generate more code than needed to pass the current test. Testing implementation details: Tests tightly coupled to code structure... Incomplete test coverage: AI might miss edge cases."
> — [VS Code TDD Guide - Troubleshooting](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide#_troubleshooting-and-best-practices)

> "Running TDD without handoffs: Using a single agent to complete the entire TDD cycle removes the human from the loop. Handoffs provide control points where you can assess each step, verify the AI's work, and steer the agent in the right direction before moving to the next phase."
> — [VS Code TDD Guide - Troubleshooting](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide#_troubleshooting-and-best-practices)

> "The following tool aliases are available for custom agents. All aliases are case insensitive: `execute` | `shell, Bash, powershell` | Shell tools: bash or powershell"
> — [GitHub Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration#tool-aliases)

> "Use automated tests and tooling to check Copilot's work. With the help of tools like linting, code scanning, and IP scanning, you can automate an additional layer of security and accuracy checks."
> — [GitHub Best Practices](https://docs.github.com/en/copilot/get-started/best-practices#check-copilots-work)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/security
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://docs.github.com/en/copilot/reference/custom-agents-configuration
- https://docs.github.com/en/copilot/get-started/best-practices

---

### 25. verification-gates.md (PATTERNS)

**Topic:** Verification gates — checkpoints requiring evidence before claims/completion

**Status:** ✅ Complete (2026-01-25)

**Note:** "Verification gates" as a structured pattern is a **community concept** from [obra/superpowers](https://github.com/obra/superpowers). However, VS Code provides native verification mechanisms through chat checkpoints, hooks, and trust boundaries. The structured gate patterns can be implemented via agent instructions and hook configurations.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `preToolUse` hook | CONFIRMED | [GitHub About Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks) |
| `postToolUse` hook | CONFIRMED | [GitHub About Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks) |
| Six hook types total | CONFIRMED | `sessionStart`, `sessionEnd`, `userPromptSubmitted`, `preToolUse`, `postToolUse`, `errorOccurred` |
| TDD Red-Green-Refactor | CONFIRMED | [VS Code TDD Guide](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide) |
| TDD custom agents (TDD-red, TDD-green, TDD-refactor) | CONFIRMED | VS Code TDD Guide |
| Chat checkpoints | CONFIRMED | [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) |
| `chat.checkpoints.enabled` setting | CONFIRMED | VS Code Settings Reference |
| Handoffs for phase transitions | CONFIRMED | [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs) |
| Trust boundaries | CONFIRMED | [VS Code Security](https://code.visualstudio.com/docs/copilot/security#_trust-boundaries) |
| GitHub Spec-Kit | CONFIRMED | [GitHub Spec-Kit](https://github.com/github/spec-kit) |
| Quote-first/evidence-first | PARTIAL | Implied in [Prompt Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/prompt-engineering-guide) |
| Abstention pattern | PARTIAL | Aligned with [Microsoft RAI Validation](https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/rai-validation) |
| Test coverage 80%/100% thresholds | **SILENT** → Community guideline | Not mandated in official docs |
| "Dual review pattern" (spec then code) | **SILENT** → obra/superpowers pattern | Not in official docs |
| "Backpressure testing" terminology | **SILENT** → Claude Code ecosystem | Not in official docs |
| obra/superpowers patterns | **SILENT** → Third-party community project | Not referenced in official docs |

#### Corrections Applied

| Was | Now | Source |
|-----|-----|--------|
| 3 hook types (preToolUse, postToolUse, Stop) | 6 hook types with official descriptions | [GitHub About Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks) |
| TDD without agent references | TDD with official agent names (TDD-red, TDD-green, TDD-refactor) | [VS Code TDD Guide](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide) |
| Abstention without official backing | Added Microsoft RAI validation reference | [Microsoft Transparency Note](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-transparency-note#manage) |

#### Additions Made

| New Content | Source | Section Added |
|-------------|--------|---------------|
| Platform Note explaining community vs native patterns | Official docs review | Top of file |
| VS Code Native Checkpoints section | [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) | After Core Principle |
| Trust Boundaries subsection | [VS Code Security](https://code.visualstudio.com/docs/copilot/security#_trust-boundaries) | VS Code Native Checkpoints |
| TDD custom agents table | [VS Code TDD Guide](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide) | Type 5: TDD |
| preToolUse `permissionDecision` detail | GitHub Hooks Reference | Hook-Based Verification |
| `.github/hooks/*.json` location | GitHub Hooks Reference | Hook-Based Verification |
| Official VS Code/GitHub Documentation subsection | Multiple official docs | Sources |

#### Silent Flags Added

| Claim | Decision | Reason |
|-------|----------|--------|
| Test coverage thresholds (80% general, 100% security) | KEEP | Community guideline, HTML comment + note added clarifying not official |
| "Dual review pattern" (spec compliance before code quality) | KEEP | Community pattern from obra/superpowers, HTML comment added |
| "Backpressure testing" terminology | KEEP | Community pattern from Claude Code ecosystem, HTML comment added |

#### Excerpts from Official Docs

> "preToolUse: Executed before the agent uses any tool (such as bash, edit, view). This is the most powerful hook as it can approve or deny tool executions. Use this hook to block dangerous commands, enforce security policies and coding standards, require approval for sensitive operations, or log tool usage for compliance."
> — [GitHub About Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks#types-of-hooks)

> "The following types of hooks are available: sessionStart, sessionEnd, userPromptSubmitted, preToolUse, postToolUse, errorOccurred"
> — [GitHub About Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks#types-of-hooks)

> "Checkpoints allow you to save the state of your chat session at a specific point in time... helpful if you want to experiment with different approaches"
> — [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)

> "Trust boundaries limit critical operations unless trust is explicitly granted by the user. They ensure that only authorized actions are permitted."
> — [VS Code Security](https://code.visualstudio.com/docs/copilot/security#_trust-boundaries)

> "TDD follows a three-phase cycle known as red-green-refactor... Write a failing test... Use Copilot to write the minimum code... Refactor the code"
> — [VS Code TDD Guide](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide)

> "In this release, the runTests tool now also reports test code coverage to the agent. This enables the agent to generate and verify tests that cover the entirety of your code."
> — [VS Code Updates v1.105](https://code.visualstudio.com/updates/v1_105#_testing)

> "If you instruct the model to cite the source material when it makes statements, those statements are much more likely to be grounded."
> — [Prompt Engineering Techniques](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/prompt-engineering)

> "Metaprompting involves giving instructions to the model to guide its behavior... Classifiers... flag different types of potential harmful content... leads to potential mitigations, such as not returning generated content"
> — [Microsoft Transparency Note](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-transparency-note#manage)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints
- https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide
- https://code.visualstudio.com/docs/copilot/guides/test-with-copilot
- https://code.visualstudio.com/docs/copilot/security
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/guides/prompt-engineering-guide
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/updates/v1_105
- https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks
- https://docs.github.com/en/copilot/reference/hooks-configuration
- https://github.com/github/spec-kit
- https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/rai-validation
- https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-transparency-note

---

### 26. hallucination-reduction.md (PATTERNS)

**Topic:** Hallucination reduction — patterns to prevent AI fabrication and ensure grounded responses

**Status:** ✅ Complete (2026-01-25)

**Note:** VS Code/Copilot docs explicitly acknowledge hallucination risks but place validation burden on users. The patterns in this file are **community best practices** implementable via custom instructions, with some supported by Microsoft's broader AI guidance.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| "I Don't Know" pattern | **PARTIAL SUPPORT** | [MS UX Guidance](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/ux-guidance) confirms "Withhold outputs when necessary" |
| Direct Quote Grounding | **CONFIRMED** | MS UX: "By integrating direct quotes from the source and directing the user to the specific location of that information" |
| Citation Verification (self-retraction) | **SILENT** | Pattern not documented in official VS Code docs |
| Best-of-N Verification | **SILENT** | Pattern not documented in official VS Code docs |
| Investigate-First Rule | **PARTIAL SUPPORT** | Implied by Plan agent's "research-first" approach and context provision patterns |
| Knowledge Restriction | **PARTIAL SUPPORT** | Supported via custom agents with restricted tools; MS: "ground AI-generated content in relevant business data" |
| Chain-of-Verification (CoVe) | **SILENT** | Academic pattern (Meta/ACL 2023), not in official docs |
| Confidence Thresholds (80%/50%) | **PARTIAL SUPPORT** | [MS Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/kit-prompt-advisor) documents "High (80-100)... Medium (50-79)... Low (0-49)" |
| Anti-Sycophancy Checks | **SILENT** | Not documented; related: MS UX "Human in control" principle |
| Evidence-First Gate | **SILENT** | Pattern not explicitly documented |
| Citations API (Anthropic) | **CONFIRMED** | [Anthropic](https://www.anthropic.com/news/introducing-citations-api): "reduced source hallucinations from 10% to 0%" — Note: Not VS Code native |
| Hallucination risk warning | **CONFIRMED** | [GitHub Responsible Use](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-your-ide) |
| User validation responsibility | **CONFIRMED** | GitHub: "Users of Copilot Chat are responsible for reviewing and validating responses" |

#### Corrections Applied

| Was | Now | Source |
|-----|-----|--------|
| Missing official hallucination warnings | Added official quotes from GitHub Responsible Use docs | [GitHub Responsible Use](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-your-ide) |
| Citations API link to `claude.com/blog` | Corrected to `anthropic.com/news` with case study metrics | [Anthropic Citations API](https://www.anthropic.com/news/introducing-citations-api) |
| "Why it works" for Grounding — no official backing | Added Microsoft UX guidance citation | [MS UX Guidance](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/ux-guidance) |
| Confidence thresholds without attribution | Added MS Copilot Studio reference for similar thresholds | [MS Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/kit-prompt-advisor) |
| Knowledge Restriction — no official backing | Added MS Transparency Note "grounding in business data" | [MS Transparency Note](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-transparency-note) |
| Investigate-First — no VS Code context | Added #codebase and #file reference mechanisms | VS Code docs |
| Missing platform note | Added top-of-file platform note explaining community vs official | N/A (editorial) |
| Missing VS Code native features | Added "VS Code Native Mitigation Features" section | VS Code docs |

#### Additions Made

| New Content | Source | Section Added |
|-------------|--------|---------------|
| Platform Note (community patterns, not official features) | Official docs review | Top of file |
| Official hallucination warnings with quotes | [GitHub Responsible Use](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-your-ide) | The Problem |
| MS UX withhold outputs reference | [MS UX Guidance](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/ux-guidance) | Allow "I Don't Know" |
| MS UX citations reference | [MS UX Guidance](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/ux-guidance) | Direct Quote Grounding |
| VS Code Native Mitigation Features section | Multiple VS Code docs | New section before Related |
| Human review loop (Keep/Undo, tool approval, URL approval) | [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools) | VS Code Native Mitigation |
| Checkpoints subsection | [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) | VS Code Native Mitigation |
| Context isolation for subagents | [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) | VS Code Native Mitigation |
| Appropriate friction pattern | [MS UX Guidance](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/ux-guidance) | VS Code Native Mitigation |
| Context engineering anti-patterns | [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) | VS Code Native Mitigation |
| Updated Sources with Official Documentation section | Multiple official docs | Sources |

#### Silent Flags Added

| Claim | Decision | Reason |
|-------|----------|--------|
| Citation Verification self-retraction pattern | KEEP | Community pattern, HTML comment added |
| Best-of-N Verification pattern | KEEP | Prompt engineering research, HTML comment added |
| Chain-of-Verification (CoVe) methodology | KEEP | Academic pattern (Meta/ACL 2023), HTML comment added, research citation retained |
| Anti-Sycophancy Checks | KEEP | Community pattern, HTML comment added |
| Evidence-First Gate | KEEP | Related pattern in verification-gates.md |

#### Excerpts from Official Docs

> "One of the limitations of Copilot Chat is that it may generate code that appears to be valid but may not actually be semantically or syntactically correct"
> — [GitHub Responsible Use of Copilot Chat (IDE)](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-your-ide)

> "There is a risk of 'hallucination,' where Copilot generates statements that are inaccurate"
> — [GitHub Responsible Use of Copilot Chat (GitHub)](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-github)

> "Users of Copilot Chat are responsible for reviewing and validating responses generated by the system to ensure its accuracy and appropriateness"
> — [GitHub Responsible Use of Copilot Chat (IDE)](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-your-ide)

> "Withhold outputs when necessary... In some cases, it's better for a copilot to give no answer instead of outputting something potentially inappropriate."
> — [Microsoft Creating a Dynamic UX](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/ux-guidance#6-withhold-outputs-when-necessary)

> "By integrating direct quotes from the source and directing the user to the specific location of that information, your copilot can support more thorough fact-checking."
> — [Microsoft Creating a Dynamic UX](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/ux-guidance#4-encourage-fact-checking-using-citations-and-direct-quotes)

> "An important mitigation in Microsoft 365 Copilot is to ground AI-generated content in relevant business data."
> — [Microsoft Transparency Note](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-transparency-note#manage)

> "Endex reduced source hallucinations and formatting issues from 10% to 0%"
> — [Anthropic Citations API](https://www.anthropic.com/news/introducing-citations-api)

> "Always review tool parameters carefully before approving, especially for tools that modify files, run commands, or access external services."
> — [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools)

> "Context dumping: Avoid providing excessive, unfocused information that doesn't directly help with decision-making."
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/overview
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/chat/review-code-edits
- https://code.visualstudio.com/docs/copilot/chat/chat-planning
- https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/guides/prompt-engineering-guide
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/copilot-tips-and-tricks
- https://code.visualstudio.com/docs/copilot/reference/workspace-context
- https://code.visualstudio.com/docs/copilot/security
- https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-your-ide
- https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-github
- https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/ux-guidance
- https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-transparency-note
- https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/kit-prompt-advisor
- https://www.anthropic.com/news/introducing-citations-api

---

### 27. twelve-factor-agents.md (PATTERNS)

**Topic:** Twelve-factor agents pattern

**Status:** ✅ Complete (2026-01-25)

**Note:** Community framework from HumanLayer, not official VS Code feature. Many factors map to native VS Code capabilities.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| Factor 1: Tool invocations | CONFIRMED | VS Code docs |
| Factor 2: Own prompts (`.agent.md`, `.instructions.md`) | CONFIRMED | VS Code docs |
| Factor 3: "Dumb zone" 40-60% utilization | **SILENT** | Not in official docs |
| Factor 4: Tools return JSON | CONFIRMED | VS Code docs |
| Factor 5: Memory bank persistence | **SILENT** | Official uses sessions/checkpoints |
| Factor 6: Launch/Pause/Resume (checkpoints) | CONFIRMED | VS Code docs |
| Factor 7: Human escalation as tool | CONFIRMED | VS Code docs (tool approval) |
| Factor 8: Own control flow (handoffs) | CONFIRMED | VS Code docs |
| Factor 9: Error compaction | **SILENT** | Not explicitly documented |
| Factor 10: Small focused agents (3-10 steps) | CONFIRMED | VS Code docs (decomposition) |
| Factor 11: `@agent-name` invocation | PARTIAL | Built-in only; custom agents use dropdown |
| Factor 12: Stateless reducer | PARTIAL | Sessions are stateful; conceptual model |
| Factor 13: Pre-fetch context | CONFIRMED | Custom instructions pattern |
| WRAP pattern | **SILENT** | Not in official docs |
| HumanLayer attribution | CONFIRMED | External framework, clearly cited |

#### Excerpts from Official Docs

> "Tools extend chat in Visual Studio Code with specialized functionality... The agent autonomously chooses and invokes relevant tools as needed"
> — [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools)

> "Separate concerns: Use different agents for different activities (planning versus implementation versus review)"
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

> "Chat checkpoints provide a way to restore the state of your workspace to a previous point in time"
> — [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)

> "Handoffs enable you to create guided sequential workflows that transition between agents with suggested next steps."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs)

> "Terminal approval: Before executing any terminal commands, the agent requests explicit user approval."
> — [VS Code Security](https://code.visualstudio.com/docs/copilot/security)

> "Start small and iterate: Begin with minimal project context and gradually add detail based on observed AI behavior."
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

> "As with web apps, an agent is inherently stateless."
> — [Microsoft Agents SDK State](https://learn.microsoft.com/en-us/microsoft-365/agents-sdk/state-concepts)

> "Chat sessions are automatically saved, enabling you to continue conversations where you left off."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

#### Additions Made

1. Added platform note clarifying 12-Factor Agents is a HumanLayer community framework
2. Added "VS Code Native Features Supporting These Factors" section mapping factors to official features
3. Added official VS Code documentation URLs to Sources section
4. Updated Factor 11 description (custom agents use dropdown, not @-mention)
5. Added HTML comment flags for "dumb zone" and WRAP pattern claims

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/security
- https://code.visualstudio.com/docs/copilot/agents/overview
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://docs.github.com/en/copilot/concepts/agents/copilot-memory
- https://learn.microsoft.com/en-us/microsoft-365/agents-sdk/state-concepts

---

### 28. prompt-engineering.md (PATTERNS)

**Topic:** Prompt engineering patterns and techniques for VS Code Copilot

**Status:** ✅ Complete (2026-01-25)

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| 4-Element Prompt Structure | **SILENT** — not named as official framework | (flagged in file) |
| 4 Ss Framework "Microsoft's" | **SILENT** — principles confirmed but name not official | Platform note added |
| ReAct Pattern | **SILENT** — research pattern, not VS Code terminology | Platform note added |
| Positive Framing | CONFIRMED | VS Code Prompt Engineering Guide |
| Chain-of-Thought | CONFIRMED | Microsoft Learn Prompt Engineering |
| Claude Thinking Triggers | **CORRECTED** — "think"/"ultrathink" do NOT allocate thinking tokens | Claude Code Workflows |
| Role Prompting | CONFIRMED | VS Code Context Engineering Guide |
| Few-Shot Examples | CONFIRMED | VS Code Prompt Engineering Guide |
| Output Templates | CONFIRMED | VS Code Context Engineering Guide |
| Tree of Thoughts | **SILENT** — research pattern | Platform note added |
| Query Complexity Routing | **SILENT** — community pattern | Platform note added |
| Quantified Limits | CONFIRMED | VS Code Context Engineering Guide |
| Chat History Management | CONFIRMED | VS Code Chat Sessions |
| Claude Opus 4.5 behaviors | CONFIRMED | Anthropic Claude 4 Best Practices |
| `.agent.md` files | CONFIRMED | VS Code Custom Agents |
| `.instructions.md` files | CONFIRMED | VS Code Custom Instructions |
| `.prompt.md` files | CONFIRMED | VS Code Prompt Files |
| `copilot-instructions.md` | CONFIRMED | VS Code Custom Instructions |
| `${selection}` variable | CONFIRMED | VS Code Prompt Files |
| `#file:path` syntax | **CORRECTED** → `#filename` (simpler syntax) | VS Code Chat Context |
| `mode: agent` frontmatter | **CORRECTED** → field is `agent:` not `mode:` | VS Code Prompt Files |
| `tools:` frontmatter | CONFIRMED | VS Code Prompt Files |

#### Corrections Applied

1. Changed `mode: agent` to `agent: agent` in frontmatter example
2. Changed `#file:src/auth.ts` to `#src/auth.ts` (simpler syntax)
3. Changed `tools: ['read', 'edit', 'search']` to `tools: ['editFiles', 'fetch', 'search']` (actual tool names)
4. **Major correction:** Claude thinking triggers table replaced with note that "think"/"think hard"/"ultrathink" do NOT allocate thinking tokens

#### Excerpts from Official Docs

> "To get the best results from Copilot, it helps to follow some best practices for prompts: be specific, keep it simple, and ask follow-up questions."
> — [VS Code Copilot Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features#chat-experience-in-vs-code)

> "One trick to get AI on the right page, is to copy and paste sample code that is close to what you are looking for into your open editor."
> — [VS Code Prompt Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/prompt-engineering-guide)

> "Create a planning persona... 'You are an architect focused on...'"
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide#_step-2-create-implementation-plan)

> "Type `#`, followed by a file, folder, or symbol name, to add it as chat context."
> — [VS Code Copilot Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context#_add-files-as-context)

> "Phrases like 'think', 'think hard', 'ultrathink', and 'think more' are interpreted as regular prompt instructions and don't allocate thinking tokens."
> — [Claude Code Common Workflows](https://code.claude.com/docs/en/common-workflows#use-extended-thinking-thinking-mode)

> "Chain of thought prompting is the practice of prompting a model to perform a task step-by-step and to present each step and its result in order in the output"
> — [Microsoft Learn Prompt Engineering](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/prompt-engineering#chain-of-thought-prompting)

> "Claude Opus 4.5 has a tendency to overengineer by creating extra files, adding unnecessary abstractions, or building in flexibility that wasn't requested."
> — [Claude 4 Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices#overeagerness-and-file-creation)

> "When extended thinking is disabled, Claude Opus 4.5 is particularly sensitive to the word 'think' and its variants. We recommend replacing 'think' with alternative words that convey similar meaning, such as 'consider,' 'believe,' and 'evaluate.'"
> — [Claude 4 Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices#thinking-sensitivity)

#### Additions Made

1. Added "Additional Official Guidance" section with iteration guidance, sample code priming, project context docs recommendation
2. Added 128 tools per request limit
3. Added subagent isolation note
4. Reorganized Sources into "Official Documentation" and "Research & Community" sections
5. Added citation to Claude Opus 4.5 Pitfalls table

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/guides/prompt-engineering-guide
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/prompt-engineering
- https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices
- https://code.claude.com/docs/en/common-workflows

---

### 29. constitutional-principles.md (PATTERNS)

**Topic:** Constitutional principles, constraint hierarchies, and immutable rules for agent behavior

**Status:** ✅ Complete (2026-01-25)

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `.github/copilot-instructions.md` location | **CONFIRMED** | VS Code Custom Instructions |
| `memory/constitution.md` location | **SILENT** — community pattern from Cline Memory Bank | HTML comment added |
| Constraint priority hierarchy (Safety > Project > etc.) | **CONTRADICTED** — VS Code "combines with no specific order guaranteed" | Platform note + correction added |
| Hard constraints vs contextual guidelines | **SILENT** — design pattern, not platform feature | HTML comment added |
| `.github/agents/{name}.agent.md` path | **CONFIRMED** | VS Code Custom Agents |
| Protection Level markers (!cp, !cg, etc.) | **SILENT** — CursorRIPER.sigma pattern | HTML comment added |
| Spec-Kit constitutional principles | **SILENT** (VS Code) — external CLI tool exists | HTML comment added |
| `/speckit.constitution` command | **SILENT** (VS Code) — Spec-Kit CLI command | HTML comment added |
| `memory/protection.md` file | **SILENT** — CursorRIPER.sigma pattern | HTML comment added |
| Anthropic Constitution hierarchy | **SILENT** — Anthropic framework, not VS Code | N/A (external source) |
| Instruction conflict resolution | **CONTRADICTED** — no priority, combined "with no specific order guaranteed" | Platform note added |

#### Corrections Applied

1. **Major correction:** Added Platform Note at top clarifying constraint hierarchy is a design pattern, not platform behavior
2. Added HTML comment to Constraint Hierarchy section explaining VS Code does NOT enforce priority
3. Updated Constraint Hierarchy section text to clarify it's a "writing guideline"
4. Removed claim "Higher priority principles always win"
5. Added "How VS Code Handles Instructions" section with official behavior
6. Added "Platform-Level Safety (GitHub)" section documenting actual safety pipeline
7. Updated Deployment Locations table to include `.instructions.md` files and `AGENTS.md`
8. Reorganized Sources into "Official VS Code / GitHub Documentation" and "External Tools & Frameworks"

#### Key Correction: Constraint Hierarchy

**Cookbook claimed:** "Higher priority principles **always win** in conflicts" with Safety > Project > Behavioral > User hierarchy.

**Official docs say:**
> "If you have multiple types of instructions files in your project, VS Code combines and adds them to the chat context, **no specific order is guaranteed**."

**Resolution:** The hierarchy is retained as a **design pattern** for writing non-conflicting instructions, with explicit Platform Note explaining VS Code does not enforce semantic priority.

#### Additions Made

1. Added "How VS Code Handles Instructions" section explaining:
   - Instructions are combined, not prioritized
   - LLM resolves conflicts
   - Recommendation to avoid conflicting instructions
2. Added "Platform-Level Safety (GitHub)" section:
   - Input/output filtering pipeline
   - Content safety filters
   - Responsible AI principles
3. Added `AGENTS.md` and `.instructions.md` to Deployment Locations
4. Added Official Documentation sources section

#### Excerpts from Official Docs

> "If you have multiple types of instructions files in your project, VS Code combines and adds them to the chat context, **no specific order is guaranteed**."
> — [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions#_type-of-instructions-files)

> "You can use a combination of these approaches to define custom instructions and the instructions are all included in the chat request. **No particular order or priority is applied to the instructions**, so make sure to avoid conflicting instructions."
> — [VS Code Customization Overview](https://code.visualstudio.com/docs/copilot/customization/overview)

> "On the proxy, we first test the prompt for **toxic language—things like hate speech, sexual content, violence, and evidence of self-harm—and relevance**."
> — [GitHub Copilot Data Handling](https://resources.github.com/learn/pathways/copilot/essentials/how-github-copilot-handles-data/)

> "For trust & safety and security, **there SHOULD always be a human in the loop** with the ability to deny tool invocations."
> — [MCP Specification — Tools](https://modelcontextprotocol.io/specification/2025-06-18/server/tools)

> "**User Consent and Control**: Users must explicitly consent to and understand all data access and operations."
> — [MCP Specification Security Principles](https://modelcontextprotocol.io/specification/2025-11-25)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/overview
- https://code.visualstudio.com/docs/copilot/security
- https://resources.github.com/learn/pathways/copilot/essentials/how-github-copilot-handles-data/
- https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-your-ide
- https://modelcontextprotocol.io/specification/2025-11-25
- https://modelcontextprotocol.io/specification/2025-06-18/server/tools
- https://github.com/github/spec-kit

---

### 29. constitutional-principles.md (PATTERNS)

**Topic:** Constitutional AI principles for agents

**Status:** ⏳ Pending

**Note:** Community pattern, not official VS Code feature.

#### Key Findings

*(Populated during validation)*

#### Excerpts from Official Docs

*(Quoted text with source URLs added during validation)*

#### Sources Consulted

*(URLs read during validation)*

---

### 30. constraint-hierarchy.md (PATTERNS)

**Topic:** Constraint hierarchy for agent instructions, priority resolution

**Status:** ✅ Complete (2026-01-25)

**Note:** Design pattern with official documentation support for precedence rules.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| Platform behavior quote | **CORRECTED** → Updated to exact official wording | VS Code + GitHub docs |
| Four-tier priority system (Safety > Context > Behavioral > User) | **SILENT** | Cookbook design pattern, platform note exists |
| VS Code instruction file locations | CONFIRMED | VS Code docs |
| VS Code settings precedence order | CONFIRMED | VS Code docs (general settings) |
| Object vs primitive merge behavior | CONFIRMED | VS Code docs (general settings) |
| GitHub instruction file precedence | **CORRECTED** → Fixed order, removed "Agent file" distinction | GitHub docs |
| `excludeAgent` frontmatter values | CONFIRMED | GitHub docs |
| Protection level markers (!cp, !cg, etc.) | **SILENT** | CursorRIPER.sigma (third-party), attribution exists |

#### Additions Made

| Addition | Source |
|----------|--------|
| VS Code Trust Boundaries section (Workspace, Extension Publisher, MCP Server) | VS Code Security docs |
| Enterprise AI Policies section (ChatToolsAutoApprove, ChatToolsEligibleForAutoApproval, ChatToolsTerminalEnableAutoApprove) | VS Code Enterprise AI Settings |
| Tool List Priority section (prompt file > agent > defaults) | VS Code Custom Agents docs |
| Settings precedence source citation | VS Code Settings docs |

#### Excerpts from Official Docs

> "If you have multiple types of instructions files in your project, VS Code combines and adds them to the chat context, **no specific order is guaranteed**."
> — [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions#_type-of-instructions-files)

> "Due to the non-deterministic nature of AI, Copilot may not always follow your custom instructions in exactly the same way every time they are used."
> — [GitHub Response Customization](https://docs.github.com/en/copilot/concepts/prompting/response-customization)

> "Configurations can be overridden at multiple levels by the different setting scopes. In the following list, later scopes override earlier scopes: Default settings → User settings → Remote settings → Workspace settings → Workspace Folder settings → Language-specific [...] → Policy settings - Set by the system administrator, these values always override other setting values."
> — [VS Code Settings](https://code.visualstudio.com/docs/getstarted/settings#_settings-precedence)

> "Values with primitive types and Array types are overridden, meaning a configured value in a scope that takes precedence over another scope is used instead of the value in the other scope. But, values with Object types are merged."
> — [VS Code Settings](https://code.visualstudio.com/docs/getstarted/settings#_settings-precedence)

> "The list of available tools in chat is determined by the following priority order: 1. Tools specified in the prompt file (if any) 2. Tools from the referenced custom agent in the prompt file (if any) 3. Default tools for the selected agent (if any)"
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_tool-list-priority)

> "Use either `"code-review"` or `"coding-agent"`."
> — [GitHub Adding Custom Instructions](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot#creating-path-specific-custom-instructions)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/reference/workspace-context
- https://code.visualstudio.com/docs/getstarted/settings
- https://code.visualstudio.com/docs/copilot/security
- https://code.visualstudio.com/docs/enterprise/ai-settings
- https://code.visualstudio.com/docs/enterprise/policies
- https://docs.github.com/en/copilot/concepts/prompting/response-customization
- https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot
- https://docs.github.com/en/copilot/reference/policy-conflicts

---

### 31. memory-bank-files.md (CONTEXT-MEMORY)

**Topic:** Memory bank file structure and usage for cross-session context persistence

**Status:** ✅ Complete (2026-01-26)

**Note:** Community pattern (Cline/Roo Code origin), not official VS Code feature. Platform note added to clarify.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `.github/memory-bank/` folder pattern | **SILENT** → KEEP with platform note | Community pattern, not in official docs |
| 6-file core pattern (projectbrief, productContext, techContext, systemPatterns, activeContext, progress) | **SILENT** → KEEP with platform note | Cline origin, documented with source |
| `manifest.yaml` file | **SILENT** → KEEP | Community extension to pattern |
| `#file:` syntax in instructions | **CORRECTED** → Use Markdown links in instructions, `#filename` in chat | VS Code docs |
| GitHub Agentic Memory Public Preview Jan 2026 | **CONFIRMED** | GitHub changelog, official docs |
| Agentic Memory is repository-scoped | **CONFIRMED** | GitHub docs |
| Memories auto-expire after 28 days | **CONFIRMED** | GitHub docs |
| Agentic Memory works with coding agent, code review, CLI | **CONFIRMED** | GitHub docs |
| Session history persists across VS Code restarts | **CONFIRMED** | VS Code docs |
| Checkpoints allow rollback within session | **CONFIRMED** | VS Code docs |
| `copilot-instructions.md` auto-loads | **CONFIRMED** | VS Code docs |
| Update triggers and file dependencies | **SILENT** → KEEP | Implementation pattern |

#### Corrections Applied

| Original | Corrected | Source |
|----------|-----------|--------|
| `#file:.github/memory-bank/...` syntax | Markdown links `[name](path)` in instructions; `#filename` in chat | [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files#_body) |
| "complementary approach" description of Agentic Memory | Expanded with official characteristics: server-side, 28-day expiry, repository-scoped | [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) |

#### Additions Made

| Addition | Source |
|----------|--------|
| Platform Note clarifying community vs official status | Official docs confirmation |
| Native VS Code Session Management section (session history, checkpoints, export, save as prompt) | [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions), [Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) |
| Syntax Note for file references | [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files), [Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) |
| Official Documentation section in Sources | Multiple VS Code/GitHub docs |
| Expanded Agentic Memory details | [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) |

#### Excerpts from Official Docs

> "Copilot can develop a persistent understanding of a repository by storing 'memories.' Memories are tightly scoped pieces of information about a repository, that are deduced by Copilot as it works on the repository."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#introduction)

> "Memories are repository scoped, not user scoped, so all memories stored for a repository are available for use in Copilot operations initiated by any user who has access to Copilot Memory for that repository."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#how-memories-are-stored-retained-and-used)

> "Memories are automatically deleted after 28 days to avoid stale information adversely affecting agentic decision making."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/copilot-memory#deleting-a-memory)

> "Currently Copilot Memory is used by Copilot coding agent and Copilot code review when these features are working on pull requests on the GitHub website, and by Copilot CLI."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#where-is-copilot-memory-used)

> "All your chat sessions are saved in the session history, allowing you to return to previous conversations and continue where you left off."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_chat-session-history)

> "Chat checkpoints provide a way to restore the state of your workspace to a previous point in time, and are useful when chat interactions resulted in changes across multiple files."
> — [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints#_use-checkpoints-to-revert-file-changes)

> "You can reference other workspace files by using Markdown links. Use relative paths to reference these files."
> — [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files#_body)

> "#-mention the file, folder, or symbol in your chat message by typing `#` followed by the name of the file, folder, or symbol."
> — [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context#_add-files-as-context)

#### Sources Consulted

- https://docs.github.com/en/copilot/concepts/agents/copilot-memory
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/copilot-memory
- https://github.blog/changelog/2026-01-15-agentic-memory-for-github-copilot-is-in-public-preview/
- https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://code.visualstudio.com/docs/copilot/workspace-context

---

### 32. tiered-memory.md (CONTEXT-MEMORY)

**Topic:** Tiered memory architecture pattern for organizing context by access frequency

**Status:** ✅ Complete (2026-01-26)

**Note:** Community pattern (synthesized from mem0, CrewAI, Azure Foundry), not official VS Code feature. Platform note added to clarify.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| Hot/Warm/Cold/Frozen tier terminology | **SILENT** → KEEP with platform note | Synthesized design pattern, correctly documented |
| GitHub Copilot Memory 28-day expiration | **CONFIRMED** | GitHub docs |
| Repository-scoped memory | **CONFIRMED** | GitHub docs |
| Memory validation against codebase | **CONFIRMED** | GitHub docs |
| `#file:` reference syntax | **CORRECTED** → `#filename` (no colon) | VS Code docs |
| <40%, 40-60%, >60%, >80% utilization thresholds | **SILENT** → KEEP with community guideline note | HumanLayer ACE pattern |
| 70% and 85% compaction triggers | **SILENT** → KEEP with community guideline note | Community pattern |
| `.github/memory-bank/` folder pattern | **SILENT** → KEEP | Community pattern from Cline |
| Temporal context feature | **ADDITION** | VS Code 1.97 release notes |
| Agent conversation summarization setting | **ADDITION** | VS Code 1.101 release notes |
| Context overflow behavior (file→outline→exclude) | **ADDITION** | VS Code context docs |

#### Corrections Applied

| Original | Corrected | Source |
|----------|-----------|--------|
| `#file:` syntax | `#filename` (type `#` followed by filename) | [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) |
| Utilization thresholds without attribution | Added community guideline note attributing to HumanLayer ACE | Official docs don't specify thresholds |
| Compaction triggers without attribution | Added community guideline note + VS Code native summarization setting | [VS Code 1.101](https://code.visualstudio.com/updates/v1_101) |

#### Additions Made

| Addition | Source |
|----------|--------|
| "VS Code Native: Temporal Context" section with `temporalContext.enabled` settings | [VS Code 1.97 Release Notes](https://code.visualstudio.com/updates/v1_97) |
| Agent conversation summarization setting (`github.copilot.chat.summarizeAgentConversationHistory.enabled`) | [VS Code 1.101 Release Notes](https://code.visualstudio.com/updates/v1_101) |
| Context overflow behavior (full file→outline→exclude) | [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) |
| Official Documentation section in Sources | Multiple VS Code/GitHub docs |
| HumanLayer ACE attribution for utilization guidelines | [HumanLayer 12-Factor Agents](https://github.com/humanlayer/12-factor-agents) |

#### Excerpts from Official Docs

> "To avoid stale memories being retained indefinitely, memories are automatically deleted after 28 days."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

> "Memories are: Repository-specific - You can store memories for as many repositories as you like. The memories stored for a repository can only be used in Copilot operations on that same repository."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

> "When Copilot finds a memory that relates to the work it is doing, it checks the citations against the current codebase to validate that the information is still accurate."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

> "If possible, the full contents of the file will be included when you attach a file. If that is too large to fit into the context window, an outline of the file will be included that includes functions and their descriptions without implementations. If the outline is also too large, then the file won't be part of the prompt."
> — [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context)

> "Temporal context helps when editing or generating code by informing the language model about files that you have recently interacted with. `github.copilot.chat.editor.temporalContext.enabled` for Inline Chat and `github.copilot.chat.edits.temporalContext.enabled` for Copilot Edits."
> — [VS Code 1.97 Release Notes](https://code.visualstudio.com/updates/v1_97)

> "That summary is also included when summarizing the conversation history when the context gets too large to keep the agent going through complex operations."
> — [VS Code 1.101 Release Notes](https://code.visualstudio.com/updates/v1_101)

#### Sources Consulted

- https://docs.github.com/en/copilot/concepts/agents/copilot-memory
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/copilot-memory
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/reference/workspace-context
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://code.visualstudio.com/updates/v1_97
- https://code.visualstudio.com/updates/v1_101

---

### 33. conflict-resolution.md (CONTEXT-MEMORY)

**Topic:** Memory conflict resolution strategies

**Status:** ✅ Complete (2026-01-26)

**Note:** Community pattern file. ADD/UPDATE/DELETE/NOOP model, conflict markers, hash-based IDs, and manifest.yaml config are from external sources (mem0, Beads). GitHub Copilot Memory section updated with verified official docs.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| ADD/UPDATE/DELETE/NOOP model | **SILENT** → KEEP with HTML flag | mem0 research paper, not VS Code |
| Conflict resolution strategies (append_only, last_write_wins, semantic_merge, frozen) | **SILENT** → KEEP with HTML flag | Cookbook design patterns |
| Conflict markers format (`<!-- CONFLICT: ... -->`) | **SILENT** → KEEP with HTML flag | Cookbook design pattern |
| GitHub Copilot Memory citation-based verification | **CONFIRMED** | GitHub docs |
| 28-day memory expiry | **CONFIRMED** | GitHub docs |
| Self-healing memory pattern | **CONFIRMED** | GitHub Engineering Blog |
| Git push session completion protocol | **SILENT** → KEEP with HTML flag | Community pattern |
| Hash-based IDs (`[bd-xxxxxx]`) | **SILENT** → KEEP with HTML flag | steveyegge/beads pattern |
| Memory file update strategies | **SILENT** → KEEP with HTML flag | Cookbook design pattern |
| Conflict log template | **SILENT** → KEEP | mem0 pattern |
| manifest.yaml conflict_resolution config | **SILENT** → KEEP with HTML flag | Cookbook extension |
| VS Code Checkpoints for state recovery | **ADDITION** | VS Code docs (not for conflict resolution, but for state recovery) |
| Memory repository scope | **ADDITION** | GitHub docs |
| Memory cross-feature sharing | **ADDITION** | GitHub docs |

#### Corrections Applied

| Original | Corrected | Source |
|----------|-----------|--------|
| GitHub Copilot Memory section (brief) | Expanded with official quotes and citations | [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) |
| Self-healing pattern (no quote) | Added verified quote from GitHub Engineering Blog | [GitHub Blog](https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/) |

#### Additions Made

| Addition | Source |
|----------|--------|
| Platform Note at top clarifying community vs official patterns | N/A (synthesis) |
| VS Code Checkpoints for State Recovery section | [VS Code Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) |
| Memory Scope subsection (repository-specific, cross-feature, opt-in) | [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) |
| Official Documentation section in Sources | Multiple GitHub/VS Code docs |
| HTML comments flagging 6 community patterns | N/A (synthesis) |

#### Excerpts from Official Docs

> "Each memory that Copilot generates is stored with citations. These are references to specific code locations that support the memory. When Copilot finds a memory that relates to the work it is doing, it checks the citations against the current codebase to validate that the information is still accurate and is relevant to the current branch. The memory is only used if it is successfully validated."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#how-memories-are-stored-retained-and-used)

> "To avoid stale memories being retained, resulting in outdated information adversely affecting Copilot's decision making, memories are automatically deleted after 28 days. If a memory is validated and used by Copilot, then a new memory with the same details may be stored, which increases the longevity of that memory."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#how-memories-are-stored-retained-and-used)

> "Across 100 diverse sessions, agents consistently verified citations, discovered contradictions, and updated incorrect memories. The memory pool self-healed as agents stored corrected versions of outdated memories."
> — [GitHub Engineering Blog](https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/)

> "Use chat checkpoints to restore all files to a previous state, or redo edits after they have been reverted. A checkpoint is created after each accepted chat request."
> — [VS Code Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)

> "Checkpoints are designed for quick iteration within a chat session and are temporary. They complement Git but don't replace it."
> — [VS Code Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)

#### Sources Consulted

- https://docs.github.com/en/copilot/concepts/agents/copilot-memory
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/copilot-memory
- https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/
- https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/chat/review-code-edits
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/agents/background-agents
- https://modelcontextprotocol.io/docs/concepts/architecture

---

### 34. session-handoff.md (CONTEXT-MEMORY)

**Topic:** Session handoff, persistence, and context transfer between sessions

**Status:** ✅ Complete (2026-01-26)

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| VS Code 1.108+ provides native chat session history | CONFIRMED | VS Code docs |
| Session history workspace-scoped | CONFIRMED | VS Code docs |
| History NOT portable across machines | **SILENT** → flagged but implicit in "workspace-scoped" | — |
| Project-portable history closed as out-of-scope | **SILENT** → community discussion only | GitHub Issues |
| Agent Sessions View - centralized view | CONFIRMED | VS Code docs |
| Session Types: Local, Background, Cloud | CONFIRMED | VS Code docs |
| Fourth session type: Third-party agents | **ADDED** | VS Code docs |
| Session History allows return to previous conversations | CONFIRMED | VS Code docs |
| Export to JSON: `Chat: Export Chat...` | CONFIRMED | VS Code docs |
| Export to Prompt: `/savePrompt` | CONFIRMED | VS Code docs |
| Sessions stored in `workspaceStorage/.../chatSessions/` | **SILENT** → flagged | — |
| Copilot Memory - repository-level persistence | CONFIRMED | GitHub docs |
| Copilot Memory has 28-day retention | CONFIRMED | GitHub docs |
| Copilot Memory is cross-agent | CONFIRMED | GitHub docs |
| Copilot Memory validates with citations | CONFIRMED | GitHub docs |
| Copilot Memory requires opt-in in repository settings | **CORRECTED** → user-based opt-in, not repository | GitHub docs |
| Copilot Memory NOT in VS Code Chat yet | CONFIRMED | GitHub docs |
| Hooks `sessionStart` and `sessionEnd` | CONFIRMED | GitHub docs |
| Hooks support `type: command` with bash/powershell | CONFIRMED | GitHub docs |
| Six hook types total | **ADDED** | GitHub docs |
| Hooks stored in `.github/hooks/*.json` | CONFIRMED | GitHub docs |
| Context auto-summarization when window fills | CONFIRMED | VS Code docs |
| Official term is "stale context" | CONFIRMED | VS Code Context Engineering Guide |
| `.github/memory-bank/` pattern | **SILENT** → community pattern | Cline Memory Bank |
| `_active.md` session state file | **SILENT** → community pattern | roo-framework |
| Native handoffs via Continue In, @cli, @cloud | **ADDED** | VS Code docs |
| Subagents for context-isolated delegation | **ADDED** | VS Code docs |
| Context isolation recommendation | **ADDED** | VS Code Context Engineering Guide |

#### Excerpts from Official Docs

> "VS Code maintains the history of your chat sessions, allowing you to return to previous conversations at any time... **The list is scoped to your current workspace.**"
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_chat-session-history)

> "Run the `Chat: Export Chat...` command from the Command Palette... Exporting a chat session creates a JSON file that contains all prompts and responses from the session."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_export-a-chat-session-as-a-json-file)

> "Type `/savePrompt` in the chat input box and press Enter. The command creates a `.prompt.md` file that generalizes your current chat conversation into a reusable prompt."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_save-a-chat-session-as-a-reusable-prompt)

> "The Chat view provides a unified view to manage all your agent sessions, regardless of where they run."
> — [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview#_agent-sessions-list)

> "VS Code supports four main categories of agents... Local agents... Background agents... Cloud agents... Third party agents"
> — [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview#_types-of-agents)

> "Copilot can develop a persistent understanding of a repository by storing 'memories.'... **memories are automatically deleted after 28 days.**"
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#how-memories-are-stored-retained-and-used)

> "Currently Copilot Memory is used by **Copilot coding agent** and **Copilot code review** when these features are working on pull requests on the GitHub website, and by **Copilot CLI**."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#where-is-copilot-memory-used)

> "The ability to use Copilot Memory is **granted to users**, rather than being enabled for repositories."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#about-enabling-copilot-memory)

> "Copilot agents support hooks stored in JSON files in your repository at `.github/hooks/*.json`."
> — [GitHub Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks)

> "The following types of hooks are available: sessionStart, sessionEnd, userPromptSubmitted, preToolUse, postToolUse, errorOccurred"
> — [GitHub Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks#types-of-hooks)

> "You can hand off (or delegate) an existing task from one agent to another agent... Use the Continue In control in the Chat view, or type `@cli`, or `@cloud` in your prompt to pass the task to another agent type."
> — [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview#_hand-off-a-session-to-another-agent)

> "Keep context fresh: Regularly audit and update your project documentation (using the agent) as the codebase evolves. **Stale context** leads to outdated or incorrect suggestions."
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide#_context-management-principles)

> "Maintain context isolation: Keep different types of work (planning, coding, testing, debugging) in separate chat sessions to prevent context mixing and confusion."
> — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

> "If your conversation exceeds the coding agent's context window, VS Code automatically summarizes and condenses the information to fit the window."
> — [VS Code 1.105 Release Notes](https://code.visualstudio.com/updates/v1_105#_delegating-to-remote-coding-agents)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/agents/overview
- https://code.visualstudio.com/docs/copilot/agents/background-agents
- https://code.visualstudio.com/docs/copilot/agents/cloud-agents
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features
- https://code.visualstudio.com/updates/v1_108
- https://code.visualstudio.com/updates/v1_105
- https://code.visualstudio.com/updates/v1_101
- https://docs.github.com/en/copilot/concepts/agents/copilot-memory
- https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks

---

### 35. telos-goals.md (CONTEXT-MEMORY)

**Topic:** TELOS goal framework for AI agent purpose capture

**Status:** ✅ Complete (2026-01-26)

**Note:** TELOS is an **external community framework** from danielmiessler, not a VS Code feature. The cookbook file documents this pattern with clear attribution.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| TELOS framework for AI agents | **SILENT** — External framework, not VS Code | danielmiessler/Telos |
| `.github/copilot/USER/TELOS/` location | **SILENT** — Not an official VS Code path | Cookbook adaptation |
| `.github/copilot/goals/` location | **SILENT** — Not an official VS Code path | Cookbook adaptation |
| TELOS-Lite 5-file variant | **SILENT** — Cookbook-defined simplification | Cookbook pattern |
| FROZEN tier integration | **SILENT** — Cline community concept | Cline Memory Bank |
| Memory bank files (projectbrief.md, etc.) | **SILENT** — Cline community pattern | Cline Memory Bank |
| Custom agent `description` field | **CONFIRMED** — Official VS Code frontmatter | VS Code docs |
| Agent Skills (`SKILL.md`) | **CONFIRMED** — Official VS Code feature (preview) | VS Code docs |
| Prompt Files (`.prompt.md`) | **CONFIRMED** — Official VS Code feature | VS Code docs |
| AGENTS.md at workspace root | **CONFIRMED** — Official VS Code feature | VS Code docs |
| GitHub Copilot Memory | **CONFIRMED** — Official persistent memory | GitHub docs |
| Handoffs between agents | **CONFIRMED** — Official workflow feature | VS Code docs |

#### Additions Made

| Addition | Source | Why Relevant |
|----------|--------|--------------|
| VS Code Native Alternatives section | VS Code docs | Documents official features that can serve similar purposes to TELOS |
| GitHub Copilot Memory quote | GitHub docs | Official persistent memory feature as alternative |
| Official documentation links in Sources | VS Code/GitHub docs | Provides authoritative references |

#### Excerpts from Official Docs

> "Custom agents are defined in a `.agent.md` Markdown file... you can create the custom agent definition file in the `.github/agents` folder of your workspace."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

> "Agent Skills are folders of instructions, scripts, and resources that GitHub Copilot can load when relevant to perform specialized tasks."
> — [VS Code Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)

> "Prompt files are Markdown files that define reusable prompts for common development tasks... stored in the `.github/prompts` folder of the workspace."
> — [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files)

> "If you work with multiple AI agents in your workspace, you can define custom instructions for all agents in an `AGENTS.md` Markdown file at the root(s) of the workspace."
> — [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)

> "Copilot can develop a persistent understanding of a repository by storing 'memories.' Memories are tightly scoped pieces of information about a repository, that are deduced by Copilot as it works on the repository."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

> "Handoffs enable you to create guided sequential workflows that transition between agents... for example: Planning → Implementation."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/agent-skills
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/updates/v1_108
- https://code.visualstudio.com/updates/v1_107
- https://code.visualstudio.com/updates/v1_104
- https://docs.github.com/en/copilot/concepts/agents/copilot-memory
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/copilot-memory
- https://github.com/danielmiessler/Telos
- https://github.com/danielmiessler/Personal_AI_Infrastructure

---

### 36. permission-levels.md (CHECKPOINTS)

**Topic:** Permission levels for agent actions, tool approval settings

**Status:** ✅ Complete (2026-01-26)

**Note:** Combines official VS Code tool approval settings with Claude Code permission patterns. File updated with Platform Notes clarifying which features belong to which platform.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| 4-Level model (Always Deny/Ask/Ask Once/Auto) | **SILENT** — Design pattern, not official terminology | Cookbook/community |
| `chat.tools.terminal.autoApprove` object format | **CONFIRMED** | VS Code docs |
| Regex patterns in `/` characters | **CONFIRMED** | VS Code docs |
| `chat.tools.terminal.autoApproveWorkspaceNpmScripts` | **CONFIRMED** | VS Code 1.108 |
| `chat.tools.global.autoApprove` | **CONFIRMED** | VS Code docs |
| `chat.tools.eligibleForAutoApproval` | **CONFIRMED** | VS Code docs (experimental) |
| VS Code 1.108+ default auto-approve rules | **CORRECTED** — Updated to exact list | VS Code 1.108 |
| Approval scopes (Session/Workspace/User) | **CONFIRMED** | VS Code docs |
| `permissions:` frontmatter field | **SILENT** — Claude Code syntax, not VS Code | Claude Code docs |
| Permission modes (acceptEdits, bypassPermissions) | **SILENT** — Claude Code modes | Claude Code docs |
| Pattern syntax (Bash(), Read, Write, etc.) | **SILENT** — Claude Code format | Claude Code docs |
| Protection level markers (!cp, !cg, etc.) | **SILENT** — CursorRIPER.sigma pattern | CursorRIPER |

#### Corrections Applied

| Was | Now | Source |
|-----|-----|--------|
| Default rules: "git status, git diff, git log, git ls-files, rg, sed" | Exact list: `git ls-files`, `git --no-pager <safe_subcommand>`, `git -C <dir>`, `rg`, `sed`, `Out-String` + npm scripts | VS Code 1.108 |
| Missing settings | Added: `enableAutoApprove`, `ignoreDefaultAutoApproveRules`, `blockDetectedFileWrites`, `urls.autoApprove`, `preventShellHistory` | VS Code docs |
| `permissions:` shown as VS Code feature | Flagged with Platform Note as Claude Code syntax | Claude Code docs |
| Permission modes shown as general | Added Platform column showing Claude Code origin | Claude Code docs |
| Pattern syntax shown as general | Added "VS Code Equivalent Patterns" section | VS Code docs |

#### Additions Made

| Addition | Source | Why Relevant |
|----------|--------|--------------|
| Platform Note at top | Validation | Clarifies design pattern vs native feature |
| `chat.tools.terminal.enableAutoApprove` setting | VS Code docs | Master toggle (ORG controllable) |
| `chat.tools.terminal.ignoreDefaultAutoApproveRules` | VS Code docs | Full control over rules |
| `chat.tools.terminal.blockDetectedFileWrites` | VS Code docs | Protection for file writes |
| `chat.tools.urls.autoApprove` | VS Code docs | URL approval control |
| `chat.tools.terminal.preventShellHistory` | VS Code 1.108 | Privacy feature |
| Default deny list | VS Code settings | rm, rmdir, del, kill, curl, wget, eval, chmod, chown |
| "Chat: Reset Tool Confirmations" command | VS Code docs | Manage approvals |
| Trust boundaries section | VS Code security docs | Workspace/Extension/MCP/Network |
| Single Use approval scope | VS Code docs | Was missing from scopes table |
| VS Code Equivalent Patterns section | VS Code docs | Native settings.json approach |
| Expanded Sources section | Various | Official vs community sources |

#### Excerpts from Official Docs

> "Set commands to `true` to automatically approve them. Set commands to `false` to always require approval. Use regular expressions by wrapping patterns in `/` characters."
> — [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools#_automatically-approve-terminal-commands)

> "You can approve the tool for a single use, for the current session, for the current workspace, or for all future invocations."
> — [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools#_tool-approval)

> "To allow all tools and terminal commands to run without prompting for user confirmation, enable the `chat.tools.global.autoApprove` setting. This setting applies globally across all your workspaces!"
> — [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools#_can-i-automatically-approve-all-tools-and-terminal-commands)

> "chat.tools.terminal.autoApprove: Control which terminal commands are auto-approved when using agents. Commands can be set to `true` (auto-approve) or `false` (require approval). Default: `{ "rm": false, "rmdir": false, "del": false, "kill": false, "curl": false, "wget": false, "eval": false, "chmod": false, "chown": false, "/^Remove-Item\\b/i": false }`"
> — [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_agent-settings)

> "npm scripts run through `npm`, `pnpm` or `yarn` are now auto approved by default when they are included within the `package.json`. This can be disabled with `chat.tools.terminal.autoApproveWorkspaceNpmScripts`."
> — [VS Code 1.108 Release Notes](https://code.visualstudio.com/updates/v1_108#_terminal-tool-auto-approve-default-rules)

> "VS Code defines multiple trust boundaries: workspace, extension publisher, MCP server, and network domain. Users need to explicitly consent to certain actions and permissions before they are considered trusted."
> — [VS Code Security](https://code.visualstudio.com/docs/copilot/security#_trust-boundaries)

> "VS Code uses a permission-based security model where you maintain control over potentially risky operations... you can grant at different scopes: session-level for temporary access, workspace-level for project-specific trust, or user-level for broader permissions."
> — [VS Code Security](https://code.visualstudio.com/docs/copilot/security#_permission-management)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/security
- https://code.visualstudio.com/updates/v1_108
- https://docs.github.com/en/copilot/customizing-copilot
- https://docs.github.com/en/copilot/reference/custom-agents-configuration
- https://code.claude.com/docs/en/settings (for Claude Code comparison)

#### Sources Consulted

*(URLs read during validation)*

---

### 37. destructive-ops.md (CHECKPOINTS)

**Topic:** Destructive operations detection, terminal auto-approval, hooks

**Status:** ✅ Complete (2026-01-26)

**Note:** Combines official VS Code terminal settings with GitHub Copilot hooks and multi-platform permission patterns. File updated with corrected hook blocking mechanism and expanded settings.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `chat.tools.terminal.autoApprove` object syntax | **CONFIRMED** | VS Code docs |
| `chat.tools.terminal.enableAutoApprove` boolean | **CONFIRMED** | VS Code docs |
| `chat.tools.terminal.blockDetectedFileWrites` with "outsideWorkspace" | **CONFIRMED** | VS Code docs |
| `chat.tools.terminal.autoApproveWorkspaceNpmScripts` | **CONFIRMED** | VS Code 1.108 |
| Regex syntax `/^pattern/flags` | **CONFIRMED** | VS Code docs |
| `files.exclude` prevents agent access | **CORRECTED** → Excludes from workspace index | VS Code workspace context |
| Hooks at `.github/hooks/*.json` | **CONFIRMED** | GitHub docs |
| Exit code 2 for blocking | **CONTRADICTED** → Uses JSON `permissionDecision` output | GitHub docs |
| `preToolUse` and `postToolUse` hooks | **CONFIRMED** | GitHub docs |
| `timeoutSec` option (default 30) | **CONFIRMED** | GitHub docs |
| Detection categories table | **SILENT** — Cookbook design pattern | Cookbook |
| Four-tier permission model (Level 0-3) | **SILENT** — Cookbook design pattern | Cookbook |

#### Corrections Applied

| Was | Now | Source |
|-----|-----|--------|
| Exit code 2 blocks operations | JSON output `{"permissionDecision":"deny"}` blocks | GitHub hooks docs |
| Security check script used exit code 2 | Uses JSON output with `permissionDecision` | GitHub hooks docs |
| `files.exclude` hides from UI but doesn't prevent access | `files.exclude` excludes from workspace index | VS Code workspace context |
| hooks.json specific filename | Any `.json` filename in `.github/hooks/` | GitHub docs |

#### Additions Made

| Addition | Source | Why Relevant |
|----------|--------|--------------|
| `chat.tools.terminal.ignoreDefaultAutoApproveRules` | VS Code docs | Control over default rules |
| `chat.tools.terminal.preventShellHistory` | VS Code 1.108 | Privacy feature |
| Additional Security Settings table | VS Code docs | `edits.autoApprove`, `global.autoApprove`, etc. |
| Available Hook Types table | GitHub docs | 6 types: preToolUse, postToolUse, sessionStart, sessionEnd, userPromptSubmitted, errorOccurred |
| Hook location note (user-level `~/.github/hooks/`) | GitHub docs | Multi-level hook config |
| Hook Output Format section | GitHub docs | Correct blocking mechanism |
| `permissionDecision` field values | GitHub docs | allow, deny, ask (only deny processed) |
| `permissionDecisionReason` field | GitHub docs | Human-readable blocking reason |

#### Excerpts from Official Docs

> "chat.tools.terminal.autoApprove - Control which terminal commands are auto-approved when using agents. Commands can be set to `true` (auto-approve) or `false` (require approval). Regular expressions can be used by wrapping patterns in `/` characters."
> — [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_agent-settings)

> "chat.tools.terminal.blockDetectedFileWrites - (Experimental) Require user approval for terminal commands that perform file writes. Default: `outsideWorkspace`"
> — [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_agent-settings)

> "The workspace index also excludes any files that are excluded from VS Code using the `files.exclude` setting or that are part of the `.gitignore` file."
> — [VS Code Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context#_what-content-is-included-in-the-workspace-index)

> "Copilot agents support hooks stored in JSON files in your repository at `.github/hooks/*.json`."
> — [GitHub Hooks Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks)

> "preToolUse: Executed before the agent uses any tool (such as `bash`, `edit`, `view`). This is the most powerful hook as it can approve or deny tool executions."
> — [GitHub Hooks Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks)

> "Output fields: `permissionDecision`: Either `"allow"`, `"deny"`, or `"ask"` (only `"deny"` is currently processed)"
> — [GitHub Hooks Configuration](https://docs.github.com/en/copilot/reference/hooks-configuration#pre-tool-use-hook)

> "npm scripts run through `npm`, `pnpm` or `yarn` are now auto approved by default when they are included within the `package.json`. This can be disabled with `chat.tools.terminal.autoApproveWorkspaceNpmScripts`."
> — [VS Code 1.108 Release Notes](https://code.visualstudio.com/updates/v1_108)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/reference/workspace-context
- https://code.visualstudio.com/docs/copilot/security
- https://code.visualstudio.com/updates/v1_108
- https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks
- https://docs.github.com/en/copilot/reference/hooks-configuration
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/use-hooks

---

### 38. escalation-tree.md (CHECKPOINTS)

**Topic:** Escalation decision flow, hooks, stop conditions, retry patterns, agent transitions

**Status:** ✅ Complete (2026-01-26)

**Note:** Combines confirmed GitHub Copilot Hooks with community-derived design patterns. The decision flowchart, severity mapping, retry configuration, and YAML frontmatter schema are cookbook design patterns, not native VS Code features. File updated with Platform Notes, HTML comments for SILENT claims, and native VS Code alternatives.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `preToolUse`, `postToolUse`, `errorOccurred` hooks | **CONFIRMED** | GitHub docs |
| 6 hook types (sessionStart, sessionEnd, userPromptSubmitted, preToolUse, postToolUse, errorOccurred) | **CONFIRMED** | GitHub docs |
| Hooks at `.github/hooks/*.json` | **CONFIRMED** | GitHub docs |
| `chat.agent.maxRequests` default 50 | **CORRECTED** → Default is 25 | VS Code docs |
| `checkpoints:` YAML frontmatter field | **SILENT** → flagged as design pattern | Not in official docs |
| `escalation:` YAML frontmatter field | **SILENT** → flagged as design pattern | Not in official docs |
| `fallback_agent` field | **SILENT** → flagged as design pattern | Not in official docs |
| `confidence_threshold` setting | **SILENT** → flagged as design pattern | Not in official docs |
| Red Flags stop conditions terminology | **SILENT** → flagged as community pattern | Not in official docs |
| Severity-to-action mapping | **SILENT** → flagged as cookbook pattern | Not in official docs |
| Retry configuration with exponential backoff | **SILENT** → flagged as design pattern | Not in official docs |
| Error handling modes (terminated, continue-on-error) | **SILENT** → flagged as Dify feature | Not in VS Code docs |
| Workflow states (RUNNING, SUCCEEDED, etc.) | **SILENT** → flagged as Dify concept | Not in VS Code docs |

#### Corrections Applied

| Was | Now | Source |
|-----|-----|--------|
| `chat.agent.maxRequests` default 50 | Default is **25** | VS Code settings reference |
| 3 hook types listed | 6 hook types documented | GitHub hooks docs |

#### Additions Made

| Addition | Source | Why Relevant |
|----------|--------|--------------|
| Session End Reasons table (complete, error, abort, timeout, user_exit) | GitHub hooks docs | Official error classification |
| VS Code native `chat.tools.terminal.autoApprove` for stop conditions | VS Code docs | Alternative to "Red Flags" pattern |
| `handoffs` as native alternative to `escalation:` field | VS Code custom agents docs | Official agent transition mechanism |
| Platform Note explaining source origins | Multiple | Clarity on what's official vs community |

#### Excerpts from Official Docs

> "The following types of hooks are available: sessionStart, sessionEnd, userPromptSubmitted, preToolUse, postToolUse, errorOccurred"
> — [GitHub Hooks Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks#types-of-hooks)

> "preToolUse: Executed before the agent uses any tool (such as `bash`, `edit`, `view`). This is the most powerful hook as it can approve or deny tool executions."
> — [GitHub Hooks Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks#types-of-hooks)

> "chat.agent.maxRequests: Maximum number of requests that Copilot can make using agents. Default: 25"
> — [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_agent-settings)

> "chat.tools.terminal.autoApprove: Control which terminal commands are auto-approved when using agents. Default: { 'rm': false, 'rmdir': false, 'del': false, 'kill': false, 'curl': false, 'wget': false, 'eval': false, 'chmod': false, 'chown': false }"
> — [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_agent-settings)

> "Handoffs enable you to create guided sequential workflows that transition between agents with suggested next steps."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs)

> "When checkpoints are enabled, VS Code automatically creates snapshots of your files at key points during chat interactions"
> — [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints
- https://code.visualstudio.com/docs/copilot/agents/overview
- https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks
- https://docs.github.com/en/copilot/reference/hooks-configuration
- https://modelcontextprotocol.io/specification/2025-11-25/server/tools

---

### 39. approval-gates.md (CHECKPOINTS)

**Topic:** Approval gates for human review checkpoints, tool approval settings, native VS Code permissions

**Status:** ✅ Complete (2026-01-26)

**Note:** File extensively updated to reflect native VS Code approval mechanisms. Setting names corrected, dialog options updated, new settings added. The `checkpoints:` and `escalation:` YAML frontmatter schema remains documented as a community design pattern with clear Platform Note.

#### Key Findings

| Claim | Result | Source |
|-------|--------|--------|
| `chat.tools.autoApprove` setting | **CORRECTED** → `chat.tools.global.autoApprove` | VS Code settings reference |
| `chat.tools.terminal.autoApprove` is array | **CORRECTED** → Object format with true/false values | VS Code settings reference |
| Dialog options: "Allow this session", "Allow in workspace", "Always allow", "Deny" | **CORRECTED** → "Single use", "Allow in this session", "Allow in this workspace", "Always allow", "Trust all tools for server/extension" (v1.106+) | VS Code chat tools docs |
| `handoffs:` with `send: false` creates review checkpoint | **CONFIRMED** | VS Code custom agents docs |
| `files.exclude` affects Copilot workspace index | **CONFIRMED** | VS Code workspace context docs |
| `checkpoints:` YAML frontmatter field | **CONFIRMED ABSENT** → flagged as design pattern | Not in official schema |
| `escalation:` YAML frontmatter field | **CONFIRMED ABSENT** → flagged as design pattern | Not in official schema |

#### Corrections Applied

| Was | Now | Source |
|-----|-----|--------|
| `chat.tools.autoApprove` | `chat.tools.global.autoApprove` | VS Code settings reference |
| Terminal auto-approve as array `["npm test", ...]` | Object format `{ "npm test": true, "rm": false }` | VS Code settings reference |
| Dialog: "Allow this session", "Allow in workspace", "Always allow", "Deny" | "Single use", "Allow in this session", "Allow in this workspace", "Always allow", "Trust all tools for server/extension" | VS Code chat tools docs |
| No regex support mentioned | Regex patterns supported in `/` delimiters | VS Code settings reference |

#### Additions Made

| Addition | Source | Why Relevant |
|----------|--------|--------------|
| `chat.tools.terminal.blockDetectedFileWrites` setting (experimental) | VS Code settings | File write protection via terminal |
| `chat.tools.edits.autoApprove` with glob patterns | VS Code review-code-edits docs | Sensitive file protection |
| `chat.tools.urls.autoApprove` setting | VS Code chat tools docs | URL request/response approval |
| `Chat: Reset Tool Confirmations` command | VS Code chat tools docs | Reset all saved approvals |
| `Chat: Manage Tool Approval` command | VS Code v1.106 updates | Manage pre/post-approval |
| Native Chat Checkpoints section | VS Code chat checkpoints docs | `chat.checkpoints.enabled` feature |
| "Trust all tools for server/extension" option (v1.106) | VS Code v1.106 updates | Bulk MCP server approval |
| `chat.checkpoints.showFileChanges` setting | VS Code settings reference | Show file changes at checkpoints |

#### Conflicts

| Claim | Opus Says | Gemini Says | Resolution |
|-------|-----------|-------------|------------|
| Setting name: `chat.tools.autoApprove` vs `chat.tools.global.autoApprove` | `chat.tools.global.autoApprove` (VS Code settings ref) | `chat.tools.autoApprove` (MS Learn SQL docs) | Using VS Code settings reference as authoritative — `chat.tools.global.autoApprove` |

#### Excerpts from Official Docs

> "chat.tools.global.autoApprove: Automatically approve all tools - this setting disables critical security protections."
> — [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_agent-settings)

> "chat.tools.terminal.autoApprove: Control which terminal commands are auto-approved when using agents. Commands can be set to `true` (auto-approve) or `false` (require approval). Regular expressions can be used by wrapping patterns in `/` characters."
> — [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_agent-settings)

> "When a tool requires approval, a confirmation dialog appears showing the tool details. Review the information carefully before approving the tool. You can approve the tool for a single use, for the current session, for the current workspace, or for all future invocations."
> — [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools#_tool-approval)

> "handoffs.send: Optional boolean flag to auto-submit the prompt (default is `false`)"
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs)

> "The workspace index also excludes any files that are excluded from VS Code using the files.exclude setting or that are part of the .gitignore file."
> — [VS Code Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context#_what-content-is-included-in-the-workspace-index)

> "chat.checkpoints.enabled: Enable or disable checkpoints in the chat. Default: true"
> — [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_chat-settings)

#### Sources Consulted

- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints
- https://code.visualstudio.com/docs/copilot/chat/review-code-edits
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/reference/workspace-context
- https://code.visualstudio.com/docs/copilot/security
- https://code.visualstudio.com/updates/v1_106
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli

---

### 40. four-modes.md (RED-TEAM)

**Topic:** Four modes of agent critique

**Status:** ⏳ Pending

**Note:** Community pattern, not official VS Code feature.

#### Key Findings

*(Populated during validation)*

#### Excerpts from Official Docs

*(Quoted text with source URLs added during validation)*

#### Sources Consulted

*(URLs read during validation)*

---

### 41. iron-law-verification.md (RED-TEAM)

**Topic:** Iron law verification methods

**Status:** ⏳ Pending

**Note:** Community pattern, not official VS Code feature.

#### Key Findings

*(Populated during validation)*

#### Excerpts from Official Docs

*(Quoted text with source URLs added during validation)*

#### Sources Consulted

*(URLs read during validation)*

---

### 42. critique-template.md (RED-TEAM)

**Topic:** Agent critique template

**Status:** ⏳ Pending

**Note:** Community pattern, not official VS Code feature.

#### Key Findings

*(Populated during validation)*

#### Excerpts from Official Docs

*(Quoted text with source URLs added during validation)*

#### Sources Consulted

*(URLs read during validation)*

---

### 43. keyboard-shortcuts.md (REFERENCE)

**Topic:** VS Code Copilot keyboard shortcuts

**Status:** ⏳ Pending

#### Key Findings

*(Populated during validation)*

#### Excerpts from Official Docs

*(Quoted text with source URLs added during validation)*

#### Sources Consulted

*(URLs read during validation)*

---

### 44. mcp-server-stacks.md (REFERENCE)

**Topic:** MCP server configurations and stacks

**Status:** ⏳ Pending

#### Key Findings

*(Populated during validation)*

#### Excerpts from Official Docs

*(Quoted text with source URLs added during validation)*

#### Sources Consulted

*(URLs read during validation)*

---

### 45. vision-capabilities.md (REFERENCE)

**Topic:** Vision/image capabilities in Copilot

**Status:** ⏳ Pending

#### Key Findings

*(Populated during validation)*

#### Excerpts from Official Docs

*(Quoted text with source URLs added during validation)*

#### Sources Consulted

*(URLs read during validation)*

---

### 46. collections-format.md (REFERENCE)

**Topic:** Collections format for organizing prompts

**Status:** ⏳ Pending

**Note:** May be preview/experimental feature.

#### Key Findings

*(Populated during validation)*

#### Excerpts from Official Docs

*(Quoted text with source URLs added during validation)*

#### Sources Consulted

*(URLs read during validation)*

---

### 47. spec-template.md (TEMPLATES)

**Topic:** Specification template structure

**Status:** ⏳ Pending

**Note:** Community template, not official VS Code feature.

#### Key Findings

*(Populated during validation)*

#### Excerpts from Official Docs

*(Quoted text with source URLs added during validation)*

#### Sources Consulted

*(URLs read during validation)*

---

### 48. validation-checklist.md (TEMPLATES)

**Topic:** Validation checklist template

**Status:** ⏳ Pending

**Note:** Community template, not official VS Code feature.

#### Key Findings

*(Populated during validation)*

#### Excerpts from Official Docs

*(Quoted text with source URLs added during validation)*

#### Sources Consulted

*(URLs read during validation)*

---

### 49. constitution-template.md (TEMPLATES)

**Topic:** Agent constitution template

**Status:** ⏳ Pending

**Note:** Community template, not official VS Code feature.

#### Key Findings

*(Populated during validation)*

#### Excerpts from Official Docs

*(Quoted text with source URLs added during validation)*

#### Sources Consulted

*(URLs read during validation)*

---

## Summary Statistics

| Metric | Count |
|--------|-------|
| Total files | 49 |
| Validated | 27 |
| With corrections | 25 |
| With additions | 26 |
| With silent flags | 80 |
| With conflicts | 2 |
| Pending | 24 |

**Last updated:** 2026-01-25
