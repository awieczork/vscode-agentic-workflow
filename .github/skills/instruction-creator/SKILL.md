---
name: instruction-creator
description: Creates instruction files (.instructions.md and copilot-instructions.md) from specifications. Use when asked to create an instruction, build instruction, or generate instruction for a domain. Produces frontmatter, applyTo patterns, and rule sections.
---

Instruction files define rules that auto-apply when specific file patterns appear in context. The governing principle is ambient constraint — instructions shape behavior without requiring explicit invocation, loading automatically based on file patterns. The core distinction is Path-Specific (file-pattern triggered) vs Repo-Wide (always loaded) — determine type first in `<step_1_classify>` before drafting.


<workflow>

<step_1_classify>

Confirm spec describes an instruction, then determine which type.

**Artifact type decision:**
- Has `${input:}` runtime variables? → Prompt (stop, use prompt-creator)
- Has bundled scripts or assets? → Skill (stop, use skill-creator)
- Has persona, tools, or handoffs? → Agent (stop, use agent-creator)
- Auto-applying rules for file patterns? → Instruction (continue)

If unclear, ask: "This sounds like [type] because [reason]. Confirm instruction?"

**Instruction type decision:**
- Rules apply to ALL chat regardless of file type? → **Repo-Wide**
- Rules apply only when specific files are in context? → **Path-Specific (File-Triggered)**
- Rules apply when user requests specific domain guidance? → **Path-Specific (On-Demand)**

**Decision signals:**

- **Repo-Wide** — Scope: project-wide universal rules. Location: `.github/copilot-instructions.md`. Frontmatter: NONE (plain markdown). Token cost: every chat request.
- **Path-Specific (File-Triggered)** — Scope: file-type specific. Location: `.github/instructions/*.instructions.md`. Frontmatter: YAML with `description` + `applyTo`. Token cost: only when files match.
- **Path-Specific (On-Demand)** — Scope: domain guidance on request. Location: `.github/instructions/*.instructions.md`. Frontmatter: YAML with `description` only. Token cost: only when invoked.

</step_1_classify>


<step_2_name_and_describe>

**Repo-Wide:**
- Filename is fixed: `copilot-instructions.md`

**Path-Specific:**
- Name from domain: `{domain}.instructions.md`
- Examples: `typescript-standards`, `security-rules`, `api-design`, `testing-conventions`
- Format: lowercase-with-hyphens

**Description formula:** `[DOMAIN] [CONSTRAINT_TYPE] for [SCOPE]`

Examples:
- "TypeScript coding standards for all .ts files"
- "Security validation rules for API endpoints"

**On-demand description pattern:** `Use when [TASK]. [SUMMARY].`

On-demand examples:
- "Use when writing database migrations. Covers safety checks, rollback procedures, and naming conventions."
- "Use when designing REST APIs. Covers endpoint naming, versioning, and response formats."

</step_2_name_and_describe>


<step_3_assess_complexity>

Determine output depth using layer system.

**L0 — Valid (minimum viable):**
- Correct location and filename
- Frontmatter matches type
- Basic rules (3+ items)

**L1 — Good (production-ready):**
- L0 + discovery mode configured (applyTo for file-triggered, description for on-demand)
- Imperative voice throughout
- Specific, actionable rules
- ALWAYS/NEVER for safety rules

**L2 — Excellent (full quality):**
- L1 + Wrong/Correct example pairs
- Stackability verified
- Optimized token economy

If file exceeds comfortable reading length, split by concern into multiple Path-Specific files.

</step_3_assess_complexity>


<step_4_draft>

Fork based on instruction type determined in Step 1. Load [structure-reference.md](references/structure-reference.md) for: grouped format syntax, glob patterns, frontmatter fields, section details.

<if_repo_wide>

**Repo-Wide drafting:**

Location: `.github/copilot-instructions.md`

**RED FLAG:** If frontmatter (`---` block) is detected, HALT. Repo-Wide must NOT have frontmatter.

Structure uses XML tags as exclusive structure (no markdown headings):

```markdown
Opening prose paragraph stating project purpose and governing principle.

<group_name>

<rules>

- [Rule 1]
- [Rule 2]
- [Rule 3]

</rules>

<justification>

[2-4 sentences explaining WHY — include only for rules that deviate from training defaults]

</justification>

<benefit>

[1-2 sentences stating the concrete outcome]

</benefit>

<anti_patterns>

- Wrong: [bad pattern] → Correct: [good pattern]
- Wrong: [bad pattern] → Correct: [good pattern]

</anti_patterns>

</group_name>
```

</if_repo_wide>

<if_path_specific>

**Path-Specific drafting:**

Location: `.github/instructions/{name}.instructions.md`

Frontmatter (required):

```yaml
---
applyTo: "[GLOB_PATTERN]"
name: "[DISPLAY_NAME]"
description: "[PURPOSE_50_150_CHARS]"
---
```

