This project analyzes Kelos customer churn using Pendo product usage data. The analysis connects monthly user-level Pendo metrics (time on app, days active, events) to ERP contract data for churn label derivation, then applies exploratory analysis, statistical testing, feature engineering, and cohort analysis to identify churn patterns.

The governing principle is: evidence over assumption — never assume churn definitions, always ground statistical claims in data, and distinguish correlation from causation. Apply `<decision_making>` when rules conflict. Begin with `<constraints>` for hard limits, then apply patterns from remaining sections as situations arise.


<workspace>

Workspace structure and folder purposes. Load this first to locate resources.

- `.github/agents/` — Agent definitions — core agents (brain, architect, build, inspect) and domain agent (churn-analyst) — `Active`
- `.github/instructions/` — Instruction files — writing rules, structure conventions, glossary, R/tidyverse standards — `Active`
- `.github/skills/` — Skill definitions — churn-wrangling data pipeline with reference files — `Active`
- `.github/prompts/` — Reusable prompt files — EDA and visualization prompts — `Active`
- `data/` — Raw and processed data files (Pendo exports, ERP extracts) — `Placeholder`
- `R/` — R scripts for analysis, data processing, and visualization — `Placeholder`
- `output/` — Analysis outputs, reports, and figures — `Placeholder`

**Status meanings:**

- `Active` — Authoritative, use as source of truth
- `Placeholder` — Structure exists, content not yet generated

</workspace>


<tech_stack>

- **Languages** — R (primary), SQL (data extraction)
- **Frameworks** — tidyverse (dplyr, tidyr, ggplot2, readr, purrr)
- **Database** — Amazon Redshift (Pendo usage data warehouse)
- **Style guide** — [Tidyverse style guide](https://style.tidyverse.org/)

</tech_stack>


<constraints>

- copilot-instructions.md takes precedence over domain instruction files
- Never overwrite existing data files without explicit user confirmation
- Never install R packages without asking the user first
- Never assume churn definitions — always ask the user for the business rule before deriving churn labels
- Trust documented structure without re-verification; verify all facts and data before citing
- Do only what is requested or clearly necessary; treat undocumented features as unsupported
- Always distinguish correlation from causation when presenting churn-related findings
- Always cite data source, scope, and sample size when presenting metrics or statistical results

</constraints>


<decision_making>

- When rules conflict, apply: Safety → Accuracy → Clarity → Style — the first dimension that distinguishes options wins
- Classify issues by impact: P1 blocks completion, P2 degrades quality, P3 is optional
- Calibrate decisions to confidence: high confidence → proceed; medium confidence → flag uncertainty, ask; low confidence → stop, request clarification
- When data is unavailable or incomplete, state the gap, provide an explicit workaround, continue

</decision_making>


<collaboration>

- @churn-analyst is the primary domain agent — invoke for EDA, statistical testing, feature engineering, and cohort analysis
- @brain routes user requests to the appropriate agent; @architect plans multi-step workflows
- @build implements data pipeline scripts identified during analysis; @inspect verifies statistical methodology and data quality
- Delegate when expertise differs or parallelism saves time; retain when handoff overhead exceeds task cost
- Make every handoff payload self-contained: summary of completed work, key decisions, explicit next steps

</collaboration>


<error_reporting>

- Report errors using the standard format: `status` (`success` | `partial` | `failed` | `blocked`), `error_code` (kebab-case), `message` (human explanation), `recovery` (next action)

</error_reporting>
