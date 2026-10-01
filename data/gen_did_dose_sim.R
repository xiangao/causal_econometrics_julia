# Two-period simulation with a continuous dose, used in did-continuous.qmd.
# Scenario A: gains independent of dose. Scenario B: larger gains, larger dose.
set.seed(20261001)
n0 <- 1000; n1 <- 2000; n <- n0 + n1
D <- c(rep(0, n0), runif(n1, 0.5, 2.5))
alpha <- 2 + 0.5 * D + rnorm(n)
e1 <- rnorm(n, sd = 0.5); e2 <- rnorm(n, sd = 0.5)
m <- function(d) 1.5 * d - 0.3 * d^2
u <- rnorm(n, sd = 0.2)
b <- list(A = 1 + u, B = 1 + 0.5 * (D - 1.5) * (D > 0) + u)
sim <- do.call(rbind, lapply(names(b), function(sc) rbind(
  data.frame(id = 1:n, t = 1, d = D, y = alpha + e1, scenario = sc),
  data.frame(id = 1:n, t = 2, d = D, y = alpha + 1 + b[[sc]] * m(D) + e2, scenario = sc))))
data.table::fwrite(sim, "did_dose_sim.csv")
