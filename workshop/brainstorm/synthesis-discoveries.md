# Synthesis Discoveries

> **Purpose:** Capture improvements, ideas, and inconsistencies discovered during GENERATION-RULES synthesis.
> **Updated:** 2026-01-28
> **Status:** ✅ SYNTHESIS COMPLETE — Final checkpoint passed 2026-01-28

---

## 🔧 Agent Improvements

| Date | Agent | Discovery | Action |
|------|-------|-----------|--------|
| 2026-01-28 | @brain | Subagent synthesis works well with parallel spawning for independent analyses | Keep pattern |
| 2026-01-28 | @brain | Low complexity synthesis (2 sources) completes efficiently in 3 iterations | Validate iteration estimates |
| 2026-01-28 | @brain | High complexity synthesis (5 sources + all GENERATION-RULES) completes in 8 iterations with critique | Validates iteration estimates |
| 2026-01-28 | @brain | Parallel subagent spawning for independent workflow analyses (4 at once) significantly speeds synthesis | Keep pattern for future high-complexity tasks |

---

## ✨ New Agent Ideas

| Date | Idea | Rationale | Priority |
|------|------|-----------|----------|
| | | | |

---

## 📝 Pattern Refinements

| Date | Pattern | Current | Proposed | Why |
|------|---------|---------|----------|-----|
| 2026-01-28 | Component selection | Needs → single component | Dominant characteristic + composition | Components combine; mutual exclusivity is false |
| 2026-01-28 | User entry templates | Copy spec-template as entry point | Minimal template with optional expansion | spec-template is Generator-facing; users need INVERSE (minimal → expanded) |
| 2026-01-28 | Validation placement | End-of-form checklist | Inline hints after each field | Users skip end-of-form checklists; inline tips prevent errors at source |
| 2026-01-28 | Uncertainty handling | Require all answers | Allow "I don't know" escape hatches | Exploratory users can't articulate problem upfront; interviewer handles discovery |
| 2026-01-28 | Workflow model | 5-mode RIPER or 4-phase spec-driven or 3-phase R→P→I | Custom 4-stage (PREPARE→COLLECT→COMPOSE→VALIDATE) | Balances granularity, human gates, and generator simplicity |
| 2026-01-28 | Validation timing | End-of-workflow checklist | Critique iteration found "validation-at-end fallacy" — added RE-COMPOSE loop | Linear flows fail on first error; need iteration |
| 2026-01-28 | Human gates | Implicit in phase model | Explicit SCOPE_GATE and DELIVERY_GATE | Gates evaporate if not explicit; critique C1 |

---

## ⚠️ Inconsistencies Found

| Date | File 1 | File 2 | Conflict | Resolution |
|------|--------|--------|----------|------------|
| 2026-01-28 | skills-format.md | agent-file-format.md | Both claim tool config (`allowed-tools` vs `tools:`) | `tools:` supported in VS Code; `allowed-tools` experimental/not supported |
| 2026-01-28 | skills-format.md | (self) | "15+ platforms" claim vs actual ~7-8 documented | Flagged in source comment; used actual count |
| 2026-01-28 | skills-format.md | collections-format.md | Path formats differ (`.github/skills/` vs `skills/`) | Context-dependent: project uses `.github/`, awesome-copilot uses root |
| 2026-01-28 | instruction-files.md | constraint-hierarchy.md | Hierarchy described as "precedence" vs "design pattern" | Design pattern only; platform doesn't enforce |
| 2026-01-28 | mcp-servers.md | agent-file-format.md | `mcp-servers:` in agent frontmatter scope | Only works at org/enterprise level, NOT repository agents — documented in anti-patterns |
| 2026-01-28 | mcp-server-stacks.md | (community) | <10 servers, <80 tools "limits" | Community guidelines only — 128 tools is only verified hard limit |
| 2026-01-28 | memory-bank-files.md | memory-bank-schema.md | `activeContext.md` vs `_active.md` naming | Different purposes: `activeContext.md` = project focus, `_active.md` = session state |
| 2026-01-28 | tiered-memory.md | official docs | Utilization thresholds (40-60%) | Community guidelines from HumanLayer ACE, not official |
| 2026-01-28 | telos-goals.md | VS Code discovery | TELOS paths not auto-discovered | Requires explicit `#file` loading — noted as advanced extension |
| 2026-01-28 | context-quality.md | utilization-targets.md | "Include if uncertain" vs "stay at 40-60%" | Resolved: Include applies to initial decisions; compaction manages utilization |
| 2026-01-28 | verification-gates.md | (community) | Coverage thresholds (80%/100%) claimed as standard | VS Code reports coverage but doesn't mandate; framed as industry guidelines |
| 2026-01-28 | checkpoint sources | VS Code | `checkpoints:` YAML frontmatter | NOT native VS Code — proposed pattern only; implement via settings + instructions |
| 2026-01-28 | checkpoint sources | VS Code | `escalation:` YAML frontmatter | NOT native — use `handoffs:` field instead |
| 2026-01-28 | permission-levels.md | Claude Code | Permission syntax divergence | VS Code uses `autoApprove` object; Claude uses `permissions: allow/deny/ask` |

