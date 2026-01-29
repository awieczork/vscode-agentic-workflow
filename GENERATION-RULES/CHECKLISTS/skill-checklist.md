---
type: checklist
version: 1.0.0
purpose: Validate skill files against skill-patterns.md rules
checklist-for: skill
applies-to: [generator, build, inspect]
last-updated: 2026-01-28
---

# Skill Checklist

> **Validate `.md` skill files against framework rules before deployment**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
Run this checklist after creating any skill file. All BLOCKING items must pass.

**For Build Agents:**
Validate generated skills before committing. Fix any failures before proceeding.

**For Inspect Agents:**
Use this checklist as verification criteria. Report failures with specific rule IDs.

---

## GATE 1: Structure & Naming

```
CHECK_S001: Name Format
  VERIFY: Skill name follows naming rules
  PASS_IF: 1-64 chars, lowercase alphanumeric + hyphens, no consecutive hyphens
  FAIL_IF: Consecutive hyphens, starts/ends with hyphen, uppercase, >64 chars
  SEVERITY: BLOCKING

CHECK_S002: Name Matches Folder
  VERIFY: `name` field equals parent folder name
  PASS_IF: name: "fix-issue" in folder `fix-issue/`
  FAIL_IF: name: "fix-issue" but folder is `fixIssue/`
  SEVERITY: BLOCKING

CHECK_S003: Frontmatter Present
  VERIFY: Has YAML frontmatter with required fields
  PASS_IF: Has `name` + `description` fields
  FAIL_IF: Missing frontmatter or required fields
  SEVERITY: BLOCKING

CHECK_S004: Location Valid
  VERIFY: File in correct directory
  PASS_IF: In `.github/skills/{skill-name}/` or `skills/{skill-name}/`
  FAIL_IF: Wrong directory structure
  SEVERITY: BLOCKING
```

**Human-readable:**
- [ ] CHECK_S001: Name is 1-64 chars, lowercase, hyphens (no consecutive)
- [ ] CHECK_S002: `name` field matches parent folder name exactly
- [ ] CHECK_S003: Has frontmatter with `name` + `description`
- [ ] CHECK_S004: Located in correct skills directory

**Gate 1 Result:** [ ] PASS  [ ] FAIL

---

## GATE 2: Content Quality

```
CHECK_Q001: Description Completeness
  VERIFY: Description states capability AND trigger condition
  PASS_IF: "Does X when Y" format — what it does + when to use
  FAIL_IF: Description only says what, not when to use
  SEVERITY: WARNING

CHECK_Q002: Steps Section Present
  VERIFY: Has numbered steps for task skills
  PASS_IF: Clear numbered steps for procedural skills
  FAIL_IF: Missing steps section (for non-reference skills)
  SEVERITY: WARNING

CHECK_Q003: Error Handling Documented
  VERIFY: Has error handling section
  PASS_IF: Failure modes and recovery actions documented
  FAIL_IF: No failure modes or recovery actions
  SEVERITY: WARNING

CHECK_Q004: Single Responsibility
  VERIFY: Skill has one purpose
  PASS_IF: One clear capability
  FAIL_IF: Multiple unrelated responsibilities
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_Q001: Description has capability + trigger ("Does X when Y")
- [ ] CHECK_Q002: Has numbered steps (for procedural skills)
- [ ] CHECK_Q003: Error handling with failure modes documented
- [ ] CHECK_Q004: Single responsibility (one capability)

**Gate 2 Result:** [ ] PASS  [ ] FAIL

---

## GATE 3: Size Limits

```
CHECK_L001: Line Limit
  VERIFY: SKILL.md body <500 lines
  PASS_IF: Total lines <500
  FAIL_IF: Exceeds 500 lines
  SEVERITY: BLOCKING

CHECK_L002: Token Estimate
  VERIFY: Content <5000 tokens
  PASS_IF: Estimated tokens <5000
  FAIL_IF: Exceeds 5000 tokens
  SEVERITY: WARNING

CHECK_L003: Reference Depth
  VERIFY: References are ONE level deep only
  PASS_IF: SKILL.md → referenced file (single hop)
  FAIL_IF: SKILL.md → file → file (nested references)
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_L001: File <500 lines
- [ ] CHECK_L002: Content <5000 tokens
- [ ] CHECK_L003: References are single-hop only

**Gate 3 Result:** [ ] PASS  [ ] FAIL

---

## GATE 4: Safety & Compatibility

```
CHECK_C001: No Tool Restrictions
  VERIFY: No `allowed-tools` field in frontmatter
  PASS_IF: `allowed-tools` field not present
  FAIL_IF: `allowed-tools` field present (not supported)
  SEVERITY: BLOCKING

CHECK_C002: Platform Compatibility
  VERIFY: Portable by default OR compatibility documented
  PASS_IF: Portable constructs OR `compatibility:` field present
  FAIL_IF: Platform-specific without compatibility note
  SEVERITY: WARNING

CHECK_C003: Idempotency Flagged
  VERIFY: Non-idempotent operations are documented
  PASS_IF: Idempotent OR non-idempotent flagged clearly
  FAIL_IF: Non-idempotent operations not documented
  SEVERITY: WARNING

CHECK_C004: No Hardcoded Secrets
  VERIFY: No credentials or paths hardcoded
  PASS_IF: Uses environment variables or relative paths
  FAIL_IF: Literal API keys, absolute paths, or credentials
  SEVERITY: BLOCKING
```

**Human-readable:**
- [ ] CHECK_C001: No `allowed-tools` field (not supported)
- [ ] CHECK_C002: Platform-portable OR compatibility documented
- [ ] CHECK_C003: Non-idempotent operations flagged
- [ ] CHECK_C004: No hardcoded secrets or absolute paths

**Gate 4 Result:** [ ] PASS  [ ] FAIL

---

## GATE 5: Anti-Patterns

```
CHECK_A001: No Pre-loaded Content
  VERIFY: References use links, not inline content
  PASS_IF: File links to reference files
  FAIL_IF: Full reference text copied into SKILL.md
  SEVERITY: WARNING

CHECK_A002: Trigger Clarity
  VERIFY: Description includes when to invoke
  PASS_IF: Clear trigger condition in description
  FAIL_IF: Vague "helps with issues" without trigger
  SEVERITY: WARNING

CHECK_A003: Scope Bounded
  VERIFY: Skill does one thing
  PASS_IF: Single focused capability
  FAIL_IF: "review-and-deploy" combined skills
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_A001: No pre-loaded reference content (use links)
- [ ] CHECK_A002: Trigger condition clear in description
- [ ] CHECK_A003: Single focused capability (no combined skills)

**Gate 5 Result:** [ ] PASS  [ ] FAIL

---

## SUMMARY

| Gate | Status | Notes |
|------|--------|-------|
| 1. Structure & Naming | | |
| 2. Content Quality | | |
| 3. Size Limits | | |
| 4. Safety & Compatibility | | |
| 5. Anti-Patterns | | |

**Overall:** [ ] PASS — Ready for deployment  [ ] FAIL — Needs revision

**Blocking Issues:**
- 

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [skill-patterns.md](../PATTERNS/skill-patterns.md) | Rules being verified |
| [RULES.md](../RULES.md) | P1/P2/P3 constraint definitions |
| [NAMING.md](../NAMING.md) | Naming convention details |

---

## SOURCES

- [skill-patterns.md](../PATTERNS/skill-patterns.md) — All RULE_NNN items
- [validation-checklist.md](../../cookbook/TEMPLATES/validation-checklist.md) — Gate format
