# Risk Registry

## Summary

| Category | Count | Critical | High | Medium | Low |
|----------|-------|----------|------|--------|-----|
| Technical Debt | 8 | 2 | 3 | 2 | 1 |
| Usability | 6 | 1 | 2 | 2 | 1 |
| Reliability | 10 | 4 | 3 | 2 | 1 |
| Maintenance | 10 | 2 | 4 | 3 | 1 |
| **Total** | **34** | **9** | **12** | **9** | **4** |

---

## Top 10 Risks by Priority

| Rank | ID | Domain | Risk | L | I | Score | Blocks M/C |
|------|-----|--------|------|---|---|-------|------------|
| 1 | R001 | D1 | Scope loss from instruction consolidation | H | H | 9 | No |
| 2 | R002 | D1 | Layering loss breaks inheritance | H | H | 9 | No |
| 3 | R004 | D3 | Stale architecture documentation | H | H | 9 | **Yes** |
| 4 | R008 | D6 | Skill format coupling | H | H | 9 | **Yes** |
| 5 | R009 | D8 | No README.md at root | H | H | 9 | No |
| 6 | R016 | D4 | Execute tool assumed available | H | H | 9 | No |
| 7 | R018 | D6 | Format brittleness (Markdown tables) | H | H | 9 | **Yes** |
| 8 | R019 | D6 | State management gaps | H | H | 9 | **Yes** |
| 9 | R022 | D6 | Creator hallucinated completion | H | M | 6 | **Yes** |
| 10 | R023 | D6 | Context window overflow | M | H | 6 | **Yes** |

---

## Risks Blocking Master/Creator Development

### Critical (Must Fix Before Starting)

| ID | Risk | Mitigation |
|----|------|------------|
| R018 | Format brittleness — contracts use Markdown tables | Replace with YAML blocks |
| R019 | State management — no checkpoint persistence | Implement .generator-state.yaml |
| R008 | Skill format coupling — changes break Creator | Version skill interfaces |
| R004 | Stale documentation — knowledge-base references | Clean before adding new docs |

### High (Should Fix Soon)

| ID | Risk | Mitigation |
|----|------|------------|
| R033 | Brief not persisted by Interview | Master must write projectbrief.md |
| R034 | Manifest format mismatch | Normalize on YAML |
| R022 | Creator may hallucinate completion | Add validation spot-checks |
| R023 | Context overflow for large manifests | Implement chunking |
| R020 | Subagent timeout undefined | Define 90s hard limit |

### Medium (Fix During Development)

| ID | Risk | Mitigation |
|----|------|------------|
| R021 | Validation authority unclear | Master is final arbiter |
| R024 | Partial write race conditions | Write temp, atomic rename |
| R030 | Checklist version drift | Centralize definitions |

---

## Full Risk Inventory

### Technical Debt (D1, D3, D5)

| ID | Risk | L | I | Status |
|----|------|---|---|--------|
| R001 | Instruction consolidation scope loss | H | H | Open |
| R002 | Instruction layering loss | H | H | Open |
| R003 | Token bloat from consolidation | H | M | Open |
| R004 | Stale architecture.md content | H | H | Open |
| R005 | Broken knowledge-base references (4+) | H | M | Open |
| R006 | instruction-creator external refs | H | M | Open |
| R007 | prompt-creator missing references/ | M | L | Accepted |
| R008 | Skill format coupling | H | H | Open |

### Usability (D7, D8)

| ID | Risk | L | I | Status |
|----|------|---|---|--------|
| R009 | No README.md | H | H | Open |
| R010 | No prerequisites documented | H | M | Open |
| R011 | No end-to-end walkthrough | M | M | Open |
| R012 | Stale "Planned" status markers | M | M | Open |
| R013 | 5 broken cross-reference links | H | M | Open |
| R014 | No FAQ/troubleshooting | M | L | Open |

### Reliability (D4, D6)

| ID | Risk | L | I | Status |
|----|------|---|---|--------|
| R015 | Agent handoff targets assumed | H | M | Open |
| R016 | Execute tool assumed available | H | H | Open |
| R017 | copilot-instructions coupling | H | M | Open |
| R018 | Contract format brittleness | H | H | Open |
| R019 | State management gaps | H | H | Open |
| R020 | Subagent timeout undefined | M | M | Open |
| R021 | Validation authority unclear | M | M | Open |
| R022 | Creator hallucinated completion | H | M | Open |
| R023 | Context window overflow | M | H | Open |
| R024 | Partial write race conditions | L | H | Open |

### Maintenance (D4, D7)

| ID | Risk | L | I | Status |
|----|------|---|---|--------|
| R025 | True agent portability 57% not 95% | H | M | Open |
| R026 | Terminology inconsistencies (14) | M | M | Open |
| R027 | Markdown tables violate style | L | L | Open |
| R028 | Model-specific prompting (Claude 4.x) | M | M | Accepted |
| R029 | Cross-agent ecosystem assumed | H | M | Open |
| R030 | Checklist version drift | M | M | Open |
| R031 | No CONTRIBUTING.md | M | L | Open |
| R032 | audit/ folder untracked | L | L | Open |
| R033 | Brief not persisted | H | M | Open |
| R034 | Manifest format mismatch | H | M | Open |

---

## Risk Mitigation Priority

### P1: Before Master/Creator (Blocking)

1. R018 — Define YAML canonical format for contracts
2. R019 — Implement .generator-state.yaml checkpoint
3. R004 — Remove stale knowledge-base content
4. R008 — Version skill interfaces

### P2: During Refactoring

5. R005, R006 — Fix broken references
6. R009, R010 — Create README.md with prerequisites
7. R015, R016, R017 — Add agent fallback behaviors
8. R026 — Standardize terminology

### P3: Ongoing Maintenance

9. R025 — Document true portability score
10. R028 — Document model optimization
11. R027 — Convert tables to bullet lists
12. R031 — Create CONTRIBUTING.md
