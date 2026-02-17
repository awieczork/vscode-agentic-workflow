---
# applyTo glob '**/*.ts' auto-attaches this instruction when any .ts file appears in context
applyTo: '**/*.ts'
description: 'TypeScript coding standards for type safety, naming, and error handling'
---

This file defines TypeScript rules for all `.ts` files. The governing principle is strict type safety — prefer explicit types over inference for public APIs.


<type_safety>

Type safety rules enforce explicit contracts at module boundaries.

- NEVER use `any` without explicit narrowing
- ALWAYS prefer `unknown` over `any` and narrow with type guards
- ALWAYS use `interface` for extensible object shapes, `type` for unions and intersections
- NEVER export a function without an explicit return type annotation

</type_safety>


<naming_conventions>

Naming rules ensure consistency and readability across the codebase.

- ALWAYS use `PascalCase` for types, interfaces, enums, and classes
- ALWAYS use `camelCase` for variables, functions, and methods
- NEVER prefix interfaces with `I` — use descriptive nouns instead (e.g., `UserService`, not `IUserService`)

</naming_conventions>


<error_handling>

Error handling rules prevent silent failures and enforce recoverable error paths.

- NEVER swallow exceptions with empty `catch` blocks — log or rethrow
- ALWAYS use typed error classes extending `Error` instead of throwing plain strings
- NEVER use `Promise` without a `.catch()` handler or `try/catch` in an `async` function

</error_handling>
