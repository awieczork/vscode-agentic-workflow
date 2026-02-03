# Terminology Inventory Audit

Comprehensive analysis of term usage across all markdown documentation.

---

## Executive Summary

**Files analyzed:** 48 markdown files
**Inconsistencies found:** 14 distinct terminology conflicts
**Critical issues:** 3 (require immediate remediation)
**Recommended actions:** Glossary creation + targeted fixes

---

## 1. Artifact Type Terms

### Canonical Definitions

| Term | Definition | File Extension |
|------|-----------|----------------|
| **agent** | Autonomous workflow orchestrator with tool access | `.agent.md` |
| **skill** | Invocable procedure, self-contained with references | `SKILL.md` |
| **prompt** | One-shot template with placeholders | `.prompt.md` |
| **instruction** | Contextual rules injected via applyTo | `.instructions.md` |

### Usage Consistency: ✅ CONSISTENT

All four artifact types are used consistently across documentation:
- [generator.md](../generator/generator.md) — Defines four types in manifest schema
- [10-final-contract-specifications.md](10-final-contract-specifications.md#L91) — Enumerates: `agent | skill | prompt | instruction`
- [customization.md](../core-agents/docs/customization.md) — Documents all four extension mechanisms

### Synonym Detection

| Synonym Found | Canonical Term | Files | Action |
|--------------|----------------|-------|--------|
| **procedure** | skill | [customization.md](../core-agents/docs/customization.md#L15), [customization.md](../core-agents/docs/customization.md#L292) | ⚠️ CLARIFY — "procedure" describes skill behavior, not a synonym |
| **template** | prompt | Multiple | ⚠️ CLARIFY — "template" describes prompt format, not a synonym |
| **overlay** | instruction | [customization.md](../core-agents/docs/customization.md#L20) | ✅ OK — "overlay" is contextual usage pattern |

**Finding:** No true synonyms detected. "Procedure" and "template" are descriptive terms for skill/prompt behavior, not alternate names.

---

## 2. Pipeline Terms

### Canonical Definitions

| Term | Definition | Capitalization Rule |
|------|-----------|-------------------|
| **Interview** | First pipeline agent that collects requirements | Title case when naming agent |
| **Master** | Second pipeline agent that orchestrates creation | Title case when naming agent |
| **Creator** | Third pipeline agent that executes skills | Title case when naming agent |
| **questionnaire** | XML input format for Interview | Lowercase |
| **project brief** | Synthesized requirements document | Lowercase, two words |
| **execution manifest** | Artifact generation specifications | Lowercase |

### Inconsistencies Found

#### Issue T1: Agent name capitalization (MEDIUM)

| Variant | Count | Files |
|---------|-------|-------|
| `Interview` (title case) | 25+ | [generator.md](../generator/generator.md), [user-manual.md](../generator/user-manual.md) |
| `interview` (lowercase) | 15+ | [04-core-agent-portability.md](04-core-agent-portability.md), [06-interview-interface-contract.md](06-interview-interface-contract.md) |
| `@interview` (reference) | 5+ | [generator.md](../generator/generator.md#L62) |

**Recommendation:** Use title case (`Interview`, `Master`, `Creator`) when referring to the agent role. Use lowercase (`interview`) only in file paths and code.

#### Issue T2: "project brief" vs "projectbrief" (HIGH)

| Variant | Files |
|---------|-------|
| `project brief` (two words) | [generator.md](../generator/generator.md#L62), [user-manual.md](../generator/user-manual.md#L160) |
| `projectbrief.md` (filename) | [06-interview-interface-contract.md](06-interview-interface-contract.md#L239), [generator.md](../generator/generator.md#L116) |
| `Project Brief` (title case) | [06-interview-interface-contract.md](06-interview-interface-contract.md#L19) |

**Recommendation:** 
- Document name: "project brief" (lowercase, two words)
- File name: `projectbrief.md` (one word, lowercase)
- Section header: "Project Brief" (title case)

#### Issue T3: "execution manifest" vs "artifact manifest" (MEDIUM)

| Variant | Files |
|---------|-------|
| `execution manifest` | [user-manual.md](../generator/user-manual.md#L166), [user-manual.md](../generator/user-manual.md#L190) |
| `artifact manifest` | [generator.md](../generator/generator.md#L74), [generator.md](../generator/generator.md#L90) |

**Recommendation:** Standardize on **execution manifest** — describes what it does (executes creation).

---

## 3. Status Terms

### Canonical Definitions

| Term | Context | Definition |
|------|---------|-----------|
| **implemented** | Development status | Feature is built and functional |
| **planned** | Development status | Feature is designed but not built |
| **success** | Runtime status | Operation completed without errors |
| **partial** | Runtime status | Operation completed with warnings/incomplete |
| **failed** | Runtime status | Operation could not complete |
| **complete** | Runtime status | Artifact generation finished |
| **pending** | Runtime status | Artifact not yet started |
| **in-progress** | Runtime status | Artifact currently being generated |

### Inconsistencies Found

#### Issue T4: Status value casing (CRITICAL)

| Variant | Files |
|---------|-------|
| `Complete` | [05-skill-audit.md](05-skill-audit.md#L7) |
| `COMPLETE` | [05-skill-audit.md](05-skill-audit.md#L46) |
| `complete` | [07-master-agent-interface-contract.md](07-master-agent-interface-contract.md#L340) |
| `completed` | [06-master-creator-specs.md](06-master-creator-specs.md#L179) |

**Recommendation:** Standardize on lowercase for enum values:
- `success`, `partial`, `failed` — Creator status
- `complete`, `pending`, `in-progress` — Artifact status
- `Implemented`, `Planned` — Development status (title case)

#### Issue T5: "in-progress" format (HIGH)

| Variant | Files |
|---------|-------|
| `in-progress` | [10-final-contract-specifications.md](10-final-contract-specifications.md#L552) |
| `in_progress` | [06-master-creator-specs.md](06-master-creator-specs.md#L179) |
| `in progress` | None found |

**Recommendation:** Standardize on `in-progress` (hyphenated) for consistency with other status values.

#### Issue T6: "complete" vs "completed" (MEDIUM)

| Variant | Files |
|---------|-------|
| `complete` | [10-final-contract-specifications.md](10-final-contract-specifications.md#L552) |
| `completed` | [06-master-creator-specs.md](06-master-creator-specs.md#L179), [07-master-agent-interface-contract.md](07-master-agent-interface-contract.md#L459) |

**Recommendation:** Use `complete` (adjective) for status enum, `completed` (verb) for prose.

---

## 4. Structural Terms

### Canonical Definitions

| Term | Definition | Usage |
|------|-----------|-------|
| `.github/` | Agentic framework root folder | Always with trailing slash |
| `generator/` | Pipeline documentation folder | Always with trailing slash |
| `core-agents/` | Portable agent pack documentation | Always with trailing slash |
| `audit/` | Design documents and specifications | Always with trailing slash |
| **workspace** | VS Code workspace root | Use for user's project |
| **project** | User's software project being enhanced | Avoid confusion with "project brief" |
| **repository** | Git repository containing workspace | Use sparingly |

### Inconsistencies Found

#### Issue T7: "knowledge-base/" references (CRITICAL)

| Reference Type | Files | Status |
|----------------|-------|--------|
| Broken links | [05-skill-audit.md](05-skill-audit.md#L20-L23) | Folder deleted, links remain |
| Documentation | [architecture.md](../generator/architecture.md#L11), [architecture.md](../generator/architecture.md#L33) | References obsolete folder |
| Anti-pattern warnings | [05-skill-audit.md](05-skill-audit.md#L35) | Intentional — should keep |

**Recommendation:** 
1. Remove broken links from copilot-instructions.md and instruction-creator references
2. Delete knowledge-base sections from [architecture.md](../generator/architecture.md#L60-L76)
3. Keep anti-pattern warnings in skill-creator (intentional)

#### Issue T8: Folder path format (LOW)

| Variant | Files |
|---------|-------|
| `.github/` (with slash) | Most files |
| `.github` (without slash) | Occasional |

**Recommendation:** Always use trailing slash for folder references.

---

## 5. Quality Terms

### Canonical Definitions

| Term | Definition | Usage |
|------|-----------|-------|
| **L0** | Single-file artifact, no references needed | Complexity level |
| **L1** | May need 1-2 reference files for context | Complexity level |
| **L2** | Full integration layer with references/ folder | Complexity level |
| **P1** | Critical/blocker — must fix before completion | Priority level |
| **P2** | Important/warning — should fix | Priority level |
| **P3** | Minor/enhancement — nice to have | Priority level |

### Definition Locations

| Term | Defined In |
|------|-----------|
| L0/L1/L2 | [10-final-contract-specifications.md](10-final-contract-specifications.md#L108-L112), [06-interview-interface-contract.md](06-interview-interface-contract.md#L146-L148), [user-manual.md](../generator/user-manual.md#L176) |
| P1/P2/P3 | [04-core-agent-portability.md](04-core-agent-portability.md#L33-L49), [05-skill-audit.md](05-skill-audit.md#L16-L33), [08-creator-agent-interface-contract.md](08-creator-agent-interface-contract.md#L247-L250) |

### Inconsistencies Found

#### Issue T9: Complexity level definitions (LOW)

Definitions are consistent but appear in 3+ files. No conflict, but creates maintenance burden.

**Recommendation:** Consolidate to single source of truth in final-contract-specifications.md, reference elsewhere.

#### Issue T10: Priority level definitions (LOW)

P1/P2/P3 defined slightly differently in audit vs contract files:
- Audit files: "Critical Issues (Must Fix)", "Important Issues (Should Fix)", "Minor Issues (Nice to Have)"
- Contract files: "P1 blockers", "required quality", "enhancements"

**Recommendation:** Adopt contract file definitions as canonical.

---

## 6. Additional Inconsistencies

#### Issue T11: "artifact" vs "resource" (LOW)

| Term | Usage |
|------|-------|
| artifact | Agents, skills, prompts, instructions |
| resource | [generator.md](../generator/generator.md#L109) — "Resources" section header |

**Recommendation:** Use "artifact" for generated items, "resource" for documentation/files.

#### Issue T12: "spawn" vs "invoke" vs "delegate" (MEDIUM)

| Term | Usage | Files |
|------|-------|-------|
| spawn | Create subagent in new context | [generator.md](../generator/generator.md#L54), [07-master-agent-interface-contract.md](07-master-agent-interface-contract.md) |
| invoke | Call skill or tool | [customization.md](../core-agents/docs/customization.md#L15) |
| delegate | Hand off to another agent | [customization.md](../core-agents/docs/customization.md#L14) |

**Recommendation:** 
- **spawn** — Create new agent context (subagent)
- **invoke** — Execute skill procedure
- **delegate** — Hand off control to peer agent

#### Issue T13: "validation" vs "verification" (LOW)

Both terms used interchangeably. Current usage is acceptable but could be clarified:
- **validation** — Check against schema/rules
- **verification** — Confirm artifact content is correct

#### Issue T14: Example file naming (LOW)

| Pattern | Files |
|---------|-------|
| `example-*.md` | All skill assets |
| `example-skeleton.md` | [05-skill-audit.md](05-skill-audit.md#L57) — consistent across all skills |

**Finding:** Naming is consistent. No action needed.

---

## Remediation Plan

### Priority 1 (Critical) — Fix immediately

1. **T7: knowledge-base references**
   - Remove from [copilot-instructions.md](../.github/copilot-instructions.md#L32)
   - Remove from [instruction-creator/references/](../.github/skills/instruction-creator/references/)
   - Delete sections from [architecture.md](../generator/architecture.md#L60-L76)

2. **T4: Status value casing**
   - Audit and normalize all status enums to lowercase in contract specs
   - Update skill-audit.md to use consistent casing

3. **T5: in-progress format**
   - Change `in_progress` to `in-progress` in [06-master-creator-specs.md](06-master-creator-specs.md#L179)

### Priority 2 (High) — Fix soon

4. **T2: project brief naming**
   - Document canonical usage in glossary
   - No file changes needed (current usage is logical)

5. **T3: execution manifest naming**
   - Change "artifact manifest" to "execution manifest" in [generator.md](../generator/generator.md#L74), [generator.md](../generator/generator.md#L90)

### Priority 3 (Low) — Fix when convenient

6. **T1, T6, T8-T14**
   - Document in glossary
   - Fix opportunistically during other edits

---

## Canonical Glossary

### Artifact Types

- **agent** — Autonomous workflow orchestrator with tool access. File: `[name].agent.md`
- **skill** — Invocable procedure with self-contained references. File: `[name]/SKILL.md`
- **prompt** — One-shot template with placeholders. File: `[name].prompt.md`
- **instruction** — Contextual rules injected via applyTo. File: `[name].instructions.md`

### Pipeline Components

- **Interview** — First pipeline agent. Collects requirements via questionnaire. Outputs project brief + execution manifest.
- **Master** — Second pipeline agent. Validates manifest, determines order, spawns Creator for each artifact.
- **Creator** — Third pipeline agent. Reads skill, follows workflow, produces artifact.
- **questionnaire** — XML format for user input to Interview agent.
- **project brief** — Synthesized requirements document. File: `projectbrief.md`
- **execution manifest** — Artifact specifications with type, path, skill, complexity.

### Status Values

- **Development status:** `Implemented`, `Planned` (title case)
- **Creator result:** `success`, `partial`, `failed` (lowercase)
- **Artifact state:** `pending`, `in-progress`, `complete`, `failed`, `skipped`, `blocked` (lowercase)

### Quality Levels

- **L0** — Single-file artifact, no references needed
- **L1** — May need 1-2 reference files for context
- **L2** — Full integration layer with references/ folder
- **P1** — Critical blocker, must fix
- **P2** — Important warning, should fix
- **P3** — Minor enhancement, nice to have

### Structural Terms

- **.github/** — Agentic framework root folder
- **generator/** — Pipeline documentation folder
- **core-agents/** — Portable agent pack documentation
- **workspace** — VS Code workspace root (user's project)
- **spawn** — Create subagent in new context
- **invoke** — Execute skill procedure
- **delegate** — Hand off control to peer agent

---

## Cross-References

- Contract specifications: [10-final-contract-specifications.md](10-final-contract-specifications.md)
- Skill audit: [05-skill-audit.md](05-skill-audit.md)
- Architecture: [architecture.md](../generator/architecture.md)
