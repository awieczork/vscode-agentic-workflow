---
description: 'Generate publication-ready ggplot2 visualization code from a natural language chart description'
agent: 'churn-analyst'
argument-hint: 'Describe the chart you want — data columns, chart type, grouping, and any styling preferences'
---
Generate ggplot2 code for the following visualization:

${input:chart_description}

<task>

Produce a complete, runnable R code block that creates the described chart. Follow these rules:

- Expect a dataframe in long/tidy format — use `tidyr::pivot_longer()` if reshaping is needed
- Select the appropriate geom based on data type and chart request:
  - Categorical × continuous → `geom_col()`, `geom_boxplot()`, `geom_violin()`
  - Continuous × continuous → `geom_point()`, `geom_smooth()`, `geom_line()`
  - Single continuous → `geom_histogram()`, `geom_density()`
  - Error bars → `geom_errorbar()`, `geom_pointrange()`
- Map grouping variables to `color`, `fill`, or `shape` aesthetics as appropriate
- Apply `facet_wrap()` or `facet_grid()` when the description requests panel splits
- Use `coord_flip()` or mapped y-axis orientation when horizontal layout improves readability

</task>

<format>

Structure the output as a single R code block:

- Load `library(tidyverse)` at the top
- Add comments explaining each aesthetic mapping and layer choice
- Mark customization points with `# CUSTOMIZE:` comments for colors, labels, and theme tweaks
- Apply `theme_minimal()` as the default theme — note `theme_bw()` as an alternative
- Include `labs()` with `title`, `x`, `y`, and legend title
- Use `scale_color_brewer()` or `scale_fill_brewer()` with a sensible palette for grouped data
- End with a comment block listing common modifications: adjusting `base_size`, rotating axis labels, saving with `ggsave()`

</format>
