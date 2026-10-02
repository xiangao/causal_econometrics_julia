# Walmart county panel used in did-continuous.qmd.
# Source: walmart_lw.dta in Wooldridge's replication folder for
# Wooldridge (2026), https://tinyurl.com/wooldridge-ER-MacKinnon-data
# (built from the Brown and Butts 2025 county panel).
# Usage: Rscript gen_walmart_lw.R /path/to/walmart_lw.dta
args <- commandArgs(trailingOnly = TRUE)
d <- haven::read_dta(args[1])
d <- as.data.frame(d[, c("fips", "year", "cohort", "n_open", "log_retail_emp")])
d[] <- lapply(d, as.numeric)
data.table::fwrite(d, "walmart_lw.csv")
