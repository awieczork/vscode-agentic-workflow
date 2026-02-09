This file defines the structural skeleton of an `.instructions.md` artifact. Instructions are ambient constraints that shape agent behavior without explicit invocation. The governing principle is body complexity is minimal, routing complexity is maximal — instructions use custom XML groups for project-specific rules, but have 3 sub-types with conditional frontmatter.


<sub_type_decision>

Determine instruction sub-type before drafting. Each sub-type has different routing, frontmatter, and token cost implications.

**Decision tree:**

- Rules apply to ALL chat requests regardless of file type? → **Repo-wide**
- Rules apply only when specific file patterns appear in context? → **Path-specific file-triggered**
- Rules apply when agent detects task relevance from description keywords? → **Path-specific on-demand**

**Decision signals:**

- Repo-wide — Universal rules, project architecture, and links to relevant files. Location: `.github/copilot-instructions.md`. Frontmatter: none. Loaded on every chat request
- Path-specific file-triggered — File-type rules. Location: `.github/instructions/*.instructions.md`. Frontmatter: `applyTo` + `description`. Loaded only when matching files appear in context. Triggers on create/modify operations only, not read-only
- Path-specific on-demand — Domain rules. Location: `.github/instructions/*.instructions.md`. Frontmatter: `description` only. Loaded only when agent detects task relevance from description keywords

**Choosing between sub-types:**

- If rules mention specific file extensions or directories → file-triggered
- If rules apply broadly but not universally → on-demand with keyword-rich `description`
- If rules are project-wide coding standards, conventions, or architecture documentation → repo-wide
- If unsure between file-triggered and on-demand → prefer file-triggered with `applyTo` + `description` for dual discovery

</sub_type_decision>


<prose_intro_pattern>

Every instruction file opens with 1-3 sentences of prose before the first XML group. The intro states purpose and governing principle — no tag wraps it.

- **Repo-wide:** "This project follows [principle]. [Primary constraint]. [Scope statement]."
- **Path-specific:** "This file defines [domain] rules for [scope]. The governing principle is [principle]."

**Examples:**

- "This project prioritizes type safety and explicit error handling across all code. Every module follows functional patterns unless framework constraints require otherwise."
- "This file defines TypeScript rules for all `.ts` files. The governing principle is strict type safety — prefer explicit types over inference for public APIs."

</prose_intro_pattern>


<body_structure>

Instructions use a grouped format: custom XML groups wrapping project-specific rule sets. Each group is a self-contained concern with a domain-specific tag name. Tag names are custom per project — there is no closed vocabulary for instruction body tags.

**Group format:**

- `<group_name>` — Custom domain-specific name: `<naming_conventions>`, `<error_handling>`, `<type_safety>`, `<voice_and_precision>`. Never generic names like `<section_1>` or `<rules_group>`
  - Bullet rules directly inside the group tag — one rule per bullet
  - Optional Wrong/Correct pairs inline — contrast examples with em-dash
  - Optional `<example>` sub-tags for complex code demonstrations

**Referencing:** Use markdown links to reference specific files or URLs — VS Code resolves them as context. Example: `[See config](./config.json)` or `[API spec](./docs/api.md)`. Repo-wide instructions commonly link to architecture docs, key directories, and other instruction files.

**Examples:** See [example-repo-wide.md](../assets/example-repo-wide.md) for a repo-wide instruction and [example-path-specific.md](../assets/example-path-specific.md) for a path-specific file-triggered instruction.

</body_structure>


<visual_skeleton>

**Repo-wide variant:**

```
┌─────────────────────────────────────┐
│  NO FRONTMATTER                     │  ← Repo-wide has no YAML header
├─────────────────────────────────────┤
│  PROSE INTRO (no tag)               │  ← Purpose + governing principle
├─────────────────────────────────────┤
│  <group_name>                       │
│  ├── Bullet rules                   │
│  └── <example> (optional)           │
├─────────────────────────────────────┤
│  <another_group>                    │
│  └── ...                            │
└─────────────────────────────────────┘
```

