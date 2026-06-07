# Causal Econometrics with Julia

A Quarto book covering modern causal inference methods implemented in Julia,
with chapters on identification, estimation, research designs, mediation, and
causal discovery. All computational examples use custom Julia packages from
`~/projects/software/`.

Live site: **https://xiangao.github.io/causal_econometrics_julia/**

## Chapters (18 total)

### Identification
1. **Identification** — Potential outcomes, DAGs, unconfoundedness
2. **Five Estimands on One DGP** — ATE, ATT, LATE, CATE, QTE compared on a single simulation
3. **DAGs and Graph Identification** — ADMGs, backdoor/front-door, Pearl-Shpitser ID
4. **Smoking Cessation (Applied DAG)** — End-to-end NHEFS workflow with causal graphs

### Estimation
5. **Estimation** — Regression adjustment, IPW, AIPW, IPWRA
6. **Nonparametric Methods** — Influence-function estimators, TMLE, DoubleML
7. **Distributional Treatment Effects** — QTE, Engression-based distributional DiD (Endid.jl)

### Designs
8. **Difference-in-Differences** — ETWFE, staggered adoption, `DiD.jl`
9. **Synthetic Control, SDiD, and TASC** — SC, SynthDiD, time-aware SC with Kalman smoother
10. **Randomization Inference for SC** — Placebo unit tests, MSPE ratio, Fisher p-values, TASC posterior
11. **IV and Regression Discontinuity** — LATE, weak-IV, RD designs with `RDRobust.jl`
12. **IV in Poisson with Fixed Effects** — Control-function and GMM approaches

### Mediation
13. **Causal Mediation** — CDE, NDE, NIE with `Crumble.jl`

### Causal Discovery
14. **Discovery: Observed Variables** — PC, RSL-D algorithms via `CausalInference.jl`; a survey-weighted real-data example on PISA 2022 (background-knowledge tier orientation, bootstrap edge stability)
15. **Discovery: Latent Variables** — FCI, L-MARVEL, PAGs
16. **From Graph to Estimate** — Identification routing (a-fix/p-fix/nested) and TMLE/AIPW estimation with `CausalGraphs.jl`

### Appendix
17. **Package Ecosystem** — Overview of all custom Julia packages

## Rendering

```bash
# Full book (re-renders all chapters from _freeze/)
JULIA_PROJECT=. quarto render

# Single chapter (updates that chapter and the nav in _book/)
JULIA_PROJECT=. quarto render nonparametric.qmd --to html

# Publish to GitHub Pages (after render)
quarto publish gh-pages --no-render --no-prompt
```

> **Important**: When adding a new chapter, run `quarto render` (full project)
> before publishing so all chapters pick up the updated sidebar navigation.
> Rendering individual chapters gives them correct content but outdated nav.

The book uses `freeze: auto` — chapters only re-execute when their source
changes. Delete `_freeze/<chapter>/` to force re-execution of a specific chapter.

## Custom Packages

All live at `~/projects/software/` and are referenced in the book's `Manifest.toml`:

| Package | What it provides |
|---|---|
| `CausalEstimate.jl` | Unified TMLE/AIPW: `estimate(ATE(...), TMLE(...), df)` |
| `CausalGraphs.jl` | ADMG identification routing + TMLE/AIPW for backdoor/front-door/nested |
| `SynthDiD.jl` | `synthdid_estimate`, `sc_estimate`, `did_estimate`, `california_prop99()` |
| `DiD.jl` (ETWFE) | `att_gt`, `emfx`, `dataset("mpdta")` |
| `RDRobust.jl` | `rdrobust`, `rdbwselect`, `rdplot` |
| `Panelest.jl` | `feols`, `feiv` for fixed-effects panel models |
| `Lavaan.jl` | `sem()` structural equation models |
| `Crumble.jl` | Causal mediation (CDE, NDE, NIE) |

Packages loaded via `include()` (not in `Project.toml`):

| Package | Used in |
|---|---|
| `TASC.jl` | `synthetic-control-did-tasc.qmd`, `randomization-inference-sc.qmd` |

## Dependencies

Julia 1.12+ and Quarto. See `Project.toml` for the full package list.

> **2026-06-07:** Math/code review pass — see `CLAUDE.md` (Review pass section) for the list of corrections. Audit trail in `../_review/`.
