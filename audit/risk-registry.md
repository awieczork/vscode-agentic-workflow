# Risk Registry

Comprehensive risk registry compiled from audit domains D1-D8. Risks categorized by type and prioritized by Likelihood × Impact.

---

## Risk Categories

- **Technical Debt** — Risks from accumulated shortcuts, stale content, or architectural inconsistencies
- **Usability** — Risks affecting user experience, onboarding, or discoverability
- **Reliability** — Risks affecting system correctness, data integrity, or failure handling
- **Maintenance** — Risks affecting long-term sustainability, updates, or extensibility

---

## Complete Risk Registry

### Technical Debt Risks

| ID | Domain | Risk Description | L | I | Status | Mitigation | Owner |
|----|--------|------------------|---|---|--------|------------|-------|
| R001 | D1 | **Scope Loss** — Artifact-specific rules in artifact-style.instructions.md could accidentally apply universally if consolidation merges files incorrectly | H | H | Open | Keep artifact-style separate with applyTo targeting | TBD |
| R002 | D1 | **Layering Loss** — Instruction file inheritance semantics break if applyTo mechanism changes | H | H | Open | Document applyTo behavior, add fallback | TBD |
| R003 | D1 | **Token Bloat** — 80 rules loading on every interaction causes unnecessary token consumption | H | M | Open | Implement hybrid consolidation (~1,200 tokens) | TBD |
| R004 | D3 | **Stale Architecture Documentation** — architecture.md contains 80% obsolete content referencing deleted knowledge-base/ folder | H | H | Open | Merge valuable content to copilot-instructions.md, delete file | TBD |
| R005 | D3 | **Mixed Documentation State** — generator.md contains implemented + planned content mixed together | H | M | Open | Slim to ~40 lines, move orchestration overview to README.md | TBD |
| R006 | D5 | **Broken External References** — 4 links point to deleted knowledge-base/ folder | H | M | Open | Remove all 4 broken references | TBD |
| R007 | D7 | **Terminology Inconsistency** — 14 terminology inconsistencies across files (casing, hyphens, naming) | M | M | Open | Create terminology glossary, batch fix files | TBD |
| R008 | D6 | **Skill Format Coupling** — Master/Creator contracts assume current skill structure, breaking changes cascade | H | H | Open | Version skill interfaces, document stability guarantees | TBD |

### Usability Risks

| ID | Domain | Risk Description | L | I | Status | Mitigation | Owner |
|----|--------|------------------|---|---|--------|------------|-------|
| R009 | D8 | **No README.md** — Users cannot discover entry point or understand project purpose | H | H | Open | Create workspace root README.md (~95 lines) | TBD |
| R010 | D8 | **Prerequisites Undocumented** — Users may fail silently without knowing VS Code/Copilot requirements | H | M | Open | Add prerequisites section to README or separate file | TBD |
| R011 | D8 | **No End-to-End Walkthrough** — Users unsure what happens after /interview | M | M | Open | Add walkthrough to user-manual.md | TBD |
| R012 | D8 | **No CONTRIBUTING.md** — Framework developers have no onboarding path | M | L | Open | Create contributor guide | TBD |
| R013 | D7 | **Broken Cross-References** — 5 documentation links point to missing files | H | M | Open | Fix all broken paths | TBD |
| R014 | D2 | **Unclear Entry Point** — /interview command not documented in main instructions | M | M | Open | Reference user-manual.md from README | TBD |

### Reliability Risks

