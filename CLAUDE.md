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

| Package | Version | Purpose | Julia General PR |
|---------|---------|---------|---------|
| `RDRobust.jl` | 0.1.0 | RD estimation: `rdrobust`, `rdbwselect`, `rdplot` | [#155054](https://github.com/JuliaRegistries/General/pull/155054) |
| `Panelest.jl` | 0.1.1 | FE panel OLS/GLM: `feols`, `feiv` | [#155060](https://github.com/JuliaRegistries/General/pull/155060) |
| `CausalGraphs.jl` | 0.1.1 | DAG/ADMG construction, identification, and ID algorithm | [#155059](https://github.com/JuliaRegistries/General/pull/155059) |
| `CausalEstimate.jl` | 0.1.0 | Unified TMLE/AIPW: `estimate(ATE/ATT(...), TMLE/AIPW(...), df)` | pending CausalGraphs merge |
| `SynthDiD.jl` | 0.1.0 | Synthetic DiD: `synthdid_estimate`, `sc_estimate`, `did_estimate` | [#155055](https://github.com/JuliaRegistries/General/pull/155055) |
| `DiD.jl` | 0.1.0 | ETWFE + `emfx()` aggregation; `dataset("mpdta")` | [#155056](https://github.com/JuliaRegistries/General/pull/155056) |
| `Lavaan.jl` | 0.1.0 | SEM: `sem()` | [#155057](https://github.com/JuliaRegistries/General/pull/155057) |
| `Crumble.jl` | 0.1.0 | Causal mediation analysis | [#155058](https://github.com/JuliaRegistries/General/pull/155058) |

**Registration notes:**
- All 8 packages submitted to Julia General Registry (JuliaRegistrator app installed on all repos)
- CausalEstimate registration blocked until CausalGraphs PR merges — re-trigger with `@JuliaRegistrator register` on the v0.1.0 tagged commit once CausalGraphs is merged
- CausalGraphs and Panelest are v0.1.1 (v0.1.0 had unregistered weakdeps that were removed: NPCausal from CausalGraphs, DuckDB/DBInterface from Panelest)
- `RecursiveCausalDiscovery` is still a local path dep (`~/projects/repo_cloned/`) — not our package, upstream registration pending
- UUID fixes applied: CausalGraphs, Crumble, Lavaan had placeholder UUIDs replaced with valid UUID4 values

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

## Chapter structure notes

- Each chapter has a **hidden setup block** (`#| include: false`) loading all packages and helper functions, followed immediately by a **visible display block** (`#| eval: false`) showing only the `using`/`import` lines. Edit both if adding new packages.
- Causal discovery chapters (`causal-discovery.qmd`, `causal-discovery-latent.qmd`) use `gen_er_dag_adj_mat` and `gen_gaussian_data` from `RecursiveCausalDiscovery` (local clone at `~/projects/repo_cloned/RecursiveCausalDiscovery.jl`).

## Sysimage notes

- The default render path does not require a sysimage.
- If you switch `_quarto.yml` to `jupyter: julia-_book_-1.12`, rebuild the sysimage whenever custom packages change (paths in Manifest.toml).
- HypothesisTests must be in Project.toml as a **direct** dependency (not just transitive via TMLE.jl)
- The `julia-_book_-1.12` IJulia kernel is installed by `build_sysimage.jl`

## ETWFE / emfx design (critical)

- Must use **string columns** `first_treat_str & year_str` for ETWFE dummies (Int columns give 1 coef, not cohort×time dummies)
- `DiD.dataset("mpdta")` already includes `first_treat_str`, `year_str`
- For external datasets: `df.first_treat_str = string.(df.first_treat); df.year_str = string.(df.year)`
