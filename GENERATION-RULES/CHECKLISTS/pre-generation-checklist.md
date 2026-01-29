---
type: checklist
version: 1.0.0
purpose: Validate inputs before generating any component
checklist-for: pre-generation
applies-to: [generator]
last-updated: 2026-01-28
---

# Pre-Generation Checklist

> **Validate spec completeness and constraints before generating any component**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
Run this checklist BEFORE starting generation. Stop if any BLOCKING item fails.

**For Build Agents:**
Ensure pre-generation checks passed before implementing generated specs.

**For Inspect Agents:**
Verify pre-generation checklist was run before auditing generated output.

---

## GATE 1: Spec Completeness

```
CHECK_SC001: Component Type Clear
  VERIFY: Target component type identified
  PASS_IF: One of: agent, skill, instruction, prompt, memory, mcp
  FAIL_IF: Component type unclear or unspecified
  SEVERITY: BLOCKING

CHECK_SC002: Purpose Defined
  VERIFY: What the component should do is clear
  PASS_IF: Clear description of capability/behavior
  FAIL_IF: Vague or missing purpose
  SEVERITY: BLOCKING

CHECK_SC003: No Clarification Markers
  VERIFY: All `[NEEDS CLARIFICATION]` resolved
  PASS_IF: No unresolved markers in spec
  FAIL_IF: Any `[NEEDS CLARIFICATION]` or `[TBD]` present
  SEVERITY: BLOCKING

CHECK_SC004: Acceptance Criteria Present
  VERIFY: How to verify success is defined
  PASS_IF: Testable acceptance criteria
  FAIL_IF: No way to verify component works
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_SC001: Component type is clear (agent/skill/instruction/prompt/memory/mcp)
- [ ] CHECK_SC002: Purpose clearly defined
- [ ] CHECK_SC003: No `[NEEDS CLARIFICATION]` markers
- [ ] CHECK_SC004: Acceptance criteria are testable

**Gate 1 Result:** [ ] PASS  [ ] FAIL

---

## GATE 2: Constraint Validation

```
CHECK_CV001: MUST Constraints Present
  VERIFY: At least one MUST constraint defined
  PASS_IF: Has explicit MUST requirements
  FAIL_IF: No MUST constraints
  SEVERITY: WARNING

CHECK_CV002: MUST NOT Constraints Present
  VERIFY: At least one MUST NOT constraint defined
  PASS_IF: Has explicit MUST NOT prohibitions
  FAIL_IF: No MUST NOT constraints
  SEVERITY: WARNING

CHECK_CV003: Out of Scope Defined
  VERIFY: What NOT to include is documented
  PASS_IF: Out of Scope section not empty
  FAIL_IF: No scope boundaries defined
  SEVERITY: WARNING

CHECK_CV004: Unambiguous Language
  VERIFY: Constraints use clear language
  PASS_IF: Specific, testable constraints
  FAIL_IF: Vague constraints ("should be good")
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_CV001: At least one MUST constraint
- [ ] CHECK_CV002: At least one MUST NOT constraint
- [ ] CHECK_CV003: Out of Scope documented
- [ ] CHECK_CV004: Constraints are specific and testable

**Gate 2 Result:** [ ] PASS  [ ] FAIL

---

## GATE 3: Safety Pre-Check

```
CHECK_SP001: P1 Constraints Identified
  VERIFY: Safety constraints documented
  PASS_IF: P1 constraints explicitly listed if component has tools
  FAIL_IF: Tool-enabled component without P1 constraints
  SEVERITY: BLOCKING

CHECK_SP002: No Credential Requirements
  VERIFY: No hardcoded secrets expected
  PASS_IF: Spec uses env vars for any credentials
  FAIL_IF: Spec expects hardcoded credentials
  SEVERITY: BLOCKING

CHECK_SP003: Scope Appropriate
  VERIFY: Component scope is bounded
  PASS_IF: Clear boundaries on what component can do
  FAIL_IF: Unbounded or unclear scope
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_SP001: P1 constraints listed (if has tools)
- [ ] CHECK_SP002: No hardcoded credentials in spec
- [ ] CHECK_SP003: Component scope is bounded

**Gate 3 Result:** [ ] PASS  [ ] FAIL

---

## GATE 4: Naming Pre-Check

```
CHECK_NP001: Name Proposed
  VERIFY: Component name is specified
  PASS_IF: Name provided in spec
  FAIL_IF: No name suggested
  SEVERITY: WARNING

