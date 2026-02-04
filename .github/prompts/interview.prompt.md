---
description: 'Generate project brief and artifact recommendations for your codebase'
name: 'interview'
argument-hint: 'Optional: describe your project in a sentence'
agent: 'interview'
---

# Project Interview

<introduction>

Fill the questionnaire below, then send to generate a customized `.github/` framework for your project.

</introduction>

<tips>

**Tips:**
- Use `&lt;` and `&gt;` for literal angle brackets in your content
- Mark high-priority workflows with `(priority)` or combine: `(daily, priority)`
- Refs must use `https://` or relative paths (`./docs/...`)

</tips>

<questionnaire version="1.0">

<name required="true">
<!-- kebab-case identifier, e.g., api-gateway -->
</name>

<description required="true">
<!-- What it does, what problem it solves (2-3 sentences, min 10 chars) -->
</description>

<tech>
<!-- Languages, frameworks, tools — one per line -->
</tech>

<workflows>
<!-- Tasks you repeat — one per line -->
<!-- Mark priority: (priority) standalone, or combine with frequency -->
<!-- Example: -->
<!-- - Add new service route (daily, priority) -->
<!-- - Debug request flow (weekly) -->
<!-- - Update rate limits (monthly) -->
</workflows>

<constraints>
<!-- Rules to enforce — one per line -->
<!-- These become Iron Laws in generated artifacts -->
</constraints>

<refs>
<!-- Optional: sources with freeform tags (max 9) -->
<!-- Allowed: https:// URLs or relative paths (./docs/...) -->
<!-- <ref src="https://example.com/docs" tags="framework style" /> -->
</refs>

<notes>
<!-- Optional: Anything else important — suggestions, preferences, context (~500 chars) -->
<!-- Examples: "I need a skill for X", "Prefer prompts over agents", "Monorepo setup" -->
</notes>

</questionnaire>

<expected_output>

## Expected Output

InterviewHandoff artifact containing:
- Project brief summary
- Requirements gathered
- Recommended artifacts for generation
- Confidence assessment

</expected_output>

<success_criteria>

## Success Criteria

- [ ] All questionnaire sections completed or explicitly skipped
- [ ] Project brief synthesized from responses
- [ ] Artifact recommendations provided with rationale
- [ ] Handoff package ready for @architect

</success_criteria>
