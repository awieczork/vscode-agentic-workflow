# Schema Documentation Generator for Patterns Shiny App
# Generates markdown documentation from Parquet schemas

library(arrow)
library(yaml)
library(glue)

#' Generate schema documentation
#'
#' @param output_path Path for output markdown file
#' @param schema_path Path to expected_schema.yaml
#' @param data_paths Named list of data file paths
generate_schema_docs <- function(
  output_path = "docs/data-schema.md",
  schema_path = ".github/skills/data-schema/assets/expected_schema.yaml",
  data_paths = list(
    pattern_metadata = "data/patterns/pattern_metadata.parquet",
    pattern_documents = "data/patterns/pattern_documents.parquet",
    document_metadata = "data/documents/document_metadata.parquet",
    document_cooccurrence = "data/relationships/document_cooccurrence.parquet",
    sessions = "data/sessions/"
  )
) {
  expected <- yaml::read_yaml(schema_path)

  lines <- character()

  # Header
  lines <- c(lines, "# Data Schema Documentation")
  lines <- c(lines, "")
  lines <- c(lines, glue("*Generated: {Sys.time()}*"))
  lines <- c(lines, "")
  lines <- c(lines, "## Overview")
  lines <- c(lines, "")
  lines <- c(lines, "This document describes the data schema for the Patterns Shiny Application.")
  lines <- c(lines, "")
  lines <- c(lines, "| Dataset | Approximate Size | Storage |")
  lines <- c(lines, "|---------|------------------|---------|")
  lines <- c(lines, "| Sessions | ~800,000 records | Partitioned Parquet (segment/industry) |")
  lines <- c(lines, "| Documents | ~200,000 records | Parquet |")
  lines <- c(lines, "| Patterns | ~20,000 records | Parquet |")
  lines <- c(lines, "")
  lines <- c(lines, "---")
  lines <- c(lines, "")

  # Document each table
  for (table_name in names(expected$tables)) {
    table_def <- expected$tables[[table_name]]

    lines <- c(lines, glue("## {format_table_name(table_name)}"))
    lines <- c(lines, "")

    if (!is.null(table_def$description)) {
      lines <- c(lines, table_def$description)
      lines <- c(lines, "")
    }

    # File location
    if (table_name %in% names(data_paths)) {
      lines <- c(lines, glue("**Location:** `{data_paths[[table_name]]}`"))
      lines <- c(lines, "")
    }

    # Column table
    lines <- c(lines, "### Columns")
    lines <- c(lines, "")
    lines <- c(lines, "| Column | Type | Required | Description |")
    lines <- c(lines, "|--------|------|----------|-------------|")

    for (col_name in names(table_def$columns)) {
      col <- table_def$columns[[col_name]]
      required <- ifelse(isTRUE(col$required), "✓", "")
      desc <- ifelse(is.null(col$description), "", col$description)
      lines <- c(lines, glue("| {col_name} | {col$type} | {required} | {desc} |"))
    }

    lines <- c(lines, "")

    # Add actual stats if file exists
    if (table_name %in% names(data_paths)) {
      stats <- get_table_stats(data_paths[[table_name]])
      if (!is.null(stats)) {
        lines <- c(lines, "### Statistics")
        lines <- c(lines, "")
        lines <- c(lines, glue("- **Row count:** {format(stats$rows, big.mark = ',')}"))
        lines <- c(lines, glue("- **Column count:** {stats$cols}"))
        if (!is.null(stats$file_size)) {
          lines <- c(lines, glue("- **File size:** {format_bytes(stats$file_size)}"))
        }
        lines <- c(lines, "")
      }
    }

    lines <- c(lines, "---")
    lines <- c(lines, "")
  }

  # Partition documentation
  if ("sessions" %in% names(data_paths) && dir.exists(data_paths[["sessions"]])) {
    lines <- c(lines, "## Partition Structure")
    lines <- c(lines, "")
    lines <- c(lines, "The sessions dataset is partitioned for efficient querying:")
    lines <- c(lines, "")
    lines <- c(lines, "```")
    lines <- c(lines, "sessions/")
    lines <- c(lines, "├── segment=enterprise/")
    lines <- c(lines, "│   ├── industry=finance/")
    lines <- c(lines, "│   ├── industry=healthcare/")
    lines <- c(lines, "│   └── ...")
    lines <- c(lines, "├── segment=smb/")
    lines <- c(lines, "│   └── ...")
    lines <- c(lines, "└── ...")
    lines <- c(lines, "```")
    lines <- c(lines, "")
    lines <- c(lines, "### Partition Keys")
    lines <- c(lines, "")
    lines <- c(lines, "| Key | Description |")
    lines <- c(lines, "|-----|-------------|")
    lines <- c(lines, "| segment | Customer segment (enterprise, smb, consumer) |")
    lines <- c(lines, "| industry | Industry vertical |")
    lines <- c(lines, "")
  }

  # Relationships
  lines <- c(lines, "## Relationships")
  lines <- c(lines, "")
  lines <- c(lines, "```mermaid")
  lines <- c(lines, "erDiagram")
  lines <- c(lines, "    PATTERN_METADATA ||--o{ PATTERN_DOCUMENTS : contains")
  lines <- c(lines, "    PATTERN_DOCUMENTS }o--|| DOCUMENT_METADATA : references")
  lines <- c(lines, "    DOCUMENT_METADATA ||--o{ DOCUMENT_COOCCURRENCE : appears_in")
  lines <- c(lines, "    SESSIONS }o--o{ PATTERN_METADATA : uses")
  lines <- c(lines, "```")
  lines <- c(lines, "")

  # Write output
  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
  writeLines(lines, output_path)

  message(sprintf("Schema documentation written to: %s", output_path))
  invisible(output_path)
}

