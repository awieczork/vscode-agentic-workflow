---
description: 'Start a project generation workflow — fill the seed and run to begin expert interview'
agent: 'brain'
workflow: 'generation'
argument-hint: 'Describe your project to generate a complete .github/ folder with agents, skills, instructions, and prompts'
---

<!-- Fill what you know, leave the rest empty. Gaps are covered during the interview. -->

Follow the [generation workflow](../agent-workflows/generation.workflow.md) with the following seed data.

```yaml
name: ""              # Project name
area: ""              # e.g. "fintech", "data science", "devops"
goal: ""              # One sentence: what does this project achieve?
tech: []              # Languages, frameworks, DBs, libraries, tools
sources:              # Optional — URLs with short titles
  - url: ""
    title: ""
commands:             # Optional — known development commands
  build: ""
  test: ""
  lint: ""
  run: ""
constraints: []       # Optional — things agents must NEVER do
```

<description>

Write freely here: business context, problems you face, what you want agents to help with,
domain concepts, team practices — anything relevant. This feeds an expert interview that
produces agents, skills, instructions, prompts, and copilot-instructions for your project.
One sentence or ten paragraphs — the interview adapts to the depth you provide.

</description>