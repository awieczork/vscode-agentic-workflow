---
type: checklist
version: 1.0.0
purpose: Validate memory bank files against memory-patterns.md rules
checklist-for: memory
applies-to: [generator, build, inspect]
last-updated: 2026-01-28
---

# Memory Checklist

> **Validate memory bank structure and files against framework rules**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
Run this checklist after creating/updating memory bank files. All BLOCKING items must pass.

**For Build Agents:**
Validate memory bank structure before committing. Fix any failures before proceeding.

**For Inspect Agents:**
Use this checklist as verification criteria. Report failures with specific rule IDs.

---

## GATE 1: Directory Structure

```
CHECK_D001: Memory Bank Exists
  VERIFY: Memory bank directory present
  PASS_IF: `.github/memory-bank/` directory exists
  FAIL_IF: Missing memory bank directory
  SEVERITY: BLOCKING

CHECK_D002: Core Files Present
  VERIFY: Required files exist
  PASS_IF: `global/projectbrief.md`, `sessions/_active.md`, `decisions.md` present
  FAIL_IF: Missing any required file
  SEVERITY: WARNING

CHECK_D003: Directory Organization
  VERIFY: Proper tier directories
  PASS_IF: `global/`, `sessions/` subdirectories present
  FAIL_IF: Flat structure without organization
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_D001: `.github/memory-bank/` directory exists
- [ ] CHECK_D002: Core files present (projectbrief, _active, decisions)
- [ ] CHECK_D003: Has `global/` and `sessions/` subdirectories

**Gate 1 Result:** [ ] PASS  [ ] FAIL

---

## GATE 2: Timestamp Requirements

```
CHECK_T001: Timestamps Present
  VERIFY: Every memory file has timestamp
  PASS_IF: `Last Updated: {ISO8601}` in every file
  FAIL_IF: Any memory file missing timestamp
  SEVERITY: BLOCKING

CHECK_T002: Timestamp Currency
  VERIFY: Timestamps reflect recent activity
  PASS_IF: Active project: updated within 30 days; Inactive: documented pause
  FAIL_IF: Active project with >30 days since last update AND no pause documented
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_T001: Every file has `Last Updated:` timestamp
- [ ] CHECK_T002: Timestamps reasonably current

**Gate 2 Result:** [ ] PASS  [ ] FAIL

---

## GATE 3: File Content Rules

