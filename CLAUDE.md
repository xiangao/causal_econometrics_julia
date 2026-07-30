# Causal Econometrics with Julia — CLAUDE.md

## Quick reference

- **Render full book**: `JULIA_PROJECT=. quarto render`
- **Render one chapter**: `JULIA_PROJECT=. quarto render nonparametric.qmd --to html`
- **Publish**: `quarto publish gh-pages --no-render --no-prompt`
- **Force re-execute a chapter**: delete `_freeze/<chapter>/` then render
- **Run package tests**: `cd ~/projects/software/<Package>.jl && julia --project -e 'using Pkg; Pkg.test()'`

> **Navigation gotcha**: individual chapter renders update only that chapter's
> HTML. Run `quarto render` (full project) whenever chapters are added or
> removed so all sidebars stay in sync.

## Book structure (25 chapters, 9 parts; excluding `index.qmd`)

| Part | Chapter file | Notes |
|---|---|---|
| Identification | `identification.qmd` | Potential outcomes, DAGs |
| Identification | `causal-estimands.qmd` | ATE/ATT/LATE/CATE/QTE on one DGP |
| Identification | `graphs-identification-estimation.qmd` | ADMGs, ID algorithm |
| Identification | `smoking-cessation-graphs.qmd` | Applied NHEFS DAG workflow |
| Identification | `sensitivity-analysis.qmd` | Cinelli-Hazlett RV, E-values, Rosenbaum bounds (inline) |
| Estimation | `estimation.qmd` | RA, IPW, AIPW, IPWRA |
| Estimation | `matching.qmd` | NN matching, IPW, balance diagnostics, entropy balancing (inline Newton on convex dual) |
| Estimation | `nonparametric.qmd` | TMLE, DoubleML, CausalEstimate.jl |
| Estimation | `heterogeneous-effects.qmd` | S/T/X/R/DR meta-learners with MLJ + DecisionTree; panel CATE via within-transform |
| Estimation | `continuous-treatments.qmd` | Hirano-Imbens GPS, DR dose-response (inline) |
| Estimation | `bayesian-causal.qmd` | Bayesian g-computation (inline conjugate Bayesian linreg) |
| Estimation | `distributional-effects.qmd` | QTE, Engression-based distributional DiD |
| Designs | `did.qmd` | ETWFE, staggered adoption |
| Designs | `synthetic-control-did-tasc.qmd` | SC, SynthDiD, TASC |
| Designs | `randomization-inference-sc.qmd` | Placebo tests, MSPE ratio, TASC posterior |
| Designs | `shift-share-iv.qmd` | Bartik IV, Rotemberg weights, BHJ collapse (ShiftShareIV.jl) |
| Designs | `iv-rdd.qmd` | IV/LATE, RD with RDRobust.jl |
| Designs | `poisson-iv.qmd` | CF + GMM for Poisson with FE |
| Longitudinal | `g-methods.qmd` | G-formula + IPTW + MSM via GLM (LTMLE noted as R-only) |
| Survival | `survival-causal.qmd` | KM, IPW-adjusted KM, RMST (inline; Cox/DR-survival noted as R-only) |
| Mediation | `mediation.qmd` | CDE, NDE, NIE with Crumble.jl |
| Causal Discovery | `causal-discovery.qmd` | PC, RSL-D |
| Causal Discovery | `causal-discovery-latent.qmd` | FCI, L-MARVEL, PAGs |
| Causal Discovery | `graph-to-estimate.qmd` | CausalGraphs.jl: identify + estimate |
| Appendix | `package-ecosystem.qmd` | Package overview |

## Adding a new chapter

1. Create the `.qmd` file.
2. Add it to `_quarto.yml` in the right part.
3. Render it: `JULIA_PROJECT=. quarto render <chapter>.qmd --to html`
4. Run a full project render to update nav in all other chapters: `JULIA_PROJECT=. quarto render`
5. Commit: `git add <chapter>.qmd _quarto.yml _freeze/<chapter>/ && git commit -m "..."`
6. Push: `git push`
7. Publish: `quarto publish gh-pages --no-render --no-prompt`

## Custom packages (all at ~/projects/software/)

### In Project.toml (registered or developed)

