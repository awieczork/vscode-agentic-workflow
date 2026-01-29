---
name: shiny-module
description: Scaffold new Shiny modules with UI and server components following Tidyverse style, NS() namespacing, and project conventions. Invoke when creating a new feature module for the Shiny application.
metadata:
  author: patterns-shiny-app
  version: "1.0.0"
  tags: [r, shiny, module, scaffolding, bslib]
---

# Shiny Module Scaffolder

Generate properly structured Shiny modules with UI and server files following project conventions.

## Steps

1. **Receive module name** — Get the module name from user (e.g., `dashboard`, `data_table`, `chart_view`)

2. **Validate module name** — Ensure name follows snake_case convention (lowercase, underscores only)

3. **Create UI file** — Generate `R/mod_{name}_ui.R` using the UI template:
   - Copy template from `assets/mod_template_ui.R`
   - Replace `{MODULE_NAME}` with actual name
   - Replace `{MODULE_TITLE}` with Title Case version
   - Update roxygen2 `@title` and `@description`

4. **Create server file** — Generate `R/mod_{name}_server.R` using the server template:
   - Copy template from `assets/mod_template_server.R`
   - Replace `{MODULE_NAME}` with actual name
   - Replace `{MODULE_TITLE}` with Title Case version
   - Update roxygen2 documentation

5. **Register module** — Add module sourcing to `global.R` or appropriate loader:
   ```r
   source("R/mod_{name}_ui.R")
   source("R/mod_{name}_server.R")
   ```

6. **Wire into app** — Instruct user to add to `app.R` or parent module:
   ```r
   # In UI
   mod_{name}_ui("id_{name}")
   
   # In Server
   mod_{name}_server("id_{name}")
   ```

## Templates

Templates are located in the `assets/` folder:

- [mod_template_ui.R](assets/mod_template_ui.R) — UI function template
- [mod_template_server.R](assets/mod_template_server.R) — Server function template

## Error Handling

If module name contains invalid characters: Reject and request snake_case format (e.g., `my_module`)

If module files already exist: Warn user and ask for confirmation before overwriting

If R/ directory doesn't exist: Create `R/` directory first

If roxygen2 not installed: Skip documentation build step, note for user

## Validation

After generation, verify:

- [ ] `R/mod_{name}_ui.R` exists and contains valid R syntax
- [ ] `R/mod_{name}_server.R` exists and contains valid R syntax
- [ ] Both files use `NS("{name}")` namespacing consistently
- [ ] roxygen2 headers are complete
- [ ] Functions follow pattern: `mod_{name}_ui` and `mod_{name}_server`

Run `devtools::check()` or `lintr::lint_dir("R/")` to verify code quality.

## Project Theme Reference

Use these theme colors from project palette:

```r
# Primary colors (reference in bslib components)
# primary: "#0d6efd"
# secondary: "#6c757d"
# success: "#198754"
# warning: "#ffc107"
# danger: "#dc3545"
```
