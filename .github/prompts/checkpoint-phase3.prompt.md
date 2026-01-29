---
agent: brain
description: Phase 3 Checkpoint - all patterns coherence review after deliverables 1-10
---

# Checkpoint: All Patterns Coherence Review

**Run after:** Deliverables 1-10 complete (all pattern files)

## Task

Review all pattern files for consistency before cross-cutting rules synthesis.

## Files to Review

- `GENERATION-RULES/COMPONENT-MATRIX.md`
- `GENERATION-RULES/PATTERNS/agent-patterns.md`
- `GENERATION-RULES/PATTERNS/skill-patterns.md`
- `GENERATION-RULES/PATTERNS/instruction-patterns.md`
- `GENERATION-RULES/PATTERNS/prompt-patterns.md`
- `GENERATION-RULES/PATTERNS/memory-patterns.md`
- `GENERATION-RULES/PATTERNS/mcp-patterns.md`
- `GENERATION-RULES/PATTERNS/orchestration-patterns.md`
- `GENERATION-RULES/PATTERNS/quality-patterns.md`
- `GENERATION-RULES/PATTERNS/checkpoint-patterns.md`

## Checks

### Agent-Optimized Format Compliance
- [ ] All 10 files have YAML frontmatter
- [ ] All files have HOW TO USE THIS FILE section
- [ ] All pattern files have AUTHORING RULES in RULE_NNN format
- [ ] All pattern files have VALIDATION CHECKLIST
- [ ] All files have CROSS-REFERENCES section
- [ ] All files use tables over prose for structured data

### No Contradictions
- [ ] Rules in one pattern don't conflict with rules in another
- [ ] Orchestration patterns align with agent patterns
- [ ] Quality patterns apply to all component types
- [ ] Checkpoint patterns integrate with workflow

### Terminology Consistent
- [ ] Same terms used across all files
- [ ] No conflicting definitions
- [ ] Cross-references resolve correctly

### Coverage Complete
- [ ] Every component type has structure defined
- [ ] Every component type has rules
- [ ] Memory and orchestration integrate with components

### Ready for RULES.md
- [ ] Can extract universal rules from patterns (RULE_NNN format)
- [ ] Can identify component-specific rules
- [ ] Iron laws identifiable

## Output

Report with:
1. ✅ Passed checks
2. ❌ Failed checks with specific file/line
3. 🔧 Recommended fixes
4. 📋 Notes for RULES.md synthesis

## If Issues Found

Fix before proceeding to Phase 4 (Cross-Cutting).
