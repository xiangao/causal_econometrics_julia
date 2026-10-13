# Permutations of the ADH industry shocks for randomization inference in
# recentered-instruments.qmd (both books). Run from the book root:
# Rscript data/gen_adh_perms.R
# Each column is one draw: shock k takes the value of shock perm[k].
# Design 1 reshuffles the 397 shocks within each period; design 2 reshuffles
# them within each two-digit SIC sector and period.
library(readr)
shk <- read_csv("data/adh_shocks.csv", show_col_types = FALSE)
P <- 1999
perm_within <- function(grp) {
  sapply(seq_len(P), function(p) {
    idx <- seq_along(grp)
    for (gq in split(seq_along(grp), grp)) idx[gq] <- gq[sample.int(length(gq))]
    idx
  })
}
set.seed(20261013)
d1 <- perm_within(shk$year)
d2 <- perm_within(paste(shk$sic87dd %/% 100, shk$year))
colnames(d1) <- colnames(d2) <- paste0("p", seq_len(P))
write_csv(as.data.frame(d1), "data/adh_perms_design1.csv")
write_csv(as.data.frame(d2), "data/adh_perms_design2.csv")
