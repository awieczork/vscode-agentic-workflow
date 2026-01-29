---
type: patterns
version: 1.0.0
purpose: THE framework approach for building skills — portable, on-demand capabilities
applies-to: [generator, build, inspect]
last-updated: 2026-01-28
---

# Skill Patterns

> **Skills are portable, on-demand capabilities loaded when invoked, not pre-loaded.**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
1. Use STRUCTURE section to generate SKILL.md files
2. Apply AUTHORING RULES to validate content
3. Select DEGREE OF FREEDOM matching task fragility

**For Build Agents:**
1. Follow STRUCTURE exactly when creating skills
2. Validate against VALIDATION CHECKLIST before completion
3. Ensure cross-platform compatibility

**For Inspect Agents:**
1. Verify SKILL.md against AUTHORING RULES
2. Check size limits (500 lines / 5000 tokens)
3. Flag anti-patterns

---

## PURPOSE

Skills solve two problems:

| Problem | How Skills Solve It |
|---------|---------------------|
| **Context budget bloat** | Loaded on-demand when invoked, not pre-loaded |
| **Workflow reusability** | Portable across VS Code, Claude Code, Cursor |

**Skills are:**
- Self-contained capability packages
- Loaded dynamically when an agent invokes them
- Portable across platforms supporting agentskills.io

**Skills are NOT:**
- Pre-loaded context (use instructions for that)
- Persistent state containers (use memory-bank)
- Collections (which are distribution manifests)

---

## THE FRAMEWORK APPROACH

