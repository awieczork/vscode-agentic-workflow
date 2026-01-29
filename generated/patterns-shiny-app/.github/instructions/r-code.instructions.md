---
applyTo: "**/*.R"
name: "R Code Standards"
description: "R code style and quality rules for Shiny application development"
---

# R Code Standards

> Rules for writing consistent, maintainable R code in this Shiny application.

## Style Guide

- ✅ Follow the [Tidyverse style guide](https://style.tidyverse.org/)
- ✅ Use `snake_case` for variable and function names
- ✅ Use `<-` for assignment, not `=`
- ✅ Keep lines under 80 characters
- ✅ Use meaningful, descriptive names for variables and functions

## Package Usage in Modules

- ✅ Use `::` notation for package functions (e.g., `dplyr::filter()`, `shiny::reactive()`)
- ✅ Import only what you need at the module level
- ❌ Do NOT use `library()` calls inside Shiny modules
- ❌ Do NOT use `require()` inside modules

## Data Manipulation

- ✅ Prefer `arrow` or `data.table` for large data operations
- ✅ Use `dplyr` verbs for data transformation when appropriate
- ✅ Chain operations with the pipe operator `|>` or `%>%`

## Documentation

- ✅ Add roxygen2 documentation to all exported functions:
  ```r
  #' Calculate summary statistics
  #'
  #' @param data A data frame with numeric columns
  #' @param column Character string specifying the column name
  #' @return A named numeric vector with summary statistics
  #' @export
  calculate_summary <- function(data, column) {
    # implementation
  }
  ```
- ✅ Document parameters, return values, and examples

## File Paths

- ✅ Use `here::here()` for all file paths
- ❌ Do NOT use absolute paths
- ❌ Do NOT use `setwd()`

## Theme Colors

When styling Shiny components, use project colors:
- **Primary:** `#007AC3` (blue)
- **Secondary:** `#85BC20` (green)

Example:
```r
theme_colors <- list(
  primary = "#007AC3",
  secondary = "#85BC20"
)
```

## IMPORTANT — Prohibited Patterns (No Exceptions)

- **Never** use `rm(list = ls())` — breaks reproducibility and can cause silent failures
- **Never** use `<<-` (global assignment) inside modules — violates encapsulation
- **Never** use `attach()` or `detach()` — causes namespace pollution
- **Never** suppress warnings globally with `options(warn = -1)`
- **Always** handle errors explicitly with `tryCatch()` where appropriate
