# Generates the shared data for the deworming section of recentered-instruments.qmd
# (both books). Run from the book root: Rscript data/gen_deworming.R
#
# 75 schools in a 30 km x 30 km district: half clustered around a town, half
# spread over the district. Each school has about 400 pupils and a fixed error.
# A treatment draw picks exactly 25 of the 75 schools, as in each phase-in group
# of Miguel and Kremer (2004).

set.seed(20261008)

n_school <- 75
n_treat  <- 25
n_draw   <- 1000
n_town   <- 38

schools <- data.frame(
  id     = seq_len(n_school),
  east   = c(rnorm(n_town, 15, 2.5), runif(n_school - n_town, 0, 30)),
  north  = c(rnorm(n_town, 15, 2.5), runif(n_school - n_town, 0, 30)),
  pupils = pmax(100, round(rnorm(n_school, 400, 100))),
  eta    = rnorm(n_school, 0, 0.05)
)

draws <- t(replicate(n_draw, as.integer(seq_len(n_school) %in%
                                         sample.int(n_school, n_treat))))
colnames(draws) <- paste0("s", seq_len(n_school))

write.csv(schools, "data/deworm_schools.csv", row.names = FALSE)
write.csv(data.frame(draw = seq_len(n_draw), draws),
          "data/deworm_draws.csv", row.names = FALSE)
