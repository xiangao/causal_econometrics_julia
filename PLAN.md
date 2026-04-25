# Causal Econometrics with Julia — Rewrite Plan

This is the historical rewrite plan for the book. The current book now includes the DiD, IV/RDD, mediation, and package-ecosystem chapters; consult `_quarto.yml` and `README.md` for the active chapter list.

## Book Structure (7 chapters — ML chapter skipped)

| Part | Chapter | R Original | Julia Strategy |
|------|---------|------------|----------------|
| Foundations | identification | ggplot2, ggdag | Makie.jl + GraphMakie.jl |
| Foundations | estimation | npcausal, fixest, SuperLearner, sandwich, lmtest | NPCausal.jl (yours), Panelest.jl (yours), MLJ.jl |
| ~~Methods~~ | ~~machine-learning~~ | ~~glmnet, rpart, grf~~ | ~~SKIPPED~~ |
| Methods | nonparametric | npcausal, SuperLearner, tmle, DoubleML | NPCausal.jl (yours), MLJ.jl stacking, TMLE.jl, **DML via NPCausal** |
| Designs | did | did, etwfe, synthdid, fixest | Panelest.jl (yours), SynthControl.jl, **DiD.jl (to build)** |
| Designs | iv-rdd | sem::tsls, rdrobust, fixest | Panelest.jl (yours) for IV, **RDRobust.jl (to build)** |
| Mediation | mediation | lavaan, medoutcon | **Mediation.jl (to build)** |

---

## Package Mapping: What Exists

### Your packages (ready to use)
- **Panelest.jl** → replaces fixest (feols, fepois, felogit, feprobit + FE)
- **NPCausal.jl** → replaces npcausal (ate, att, ctseff, ivlate, ivbds, ipsi)
- **Engression.jl** → distributional regression (supplementary)
- **Endid.jl** → distributional DiD (supplementary)

### Existing Julia ecosystem packages
- **MLJ.jl + EvoTrees.jl** → replaces SuperLearner ensemble + ranger + xgboost
- **GLMNet.jl** → replaces glmnet (LASSO, Ridge, elastic net via MLJ interface)
- **DecisionTree.jl** → replaces rpart (CART, random forests)
- **TMLE.jl** (TARGENE) → replaces tmle (published JOSS 2025, MLJ-integrated)
- **SynthControl.jl** → replaces synthdid (synthetic control + synthetic DiD)
- **RegressionDiscontinuity.jl** → partial replacement for rdrobust (experimental, limited)
- **Makie.jl + AlgebraOfGraphics.jl** → replaces ggplot2
- **GraphMakie.jl + Graphs.jl** → replaces ggdag
- **DataFrames.jl + DataFramesMeta.jl** → replaces tidyverse/dplyr
- **ReadStatTables.jl** → replaces haven
- **HypothesisTests.jl** → replaces parts of lmtest
- **CovarianceMatrices.jl / Vcov.jl** → replaces sandwich

---

## Packages to Build (3 new packages)

