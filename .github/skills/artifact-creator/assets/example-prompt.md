```markdown
<!-- description targets discovery; agent field targets this prompt to a specific agent; argument-hint provides UI guidance -->
---
description: 'Generate comprehensive test cases for selected code'
agent: 'test-engineer'
argument-hint: 'Select the code you want to generate tests for'
---
Generate comprehensive test cases for the provided code.

<context>

Analyze the selected code: ${selection}

Review existing test patterns using #tool:search to find similar test files in the codebase.

Reference the project testing conventions: [testing-guide.md](../docs/testing-guide.md)

</context>

<!-- task section uses bullet lists for clear, scannable requirements the agent can check off -->
<task>

Generate test cases that cover:

- Happy path scenarios with expected inputs and outputs
- Edge cases: empty inputs, boundary values, null/undefined
- Error scenarios: invalid inputs, network errors, permission errors

</task>

<format>

- Use the same test framework and assertion library as existing tests
- Follow the naming convention: `describe('[ModuleName]', () => { it('should [behavior]', ...) })`
- Group tests by function or method under `describe` blocks
- Include setup and teardown when shared state is needed

</format>
```