| Package | Version | Julia General | Key API |
|---|---|---|---|
| `CausalGraphs.jl` | 0.1.2 | **Merged** ✓ | `make_graph`, `identify`, `estimate_causal` |
| `Crumble.jl` | 0.1.1 | **Merged** ✓ | causal mediation |
| `ETWFE` (DiD.jl) | 0.1.3 | Pending #155610 | `att_gt`, `emfx`, `dataset` |
| `Lavaan.jl` | 0.1.1 | Pending #155063 | `sem()` |
| `RDRobust.jl` | 0.1.1 | Pending #155061 | `rdrobust`, `rdbwselect` |
| `Panelest.jl` | 0.1.3 | Pending #155060 | `feols`, `feiv`, `etwfe`, `emfx` |
| `SynthDiD.jl` | 0.1.1 | Pending #155062 | `synthdid_estimate`, `sc_estimate`, `did_estimate`, `california_prop99` |
| `CausalEstimate.jl` | 0.1.0 | Pending CausalGraphs merge | `estimate(ATE/ATT(...), TMLE/AIPW(...), df)` |
| `TASC.jl` | 0.1.0 | Dev / Local | `fit_tasc`, `predict_counterfactual`, `tasc_plot` |
| `ShiftShareIV.jl` | 0.1.0 | Dev / Local | shift-share IV, Rotemberg weights |
| `MSC.jl` | 0.1.0 | Dev / Local | model selection control / synthetic controls |

### External (not our packages)

| Package | Source |
|---|---|
| `RecursiveCausalDiscovery` | Local clone at `~/projects/repo_cloned/`; used in discovery chapters |

### Intentionally local (not published)

| Package | Location | Reason |
|---|---|---|
| `TMLE.jl` | `~/projects/local_software/TMLE.jl` | Name taken by TARGENE/TMLE.jl in General registry; book uses CausalEstimate.jl for TMLE instead |
| `anankeR` | `~/projects/local_software/anankeR` | R port of ananke-causal Python package; no remote |
| `lavaan_r` | `~/projects/local_software/lavaan_r` | Rosseel's upstream lavaan source; reference copy for Lavaan.jl development |

## Registry status (as of 2026-05-15)

