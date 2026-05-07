# Causal Econometrics with Julia — CLAUDE.md

## Quick reference

- **Render**: `quarto render` (uses the standard `julia-1.12` kernel with `--project=@.`)
- **Render one chapter**: `quarto render nonparametric.qmd`
- **Optional fast kernel**: `julia --project build_sysimage.jl` (~20 min; do this when packages change)
- **Run tests for packages**: `cd ~/projects/software/CausalEstimate.jl && julia --project -e 'using Pkg; Pkg.test()'`

## Project structure

- `*.qmd` — Quarto book chapters (Julia/IJulia kernel)
- `_quarto.yml` — Quarto config; kernel = `julia-1.12`
- `package-ecosystem.qmd` — final chapter summarizing the local packages under `~/projects/software`
- `book_sysimage.so` — optional precompiled sysimage for fast rendering
- `build_sysimage.jl` — Script to rebuild sysimage
- `precompile_script.jl` — PackageCompiler precompile workload
- `data/` — Dataset files (CSV, DTA)
- `_book/` — Rendered HTML output (do not edit)
- `_freeze/` — Quarto cell cache (delete to force re-render)

## Custom packages (all at ~/projects/software/)

| Package | Purpose |
|---------|---------|
| `RDRobust.jl` | RD estimation: `rdrobust`, `rdbwselect`, `rdplot` |
| `Panelest.jl` | FE panel OLS/GLM: `feols`, `feiv` |
| `CausalGraphs.jl` | DAG/ADMG construction, identification, and ID algorithm |
| `CausalEstimate.jl` | Unified TMLE/AIPW: `estimate(ATE/ATT(...), TMLE/AIPW(...), df)` |
| `SynthDiD.jl` | Synthetic DiD: `synthdid_estimate`, `sc_estimate`, `did_estimate` |
| `DiD.jl` | ETWFE + `emfx()` aggregation; `dataset("mpdta")` |
| `CausalGraphs.jl` | DAG/ADMG identification + p-fixable/nested estimation |
| `Lavaan.jl` | SEM: `sem()` |
| `Crumble.jl` | Causal mediation analysis |

## CausalEstimate.jl API

```julia
using CausalEstimate

# ATE with TMLE
result = estimate(ATE(outcome=:Y, treatment=:A, confounders=[:W1,:W2]), TMLE(crossfit=5), df)

# ATE with AIPW
result = estimate(ATE(outcome=:Y, treatment=:A, confounders=[:W1,:W2]), AIPW(crossfit=5), df)

# ATT
result = estimate(ATT(outcome=:Y, treatment=:A, confounders=[:W1,:W2]), AIPW(crossfit=5), df)

# Graph-identified (backdoor/a-fixable)
result = estimate(ATE(outcome=:Y, treatment=:A), GraphID(graph=g), AIPW(crossfit=5), df)

estimate(result)        # point estimate
confint(result)         # (lb, ub) tuple
pvalue(result)          # p-value
result.primary.standard_error
```

For p-fixable / front-door / nested-fixable / ID plug-in effects, use `CausalGraphs.estimate_causal(...)` directly.

## Sysimage notes

- The default render path does not require a sysimage.
- If you switch `_quarto.yml` to `jupyter: julia-_book_-1.12`, rebuild the sysimage whenever custom packages change (paths in Manifest.toml).
- HypothesisTests must be in Project.toml as a **direct** dependency (not just transitive via TMLE.jl)
- The `julia-_book_-1.12` IJulia kernel is installed by `build_sysimage.jl`

## ETWFE / emfx design (critical)

- Must use **string columns** `first_treat_str & year_str` for ETWFE dummies (Int columns give 1 coef, not cohort×time dummies)
- `DiD.dataset("mpdta")` already includes `first_treat_str`, `year_str`
- For external datasets: `df.first_treat_str = string.(df.first_treat); df.year_str = string.(df.year)`
