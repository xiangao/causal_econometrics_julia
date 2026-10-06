# Generates the shared data for recentered-instruments.qmd (both books).
# Run from the book root: Rscript data/gen_recentering.R
#
# Simulation: 50 states, 10,000 people. A state's policy is an income threshold
# (multiples of the poverty line) drawn iid from a pool of four. Eligibility is
# 1[income < threshold]. The error depends on income and on a state effect, so
# eligibility is endogenous; the thresholds are independent of both.
#
# ADH: the GPSS (2020) bartik-weight files, copied from the validated build in
# ~/projects/claude/shiftshare_adh_showcase/data/ (sources: github.com/paulgp/bartik-weight).

set.seed(20261006)

n_people <- 10000
n_state  <- 50
n_draw   <- 1000
pool     <- c(0.5, 1.0, 1.38, 2.0)

people <- data.frame(
  id     = seq_len(n_people),
  state  = sample.int(n_state, n_people, replace = TRUE),
  income = exp(rnorm(n_people, log(1.4), 0.6))
)
alpha_state  <- rnorm(n_state, 0, 0.3)
people$eps   <- 0.5 * (-log(people$income)) + alpha_state[people$state] +
                rnorm(n_people)

draws <- matrix(sample(pool, n_draw * n_state, replace = TRUE),
                nrow = n_draw, ncol = n_state)
colnames(draws) <- paste0("s", seq_len(n_state))

write.csv(people, "data/recenter_people.csv", row.names = FALSE)
write.csv(data.frame(draw = seq_len(n_draw), draws),
          "data/recenter_policy_draws.csv", row.names = FALSE)

src <- "~/projects/claude/shiftshare_adh_showcase/data"
adh <- read.csv(file.path(src, "ADHdata_AKM.csv"))
adh$row <- seq_len(nrow(adh))
write.csv(adh, "data/adh_master.csv", row.names = FALSE)
tr <- read.csv(file.path(src, "shares_triplets.csv"), header = FALSE,
               col.names = c("row", "col", "share"))
write.csv(tr, "data/adh_shares_triplets.csv", row.names = FALSE)
sh <- read.csv(file.path(src, "shocks.csv"))
sh$col <- seq_len(nrow(sh))
write.csv(sh[, c("col", "year", "sic87dd", "g")], "data/adh_shocks.csv",
          row.names = FALSE)
