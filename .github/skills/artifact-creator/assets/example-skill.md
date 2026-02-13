```markdown
---
name: 'api-scaffold'
description: 'Scaffolds REST API endpoints with routing, validation, and error handling. Use when asked to "scaffold routes", "add endpoint", or "create controller". Produces route handlers, input validation middleware, and TypeScript types.'
---

<!-- prose intro with governing principle — required for all skills -->
This skill scaffolds REST API endpoints with validation and error handling. The governing principle is convention over configuration — standard patterns unless the spec overrides. Begin with `<step_1_analyze>` to determine the API framework and routing style.


<use_cases>

- Scaffold new REST API endpoints from an OpenAPI spec or description
- Add input validation middleware to existing routes
- Generate TypeScript types from API schema
- Create standardized error response handlers

</use_cases>


<workflow>

Execute steps sequentially. Each step produces artifacts that feed the next.

<!-- step naming: imperative verb + noun (step_1_analyze, not step_1_analysis) -->

<step_1_analyze>

Read the spec to determine:

- Target framework (Express, Fastify, or auto-detect from project)
- Routing style (file-based, centralized, feature-grouped)
- Existing patterns in the codebase

Load [framework-patterns.md](./references/framework-patterns.md) for: framework detection rules and route conventions. Apply `<detection_rules>` in [framework-patterns.md](./references/framework-patterns.md) to identify the target framework.

</step_1_analyze>


<step_2_generate_types>

Generate TypeScript interfaces from the API schema:

- Request body types per endpoint
- Response types with status code variants
- Query parameter types
- Path parameter types

Output: `types/` directory with one file per resource.

</step_2_generate_types>


<step_3_create_routes>

Create route handler files with validation:

- One handler per endpoint
- Include request validation using generated types
- Validate query and path parameters
- Return 400 with structured error messages on validation failure
- Add error handling with standardized response format
- Follow detected framework conventions

</step_3_create_routes>


<step_4_verify>

Verify the scaffolded output:

- All endpoints from spec have corresponding route handlers
- TypeScript compiles without errors
- Validation middleware is wired to each route
- Error handlers return consistent response format

</step_4_verify>


</workflow>


<error_handling>

- If framework cannot be detected, then ask user to specify: "Express, Fastify, or other?"
- If OpenAPI spec has validation errors, then report specific errors and stop: "Fix spec before scaffolding"
- If conflicting route patterns exist, then flag conflicts and ask user to resolve before generating
- If required middleware package is missing, then include installation command in output

</error_handling>


<!-- P1/P2/P3 validation tiers: P1 blocks delivery, P2 degrades quality, P3 is optional polish -->
<validation>

**P1 (blocking):**

- Every endpoint in spec has a corresponding route handler file
- All generated TypeScript compiles without type errors

**P2 (quality):**

- Validation middleware is attached to every route that accepts input
- Error responses follow the standardized format

**P3 (polish):**

- Route handlers follow detected framework conventions consistently
- Generated types use descriptive names matching the API schema

</validation>


<resources>

- [framework-patterns.md](./references/framework-patterns.md) — framework detection rules and route conventions. Load for `<step_1_analyze>`, `<step_3_create_routes>`
- [validation-schemas.md](./references/validation-schemas.md) — validation middleware patterns per framework. Load for `<step_3_create_routes>`

</resources>
```
