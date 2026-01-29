# Iteration State: Instruction Reference Documentation

> **Task:** Create REFERENCE/instruction/ documentation  
> **Iterations:** 15/15 ✅ COMPLETE  
> **Status:** ✅ DELIVERED

---

## Deliverables Created

| File | Lines | Target | Status |
|------|-------|--------|--------|
| REFERENCE/instruction/README.md | 36 | 20-30 | ✅ (+20%) |
| REFERENCE/instruction/PATTERNS.md | 208 | 150-200 | ✅ (+4%) |
| REFERENCE/instruction/TEMPLATE.md | 128 | 100-120 | ✅ (+7%) |
| REFERENCE/instruction/CHECKLIST.md | 51 | 50-60 | ✅ |

---

## Success Criteria Verification

- [x] Two instruction types clearly distinguished
- [x] Frontmatter schema complete and accurate
- [x] Glob pattern examples comprehensive
- [x] excludeAgent field documented (GitHub.com only)
- [x] Anti-patterns instruction-specific
- [x] Component selection table included
- [x] Line counts within targets (±20%)
- [x] Cross-references between files
- [x] Aligned with TAGS-INSTRUCTION.md vocabulary
- [x] NO references to cookbook/ or GENERATION-RULES/

---

## Pre-Flight Questions — ANSWERED ✅

| Question | Answer | Source |
|----------|--------|--------|
| Exact difference repo-wide vs path-specific? | Repo-wide: `.github/copilot-instructions.md` NO frontmatter, auto-applies all requests. Path-specific: `*.instructions.md` supports frontmatter with `applyTo` for targeting | VS Code + GitHub docs |
| Valid frontmatter fields for path-specific? | `applyTo` (required for auto-apply), `name` (optional), `description` (optional), `excludeAgent` (GitHub.com only: "code-review" \| "coding-agent") | GitHub docs |
| Glob pattern syntax supported? | VS Code's custom glob: `**/*.ts`, `src/**`, `*.py`, `**/*.{ts,tsx}`, comma-separated for multiple | VS Code glob docs |
| When Instruction vs Agent vs Skill? | Instructions for auto-applied rules without persona. Agents for persona + tools + handoffs. Skills for bundled portable procedures. | Official docs comparison |

---

## Key Decisions

| ID | Decision | Source | Status |
|----|----------|--------|--------|
| D1 | Two instruction types: repo-wide (no frontmatter) vs path-specific (frontmatter optional) | VS Code + GitHub | ✅ |
| D2 | excludeAgent is GitHub.com-only, not VS Code | GitHub Docs | ✅ |
| D3 | Main toggle setting: `github.copilot.chat.codeGeneration.useInstructionFiles` (default: false) | VS Code docs | ✅ |
| D4 | No hard size limits documented; guidance is "≤2 pages" | GitHub docs | ✅ |
| D5 | applyTo required for AUTO-apply; without it, manual attachment needed | VS Code docs | ✅ |
| D6 | Glob patterns: no negation (!), no regex, VS Code custom implementation | VS Code source | ✅ |
| D7 | XML tags not officially supported — passthrough to LLM only | VS Code docs | ✅ |
| D8 | Use markdown format (headings, lists, tables) for portability | Community patterns | ✅ |

---

## Synthesized Schema

### Type 1: Repo-Wide (`copilot-instructions.md`)
```
Location: .github/copilot-instructions.md
Frontmatter: NONE (plain markdown)
Scope: ALL chat requests
Auto-apply: Yes (when setting enabled)
Setting: github.copilot.chat.codeGeneration.useInstructionFiles
```

### Type 2: Path-Specific (`*.instructions.md`)
```yaml
---
applyTo: "**/*.ts"           # Optional but REQUIRED for auto-apply
name: "TypeScript Rules"     # Optional: display name
description: "..."           # Optional: UI description
excludeAgent: "code-review"  # GitHub.com ONLY
---
# Markdown body here
```
```
Location: .github/instructions/*.instructions.md
Frontmatter: Optional (but applyTo needed for auto-apply)
Scope: Files matching glob pattern
Auto-apply: When files match applyTo pattern
```

---

## Handoff Summary

**Ready to create REFERENCE/instruction/ with:**
- README.md (~25 lines)
- PATTERNS.md (~180 lines)
- TEMPLATE.md (~110 lines)
- CHECKLIST.md (~55 lines)

**Key sources verified:**
- VS Code official docs ✅
- GitHub official docs ✅
- awesome-copilot examples ✅
- Local workspace examples ✅

**All pre-flight questions answered, all constraints documented.**
