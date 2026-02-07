A complete Path-Specific instruction demonstrating coding standards for TypeScript files. This example shows L2 (Excellent) quality with grouped format, Wrong/Correct pairs, and justification for training-deviant rules.

---

```markdown
---
applyTo: "**/*.ts"
name: "TypeScript Standards"
description: "Type safety and coding conventions for TypeScript files in this project"
---

Enforce strict type safety and consistent patterns across all TypeScript code. The governing principle is: catch errors at compile time, not runtime — every `any` is a deferred bug.


<type_system>

<rules>

- Enable `strict: true` in tsconfig.json for all projects
- Use `interface` for object shapes that may be extended
- Use `type` for unions, intersections, and mapped types
- Prefer `unknown` over `any` — narrow types explicitly
- Export types alongside their implementations
- Use `readonly` for properties that should not be reassigned
- Prefer `const` assertions for literal types (`as const`)
- NEVER use `@ts-ignore` without a linked issue explaining why
- ALWAYS handle null and undefined explicitly — no implicit any

</rules>

<justification>

The interface/type distinction follows TypeScript team recommendations and enables declaration merging where needed. Preferring `unknown` over `any` forces explicit narrowing, catching type errors that `any` silently permits. The `@ts-ignore` constraint ensures suppressions are tracked and revisited.

</justification>

<benefit>

Type errors surface during development instead of production. Code is self-documenting through explicit type signatures.

</benefit>

<anti_patterns>

- Wrong: `function process(input: any)` → Correct: `function process(input: unknown)` with type guard
- Wrong: Empty `interface {}` → Correct: `type X = Record<string, never>` or `unknown`
- Wrong: `as Type` assertion → Correct: Type guard with narrowing
- Wrong: `// @ts-ignore` without context → Correct: `// @ts-ignore — tracked in ISSUE-123`
- Wrong: `Function` type → Correct: Specific signature `(x: string) => number`

</anti_patterns>

</type_system>


<code_examples>

<rules>

- Add explicit return types on all exported functions
- Use `readonly` array parameters to prevent mutation
- Narrow `unknown` with type guards, not assertions

</rules>

<anti_patterns>

- Wrong: `export function calculateTotal(items: Item[])` (missing return type, mutable param) → Correct: `export function calculateTotal(items: readonly Item[]): number`
- Wrong: `return input.toUpperCase()` on `any` param → Correct: `if (typeof input === 'string') { return input.toUpperCase(); }` with `unknown` param

</anti_patterns>

</code_examples>
```

---

<why_this_works>

**Pattern → Purpose:**
- `applyTo: "**/*.ts"` → Targets only TypeScript files, not consuming tokens for other file types
- Grouped format with `<type_system>` and `<code_examples>` → Domain-specific tag names avoid stacking conflicts
- `<justification>` included → These rules deviate from defaults (e.g., `unknown` over `any` is not the path of least resistance)
- Wrong/Correct pairs in `<anti_patterns>` → Eliminates ambiguity about what "prefer unknown over any" means in practice
- Opening prose with governing principle → Agent understands the WHY, not just the WHAT

**Demonstrates:**
- L2 (Excellent) quality: grouped format, justification, anti-patterns
- Self-contained — no dependencies on other instruction files
- Size discipline — under 80 lines while covering comprehensive standards
- XML-only structure — no markdown headings anywhere

</why_this_works>
- Real patterns developers encounter (readonly, narrowing, type vs interface)

**Stackability:**
- Complements (not conflicts with) potential `react.instructions.md` or `testing.instructions.md`
- Rules are TypeScript-specific, not framework-specific
- Could stack with Repo-Wide project context without contradiction
