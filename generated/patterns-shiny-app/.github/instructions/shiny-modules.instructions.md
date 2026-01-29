---
applyTo: "**/mod_*.R"
name: "Shiny Module Conventions"
description: "Standards for R/Shiny module files ensuring consistent namespacing, structure, and reactivity patterns"
---

# Shiny Module Conventions

> Rules for creating maintainable, properly-namespaced Shiny modules.

---

## File Naming

- Name UI function files: `mod_{name}_ui.R`
- Name server function files: `mod_{name}_server.R`
- Use snake_case for module names: `mod_data_table_ui.R`, not `mod_dataTable_ui.R`
- Keep UI and server in separate files for modules with significant logic

---

## Namespacing

- **Always** wrap UI element IDs in `ns()`: `textInput(ns("input_id"), ...)`
- **Always** create namespace function at top of UI: `ns <- NS(id)`
- **Never** hardcode IDs without namespace — this breaks module encapsulation
- Use consistent `id` parameter naming in both UI and server functions

```r
# ✅ Correct namespacing
mod_example_ui <- function(id) {
  ns <- NS(id)
  tagList(
    textInput(ns("name"), "Name"),
    actionButton(ns("submit"), "Submit")
  )
}
```

---

## Server Pattern

- **Always** use `moduleServer()` pattern (introduced in Shiny 1.5.0)
- **Never** use deprecated `callModule()` pattern
- Match the `id` parameter between UI and server functions

```r
# ✅ Correct: moduleServer pattern
mod_example_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # module logic here
  })
}

# ❌ Deprecated: callModule pattern
# callModule(mod_example_server, "example")
```

---

## Input Guards

- **Always** use `req()` for optional or conditional inputs
- Place `req()` at the start of reactive expressions that depend on optional values
- Use `req(FALSE)` to silently cancel reactive execution when needed
- Prefer `req()` over `validate(need())` for simple presence checks

```r
# ✅ Guarded reactive
filtered_data <- reactive({
  req(input$dataset)
  req(input$filter_column)
  # processing logic
})
```

---

## Return Values

- **Always** return `reactive()` or `reactiveValues()` from server functions
- **Never** return raw values — they won't update when dependencies change
- Document return structure in function comments
- Use named lists for multiple return values

```r
# ✅ Correct: return reactive
mod_filter_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    filtered <- reactive({
      req(input$filter)
      data() |> dplyr::filter(category == input$filter)
    })

    return(filtered)  # Returns reactive, not raw data
  })
}
```

---

## Documentation

- Document module inputs at the top of each file
- Document module outputs (return values) clearly
- Specify expected reactive vs static inputs
- Include usage example in comments

```r
#' Filter Module Server
#'
#' @param id Character. Module namespace ID.
#' @param data Reactive. Data frame to filter (must be reactive).
#'
#' @return Reactive data frame with applied filters.
#'
#' @example
#' # In app server:
#' filtered <- mod_filter_server("filter1", reactive(my_data))
```

---

## Package References

- **Never** use `library()` calls inside module files
- **Always** use explicit `::` notation for external packages
- This ensures dependencies are clear and avoids namespace conflicts

```r
# ✅ Correct: explicit namespace
dplyr::filter(data, condition)
shiny::reactive({ ... })
DT::renderDataTable({ ... })

# ❌ Wrong: library calls in modules
library(dplyr)
filter(data, condition)
```

---

## Variable Scope

- **Never** access global variables from within modules
- **Always** pass data as function parameters (preferably reactive)
- Use parent module or app-level data passing, not global assignment
- Avoid `<<-` operator — it breaks module encapsulation

```r
# ✅ Correct: data passed as parameter
mod_chart_server <- function(id, chart_data) {
  moduleServer(id, function(input, output, session) {
    output$plot <- shiny::renderPlot({
      ggplot2::ggplot(chart_data(), ggplot2::aes(x, y)) +
        ggplot2::geom_point()
    })
  })
}

# ❌ Wrong: accessing global variable
mod_chart_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$plot <- shiny::renderPlot({
      ggplot2::ggplot(global_data, ...)  # Never do this
    })
  })
}
```

---

## IMPORTANT — Required Practices

- **Always** namespace all input/output IDs with `ns()`
- **Always** use `moduleServer()`, never `callModule()`
- **Never** use `library()` in module files
- **Never** access or modify global variables
