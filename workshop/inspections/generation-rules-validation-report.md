# GENERATION-RULES Validation Report

**Date:** 2026-01-28
**Validated Against:** `cookbook/REFERENCE/official-docs-reference.md`
**Official Sources:** VS Code Copilot Docs, GitHub Copilot Docs, MCP Specification

---

## Executive Summary

| Metric | Count |
|--------|-------|
| **Files Validated** | 38 |
| **Total Claims Analyzed** | ~300+ |
| **Critical Fixes Needed** | 8 |
| **Minor Fixes Needed** | 12 |
| **Settings Not Found** | 6 |
| **Unofficial but Acceptable** | ~60 (community patterns) |

### Verdict: **MOSTLY CORRECT** with targeted fixes needed

The GENERATION-RULES framework is well-designed with accurate VS Code primitives. Most issues are:
1. Outdated/deprecated setting names (3 locations)
2. Character limits using old 25K instead of official 30K (6 locations)
3. Missing fields from frontmatter examples
4. Terminal deny list incomplete (missing 4 commands)

**Validation Updated:** 2026-01-28 — Line numbers verified against actual files

---

## 🔴 Critical Fixes Required

These are incorrect claims that must be fixed:

### 1. Character Limit: 25K → 30K

| File | Location (Line) | Current | Should Be |
|------|-----------------|---------|-----------|
| [agent-checklist.md](../GENERATION-RULES/CHECKLISTS/agent-checklist.md#L133-L135) | CHECK_C001 (L133-135) | ≤25,000 chars | **≤30,000 chars** |
| [agent-checklist.md](../GENERATION-RULES/CHECKLISTS/agent-checklist.md#L158) | Human-readable (L158) | ≤25,000 chars | **≤30,000 chars** |
| [agent-patterns.md](../GENERATION-RULES/PATTERNS/agent-patterns.md#L296-L328) | RULE (L296-297, L328) | ≤25,000 chars | **≤30,000 chars** |
| [agent-patterns.md](../GENERATION-RULES/PATTERNS/agent-patterns.md#L490) | Quick ref (L490) | ≤25,000 chars | **≤30,000 chars** |
| [agent-skeleton.md](../GENERATION-RULES/TEMPLATES/agent-skeleton.md#L179) | Checklist (L179) | ≤25,000 chars | **≤30,000 chars** |
| [pre-generation-checklist.md](../GENERATION-RULES/CHECKLISTS/pre-generation-checklist.md#L172) | CHECK_CC001 (L172) | ≤25k chars | **≤30k chars** |

**Source:** [GitHub Custom Agents](https://docs.github.com/en/copilot/reference/custom-agents-configuration) — "The prompt can be a maximum of 30,000 characters."

---

### 2. Variable Syntax: `${currentFile}` → `${file}`

| File | Location (Line) | Current | Should Be |
|------|-----------------|---------|-----------|
| [prompt-checklist.md](../GENERATION-RULES/CHECKLISTS/prompt-checklist.md#L103) | CHECK_V001 (L103) | `${currentFile}` | **`${file}`** |

**Source:** [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) — Variable is `${file}`, not `${currentFile}`.

---

### 3. Setting Name: `chat.mcp.discovery.enabled` → `chat.mcp.gallery.enabled`

| File | Location (Line) | Current | Should Be |
|------|-----------------|---------|-----------|
| [mcp-patterns.md](../GENERATION-RULES/PATTERNS/mcp-patterns.md#L164) | Settings section (L164) | `chat.mcp.discovery.enabled` | **`chat.mcp.gallery.enabled`** |
| [SETTINGS.md](../GENERATION-RULES/SETTINGS.md#L238) | Discovery section (L238) | `chat.mcp.discovery.enabled` | **`chat.mcp.gallery.enabled`** |
| [SETTINGS.md](../GENERATION-RULES/SETTINGS.md#L247) | Table row (L247) | `chat.mcp.discovery.enabled` | **`chat.mcp.gallery.enabled`** |

**Source:** [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings)

---

### 4. Tool Alias: `agent` — Verify Status

| File | Location (Line) | Current | Note |
|------|-----------------|---------|------|
| [agent-patterns.md](../GENERATION-RULES/PATTERNS/agent-patterns.md#L177) | Tool aliases (L177) | `agent` alias | Listed as official — **VERIFY** if still valid |

**Note:** The official tool aliases documented are: `execute`, `read`, `edit`, `search`, `web`, `todo`. The `agent` alias may be `runSubagent` in newer docs. Verify against current VS Code version.

---

### 5. Terminal Deny List: Missing Commands

| File | Location (Line) | Missing Commands |
|------|-----------------|------------------|
| [checkpoint-patterns.md](../GENERATION-RULES/PATTERNS/checkpoint-patterns.md#L220-L230) | VS Code settings (L220-230) | `kill`, `chmod`, `chown`, `/^Remove-Item\b/i` |

**Note:** The file ALREADY has `eval` (L227). Report originally said it was missing — this was **incorrect**.

**Fix:** Add to `chat.tools.terminal.autoApprove`:
```json
{
  "kill": false,
  "chmod": false,
  "chown": false,
  "/^Remove-Item\\b/i": false
}
```

---

### 6. `maxRequests` Example: 50 → 25 (default)

| File | Location (Line) | Current | Should Be |
|------|-----------------|---------|-----------|
| [checkpoint-patterns.md](../GENERATION-RULES/PATTERNS/checkpoint-patterns.md#L542) | Example (L542) | `maxRequests: 50` | **`maxRequests: 25`** (official default) |

**Source:** [VS Code Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings) — Default is 25.

---

### 7. Skills Structure: Wrong Naming Convention

| File | Location (Line) | Current | Should Be |
|------|-----------------|---------|-----------|
| [skills/README.md](../GENERATION-RULES/_EXEMPLAR/skills/README.md#L15) | Naming (L15) | `{capability}.skill.md` | **`.github/skills/{name}/SKILL.md`** |
| [skills/README.md](../GENERATION-RULES/_EXEMPLAR/skills/README.md#L19-L21) | Examples (L19-21) | `git-workflow.skill.md` | **`.github/skills/git-workflow/SKILL.md`** |
| [skills/README.md](../GENERATION-RULES/_EXEMPLAR/skills/README.md#L27) | Structure (L27) | Only `description` | **`name` (required) + `description` (required)** |

**Source:** [VS Code Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) — Skills are **directories** with `SKILL.md`, not single files.

---

### 8. Prompt Frontmatter: `agent` + `description` Not Required

| File | Location (Line) | Current | Should Be |
|------|-----------------|---------|-----------|
| [prompt-checklist.md](../GENERATION-RULES/CHECKLISTS/prompt-checklist.md#L34-L35) | CHECK_S001 (L34-35) | "PASS_IF: Has `agent` AND `description`" | **Both are optional** |
| [prompt-checklist.md](../GENERATION-RULES/CHECKLISTS/prompt-checklist.md#L51) | Human-readable (L51) | "Frontmatter has `agent` + `description`" | **Remove "required" implication** |

**Source:** [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) — All fields optional.

---

## 🟡 Settings Not Found in Official Docs

These settings are referenced but not found in current VS Code documentation. They may be:
- Deprecated
- Renamed  
- Extension-specific (not core VS Code)
- Hidden/internal

| Setting | File | Action |
|---------|------|--------|
| `chat.tools.terminal.autoApproveWorkspaceNpmScripts` | SETTINGS.md | Verify or remove |
| `github.copilot.chat.anthropic.thinking.budgetTokens` | SETTINGS.md | May be internal — flag as unverified |
| `chat.restoreLastPanelSession` | SETTINGS.md | Not found — remove or verify |
| `github.copilot.chat.githubMcpServer.enabled` | SETTINGS.md | GitHub-specific, not VS Code — move to separate section |
| `github.copilot.chat.githubMcpServer.toolsets` | SETTINGS.md | GitHub-specific |
| `github.copilot.chat.githubMcpServer.readonly` | SETTINGS.md | GitHub-specific |

---

## 🟢 Minor Improvements

### Agent Skeleton Missing Optional Fields

| File | Missing Fields |
|------|----------------|
| [agent-skeleton.md](../GENERATION-RULES/TEMPLATES/agent-skeleton.md) | `argument-hint`, `infer`, `target`, `mcp-servers` |

**Fix:** Add commented examples for all optional fields.

---

### Reserved Names Inferred (Not Official)

| File | Names | Status |
|------|-------|--------|
| [NAMING.md](../GENERATION-RULES/NAMING.md) | `copilot`, `chat` | Inferred reserved — add note they're not explicitly documented |

---

### Instruction Field: `excludeAgent`

| File | Location (Line) | Field | Status |
|------|-----------------|-------|--------|
| [instruction-patterns.md](../GENERATION-RULES/PATTERNS/instruction-patterns.md#L114) | Frontmatter (L114) | `excludeAgent` | NOT in VS Code docs — verify or remove |
| [instruction-patterns.md](../GENERATION-RULES/PATTERNS/instruction-patterns.md#L127) | Table (L127) | `excludeAgent` | Listed as optional field |
| [instruction-skeleton.md](../GENERATION-RULES/TEMPLATES/instruction-skeleton.md#L105) | Generator hint (L105) | `excludeAgent` | Referenced in comment |

---

### Component Matrix: `allowed-tools` for Skills

| File | Claim | Status |
|------|-------|--------|
| [COMPONENT-MATRIX.md](../GENERATION-RULES/COMPONENT-MATRIX.md) | Skills have `allowed-tools` | Correctly flagged as experimental/not supported |

**Action:** Consider removing entirely if never implemented.

---

### Skills README: Missing Required Fields

| File | Current | Should Be |
|------|---------|-----------|
| [skills/README.md](../GENERATION-RULES/_EXEMPLAR/skills/README.md) | Only `description` shown | Both `name` (required) and `description` (required) |

---

### `github.copilot.enable` Default Differs

| File | Current | Official Default |
|------|---------|------------------|
| [SETTINGS.md](../GENERATION-RULES/SETTINGS.md) | `{ "*": true }` | `{ "*": true, "plaintext": false, "markdown": false, "scminput": false }` |

**Action:** Clarify this is a recommended override, not the default.

---

### Brain Agent: Unknown Tool

| File | Location (Line) | Tool | Status |
|------|-----------------|------|--------|
| [brain.agent.md](../GENERATION-RULES/_EXEMPLAR/agents/brain.agent.md#L4) | tools array (L4) | `vscode` | Not a documented tool alias — verify or remove |

---

## ✅ Confirmed Correct

These key claims were verified against official documentation:

| Category | Verified Items |
|----------|----------------|
| **File Extensions** | `.agent.md`, `.instructions.md`, `.prompt.md`, `SKILL.md`, `mcp.json` |
| **Locations** | `.github/agents/`, `.github/instructions/`, `.github/prompts/`, `.github/skills/` |
| **Built-in Participants** | `@workspace`, `@terminal`, `@vscode`, `@github`, `@azure` |
| **Built-in Agents** | Agent, Plan, Ask, Edit |
| **Tool Aliases** | `execute`, `read`, `edit`, `search`, `web`, `todo` |
| **Agent Fields** | `name`, `description`, `tools`, `model`, `argument-hint`, `infer`, `target`, `mcp-servers`, `handoffs` |
| **Skill Fields** | `name` (required), `description` (required) |
| **Settings** | `chat.tools.terminal.autoApprove`, `chat.tools.global.autoApprove`, `chat.agent.maxRequests`, `chat.checkpoints.enabled` |
| **Limits** | 128 tools/request, 30K chars prompt, ~1000 lines instructions, 64 chars skill name |

---

## ⚠️ Unofficial But Acceptable

These are community patterns correctly used without claiming official status:

| Pattern | Source | Files Using |
|---------|--------|-------------|
| Memory Bank (`.github/memory-bank/`) | Cline | memory-checklist.md, memory-patterns.md |
| Tiered Memory (HOT/WARM/COLD/FROZEN) | mem0/CrewAI | memory-checklist.md |
| Utilization Targets (40-60%) | HumanLayer ACE | general-quality-checklist.md |
| Iron Laws | obra/superpowers | security-checklist.md, RULES.md |
| Priority Stack | Community | RULES.md |
| Four Modes Review | Community | general-quality-checklist.md |

**Status:** These are correctly documented as framework conventions, not VS Code features.

---

## Validation Sources

| Source | URL | Used For |
|--------|-----|----------|
| VS Code Custom Agents | https://code.visualstudio.com/docs/copilot/customization/custom-agents | Agent fields, structure |
| VS Code Custom Instructions | https://code.visualstudio.com/docs/copilot/customization/custom-instructions | Instruction fields |
| VS Code Prompt Files | https://code.visualstudio.com/docs/copilot/customization/prompt-files | Prompt fields, variables |
| VS Code Agent Skills | https://code.visualstudio.com/docs/copilot/customization/agent-skills | Skill structure, limits |
| VS Code Copilot Settings | https://code.visualstudio.com/docs/copilot/reference/copilot-settings | All settings verification |
| VS Code Chat Tools | https://code.visualstudio.com/docs/copilot/chat/chat-tools | Tool approval, terminal |
| GitHub Custom Agents | https://docs.github.com/en/copilot/reference/custom-agents-configuration | 30K char limit |
| MCP Specification | https://spec.modelcontextprotocol.io/specification/2025-03-26/ | MCP server config |

---

## Recommended Fix Priority

### P0 — Fix Immediately (Incorrect Facts)
1. 25K → 30K character limit (6 locations across 4 files)
2. `${currentFile}` → `${file}` (1 location)
3. `chat.mcp.discovery.enabled` → `chat.mcp.gallery.enabled` (3 locations across 2 files)
4. Skills naming convention — directories not files (3 locations in 1 file)
5. Prompt checklist `agent`+`description` required claim (2 locations in 1 file)

### P1 — Fix Soon (Incomplete)
6. Terminal deny list additions — missing `kill`, `chmod`, `chown`, `Remove-Item` (1 file)
7. Skills README missing required `name` field (1 file)
8. `maxRequests` example 50 → 25 default (1 location)

### P2 — Verify/Clarify
9. 6 unverified settings in SETTINGS.md (move to "unverified" section or remove)
10. `excludeAgent` field (3 locations — verify or remove)
11. `vscode` tool alias in brain.agent.md (1 location — verify or remove)
12. `agent` tool alias — verify still official (1 location)

---

## Iteration Summary

| Iteration | Scope | Files | Findings |
|-----------|-------|-------|----------|
| 1 | TEMPLATES | 6 | 10 fixes needed |
| 2 | PATTERNS part 1 | 5 | 6 wrong, 17 unofficial |
| 3 | PATTERNS part 2 | 4 | 3 wrong, 16 unofficial |
| 4 | CHECKLISTS part 1 | 4 | 3 wrong, 9 unofficial |
| 5 | CHECKLISTS part 2 | 4 | 1 wrong, 19 unofficial |
| 6 | Root configs | 4 | 6 settings not found, 3 fixes |
| 7 | Root docs | 3 | Clean — no fixes |
| 8 | _EXEMPLAR agents | 5 | 1 minor (vscode tool) |
| 9 | _EXEMPLAR other | 5 | 3 fixes in skills/README |
| 10 | Synthesis | — | This report |

---

**Report Generated By:** @brain validation workflow
**Validation Method:** Subagent research with full file reads + URL fetches
**Total Iterations:** 10
