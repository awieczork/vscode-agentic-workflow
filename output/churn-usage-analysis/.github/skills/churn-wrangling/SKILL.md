---
name: 'churn-wrangling'
description: 'Repeatable 6-step pipeline for pulling Pendo usage data from Redshift, cleaning, joining to ERP records, deriving churn labels, aggregating to customer level, and handling missing data. Use when asked to "pull Pendo data", "wrangle churn data", "join Pendo to ERP", or "build the churn dataset". Produces analysis-ready customer-level datasets with usage metrics and churn labels from raw Redshift and ERP sources.'
---

This skill transforms raw Pendo usage data and ERP records into an analysis-ready customer-level dataset with churn labels. The governing principle is source-grounded reproducibility — every step validates its inputs before producing outputs, and churn label logic always comes from the user, never assumed. Begin with `<step_1_pull>` to extract Pendo usage data from Redshift.


<use_cases>

- Pull Pendo usage metrics from Redshift and load into R for analysis
- Clean and standardize raw Pendo columns before joining to business data
- Join Pendo user-level data to ERP customer records by shared ID
- Derive churn labels using user-defined business rules applied to ERP data
- Aggregate user-level Pendo metrics to customer-level summaries for modeling

</use_cases>


<workflow>

Execute steps sequentially. Each step validates its output before the next step consumes it. Steps 1-3 build the joined dataset; steps 4-6 derive labels, aggregate, and clean.


<step_1_pull>

Extract Pendo usage data from Redshift into R.

Load [pipeline-steps.md](./references/pipeline-steps.md) for: SQL query template and Redshift connection pattern.

1. Establish Redshift connection using `DBI::dbConnect()` with `RPostgres::Postgres()` driver
2. Execute SQL query to pull Pendo usage columns: `visitor_id`, `time_on_app_minutes`, `days_active`, `event_count`, `last_active_date`, and any additional usage metrics
3. Load result into a tibble with `dbFetch()` and `as_tibble()`
4. Close the database connection with `dbDisconnect()`
5. Validate: confirm row count > 0, no fully empty columns, expected column names present

</step_1_pull>


<step_2_clean>

Clean and standardize Pendo usage columns.

Load [pipeline-steps.md](./references/pipeline-steps.md) for: tidyverse cleaning patterns.

1. Coerce columns to correct types — numeric for metrics, date for timestamps, character for IDs
2. Standardize column names to snake_case using `janitor::clean_names()` or `rename()`
3. Remove exact duplicate rows with `distinct()`
4. Trim whitespace from character columns
5. Validate: confirm no unexpected `NA` values introduced by type coercion — compare `NA` counts before and after

</step_2_clean>


<step_3_join>

Join Pendo data to ERP records by customer or user ID.

Load [pipeline-steps.md](./references/pipeline-steps.md) for: join patterns with key validation.

1. Identify the shared join key between Pendo (`visitor_id` or mapped `customer_id`) and ERP (`customer_id` or `account_id`)
2. Run `anti_join()` in both directions to detect unmatched keys — report counts and sample IDs
3. If unmatched keys exceed 10% of either dataset, flag for review before proceeding
4. Execute `left_join()` from Pendo to ERP using the validated join key
5. Check for row count inflation after join — if rows increased, duplicates exist in the ERP key; deduplicate or flag
6. Validate: joined dataset has expected column count (Pendo columns + ERP columns) and no unexpected row multiplication

</step_3_join>


<step_4_label>

Derive churn labels from ERP data using user-defined churn logic.

Load [pipeline-steps.md](./references/pipeline-steps.md) for: churn label derivation template.

1. Request churn definition from user — never assume a churn rule. Common patterns: contract end date passed, no activity in N days, subscription status field
2. Apply the user-provided rule using `mutate()` with `case_when()` to create a `churn_label` column (1 = churned, 0 = active)
3. Validate label distribution: report counts and proportions of each label. If one class is < 5%, flag class imbalance
4. Validate: no `NA` values in `churn_label` — every record must have a label or be explicitly excluded

</step_4_label>


<step_5_aggregate>

Aggregate user-level data to customer-level summaries.

Load [pipeline-steps.md](./references/pipeline-steps.md) for: aggregation patterns.

1. Identify the customer-level grouping key (`customer_id` or `account_id`)
2. Group by customer key and compute summary metrics:
   - `total_time_on_app` — `sum(time_on_app_minutes)`
   - `avg_days_active` — `mean(days_active)`
   - `total_events` — `sum(event_count)`
   - `user_count` — `n_distinct(visitor_id)`
   - `max_last_active` — `max(last_active_date)`
3. Carry the `churn_label` forward — use `max(churn_label)` if any user under a customer churned, or apply user-specified aggregation rule
4. Validate: one row per customer, no duplicate customer keys after aggregation

</step_5_aggregate>


<step_6_handle_missing>

Detect, report, and handle missing data and outliers.

Load [pipeline-steps.md](./references/pipeline-steps.md) for: missing data detection and handling patterns.

1. Compute missing data summary: count and percentage of `NA` per column
2. If any column exceeds 30% missing, flag for review — the column may need removal or imputation strategy confirmation from user
3. For numeric columns below the missing threshold, apply imputation: median for skewed distributions, mean for symmetric
4. Detect outliers using IQR method: values beyond 1.5 * IQR from Q1/Q3. Report outlier counts per column
5. Cap or flag outliers per user preference — do not remove rows by default
6. Validate: final dataset has zero `NA` values in critical columns (`customer_id`, `churn_label`), and outlier handling is documented

</step_6_handle_missing>


</workflow>


<error_handling>

- If Redshift connection or query fails, then check connection parameters (host, port, dbname, credentials), verify SQL syntax in a database client, and retry once. If retry fails, report the error message and stop
- If join key mismatch — Pendo user IDs do not match ERP customer IDs — then run `anti_join()` diagnostics, report unmatched counts and sample IDs, and ask user to provide an ID mapping table or confirm the correct key columns
- If churn label derivation rule is not defined, then stop and request the rule from the user. Provide example rule formats: "contract_end_date < today()", "last_activity > 90 days ago", "subscription_status == 'cancelled'". Never assume a churn definition
- If missing data exceeds threshold (> 30% `NA` in any column), then report the column names and missing percentages, ask user whether to drop the column, impute, or proceed with `NA`
- If data type mismatch after join — numeric columns read as character — then apply `mutate(across(cols, as.numeric))` and report any values that coerced to `NA`

</error_handling>


<validation>

- Final dataset has exactly one row per customer — no duplicate customer keys
- `churn_label` column exists with values in {0, 1} and zero `NA` values
- All numeric metric columns have correct types (not character)
- Missing data summary was generated and any column exceeding 30% `NA` was flagged
- Join diagnostics ran — unmatched key counts are documented

</validation>


<resources>

- [pipeline-steps.md](./references/pipeline-steps.md) — SQL query templates for Redshift Pendo data pull, R/tidyverse code patterns for cleaning, join key validation, churn label derivation, customer-level aggregation, and missing data handling

</resources>