**One skill = One capability.** Skills follow the [agentskills.io](https://agentskills.io/specification) open standard.

```
CANONICAL_STRUCTURE:
  {skill-name}/
  ├── SKILL.md          # REQUIRED — entry point with instructions
  ├── scripts/          # Optional — executable code
  ├── references/       # Optional — documentation for JIT loading
  └── assets/           # Optional — templates, data files
```

**Location Decision Tree:**

```
WHERE_TO_PUT_SKILL:
  IF creating for your project
    THEN → .github/skills/{skill-name}/
  ELSE IF creating for personal use across projects
    THEN → ~/.copilot/skills/{skill-name}/
  ELSE IF contributing to awesome-copilot
    THEN → skills/{skill-name}/  (root-level, NOT .github/)
```

---

## STRUCTURE

### Required Sections

| Section | Purpose | Required |
|---------|---------|----------|
| YAML Frontmatter | Metadata for discovery | ✅ |
| H1 Title | Human-readable name | ✅ |
| Overview | What the skill does | ✅ |
| Steps | Execution sequence | ✅ for task skills |
| Error Handling | How failures are managed | ✅ |
| Validation | How to verify success | ⚠️ Recommended |
| Reference Files | Links to detailed docs | ⚠️ If using JIT |

### Section Order

```
1. YAML Frontmatter
2. H1 Title
3. Overview (1-2 sentences)
4. Steps (numbered)
5. Error Handling
6. Reference Files (if any)
7. Validation (if applicable)
```

### SKILL.md Template

```yaml
---
name: {skill-name}
description: {1-1024 chars: capability AND when to use}
license: {optional: license name}
compatibility: {optional: requirements, max 500 chars}
metadata:
  author: {optional}
  version: "{optional: semver}"
  tags: [{optional: discovery tags}]
---

# {Skill Title}

{One-line description of what this skill does.}

## Steps

1. {First step — include commands if applicable}
2. {Second step}
3. {Continue as needed}

## Error Handling

If {failure condition}: {recovery action}
If {another failure}: {recovery action}

## Reference Files

- [{Reference Name}](references/{file}.md)

## Validation

Run `{validation command}` to verify success.
```

---

## AUTHORING RULES

### RULE_001: Size Limits
```
REQUIRE: SKILL.md body < 500 lines AND < 5000 tokens
REJECT_IF: SKILL.md exceeds limits
RATIONALE: Context window is shared; bloated skills starve other context
ESCAPE_HATCH: If exceeding, decompose into SKILL.md + scripts/ + references/
```

### RULE_002: Name Matching
```
REQUIRE: `name` field MUST match parent folder name
REJECT_IF: name: "fix-issue" but folder is "fixIssue/"
RATIONALE: Tooling and discovery depend on name-folder alignment
EXAMPLE_VALID: fix-issue/SKILL.md with name: fix-issue
EXAMPLE_INVALID: fix-issue/SKILL.md with name: fixIssue
```

### RULE_003: Name Format
```
REQUIRE: name is 1-64 chars, lowercase alphanumeric + hyphens
REJECT_IF: consecutive hyphens, starts/ends with hyphen, uppercase
RATIONALE: Cross-platform compatibility, URL-safe
EXAMPLE_VALID: database-migration
EXAMPLE_INVALID: Database_Migration, fix--issue, -fix-issue
```

### RULE_004: Description Completeness
```
REQUIRE: description (1-1024 chars) states capability AND trigger
REJECT_IF: description only says what, not when
RATIONALE: Agent must know WHEN to invoke, not just WHAT it does
EXAMPLE_VALID: "Fix a GitHub issue by reading it and implementing the solution"
EXAMPLE_INVALID: "Fixes issues" (no trigger context)
```

### RULE_005: No Tool Restrictions in Skill
```
REQUIRE: Do NOT use `allowed-tools` in SKILL.md frontmatter
REJECT_IF: allowed-tools field present
RATIONALE: NOT supported in VS Code; use agent-level tool restrictions
```

### RULE_006: Progressive Disclosure Depth
```
REQUIRE: References are ONE level deep only
REJECT_IF: SKILL.md → file → file (nested references)
RATIONALE: Complexity explosion; hard to trace context loading
EXAMPLE_VALID: SKILL.md links to references/guide.md
EXAMPLE_INVALID: references/guide.md links to references/details.md
```

### RULE_007: Error Handling Required
```
REQUIRE: Every skill documents error handling
REJECT_IF: No failure modes or recovery actions documented
RATIONALE: Silent failures erode trust; partial state corrupts
MINIMUM: "If {X} fails, {Y}" for each critical step
```

### RULE_008: Platform Compatibility
```
REQUIRE: Skills are portable by default; platform-specific skills document requirements
REJECT_IF: Uses platform-specific constructs without compatibility note
RATIONALE: Teams are mixed OS; Windows-only skill breaks on Mac
PORTABLE: Use forward slashes, sh-compatible scripts, cross-platform tools
PLATFORM_SPECIFIC: Add compatibility: "Requires Windows/PowerShell"
```

### RULE_009: Idempotency Preference
```
PREFER: Skills SHOULD be idempotent (re-runnable without side effects)
DOCUMENT_IF_NOT: Non-idempotent operations must be flagged
RATIONALE: Users re-run skills; duplicate creates/deletes cause errors
EXAMPLE: "Note: Running twice will duplicate the component. Delete first if re-running."
```

---

## DEGREE OF FREEDOM

Match instruction precision to task fragility:

| Freedom | Format | When to Use | Example |
|---------|--------|-------------|---------|
| **High** | Text instructions | Multiple valid approaches | "Handle errors appropriately" |
| **Medium** | Pseudocode | Preferred pattern, variation OK | "1. Check X 2. If Y then Z" |
| **Low** | Specific scripts | Fragile, exact sequence required | "Run exactly: `npm run db:migrate`" |

**Selection Logic:**

```
IF operation is destructive OR sequence-sensitive
  THEN → Low freedom (specific scripts)
ELSE IF preferred pattern exists but context varies
  THEN → Medium freedom (pseudocode)
ELSE
  THEN → High freedom (text instructions)
```

**Low Freedom Example (database migration):**
```markdown
## Migration Steps

Execute exactly in order:
1. `npm run db:backup` — Create backup FIRST
2. `npm run db:migrate` — Run migrations
3. `npm run db:verify` — Verify schema
4. If verify fails: `npm run db:rollback`

⚠️ Do NOT skip backup step.
```

**High Freedom Example (error handling):**
```markdown
## Error Handling

Handle errors appropriately for the context:
- Log with sufficient detail for debugging
- Consider retry logic for transient failures
- Surface errors clearly to the user
```

---

## VALIDATION CHECKLIST

```
VALIDATE_SKILL:
  □ Has YAML frontmatter with name + description
  □ name matches parent folder name (RULE_002)
  □ name is lowercase alphanumeric + hyphens (RULE_003)
  □ description includes capability AND trigger (RULE_004)
  □ SKILL.md body < 500 lines (RULE_001)
  □ No allowed-tools field (RULE_005)
  □ References are one level deep only (RULE_006)
  □ Error handling documented (RULE_007)
  □ Platform requirements documented if needed (RULE_008)
  □ Non-idempotent operations flagged (RULE_009)
```

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| Pre-load all reference content in SKILL.md | Link to references/, load JIT | Wastes context budget |
| Nest references (file → file → file) | One level deep only | Complexity explosion |
| Vague description ("Helps with issues") | State capability + trigger | Agent can't determine when to invoke |
| Multiple responsibilities in one skill | One capability per skill | Hard to compose, invoke confusion |
| Hardcode paths/secrets | Use environment variables | Not portable, security risk |
| Skip error handling | Document failure modes + recovery | Silent failures corrupt state |
| Use `allowed-tools` | Agent-level tool restrictions | NOT supported in VS Code |
| Platform-specific without noting | Add `compatibility:` field | Breaks on other OS |
| Assume single execution | Design for idempotency | Re-runs cause duplicates/errors |
| Exceed 500 lines in SKILL.md | Decompose to scripts/references/ | Starves other context |

---

## CROSS-PLATFORM CONSIDERATIONS

**Portable by default. Platform-specific by exception.**

| Aspect | Portable | Platform-Specific |
|--------|----------|-------------------|
| Path separators | `/` (forward slash) | `\` (Windows only) |
| Shell scripts | `sh`, `bash` | PowerShell, cmd |
| Line endings | LF | CRLF (Windows) |
| Executables | Cross-platform tools | `.exe`, `.bat` |

**If platform-specific is required:**
```yaml
compatibility: Requires Windows and PowerShell 5.1+
```

---

## KNOWN LIMITATIONS

| Limitation | Workaround | Status |
|------------|------------|--------|
| No parameter typing | Use `$ARGUMENTS` placeholder convention | Ecosystem gap |
| No versioning standard | Document version in metadata, pin via commit SHA | Ecosystem gap |
| No dependency declaration | Skills must be self-contained | Ecosystem gap |
| No auto-update | Manual copy to update | By design |
| `allowed-tools` not enforced | Use agent-level tool restrictions | VS Code limitation |
| Organization/Enterprise skills | Use project-level skills | "Coming soon" |

---

## EXAMPLES

### Minimal Valid Example

```yaml
---
name: run-tests
description: Run project test suite and report failures
---

# Run Tests

Execute the test suite and report results.

## Steps

1. Run `npm test`
2. Report any failures with file and line number

## Error Handling

If tests fail: Report failure count and first 3 failing tests.
If npm not found: Report "npm not installed" and stop.
```

### Full Example

```yaml
---
name: fix-github-issue
description: Fix a GitHub issue by reading requirements, implementing the fix, and creating a commit
license: MIT
compatibility: Requires git and gh CLI installed
metadata:
  author: your-org
  version: "1.0.0"
  tags: [github, workflow, issues]
---

# Fix GitHub Issue

Read a GitHub issue, implement the fix, run tests, and create a commit.

## Steps

1. Read issue: `gh issue view $ARGUMENTS`
2. Understand requirements and acceptance criteria
3. Find relevant code locations
4. Implement the fix
5. Write or update tests
6. Run tests: `npm test`
7. Create commit: `git commit -m "fix: resolve #$ARGUMENTS"`

## Error Handling

If issue not found: Report "Issue #$ARGUMENTS not found" and stop.
If tests fail: Report failures, do NOT commit.
If gh CLI not authenticated: Run `gh auth login` first.

## Reference Files

- [Contributing Guide](references/CONTRIBUTING.md)
- [Code Standards](references/CODE_STANDARDS.md)

## Validation

Before committing, verify:
- [ ] All tests pass
- [ ] Changes address issue requirements
- [ ] Commit message references issue number
```

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| `COMPONENT-MATRIX.md` | When to choose skill vs other components |
| `agent-patterns.md` | Agents invoke skills; skill ↔ agent interaction |
| `TEMPLATES/skill-template.md` | Copy-paste starting point |
| `CHECKLISTS/skill-checklist.md` | Verification checklist |

---

## SOURCES

- [skills-format.md](../../cookbook/CONFIGURATION/skills-format.md) — Core structure, frontmatter, limits
- [collections-format.md](../../cookbook/REFERENCE/collections-format.md) — Distribution, bundling patterns
- [agentskills.io Specification](https://agentskills.io/specification) — Open standard
- [VS Code Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) — VS Code implementation
- [Claude Agent Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) — Conciseness guidelines
