# Example: TypeScript Standards Instruction

A complete Path-Specific instruction demonstrating coding standards for TypeScript files.

---

```markdown
---
applyTo: "**/*.ts"
name: "TypeScript Standards"
description: "Type safety and coding conventions for TypeScript files in this project"
---

# TypeScript Standards

Enforce strict type safety and consistent patterns across all TypeScript code.

## Core Rules

- Enable `strict: true` in tsconfig.json for all projects
- Use `interface` for object shapes that may be extended
- Use `type` for unions, intersections, and mapped types
- Prefer `unknown` over `any` — narrow types explicitly
- Export types alongside their implementations
- Use `readonly` for properties that should not be reassigned
- Prefer `const` assertions for literal types (`as const`)
- NEVER use `@ts-ignore` without a linked issue explaining why
- ALWAYS handle null and undefined explicitly — no implicit any

## Code Standards

### Correct

```typescript
// Explicit return types on exported functions
export function calculateTotal(items: readonly Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// Interface for extensible object shapes
interface UserProfile {
  readonly id: string;
  name: string;
  email: string;
}

// Type for unions and complex types
type Status = 'pending' | 'active' | 'completed';
type Result<T> = { success: true; data: T } | { success: false; error: Error };

// Narrowing unknown instead of using any
function processInput(input: unknown): string {
  if (typeof input === 'string') {
    return input.toUpperCase();
  }
  throw new Error('Expected string input');
}
```

### Incorrect

```typescript
// Missing return type on exported function
export function calculateTotal(items: Item[]) {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// Using any instead of unknown
function processInput(input: any): string {
  return input.toUpperCase(); // Runtime error if not string
}

// Mutable array parameter
function sortItems(items: Item[]): Item[] {
  return items.sort(); // Mutates original array
}

// Suppressing errors without explanation
// @ts-ignore
const value = someUntypedLibrary.getValue();
```

## Anti-Patterns

- **Excessive type assertions (`as`)**: Indicates type system is fighting you — fix the types instead
- **Empty interfaces**: Use `type X = Record<string, never>` or `unknown` instead
- **Nested ternaries in types**: Extract to named type aliases for readability
- **Ignoring strict null checks**: Handle null/undefined explicitly, don't disable the check
- **Using `Function` type**: Use specific function signatures (`() => void`, `(x: string) => number`)
```

---

## Why This Example Works

**Pattern → Purpose:**
- `applyTo: "**/*.ts"` → Targets only TypeScript files, not consuming tokens for other file types
- Imperative voice ("Use X", "Prefer Y") → Direct, actionable guidance
- NEVER/ALWAYS for safety rules → Signals non-negotiable constraints
- Correct/incorrect code pairs → Eliminates ambiguity about what "prefer unknown over any" means in practice
- Anti-patterns section → Addresses common mistakes that rules alone don't prevent

**Demonstrates:**
- L2 (Excellent) quality with code examples and anti-patterns
- Specific rules with versions implied (modern TypeScript strict mode)
- Self-contained — no dependencies on other instruction files
- Size discipline — under 100 lines while covering comprehensive standards
- Real patterns developers encounter (readonly, narrowing, type vs interface)

**Stackability:**
- Complements (not conflicts with) potential `react.instructions.md` or `testing.instructions.md`
- Rules are TypeScript-specific, not framework-specific
- Could stack with Repo-Wide project context without contradiction
