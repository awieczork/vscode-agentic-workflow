This file contains SQL templates and R/tidyverse code patterns for each step of the churn-wrangling pipeline. The governing principle is copy-adapt-validate — each pattern is a working template that requires adaptation to the specific Redshift schema and business rules before execution.


<sql_redshift_pull>

SQL query template for extracting Pendo usage data from Redshift. Adapt table and column names to match the actual Redshift schema.

```sql
-- Pendo usage data pull from Redshift
-- Adapt: schema name, table name, column names, date range
SELECT
    visitor_id,
    account_id,
    time_on_app_minutes,
    days_active,
    event_count,
    last_active_date,
    first_active_date
FROM pendo_schema.usage_summary
WHERE last_active_date >= DATEADD(month, -12, CURRENT_DATE)
  AND visitor_id IS NOT NULL
ORDER BY visitor_id;
```

R connection and loading pattern:

```r
library(DBI)
library(RPostgres)
library(tibble)

# Establish connection — replace placeholders with actual credentials
con <- dbConnect(
  RPostgres::Postgres(),
  host     = Sys.getenv("REDSHIFT_HOST"),
  port     = as.integer(Sys.getenv("REDSHIFT_PORT", "5439")),
  dbname   = Sys.getenv("REDSHIFT_DB"),
  user     = Sys.getenv("REDSHIFT_USER"),
  password = Sys.getenv("REDSHIFT_PASSWORD")
)

# Execute query and load into tibble
query <- readr::read_file("sql/pendo_pull.sql")  # or inline SQL string
pendo_raw <- dbGetQuery(con, query) |> as_tibble()

# Validate pull
stopifnot(nrow(pendo_raw) > 0)
cat("Rows pulled:", nrow(pendo_raw), "\n")
cat("Columns:", paste(names(pendo_raw), collapse = ", "), "\n")

# Close connection
dbDisconnect(con)
```

</sql_redshift_pull>


<cleaning_patterns>

R/tidyverse patterns for cleaning and standardizing Pendo usage columns.

```r
library(dplyr)
library(janitor)

# Standardize column names to snake_case
pendo_clean <- pendo_raw |>
  janitor::clean_names()

# Coerce columns to correct types
pendo_clean <- pendo_clean |>
  mutate(
    visitor_id          = as.character(visitor_id),
    account_id          = as.character(account_id),
    time_on_app_minutes = as.numeric(time_on_app_minutes),
    days_active         = as.integer(days_active),
    event_count         = as.integer(event_count),
    last_active_date    = as.Date(last_active_date),
    first_active_date   = as.Date(first_active_date)
  )

# Track NA introduction from type coercion
na_before <- colSums(is.na(pendo_raw))
na_after  <- colSums(is.na(pendo_clean))
na_diff   <- na_after - na_before
if (any(na_diff > 0)) {
  warning("Type coercion introduced NAs in: ",
          paste(names(na_diff[na_diff > 0]), collapse = ", "))
}

# Remove exact duplicate rows
pendo_clean <- pendo_clean |>
  distinct()

# Trim whitespace from character columns
pendo_clean <- pendo_clean |>
  mutate(across(where(is.character), trimws))

cat("Rows after cleaning:", nrow(pendo_clean), "\n")
```

</cleaning_patterns>


<join_patterns>

Join patterns with key validation between Pendo and ERP datasets.

