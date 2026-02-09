---
description: 'Generate R/tidyverse EDA code for summary statistics, distributions, missing data, and correlations'
agent: 'churn-analyst'
argument-hint: 'Describe your dataset — column names, types, and what you want to explore'
---

Analyze the following dataset and generate R/tidyverse code that performs a complete exploratory data analysis.

Dataset: ${input:dataset_description}

<task>

Generate R code covering each of these analyses:

1. Summary statistics — use `summarize(across(...))` with `mean`, `median`, `sd`, `quantile` for all numeric columns
2. Frequency tables — use `count()` for each categorical column, sorted by descending frequency
3. Missing data audit — count and percentage of `NA` values per column using `summarize(across(everything(), ...))`
4. Distribution visualizations — `geom_histogram()` or `geom_density()` for key numeric variables, faceted with `facet_wrap()` when multiple variables
5. Correlation matrix — compute with `cor(use = "complete.obs")` on numeric columns, visualize as a heatmap with `geom_tile()` and `scale_fill_gradient2()`
6. Initial observations — print findings as inline comments noting skewness, outliers, or data quality concerns

</task>

<format>

- Load `library(tidyverse)` at the top
- Use pipe operator `|>` throughout
- Use `across()` with tidy-select helpers (`where(is.numeric)`, `where(is.character)`) to operate on column groups
- Add inline comments (`#`) explaining each analysis step and what to look for in the output
- Use `theme_minimal()` for all plots
- Name each plot object descriptively (e.g., `p_distributions`, `p_correlation`)

</format>

<output>

Return a single R code block followed by a brief summary listing:

- Key statistics to inspect in the output
- Potential data quality concerns (high missingness, zero-variance columns, skewed distributions)
- Suggested next steps based on the data shape

</output>