#' Format table name for display
#'
#' @param name Snake_case table name
#' @return Title Case name
format_table_name <- function(name) {
  words <- strsplit(name, "_")[[1]]
  paste(tools::toTitleCase(words), collapse = " ")
}

#' Get basic statistics for a table
#'
#' @param path Path to Parquet file or directory
#' @return List with rows, cols, file_size
get_table_stats <- function(path) {
  tryCatch({
    if (dir.exists(path)) {
      # Partitioned dataset
      ds <- arrow::open_dataset(path)
      df <- ds |> dplyr::count() |> dplyr::collect()
      list(
        rows = df$n,
        cols = length(names(ds)),
        file_size = sum(file.info(
          list.files(path, recursive = TRUE, full.names = TRUE, pattern = "\\.parquet$")
        )$size)
      )
    } else if (file.exists(path)) {
      # Single file
      ds <- arrow::open_dataset(path)
      df <- ds |> dplyr::count() |> dplyr::collect()
      list(
        rows = df$n,
        cols = length(names(ds)),
        file_size = file.info(path)$size
      )
    } else {
      NULL
    }
  }, error = function(e) {
    NULL
  })
}

#' Format bytes to human readable
#'
#' @param bytes Number of bytes
#' @return Formatted string
format_bytes <- function(bytes) {
  units <- c("B", "KB", "MB", "GB", "TB")
  i <- 1
  while (bytes >= 1024 && i < length(units)) {
    bytes <- bytes / 1024
    i <- i + 1
  }
  sprintf("%.1f %s", bytes, units[i])
}

#' Generate column summary for a specific table
#'
#' @param file_path Path to Parquet file
#' @return Data frame with column statistics
summarize_columns <- function(file_path) {
  tryCatch({
    ds <- arrow::open_dataset(file_path)
    schema <- ds$schema

    data.frame(
      column = names(schema),
      type = sapply(seq_len(length(schema)), function(i) {
        as.character(schema$GetFieldByName(names(schema)[i])$type)
      }),
      stringsAsFactors = FALSE
    )
  }, error = function(e) {
    data.frame(column = character(), type = character())
  })
}