```r
library(dplyr)

# --- Key validation before join ---

# Check for unmatched keys: Pendo visitors not in ERP
pendo_not_in_erp <- anti_join(pendo_clean, erp_data,
                               by = c("account_id" = "customer_id"))
cat("Pendo records not in ERP:", nrow(pendo_not_in_erp),
    "(", round(nrow(pendo_not_in_erp) / nrow(pendo_clean) * 100, 1), "% )\n")

# Check for unmatched keys: ERP customers not in Pendo
erp_not_in_pendo <- anti_join(erp_data, pendo_clean,
                               by = c("customer_id" = "account_id"))
cat("ERP records not in Pendo:", nrow(erp_not_in_pendo),
    "(", round(nrow(erp_not_in_pendo) / nrow(erp_data) * 100, 1), "% )\n")

# Sample unmatched IDs for review
if (nrow(pendo_not_in_erp) > 0) {
  cat("Sample unmatched Pendo IDs:\n")
  print(head(pendo_not_in_erp |> select(account_id, visitor_id), 10))
}

# Flag if mismatch exceeds 10%
mismatch_pct <- nrow(pendo_not_in_erp) / nrow(pendo_clean) * 100
if (mismatch_pct > 10) {
  warning("Join key mismatch exceeds 10% — review ID mapping before proceeding")
}

# --- Execute join ---

rows_before <- nrow(pendo_clean)

joined_data <- pendo_clean |>
  left_join(erp_data, by = c("account_id" = "customer_id"))

# Check for row inflation (indicates duplicate keys in ERP)
rows_after <- nrow(joined_data)
if (rows_after > rows_before) {
  warning("Row count increased from ", rows_before, " to ", rows_after,
          " — duplicate keys in ERP data. Investigate and deduplicate.")
}

cat("Joined dataset:", nrow(joined_data), "rows x",
    ncol(joined_data), "columns\n")
```

Alternate join key patterns:

```r
# If Pendo uses visitor_id and ERP has a separate mapping table
id_map <- read_csv("data/pendo_erp_id_map.csv")  # visitor_id → customer_id

pendo_mapped <- pendo_clean |>
  left_join(id_map, by = "visitor_id") |>
  left_join(erp_data, by = "customer_id")

# If join key columns have different names
joined_data <- pendo_clean |>
  left_join(erp_data, by = c("pendo_account" = "erp_customer_id"))
```

</join_patterns>


<churn_label_derivation>

Churn label derivation template. Replace the placeholder logic with the user-provided churn definition — never assume a churn rule.

```r
library(dplyr)
library(lubridate)

# --- PLACEHOLDER: Replace with user-defined churn rule ---
# Common churn rule patterns (use the one matching user's definition):

# Pattern A: Contract end date passed
joined_data <- joined_data |>
  mutate(
    churn_label = case_when(
      contract_end_date < today()          ~ 1L,
      contract_end_date >= today()         ~ 0L,
      TRUE                                 ~ NA_integer_
    )
  )

# Pattern B: No activity in N days
# joined_data <- joined_data |>
#   mutate(
#     churn_label = case_when(
#       last_active_date < today() - days(90)  ~ 1L,
#       last_active_date >= today() - days(90) ~ 0L,
#       TRUE                                   ~ NA_integer_
#     )
#   )

# Pattern C: Subscription status field
# joined_data <- joined_data |>
#   mutate(
#     churn_label = case_when(
#       subscription_status == "cancelled"   ~ 1L,
#       subscription_status == "active"      ~ 0L,
#       TRUE                                 ~ NA_integer_
#     )
#   )
# --- END PLACEHOLDER ---

# Validate label distribution
label_dist <- joined_data |>
  count(churn_label) |>
  mutate(pct = round(n / sum(n) * 100, 1))
print(label_dist)

# Flag class imbalance
minority_pct <- min(label_dist$pct)
if (minority_pct < 5) {
  warning("Class imbalance detected: minority class is ", minority_pct,
          "% — consider stratified sampling or oversampling for modeling")
}

# Flag any NA labels
na_labels <- sum(is.na(joined_data$churn_label))
if (na_labels > 0) {
  warning(na_labels, " records have NA churn_label — investigate or exclude")
}
```

</churn_label_derivation>


<aggregation_patterns>

Aggregation patterns for rolling user-level data up to customer-level summaries.