Structure uses the same grouped format:

```markdown
---
applyTo: "**/*.ts"
description: "TypeScript coding standards for all TypeScript files"
---

Opening prose paragraph stating purpose and governing principle.


<group_name>

<rules>

- [Rule 1 — imperative voice]
- [Rule 2 — specific, actionable]
- [Rule 3]

</rules>

<justification>

[Only for training-deviant rules — explain WHY these differ from defaults]

</justification>

<benefit>

[Concrete outcome from following these rules]

</benefit>

<anti_patterns>

- Wrong: [bad pattern] → Correct: [good pattern]

</anti_patterns>

</group_name>
```

</if_path_specific>

**Grouped format rules:**
- Each named group wraps a cohesive set of rules
- `<rules>` — Required. Bullet list of imperative rules.
- `<justification>` — Optional. Include only for rules that deviate from training defaults. 2-4 sentences.
- `<benefit>` — Optional. 1-2 sentences stating concrete outcome.
- `<anti_patterns>` — Optional. Wrong/Correct pairs with em-dash.
- Use XML tags as exclusive structure — no markdown headings anywhere

**Rule writing guidance:**
- Imperative voice: "Use X" not "You should use X"
- Specific: "Maximum 3 levels of nesting" not "Avoid deep nesting"
- Versioned: "React 18+ hooks" not "modern React"
- ALWAYS/NEVER: Reserve for safety-critical rules (2-5 per file)

**Stackability check:**

Instructions stack additively. Order is non-deterministic.

Before finalizing:
1. List existing instruction files in `.github/instructions/`
2. Identify files with overlapping `applyTo` patterns
3. Compare rules for contradictions or duplicates

**Conflict types:**
- **Contradiction** — "Use interface" vs "Use type" for same case → Revise one instruction
- **Duplication** — Same rule in multiple files → Extract to Repo-Wide or remove duplicate
- **Overlap** — Both files handle same concern → Consolidate or clarify scope

</step_4_draft>


<step_5_validate>

Run validation checks. Load [validation-checklist.md](references/validation-checklist.md) for full list.

**Quick 5-check (P1 blockers):**
1. [ ] Correct location and filename pattern
2. [ ] Frontmatter matches type (none for Repo-Wide, valid YAML for Path-Specific)
3. [ ] `description` specified with domain keywords (Path-Specific)
4. [ ] If `applyTo` present, uses valid glob — NOT `**` or `*` alone
5. [ ] All rules are specific and actionable
6. [ ] No placeholders, secrets, or persona language

**Structure check (P2):**
- [ ] No markdown headings — XML tags are exclusive structure
- [ ] Content sections wrapped in named groups using grouped format
- [ ] Each group has `<rules>` section

**Contamination check — reject if ANY appear:**
- `<identity>`, `<safety>`, `<boundaries>`, `<modes>` tags
- `tools:` or `handoffs:` in frontmatter
- `${input:}` variable syntax
- "You are a..." identity statements
- `#!/bin/bash` or other shebang lines

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
- Repo-Wide: VS Code, GitHub.com, JetBrains
- Path-Specific: VS Code, GitHub.com (Coding Agent/Code Review only), JetBrains

</step_6_integrate>

</workflow>


<when_to_ask>

- Type ambiguous → "Should these rules apply to ALL chat, or only specific file types?"
- Scope unclear → "What file patterns should trigger these rules? (e.g., `**/*.ts`)"
- Conflicts detected → "Found overlap with [file]. Should I merge, split concerns, or override?"

</when_to_ask>


<quality_signals>

**Good instruction:**
- Passes P1/P2 validation
- Correct location and frontmatter format
- Rules are specific and actionable
- `applyTo` specified (Path-Specific)

**Excellent instruction:**
- Stackability verified — no conflicts with existing instructions
- Conflict surfaces declared
- Wrong/Correct example pairs for ambiguous rules
- Optimized token economy

</quality_signals>


<loading_directives>

**HOT (always load at skill start):**
- This SKILL.md
- Spec or requirements from user

**WARM (load when drafting):**
- [structure-reference.md](references/structure-reference.md) — Grouped format syntax, glob patterns, sections
- [validation-checklist.md](references/validation-checklist.md) — P1/P2/P3 checks

**JIT (load at stackability check):**
- Existing `.github/instructions/*.instructions.md` files in workspace
- Existing `.github/copilot-instructions.md` if present

</loading_directives>


<references>

- [structure-reference.md](references/structure-reference.md) — Frontmatter, globs, grouped format, sections
- [validation-checklist.md](references/validation-checklist.md) — P1/P2/P3 checks, contamination detection

</references>


<assets>

- [example-skeleton.md](assets/example-skeleton.md) — Annotated templates for both types
- [example-typescript-standards.md](assets/example-typescript-standards.md) — Complete working instruction

</assets>