CHECK_NP002: Name Format Valid
  VERIFY: Name follows naming conventions
  PASS_IF: Lowercase, hyphens, appropriate length
  FAIL_IF: Invalid characters or format
  SEVERITY: WARNING

CHECK_NP003: Name Not Reserved
  VERIFY: Name not in reserved list
  PASS_IF: Not reserved (workspace, terminal, vscode, etc.)
  FAIL_IF: Uses reserved name
  SEVERITY: BLOCKING
```

**Human-readable:**
- [ ] CHECK_NP001: Component name specified
- [ ] CHECK_NP002: Name follows conventions (lowercase, hyphens)
- [ ] CHECK_NP003: Name not reserved

**Gate 4 Result:** [ ] PASS  [ ] FAIL

---

## GATE 5: Cross-Cutting Rules

```
CHECK_CC001: Size Limits Known
  VERIFY: Aware of component size limits
  PASS_IF: Generator knows limits (e.g., agent ≤25k chars)
  FAIL_IF: Size limits not considered
  SEVERITY: WARNING

CHECK_CC002: Related Components Identified
  VERIFY: Dependencies documented
  PASS_IF: Related agents/skills/instructions listed
  FAIL_IF: Dependencies unknown
  SEVERITY: WARNING

CHECK_CC003: Output Location Clear
  VERIFY: Where to create file is known
  PASS_IF: Target directory specified
  FAIL_IF: Output location unclear
  SEVERITY: BLOCKING

CHECK_CC004: Pattern File Referenced
  VERIFY: Correct pattern file for component type
  PASS_IF: Will follow {component}-patterns.md
  FAIL_IF: No pattern file reference
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_CC001: Size limits known for component type
- [ ] CHECK_CC002: Related components identified
- [ ] CHECK_CC003: Output location specified
- [ ] CHECK_CC004: Will follow correct pattern file

**Gate 5 Result:** [ ] PASS  [ ] FAIL

---

## GATE 6: Resource Availability

```
CHECK_RA001: Domain Expertise Level
  VERIFY: Required expertise documented
  PASS_IF: Domain expertise level specified
  FAIL_IF: Unknown expertise requirements
  SEVERITY: WARNING

CHECK_RA002: Dependencies Identified
  VERIFY: External dependencies documented
  PASS_IF: Required packages/tools listed
  FAIL_IF: Dependencies unknown
  SEVERITY: WARNING

CHECK_RA003: Reference Resources Available
  VERIFY: Can access needed references
  PASS_IF: Reference files/URLs accessible
  FAIL_IF: References unavailable
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_RA001: Domain expertise level specified
- [ ] CHECK_RA002: Dependencies identified
- [ ] CHECK_RA003: Reference resources accessible

**Gate 6 Result:** [ ] PASS  [ ] FAIL

---

## SUMMARY

| Gate | Status | Notes |
|------|--------|-------|
| 1. Spec Completeness | | |
| 2. Constraint Validation | | |
| 3. Safety Pre-Check | | |
| 4. Naming Pre-Check | | |
| 5. Cross-Cutting Rules | | |
| 6. Resource Availability | | |

**Overall:** [ ] PASS — Ready to generate  [ ] FAIL — Need more information

**Blocking Issues:**
- 

**Missing Information (Request Before Proceeding):**
- 

---

## QUICK PRE-GENERATION CHECK

Minimal validation for simple components:

```markdown
Before generating, verify:
- [ ] Component type known
- [ ] Purpose clear (what it does)
- [ ] No `[NEEDS CLARIFICATION]` markers
- [ ] Name valid and not reserved
- [ ] Output location specified
- [ ] P1 constraints documented (if has tools)

If ANY fail: request clarification, do NOT proceed.
```

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [COMPONENT-MATRIX.md](../COMPONENT-MATRIX.md) | Component type selection |
| [NAMING.md](../NAMING.md) | Naming conventions |
| [RULES.md](../RULES.md) | P1/P2/P3 constraints |
| [{component}-patterns.md](../PATTERNS/) | Component-specific patterns |

---

## SOURCES

- [validation-checklist.md](../../cookbook/TEMPLATES/validation-checklist.md) — Gate structure
- [COMPONENT-MATRIX.md](../COMPONENT-MATRIX.md) — Component selection
- [RULES.md](../RULES.md) — Constraint hierarchy
