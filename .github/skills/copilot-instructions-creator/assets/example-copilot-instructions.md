````markdown
This is the copilot-instructions.md for the Acme API project — a REST API service built with Node.js and Express. The governing principle is: calibrate autonomy to confidence — proceed decisively when evidence is strong, escalate when uncertain.


<workspace>

Workspace structure and folder purposes. Load this first to locate resources.

- `.github/agents/core/` — Acme API core agents (hub-and-spoke lifecycle) — `Active`
- `.github/agents/api-tester.agent.md` — Validates endpoint contracts and response schemas — `Active`
- `.github/skills/api-design/` — REST endpoint design patterns and OpenAPI generation — `Active`
- `.github/instructions/express-routes.instructions.md` — Route handler conventions for Express middleware — `Placeholder`

</workspace>


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
````