| ID | Domain | Risk Description | L | I | Status | Mitigation | Owner |
|----|--------|------------------|---|---|--------|------------|-------|
| R015 | D4 | **Handoff Targets Assumed** — Core agents assume @architect, @brain, @build exist without fallback | H | M | Open | Add "if missing" fallback behavior to all agents | TBD |
| R016 | D4 | **Tool Availability (execute)** — Core agents assume execute tool available without fallback | H | H | Open | Add command-reporting fallback when execute unavailable | TBD |
| R017 | D4 | **copilot-instructions Coupling** — Core agents assume compatible copilot-instructions.md exists | H | M | Open | Add explicit fallback behavior for missing/incompatible file | TBD |
| R018 | D6 | **Format Brittleness** — Contracts rely on Markdown tables that LLM may malform | H | H | Open | Replace Markdown tables with YAML blocks for structured data | TBD |
| R019 | D6 | **State Management Gaps** — Session state exists only in-memory, no persistence mechanism | H | H | Open | Implement .github/.generator-state.yaml checkpoint file | TBD |
| R020 | D6 | **Subagent Timeout** — Creator subagent may timeout mid-generation with no partial result | H | M | Open | Add soft/hard timeout with grace period (60s/90s) | TBD |
| R021 | D6 | **Validation Circular Dependency** — No clear source of truth when Master and Creator disagree | M | M | Open | Define Master as final validation authority | TBD |
| R022 | D6 | **Creator Hallucinated Completion** — Creator may report success with truncated or incomplete content | M | H | Open | Master runs independent spot-check on returned artifacts | TBD |
| R023 | D6 | **Context Window Overflow** — Large manifests (20+ artifacts) may exceed context limits | M | H | Open | Implement context summarization for completed artifacts | TBD |
| R024 | D6 | **Partial Write Race** — Artifact written but crash before checkpoint creates inconsistent state | M | M | Open | Write checkpoint BEFORE artifact write with "in-progress" status | TBD |

### Maintenance Risks