---

## 💡 General Insights

- Decision flowcharts are more actionable than comprehensive matrices for 90% of use cases
- Composition patterns (what invokes what) is a critical missing dimension in most documentation
- "Guardrails/safety" use case needs explicit mapping — users often put them in wrong component type
- Skills need explicit error handling guidance — silent failures erode trust
- Cross-platform compatibility is often overlooked; must be addressed proactively
- agentskills.io is community-driven, not official — patterns should note source stability
- Priority hierarchy is social contract, not technical enforcement — users need explicit "LIMITATIONS" sections
- Self-contained instruction design trades DRY for reliability (no load order guarantee)
- **Prompt patterns:** Undefined variables render as literal strings (silent failure) — critical for generators to know
- **Prompt patterns:** `${selection}` = empty string if nothing selected — prompts must handle gracefully
- **Prompt patterns:** Spec says "optional" but generators need "recommended minimum" guidance — pattern files bridge this gap
- **MCP patterns:** 80% of users need 1-3 servers — lead with minimal config, progressive disclosure to advanced
- **MCP patterns:** `mcp-servers:` frontmatter only works at org/enterprise level — major "gotcha" for individual users
- **MCP patterns:** MCP servers run as external processes with NO VS Code API access — architectural boundary
- **Memory patterns:** File-based memory is community pattern (Cline) — VS Code has no native awareness; works via explicit agent instructions
- **Memory patterns:** "Prevents context exhaustion" is aspirational — no platform enforcement; reframe as "enables management"
- **Memory patterns:** Manual maintenance doesn't scale — design for infrequent global updates, frequent session updates
- **Memory patterns:** Precedence rule needed: file-based memory > Copilot Memory for intentional state (not inferred conventions)
- **Memory patterns:** Staleness is real risk — all memory files MUST have timestamps; consider periodic reconciliation checkpoints
- **Orchestration patterns:** Subagents are SYNCHRONOUS, not parallel — major misconception; true parallel requires background agents (v1.107+)
- **Orchestration patterns:** `escalation:` and `checkpoints:` are NOT native frontmatter — community patterns only; implement in instructions body
- **Orchestration patterns:** Agents can't reliably self-assess confidence — need explicit "UNCERTAIN:" markers or external signals
- **Orchestration patterns:** Memory bank writes are NOT guaranteed — critical state should be echoed in handoff prompt as backup
- **Orchestration patterns:** Hub-and-spoke is THE model, but orchestrator becomes single point of failure — circuit breaker pattern essential
- **Orchestration patterns:** Token tracking is aspirational (agents can't introspect) — reframe as heuristic triggers, not automated
- **Quality patterns:** "Include if uncertain" vs "stay at 40-60%" is NOT a contradiction — inclusion is for initial decisions, compaction manages utilization over time
- **Quality patterns:** Unenforceable MUSTs degrade trust — convert to SHOULDs or reserve MUST for verifiable conditions only
- **Quality patterns:** Tiered evidence requirements reduce friction — high-stakes = mandatory, routine = optional
- **Quality patterns:** Recovery protocols are essential — compaction can lose critical context; define re-derivation process
- **Quality patterns:** "Abstain on facts, disagree on judgments" provides clear bright-line rule for sycophancy vs pushback tension
- **Quality patterns:** Steel-man critique revealed over-specification risk — compliance theater without enforcement is worse than simple rules
- **Checkpoint patterns:** HARD GATES (settings) vs SOFT GUIDANCE (instructions) is THE critical distinction — users conflate them creating false security
- **Checkpoint patterns:** Pattern-based detection is bypassable — first defense, not complete solution. Semantic understanding not available.
- **Checkpoint patterns:** Prompt fatigue is real — too many checkpoints = users auto-approve, defeating purpose. Target <3 prompts/session.
- **Checkpoint patterns:** Subagent permissions ≤ parent permissions — principle of least privilege prevents escalation attacks
- **Checkpoint patterns:** Partial execution recovery missing — HALT mid-operation leaves inconsistent state; `chat.checkpoints.enabled` provides file-level rollback
- **Rules synthesis:** Critique iteration is HIGH VALUE — identified 19 challenges, led to 6 new decisions (D12-D17)
- **Rules synthesis:** "Design pattern vs enforcement" tension runs through everything — must be explicit about advisory nature
- **Rules synthesis:** TDD as Iron Law fails binary test ("what counts as tests?") — demoted to P2 project rule
- **Rules synthesis:** Recovery protocol (preserve → report → wait → resume) is essential — STOP without recovery = broken workflows
- **Rules synthesis:** Subagent inheritance of P1 constraints is core for meta-agentic framework — not edge case
- **Rules synthesis:** Rules apply to OUTCOMES not literal phrasing — prevents circumvention via rephrasing
- **Rules synthesis:** Runtime rule immutability prevents prompt injection — rules loaded at instantiation cannot be modified
