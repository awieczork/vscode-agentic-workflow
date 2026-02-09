This file defines the frontmatter contract for SKILL.md files. The governing principle is minimal required fields — `name` and `description` are the only fields, both serving discovery.


<frontmatter_fields>

Set both fields during skill creation.

- `name` — string, required. Skill identifier, 1-64 chars, lowercase alphanumeric + hyphens. Must match parent folder name exactly. Single-line only. Derive from the skill's name or intended capability; follow `<name_rules>`
- `description` — string, required. What and when to use, max 1024 chars. Drives skill discovery — agents match user requests against this text. Single-line only. Build from the skill's purpose and capabilities using `<description_rules>`

</frontmatter_fields>


<description_rules>

**Formula:** `[What it does]. Use when [trigger phrases]. [Key capabilities].`

**Rules:**

- Include 2-4 trigger phrases in quotes — these are the words users say that should activate this skill
- List at least 3 concrete capabilities that the skill provides
- Stay under 1024 characters
- No negative triggers ("Don't use when...")
- No XML tags in description

**Examples:**

- `Creates REST API endpoints with validation and error handling. Use when user asks to "scaffold routes", "add endpoint", or "create controller". Produces route handlers, input validation middleware, and TypeScript types.`
- `Runs database migration workflows safely. Use when user asks to "run migrations", "rollback database", or "check migration status". Validates migration files, executes in order, and verifies schema state.`
- `Tests web applications using Playwright. Use for "verifying frontend", "debugging UI", or "capturing screenshots". Starts servers, runs browser tests, and collects visual artifacts.`

</description_rules>


<name_rules>

**Pattern:** Lowercase alphanumeric characters and hyphens only.

**Constraints:**

- Length: 1-64 characters
- Must match parent folder name exactly: `skills/api-scaffold/SKILL.md` → `name: api-scaffold`
- No underscores, spaces, or uppercase letters
- No leading or trailing hyphens

**Valid:** `api-scaffold`, `webapp-testing`, `db-migration`, `code-review`

**Invalid:** `API_Scaffold` (uppercase + underscore), `my skill` (space), `-leading-hyphen` (leading hyphen), `a-very-long-skill-name-that-exceeds-the-sixty-four-character-maximum-limit` (too long)

</name_rules>
