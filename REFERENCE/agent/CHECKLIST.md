# Agent Checklist

Validation checklist for `.agent.md` files.

---

## Blocking (P1) ❌

Must pass before agent is valid:

- [ ] Agent name not reserved (`ask`, `edit`, `agent`, `plan`, `workspace`, `terminal`, `vscode`)
- [ ] `description` field present in frontmatter
- [ ] `description` is 50-150 characters
- [ ] Identity statement in first paragraph ("You are...")
- [ ] `<safety>` section with P1 constraints
- [ ] `<boundaries>` section with three-tier format
- [ ] Total ≤30,000 characters
- [ ] No placeholder text remaining (`{...}`, `TODO`)

---

## Required (P2) ⚠️

Should pass for quality:

- [ ] `tools` explicitly listed (not relying on default)
- [ ] `<context_loading>` specifies session start files
- [ ] `<modes>` or workflow section present
- [ ] `<outputs>` defines expected deliverables
- [ ] Tools match stated boundaries
- [ ] Handoff targets exist (if handoffs used)
- [ ] MCP tools use correct format (`server/*` or `server/tool`)
- [ ] No vague instructions ("be helpful", "be thorough")
- [ ] No conflicting guidance
- [ ] Total ≤25,000 characters (recommended)

---

## Optional (P3) ✅

Nice to have:

- [ ] `model` specified (VS Code agents)
- [ ] `<stopping_rules>` defined
- [ ] `argument-hint` for input guidance
- [ ] Handoff `send` property considered (default: `false`)
- [ ] Priority hierarchy in safety section
- [ ] ≤300 lines total
- [ ] ≤7 modes defined
- [ ] All XML tags properly closed

---

## Quick Pass

Minimum viable agent — check these 5:

1. [ ] `description` 50-150 chars
2. [ ] Identity in first paragraph
3. [ ] `<safety>` present
4. [ ] `<boundaries>` present
5. [ ] No placeholders remaining

---

## Cross-References

- [README.md](README.md) — Quick start guide
- [PATTERNS.md][patterns] — Rules and best practices
- [TEMPLATE.md][template] — Format and structure
- [TAGS-AGENT.md][tags] — Tag vocabulary

<!-- Reference Links -->
[patterns]: PATTERNS.md
[template]: TEMPLATE.md
[tags]: TAGS-AGENT.md
