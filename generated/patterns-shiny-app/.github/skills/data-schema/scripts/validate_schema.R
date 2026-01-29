# Schema Validation Script for Patterns Shiny App
# Validates Parquet files against expected schema definitions

library(arrow)
library(yaml)
library(purrr)
library(dplyr)

#' Load expected schema from YAML
#'
#' @param schema_path Path to expected_schema.yaml
#' @return List of expected schemas by table name
load_expected_schema <- function(schema_path = NULL) {
  if (is.null(schema_path)) {
    schema_path <- file.path(
      ".github/skills/data-schema/assets/expected_schema.yaml"
    )
  }
  yaml::read_yaml(schema_path)
}

#' Validate a single Parquet file against expected schema
#'
#' @param file_path Path to the Parquet file
#' @param expected_cols Named list of expected columns and types
#' @param table_name Name of the table for error reporting
#' @return List with passed, errors, and warnings
validate_schema <- function(file_path, expected_cols, table_name) {
  result <- list(
    table = table_name,
    path = file_path,
    passed = TRUE,
    errors = character(),
    warnings = character()
  )

  # Check file exists

if (!file.exists(file_path)) {
    result$passed <- FALSE
    result$errors <- c(result$errors, sprintf("File not found: %s", file_path))
    return(result)
  }

  # Read schema from Parquet
  tryCatch({
    pq <- arrow::open_dataset(file_path)
    actual_schema <- pq$schema
    actual_cols <- names(actual_schema)

    # Check for missing columns
    expected_names <- names(expected_cols)
    missing <- setdiff(expected_names, actual_cols)
    if (length(missing) > 0) {
      result$passed <- FALSE
      result$errors <- c(
        result$errors,
        sprintf("Missing columns in %s: %s", table_name, paste(missing, collapse = ", "))
      )
    }

    # Check for extra columns (warning, not error)
    extra <- setdiff(actual_cols, expected_names)
    if (length(extra) > 0) {
      result$warnings <- c(
        result$warnings,
        sprintf("Extra columns in %s: %s", table_name, paste(extra, collapse = ", "))
      )
    }

    # Check data types for matching columns
    common_cols <- intersect(expected_names, actual_cols)
    for (col in common_cols) {
      expected_type <- expected_cols[[col]]$type
      actual_type <- as.character(actual_schema$GetFieldByName(col)$type)

      if (!types_compatible(expected_type, actual_type)) {
        result$passed <- FALSE
        result$errors <- c(
          result$errors,
          sprintf(
            "Type mismatch in %s.%s: expected %s, got %s",
            table_name, col, expected_type, actual_type
          )
        )
      }
    }
  }, error = function(e) {
    result$passed <- FALSE
    result$errors <- c(result$errors, sprintf("Failed to read %s: %s", file_path, e$message))
  })

  result
}

#' Check if two types are compatible
#'
#' @param expected Expected type string
#' @param actual Actual Arrow type string
#' @return TRUE if compatible
types_compatible <- function(expected, actual) {
  # Normalize type names
  expected <- tolower(expected)
  actual <- tolower(actual)

  # Type mapping for common variations
  type_map <- list(
    "string" = c("string", "utf8", "large_utf8"),
    "int64" = c("int64", "int32", "integer"),
    "int32" = c("int32", "int64", "integer"),
    "double" = c("double", "float64", "float"),
    "float" = c("float", "float32", "double"),
    "boolean" = c("boolean", "bool"),
    "date" = c("date32", "date64", "date"),
    "timestamp" = c("timestamp", "datetime")
  )

  if (expected %in% names(type_map)) {
    return(actual %in% type_map[[expected]])
  }

  expected == actual
}

#' Check data integrity (nulls in required columns)
#'
#' @param file_path Path to Parquet file
#' @param required_cols Character vector of required (non-null) columns
#' @param table_name Table name for reporting
#' @return List with null counts per column
check_data_integrity <- function(file_path, required_cols, table_name) {
  result <- list(
    table = table_name,
    null_counts = list(),
    integrity_passed = TRUE
  )

  tryCatch({
    ds <- arrow::open_dataset(file_path)
    df <- ds |> collect()

    for (col in required_cols) {
      if (col %in% names(df)) {
        null_count <- sum(is.na(df[[col]]))
        result$null_counts[[col]] <- null_count
        if (null_count > 0) {
          result$integrity_passed <- FALSE
        }
      }
    }
  }, error = function(e) {
    result$integrity_passed <- FALSE
    result$error <- e$message
  })

  result
}

