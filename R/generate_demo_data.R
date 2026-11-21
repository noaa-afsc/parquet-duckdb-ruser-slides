# Generate synthetic Alaska pinniped telemetry and haulout datasets
# Used by index.qmd so all benchmark and query chunks run locally and reproducibly.

generate_demo_data <- function(base_dir = "data") {
  raw_dir <- file.path(base_dir, "raw")
  pq_dir <- file.path(base_dir, "parquet")
  part_dir <- file.path(pq_dir, "telemetry_partitioned")

  dir.create(raw_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(pq_dir, recursive = TRUE, showWarnings = FALSE)

  set.seed(7391)
  n <- 500000L

  species_pool <- c(
    "Harbor seal",
    "Steller sea lion",
    "Northern fur seal",
    "Bearded seal"
  )
  species_depth_mean <- c(
    "Harbor seal" = 35,
    "Bearded seal" = 55,
    "Steller sea lion" = 85,
    "Northern fur seal" = 115
  )
  regions <- c(
    "Bering Sea",
    "Gulf of Alaska",
    "Aleutian Islands",
    "Chukchi Sea"
  )
  region_offset <- c(
    "Bering Sea" = 1.0,
    "Gulf of Alaska" = 0.9,
    "Aleutian Islands" = 1.2,
    "Chukchi Sea" = 0.75
  )

  species_vec <- sample(species_pool, n, replace = TRUE, prob = c(0.40, 0.25, 0.25, 0.10))
  region_vec <- sample(regions, n, replace = TRUE, prob = c(0.45, 0.30, 0.15, 0.10))
  expected_depth <- species_depth_mean[species_vec] * region_offset[region_vec]

  # Sort by analytical keys so Parquet row-group statistics and RLE encoding work as in real archives
  telemetry <- tibble::tibble(
    obs_id = seq_len(n),
    deploy_id = sprintf("AK%04d", sample.int(120, n, replace = TRUE)),
    species = species_vec,
    region = region_vec,
    year = sample(2019:2025, n, replace = TRUE),
    timestamp = as.POSIXct("2019-01-01", tz = "UTC") +
      sample.int(6L * 365L * 86400L, n, replace = TRUE),
    lat = round(stats::runif(n, 52.0, 70.5), 5),
    lon = round(stats::runif(n, -178.0, -134.0), 5),
    max_depth_m = round(stats::rexp(n, rate = 1 / expected_depth), 1),
    duration_s = round(stats::runif(n, 30, 480), 0),
    quality_flag = sample(
      c("good", "suspect", "bad"),
      n,
      replace = TRUE,
      prob = c(0.90, 0.07, 0.03)
    )
  ) |>
    dplyr::arrange(year, species, deploy_id, timestamp)

  readr::write_csv(telemetry, file.path(raw_dir, "seal_telemetry.csv"))
  saveRDS(telemetry, file.path(raw_dir, "seal_telemetry.rds"))
  arrow::write_parquet(
    telemetry,
    file.path(pq_dir, "seal_telemetry.parquet"),
    compression = "zstd"
  )

  if (dir.exists(part_dir)) {
    unlink(part_dir, recursive = TRUE)
  }
  arrow::write_dataset(
    telemetry,
    path = part_dir,
    format = "parquet",
    partitioning = "year",
    compression = "zstd"
  )

  invisible(pq_dir)
}
