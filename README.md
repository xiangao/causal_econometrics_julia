# Causal Econometrics with Julia

A Quarto book covering modern causal inference methods implemented in Julia,
with chapters on identification, estimation, research designs, mediation, and
causal discovery. All computational examples use custom Julia packages from
`~/projects/software/`.

Live site: **https://xiangao.github.io/causal_econometrics_julia/**

## Chapters

The chapter list below mirrors `_quarto.yml`. There are 25 content
chapters organized into eight parts, plus the preface (`index.qmd`) and
a references page.

### Identification
1. **Identification** — Potential outcomes, DAGs, unconfoundedness
2. **Five Estimands on One DGP** — ATE, ATT, LATE, CATE, QTE compared on a single simulation
3. **DAGs and Graph Identification** — ADMGs, backdoor/front-door, Pearl-Shpitser ID
4. **Smoking Cessation (Applied DAG)** — End-to-end NHEFS workflow with causal graphs
5. **Sensitivity Analysis** — Robustness of causal conclusions to unmeasured confounding

### Estimation
6. **Estimation** — Regression adjustment, IPW, AIPW, IPWRA
7. **Matching** — Nearest-neighbor / balancing approaches in Julia
8. **Nonparametric Methods** — Influence-function estimators, TMLE, DoubleML
9. **Heterogeneous Effects** — Meta-learners, causal forests, BLP, policy learning
10. **Continuous Treatments** — Generalized propensity score, dose-response, kernel AIPW
11. **Bayesian Causal Inference** — BART / BCF
12. **Distributional Treatment Effects** — QTE, Engression-based distributional DiD (Endid.jl)

### Designs
13. **Difference-in-Differences** — ETWFE, staggered adoption, `DiD.jl`
14. **Synthetic Control, SDiD, and TASC** — SC, SynthDiD, time-aware SC with Kalman smoother
15. **Randomization Inference for SC** — Placebo unit tests, MSPE ratio, Fisher p-values, TASC posterior
16. **IV and Regression Discontinuity** — LATE, weak-IV, RD designs with `RDRobust.jl`
17. **Shift-Share IV** — Bartik instruments, Rotemberg weights
18. **IV in Poisson with Fixed Effects** — Control-function and GMM approaches

### Longitudinal Causal Inference
19. **G-Methods** — G-computation, IPW, marginal structural models

### Survival & Time-to-Event
20. **Survival Causal Inference** — RMST, IPW-adjusted survival curves

### Mediation
21. **Causal Mediation** — CDE, NDE, NIE with `Crumble.jl`

### Causal Discovery
22. **Discovery: Observed Variables** — PC, RSL-D algorithms via `CausalInference.jl`; a survey-weighted real-data example on PISA 2022 (background-knowledge tier orientation, bootstrap edge stability)
23. **Discovery: Latent Variables** — FCI, L-MARVEL, PAGs
24. **From Graph to Estimate** — Identification routing (a-fix/p-fix/nested) and TMLE/AIPW estimation with `CausalGraphs.jl`

### Appendix
25. **Package Ecosystem** — Overview of all custom Julia packages

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

## Setup for external readers

The `Manifest.toml` references custom packages by **absolute local
paths** under `~/projects/software/`, which will not exist on another
machine. To run the examples yourself:

```bash
# 1. Clone the custom packages somewhere, e.g. ~/projects/software/
# 2. From the book directory, dev them into the project environment:
julia --project=. -e 'using Pkg; \
  for p in ("CausalEstimate","CausalGraphs","SynthDiD","DiD", \
            "RDRobust","Panelest","Lavaan","Crumble"); \
    Pkg.develop(path=joinpath(homedir(),"projects","software",p*".jl")); end; \
  Pkg.instantiate()'
```

Several of these packages are unregistered and under active
development, so their APIs may still change. Before depending on one in
your own work, check that package's own repository/README for its
current status, and treat code shown in the book as pinned to the
versions in `Manifest.toml` rather than to a stable public API.

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
>
> **2026-06-12:** Second review pass (derivation-focused, all 27 chapters, inline; audit trail in `../_review2/cjulia_inline.md`, fixes in `../_review2/FIXLOG.md`). Highlights: LATE DGP monotonicity (shared-uniform draws), additive- vs multiplicative-moment IV Poisson (Mullahy), panel causal-learner DGP + within-contrast rescaling, in-sample policy-evaluation bias made explicit, recanting-twins mediation section, stabilized-weight display, Rotemberg-weight diagnostics.

> **2026-06-13:** Technical-audit fix pass (Codex audit in `../_technical_audit_20260613/`). Fixed sharp-RD DGP sign; defined the panel within-CATE estimand precisely; strengthened mediation natural-effect assumptions and labeled the CDE IPW formula discrete-mediator-only; qualified continuous-treatment DR; fixed the BLP coefficients-vs-function display; noted that the `Endid`/`Engression` `eval:false` block needs a separate environment; flagged the CPDAG bidirected-glyph overload; softened the L-MARVEL intuition; labeled the synthetic-control objective displays as schematic; removed `mean()` around scalars. Rebuilt the README chapter list to match `_quarto.yml` (25 chapters), added external-reader package-setup instructions and an `eval:false` explanation. Rendered clean.
