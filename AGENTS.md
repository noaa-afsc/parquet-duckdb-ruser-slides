# Main Objective

Provide a Quarto revealjs presentation that introduces intermediate-advanced R users
to the benefits of parquet files and duckdb. After the presentation users should
have the ability to start a simple data science project that creates parquet
files from source data and uses duckdb to query and analyze patterns in the source
data.

## Audience

The audience for the presentation is an informal R User Group at the National
Marine Fisheries Service (NMFS). The audience is almost exclusively scientists that
study marine mammals and sustainable fisheries in Alaska and the North Pacific.

## Style and Approach

The presentation should use the 'moon' revealjs theme and be typical in look/feel of a
scientific presentation and software tutorial. Code blocks should be included
so users viewing the slide deck later can copy and run code themselves. Code
blocks should be executable when rendering so results of the code are displayed.
When helpful, ggplots or mermaid diagrams can be used to convey
concepts or results. Use graphics judiciously. The presentation is scheduled for
30 minutes followed by 15 minutes of questions.

## Additional Context

The NMFS is migrating all legacy on-premise/local compute to the Google Cloud
with an emphasis on GCS (buckets) and GCP. Learning about cloud-optimized workflows
and file formats is a key importance of this presentation, but not the highest
priority. Many users are also new users of Positron (after using RStudio for many
years). Users are also experimenting with agentic tools and workflows through
Posit Assistant, GitHub CoPilot, and Antigravity.

## Key Topics and Components

The following ideas for topics are presented in no particular order. This is a
brainstorm listing of topics. Presentation should be ordered in logical approach for new users.

* History of parquet files and why the format was developed
* The key advantages of parquet files and why they can be an effective default tabular data format
* How to create a parquet file in R
* How to create a nested parquet file in R
* How to store spatial data in parquet files
* How to view and explore parquet files in Positron
* Compare/contrast parquet files to CSV or rdata and rds files
* History of duckdb and why the database was created
* How does duckdb compare to sqlite, PostgreSQL, and Oracle (the later 2 are enterprise services NMFS offers)
* How to 'install' duckdb for use in R
* How to query parquet files from duckdb in R
* How to query spatial data in duckdb?
* What's the difference between storing data as *.duckb vs pointing to a parquet data lake/bucket?
* How to run complex queries in duckdb and how would that compare to using tidyverse?
* Introduce the data-dict package from Posit and how it can be used to document data in a parqeut file
* Benefits of parquet and duckdb when working with LLM agents to develop scientific code/analysis
* Benefits of parquet and duckdb when developing reproducible scientific code
* Do I need parquet and duckdeb if all my data is in Oracle?
* What about 'arrow'?
* How to store parquet files in a GCS bucket and query from duckdb (using HKEY auth)
* How to integrate use of central database with parquet/duckdb -- e.g., initial query of authoritative data from PostgreSQL with reproducible script/function but with local project data store.
