# Example: API Scaffold Skill

A complete working skill demonstrating Medium complexity with references.

---

```markdown
---
name: 'api-scaffold'
description: Creates REST API endpoint structures. Use when user asks to "add endpoint", "create route", "scaffold API", or "generate controller". Produces route handlers with validation, error handling, and TypeScript types.
---

# API Scaffold

Create REST API endpoint structure with route, controller, validation, and types.

<steps>

## Steps

1. **Gather Requirements**
   - Identify HTTP method (GET, POST, PUT, DELETE, PATCH)
   - Identify resource name (users, products, orders)
   - Identify path parameters (`:id`, `:slug`)
   - Identify request body schema (for POST/PUT/PATCH)
   - Identify response schema

2. **Determine File Locations**
   - Route file: `src/routes/{resource}.routes.ts`
   - Controller: `src/controllers/{resource}.controller.ts`
   - Validation: `src/validators/{resource}.validator.ts`
   - Types: `src/types/{resource}.types.ts`

3. **Generate Type Definitions**
   Use #tool:editFiles to create `src/types/{resource}.types.ts`:
   - Request interfaces (params, query, body)
   - Response interfaces
   - Export all types

4. **Generate Validation Schema**
   Use #tool:editFiles to create `src/validators/{resource}.validator.ts`:
   - Import validation library (zod, joi, or project standard)
   - Define request body schema
   - Define query parameter schema
   - Export validators

5. **Generate Controller**
   Use #tool:editFiles to create `src/controllers/{resource}.controller.ts`:
   - Import types and validators
   - Create handler function with typed request/response
   - Add try/catch with error handling
   - Return appropriate status codes

6. **Generate Route**
   Use #tool:editFiles to create or update `src/routes/{resource}.routes.ts`:
   - Import controller and validators
   - Define route with method and path
   - Attach validation middleware
   - Export router

7. **Register Route**
   Update `src/routes/index.ts` to import and use new router.

8. **Verify Structure**
   - Confirm all 4 files created
   - Confirm route registered in index
   - Confirm no TypeScript errors

</steps>

<error_handling>

## Error Handling

If resource name unclear: Ask "What resource does this endpoint manage?"

If HTTP method unclear: Default to GET for retrieval, POST for creation

If project structure differs: Ask "Where should route files be created?"

If validation library unknown: Check `package.json` for zod/joi/yup, default to zod

If TypeScript not used: Skip type generation, adjust imports accordingly

</error_handling>

<validation>

## Validation

Before complete:
- [ ] All 4 files created (types, validator, controller, route)
- [ ] Route registered in main router
- [ ] No TypeScript compilation errors
- [ ] Imports resolve correctly

</validation>

<notes>

## Notes

- This skill assumes Express.js or similar routing pattern
- For Fastify, Hono, or other frameworks, adjust route syntax
- Generated code follows REST conventions (plural resource names, standard methods)

</notes>
```

---

## Why This Example Works

**Demonstrates key patterns:**
- Description following [What it does] + [When to use it] + [Key capabilities]
- Numbered steps with clear actions
- Tool references (`#tool:editFiles`) where specific
- Error handling for common ambiguities
- Validation checklist for verifiable completion

**Shows Medium complexity:**
- 8 steps requiring coordination
- Multiple file outputs
- Framework-aware decisions
- Could benefit from `references/` for framework variants

**Different domain:**
- Not a "creator" skill (avoids meta-confusion)
- Practical utility (commonly needed)
- Shows skill scope (single capability: scaffold endpoint)
