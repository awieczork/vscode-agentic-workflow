# Interview User Manual

Use the `/interview` prompt to generate your project brief and artifact recommendations.

---

## How to Start

1. Open VS Code chat
2. Type `/interview` and press Enter
3. Fill in the XML questionnaire (replace comments with your content)
4. Send the message

---

## Questionnaire Fields

| Field | Required | Description |
|-------|----------|-------------|
| `<name>` | Yes | Project identifier in kebab-case (e.g., `api-gateway`) |
| `<description>` | Yes | What it does, what problem it solves (min 10 characters) |
| `<tech>` | No | Languages, frameworks, tools — one per line |
| `<workflows>` | Recommended | Tasks you repeat — one per line, with priority markers |
| `<constraints>` | No | Rules to enforce — become Iron Laws in artifacts (max 10) |
| `<refs>` | No | External sources with tags (max 9) |
| `<notes>` | No | Free-form suggestions, preferences, context (~500 chars) |

---

## Workflow Priority

Mark your workflows with priority to help the agent focus on what matters most:

```xml
<workflows>
- Add new service route (daily, priority)
- Debug request flow (weekly)
- Update rate limits (monthly)
</workflows>
```

**Priority markers:**
- `(priority)` = High priority workflow (standalone or combined)
- `(daily)`, `(weekly)`, `(monthly)` = Frequency hint
- Combined format: `(daily, priority)`

Workflows without markers are treated as normal priority.

---

## Validation Rules

The interview validates your input before processing:

| Rule | Limit | What Happens |
|------|-------|--------------|
| Required fields | — | Error if `<name>` or `<description>` is empty/whitespace |
| Description length | ≥10 chars | Error if too short |
| Workflow count | Max 15 | Asked to prioritize if exceeded |
| Constraint count | Max 10 | Asked to prioritize if exceeded |
| Ref count | Max 9 | Asked to prioritize if exceeded |
| Ref schemes | `https://`, `./`, `../` | Error if using `file://` or `http://` |

**XML escaping:** Use `&lt;` for `<` and `&gt;` for `>` if you need literal angle brackets in your content.

---

## Example

```xml
<questionnaire version="1.0">

<name required="true">
api-gateway
</name>

<description required="true">
REST API gateway for microservices. Handles authentication, 
rate limiting, and request routing with centralized validation.
</description>

<tech>
- TypeScript
- Fastify
- Redis
- Docker
</tech>

<workflows>
- Add new service route (daily, priority)
- Debug request flow (weekly)
- Update rate limits (monthly)
</workflows>

<constraints>
- No secrets in code
- All endpoints need OpenAPI docs
- Never modify pnpm-lock.yaml
</constraints>

<refs>
<ref src="https://fastify.dev/docs" tags="framework routing" />
<ref src="./docs/style-guide.md" tags="style internal" />
</refs>

<notes>
I need a skill for adding new routes with automatic OpenAPI generation.
Prefer keeping agents minimal — one clear purpose each.
</notes>

</questionnaire>
```

---

## Adding References (Optional)

Link documentation, style guides, or patterns you want agents to follow:

```xml
<refs>
<ref src="https://example.com/docs" tags="framework routing" />
<ref src="./docs/style-guide.md" tags="style internal" />
</refs>
```

- `src` — URL (`https://` only) or local file path (`./` or `../`)
- `tags` — Your choice, one word each, space-separated (max 5 per ref)

References help the interview agent understand your project context and inform artifact recommendations.

---

## Adding Notes (Optional)

Use notes for anything that doesn't fit the structured fields:

```xml
<notes>
I need a skill for generating API client SDKs from OpenAPI specs.
Prefer prompts over agents for simple one-shot tasks.
We have a monorepo with 3 packages — shared, api, web.
</notes>
```

**Good uses for notes:**
- Direct artifact suggestions: "I need a skill for X"
- Preferences: "Prefer prompts over agents for simple tasks"
- Project context: "Monorepo with shared packages"
- Prior attempts: "Tried X but it didn't work because Y"

**Soft limit:** ~500 characters. If you have more context, consider adding it as a referenced doc instead.

---

## What You'll Receive

After the interview completes, you get:

### Project Brief
- Overview of your project
- Tech stack summary
- Prioritized workflows with goals
- Constraints (numbered for reference)

### Execution Manifest

| Column | Description |
|--------|-------------|
| Artifact | Name of the artifact |
| Type | agent, instruction, prompt, or skill |
| Path | Where @build will create the file |
| Skill | Which creator skill to use |
| Tools | Capabilities needed (agents only) |
| Constraints | Which of your rules apply (C1, C2, etc.) |
| Complexity | L0 (simple), L1 (with refs), L2 (full integration) |

### Constraint Propagation
Shows exactly which of your constraints become Iron Laws in which artifacts.

---

## What Happens Next

1. **Interview validates** — checks required fields, validates refs
2. **Existing artifact scan** — finds what's already in `.github/`
3. **Reference summary** — fetches and summarizes linked sources (if provided)
4. **Clarifying questions** — 2-3 questions if workflows are missing or unclear
5. **Project brief** — synthesizes your input into structured format
6. **Execution manifest** — recommends artifacts with full generation specs
7. **Approval checkpoint** — you review and approve (can modify individual items)
8. **Handoff** — proceeds to `@architect` for planning or `@build` for generation
