---
applyTo: ['**/*.R', '**/*.Rmd', '**/*.qmd']
description: 'R tidyverse coding standards for style consistency and naming conventions'
---

This file defines tidyverse style rules for all R scripts and notebooks. The governing principle is consistency — follow the [tidyverse style guide](https://style.tidyverse.org/) for naming, syntax, and pipe usage across all R code.


<naming_conventions>

- Use `snake_case` for all variable and function names — Wrong: `dayOne`, `DayOne` — Correct: `day_one`
- NEVER use `T`/`F` as abbreviations for `TRUE`/`FALSE` — explicit values prevent silent errors when `T` or `F` are reassigned
- Use meaningful, descriptive variable names — no single-letter names except loop indices (`i`, `j`, `k`)
- Name variables as nouns and functions as verbs — Wrong: `data_process` — Correct: `process_data`
- Avoid reusing names of common functions and variables — Wrong: `c <- 10`, `mean <- function(x) sum(x)` — Correct: use distinct, non-shadowing names

</naming_conventions>


<syntax_rules>

- Use `<-` for assignment, not `=` — Wrong: `x = 5` — Correct: `x <- 5`
- Limit lines to 80 characters — break long function calls with one argument per line, indented
- NEVER use `attach()` — causes namespace collisions and unpredictable name resolution
- Prefer tidyverse verbs (`filter`, `mutate`, `summarize`, `select`, `arrange`) over base R equivalents (`subset`, `transform`, `aggregate`)
- Use explicit column selection with `select()` or `pull()` instead of positional indexing — Wrong: `df[, 3]` — Correct: `df |> select(revenue)`
- Surround most infix operators (`<-`, `==`, `+`, `|>`) with spaces — exceptions: `::`, `$`, `[`, `^`
- Use `"` for quoting text, not `'` — exception: text already containing double quotes
- Use braced expressions `{}` for all loop and multi-line `if` statement bodies

</syntax_rules>


<pipe_and_organization>

- Use the pipe operator `|>` for multi-step transformations — prefer base pipe `|>` over magrittr `%>%` for R ≥4.1
- Place each pipe step on its own line, indented by two spaces
- Group related operations in pipe chains — break chains at logical boundaries between distinct transformations
- Avoid pipes when manipulating multiple objects simultaneously or when meaningful intermediate objects deserve informative names
- Place all `library()` calls at the top of scripts, one per line — no inline `library()` calls mid-script
- Use commented section headers (`# Section name -----`) to break scripts into readable chunks
- Comment non-obvious data transformations with the business reason — explain *why*, not *what*

<example>

```r
# Wrong — positional indexing, no pipe, = assignment, T abbreviation
result = df[df[,3] > 100, c(1,2)]
complete = result[complete.cases(result), ]

# Correct — explicit selection, pipe chain, <- assignment, TRUE literal
result <- df |>
  filter(revenue > 100) |>
  select(customer_id, segment) |>
  drop_na()
```

</example>

</pipe_and_organization>