| ID | Domain | Risk Description | L | I | Status | Mitigation | Owner |
|----|--------|------------------|---|---|--------|------------|-------|
| R025 | D1 | **Rule Duplication** — Same rules exist in multiple instruction files, changes require multi-file updates | M | M | Open | Consolidate universal rules to single source | TBD |
| R026 | D1 | **Update Fragility** — Single file changes risk breaking layered instruction system | M | L | Open | Document instruction hierarchy, add integration tests | TBD |
| R027 | D4 | **Model-Specific Prompting** — Agents optimized for Claude 4.x may perform worse on other models | M | M | Accepted | Document Claude 4.x optimization, accept tradeoff | TBD |
| R028 | D4 | **Full Ecosystem Assumed** — Core agents expect all four agents present for handoff | H | M | Open | Document minimum viable agent set | TBD |
| R029 | D5 | **Skill Completeness Variance** — instruction-creator has 89% self-containment vs 100% for others | M | L | Open | Fix 3 broken references in instruction-creator | TBD |
| R030 | D6 | **Checklist Version Drift** — Skill updates change validation baseline mid-session | M | M | Open | Add version field to validation checklists, log versions | TBD |
| R031 | D7 | **Orphan Audit Files** — audit/*.md files unreferenced, no tracking mechanism | L | L | Open | Create audit/README.md with remediation tracking | TBD |
| R032 | D4 | **Portability Score Below Target** — Core agents at 57% portability vs claimed 95% | H | M | Open | Implement all P1 portability fixes before release | TBD |
| R033 | D6 | **Brief Not Persisted** — Interview generates brief but doesn't write projectbrief.md | H | M | Open | Master must write projectbrief.md on first execution | TBD |
| R034 | D6 | **Manifest Format Mismatch** — Interview outputs Markdown, Master expects YAML | H | M | Open | Master must parse and normalize manifest format | TBD |

---

## Top 10 Risks by Priority

Priority calculated as Likelihood × Impact where H=3, M=2, L=1.

| Rank | ID | Risk | L×I | Domain | Category | Blocks Master/Creator |
|------|-----|------|-----|--------|----------|----------------------|
| 1 | R001 | Scope Loss (consolidation breaks applyTo) | 9 | D1 | Technical Debt | No |
| 2 | R002 | Layering Loss (inheritance semantics break) | 9 | D1 | Technical Debt | No |
| 3 | R004 | Stale Architecture Documentation (80% obsolete) | 9 | D3 | Technical Debt | Yes |
| 4 | R008 | Skill Format Coupling (contracts assume structure) | 9 | D6 | Technical Debt | **Yes** |
| 5 | R009 | No README.md (no entry point) | 9 | D8 | Usability | No |
| 6 | R016 | Tool Availability (execute assumed) | 9 | D4 | Reliability | No |
| 7 | R018 | Format Brittleness (Markdown tables malform) | 9 | D6 | Reliability | **Yes** |
| 8 | R019 | State Management Gaps (in-memory only) | 9 | D6 | Reliability | **Yes** |
| 9 | R022 | Creator Hallucinated Completion (false success) | 6 | D6 | Reliability | **Yes** |
| 10 | R023 | Context Window Overflow (20+ artifacts) | 6 | D6 | Reliability | **Yes** |

---

## Risks Blocking Master/Creator Development

These risks must be resolved before Master/Creator agents can be built:

### Critical Blockers (Must Fix First)

| ID | Risk | Why It Blocks | Required Action |
|----|------|---------------|-----------------|
| R018 | Format Brittleness | Master cannot reliably parse Interview output | Define YAML canonical format for manifest |
| R019 | State Management Gaps | No session persistence = no resume capability | Implement .github/.generator-state.yaml |
| R008 | Skill Format Coupling | Contract changes break existing skills | Version skill interfaces before Master implementation |
| R004 | Stale Architecture Documentation | Developers will reference wrong structure | Clean up architecture.md before adding Master/Creator docs |

### High Blockers (Should Fix Soon)

| ID | Risk | Why It Blocks | Required Action |
|----|------|---------------|-----------------|
| R033 | Brief Not Persisted | Master needs project brief but Interview doesn't write it | Define who writes projectbrief.md |
| R034 | Manifest Format Mismatch | Master expects YAML, Interview outputs Markdown | Standardize on single format |
| R022 | Creator Hallucinated Completion | Master cannot trust Creator validation | Add spot-check mechanism to Master |
| R023 | Context Window Overflow | Large manifests cause failures | Design context summarization strategy |
| R020 | Subagent Timeout | Creator failures not handled | Define timeout policy with grace periods |

### Medium Blockers (Should Fix During)

| ID | Risk | Why It Blocks | Required Action |
|----|------|---------------|-----------------|
| R021 | Validation Circular Dependency | Unclear who has final authority | Document Master as final arbiter |
| R024 | Partial Write Race | Inconsistent state on crash | Implement checkpoint-before-write pattern |
| R030 | Checklist Version Drift | Inconsistent validation across session | Add version tracking to checklists |

---

## Summary Statistics

| Category | Count | H×H | H×M | M×M | Other |
|----------|-------|-----|-----|-----|-------|
| Technical Debt | 8 | 3 | 3 | 2 | 0 |
| Usability | 6 | 1 | 3 | 2 | 0 |
| Reliability | 10 | 3 | 2 | 3 | 2 |
| Maintenance | 10 | 0 | 3 | 3 | 4 |
| **Total** | **34** | **7** | **11** | **10** | **6** |

**Risk Distribution:**
- Critical (L×I = 9): 8 risks
- High (L×I = 6): 12 risks
- Medium (L×I ≤ 4): 14 risks

**Status:**
- Open: 33
- Accepted: 1 (R027 — Claude 4.x optimization tradeoff)
- Mitigated: 0

---

## Recommended Remediation Order

### Phase 1: Pre-Master Development (Required)

1. R018 — Define YAML canonical format
2. R019 — Design checkpoint persistence
3. R004 — Clean architecture.md
4. R008 — Version skill interfaces

### Phase 2: During Master Development

5. R033 — Define projectbrief.md ownership
6. R034 — Standardize manifest format
7. R022 — Design spot-check mechanism
8. R020 — Define timeout policy

### Phase 3: During Creator Development

9. R021 — Document validation authority
10. R023 — Design context summarization
11. R024 — Implement checkpoint-before-write
12. R030 — Add checklist versioning

### Phase 4: Pre-Release

13. R009 — Create README.md
14. R006 — Fix broken references
15. R016 — Add execute fallback
16. R032 — Reach portability target

---

## Cross-References

- [D1: Instruction Consolidation](01-instruction-consolidation.md)
- [D2: copilot-instructions Redesign](02-copilot-instructions-redesign.md)
- [D3: Generator Architecture](03-generator-architecture.md)
- [D4: Core Agent Portability](04-core-agent-portability.md)
- [D5: Skill Self-Containment](05-skill-audit.md)
- [D6: Master/Creator Specs](06-master-creator-specs.md)
- [D7: Documentation Consistency](07-documentation-consistency.md)
- [D8: Onboarding Experience](08-onboarding-experience.md)
- [Contract Adversary Analysis](09-contract-adversary-analysis.md)
- [Final Contract Specifications](10-final-contract-specifications.md)
