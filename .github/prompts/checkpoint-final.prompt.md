---
agent: brain
description: Final Checkpoint - complete GENERATION-RULES review
---

# Checkpoint: FINAL GENERATION-RULES Review

**Run after:** All 17 deliverables complete

## Task

Complete review of entire GENERATION-RULES folder before declaring synthesis complete.

## Files to Review

**ALL files in GENERATION-RULES/**

## Checks

### Completeness
- [ ] README.md exists and provides clear entry point
- [ ] COMPONENT-MATRIX.md exists
- [ ] RULES.md exists
- [ ] NAMING.md exists
- [ ] SETTINGS.md exists
- [ ] WORKFLOW-GUIDE.md exists
- [ ] All 9 PATTERNS/ files exist
- [ ] All 6 TEMPLATES/ files exist
- [ ] All 8 CHECKLISTS/ files exist

### Agent-Optimized Format Compliance (CRITICAL)
- [ ] ALL files have YAML frontmatter with: type, version, purpose, applies-to, last-updated
- [ ] ALL files have HOW TO USE THIS FILE/TEMPLATE/CHECKLIST section
- [ ] Decision-matrices have IF-THEN rules AND VALIDATION RULES
- [ ] Pattern files have AUTHORING RULES in RULE_NNN format
- [ ] Checklists have CHECK_NNN format with VERIFY/PASS_IF/FAIL_IF
- [ ] Templates have PLACEHOLDER DEFINITIONS table
- [ ] ALL files have CROSS-REFERENCES section
- [ ] ALL structured data uses tables (not prose)

### Navigation
- [ ] README provides FILE INDEX with "Read When" column
- [ ] Cross-references between files resolve
- [ ] No broken links
- [ ] No orphan files (unreferenced)

### Generator Usability
- [ ] Generator can parse YAML frontmatter for file discovery
- [ ] Generator can parse IF-THEN rules for component selection
- [ ] Generator can parse RULE_NNN for validation
- [ ] Generator can parse CHECK_NNN for inspection
- [ ] Generator can find template for any component type

### User Usability
- [ ] User can understand flow from WORKFLOW-GUIDE
- [ ] User can fill project-context-template
- [ ] SETTINGS.md is copy-paste ready

### Quality
- [ ] No contradictions between files
- [ ] Consistent terminology throughout
- [ ] All rules trace to source (SOURCES section)
- [ ] All anti-patterns include "why" column

## Output

**Approval to proceed** OR **Issues list for remediation**

## If Approved

GENERATION-RULES synthesis is **COMPLETE**.

Update:
- [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md) — final notes
- [projectbrief.md](../memory-bank/projectbrief.md) — mark synthesis complete

## If Issues Found

Create remediation task list before approval.
