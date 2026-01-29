# Instruction Checklist

Validation checklist for instruction files.

---

## Blocking (P1) ❌

- [ ] Correct location (`.github/` or `.github/instructions/`)
- [ ] Correct naming (`copilot-instructions.md` OR `*.instructions.md`)
- [ ] Repo-wide has **NO frontmatter**
- [ ] Path-specific has valid YAML (if present)
- [ ] No secrets, credentials, or internal URLs
- [ ] No placeholder text remaining

---

## Required (P2) ⚠️

- [ ] `applyTo` specified for auto-apply (path-specific)
- [ ] Rules are specific and actionable
- [ ] No persona/identity language
- [ ] Imperative voice ("Use X" not "You should use X")
- [ ] Strong language for safety (NEVER, ALWAYS)
- [ ] Content ≤150 lines

---

## Optional (P3) ✅

- [ ] `name` field for display
- [ ] `description` for UI context
- [ ] `excludeAgent` considered (GitHub.com only)
- [ ] Good/bad code examples included

---

## Quick Pass (5 items)

1. [ ] Correct location and naming
2. [ ] Frontmatter matches type (none for repo-wide)
3. [ ] `applyTo` specified (path-specific)
4. [ ] Rules are actionable
5. [ ] No placeholders remaining

---

## Cross-References

- [PATTERNS.md](PATTERNS.md) — Rules and best practices
- [TEMPLATE.md](TEMPLATE.md) — Format and structure
