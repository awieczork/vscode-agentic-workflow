---
description: 'Start a project interview — fill the seed below and run this prompt'
agent: 'interviewer'
---

<!-- Fill what you know, leave the rest empty. @interviewer covers gaps during the interview. -->

```yaml
name: "Churn Usage Analysis"              # Project name
area: "Data Science"              # e.g. "fintech", "data science", "devops"
goal: "Analysis of Kelos customer churn based on Pendo usage data"              # One sentence: what does this project achieve?
tech: [R, tidyverse, SQL, Redshift]              # Everything: languages, frameworks, DBs, libraries, tools
sources:              # Optional — URLs with short titles
  - url: "https://style.tidyverse.org/"
    title: "Tidyverse style guide"
  - url: "https://rstudio.github.io/cheatsheets/html/tidyr.html"
    title: "Data tidying with tidyr"
  - url: "https://rstudio.github.io/cheatsheets/html/data-transformation.html"
    title: "Data transformation with dplyr"
  - url: "https://rstudio.github.io/cheatsheets/html/data-visualization.html"
    title: "Data visualization with ggplot2"
```

<description>

I'm working on a analysis of customer churn for Kelos product.
I have monthly Pendo usage data on user level with customer assignment.
Usage data includes general features like: time on app, number of days active, number of events etc.
Problem I'm facing is mapping the pendo data to the erp data to get the actual churn labels.
The goal is to find patterns and insights related to customer churn.

</description>
