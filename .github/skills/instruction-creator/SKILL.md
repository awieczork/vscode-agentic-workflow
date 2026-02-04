---
name: instruction-creator
description: Creates instruction files (.instructions.md and copilot-instructions.md) from specifications. Use when asked to create an instruction, build instruction, or generate instruction for a domain. Produces frontmatter, applyTo patterns, and rule sections.
---

# Instruction Creator

Create valid, high-quality instruction files from specifications.

<workflow>

<step_1_classify>

Confirm spec describes an INSTRUCTION, then determine which type.

**Tier 1 — Artifact Type Decision:**

Test in order. Stop at first YES.

- Has `${input:}` runtime variables? → **Prompt** (stop, wrong skill)
- Has bundled scripts or assets? → **Skill** (stop, wrong skill)
- Has persona, tools, or handoffs? → **Agent** (stop, wrong skill)
- Auto-applying rules for file patterns? → **Instruction** ✓

**Confidence checkpoint:** After Tier 1, confirm: "This is an instruction (not prompt/skill/agent)?"

If unclear, ask user: "This sounds like [type] because [reason]. Confirm instruction?"

**Tier 2 — Instruction Type Decision:**

- Rules apply to ALL chat regardless of file type? → **Repo-Wide**
- Rules apply only when specific files are in context? → **Path-Specific**

**Decision signals:**

**Repo-Wide signals:**
- Scope: Project-wide, universal rules
- File patterns: Not applicable
- Frontmatter: NONE (plain Markdown only)
- Location: `.github/copilot-instructions.md`
- Token cost: Every chat request

**Path-Specific signals:**
- Scope: File-type specific rules
- File patterns: Required (`applyTo` glob)
- Frontmatter: YAML with `applyTo`
- Location: `.github/instructions/*.instructions.md`
- Token cost: Only when files match pattern

</step_1_classify>

<step_2_name_and_describe>

**Repo-Wide:**
- Filename is fixed: `copilot-instructions.md`
- No naming decision required

**Path-Specific:**
- Name from domain: `{domain}.instructions.md`
- Examples: `typescript-standards`, `security-rules`, `api-design`, `testing-conventions`
- Format: lowercase-with-hyphens

**Description formula:** `[DOMAIN] [CONSTRAINT_TYPE] for [SCOPE]`

Examples:
- "TypeScript coding standards for all .ts files"
- "Security validation rules for API endpoints"
- "Testing conventions for unit and integration tests"

</step_2_name_and_describe>

<step_3_assess_complexity>

Determine output depth using layer system.

**L0 — Valid (Minimum Viable):**
- Correct location and filename
- Frontmatter matches type
- Basic rules (3+ items)

**L1 — Good (Production-Ready):**
- L0 + `applyTo` specified (Path-Specific)
- Imperative voice throughout
- Specific, actionable rules
- ALWAYS/NEVER for safety rules

**L2 — Excellent (Full Quality):**
- L1 + code examples (correct/incorrect pairs)
- Anti-patterns section
- Stackability verified
- Optimized token economy

**Size thresholds:**

- **100 lines** — Auto-recommend: Evaluate splitting by concern (both types)
- **150 lines** — Path-Specific: Mandatory split required
- **200 lines** — Repo-Wide: Mandatory split required

If splitting needed, create multiple Path-Specific files by:
- File type (TypeScript vs React vs tests)
- Concern (security vs style vs performance)
- Domain (API vs UI vs infrastructure)

</step_3_assess_complexity>

<step_4_draft>

Fork based on instruction type determined in Step 1.

<if type="repo-wide">

**Repo-Wide Drafting:**

Location: `.github/copilot-instructions.md`

**RED FLAG:** If frontmatter (`---` block) is detected, HALT. Repo-Wide must NOT have frontmatter.

Structure:
```markdown
## Project Context
[Project] uses [stack with versions].

## Code Style
- [Rule 1]
- [Rule 2]

## Commands
- Build: `[command]`
- Test: `[command]`

## Safety Rules
- NEVER [constraint]
- ALWAYS [behavior]
```

</if>

<if type="path-specific">

**Path-Specific Drafting:**

Location: `.github/instructions/{name}.instructions.md`

Frontmatter (required for auto-apply):
```yaml
---
applyTo: "[GLOB_PATTERN]"
name: "[DISPLAY_NAME]"
description: "[PURPOSE_50_150_CHARS]"
---
```

Structure:
```markdown
# [Title]

[One-line summary]

<core_rules>

## Core Rules
- [5-10 imperative rules]

</core_rules>

<code_standards>

## Code Standards (L2 only)

### Correct
[code example]

### Incorrect
[code example]

</code_standards>

<anti_patterns>

## Anti-Patterns (L2 only)
- [Pattern]: [Why problematic]

</anti_patterns>
```

