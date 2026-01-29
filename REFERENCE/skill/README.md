# Skill Reference

Quick reference for creating and validating `SKILL.md` files.

---

## Files

| File | Purpose | Use When |
|------|---------|----------|
| [PATTERNS.md](PATTERNS.md) | When/why/rules | Understanding skill design decisions |
| [TEMPLATE.md](TEMPLATE.md) | Format/structure | Creating new skills |
| [CHECKLIST.md](CHECKLIST.md) | Validation | Before deploying skill files |
| [TAGS-SKILL.md](../TAGS-SKILL.md) | Tag vocabulary | Selecting appropriate metadata tags |

---

## Quick Start

1. **Decide** — Read [PATTERNS.md](PATTERNS.md) to confirm you need a skill (not instruction/agent/prompt)
2. **Create** — Copy template from [TEMPLATE.md](TEMPLATE.md)
3. **Fill** — Use [TAGS-SKILL.md](../TAGS-SKILL.md) for valid metadata tags
4. **Validate** — Check against [CHECKLIST.md](CHECKLIST.md) before committing

---

## Rule-to-Check Mapping

| RULE | Checks | Description |
|------|--------|-------------|
| RULE_001 | S003, S005, S017 | Description completeness (WHAT + WHEN) |
| RULE_002 | S009, S010 | Size limits (<500 lines, <5000 tokens) |
| RULE_003 | S001, S002 | Name format and folder matching |
| RULE_004 | S016 | Progressive disclosure (no pre-loading) |
| RULE_005 | S011 | Reference depth (single-hop only) |
| RULE_006 | S006, S007 | Error handling required |
| RULE_007 | S012 | No allowed-tools field |
| RULE_008 | S015 | Idempotency preference |
| RULE_009 | S013 | Platform compatibility |

---

## Decision: Skill vs Other Components

| If you need... | Use | Not Skill |
|----------------|-----|-----------|
| Always-on rules for file types | Instruction | ❌ |
| Persistent persona with handoffs | Agent | ❌ |
| One-shot template with variables | Prompt | ❌ |
| Reusable procedure, any agent | **Skill** | ✅ |

---

## Status

> **Preview Feature:** Requires `chat.useAgentSkills` setting enabled in VS Code.

---

## Related

- [cookbook/CONFIGURATION/skills-format.md](../../cookbook/CONFIGURATION/skills-format.md) — Detailed format reference
- [GENERATION-RULES/PATTERNS/skill-patterns.md](../../GENERATION-RULES/PATTERNS/skill-patterns.md) — Full patterns file
- [.github/skills/](../../.github/skills/) — Live skill examples

**External Resources:**
- [github/awesome-copilot](https://github.com/github/awesome-copilot) — Community skills (19k+ ⭐)
- [agentskills.io](https://agentskills.io/specification) — Open standard specification
- [skills-ref CLI](https://github.com/agentskills/agentskills/tree/main/skills-ref) — Validation tool
