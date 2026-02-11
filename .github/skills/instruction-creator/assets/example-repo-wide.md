<!-- repo-wide instructions have NO frontmatter — content begins immediately with prose intro -->
This project prioritizes type safety and explicit error handling across all code. Every module follows functional patterns unless framework constraints require otherwise.

<!-- each XML group scopes one concern; domain-specific tag names replace markdown headings -->
<naming_conventions>

- Use PascalCase for types, interfaces, and class names
- Use camelCase for variables, functions, and methods
- Use UPPER_SNAKE_CASE for constants and environment variables

</naming_conventions>


<error_handling>

- ALWAYS handle Promise rejections explicitly
- NEVER swallow errors with empty catch blocks
- Use typed error classes for domain-specific errors

Wrong: `catch (e) {}` (empty catch) → Correct: `catch (e) { logger.error(e); throw new DomainError(e); }`

</error_handling>
