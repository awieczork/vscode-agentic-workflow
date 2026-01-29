---
agent: brain
description: Phase 5 Checkpoint - templates and checklists integration after deliverables 1-16
---

# Checkpoint: Templates + Checklists Integration

**Run after:** Deliverables 1-16 complete (before final README + WORKFLOW-GUIDE)

## Task

Verify templates match patterns and checklists verify pattern compliance.

## Files to Review

### Templates
- `GENERATION-RULES/TEMPLATES/agent-skeleton.md`
- `GENERATION-RULES/TEMPLATES/skill-skeleton.md`
- `GENERATION-RULES/TEMPLATES/instruction-skeleton.md`
- `GENERATION-RULES/TEMPLATES/prompt-skeleton.md`
- `GENERATION-RULES/TEMPLATES/memory-skeleton.md`
- `GENERATION-RULES/TEMPLATES/project-context-template.md`

### Checklists
- `GENERATION-RULES/CHECKLISTS/agent-checklist.md`
- `GENERATION-RULES/CHECKLISTS/skill-checklist.md`
- `GENERATION-RULES/CHECKLISTS/instruction-checklist.md`
- `GENERATION-RULES/CHECKLISTS/prompt-checklist.md`
- `GENERATION-RULES/CHECKLISTS/memory-checklist.md`
- `GENERATION-RULES/CHECKLISTS/general-quality-checklist.md`
- `GENERATION-RULES/CHECKLISTS/security-checklist.md`
- `GENERATION-RULES/CHECKLISTS/pre-generation-checklist.md`

### Cross-Cutting
- `GENERATION-RULES/RULES.md`
- `GENERATION-RULES/NAMING.md`
- `GENERATION-RULES/SETTINGS.md`

## Checks

### Agent-Optimized Format Compliance
- [ ] All templates have YAML frontmatter with `type: template`
- [ ] All templates have HOW TO USE THIS TEMPLATE section
- [ ] All templates have PLACEHOLDER DEFINITIONS table
- [ ] All checklists have YAML frontmatter with `type: checklist`
- [ ] All checklists have CHECK_NNN format with VERIFY/PASS_IF/FAIL_IF
- [ ] All checklists have HOW TO USE THIS CHECKLIST section
- [ ] RULES.md has RULE_NNN format with LEVEL/APPLIES_TO/RATIONALE
- [ ] NAMING.md has NAME_RULE_NNN format with PATTERN/VALID/INVALID
- [ ] SETTINGS.md has tables with RATIONALE column

### Template ↔ Pattern Alignment
- [ ] agent-skeleton includes all required sections from agent-patterns
- [ ] skill-skeleton includes all required sections from skill-patterns
- [ ] instruction-skeleton includes all required sections from instruction-patterns
- [ ] prompt-skeleton includes all required sections from prompt-patterns
- [ ] memory-skeleton includes all required sections from memory-patterns

### Checklist ↔ Pattern Alignment
- [ ] agent-checklist verifies all agent-patterns RULE_NNN items
- [ ] skill-checklist verifies all skill-patterns RULE_NNN items
- [ ] instruction-checklist verifies all instruction-patterns RULE_NNN items
- [ ] prompt-checklist verifies all prompt-patterns RULE_NNN items
- [ ] memory-checklist verifies all memory-patterns RULE_NNN items

### Cross-Cutting Integration
- [ ] RULES.md contains all universal rules from patterns
- [ ] NAMING.md covers all file types
- [ ] SETTINGS.md is complete and copy-paste ready
- [ ] general-quality-checklist covers quality-patterns
- [ ] security-checklist covers checkpoint-patterns where relevant

### Generator Can Use
- [ ] Generator can create agent from agent-skeleton + agent-patterns
- [ ] Generator can validate with agent-checklist
- [ ] No missing information between pattern → template → checklist

## Output

Report with:
1. ✅ Passed checks
2. ❌ Failed checks with specific file/line
3. 🔧 Recommended fixes
4. 📋 Ready for README + WORKFLOW-GUIDE: Yes/No

## If Issues Found

Fix before proceeding to deliverable 17 (README + WORKFLOW-GUIDE).
