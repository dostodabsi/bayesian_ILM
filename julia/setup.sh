#!/bin/bash

# install Julia from here: http://julialang.org/downloads/
# important:
# -- IJulia => enhanced interactive REPL, also notebook
# -- Distributions, StatsBase => exactly what it says
# -- PyPlot, Gadfly => plotting
# -- PyCall => call python code via the @pyimports macro
# -- DataFrames, DataArrays, RDatasets => R stuff;

julia -e 'Pkg.init(); Pkg.add("IJulia"); Pkg.add("Distributions");
          Pkg.add("PyCall"); Pkg.add("StatsBase"); Pkg.add("PyPlot"); Pkg.add("Gadfly");
          Pkg.add("DataFrames"); Pkg.add("DataArrays"); Pkg.add("RDatasets"); Pkg.update()'

# some ressources:
# great docs: http://docs.julialang.org/en/release-0.3/
# short manual: http://bogumilkaminski.pl/files/julia_express.pdf
# https://github.com/chrisvoncsefalvay/learn-julia-the-hard-way
# https://en.wikibooks.org/wiki/Introducing_Julia
# http://quant-econ.net/jl/index.html