```
CHECK_C001: Decisions Append-Only
  VERIFY: Decision entries not modified
  PASS_IF: `decisions.md` entries only added, never edited
  FAIL_IF: Existing ADR entry was modified or deleted
  SEVERITY: BLOCKING

CHECK_C002: Session State Location
  VERIFY: Current session state in correct file
  PASS_IF: Session state in `sessions/_active.md` only
  FAIL_IF: Session state scattered across multiple files
  SEVERITY: WARNING

CHECK_C003: Frozen Files Stable
  VERIFY: Global files rarely change
  PASS_IF: `global/*.md` changes only on significant events
  FAIL_IF: Frequent edits to projectbrief.md
  SEVERITY: WARNING

CHECK_C004: No Credentials
  VERIFY: No secrets in memory files
  PASS_IF: Environment variables or placeholders used
  FAIL_IF: API keys, passwords, or credentials present
  SEVERITY: BLOCKING

CHECK_C005: No Large Code Snippets
  VERIFY: References instead of raw code
  PASS_IF: File paths instead of code blocks
  FAIL_IF: Large code snippets stored in memory files
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_C001: Decisions only added, never modified
- [ ] CHECK_C002: Session state in `_active.md` only
- [ ] CHECK_C003: Global files change rarely
- [ ] CHECK_C004: No credentials in memory files
- [ ] CHECK_C005: References to code, not raw snippets

**Gate 3 Result:** [ ] PASS  [ ] FAIL

---

## GATE 4: Session Handoff

```
CHECK_H001: Active Focus Section
  VERIFY: `_active.md` has Active Focus
  PASS_IF: Active Focus section present with current context
  FAIL_IF: Missing Active Focus section
  SEVERITY: WARNING

CHECK_H002: Next Steps Section
  VERIFY: `_active.md` has Next Steps
  PASS_IF: Next Steps section with actionable items
  FAIL_IF: Missing Next Steps section
  SEVERITY: WARNING

CHECK_H003: Blockers Documented
  VERIFY: Blockers section present
  PASS_IF: Blockers section (or explicit "None")
  FAIL_IF: No blockers documentation
  SEVERITY: WARNING

CHECK_H004: Session End Update
  VERIFY: Handoff before session end
  PASS_IF: `_active.md` updated before session ends
  FAIL_IF: Session ends without handoff update
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_H001: Has Active Focus section
- [ ] CHECK_H002: Has Next Steps section
- [ ] CHECK_H003: Blockers documented (or "None")
- [ ] CHECK_H004: Updated before session end

**Gate 4 Result:** [ ] PASS  [ ] FAIL

---

## GATE 5: Loading Rules

```
CHECK_L001: Mandatory Loading
  VERIFY: Agent instructions require memory loading
  PASS_IF: Memory loading described as MUST
  FAIL_IF: Memory loading described as optional
  SEVERITY: WARNING

CHECK_L002: Tier-Appropriate Loading
  VERIFY: Loading matches utilization
  PASS_IF: <60% utilization: HOT+WARM; >60%: HOT only
  FAIL_IF: Loading all files regardless of utilization
  SEVERITY: WARNING

CHECK_L003: Frozen Excerpts
  VERIFY: Large frozen files load excerpts
  PASS_IF: Specific sections loaded, not full files
  FAIL_IF: Full projectbrief.md (500+ lines) loaded entirely
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_L001: Memory loading is mandatory (not optional)
- [ ] CHECK_L002: Tier-appropriate loading based on utilization
- [ ] CHECK_L003: Large frozen files load excerpts only

**Gate 5 Result:** [ ] PASS  [ ] FAIL

---

## GATE 6: Anti-Patterns

```
CHECK_A001: No Upfront Loading
  VERIFY: Progressive loading pattern
  PASS_IF: Context loaded on-demand
  FAIL_IF: All tiers loaded at session start
  SEVERITY: WARNING

CHECK_A002: No Edit of Decisions
  VERIFY: Decision file integrity
  PASS_IF: Existing ADR entries unchanged
  FAIL_IF: Modifications to existing decision entries
  SEVERITY: BLOCKING

CHECK_A003: Handoff Before End
  VERIFY: Session handoff completed
  PASS_IF: `_active.md` updated with current state
  FAIL_IF: Session ends without handoff
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_A001: Progressive loading (not all upfront)
- [ ] CHECK_A002: Decision entries never edited
- [ ] CHECK_A003: Handoff completed before session end

**Gate 6 Result:** [ ] PASS  [ ] FAIL

---

## SUMMARY

| Gate | Status | Notes |
|------|--------|-------|
| 1. Directory Structure | | |
| 2. Timestamp Requirements | | |
| 3. File Content Rules | | |
| 4. Session Handoff | | |
| 5. Loading Rules | | |
| 6. Anti-Patterns | | |

**Overall:** [ ] PASS — Memory bank valid  [ ] FAIL — Needs revision

**Blocking Issues:**
- 

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [memory-patterns.md](../PATTERNS/memory-patterns.md) | Rules being verified |
| [RULES.md](../RULES.md) | P1/P2/P3 constraint definitions |
| [agent-checklist.md](agent-checklist.md) | Agents load memory |

---

## SOURCES

- [memory-patterns.md](../PATTERNS/memory-patterns.md) — All RULE_NNN items
- [validation-checklist.md](../../cookbook/TEMPLATES/validation-checklist.md) — Gate format