#' Report partition structure
#'
#' @param partition_path Path to partitioned dataset
#' @return List with partition details
report_partitions <- function(partition_path) {
  result <- list(
    path = partition_path,
    partitions = list(),
    total_files = 0,
    partition_keys = character()
  )

  tryCatch({
    ds <- arrow::open_dataset(partition_path)

    # Get partition columns
    result$partition_keys <- names(ds$partitioning$schema)

    # Count files per partition
    files <- list.files(partition_path, recursive = TRUE, pattern = "\\.parquet$")
    result$total_files <- length(files)

    # Extract partition values
    for (file in files) {
      parts <- strsplit(dirname(file), "/")[[1]]
      for (part in parts) {
        if (grepl("=", part)) {
          kv <- strsplit(part, "=")[[1]]
          key <- kv[1]
          value <- kv[2]
          if (!key %in% names(result$partitions)) {
            result$partitions[[key]] <- character()
          }
          result$partitions[[key]] <- unique(c(result$partitions[[key]], value))
        }
      }
    }
  }, error = function(e) {
    result$error <- e$message
  })

  result
}

#' Validate all schemas
#'
#' @param patterns_metadata Path to pattern_metadata.parquet
#' @param patterns_documents Path to pattern_documents.parquet
#' @param document_metadata Path to document_metadata.parquet
#' @param document_cooccurrence Path to document_cooccurrence.parquet
#' @param sessions_path Path to sessions/ partitioned dataset
#' @return List with validation results for all tables
validate_all_schemas <- function(
  patterns_metadata = "data/patterns/pattern_metadata.parquet",
  patterns_documents = "data/patterns/pattern_documents.parquet",
  document_metadata = "data/documents/document_metadata.parquet",
  document_cooccurrence = "data/relationships/document_cooccurrence.parquet",
  sessions_path = "data/sessions/"
) {
  expected <- load_expected_schema()

  results <- list(
    all_passed = TRUE,
    tables = list(),
    errors = character(),
    null_report = list(),
    partitions = NULL
  )

  # Validate each table
  tables <- list(
    list(path = patterns_metadata, name = "pattern_metadata"),
    list(path = patterns_documents, name = "pattern_documents"),
    list(path = document_metadata, name = "document_metadata"),
    list(path = document_cooccurrence, name = "document_cooccurrence")
  )

  for (table in tables) {
    if (table$name %in% names(expected$tables)) {
      schema_result <- validate_schema(
        table$path,
        expected$tables[[table$name]]$columns,
        table$name
      )
      results$tables[[table$name]] <- schema_result

      if (!schema_result$passed) {
        results$all_passed <- FALSE
        results$errors <- c(results$errors, schema_result$errors)
      }

      # Check integrity
      required <- names(
        Filter(function(x) isTRUE(x$required), expected$tables[[table$name]]$columns)
      )
      if (length(required) > 0) {
        integrity <- check_data_integrity(table$path, required, table$name)
        results$null_report[[table$name]] <- integrity
        if (!integrity$integrity_passed) {
          results$all_passed <- FALSE
        }
      }
    }
  }

  # Validate sessions (partitioned)
  if (dir.exists(sessions_path)) {
    results$partitions <- report_partitions(sessions_path)
  }

  results
}

#' Print validation summary
#'
#' @param results Results from validate_all_schemas
print_validation_summary <- function(results) {
  cat("=== Schema Validation Summary ===\n\n")

  cat(sprintf("Overall: %s\n\n", ifelse(results$all_passed, "PASSED", "FAILED")))

  for (table_name in names(results$tables)) {
    table <- results$tables[[table_name]]
    status <- ifelse(table$passed, "✓", "✗")
    cat(sprintf("%s %s\n", status, table_name))

    if (length(table$errors) > 0) {
      for (err in table$errors) {
        cat(sprintf("  ERROR: %s\n", err))
      }
    }
    if (length(table$warnings) > 0) {
      for (warn in table$warnings) {
        cat(sprintf("  WARN: %s\n", warn))
      }
    }
  }

  if (!is.null(results$partitions)) {
    cat(sprintf(
      "\nPartitions: %d files across %s\n",
      results$partitions$total_files,
      paste(results$partitions$partition_keys, collapse = "/")
    ))
  }
}
