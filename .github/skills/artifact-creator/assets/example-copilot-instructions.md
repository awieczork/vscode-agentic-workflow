Acme API — a REST service for the Acme platform built with Node.js 20, Express 4.x, and TypeScript 5.x. Three-layer architecture: controllers (HTTP) → services (business logic) → repositories (TypeORM/PostgreSQL). Redis for caching and sessions, Jest for testing, ESLint + Prettier for code quality.

Source lives in `src/` (controllers, services, repositories, middleware), e2e tests in `test/`, compiled output in `dist/` (never edit directly). Files use kebab-case (`user-service.ts`), classes PascalCase, functions/variables camelCase, database tables snake_case. Test files are `*.test.ts` co-located in `__tests__/` folders.


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