- **Merged**: CausalGraphs v0.1.2, Crumble v0.1.1
- **Pending review**: ETWFE v0.1.3 (#155610), Lavaan v0.1.1 (#155063), RDRobust v0.1.1 (#155061), Panelest v0.1.1 (#155060), SynthDiD v0.1.1 (#155062)
- **Closed/withdrawn**: DiD v0.1.0 and v0.1.1 (renamed to ETWFE), old v0.1.0 PRs superseded by v0.1.1s
- To re-trigger registration for a package: comment `@JuliaRegistrator register` on the latest tagged commit

## Chapter coding patterns

### Setup blocks
Each chapter has two import blocks:
```julia
# Block 1: hidden setup (include: false) — loads everything needed
#| include: false
using Foo, Bar, ...

# Block 2: visible display (eval: false) — shows imports to reader
#| eval: false
using Foo, Bar, ...
```
Edit **both** when adding new packages to a chapter.

### TASC.jl import pattern
```julia
#| include: false
using TASC
```
TASC EM convergence: use `n_em=200, tol=1e-3` for Prop 99 (38 states × 31 years).
`n_em=25` was too tight and now emits a `@warn`.

### ETWFE string-column requirement
ETWFE cohort×time interactions require **string** columns:
```julia
df.first_treat_str = string.(df.first_treat)
df.year_str        = string.(df.year)
```
`DiD.dataset("mpdta")` already includes these columns.

## CausalEstimate.jl API

```julia
result = estimate(ATE(outcome=:Y, treatment=:A, confounders=[:W1,:W2]), TMLE(crossfit=5), df)
result = estimate(ATT(outcome=:Y, treatment=:A, confounders=[:W1,:W2]), AIPW(crossfit=5), df)
estimate(result)   # point estimate
confint(result)    # (lb, ub)
pvalue(result)
```

For p-fixable / front-door / nested-fixable effects, use `CausalGraphs.estimate_causal(...)` directly (see `graph-to-estimate.qmd`).

## Cross-book parity with R companion

Results are validated to match `causal_econometrics_guide` within 1% (real data) or 5% (simulated).

### Shared datasets (generated in R, loaded by both books)
- `survival-causal.qmd` → `data/survival_sim.csv` (n=1500 Weibull; propensity intercept=-4 for ~30% treatment)
- `shift-share-iv.qmd` → `data/shift_share_sim.csv`, `shift_share_shares.csv`, `shift_share_shocks.csv`, `shift_share_bad_v.csv`, `shift_share_bad_noise.csv`

### Notable chapter additions (May 2026)
- `did.qmd`: Added **Nonlinear ETWFE** section using `Panelest.etwfe(family="poisson")`. Uses cohort FE + year FE (not unit FE) to avoid contamination bias. `emfx()` returns log-scale ATTs (log IRR).

### Key gotchas

**ETWFE: cohort FE vs unit FE**
Wooldridge ETWFE uses cohort FE + year FE, NOT unit FE (`fe(id)`). Using unit FE creates contamination bias: the within-unit demeaning mixes pre- and post-treatment variation, compressing post-treatment ATTs and producing negative pre-trends even when CPT holds. Use `etwfe()` from Panelest (defaults to cohort FE) or manually specify `fe(first_treat_str) + fe(year)`.

**`feiv` coefficient ordering**
In `Panelest.feiv`, coefficients are ordered `[endo vars, exo vars]`:
- `coef(model)[1]` → endogenous variable coefficient (the IV estimate you want)
- `coef(model)[end]` → last exogenous coefficient (intercept if `@formula(Y ~ 1)`)
This is opposite to `feols` where `[end]` gives the last regressor.

**L&L pre-trend test reference period**
When adding pre-treatment dummies for the event study, drop `t = g-1` (the period just before treatment). Including all pre-treatment periods without a reference creates identification issues with cohort FE.

## Data

- `data/california_prop99.csv` — Prop 99 cigarette panel (39 states, 1970–2000)
- `data/mpdta.csv` — US teen employment (500 counties × 5 years)
- `data/survival_sim.csv` — Shared survival simulation (Weibull, n=1500)
- `data/shift_share_*.csv` — Shared shift-share simulation (n=500 regions, 20 industries)
- `data/pisa_usa2022.csv` — **real** PISA data (USA 2022, 3,890 students; nodes HISEI, HOMEPOS, IMMIG, GRADE, GENDER, MATH = mean of 10 PVs; survey weight `W`). Used by `causal-discovery.qmd`'s real-data section (weighted PC + RSL-D, tier orientation, bootstrap stability). Generated from `~/projects/pisa-covid-did`; **`PARED` is absent in PISA 2022 — do not add it.** Same file as the R book.
- Other datasets loaded inside chapters from CSV or generated synthetically

## Review pass (2026-06-07)
Math/code audit + fixes across 16 chapters (audit trail: ../_review/). Key corrections:
- matching: entropy-balancing Newton step had the WRONG SIGN (`λ .+= step` → `λ .-= step`); was giving ATT≈5.6, now 1.014 (true 1.0), control means now exactly match treated.
- g-methods: stated true effects corrected to 1.5/1.0 (mirror of R guide).
- heterogeneous-effects: dropped unobserved U from propensity (identified); R-learner now actually uses its weights (weighted bootstrap in rf_fit_predict); panel true-ATE corrected to mean(1 .+ tau_panel).
- estimation: IPW-ATT now carries the π/(1-π) odds factor. iv-rdd: `tau_us` relabeled conventional (not bias-corrected). identification: 0<π(X)<1.
- causal-discovery: α/significance bias-variance description was backwards. distributional-effects: IPW-CDF self-normalized; difference-of-quantiles relabeled (not a QTE).
- sensitivity-analysis: `using Distributions` was sitting after a docstring → "cannot document" error; moved above it.
- survival-causal: shares regenerated data/survival_sim.csv (generator: data/gen_survival.R).
Re-rendered (JULIA_PROJECT=.) + outputs verified.

## Review pass 2 (2026-06-12)
Inline derivation-focused review of ALL 27 chapters, one chapter at a time (audit trail: ../_review2/cjulia_inline.md; itemized in ../_review2/FIXLOG.md; every MAJOR-class item numerically verified before editing). Highest-severity corrections:
- causal-estimands: D0/D1 were INDEPENDENT draws → 2.95% defiers despite the monotonicity prose; both DGPs now use one shared uniform with ordered thresholds (Wald 2.004 = LATE 2.004 after fix). Same bug class as the R book's F-CE-1.
- poisson-iv: additive-moment IV Poisson is inconsistent under this chapter's inside-exp unobservables (Mullahy 1997) — own table showed 0.527 vs truth 0.8 while the note claimed "recovers closely". MC-verified (additive mean 0.610, multiplicative 0.788); ivpois_mult added; both moment forms now taught.
- heterogeneous-effects: panel DGP had no FE confounding + the dichotomized within-T-learner contrast was attenuated by the W_dm gap (printed 1.283 vs own truth 1.655); new DGP (W depends on unit_fe) + Wald-style rescale. Policy section: cost 0.5 was degenerate AND the τ̂-rule was selected and evaluated on the same DR scores (biased 0.887 vs honest 0.133 vs oracle 0.302 at cost 2) — now an explicit lesson about in-sample policy evaluation.
- mediation: IIE/IDE section rewritten for the RECANTING-TWINS estimand (Crumble effect="RT" sums to the ATE exactly — verified; do NOT import the R book's medoutcon wording here); NDE/NIE mediator model had no main A effect (M ~ A&W1+W1&W2) forcing NIE≈0 artifact → A*W1+W1*W2.
- identification (adjustment formula, not marginal equality), g-methods (SW denominator L̄_t; untrimmed-MSM comparison), matching (ebal Σw=1; honest control-exhaustion prose for the biased 1:1 match), nonparametric (partialling-out score display; sandwich), shift-share (Rotemberg weights = influence not endogeneity, LOO check added), did (Bacon weights; ETWFE incidental-parameters rationale), discovery chapters (F1 metric description matches implementation; Possible-D-SEP stage; PAG-mark table row; arrows = ancestors), iv-rdd (kappalate), sensitivity/survival/continuous (smaller mirrors).
- KNITR-style staleness does NOT apply here (jupyter engine = whole-notebook cache), but chunk RNG is stream-order dependent: standalone reproductions can differ from rendered numbers — always verify claims against the RENDERED output.

## Review pass (2026-07-30)
Review of the 2026-07-28 rewrite of `poisson-iv.qmd` (10 commits), the only chapter changed since the 2026-07-04 agy-review fix pass. Report: `../_review3/review_20260730.md`. Identical findings and fixes applied to both this book and its Julia book counterpart.

**The mathematics was all correct** and was left alone. Re-derived independently before touching anything: Terza's $h(\cdot)$ from the truncated-normal moments $E[e^{\rho v}\mid v \ge -z\pi] = e^{\rho^2/2}\Phi(z\pi+\rho)/\Phi(z\pi)$; the Taylor expansion ($\partial_\rho e^{\rho^2/2}|_0 = 0$, $\partial_\rho[\Phi(\rho+\eta)/\Phi(\eta)]|_0 = \lambda(\eta)$, $\partial_\rho\{[1-\Phi(\rho+\eta)]/[1-\Phi(\eta)]\}|_0 = -\lambda(-\eta)$), hence Approach B as the first-order-in-$\rho$ approximation with $O(\rho^2)$ error; and the logit collapse $y_2\lambda/\Lambda - (1-y_2)\lambda/(1-\Lambda) = y_2 - \Lambda$. Claimed plims confirmed at $n=10^6$ (A 0.8383, B 0.8212 against the stated 0.839/0.822) and the additive-moment figure is exactly 0.6279 against "≈0.63".

**Citation provenance (the main finding).** All six `@imbens-wooldridge-2009-jel` citations pointed at the wrong document. Equations (3.23)–(3.25), (3.32), (3.34)–(3.36), "sec. 3.3", the $h(\cdot)$ formula and the Terza block quote are all from **Imbens & Wooldridge (2007), NBER Summer Institute Lecture Notes 6, "Control Functions and Related Methods"** (downloaded and text-matched; page 20 carries the quote verbatim), not from the 2009 *JEL* program-evaluation paper. New bib key `@imbens-wooldridge-2007-cf` added to `references.bib`; all six re-pointed. The 2009 JEL entry is now unused but kept.
- The quote had been truncated immediately before **"and still adopt (3.25). In fact, we assume $(r_1,v_2)$ is jointly normal."** — which reverses its sense, since (3.25) (independence from $\mathbf z$) is *re-asserted about the latent $v_2$*, not discarded. Restored, with a gloss.
- The unverifiable "Estimate P(W=1|x,z) by probit (or logit)…" quote was replaced with the verbatim lecture-notes wording; the probit-or-logit point is now derived (a logit fitted probability is just another function of $\mathbf z$) rather than attributed.

**$\rho$ is a coefficient, not a correlation.** The chapter defined $\mathrm{Corr}(c_1,v_2)=\rho$, but $h(\cdot)$ requires $\rho$ from $E(\exp(c_1)\mid v_2)=\exp(\rho v_2)$ — that is what makes $e^{\rho^2/2}$ the lognormal correction and puts $\rho$ on the probit index's scale. The chapter's own DGP settles it: $c_1 = 0.2 e_2$ with $v_2 = e_2$, so the correlation is exactly **1** while $\rho = 0.2$.

**A-vs-B contradiction.** The Approach-C callout said "Approach A … is the practical choice when many fixed effects are present" while the rewritten takeaway said to use B and treat A as a fallback. Both A and B run unmodified in FE-Poisson (only the first stage differs), so the callout now says so and prefers B.

**Approach C: state it as a bias-variance tradeoff, not a ranking.** Mullahy's multiplicative moments are genuinely *consistent* for this DGP — the omitted `ad`/`female` effects are independent multiplicative heterogeneity, absorbed by the intercept ($\beta_0 \to \beta_0 + \log E[e^c]$) — verified at $n=10^6$: 0.8015, sd 0.0013. **But consistency is not accuracy at a given $n$.** At the chapter's own $n=5000$ over 10 seeds: A mean 0.8323 / sd 0.0236 / RMSE 0.0393; B 0.8185 / 0.0262 / 0.0310; C 0.7985 / 0.0679 / 0.0645. C is nearly unbiased and yet has the **worst RMSE**, being ~3× noisier without the fixed effects. My first draft of this fix said "prefer Approach C" and had to be corrected — the rendered output refuted it. Its own comparison table shows the Mullahy version at 0.7260 — *worse* than A (0.8128) and B (0.7636) — so the paragraph now explains explicitly why the table can look like it contradicts the consistency claim.

## Deep read (2026-07-30) — reusable gotchas

Full-depth pass over all 25 topics, paired against the R companion. Log:
`~/projects/books/_review3/deepread_causal_books.md`.

### Displaying results: never `println` a `CoefTable`

StatsBase defines **only** `show(io, ::MIME"text/plain", ::CoefTable)`. So
`println(coeftable(fit))` falls through to the generic struct show and prints
`CoefTable(Any[[0.997, 2.110, ...], ...])` into the page. Use `display(coeftable(fit))`,
or let the table be the cell's last expression.

The same applies to any wrapper holding a `CoefTable`. A bare
`mod = etwfe(...)` or `mod = feols(...)` as a cell's last expression renders
`ETWFEResult(Panelest Model: ... CoefTable(Any[[...]]))`. End such lines with `;`
and show the table explicitly (`show_regression_html(mod.model)`).

And end any line producing a long vector with `;` — `sw_trim = min.(sw, q)` once
dumped all 5000 weights into `g-methods.html`.

Sweep before committing:
```bash
grep -l 'CoefTable(Any\[' _book/*.html ; grep -l 'element Vector{' _book/*.html
```

### `crossfit`: use the package default of 5, never 2

`AIPW(crossfit = 2)` fits each nuisance on half the sample and inflates the point
estimate *and* the influence-function SE together. On NHEFS: 3.866 (SE 1.331) at
2 folds, 3.452 (0.748) at 5, 3.312 (0.737) at 10, against the R companion's
full-sample parametric 3.293 (0.498). `nonparametric.qmd` tells the reader the book
uses `crossfit=5`, so 2 also contradicts the book's own stated convention.

### Any score used to rank observations must be out of fold

`rf_fit_predict(X, y, X)` trains and predicts on the same rows. Ranking on such a
score and then averaging the same pseudo-outcome inside the resulting bins made the
GATES table report quintile ATTs of -1.204 and 5.271 for a DGP where
`tau(x) = 1 + 2X1` is confined to `[1, 3]`. Out-of-fold ranking puts every bin
within 0.06 of its true bin mean.

**Still open:** all five meta-learners in `heterogeneous-effects.qmd` are *evaluated*
with in-sample predictions (`rf_fit_predict(X, ..., X)`). That is why this book
reports the DR-learner at 0.433 where the R companion reports 0.931. Converting them
to out-of-fold changes every number in that section.

### Pull coefficients by name, not by position

`coef(lm(@formula(Y ~ D + X1 + X2), df))[end]` is **X2's** coefficient. That line
was reporting X2 as the adjusted treatment effect in `sensitivity-analysis.qmd`, and
went unnoticed for four review passes because the DGP's coefficients put the wrong
number in a plausible range. Use
`coef(m)[findfirst(==(name), coefnames(m))]`.

### Sanity-check against the estimand's possible range

Two of the largest errors this pass were caught by asking "can the estimand even
take this value?" — a negative GATES bin for a `tau` confined to `[1,3]`, and a
mediation SE of 0.76 for a contrast of probabilities. Do this before reading
standard errors.

### Package bugs found via this book (both fixed upstream)

- `CausalEstimate.jl` AIPW ATT normalised the augmentation term by `P(A=0)` instead
  of `P(A=1)`, inflating the SE by `P(A=1)/P(A=0)`.
- `Crumble.jl` reported the influence curve's standard *deviation* as the standard
  error (missing `/sqrt(n)`, ~31.6x at n=1000).

Two `Crumble.jl` issues remain open and are flagged in a `callout-warning` in
`mediation.qmd`: contrast SEs combine as `sqrt(se_a^2 + se_b^2)` (ignoring
covariance between estimators on the same sample), and `calc_estimates_rt` accepts
the randomized influence curves then never uses them, so `effect="RT"` does not
return a recanting-twins decomposition.
