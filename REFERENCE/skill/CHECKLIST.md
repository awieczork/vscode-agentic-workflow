# Skill Checklist

Validation checklist for `SKILL.md` files.

---

## Blocking (P1) ❌

Must pass before skill is valid:

- [ ] S001: Name format valid (1-64 chars, `[a-z0-9-]+`, no leading/trailing/consecutive hyphens)
- [ ] S002: `name` field matches parent folder exactly
- [ ] S003: Frontmatter has `name` + `description`
- [ ] S004: Located in `.github/skills/{name}/SKILL.md`
- [ ] S009: File under 500 lines
- [ ] S012: No `allowed-tools` field (experimental, not supported in VS Code)
- [ ] S014: No hardcoded secrets or absolute paths

---

## Required (P2) ⚠️

Should pass for quality:

- [ ] S005: Description uses "{Verb} {what} when {trigger}"
- [ ] S006: Numbered steps with specific actions
- [ ] S007: Error handling with recovery actions
- [ ] S008: Single focused capability (not combined)
- [ ] S010: Content under ~5000 tokens
- [ ] S011: References are single-hop (no nesting)
- [ ] S013: Platform-portable OR compatibility documented
- [ ] S015: Non-idempotent operations flagged

---

## Optional (P3) ✅

Nice to have:

- [ ] S016: Large content in `references/`, not inline
- [ ] S017: Clear trigger ("when X") not vague ("helps with")
- [ ] S018: Destructive ops have exact commands

---

## Quick Pass

Minimum viable skill — check these 5:

1. [ ] `name` + `description` in frontmatter
2. [ ] Name matches folder
3. [ ] Description has verb + trigger
4. [ ] Under 500 lines
5. [ ] No hardcoded secrets

---

## Cross-References

- [README.md](README.md) — Quick start guide
- [PATTERNS.md][patterns] — Rules and best practices
- [TEMPLATE.md][template] — Format and structure
- [TAGS-SKILL.md][tags] — Tag vocabulary

<!-- Reference Links -->
[patterns]: PATTERNS.md
[template]: TEMPLATE.md
[tags]: ../TAGS-SKILL.md
