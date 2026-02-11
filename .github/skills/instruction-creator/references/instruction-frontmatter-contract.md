This file defines YAML frontmatter fields for `.instructions.md` files. The governing principle is conditional presence — repo-wide instructions have no frontmatter; path-specific instructions require 1-2 fields for discovery and routing.


<frontmatter_fields>

All fields are determined during instruction creation. No user-decided fields exist for instructions.

- `description` — string, required for path-specific only. Keyword-rich description for discovery, 50-150 chars. Drives on-demand task-relevance matching. Derive from purpose and rules — rephrase as domain constraint summary
- `name` — string, optional. Display name in UI. If omitted, derived from filename
- `applyTo` — string | string[], optional. Glob pattern(s) for auto-attachment when matching files appear in context. Convert file patterns to valid glob syntax per `<glob_pattern_guidance>`

</frontmatter_fields>


<repo_wide_exception>

Repo-wide instructions (`copilot-instructions.md`) have NO frontmatter — the only artifact type with a frontmatter-free variant.

- Location: `.github/copilot-instructions.md` (fixed path, fixed filename)
- No `---` YAML block — content begins immediately with prose
- If instruction type is repo-wide → produce no frontmatter. If path-specific-triggered or path-specific-on-demand → produce frontmatter per `<frontmatter_fields>`

</repo_wide_exception>


<discovery_mode_guidance>

Select frontmatter configuration based on how the instruction should be discovered.

- `applyTo` + `description` → File-triggered with on-demand fallback. Most common configuration. Auto-attaches when matching files appear in context AND discoverable by task relevance
- `description` only → On-demand discovery. Agent detects task relevance from description keywords. Use for domain rules not tied to specific file types
- No frontmatter → Repo-wide. Universal rules applied to every chat request. Only `copilot-instructions.md`

**Decision rule:** If rules mention specific file extensions → use `applyTo`. If rules apply to a task type regardless of files → use `description` only. If rules apply universally → use repo-wide.

</discovery_mode_guidance>


<description_rules>

Two patterns based on discovery mode.

**File-triggered pattern:** `'[DOMAIN] [CONSTRAINT_TYPE] for [SCOPE]'`

- Correct: `'TypeScript coding standards for type safety and naming conventions'`
- Correct: `'Python testing conventions for pytest-based test files'`
- Wrong: `'Helpful coding tips'` — vague, no domain keywords
- Wrong: `'Rules'` — no discovery signal

**On-demand pattern:** `'Use when [TASK]. [SUMMARY].'`

- Correct: `'Use when writing database migrations. Covers safety checks, rollback procedures, and naming conventions.'`
- Correct: `'Use when designing REST APIs. Covers endpoint naming, versioning, and response formats.'`
- Wrong: `'Use when coding.'` — too broad, no task specificity
- Wrong: `'Database stuff'` — no action verb, no summary

**Length:** 50-150 characters. Include domain keywords that agents match against user requests.

</description_rules>


<glob_pattern_guidance>

`applyTo` uses VS Code glob syntax (not regex). Use array for multiple patterns: `applyTo: ['**/*.ts', '**/*.tsx']`.

</glob_pattern_guidance>
