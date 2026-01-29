---
name: add-filter
description: Add a new filter control to the session filter panel
agent: shiny-dev
---

# Add Filter

Add a new filter input to the session filtering module.

## Input

- **Filter Name:** ${input:filterName:Filter name in snake_case (e.g., date_range, segment)}
- **Filter Type:** ${input:filterType:Type of input - select, dateRange, text, numeric}

## Task

Add a new filter to `app/R/mod_filters_ui.R` and `app/R/mod_filters_server.R`:

### UI Changes

1. Add appropriate input control based on filter type:
   - `select` → `shiny::selectInput()` with server-side choices
   - `dateRange` → `shiny::dateRangeInput()`
   - `text` → `shiny::textInput()` with debounce
   - `numeric` → `shiny::numericInput()` or `shiny::sliderInput()`

2. Include tooltip explaining the filter
3. Wrap ID with `ns()` for namespacing

### Server Changes

1. Add reactive to process filter value
2. Include in the returned filter list
3. Add `req()` guard if filter is optional
4. Update data filtering logic

### Data Layer

1. Verify filter column exists in Arrow dataset
2. Add filter to `utils_data.R` query functions

## Example for Select Filter

```r
# UI
shiny::selectInput(
  ns("${filterName}"),
  label = "${filterName} Filter",
  choices = NULL,  # Populated by server
  selected = NULL,
  multiple = TRUE
)

# Server
shiny::observe({
  choices <- data() |>
    dplyr::distinct(${filterName}) |>
    dplyr::pull()
  shiny::updateSelectInput(session, "${filterName}", choices = choices)
})
```
