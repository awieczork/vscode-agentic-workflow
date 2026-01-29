# Agent Tags

Tag vocabulary for `.agent.md` files.

---

## Required

```yaml
role: Identity + expertise + stance (2-3 paragraphs)
safety: Priority hierarchy + P1 hard limits
boundaries: "✅ Do / ⚠️ Ask First / 🚫 Don't"
```

## Recommended ⭐

These make agents significantly more effective:

```yaml
context_loading: Files to read at session start (ordered priority)
modes: Behavioral variations (trigger → steps → output)
outputs: Format specs, naming conventions, file locations
stopping_rules: When to hand off or stop (trigger → action)
when_blocked: What to do when stuck (surface blockers, propose options)
examples: Few-shot demonstrations of expected behavior
```

## Optional

Use when the agent needs specialized behavior:

```yaml
handoffs: Target agent + context to pass
tools: When/how to use specific tools (priority, fallbacks)
evolution: Friction reporting format for self-improvement
constraints: Token limits, response length, scope boundaries
personality: Tone, voice, communication style
```

---

## Examples

**role** — flat, no nesting needed:
```markdown
<role>
You are a code reviewer focused on security and maintainability.

**Expertise:** Security patterns, OWASP, clean code principles.

**Stance:** Thorough but constructive — find issues, suggest fixes.
</role>
```

**safety** — nest when grouping related items:
```markdown
<safety>
**Priority:** Safety > Clarity > Flexibility > Convenience

<p1_rules>
- Never approve code with known vulnerabilities
- Never fabricate security issues
</p1_rules>
</safety>
```

**modes** — nest to define each mode:
```markdown
<modes>

<mode name="quick-review">
**Trigger:** Small PR, <100 lines
**Output:** Inline comments only
</mode>

<mode name="deep-review">
**Trigger:** Large PR or security-sensitive
**Output:** Full report + inline comments
</mode>

</modes>
```

**boundaries** — flat works fine:
```markdown
<boundaries>
✅ **Do:** Review code, suggest improvements, explain issues
⚠️ **Ask First:** Before suggesting architectural changes
🚫 **Don't:** Auto-apply fixes without approval
</boundaries>
```

---

## Cross-References

- [README.md](README.md) — Quick start guide
- [PATTERNS.md][patterns] — Rules and best practices
- [TEMPLATE.md][template] — Format and structure
- [CHECKLIST.md][checklist] — Validation checklist

<!-- Reference Links -->
[patterns]: PATTERNS.md
[template]: TEMPLATE.md
[checklist]: CHECKLIST.md
