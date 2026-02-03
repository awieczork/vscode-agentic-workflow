# Example: Code Review Prompt

Full working prompt demonstrating tools array, agent field, variables, and XML body structure.

---

```markdown
---
description: "Review selected code for bugs, security issues, and improvements"
name: "code-review"
argument-hint: "Select code to review, then describe focus areas"
agent: "agent"
tools: ["codebase", "fetch_webpage"]
---

# Code Review

<context>

Reviewing code in ${workspaceFolder}.

**File:** ${file}

**Selected code:**
```
${selection}
```

**Review focus:** ${input:focus:What aspects should I focus on? (security, performance, readability)}

</context>

<task>

Analyze the selected code and provide a thorough review:

1. Identify bugs, logic errors, and edge cases
2. Flag security vulnerabilities (injection, auth, data exposure)
3. Suggest performance improvements
4. Recommend readability and maintainability enhancements

Use #tool:codebase to search for related code patterns in the repository.

</task>

<format>

## Review Summary

**Risk Level:** [High/Medium/Low]

## Issues Found

- **Line X**: [Issue description] → [Suggested fix]

## Security Concerns

- [Vulnerability]: [Explanation and mitigation]

## Improvements

- [Suggestion with code example]

## Related Patterns

[Links to similar code in the repository]

</format>

<constraints>

- Focus only on selected code, not entire file
- Maximum 5 issues per category
- Provide actionable fixes, not just observations
- Do not modify files — analysis only

</constraints>
```

---

## Why This Example Works

**Pattern → Purpose:**

- `agent: "agent"` + `tools:` → Demonstrates explicit mode setting when tools specified (P2 requirement)
- `tools: ["codebase", "fetch_webpage"]` → Shows tool whitelist restricting access to specific capabilities
- `${selection}` in context → Shows selection variable capturing user's highlighted code
- `${file}` for location → Shows file variable providing path context
- `${input:focus:...}` → Shows user-input variable with placeholder hint for runtime customization
- `#tool:codebase` in task → Shows tool reference syntax for inline documentation
- `<constraints>` with "analysis only" → Reinforces read-only behavior despite agent mode access

**Demonstrates:**

- All 4 XML body sections (`<context>`, `<task>`, `<format>`, `<constraints>`)
- All 3 variable categories used (file, selection, user-input)
- Tool whitelist pattern with explicit agent mode
- Single-purpose task (review) with structured output format
- Constraint that limits scope despite having tool access
