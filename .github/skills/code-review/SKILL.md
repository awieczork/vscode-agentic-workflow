---
name: code-review
description: Review code changes for quality, security, and best practices. Invoke when reviewing PRs, staged changes, or code before commit.
metadata:
  author: vscode_agentic_workflow
  version: "1.0.0"
  tags: [code-quality, security, review, best-practices]
---

# Code Review

Review code changes for quality, security vulnerabilities, and adherence to best practices.

## Overview

This skill performs a structured code review covering:
- **Quality:** Readability, maintainability, complexity
- **Security:** Common vulnerabilities, credential exposure, injection risks
- **Best Practices:** Language idioms, patterns, naming conventions

## Steps

1. **Gather changes to review**
   - If reviewing staged changes: `git diff --cached`
   - If reviewing a PR: `gh pr diff {pr-number}`
   - If reviewing specific files: Read the file contents

2. **Analyze code quality**
   - Check function/method length (flag if > 50 lines)
   - Identify deeply nested logic (> 3 levels)
   - Look for code duplication
   - Assess naming clarity (variables, functions, classes)

3. **Check for security issues**
   - Scan for hardcoded secrets/credentials
   - Identify SQL injection vulnerabilities (string concatenation in queries)
   - Check for XSS risks (unescaped user input)
   - Flag unsafe deserialization
   - Verify input validation on user-provided data

4. **Verify best practices**
   - Check error handling completeness
   - Verify logging is appropriate (not excessive, not missing)
   - Assess test coverage implications
   - Check for magic numbers/strings (should be constants)

5. **Generate review report**
   - Categorize findings: 🔴 Critical, 🟡 Warning, 🔵 Suggestion
   - Include file path and line numbers
   - Provide specific remediation guidance

## Error Handling

If git diff fails: Check if inside a git repository, report if not.
If no changes found: Report "No changes to review" and stop.
If gh CLI not authenticated: Suggest running `gh auth login` first.
If file not found: Report which file is missing and continue with remaining files.

## Output Format

```markdown
## Code Review Summary

**Files Reviewed:** {count}
**Findings:** 🔴 {critical} | 🟡 {warnings} | 🔵 {suggestions}

### Critical Issues
{List with file:line and description}

### Warnings
{List with file:line and description}

### Suggestions
{List with file:line and description}

### Summary
{Overall assessment and recommended actions}
```

## Validation

Review is complete when:
- [ ] All changed files have been examined
- [ ] Security checklist has been applied
- [ ] Findings are categorized by severity
- [ ] Each finding includes remediation guidance
