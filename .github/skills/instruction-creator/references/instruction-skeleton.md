This file defines the structural skeleton of an `.instructions.md` artifact. Instructions are ambient constraints that shape agent behavior without explicit invocation. The governing principle is body complexity is minimal, routing complexity is maximal — instructions use custom XML groups for project-specific rules, but have 3 sub-types with conditional frontmatter.


<sub_type_decision>

Determine instruction sub-type before drafting. Each sub-type has different routing, frontmatter, and token cost implications.

**Decision tree:**

- Rules apply to ALL chat requests regardless of file type? → **Repo-wide** (location: `.github/copilot-instructions.md`, no frontmatter, loaded every request)
- Rules apply only when specific file patterns appear in context? → **Path-specific file-triggered** (location: `.github/instructions/*.instructions.md`, frontmatter: `applyTo` + `description`, loaded on create/modify only)
- Rules apply when agent detects task relevance from description keywords? → **Path-specific on-demand** (location: `.github/instructions/*.instructions.md`, frontmatter: `description` only, loaded on keyword match)
- Unsure between file-triggered and on-demand? → Prefer file-triggered with `applyTo` + `description` for dual discovery

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


<anti_patterns>

Common mistakes that produce instructions that appear functional but fail in practice. Check the final instruction against this list before delivery.

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
