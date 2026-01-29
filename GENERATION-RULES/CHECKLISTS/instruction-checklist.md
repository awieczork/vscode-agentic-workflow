---
type: checklist
version: 1.0.0
purpose: Validate instruction files against instruction-patterns.md rules
checklist-for: instruction
applies-to: [generator, build, inspect]
last-updated: 2026-01-28
---

# Instruction Checklist

> **Validate `.instructions.md` files against framework rules before deployment**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
Run this checklist after creating any instruction file. All BLOCKING items must pass.

**For Build Agents:**
Validate generated instructions before committing. Fix any failures before proceeding.

**For Inspect Agents:**
Use this checklist as verification criteria. Report failures with specific rule IDs.

---

## GATE 1: Structure & Location

```
CHECK_S001: Correct Location
  VERIFY: File in valid instruction location
  PASS_IF: `copilot-instructions.md` OR `.github/instructions/*.instructions.md`
  FAIL_IF: Wrong directory or filename pattern
  SEVERITY: BLOCKING

CHECK_S002: Frontmatter (Targeted Files)
  VERIFY: Targeted files have YAML frontmatter
  PASS_IF: `*.instructions.md` has valid frontmatter with `applyTo`
  FAIL_IF: Missing frontmatter for targeted instruction file
  SEVERITY: BLOCKING

CHECK_S003: ApplyTo Valid
  VERIFY: Glob pattern syntax is correct
  PASS_IF: Valid glob pattern (e.g., `**/*.ts`)
  FAIL_IF: Invalid glob syntax or malformed pattern
  SEVERITY: BLOCKING

CHECK_S004: No Tool Specs
  VERIFY: File contains no tool specifications
  PASS_IF: No tool access rules in content
  FAIL_IF: Contains tool configurations
  SEVERITY: BLOCKING

CHECK_S005: No Handoff Rules
  VERIFY: File contains no handoff configuration
  PASS_IF: No handoff rules in content
  FAIL_IF: Contains handoff configurations
  SEVERITY: BLOCKING
```

**Human-readable:**
- [ ] CHECK_S001: File in `copilot-instructions.md` or `.github/instructions/`
- [ ] CHECK_S002: Targeted files have YAML frontmatter with `applyTo`
- [ ] CHECK_S003: `applyTo` uses valid glob syntax
- [ ] CHECK_S004: No tool specifications (belongs in agents)
- [ ] CHECK_S005: No handoff rules (belongs in agents)

**Gate 1 Result:** [ ] PASS  [ ] FAIL

---

## GATE 2: Content Rules

```
CHECK_C001: No Roles
  VERIFY: Contains only rules, constraints, standards
  PASS_IF: Only instructions, no "You are..." persona definitions
  FAIL_IF: Contains role definitions or persona descriptions
  SEVERITY: BLOCKING

CHECK_C002: Self-Contained
  VERIFY: File works independently
  PASS_IF: No assumptions about other instruction files being loaded
  FAIL_IF: References or depends on another instruction file
  SEVERITY: WARNING

CHECK_C003: Specific Stack
  VERIFY: Technology references are explicit
  PASS_IF: Explicit versions and frameworks (e.g., "TypeScript 5.4")
  FAIL_IF: Vague descriptions like "modern practices"
  SEVERITY: WARNING

CHECK_C004: Positive Framing
  VERIFY: Majority positive instructions
  PASS_IF: More "Write tests" than "Don't skip tests"
  FAIL_IF: Majority negative framing
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_C001: No personas ("You are...")
- [ ] CHECK_C002: Self-contained (no cross-file dependencies)
- [ ] CHECK_C003: Explicit tech versions (not "modern practices")
- [ ] CHECK_C004: Positive framing ("Do X" over "Don't Y")

**Gate 2 Result:** [ ] PASS  [ ] FAIL

---

## GATE 3: Size & Organization

```
CHECK_L001: Line Limit (Soft)
  VERIFY: File ≤300 lines
  PASS_IF: Total lines ≤300
  FAIL_IF: >300 lines without clear justification
  SEVERITY: WARNING

CHECK_L002: Line Limit (Hard)
  VERIFY: File ≤500 lines
  PASS_IF: Total lines ≤500
  FAIL_IF: Exceeds 500 lines
  SEVERITY: BLOCKING

CHECK_L003: Commands Early
  VERIFY: Commands section in first third
  PASS_IF: Slash commands documented in first 100 lines (if present)
  FAIL_IF: Commands buried at end of file
  SEVERITY: WARNING

CHECK_L004: No Duplicates
  VERIFY: Each rule has single source of truth
  PASS_IF: Rules not duplicated across multiple instruction files
  FAIL_IF: Same rule in multiple files
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_L001: File ≤300 lines (soft limit)
- [ ] CHECK_L002: File ≤500 lines (hard limit)
- [ ] CHECK_L003: Commands in first third (if present)
- [ ] CHECK_L004: No duplicate rules across files

**Gate 3 Result:** [ ] PASS  [ ] FAIL

---

## GATE 4: Safety Rules

```
CHECK_P001: P1 Emphasis
  VERIFY: P1/P2 rules use strong language
  PASS_IF: Uses **Never**, **Always**, **MUST** for P1/P2 constraints
  FAIL_IF: P1 constraints use weak language ("try to avoid")
  SEVERITY: BLOCKING

CHECK_P002: No Escape Clauses
  VERIFY: P1/P2 rules have no exceptions
  PASS_IF: P1/P2 rules are absolute
  FAIL_IF: P1/P2 has "unless..." clauses
  SEVERITY: BLOCKING
```

**Human-readable:**
- [ ] CHECK_P001: P1/P2 rules use **Never**/**Always**/**MUST**
- [ ] CHECK_P002: No "unless..." on P1/P2 rules

**Gate 4 Result:** [ ] PASS  [ ] FAIL

---

## GATE 5: Anti-Patterns

```
CHECK_A001: No Personas
  VERIFY: No role definitions
  PASS_IF: Only standards and rules
  FAIL_IF: "You are a senior developer" or similar
  SEVERITY: BLOCKING

CHECK_A002: No Load Order Assumptions
  VERIFY: Self-contained instructions
  PASS_IF: Works without other files loaded
  FAIL_IF: "See copilot-instructions.md for details"
  SEVERITY: WARNING

CHECK_A003: Actionable Rules
  VERIFY: Rules are specific and actionable
  PASS_IF: Clear "do this" or "don't do this"
  FAIL_IF: Vague guidance without specific actions
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_A001: No persona definitions in content
- [ ] CHECK_A002: No "see other file" references
- [ ] CHECK_A003: Rules are specific and actionable

**Gate 5 Result:** [ ] PASS  [ ] FAIL

---

## SUMMARY

| Gate | Status | Notes |
|------|--------|-------|
| 1. Structure & Location | | |
| 2. Content Rules | | |
| 3. Size & Organization | | |
| 4. Safety Rules | | |
| 5. Anti-Patterns | | |

**Overall:** [ ] PASS — Ready for deployment  [ ] FAIL — Needs revision

**Blocking Issues:**
- 

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [instruction-patterns.md](../PATTERNS/instruction-patterns.md) | Rules being verified |
| [RULES.md](../RULES.md) | P1/P2/P3 constraint definitions |
| [agent-checklist.md](agent-checklist.md) | Agents use instructions |

---

## SOURCES

- [instruction-patterns.md](../PATTERNS/instruction-patterns.md) — All RULE_NNN items
- [validation-checklist.md](../../cookbook/TEMPLATES/validation-checklist.md) — Gate format
