```markdown
<!-- applyTo glob '**/*.ts' auto-attaches this instruction when any .ts file appears in context -->
---
applyTo: '**/*.ts'
description: 'TypeScript coding standards for type safety and naming conventions'
---

<!-- prose intro states scope and governing principle; content is scoped to .ts files only -->
This file defines TypeScript rules for all `.ts` files. The governing principle is strict type safety — prefer explicit types over inference for public APIs.


<type_safety>

- NEVER use `any` without explicit narrowing
- Prefer `unknown` over `any` and narrow with type guards
- Use `interface` for extensible object shapes, `type` for unions and intersections

</type_safety>
```
