# Skill Template

Format specification and skeleton for `SKILL.md` files.

---

## Frontmatter Schema

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | Yes | 1-64 chars, `[a-z0-9-]+`, must match folder |
| `description` | Yes | 1-1024 chars, WHAT + WHEN formula |
| `license` | No | License name or "See LICENSE.txt" |
| `compatibility` | No | 1-500 chars, environment requirements |
| `metadata` | No | Arbitrary key-value pairs |

```yaml
---
name: 'skill-name'                    # REQUIRED: matches folder, 1-64 chars
description: 'Verb what when trigger' # REQUIRED: 1-1024 chars
license: 'MIT'                        # Optional: license name
compatibility: 'Requires Node.js 18+' # Optional: runtime requirements (1-500 chars)
metadata:                             # Optional: arbitrary pairs
  author: 'your-org'
  version: '1.0.0'
  tags: ['database', 'migration']
---
```

---

## Full Template

```markdown
---
name: '{skill-name}'
description: '{Verb} {what} when {trigger}'
license: '{license}'
compatibility: '{requirements}'
metadata:
  author: '{author}'
  version: '{version}'
  tags: [{tags}]
---

# {Skill Title}

{One-line summary.}

## Steps

1. {Step with command if applicable}
2. {Next step}
3. {Continue as needed}

## Error Handling

If {condition}: {recovery action}
If {condition}: {recovery action}

## Reference Files

- [Guide](references/guide.md) — Brief description

## Validation

Before complete:
- [ ] {Check 1}
- [ ] {Check 2}
```

---

## Minimal Template

```markdown
---
name: '{skill-name}'
description: '{Verb} {what} when {trigger}'
---

# {Skill Title}

{Summary.}

## Steps

1. {Step 1}
2. {Step 2}

## Error Handling

If {condition}: {action}
```

---

## Placeholders

| Placeholder | Example |
|-------------|---------|
| `{skill-name}` | database-migration |
| `{Verb}` | Run, Fix, Create, Review |
| `{what}` | database migrations, GitHub issue |
| `{trigger}` | when schema changes, when asked |
| `{requirements}` | Requires Node.js, Prisma CLI |
| `{author}` | your-org |
| `{version}` | 1.0.0 |

---

## Cross-References

- [README.md](README.md) — Quick start guide
- [PATTERNS.md][patterns] — Rules and best practices
- [CHECKLIST.md][checklist] — Validation checklist
- [TAGS-SKILL.md][tags] — Tag vocabulary

<!-- Reference Links -->
[patterns]: PATTERNS.md
[checklist]: CHECKLIST.md
[tags]: ../TAGS-SKILL.md
