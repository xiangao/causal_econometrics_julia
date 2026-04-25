# Run this once to build the sysimage:
#   julia --project=. build_sysimage.jl
#
# Then re-renders will use the fast kernel "Julia (book)" instead of cold-starting.

import Pkg
Pkg.add("PackageCompiler")

using PackageCompiler

# Only list packages explicitly in Project.toml (stdlibs like Random/Statistics/LinearAlgebra are included automatically)
packages = [
    :CairoMakie, :GraphMakie, :Graphs,
    :GLM, :DataFrames, :DataFramesMeta, :StatsModels,
    :Distributions, :StatsFuns, :StatsBase,
    :CSV, :ReadStatTables, :StatsAPI, :Vcov, :GeometryBasics,
    :MLJ, :MLJLinearModels, :MLJDecisionTreeInterface, :DecisionTree,
    :EvoTrees, :GLMNet, :RegressionTables,
    :NPCausal, :Panelest, :DiD, :SynthDiD, :RDRobust, :TMLE,
    :Lavaan, :Crumble,
]

println("Building sysimage — this takes ~15–25 minutes the first time...")
create_sysimage(
    packages;
    sysimage_path    = "book_sysimage.so",
    precompile_execution_file = "precompile_script.jl",
)
println("Done. Installing fast IJulia kernel...")

import IJulia
sysimage_path = joinpath(@__DIR__, "book_sysimage.so")
project_path  = @__DIR__
IJulia.installkernel(
    "Julia (book)",
    "--sysimage=$(sysimage_path)",
    "--project=$(project_path)",
)
println("""
Kernel installed.
For fast renders, update _quarto.yml to use:  jupyter: julia-_book_-1.12
Then `quarto render` will be much faster.
""")
