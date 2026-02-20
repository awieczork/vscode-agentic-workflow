---
name: 'copilot-instructions-creator'
description: 'Guides creation of the .github/copilot-instructions.md file — the singleton always-on project context file. Use when asked to "create copilot instructions", "set up project-wide AI context", "write copilot-instructions.md", or "configure Copilot for this project". Produces a single frontmatter-free file (≤50 lines) containing universal project rules and context loaded on every chat turn.'
---

Follow these steps to generate a copilot-instructions.md file by studying the project and applying the token-cost principle — every line is loaded on every chat turn, so only universal project context earns inclusion. Begin with `<step_1_understand>` to gather project context.


<use_cases>

- Set up Copilot project context for a new TypeScript monorepo
- Create copilot-instructions.md for a Python microservice
- Configure project-wide AI rules for a Rust CLI tool
- Add universal coding context for a React + Node.js application

</use_cases>


<workflow>

Execute steps sequentially. Each step builds on the previous — project context determines content candidates, the spec governs structure, triage filters what earns inclusion, generation produces the file, and validation confirms delivery readiness.


<step_1_understand>

Gather project context through workspace exploration.

- Identify the **project name and purpose** — read README.md, package.json, Cargo.toml, pyproject.toml, or equivalent manifest files
- Identify the **tech stack** — languages, frameworks, major dependencies, runtime versions
- Identify the **architecture** — monorepo vs single package, service boundaries, key directories and their roles
- Identify the **build/test/lint commands** — extract from scripts, Makefiles, CI configs, or task runners
- Identify **what makes this project unique** — domain-specific patterns, naming conventions, architectural decisions that an AI assistant must know on every interaction

**Output of this step:** project name, purpose, tech stack, architecture summary, key commands, unique project characteristics.

</step_1_understand>


<step_2_study>

Study the specification and exemplar to understand artifact structure and constraints.

- Load [copilot-instructions-spec.md](references/copilot-instructions-spec.md) — internalize the body structure (prose intro → `<rules>` → optional `<commands>`), the token-cost principle, content placement rules, and anti-patterns
- Load [exemplar.md](assets/exemplar.md) — study the gold-reference example to observe how a well-formed copilot-instructions.md balances brevity with completeness
- Note the critical constraints: no frontmatter, no markdown headings, fixed location at `.github/copilot-instructions.md`, ≤50 lines, precedence rule first inside `<rules>`

</step_2_study>


<step_3_triage>

Decide what earns inclusion by applying the token-cost triage. This is the critical decision step — routing content to the wrong artifact is the #1 source of quality failures.

For each piece of project context gathered in step 1, ask: **does this help on EVERY chat turn?** If not, it does not belong in copilot-instructions.md.

Route content to the correct artifact:

- **copilot-instructions.md** (this artifact) — project identity, universal constraints, precedence rule, build/test/lint commands, cross-cutting architectural rules. Content that applies regardless of which file the user is editing.
- **.instructions.md files** (scoped) — coding standards, formatting rules, language conventions, file-pattern-specific guidance. Content triggered by specific file types or directories. Note these as follow-up recommendations and suggest using the instruction-creator skill at `.github/skills/instruction-creator/`.
- **.agent.md files** (agent-specific) — agent personas, domain expertise, specialized tool configurations, role-specific workflows. Note these as follow-up recommendations and suggest using the agent-creator skill at `.github/skills/agent-creator/`.

**Output of this step:** final content list for copilot-instructions.md, plus follow-up recommendations for scoped instructions or agent files.

</step_3_triage>


<step_4_generate>

Write the copilot-instructions.md file at `.github/copilot-instructions.md`.

- **Prose intro** — 1-2 bare sentences stating the project name, purpose, and tech stack. No frontmatter. No markdown headings.

- **`<rules>`** — Imperative rules governing AI behavior across the project. First rule must be the precedence statement (this file yields to scoped .instructions.md and .agent.md files). Remaining rules cover universal constraints: architecture boundaries, naming patterns, error handling approach, and any cross-cutting conventions. NEVER/ALWAYS enforcement — no hedge words.

- **`<commands>`** (optional) — Build, test, lint, and run commands. Include only if the project has non-obvious commands that the AI should know. Omit if commands are standard and discoverable.

- **Line budget** — Target ≤50 lines. Every line costs tokens on every chat turn. If the draft exceeds 50 lines, return to step 3 and triage more aggressively.

- **If `.github/copilot-instructions.md` already exists** — read the existing file, review its content, and update it rather than overwriting blindly. Preserve any valid rules that still apply.

</step_4_generate>


<step_5_validate>

Quality-check the generated file against all validation gates.

Load [quality-gates.md](references/quality-gates.md) and run each tier:

- **P1 — Blocking** (fix before delivery):
  - File is at `.github/copilot-instructions.md`
  - No frontmatter (no `---` fences)
  - No markdown headings (`#`)
  - No secrets, drive letters, or absolute paths
  - 50 lines or fewer
  - Precedence rule present inside `<rules>`

- **P2 — Quality** (fix before finalizing):
  - Prose intro states project identity
  - All rules use NEVER/ALWAYS — no hedge words
  - Content passes token-cost triage (every line useful on every turn)
  - No scoped content that belongs in .instructions.md
  - No agent-specific content that belongs in .agent.md
  - `<commands>` section present only if commands are non-obvious

- **P3 — Polish** (flag as suggestions):
  - Active voice throughout
  - Concise — no filler words or redundant rules
  - Rules ordered from most impactful to least

Fix all P1 and P2 issues. Report P3 suggestions to the user. If P1 fixes require structural changes, return to `<step_4_generate>`.

</step_5_validate>


</workflow>

<key_differentiators>

- **copilot-instructions-creator** — one file, no frontmatter, always-on, universal project context, fixed at `.github/copilot-instructions.md`, ≤50 lines, every line costs tokens on every turn
- **instruction-creator** — many files, frontmatter with `applyTo` globs, conditional loading, scoped coding standards for specific file types or directories, no strict line limit

When in doubt: if the content applies regardless of which file the user is editing, it belongs in copilot-instructions.md. Otherwise, use a scoped .instructions.md file.

</key_differentiators>

<error_handling>

Recovery actions for common failure modes. Apply the matching recovery when an issue surfaces during any step.

- If the project has **insufficient context** (no manifest files, no README) — ask targeted questions: What language and framework? What are the build commands? What architectural rules must always apply?
- If the draft **exceeds 50 lines** — return to step 3 and apply stricter triage. Move scoped content to .instructions.md recommendations, remove anything not needed on every turn.
- If content is actually **scoped coding standards** or a **persona/role description** — redirect to instruction-creator or agent-creator skill respectively. copilot-instructions.md carries only universal project context.
- If **P1 validation failures** are found in step 5 — return to `<step_4_generate>` and fix specific violations.

</error_handling>

<resources>

Reference files loaded on demand during workflow steps. All paths are relative to the skill folder.

**References:**

- [copilot-instructions-spec.md](references/copilot-instructions-spec.md) — Artifact specification: body structure, token-cost principle, content placement rules, and anti-patterns. Loaded in step 2.
- [quality-gates.md](references/quality-gates.md) — Validation tiers (P1/P2/P3), banned patterns, and copilot-instructions anti-patterns. Loaded in step 5.

**Assets:**

- [exemplar.md](assets/exemplar.md) — Annotated gold-reference copilot-instructions.md with structural observations. Loaded in step 2.

</resources>