```r
library(dplyr)

# Aggregate user-level to customer-level
customer_data <- joined_data |>
  group_by(customer_id) |>
  summarize(
    total_time_on_app  = sum(time_on_app_minutes, na.rm = TRUE),
    avg_days_active    = mean(days_active, na.rm = TRUE),
    total_events       = sum(event_count, na.rm = TRUE),
    user_count         = n_distinct(visitor_id),
    max_last_active    = max(last_active_date, na.rm = TRUE),
    min_first_active   = min(first_active_date, na.rm = TRUE),
    # Churn label: 1 if ANY user under customer churned (conservative)
    churn_label        = max(churn_label, na.rm = TRUE),
    .groups = "drop"
  )

# Validate: one row per customer
stopifnot(n_distinct(customer_data$customer_id) == nrow(customer_data))
cat("Customer-level dataset:", nrow(customer_data), "customers\n")

# Alternate churn aggregation: majority vote
# customer_data <- joined_data |>
#   group_by(customer_id) |>
#   summarize(
#     ...,
#     churn_label = as.integer(mean(churn_label) >= 0.5),
#     .groups = "drop"
#   )
```

</aggregation_patterns>


<missing_data_handling>

Patterns for detecting, reporting, and handling missing data and outliers.

```r
library(dplyr)
library(tidyr)

# --- Missing data summary ---
missing_summary <- customer_data |>
  summarize(across(everything(), ~sum(is.na(.)))) |>
  pivot_longer(everything(), names_to = "column", values_to = "na_count") |>
  mutate(
    total_rows = nrow(customer_data),
    na_pct     = round(na_count / total_rows * 100, 1)
  ) |>
  arrange(desc(na_pct))

print(missing_summary)

# Flag columns exceeding 30% missing
high_missing <- missing_summary |> filter(na_pct > 30)
if (nrow(high_missing) > 0) {
  warning("Columns exceeding 30% missing:\n",
          paste(high_missing$column, high_missing$na_pct, "%", collapse = "\n"))
}

# --- Imputation for numeric columns below threshold ---
numeric_cols <- customer_data |>
  select(where(is.numeric)) |>
  names()

# Median imputation (robust to skew)
customer_data <- customer_data |>
  mutate(across(
    all_of(numeric_cols),
    ~if_else(is.na(.), median(., na.rm = TRUE), .)
  ))

# --- Outlier detection using IQR method ---
detect_outliers <- function(x) {
  q1  <- quantile(x, 0.25, na.rm = TRUE)
  q3  <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- q1 - 1.5 * iqr
  upper <- q3 + 1.5 * iqr
  x < lower | x > upper
}

outlier_summary <- customer_data |>
  summarize(across(
    all_of(numeric_cols),
    ~sum(detect_outliers(.), na.rm = TRUE)
  )) |>
  pivot_longer(everything(), names_to = "column", values_to = "outlier_count") |>
  filter(outlier_count > 0) |>
  arrange(desc(outlier_count))

if (nrow(outlier_summary) > 0) {
  cat("Outlier counts per column:\n")
  print(outlier_summary)
}

# --- Cap outliers at IQR boundaries (optional — confirm with user) ---
cap_outliers <- function(x) {
  q1  <- quantile(x, 0.25, na.rm = TRUE)
  q3  <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- q1 - 1.5 * iqr
  upper <- q3 + 1.5 * iqr
  pmin(pmax(x, lower), upper)
}

# customer_data <- customer_data |>
#   mutate(across(all_of(numeric_cols), cap_outliers))

# --- Final validation ---
critical_cols <- c("customer_id", "churn_label")
for (col in critical_cols) {
  na_count <- sum(is.na(customer_data[[col]]))
  if (na_count > 0) {
    stop("Critical column '", col, "' still has ", na_count, " NA values")
  }
}

cat("Final dataset:", nrow(customer_data), "rows x",
    ncol(customer_data), "columns\n")
cat("Zero NAs in critical columns: customer_id, churn_label\n")
```

</missing_data_handling>
