# Parquet + DuckDB for R users

A Quarto Revealjs presentation for intermediate–advanced NMFS R users doing
scientific analysis, technical reporting, and manuscript preparation.

The deck covers Parquet internals and trade-offs, DuckDB through DBI and dplyr,
GCS/GCP workflows, database selection (including PostgreSQL, Oracle, and BigQuery),
and reproducible, collaborative science. Allow 45–60 minutes including the exercise.

## Setup and render

Install [Quarto](https://quarto.org/docs/get-started/) and R (4.2 or later;
current DuckDB releases require at least 4.2), then install the R packages once:

```r
install.packages(c("DBI", "duckdb", "dplyr", "dbplyr", "knitr", "rmarkdown"))
```

From the repository root:

```sh
quarto check
quarto render parquet-duckdb.qmd
quarto preview parquet-duckdb.qmd
```

Open `_output/parquet-duckdb.html`. It is a self-contained HTML deck, including
the computed tables and figure; share that file with collaborators who do not
have R installed. Use the arrow keys to navigate, `S` for speaker notes, and
`Esc` for the slide overview. No cloud account, Arrow package, external data
download, or DuckDB extension is required for the executed examples.

The GCS and resource-setting snippets are explicitly marked `eval: false`.
They are templates, not evidence of a cloud benchmark. Replace the placeholder
bucket paths and follow local IAM, HMAC credential, extension-installation,
confidentiality, and billing policies before running them. Never put credentials
in source files, rendered output, logs, or Git.

## Data and outputs

- `parquet-duckdb.qmd`: presentation, executable R examples, exercise and solution,
  speaker notes, and official documentation links.
- `data/survey.csv`: 24 **synthetic** pollock tow records, created for teaching,
  with two strata and three years (2022–2024). These are not NMFS observations
  and must not be used for scientific inference.
- `slides.css`: small readability adjustments.
- `_quarto.yml`: rendering configuration; errors stop the render and execution
  is not cached, so every render recomputes results.

The data dictionary is in the deck: catch is kg, effort is swept area in km²,
dates are ISO calendar dates, and tow identifiers are unique. There is one
missing catch (`NA`, tow T15), one genuine zero (T13), and no missing or zero
effort. The estimator is the unweighted mean of tow-level catch/effort,
excluding missing catch—not a ratio of totals or a survey abundance index.

Rendering creates ignored, replaceable artifacts:

| Location | Contents |
|---|---|
| `_output/` | Self-contained HTML presentation |
| `_demo/survey.parquet` | Typed, ZSTD-compressed version of the fixture |
| `_demo/cpue-summary.csv` | Six-row report table |
| `_demo/input-manifest.csv` | Source/Parquet file checksums |
| `_demo/session-info.txt` | R and package environment |

Re-rendering overwrites these demo outputs. Preserve a copy elsewhere if needed.
Delete `_demo/` and `_output/` to reset; they contain no source inputs.

## Validation and reproducibility

There is no separate test framework. Rendering executes assertions for input
keys, effort, catch missingness, known group means/sample sizes, SQL/dplyr
agreement, and the exercise answer. Expected means ordered by year then stratum:
`20, 7, 22, 6.666667, 24, 11` kg/km²; the 2023 slope has three observed catches,
all other groups have four. Inspect the resulting table and figure as well.

The tiny fixture demonstrates correctness, not performance or cloud costs.
For production, benchmark representative data, validate scientific estimators and
uncertainty, pin dependencies with a reviewed `renv.lock`, record the code revision,
and archive a versioned input manifest. The render records actual package versions
but does not claim to be a locked environment.

For collaboration, commit code and small public fixtures; store large or restricted
data only in approved storage. Freeze release prefixes and record GCS object
generations/checksums; a wildcard over a mutable bucket is not reproducible.
Review derived outputs for disclosure before sharing.