### 1. DiD.jl — Staggered Difference-in-Differences
**Priority: High** (did chapter)
**Scope:**
- `att_gt()` — group-time ATT (Callaway & Sant'Anna 2021)
- `emfx()` — event-study aggregation
- Wooldridge ETWFE via Panelest.jl interaction terms
**Complexity:** Medium — the core is DR estimation per (g,t) cell
**Note:** Your Endid.jl does distributional DiD; this covers standard ATT

### 2. RDRobust.jl — Regression Discontinuity
**Priority: Medium** (iv-rdd chapter)
**Scope:**
- `rdrobust(Y, X; c=0)` — local polynomial RD with bias correction
- `rdplot(Y, X)` — RD visualization
- Sharp and fuzzy designs
- Based on: Calonico, Cattaneo & Titiunik (2014)
**Complexity:** Medium — local polynomial regression, optimal bandwidth selection
**Note:** RegressionDiscontinuity.jl exists but is experimental and limited

### 3. Mediation.jl — Causal Mediation Analysis
**Priority: Medium** (mediation chapter)
**Scope:**
- SEM-based mediation (path analysis) — replaces lavaan for simple models
- Nonparametric mediation with cross-fitting — replaces medoutcon
- Effects: CDE, NDE, NIE, interventional direct/indirect
- One-step and TMLE estimators
**Complexity:** Medium-High

---

## Chapter-by-Chapter Translation Plan

### Chapter 1: Identification (identification.qmd)
- **DAGs**: Use Graphs.jl + GraphMakie.jl to draw DAGs
- **Plots**: Makie.jl
- **Minimal code changes** — mostly conceptual chapter

### Chapter 2: Estimation (estimation.qmd)
- **RA/IPW/AIPW**: Implement manually in Julia (educational, ~50 lines each)
- **npcausal ate/att**: → NPCausal.jl `ate()`, `att()`
- **fixest feols**: → Panelest.jl `feols()`
- **SuperLearner**: → MLJ.jl with `Stack()` for ensemble
- **sandwich/lmtest**: → Vcov.jl clustered SE via Panelest.jl
- **grf regression_forest**: → GRF.jl or DecisionTree.jl random forest
- **glmnet**: → GLMNet.jl via MLJ
- **Data**: ReadStatTables.jl for .dta files

### ~~Chapter 3: Machine Learning (machine-learning.qmd) — SKIPPED~~

### Chapter 3: Nonparametric (nonparametric.qmd)
- **SuperLearner**: → MLJ.jl `Stack()` with EvoTrees, GLMNet learners
- **npcausal ate/att**: → NPCausal.jl
- **tmle**: → TMLE.jl (TARGENE package, JOSS 2025)
- **DoubleML**: → NPCausal.jl ate() already does DML2 cross-fitting; or implement DoubleMLPLR manually (~30 lines with MLJ)

### Chapter 4: Difference-in-Differences (did.qmd)
- **fixest feols**: → Panelest.jl `feols()` for TWFE
- **did att_gt**: → DiD.jl `att_gt()` (to build)
- **etwfe**: → Panelest.jl with cohort×time interactions (Wooldridge approach)
- **synthdid**: → SynthControl.jl `SyntheticDiD`
- **Data**: ReadStatTables.jl for .dta, CSV.jl for .csv

### Chapter 5: IV & RDD (iv-rdd.qmd)
- **sem::tsls**: → Panelest.jl `feols()` with IV syntax, or manual 2SLS (~10 lines)
- **fixest feols with IV**: → Panelest.jl (needs IV support added, or manual)
- **rdrobust**: → RDRobust.jl (to build)
- **rdplot**: → RDRobust.jl + Makie.jl
- **MASS::mvrnorm**: → Distributions.jl `MvNormal`

### Chapter 6: Mediation (mediation.qmd)
- **lavaan sem()**: → Mediation.jl path analysis (to build)
- **medoutcon**: → Mediation.jl nonparametric mediation (to build)
- **data.table**: → DataFrames.jl

---

## Implementation Order

### Phase 1: Quick wins — rewrite chapters using existing packages
1. **identification.qmd** — Graphs.jl + GraphMakie.jl (no new packages needed)
2. **estimation.qmd** — NPCausal.jl + Panelest.jl + MLJ.jl (all exist)
3. **nonparametric.qmd** — NPCausal.jl + TMLE.jl + MLJ.jl (all exist)

### Phase 2: Build missing packages + complete chapters
4. **DiD.jl** — build package (Callaway & Sant'Anna 2021)
5. **did.qmd** — DiD.jl + SynthControl.jl + Panelest.jl
6. **RDRobust.jl** — build package (Calonico, Cattaneo & Titiunik 2014)
7. **iv-rdd.qmd** — Panelest.jl + RDRobust.jl

### Phase 3: Mediation (most complex new package)
8. **Mediation.jl** — build package
9. **mediation.qmd** — rewrite chapter

---

## Decision: IV Support in Panelest.jl

The book uses `fixest::feols()` with IV syntax:
```r
feols(Y ~ X1 | FE1 + FE2 | endogenous ~ instrument, data=df)
```

Panelest.jl currently does NOT support IV. Options:
- **A)** Add IV to Panelest.jl (2SLS with FE absorption)
- **B)** Implement 2SLS manually in the book (~15 lines)
- **C)** Both: manual for pedagogy, Panelest.jl for convenience

Recommendation: **C** — manual 2SLS for the IV chapter (educational), add IV to Panelest.jl later.

---

## Quarto Setup

```yaml
# _quarto.yml
project:
  type: book

book:
  title: "Causal Econometrics with Julia"
  chapters:
    - index.qmd
    - part: "Foundations"
      chapters:
        - identification.qmd
        - estimation.qmd
    - part: "Methods"
      chapters:
        - nonparametric.qmd
    - part: "Designs"
      chapters:
        - did.qmd
        - iv-rdd.qmd
    - part: "Mediation"
      chapters:
        - mediation.qmd

execute:
  freeze: auto

jupyter: julia-1.12
```

Use Quarto with IJulia kernel. Each chapter is a .qmd with Julia code blocks.
