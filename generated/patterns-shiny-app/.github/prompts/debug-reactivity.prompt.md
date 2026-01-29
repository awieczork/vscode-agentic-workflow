---
name: debug-reactivity
description: Debug Shiny reactivity issues - missing updates, circular dependencies, performance
agent: shiny-dev
---

# Debug Reactivity

Diagnose and fix Shiny reactive programming issues.

## Input

- **Symptom:** ${input:symptom:Describe what's not working (e.g., "output not updating", "infinite loop", "slow response")}

## Diagnostic Process

### Step 1: Enable Reactlog

Add to app startup:
```r
# At top of app.R or in .Rprofile
reactlog::reactlog_enable()

# Run app, reproduce issue, then:
shiny::reactlogShow()
```

This visualizes the reactive dependency graph.

### Step 2: Identify Symptom Category

| Symptom | Likely Cause | Check |
|---------|--------------|-------|
| Output not updating | Missing dependency | Reactive doesn't reference input |
| Infinite loop | Circular dependency | A → B → A chain |
| Slow response | Over-invalidation | Too many dependencies |
| NULL errors | Missing guards | No `req()` on optional inputs |
| Stale values | Using `isolate()` wrong | Value captured at wrong time |

### Step 3: Common Fixes

#### Missing Update
```r
# WRONG: output doesn't depend on input
output$result <- renderText({
  "Static text"
})

# RIGHT: explicitly reference input
output$result <- renderText({
  paste("You entered:", input$search)
})
```

#### Missing Guard
```r
# WRONG: crashes if input is NULL
output$table <- renderReactable({
  reactable(filtered_data())
})

# RIGHT: guard against NULL
output$table <- renderReactable({
  req(filtered_data())
  req(nrow(filtered_data()) > 0)
  reactable(filtered_data())
})
```

#### Circular Dependency
```r
# WRONG: A updates B, B updates A
observeEvent(input$a, {
  updateSelectInput(session, "b", selected = input$a)
})
observeEvent(input$b, {
  updateSelectInput(session, "a", selected = input$b)
})

# RIGHT: use flags or combine logic
values <- reactiveValues(updating = FALSE)
observeEvent(input$a, {
  if (!values$updating) {
    values$updating <- TRUE
    updateSelectInput(session, "b", selected = input$a)
    values$updating <- FALSE
  }
})
```

#### Over-invalidation
```r
# WRONG: entire reactive reruns on any filter change
filtered <- reactive({
  data |>
    filter(segment == input$segment) |>
    filter(industry == input$industry) |>
    filter(date >= input$date[1]) |>
    expensive_computation()
})

# RIGHT: separate cheap filters from expensive computation
base_filtered <- reactive({
  data |>
    filter(segment == input$segment) |>
    filter(industry == input$industry)
})

computed <- reactive({
  req(base_filtered())
  expensive_computation(base_filtered())
}) |> bindCache(input$segment, input$industry)
```

### Step 4: Performance Tools

```r
# Add timing to slow reactives
filtered_data <- reactive({
  start <- Sys.time()
  result <- # ... computation
  message("filtered_data took: ", Sys.time() - start)
  result
})

# Use profvis for detailed profiling
profvis::profvis({
  shiny::runApp()
})
```

## Checklist

- [ ] Reproduced issue consistently
- [ ] Enabled reactlog and visualized graph
- [ ] Identified root cause category
- [ ] Applied fix with minimal changes
- [ ] Verified fix doesn't introduce new issues
- [ ] Added guards to prevent future issues
