**Exemplar — Gold Reference Copilot Instructions**

> Study the embedded copilot-instructions.md below alongside the annotations that follow. Every structural observation refers to sections within this file. Observe the patterns, then apply them when crafting a copilot-instructions.md for any project.


## Embedded Exemplar: .github/copilot-instructions.md

````markdown
Acme API — a REST service for the Acme platform built with Node.js 20, Express 4.x, and TypeScript 5.x.
Three-layer architecture: controllers (HTTP) → services (business logic) → repositories (TypeORM/PostgreSQL).
Redis for caching and sessions, Jest for testing, ESLint + Prettier for code quality.

Source lives in `src/` with subdirectories: `controllers/`, `services/`, `repositories/`, `middleware/`.
End-to-end tests in `test/`, compiled output in `dist/` (never edit directly).
Config files: `.env` for local overrides, `.env.example` committed as the template — `.env` is gitignored.

Files use kebab-case (`user-service.ts`), classes PascalCase, functions/variables camelCase,
database tables snake_case. Test files are `*.test.ts` co-located in `__tests__/` folders.

<rules>

- This file takes precedence over all other instruction files in the workspace
- Never fabricate sources, file paths, or quotes — verify before citing
- Do only what is requested or clearly necessary — treat undocumented features as unsupported
- When rules conflict, apply: Safety → Accuracy → Clarity → Style
- Use npm exclusively — never yarn or pnpm. `package-lock.json` is committed
- Edit `.ts` source files only — never modify `dist/` output directly

</rules>

<commands>

- `npm install` — install dependencies
- `npm run build` — compile TypeScript
- `npm test` — run unit tests
- `npm run test:e2e` — run end-to-end tests
- `npm run lint` — check code quality
- `npm run dev` — start dev server with hot reload

</commands>
````


## Structural Annotations

**No frontmatter** — `copilot-instructions.md` is a singleton always-on file. It has no `applyTo` glob, no `description`, no YAML fences. VS Code loads it automatically into every Copilot interaction for the workspace. Adding frontmatter would waste tokens on metadata the runtime never reads and the AI never needs. Compare with `.instructions.md` files, which require frontmatter because they must declare their activation scope via `applyTo` globs. This is the most visible structural difference between the two artifact types.

**Terse prose intro** — A few short sentences of project context between the top of the file and the first XML group. Every line in this file is injected into every chat turn, so token cost is cumulative and permanent. The intro packs project identity, tech stack, architecture pattern, directory layout, and key infrastructure into dense, factual sentences. Each sentence earns its place by conveying information the AI would otherwise need to discover through tool calls. Verbose architecture docs, onboarding guides, or design philosophy belong in the repo's README or wiki — never here.

**Naming conventions inline** — File naming (`kebab-case`), class naming (`PascalCase`), variable naming (`camelCase`), and database naming (`snake_case`) are stated in the prose intro rather than in a separate section. These are universal facts about the project that occupy one sentence. Extracting them into their own XML group would add structural overhead for zero additional clarity.

**Config and environment facts** — The `.env` / `.env.example` pattern is stated in the prose intro because it is a universal project fact every AI interaction needs: where config lives, what's committed, what's gitignored. This prevents the AI from accidentally committing secrets or creating duplicate config files.

**Precedence rule first** — The first rule in `<rules>` declares that this file takes precedence over all other instruction files. This is deliberate: when the AI encounters conflicting guidance between `copilot-instructions.md` and any `.instructions.md` file, this rule resolves the ambiguity immediately. Precedence is always the first rule because it governs interpretation of everything that follows.

**Imperative rule style** — Rules use "Never" and "Do only" — not "should", "prefer", or "consider". Binary enforcement ("never X", "always Y") produces higher LLM compliance than graduated guidance because it eliminates the ambiguity of when to follow versus when to deviate. Each rule states exactly one prohibition or mandate; compound rules are split into separate bullets.

**Rule ordering** — After the precedence declaration, rules follow a priority cascade: safety (no fabrication), accuracy (scope boundaries), then project-specific constraints (npm only, no dist edits). This mirrors the conflict-resolution rule itself (Safety → Accuracy → Clarity → Style) — the most critical guardrails appear first. Notice the rule count: 6 items. Enough to cover critical constraints, few enough that the AI retains all of them. Avoid inflating rules beyond 8–10 — diminishing compliance follows.

**`<commands>` section** — Concrete, copy-pasteable commands the AI can run without guessing. Each entry is a single command with an em-dash explanation. This eliminates the need for the AI to search `package.json`, parse Makefiles, or infer build steps — saving tokens and reducing hallucination risk. Commands are ordered by workflow: install → build → test → lint → dev. Including commands here means every agent mode (developer, reviewer, planner) has immediate access to the project's verified build and test commands.

**What's deliberately excluded** — This file contains no coding standards (those belong in `.instructions.md` files scoped by `applyTo` globs), no agent names or persona definitions (those belong in `.agent.md` files), no workflow steps or procedural instructions (those belong in skills), and no framework API docs or verbose architecture descriptions (those belong in project documentation). The file is strictly project identity + universal rules + actionable commands. Including scoped content here would bloat every chat turn with rules that only apply to specific file types.

**How this differs from `.instructions.md`** — `copilot-instructions.md` is global and always-on: project identity, universal rules, and commands that apply regardless of what file is open. `.instructions.md` files are scoped and conditional: coding standards and patterns that activate only when files matching their `applyTo` glob enter the AI's context. The cost model is different — `copilot-instructions.md` pays its token cost on every turn, so brevity is critical. `.instructions.md` files pay their cost only when relevant files are in context, so they can afford more detail. Content that applies to all files goes here; content that applies to `**/*.ts` or `src/middleware/**` goes in `.instructions.md`.


## Contrast: What Goes in .instructions.md Instead

For the same Acme API project, the following content would NOT appear in `copilot-instructions.md`. It belongs in `.instructions.md` files scoped to specific file patterns:

**TypeScript coding conventions** → `typescript-conventions.instructions.md`
- `applyTo: '**/*.ts'`
- Rules for strict null checks, union type syntax, import ordering, barrel exports, error handling patterns

**Express middleware patterns** → `express-patterns.instructions.md`
- `applyTo: 'src/middleware/**'`
- Rules for error middleware signatures, request validation, auth guard ordering, async handler wrapping

**Test conventions** → `test-conventions.instructions.md`
- `applyTo: '**/*.test.ts'`
- Rules for describe/it naming, fixture setup, mock isolation, assertion style, coverage thresholds

**Repository layer patterns** → `repository-conventions.instructions.md`
- `applyTo: 'src/repositories/**'`
- Rules for TypeORM query builder usage, transaction boundaries, soft-delete conventions

The key distinction: `copilot-instructions.md` carries project-wide context and universal rules that apply to every interaction. `.instructions.md` files carry domain-specific coding standards scoped to file patterns — they activate only when matching files enter context, so their token cost is conditional rather than constant.
