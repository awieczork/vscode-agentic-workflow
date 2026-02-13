---
description: 'Start a project generation workflow — fill the seed and run to begin expert interview'
agent: 'brain'
workflow: 'generation'
argument-hint: 'Describe your project — name, tech stack, and what you want to build'
---

<!-- Fill what you know, leave the rest empty. Gaps are covered during the interview. -->

Follow the [generation workflow](../agent-workflows/generation.workflow.md) with the following seed data.

```yaml
name: ""              # Project name
area: ""              # e.g. "fintech", "data science", "devops"
goal: ""              # One sentence: what does this project achieve?
tech: []              # Everything: languages, frameworks, DBs, libraries, tools
sources:              # Optional — URLs with short titles
  - url: ""
    title: ""
```

<description>

Write freely here: business context, problems you face, what you want agents to help with,
rules or constraints, domain concepts, team practices — anything relevant.
One sentence or ten paragraphs — the interview adapts to the depth you provide.

</description>