# Prepare local Aleutian harbor seal dive datasets for index.qmd
# Source CSV comes from the akhs-aleutian-dive project (kept gitignored in data/).

prepare_aleutian_data <- function(base_dir = here::here("data")) {
  raw_dir <- file.path(base_dir, "raw")
  pq_dir <- file.path(base_dir, "parquet")
  part_dir <- file.path(pq_dir, "dive_data_parquet")

  csv_path <- file.path(raw_dir, "AleutianPv_DiveData4analysis.csv")
  rds_path <- file.path(raw_dir, "AleutianPv_DiveData4analysis.rds")
  single_pq <- file.path(pq_dir, "aleutian_dives.parquet")

  if (!file.exists(csv_path)) {
    stop(
      "Missing local source CSV at ",
      csv_path,
      ". Copy AleutianPv_DiveData4analysis.csv from akhs-aleutian-dive/data-raw/ into data/raw/."
    )
  }

  dir.create(pq_dir, recursive = TRUE, showWarnings = FALSE)

  con <- DBI::dbConnect(duckdb::duckdb())
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE), add = TRUE)

  # Explicitly type timestamps and numeric dive metrics: leading location rows
  # have NA dive fields, which can cause auto-inference to fall back to VARCHAR.
  read_expr <- sprintf(
    "read_csv_auto(
      '%s',
      nullstr = 'NA',
      types = {
        'dt': 'TIMESTAMP',
        'timeline_start_dt': 'TIMESTAMP',
        'depth_min': 'DOUBLE',
        'depth_max': 'DOUBLE',
        'duration_min': 'DOUBLE',
        'duration_max': 'DOUBLE'
      }
    )",
    csv_path
  )

  if (!file.exists(single_pq)) {
    DBI::dbExecute(
      con,
      sprintf(
        "COPY (SELECT * FROM %s) TO '%s' (FORMAT PARQUET, COMPRESSION ZSTD);",
        read_expr,
        single_pq
      )
    )
  }

  if (!dir.exists(part_dir) || length(list.files(part_dir)) == 0L) {
    DBI::dbExecute(
      con,
      sprintf(
        "COPY (SELECT * FROM %s) TO '%s' (FORMAT PARQUET, PARTITION_BY (deployid), COMPRESSION ZSTD, OVERWRITE_OR_IGNORE);",
        read_expr,
        part_dir
      )
    )
  }

  if (!file.exists(rds_path)) {
    df <- arrow::read_parquet(single_pq)
    saveRDS(df, rds_path)
  }

  invisible(
    list(
      csv = csv_path,
      rds = rds_path,
      parquet = single_pq,
      partitioned = part_dir
    )
  )
}
