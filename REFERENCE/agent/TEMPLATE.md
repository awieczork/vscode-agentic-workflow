# Agent Template

Format specification and skeleton for `.agent.md` files.

---

## Frontmatter Schema

```yaml
---
description: 'What this agent does'  # REQUIRED: 50-150 chars, single quotes
name: 'Display Name'                  # Optional: shown in UI
tools: ['read', 'search', 'edit']     # Optional: array or '*' for all
model: 'Claude Sonnet 4.5'            # Optional: VS Code only
argument-hint: 'What do you need?'    # Optional: input guidance
handoffs:                              # Optional: VS Code 1.106+
  - label: 'Start Building'            # Button text shown in chat
    agent: 'build'                     # Target agent (without .agent.md)
    prompt: 'Implement the plan above.' # Context for target agent
    send: false                        # false=review first (default), true=auto-send
---
```

---

## Full Template

```markdown
---
description: '{50-150 char purpose}'
name: '{Display Name}'
tools: ['{tool_list}']
model: '{model_name}'
handoffs:
  - label: '{action_label}'
    agent: '{target_agent}'
    prompt: '{context_prompt}'
---

# {Display Name}

> {one line summary}

You are a {role} specialized in {domain}.

**Expertise:** {knowledge areas}

**Stance:** {behavioral approach}

<safety>

**Priority:** Safety > Clarity > Flexibility > Convenience

- Never {critical_constraint}
- Always {required_behavior}

</safety>

<context_loading>

1. {file_1} — {purpose}
2. {file_2} — {purpose}

</context_loading>

<modes>

<mode name="{mode_name}">
**Trigger:** "{activation_phrase}"
**Steps:** {step_1} → {step_2} → {step_3}
**Output:** {expected_deliverable}
</mode>

</modes>

<boundaries>

✅ **Do:** {allowed_actions}
⚠️ **Ask First:** {conditional_actions}
🚫 **Don't:** {prohibited_actions}

</boundaries>

<outputs>

**Conversational:** {short_response_format}
**Deliverables:** `{path}/{naming_pattern}.md`

</outputs>

<stopping_rules>

- {condition_1} → @{target_agent}
- {condition_2} → @{target_agent}
- {condition_3} → Ask user

</stopping_rules>
```

---

## Minimal Template

For simple agents:

```markdown
---
description: '{50-150 char purpose}'
tools: ['{tool_list}']
---

# {Display Name}

You are a {role} specialized in {domain}.

<safety>
- Never {constraint}
- Always {required}
</safety>

<boundaries>
✅ **Do:** {allowed}
🚫 **Don't:** {prohibited}
</boundaries>
```

---

## Placeholders

| Placeholder | Example |
|-------------|---------|
| `{role}` | code reviewer, architect, researcher |
| `{domain}` | security analysis, system design |
| `{tool_list}` | 'read', 'search', 'edit' |
| `{model_name}` | Claude Sonnet 4.5, GPT-5 |
| `{target_agent}` | build, inspect, research |
| `{path}` | workshop/reviews |
| `{naming_pattern}` | review-{NNN}-{date}-{scope} |

---

## Cross-References

- [README.md](README.md) — Quick start guide
- [PATTERNS.md][patterns] — Rules and best practices
- [CHECKLIST.md][checklist] — Validation checklist
- [TAGS-AGENT.md][tags] — Tag vocabulary

<!-- Reference Links -->
[patterns]: PATTERNS.md
[checklist]: CHECKLIST.md
[tags]: TAGS-AGENT.md
