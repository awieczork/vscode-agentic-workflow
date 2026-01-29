---
name: new-module
description: Create a new Shiny module with UI and server files
agent: shiny-dev
---

# New Shiny Module

Create a new modular Shiny component following project conventions.

## Input

- **Module Name:** ${input:moduleName:Module name in snake_case (e.g., pattern_list)}
- **Description:** ${input:moduleDescription:Brief description of what this module does}

## Task

Create a new Shiny module with the following:

1. **UI file** at `app/R/mod_${moduleName}_ui.R`:
   - Use `NS()` for namespacing
   - Include `bslib::card()` wrapper
   - Add tooltip for user guidance
   - Apply project theme colors (#007AC3 primary, #85BC20 secondary)

2. **Server file** at `app/R/mod_${moduleName}_server.R`:
   - Use `moduleServer()` pattern
   - Add `req()` guards for inputs
   - Return reactive for cross-module communication
   - Include roxygen2 documentation

3. **Update `app/app.R`** to register the new module

## Requirements

- Follow Tidyverse style guide
- Use `::` notation for packages (no `library()` calls)
- Document all parameters with roxygen2
- Include meaningful tooltip text

## Reference

See `.github/skills/shiny-module/` for templates and examples.
