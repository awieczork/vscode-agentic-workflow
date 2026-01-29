# Copilot Instructions: patterns-shiny-app

## Project Context

This is an R/Shiny web application for visualizing user session patterns through document relationship graphs.

**Stack:** R 4.4+, Shiny, bslib, visNetwork, reactable, Arrow/Parquet
**Deployment:** Docker (rocker/shiny-verse) on internal server
**Data Volume:** ~800k sessions, ~200k documents, ~20k patterns

## Commands

```bash
# Development
Rscript -e "shiny::runApp('app', port = 3838)"

# Docker
docker-compose -f docker/docker-compose.yml up --build
docker-compose -f docker/docker-compose.yml down

# Validate data schema
Rscript .github/skills/data-schema/scripts/validate_schema.R
```

## Code Style

### DO ✅
- Use `snake_case` for all names
- Use `<-` for assignment
- Use `::` notation in modules (e.g., `shiny::reactive()`)
- Add roxygen2 documentation to functions
- Use `NS()` and `ns()` for module namespacing
- Guard inputs with `req()`
- Use Arrow lazy evaluation — filter before `collect()`

### DON'T ❌
- Use `library()` inside Shiny modules
- Use `<<-` (global assignment) in modules
- Use `rm(list = ls())`
- Hardcode file paths — use `here::here()`
- Load full datasets when filtering is possible

## File Conventions

| Type | Location | Naming |
|------|----------|--------|
| Modules | `app/R/` | `mod_{name}_ui.R`, `mod_{name}_server.R` |
| Utilities | `app/R/` | `utils_{purpose}.R` |
| Styles | `app/www/` | `styles.css` |
| Docker | `docker/` | `Dockerfile`, `docker-compose.yml` |
| Data | `data/` | Mounted volume (not in repo) |

## Theme Colors

```r
theme_colors <- list(
  primary = "#007AC3",
  secondary = "#85BC20"
)
```

Use with bslib:
```r
bslib::bs_theme(
  primary = "#007AC3",
  secondary = "#85BC20"
)
```

## Data Access Pattern

Always use Arrow lazy evaluation for large data:

```r
# GOOD: Filter before collecting
arrow::open_dataset("data/sessions/") |>
  dplyr::filter(segment == selected_segment) |>
  dplyr::select(session_id, pattern_id, start_date) |>
  dplyr::collect()

# BAD: Loading everything
arrow::read_parquet("data/sessions/") |>
  dplyr::filter(segment == selected_segment)
```

## Module Pattern

```r
# UI: mod_example_ui.R
mod_example_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    shiny::textInput(ns("input"), "Label")
  )
}

# Server: mod_example_server.R
mod_example_server <- function(id, data) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::reactive({ input$input })
  })
}
```

## IMPORTANT — Safety Rules

- **Never** commit data files to the repository
- **Never** expose ports other than 3838 without approval
- **Never** bake credentials into Docker images
- **Never** suppress R warnings globally
- **Always** validate user inputs before data queries

## Available Prompts

| Prompt | Purpose |
|--------|---------|
| `/new-module` | Create a new Shiny module |
| `/add-filter` | Add filter to filter panel |
| `/optimize-graph` | Optimize visNetwork for large graphs |
| `/debug-reactivity` | Debug Shiny reactive issues |

## Agents

| Agent | Purpose |
|-------|---------|
| `@shiny-dev` | R/Shiny development |
| `@docker-deploy` | Docker containerization |
| `@architect` | Planning |
| `@build` | General implementation |
| `@inspect` | Verification |
