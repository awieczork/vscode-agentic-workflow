---
name: create-api-endpoint
description: Generate a complete REST API endpoint with route handler, validation, service layer, and tests when a new API feature is requested or backend functionality needs to be added
license: MIT
compatibility: Requires Node.js 18+, Express.js, Zod, and Jest or Vitest for testing
metadata:
  author: vscode-agentic-workflow
  version: "1.0.0"
  tags: [api, rest, typescript, express, zod, backend, code-gen]
---

# Create API Endpoint

Generate a complete, production-ready REST API endpoint including route handler, request/response validation, service layer, and comprehensive tests.

## Steps

1. **Gather Requirements**
   - Identify HTTP method (GET, POST, PUT, PATCH, DELETE)
   - Define resource name and route path (e.g., `/api/users/:id`)
   - Document request parameters, query strings, and body schema
   - Define expected response structure and status codes

2. **Create Zod Validation Schemas**
   - Create request body schema: `src/schemas/{resource}.schema.ts`
   - Define path params schema if needed
   - Define query params schema if needed
   - Export typed inference: `type CreateUserInput = z.infer<typeof createUserSchema>`

3. **Create Service Layer**
   - Create service file: `src/services/{resource}.service.ts`
   - Implement business logic function with typed parameters
   - Handle database operations (if applicable)
   - Return typed response or throw typed errors

4. **Create Route Handler**
   - Create route file: `src/routes/{resource}.routes.ts`
   - Import validation middleware and schemas
   - Implement handler with try-catch error handling
   - Use appropriate HTTP status codes

5. **Register Route**
   - Add route to router index: `src/routes/index.ts`
   - Verify route path doesn't conflict with existing routes

6. **Create Tests**
   - Create test file: `src/__tests__/{resource}.test.ts`
   - Write unit tests for service layer
   - Write integration tests for route handler
   - Test validation edge cases (invalid input, missing fields)
   - Test error responses

7. **Validate Implementation**
   - Run linter: `npm run lint`
   - Run type check: `npx tsc --noEmit`
   - Run tests: `npm test`

## Error Handling

If validation schema import fails: Check Zod is installed (`npm install zod`).
If service layer type errors: Verify schema inference exports are correct.
If route conflicts: Check `src/routes/index.ts` for duplicate paths.
If tests fail on imports: Verify Jest/Vitest config includes TypeScript support.
If database errors: Confirm database connection and schema are current.

## Reference Files

- [API Patterns](references/patterns.md) — Detailed code templates and best practices

## Validation

Before marking complete:
- [ ] All files created in correct locations
- [ ] TypeScript compiles without errors
- [ ] Linter passes with no warnings
- [ ] All tests pass
- [ ] API responds correctly (manual or integration test)
- [ ] Error responses follow consistent format

## Notes

- **Idempotency:** Safe to re-run; existing files will need manual merge or overwrite confirmation.
- **Prerequisites:** Express app structure with `src/routes/`, `src/services/`, `src/schemas/` directories.
- **Convention:** Uses barrel exports in `index.ts` files for clean imports.
