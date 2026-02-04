# Risk Registry

Consolidated risks from framework audit with current status.

<metadata>

**Last Updated:** 2026-02-04
**Total Risks:** 34
**Closed:** 26
**Mitigated:** 1
**Accepted:** 1
**Open:** 6

</metadata>

<summary>

## Summary by Status

| Status | Count | IDs |
|--------|-------|-----|
| Closed | 26 | R001, R002, R003, R004, R005, R006, R007, R008, R009, R010, R013, R015, R016, R017, R018, R019, R020, R021, R022, R023, R025, R028, R029, R032, R033, R034 |
| Mitigated | 1 | R014 |
| Accepted | 1 | R027 |
| Open (Critical) | 0 | — |
| Open (High) | 0 | — |
| Open (Medium) | 3 | R011, R024, R030 |
| Open (Low) | 3 | R012, R026, R031 |

</summary>

<closed_risks>

## Closed Risks

| ID | Risk | Closed By |
|----|------|-----------|
| R001 | Scope Loss (consolidation breaks applyTo) | Hybrid consolidation preserves applyTo targeting |
| R002 | Layering Loss (inheritance breaks) | Hybrid approach maintains instruction layering |
| R003 | Token Bloat (80 rules loading) | Achieved ~1,200 tokens with tiered consolidation |
| R004 | Stale architecture.md (80% obsolete) | architecture.md deleted, content migrated to copilot-instructions.md |
| R005 | Mixed Documentation State (generator.md) | generator.md slimmed from 113→38 lines |
| R006 | Broken External References (knowledge-base/) | All 4 references removed in Phase 1 |
| R007 | Terminology Inconsistency (14 issues) | Standardized in Phase 1 |
| R008 | Skill Format Coupling | Skill interfaces versioned in contract-specifications.md (skill_version field) |
| R009 | No README.md | Created at workspace root |
| R010 | Prerequisites Undocumented | Documented in generator/prerequisites.md |
| R013 | Broken Cross-References (5 links) | Fixed in Phase 1 |
| R015 | Handoff Targets Assumed | Handoff target fallbacks added to all 4 core agents |
| R016 | Execute Tool Assumed | Execute tool fallbacks added to all 4 core agents |
| R017 | copilot-instructions Coupling | copilot-instructions.md fallback added to all 4 core agents |
| R018 | Format Brittleness (Markdown tables) | Contracts use YAML blocks (see contract-specifications.md) |
| R019 | State Management (in-memory only) | .generator-state.yaml schema in master.agent.md and contract-specifications.md |
| R020 | Subagent Timeout | 60s/90s timeout policy defined in contract-specifications.md |
| R021 | Validation Authority Ambiguous | Master documented as final validation authority |
| R022 | Creator Hallucinated Completion | Master quality gate validates Creator results |
| R023 | Context Window Overflow | Creator implements summarization strategy in error handling |
| R025 | Rule Duplication | Rules consolidated to single source in Phase 2 |
| R028 | Full Ecosystem Assumed | core-agents/ distribution with README documents minimum agent set |
| R029 | instruction-creator 89% | Fixed to 100% |
| R032 | Portability 57% vs 95% | Portability achieved ~80% with P1 fallbacks |
| R033 | Brief Not Persisted | Master writes projectbrief.md (see projectbrief_template in master.agent.md) |
| R034 | Manifest Format Mismatch | YAML standardized for all contracts |

</closed_risks>

<mitigated_risks>

## Mitigated Risks

| ID | Risk | Mitigation | Residual |
|----|------|------------|----------|
| R014 | Unclear Entry Point | README provides orientation | No FAQ section yet |

</mitigated_risks>

<accepted_risks>

## Accepted Risks

| ID | Risk | Rationale |
|----|------|-----------|
| R027 | Model-Specific Prompting (Claude 4.x) | Tradeoff accepted; document optimization |

</accepted_risks>

<open_risks>

## Open Risks

### Critical (Block Master/Creator)

*No critical risks remaining.*

### High Priority

*No high priority risks remaining.*

### Medium Priority

| ID | Risk | Required Action | Target Phase |
|----|------|-----------------|--------------|
| R011 | No End-to-End Walkthrough | Add to user-manual.md | 7 |
| R024 | Partial Write Race | Checkpoint before write | 5 |
| R030 | Checklist Version Drift | Add version tracking | 6 |

### Low Priority

| ID | Risk | Required Action | Target Phase |
|----|------|-----------------|--------------|
| R012 | No CONTRIBUTING.md | Create contributor guide | 7 |
| R026 | Update Fragility | Document instruction hierarchy | 7 |
| R031 | Orphan Audit Files | Create tracking README | 7 |

</open_risks>

<cross_references>

## Cross-References

- [implementation-status.md](implementation-status.md) — Phase status
- [contract-specifications.md](contract-specifications.md) — Mitigation specs
- Original: audit-legacy/risk-registry.md (to be deleted)

</cross_references>
