# Causal Econometrics with Julia

A Quarto book covering modern causal inference methods implemented in Julia.

## Chapters

1. **Identification** — Potential outcomes, DAGs, identification strategies
2. **Estimation** — OLS, IV, fixed effects
3. **Nonparametric / ML-based** — AIPW, TMLE, DoubleML
4. **DiD** — Difference-in-differences, staggered adoption (ETWFE)
5. **IV & RD** — Instrumental variables, regression discontinuity
6. **Mediation** — Causal mediation analysis
7. **Synthetic DiD** — Synthetic control and synthetic DiD

## Rendering

```bash
# Full book
quarto render

# Single chapter
quarto render nonparametric.qmd
```

The book uses a custom Julia sysimage (`book_sysimage.so`) for fast compilation. To rebuild after changing packages:

```bash
julia --project build_sysimage.jl
```

## Custom Packages

All custom packages live at `~/projects/software/` and are referenced via relative paths in `Manifest.toml`:

- `TMLE.jl` — TMLE and AIPW estimators
- `NPCausal.jl` — Doubly-robust nonparametric estimation
- `Panelest.jl` — Fixed-effects panel models
- `DiD.jl` — ETWFE difference-in-differences
- `SynthDiD.jl` — Synthetic DiD
- `RDRobust.jl` — Regression discontinuity
- `Lavaan.jl` — Structural equation models
- `Crumble.jl` — Causal mediation

## Dependencies

Requires Julia 1.12+ and Quarto. See `Project.toml` for the full package list.
