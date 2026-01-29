# Checklist Tags

Tag vocabulary for `CHECKLIST.md` files — validation gates.

---

## Required

```yaml
gate: Category grouping (named section containing checks)
check: Individual validation (ID, verify, pass_if, fail_if, severity)
```

## Recommended ⭐

Make checklists actionable and prioritized.

```yaml
blocking: P1 checks that halt on fail (list of check IDs)
summary: Quick overview (gate/check counts)
quick_pass: Fast-path checks for common cases
```

## Optional

For complex validation flows.

```yaml
dependencies: Checks that must pass before this one
auto_fix: Suggested remediation for failures
skip_conditions: When to skip this check
```

---

## Examples

**gate with checks** — nest checks inside gates:
```markdown
<gate name="Structure" id="GATE_1">

<check id="CHECK_S001" severity="P1">
**Verify:** description field present
**Pass if:** 50-150 characters
**Fail if:** missing or wrong length
</check>

<check id="CHECK_S002" severity="P2">
**Verify:** Identity statement present
**Pass if:** First paragraph defines role
**Fail if:** No clear identity
</check>

</gate>
```

**blocking** — flat list of critical checks:
```markdown
<blocking>
- CHECK_S001
- CHECK_C001
- CHECK_C003
</blocking>
```

**summary** — counts for quick scan:
```markdown
<summary>
- **Structure:** 5 checks (2 blocking)
- **Content:** 8 checks (3 blocking)
</summary>
```
