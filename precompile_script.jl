# Precompile script for PackageCompiler sysimage.
# Exercises all packages used across the book so they are compiled into the sysimage.

using CairoMakie
using GraphMakie
using Graphs
using GLM
using DataFrames
using DataFramesMeta
using StatsModels
using Random
using Distributions
using StatsFuns
using CSV
using ReadStatTables
using StatsAPI
using Vcov
using GeometryBasics
using MLJ
using MLJLinearModels
using MLJDecisionTreeInterface
using DecisionTree
using EvoTrees
using GLMNet
using NPCausal
using Panelest
using DiD
using SynthDiD
using RDRobust
using TMLE
using HypothesisTests
using Lavaan
using Crumble

# ── CairoMakie ──────────────────────────────────────────────────────────────
fig = Figure()
ax = Axis(fig[1, 1], xlabel = "x", ylabel = "y")
lines!(ax, 1:10, rand(10))
fig

# ── GLM ─────────────────────────────────────────────────────────────────────
n = 200
x = randn(n)
y = 1 .+ 2 .* x .+ randn(n)
df = DataFrame(x = x, y = y)
glm(@formula(y ~ x), df, Distributions.Normal(), GLM.IdentityLink())

# ── Lavaan SEM ───────────────────────────────────────────────────────────────
x2 = randn(n)
m  = 0.5 .* x2 .+ randn(n)
y2 = 0.7 .* m .+ 0.3 .* x2 .+ randn(n)
df2 = DataFrame(X = x2, M = m, Y = y2)
model_str = """
  Y ~ a*X + b*M
  M ~ c*X
  bc := b*c
"""
sem(model_str, df2)

# ── Crumble ──────────────────────────────────────────────────────────────────
Random.seed!(1)
n3 = 300
w1 = rand(Bernoulli(0.5), n3)
a3 = rand.(Bernoulli.(StatsFuns.logistic.(w1 .- 0.5)))
m3 = rand.(Bernoulli.(StatsFuns.logistic.(a3 .+ w1 .- 1.0)))
y3 = rand.(Bernoulli.(StatsFuns.logistic.(a3 .+ m3 .+ w1 .- 1.5)))
df3 = DataFrame(W = w1, A = a3, M = m3, Y = y3)
crumble(df3, ["A"];
        outcome   = "Y",
        mediators = ["M"],
        moc       = ["W"],
        covar     = ["W"],
        effect    = "RT",
        learners  = ["glm"],
        control   = crumble_control(crossfit_folds = 2, epochs = 5))

# ── TMLE ─────────────────────────────────────────────────────────────────────
let
    Random.seed!(1)
    n4  = 200
    w4  = randn(n4)
    a4  = rand.(Distributions.Binomial.(1, StatsFuns.logistic.(w4)))
    y4  = rand.(Distributions.Binomial.(1, StatsFuns.logistic.(-1.0 .+ a4 .+ 0.5.*w4)))
    df4 = DataFrame(Y=y4, A=a4, W=w4)
    EvoTreeClassifier = MLJ.@load EvoTreeClassifier pkg=EvoTrees verbosity=0
    Ψ4 = ATE(target=:Y, treatment=(A=(case=1,control=0),), confounders=[:W])
    η4 = NuisanceSpec(EvoTreeClassifier(max_depth=3, nrounds=20),
                      EvoTreeClassifier(max_depth=3, nrounds=20))
    tmle(Ψ4, η4, df4; crossfit=2, verbosity=0)
end

println("Precompile complete.")
