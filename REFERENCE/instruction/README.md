# Instruction Reference

Quick reference for `.instructions.md` files.

---

## Files

| File | Purpose | Use When |
|------|---------|----------|
| [PATTERNS.md](PATTERNS.md) | When/why/rules | Deciding if instruction is right choice |
| [TEMPLATE.md](TEMPLATE.md) | Format/structure | Creating new instruction files |
| [CHECKLIST.md](CHECKLIST.md) | Validation | Before committing |

---

## Quick Start

1. **Decide** — Read [PATTERNS.md](PATTERNS.md) to confirm you need an instruction
2. **Create** — Copy template from [TEMPLATE.md](TEMPLATE.md)
3. **Validate** — Check against [CHECKLIST.md](CHECKLIST.md)

---

## Two Instruction Types

| Type | File | Frontmatter | Auto-Apply |
|------|------|-------------|------------|
| **Repo-wide** | `.github/copilot-instructions.md` | ❌ None | ✅ All requests |
| **Path-specific** | `.github/instructions/*.instructions.md` | ✅ YAML | ✅ Via `applyTo` |

---

## Related

- [TAGS-INSTRUCTION.md](../TAGS-INSTRUCTION.md) — Tag vocabulary
