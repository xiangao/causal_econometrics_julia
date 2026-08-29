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

> **2026-07-30:** Review of the 2026-07-28 `poisson-iv` rewrite (report in `../_review3/review_20260730.md`). The mathematics checked out — Terza's exact correction, the first-order Taylor expansion behind Approach B, the logit generalized-residual collapse, and the claimed probability limits were all re-derived or re-verified at n=10^6. Four corrections: all six citations to Imbens & Wooldridge were re-pointed from the 2009 *JEL* paper to their actual source, the 2007 NBER Summer Institute Lecture Notes 6 on control functions (new bib entry); a truncated quote was restored to include "and still adopt (3.25)", which had reversed its meaning; rho is now defined as the coefficient in E(exp(c1)|v2) = exp(rho*v2) rather than as a correlation (the chapter's own DGP has correlation 1 while rho = 0.2); and two leftover passages recommending Approach A were reconciled with the takeaway's recommendation of B. Approach C is now presented as a bias-variance tradeoff rather than a ranking: Mullahy's moments are consistent here (0.8015 at n=10^6), but at the chapter's n=5000 C is roughly three times as noisy as B and so has the worst RMSE of the three.

> **2026-08-12:** Prose tightening pass across 4 foundational chapters (`identification`, `estimation`, `did`, `iv-rdd`) — compressed wordy openings, switched to "we" voice, tightened explanations. Mirrored in the R companion. No code or results changes.

> **2026-07-30 (deep read):** Full-depth pass over every topic, reviewed **paired**
> against the companion book so each acts as the other's control (log:
> `../_review3/deepread_causal_books.md`). The pairing is what found most of the
> errors; the recurring defect is a correction that landed in one book, chapter, or
> section and not its twin.
>
> Corrections here: `coef(lm(@formula(Y ~ D + X1 + X2), df))[end]` is **X2's**
> coefficient, and was being reported as the adjusted treatment effect (it survived
> four earlier passes because the DGP's coefficients put the wrong number in a
> plausible range); the GATES table ranked observations on an *in-sample* random
> forest prediction and then averaged the same pseudo-outcome inside the resulting
> bins, reporting quintile effects of -1.204 and 5.271 with tight intervals for a
> DGP where the effect is confined to [1, 3]; `AIPW(crossfit = 2)` in two chapters
> contradicted the book's own stated convention of 5 and inflated both estimates and
> standard errors; the claim that a quantile-DiD's average "is not the DiD ATT" is
> false — averaging a quantile function returns a mean, so it *is* the
> difference-in-means DiD; and four places rendered raw Julia struct dumps
> (`CoefTable(Any[[...]])`, a 5000-element weight vector, a stray literal
> `nothing`) into the published pages.
>
> Two genuine **package** bugs surfaced through this book and were fixed upstream:
> `CausalEstimate.jl`'s AIPW ATT normalised its augmentation term by P(A=0) instead
> of P(A=1), inflating the standard error by P(A=1)/P(A=0); and `Crumble.jl`
> reported the influence curve's standard *deviation* as its standard error,
> inflating every SE by sqrt(n) (about 31.6 at n = 1000). Both were invisible to the
> existing tests because they moved only the variance, not the point estimate.
>
> **Follow-up the same day:** all five meta-learners in `heterogeneous-effects` were
> converted from in-sample to out-of-fold evaluation via a new `rf_oof` helper on one
> shared 5-fold split. Every learner improved and the ranking now agrees with the R
> companion (S .723→.884, T .727→.882, X .901→.928, R .467→.714, DR .433→.769);
> in-sample evaluation had punished precisely the learners whose target is a
> high-variance pseudo-outcome. The panel section is deliberately left in-sample —
> out-of-fold there must split by firm, not by row — and the GATES table now prints a
> `Truth` column, which makes both the estimates' accuracy and the intervals' imperfect
> coverage visible in the output.

> **2026-08-24:** Parity pass with the R companion, which had just been revised
> from a handwritten markup of its rendered PDF. This book was not itself
> annotated; the pass exists because the two are twins and the defect that keeps
> recurring across audits is a correction landing in one book and not the other.
>
> The port justified itself immediately. The nonparametric chapter still carried
> a claim about plug-in estimators — that they are biased "because they are trying
> to estimate E[Y(0)] and E[Y(1)], not the difference" — that the R book had
> corrected in June and this one never received. It now has both the correction
> and a new derivation showing where the plug-in's first-order nuisance term comes
> from and why the augmentation term cancels it.
>
> Also ported: a section deleted at the author's instruction and four struck
> sentences; the layout fixes, since this book shares the same `scrbook` setup and
> had the same mid-page gaps and the same flowchart running off the page; a
> rewritten shift-share opening that names the endogenous regressor; the
> adjustment-equivalence argument; GPS and doubly-robust dose-response theory; and
> a prose trim of the Poisson-IV chapter with every code chunk left byte-identical.
>
> A new matching section relates matching and weighting to regression adjustment,
> IPW and AIPW. It reads differently from the R version by design: this book's
> simulated data has a constant effect and good overlap, so four of the five routes
> agree to within 0.005 of each other, and the section explains why rather than
> manufacturing a disagreement. The one route that misses is 1:1 matching without
> replacement, at 1.287 against a truth of 1 — and it is the only route that throws
> data away, discarding 364 of 1,182 controls.
>
> Three of the R book's fixes did not apply and are recorded in `CLAUDE.md` with
> the reason: this book has no partial-identification section, its sensitivity
> contour is a hand-rolled plot without the label-overprinting problem, and two
> items were specific to R packages.

> **2026-08-29:** Mirrored two theory additions from the R companion's
> `poisson-iv.qmd`: the Lin & Wooldridge result that the FE and Mundlak residuals
> give numerically identical estimates (verified at 3e-15), and a warning against
> using the exogeneity test to select between the naive and control-function
> models, which the existing "valid as an exogeneity test" bullet had invited.
> The third addition there is a Stata/R software note and was not carried over.

