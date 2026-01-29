---
name: data-schema
description: Validate Parquet schema against expected columns, check data integrity, and generate schema documentation. Invoke when loading data, after ETL pipeline runs, or when investigating data quality issues in the R/Shiny patterns application.
metadata:
  author: patterns-shiny-app
  version: "1.0.0"
  tags: [data-quality, parquet, arrow, schema-validation]
---

# Data Schema Validation

Validates Arrow/Parquet data files against expected schemas, checks data integrity, and generates documentation for the patterns-shiny-app dataset.

## Overview

This skill manages schema validation for ~800k sessions, ~200k documents, and ~20k patterns stored in partitioned Parquet format. Use this when:
- Loading data into the Shiny application
- After ETL pipeline completes
- Investigating data quality issues
- Documenting data structure for new team members

## Steps

1. **Load expected schema definitions**
   ```r
   source("scripts/validate_schema.R")
   expected <- yaml::read_yaml("assets/expected_schema.yaml")
   ```

2. **Validate each data file against expected schema**
   ```r
   results <- validate_all_schemas(
     patterns_metadata = "data/patterns/pattern_metadata.parquet",
     patterns_documents = "data/patterns/pattern_documents.parquet",
     document_metadata = "data/documents/document_metadata.parquet",
     document_cooccurrence = "data/relationships/document_cooccurrence.parquet",
     sessions_path = "data/sessions/"
   )
   ```

3. **Check data integrity**
   - Verify no unexpected nulls in required columns
   - Validate data types match specification
   - Check referential integrity between tables

4. **Report partition structure for sessions/**
   ```r
   report_partitions("data/sessions/")
   ```

5. **Generate schema documentation**
   ```r
   source("scripts/document_schema.R")
   generate_schema_docs(output_path = "docs/data-schema.md")
   ```

## Error Handling

If schema validation fails: Review `results$errors` for column mismatches, then update either the data pipeline or `expected_schema.yaml`.

If null check fails: Run `results$null_report` to identify affected rows; determine if nulls are acceptable or require data backfill.

If partition structure is invalid: Verify ETL wrote partitions using `segment/industry` hierarchy; re-run partitioning step if needed.

If Arrow package fails to load: Ensure `arrow` R package is installed with `install.packages("arrow")`.

## Reference Files

- [Expected Schema Definition](assets/expected_schema.yaml)
- [Schema Validation Script](scripts/validate_schema.R)
- [Documentation Generator](scripts/document_schema.R)

## Validation

Run schema validation and verify:

```r
source(".github/skills/data-schema/scripts/validate_schema.R")
results <- validate_all_schemas()
results$all_passed
```

Expected:
- [ ] `results$all_passed` returns `TRUE`
- [ ] No critical errors in `results$errors`
- [ ] Partition count matches expected (~20 segment/industry combinations)
- [ ] Generated documentation exists at `docs/data-schema.md`
