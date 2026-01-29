---
type: checklist
version: 1.0.0
purpose: Validate prompt files against prompt-patterns.md rules
checklist-for: prompt
applies-to: [generator, build, inspect]
last-updated: 2026-01-28
---

# Prompt Checklist

> **Validate `.prompt.md` files against framework rules before deployment**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
Run this checklist after creating any prompt file. All BLOCKING items must pass.

**For Build Agents:**
Validate generated prompts before committing. Fix any failures before proceeding.

**For Inspect Agents:**
Use this checklist as verification criteria. Report failures with specific rule IDs.

---

## GATE 1: Structure & Frontmatter

```
CHECK_S001: Frontmatter Minimum
  VERIFY: Has YAML frontmatter with required fields
  PASS_IF: Has `agent` AND `description` fields
  FAIL_IF: Empty frontmatter or missing required fields
  SEVERITY: BLOCKING

CHECK_S002: Description Present
  VERIFY: Description field has clear purpose
  PASS_IF: `description` explains what prompt does
  FAIL_IF: Missing or vague description
  SEVERITY: WARNING

CHECK_S003: Title Present
  VERIFY: Has markdown title
  PASS_IF: `# Title` heading present in body
  FAIL_IF: Missing title
  SEVERITY: WARNING

CHECK_S004: Body Content
  VERIFY: Has clear instruction content
  PASS_IF: Clear instruction in body section
  FAIL_IF: Empty or unclear body
  SEVERITY: BLOCKING
```

**Human-readable:**
- [ ] CHECK_S001: Frontmatter has `agent` + `description`
- [ ] CHECK_S002: Description clearly states purpose
- [ ] CHECK_S003: Has `# Title` heading
- [ ] CHECK_S004: Body has clear instructions

**Gate 1 Result:** [ ] PASS  [ ] FAIL

---

## GATE 2: Single Purpose & Scope

```
CHECK_P001: Single Purpose
  VERIFY: One workflow per prompt file
  PASS_IF: Prompt does one thing
  FAIL_IF: Multiple unrelated tasks in one prompt
  SEVERITY: WARNING

CHECK_P002: Positive Instructions
  VERIFY: Instructions state what TO DO
  PASS_IF: Positive framing ("Write tests")
  FAIL_IF: Framed as "don't" or "avoid"
  SEVERITY: WARNING

CHECK_P003: Context Budget
  VERIFY: File references are phased
  PASS_IF: ≤3 file links per phase
  FAIL_IF: >3 large file links without phasing
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_P001: Single purpose (not "review-and-deploy")
- [ ] CHECK_P002: Positive framing (what TO DO)
- [ ] CHECK_P003: ≤3 file links per phase

**Gate 2 Result:** [ ] PASS  [ ] FAIL

---

## GATE 3: Variable Handling

```
CHECK_V001: Valid Variables
  VERIFY: Uses only documented variables
  PASS_IF: Uses `${selection}`, `${currentFile}`, etc.
  FAIL_IF: Uses `${undocumentedVar}` custom variables
  SEVERITY: WARNING

CHECK_V002: Empty Selection Handling
  VERIFY: Handles empty `${selection}` case
  PASS_IF: Prompt works when nothing is selected
  FAIL_IF: Assumes selection exists without fallback
  SEVERITY: WARNING

CHECK_V003: File Links Relative
  VERIFY: File paths are relative or use variables
  PASS_IF: Relative paths or `${workspaceFolder}`
  FAIL_IF: Hardcoded absolute paths
  SEVERITY: BLOCKING
```

**Human-readable:**
- [ ] CHECK_V001: Only documented `${}` variables used
- [ ] CHECK_V002: Handles empty `${selection}` gracefully
- [ ] CHECK_V003: File links relative (no absolute paths)

**Gate 3 Result:** [ ] PASS  [ ] FAIL

---

## GATE 4: Safety Gates

```
CHECK_G001: Destructive Action Gate
  VERIFY: Has checkpoint before destructive actions
  PASS_IF: 🚨 STOP checkpoint before file deletion, mass changes
  FAIL_IF: Complex multi-step prompt with no checkpoints
  SEVERITY: BLOCKING

CHECK_G002: Not Handoff Target
  VERIFY: Prompt not referenced in agent handoffs
  PASS_IF: Not used as handoff target
  FAIL_IF: Referenced in agent handoff configurations
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_G001: Has STOP checkpoint before destructive actions
- [ ] CHECK_G002: Not used as agent handoff target

**Gate 4 Result:** [ ] PASS  [ ] FAIL

---

## GATE 5: Anti-Patterns

```
CHECK_A001: No Empty Frontmatter
  VERIFY: Frontmatter has content
  PASS_IF: Frontmatter contains actual fields
  FAIL_IF: Only `---\n---` with no content
  SEVERITY: BLOCKING

CHECK_A002: No Multi-Purpose Names
  VERIFY: Filename indicates single purpose
  PASS_IF: Single action name (e.g., "review.prompt.md")
  FAIL_IF: Combined names ("review-and-deploy.prompt.md")
  SEVERITY: WARNING

CHECK_A003: VS Code Syntax
  VERIFY: Uses VS Code file reference syntax
  PASS_IF: Uses `[text](path)` markdown links
  FAIL_IF: Uses `#file:path` Visual Studio syntax
  SEVERITY: WARNING

CHECK_A004: Reasonable File Count
  VERIFY: Not loading too many files
  PASS_IF: ≤4 large files total
  FAIL_IF: 5+ large files without phasing strategy
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_A001: Frontmatter not empty
- [ ] CHECK_A002: Single-purpose filename
- [ ] CHECK_A003: Uses VS Code syntax (not `#file:`)
- [ ] CHECK_A004: ≤4 large files (or phased loading)

**Gate 5 Result:** [ ] PASS  [ ] FAIL

---

## SUMMARY

| Gate | Status | Notes |
|------|--------|-------|
| 1. Structure & Frontmatter | | |
| 2. Single Purpose & Scope | | |
| 3. Variable Handling | | |
| 4. Safety Gates | | |
| 5. Anti-Patterns | | |

**Overall:** [ ] PASS — Ready for deployment  [ ] FAIL — Needs revision

**Blocking Issues:**
- 

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [prompt-patterns.md](../PATTERNS/prompt-patterns.md) | Rules being verified |
| [RULES.md](../RULES.md) | P1/P2/P3 constraint definitions |
| [agent-checklist.md](agent-checklist.md) | Agents invoke prompts |

---

## SOURCES

- [prompt-patterns.md](../PATTERNS/prompt-patterns.md) — All RULE_NNN items
- [validation-checklist.md](../../cookbook/TEMPLATES/validation-checklist.md) — Gate format
