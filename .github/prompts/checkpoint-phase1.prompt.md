---
agent: brain
description: Phase 1 Checkpoint - coherence review after deliverables 1-5
---

# Checkpoint: Phase 1 Coherence Review

**Run after:** Deliverables 1-5 complete (COMPONENT-MATRIX + 4 component patterns)

## Task

Review all Phase 1 files for internal consistency before proceeding.

## Files to Review

- `GENERATION-RULES/COMPONENT-MATRIX.md`
- `GENERATION-RULES/PATTERNS/agent-patterns.md`
- `GENERATION-RULES/PATTERNS/skill-patterns.md`
- `GENERATION-RULES/PATTERNS/instruction-patterns.md`
- `GENERATION-RULES/PATTERNS/prompt-patterns.md`

## Checks

### Agent-Optimized Format Compliance
- [ ] All files have YAML frontmatter (type, version, purpose, applies-to, last-updated)
- [ ] All files have HOW TO USE THIS FILE section
- [ ] COMPONENT-MATRIX has IF-THEN decision rules (not just flowchart)
- [ ] COMPONENT-MATRIX has VALIDATION RULES with REQUIRE/REJECT_IF
- [ ] Pattern files have AUTHORING RULES in RULE_NNN format
- [ ] Pattern files have VALIDATION CHECKLIST in checkbox format
- [ ] All files have CROSS-REFERENCES section

### Cross-Reference Consistency
- [ ] COMPONENT-MATRIX distinguishes all 4 types clearly
- [ ] Each pattern file's PURPOSE aligns with COMPONENT-MATRIX
- [ ] No contradicting rules between pattern files
- [ ] Terminology consistent across all files

### Rule Alignment
- [ ] agent-patterns: roles/modes allowed
- [ ] instruction-patterns: roles/modes PROHIBITED
- [ ] skill-patterns: no modes
- [ ] prompt-patterns: no persistent state

### Structure Alignment
- [ ] All pattern files follow Pattern File Format from synthesis-reference.md
- [ ] All have ANTI-PATTERNS section (table format)
- [ ] All anti-patterns include "why"

## Output

Report with:
1. ✅ Passed checks
2. ❌ Failed checks with specific file/line
3. 🔧 Recommended fixes

## If Issues Found

Fix before proceeding to Phase 2 (Memory & Tools).