**Path-specific variant:**

```
┌─────────────────────────────────────┐
│  FRONTMATTER (YAML)                 │  ← Discovery + routing
│  description, name, applyTo         │
├─────────────────────────────────────┤
│  PROSE INTRO (no tag)               │  ← Purpose + governing principle
├─────────────────────────────────────┤
│  <group_name>                       │
│  ├── Bullet rules                   │
│  └── <example> (optional)           │
└─────────────────────────────────────┘
```

</visual_skeleton>


<scaling>

**Minimal instruction (~15 lines body):** Frontmatter + 1 group with bullet rules only.

- 3-5 imperative rules
- No examples
- Suitable for narrow file-type standards

**Standard instruction (~50 lines body):** 2-3 groups with bullet rules + examples.

- Discovery configured (`applyTo` for file-triggered, `description` for on-demand)
- Imperative voice throughout
- Wrong/Correct pairs for ambiguous rules

**Full instruction (~100-150 lines body):** 3-5 groups, all with rules and examples.

- All groups include rules + at least one example
- Wrong/Correct pairs for every group
- Token economy optimized — no redundant rules

**When to split:** Evaluate splitting at ~100 lines (path-specific) or ~150 lines (repo-wide). Split by file type when rules serve different extensions. Split by concern when rules cover distinct domains. Extract to repo-wide when a rule applies to ≥3 file types.

</scaling>


<core_principles>

7 design rules shape instruction structure — violating any one produces instructions that degrade under real usage.

- **No identity, no tools, no state** — Instructions are pure ambient constraints. They carry no persona, invoke no tools, and maintain no session state. Every rule stands alone
- **One concern per file** — Separate testing, styling, API design, and documentation into distinct instruction files. Mixing domains produces bloated files that load unnecessary rules
- **Custom tags, no shared vocabulary** — Group tag names are project-specific (`<naming_conventions>`, `<type_safety>`). They must not overlap with agent or skill tag vocabularies — see `<anti_patterns>` for prohibited tags
- **Imperative voice** — "Use X" not "You should use X". Specific quantities: "Maximum 3 levels" not "Avoid deep nesting". Versioned: "React 18+ hooks" not "modern React"
- **One rule per bullet** — Compound rules split into separate bullets. Each bullet addresses exactly one concern
- **ALWAYS/NEVER sparingly** — Reserve for safety-critical rules, 2-5 per file
- **Fixed locations per sub-type** — See `<sub_type_decision>` for path mapping and filename pattern `[DOMAIN].instructions.md`

</core_principles>


<anti_patterns>

Common mistakes that produce instructions that appear functional but fail in practice. Check the final instruction against this list before delivery.

**Never use agent tags in instructions:**

- `<constraints>`, `<behaviors>`, `<outputs>`, `<termination>` — Agent top-level structure
- `<iron_law>`, `<mode>`, `<context_loading>`, `<on_missing>`, `<when_blocked>` — Agent sub-tags

**Never use skill tags in instructions:**

- `<workflow>`, `<step_N_verb>` — Skill procedural structure
- `<use_cases>`, `<resources>` — Skill discovery and resource tags

**Never include in instructions:**

- Identity prose — "You are a...", role statements, expertise declarations, stance definitions
- Stance words — "thorough", "cautious", "creative", "helpful" are identity leakage even without "You are a..."
- Prompt variables — `${input:}`, `${selection}`, `${file}` — runtime variable syntax

**Design violations:**

- Markdown headings — `#`, `##`, `###` used as structure instead of XML tags
- Generic group names — `<section_1>`, `<rules_group>` instead of domain-specific `<naming_conventions>`
- Mixing concerns — testing + API design + styling in one file instead of separate instruction files
- Hedge language — "try to avoid", "should", "be careful" instead of binary NEVER/ALWAYS
- Compound rules — multiple concerns in one bullet instead of one rule per bullet
- Load-order dependency — rules that assume another instruction file is loaded

</anti_patterns>
