# Instruction Tags

Tag vocabulary for `.instructions.md` — persistent rules without persona.

---

## Required

```yaml
rules: Numbered constraints (RULE_NNN with level + rationale)
```

## Recommended ⭐

Make rules actionable and clear.

```yaml
important: P1 rules emphasized (ALWAYS/NEVER imperatives)
examples: Correct/incorrect code pairs
rationale: Why these rules exist (context for overrides)
```

## Optional

For complex rule sets.

```yaml
exceptions: When rules don't apply
related: Links to relevant docs or patterns
```

---

## Examples

**rules** — nest each rule:
```markdown
<rules>

<rule id="RULE_001" level="P1">
**Statement:** Always use strict TypeScript
**Rationale:** Catches errors at compile time
</rule>

<rule id="RULE_002" level="P2">
**Statement:** Prefer named exports
**Rationale:** Improves refactoring support
</rule>

</rules>
```

**important** — flat, imperative:
```markdown
<important>
NEVER disable TypeScript strict mode.
NEVER use `any` without documented justification.
</important>
```

**examples** — show correct vs incorrect:
```markdown
<examples>

<example type="correct">
export const MyComponent: FC<Props> = ({ name }) => ...
</example>

<example type="incorrect">
export default function(props) ...
</example>

</examples>
```
