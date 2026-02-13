`````markdown
````markdown
This is the copilot-instructions.md for the Acme API project — a REST API service built with Node.js and Express. The governing principle is: calibrate autonomy to confidence — proceed decisively when evidence is strong, escalate when uncertain.


<workspace>

Workspace structure and folder purposes. Load this first to locate resources.

<!-- Project structure — update these entries to match your project layout -->
- `src/` — Application source code (controllers, services, repositories, middleware) — `Active`
- `src/config/` — Configuration modules and environment validation — `Active`
- `test/` — End-to-end test suites — `Active`
- `scripts/` — Utility scripts for seeding, migrations, one-time fixes — `Active`
- `dist/` — Compiled JavaScript output — do not edit directly — `Active`

<!-- Agent infrastructure — generated, no changes needed -->
- `.github/agents/core/` — Core agents (hub-and-spoke lifecycle) — `Active`
- `.github/agents/api-tester.agent.md` — Validates endpoint contracts and response schemas — `Active`
- `.github/skills/api-design/` — REST endpoint design patterns and OpenAPI generation — `Active`
- `.github/instructions/express-routes.instructions.md` — Route handler conventions for Express middleware — `Placeholder`

</workspace>


<project_context>

Project-specific context for all agents. Update these sections to reflect your project.

**Project overview**
- REST API service for the Acme platform — handles user authentication, resource CRUD, and webhook delivery
- Three-layer architecture: controllers (HTTP handling) → services (business logic) → repositories (data access)
- Express middleware chain handles auth, validation, error formatting, and request logging

**Tech stack**
- Node.js 20 LTS, Express 4.x, TypeScript 5.x
- PostgreSQL 16 (primary data store via TypeORM), Redis 7 (caching and session store)
- Jest (unit + e2e testing), ESLint + Prettier (code quality)

**Naming conventions**
- Files: kebab-case (`user-service.ts`, `auth-middleware.ts`)
- Classes: PascalCase (`UserService`, `AuthMiddleware`)
- Functions/variables: camelCase (`getUserById`, `isAuthenticated`)
- Database tables: snake_case (`user_sessions`, `api_keys`)
- Test files: `*.test.ts` co-located in `__tests__/` folders alongside source

**Key abstractions**
- `Controller` — receives HTTP request, delegates to service, returns formatted response
- `Service` — contains business logic, calls repositories, throws domain errors
- `Repository` — TypeORM-based data access, one per entity, returns typed entities
- `Middleware` — Express middleware functions for cross-cutting concerns (auth, validation, logging)
- `DomainError` — typed error hierarchy (`NotFoundError`, `ValidationError`, `AuthError`) caught by error middleware

**Testing strategy**
- Unit tests in `__tests__/` alongside source files — test services and utilities in isolation with mocked dependencies
- E2E tests in `test/` at project root — test full HTTP request/response cycles against test database
- Coverage target: 80% line coverage for services, no target for controllers (tested via e2e)
- Run all tests: `npm test`, run e2e only: `npm run test:e2e`

</project_context>


<constraints>

- copilot-instructions.md takes precedence over domain instruction files
- Trust documented structure without re-verification; verify all facts, file contents, and citations before citing — never fabricate sources, file paths, or quotes
- Do only what is requested or clearly necessary; treat undocumented features as unsupported

</constraints>


<decision_making>

- When rules conflict, apply: Safety → Accuracy → Clarity → Style — the first dimension that distinguishes options wins
- Classify issues by impact: P1 blocks completion, P2 degrades quality, P3 is optional
- Calibrate decisions to confidence: high confidence → proceed; medium confidence → flag uncertainty, ask; low confidence → stop, request clarification
- When resources are unavailable, state the gap, provide an explicit workaround, continue

</decision_making>


Core agents (brain, researcher, architect, build, inspect, curator) are defined in `.github/agents/core/`.

- `@api-tester` — Validates endpoint contracts and response schemas against OpenAPI spec


<commands>

Environment setup:
- `nvm use 20` — switch to project Node.js version
- `npm install` — install all dependencies

Build:
- `npm run build` — compile TypeScript to dist/

Test:
- `npm test` — run unit tests with Jest
- `npm run test:e2e` — run end-to-end tests
- `npm run test:coverage` — run tests with coverage report

Lint / Format:
- `npm run lint` — run ESLint checks
- `npm run lint:fix` — auto-fix lint issues
- `npm run format` — run Prettier formatting

Run:
- `npm run dev` — start development server with hot reload
- `npm start` — start production server

</commands>


<environment>

**Runtime environment**
- Node.js 20 LTS via nvm — run `nvm use` to activate (version pinned in `.nvmrc`)
- TypeScript compiled to `dist/` — agents should edit `.ts` source files, never `dist/`
- Development uses `ts-node` for direct TypeScript execution without pre-compilation

**Package management**
- npm is the authoritative package manager — do not use yarn or pnpm
- `package-lock.json` is committed — always run `npm install` after pulling to sync dependencies
- To add a dependency: `npm install <package>` (runtime) or `npm install -D <package>` (dev)

**Ad-hoc scripting**
- Agents may run one-off scripts using `npx ts-node scripts/<name>.ts`
- Utility scripts live in `scripts/` — seed data, migrations, one-time fixes
- Prefer TypeScript for ad-hoc scripts to maintain type safety with project models

**Environment variables**
- `.env` file required for local development — copy from `.env.example`
- Required variables: `DATABASE_URL`, `JWT_SECRET`, `PORT`, `REDIS_URL`
- `.env` is gitignored — never commit it. Secrets are injected via CI environment in production
- Use `process.env.VAR_NAME` with validation at startup — no direct access without config layer

**Prerequisites**
- PostgreSQL must be running — start with `docker compose up -d postgres`
- Redis optional (caching layer) — start with `docker compose up -d redis` if testing cache behavior
- No other external services required for local development

**Common development patterns**
- Hot reload: `npm run dev` uses nodemon + ts-node, restarts on `.ts` file changes
- Database seeding: `npm run seed` populates test data — always run after fresh migration
- Migration workflow: TypeORM migrations — generate with `npm run migration:generate`, apply with `npm run migration:run`
- Testing: unit tests in `__tests__/` alongside source, e2e tests in `test/` at project root
- Log level controlled by `LOG_LEVEL` env var — defaults to `info`, use `debug` during development

</environment>
````
`````
