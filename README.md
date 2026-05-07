# Causal Econometrics with Julia

A Quarto book covering modern causal inference methods implemented in Julia.

## Chapters

1. **Identification** — Potential outcomes, DAGs, identification strategies
2. **Estimation** — Regression adjustment, IPW, AIPW, IPWRA
3. **Nonparametric / ML-based** — AIPW, TMLE, DoubleML
4. **DiD** — Difference-in-differences, staggered adoption (ETWFE), synthetic control, synthetic DiD
5. **IV & RD** — Instrumental variables, regression discontinuity
6. **Mediation** — Causal mediation analysis
7. **Julia Packages** — Local Julia packages used throughout the book

## Rendering

```bash
# Full book
quarto render

# Single chapter
quarto render nonparametric.qmd
```

The book renders with the `julia-1.12` Jupyter kernel, which uses `--project=@.` and therefore picks up this book's `Project.toml` when rendering from this directory.

A custom Julia sysimage (`book_sysimage.so`) can be used for faster compilation. To rebuild after changing packages:

```bash
julia --project build_sysimage.jl
```

## Custom Packages

All custom packages live at `~/projects/software/` and are referenced via relative paths in `Manifest.toml`:

- `CausalEstimate.jl` — Unified TMLE and AIPW estimation
- `Panelest.jl` — Fixed-effects panel models
- `DiD.jl` — ETWFE difference-in-differences
- `SynthDiD.jl` — Synthetic DiD
- `RDRobust.jl` — Regression discontinuity
- `Lavaan.jl` — Structural equation models
- `Crumble.jl` — Causal mediation

## Dependencies

Requires Julia 1.12+ and Quarto. See `Project.toml` for the full package list.