</if>

**Rule writing guidance:**
- Imperative voice: "Use X" not "You should use X"
- Specific: "Maximum 3 levels of nesting" not "Avoid deep nesting"
- Versioned: "React 18+ hooks" not "modern React"
- ALWAYS/NEVER: Reserve for safety-critical rules (2-5 per file)

Load [structure-reference.md](references/structure-reference.md) for glob patterns and section details.

### Step 4.5: Stackability Check

Instructions stack additively. Order is non-deterministic.

**Before finalizing, check for conflicts:**

1. List existing instruction files in `.github/instructions/`
2. Identify files with overlapping `applyTo` patterns
3. Compare rules for contradictions or duplicates

**Conflict types:**

- **Contradiction** — "Use interface" vs "Use type" for same case → Revise one instruction
- **Duplication** — Same rule in multiple files → Extract to Repo-Wide or remove duplicate
- **Overlap** — Both files handle same concern → Consolidate or clarify scope

**Declare conflict surfaces:**
- "This instruction stacks with: [list]"
- "Non-overlapping concerns: [this file handles X, other handles Y]"

If conflicts found, resolve before proceeding to validation.

</step_4_draft>

<step_5_validate>

Run validation checks. Load [validation-checklist.md](references/validation-checklist.md) for full list.

**Quick 5-check (P1 blockers):**

1. [ ] Correct location and filename pattern
2. [ ] Frontmatter matches type (none for Repo-Wide, valid YAML for Path-Specific)
3. [ ] `applyTo` specified with valid glob — NOT `**` or `*` alone (Path-Specific only)
4. [ ] All rules are specific and actionable
5. [ ] No placeholders, secrets, or persona language

**P2 Checks (Required):**

1. [ ] Content sections wrapped in XML tags (e.g., `<core_rules>`, `<code_standards>`, `<anti_patterns>`)

**Contamination check:**

Reject if ANY of these patterns appear:
- `<identity>`, `<safety>`, `<boundaries>`, `<modes>` tags
- `tools:` or `handoffs:` in frontmatter
- `${input:}` variable syntax
- "You are a..." identity statements
- `#!/bin/bash` or other shebang lines

**Requirement:** Use XML tags for all logical sections (e.g., `<core_rules>`, `<code_standards>`, `<anti_patterns>`). Markdown headings are supplementary inside tags.

**Size check:**
- Path-Specific >150 lines → Split required
- Repo-Wide >200 lines → Split required

</step_5_validate>

<step_6_integrate>

Place instruction in correct location.

**Repo-Wide:**
- Path: `.github/copilot-instructions.md`
- Auto-loads when VS Code setting enabled: `github.copilot.chat.codeGeneration.useInstructionFiles`

**Path-Specific:**
- Path: `.github/instructions/{name}.instructions.md`
- Auto-loads when files matching `applyTo` are in context

**Platform support:**
- Repo-Wide: VS Code ✓, GitHub.com ✓, JetBrains ✓
- Path-Specific: VS Code ✓, GitHub.com (Coding Agent/Code Review only), JetBrains ✓

</step_6_integrate>

</workflow>

---

## When to Ask User

- **Type ambiguous:** "Should these rules apply to ALL chat, or only specific file types?"
- **Scope unclear:** "What file patterns should trigger these rules? (e.g., `**/*.ts`)"
- **Conflicts detected:** "Found overlap with [file]. Should I merge, split concerns, or override?"
- **Size exceeds limit:** "Draft is [X] lines. Split by [concern A] vs [concern B]?"

## Quality Signals

**Good instruction:**
- Passes P1/P2 validation
- Correct location and frontmatter format
- Rules are specific and actionable
- `applyTo` specified (Path-Specific)

**Excellent instruction:**
- Stackability verified — no conflicts with existing instructions
- Conflict surfaces declared
- Code examples for ambiguous rules
- Anti-patterns for common mistakes
- Optimized size (well under limits)

---

## Loading Directives

**HOT (always load at skill start):**
- This SKILL.md
- Spec or requirements from user

**WARM (load when drafting):**
- [structure-reference.md](references/structure-reference.md) — Glob patterns, section syntax
- [validation-checklist.md](references/validation-checklist.md) — P1/P2/P3 checks

**JIT (load at Step 4.5):**
- Existing `.github/instructions/*.instructions.md` files in workspace
- Existing `.github/copilot-instructions.md` if present

---

## References

- [structure-reference.md](references/structure-reference.md) — Frontmatter, globs, layers, sections
- [validation-checklist.md](references/validation-checklist.md) — P1/P2/P3 checks, contamination detection

## Assets

- [example-skeleton.md](assets/example-skeleton.md) — Annotated templates for both types
- [example-typescript-standards.md](assets/example-typescript-standards.md) — Complete working instruction
