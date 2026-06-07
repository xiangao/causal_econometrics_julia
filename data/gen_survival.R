# DGP for survival_sim.csv (shared by causal_econometrics_guide + _julia).
# Weibull proportional hazards; true adjusted log-HR(trt) = -0.4 (HR = exp(-0.4) ≈ 0.67);
# treatment confounded by age & sex; random dropout + administrative censoring at 12y.
set.seed(5)
n <- 1500
age <- rnorm(n, 60, 10)
sex <- rbinom(n, 1, 0.5)

# Treatment propensity (confounded by age and sex)
ps  <- plogis(-1.0 + 0.03 * (age - 60) + 0.4 * sex)
trt <- rbinom(n, 1, ps)

# Weibull PH latent event time: S(t) = exp(-(lambda0 t)^k exp(eta))
k <- 1.4; lambda0 <- 0.11
eta  <- -0.4 * trt + 0.03 * (age - 60) + 0.3 * sex   # true log-HR(trt) = -0.4
U    <- runif(n)
Tlat <- (1 / lambda0) * (-log(U) / exp(eta))^(1 / k)

# Censoring: exponential dropout capped by administrative end of follow-up (12 years)
Ctime <- pmin(rexp(n, rate = 1/40), 12)
time  <- pmin(Tlat, Ctime)
event <- as.integer(Tlat <= Ctime)

df <- data.frame(time = round(time, 4), event = event, trt = trt,
                 age = round(age, 4), sex = sex)
write.csv(df, "causal_econometrics_guide/data/survival_sim.csv", row.names = FALSE)
write.csv(df, "causal_econometrics_julia/data/survival_sim.csv",  row.names = FALSE)

suppressMessages(library(survival))
cox <- coxph(Surv(time, event) ~ trt + age + sex, data = df)
cat(sprintf("WROTE n=%d | treated %.3f | censored %.3f | median time %.2f | Cox HR(trt) %.3f\n",
            n, mean(trt), mean(1-event), median(time), exp(coef(cox)["trt"])))
