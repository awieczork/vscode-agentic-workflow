# Prompt Tags

Tag vocabulary for `.prompt.md` — reusable parameterized templates.

---

## Required

```yaml
context: Background information (variables, file refs, situation)
task: Clear imperative instruction (single goal, verb-first)
format: Expected output structure (markdown template or schema)
```

## Recommended ⭐

Make prompts predictable and reusable.

```yaml
variables: Parameter definitions (name, source, description)
examples: Few-shot demonstrations (input/output pairs)
constraints: Limits on output (length, style, scope)
```

## Optional

For advanced prompt engineering.

```yaml
role: Persona for the response (if not using an agent)
chain_of_thought: Whether to show reasoning steps
fallback: What to do if primary approach fails
temperature: Creativity level hint (precise/balanced/creative)
```

---

## Examples

**Built-in variables** — use `${name}` syntax:
```markdown
<context>
Reviewing ${file} in ${workspaceFolder}.

Selected code:
${selection}
</context>
```

Available: `${file}`, `${fileBasename}`, `${fileDirname}`, `${selection}`, `${workspaceFolder}`, `${workspaceFolderBasename}`

**User input variables** — prompt at runtime:
```markdown
<task>
Create a component named ${input:componentName:Enter component name}
</task>
```

**context** — provide background:
```markdown
<context>
This is a ${fileBasename} file in a TypeScript project.
The user has selected the following code:
${selection}
</context>
```

**task** — single clear goal:
```markdown
<task>
Identify bugs, security issues, and improvements.
Provide line-by-line feedback with fixes.
</task>
```

**format** — show expected structure:
```markdown
<format>
## Issues Found
- **Line X**: [Issue] → [Fix]

## Improvements
- [Suggestion with code]
</format>
```

**constraints** — flat list:
```markdown
<constraints>
- Focus on selected code only
- Maximum 5 issues
- Keep suggestions actionable
</constraints>
```
