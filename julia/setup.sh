#!/bin/bash

# you need to install Julia from here: http://julialang.org/downloads/
# and JAGS from here: http://mcmc-jags.sourceforge.net/

# when you've done that, you can install important Julia packages:

# important:
# -- IJulia => enhanced interactive REPL, also notebook
# -- Distributions, StatsBase => exactly what it says
# -- Jags, Mamba, Lora => MCMC sampling (maybe Lora suffices?)
# -- PyPlot, Gadfly => plotting
# -- PyCall => call python code via the @pyimports macro

# not really important, but cool:
# -- DataFrames, DataArrays, RDatasets => R stuff;

# might take a while ...
julia -e 'Pkg.init(); Pkg.add("IJulia"); Pkg.add("Distributions"); Pkg.add("Jags");
          Pkg.add("Lora"); Pkg.add("Mamba"); Pkg.add("PyCall"); Pkg.add("StatsBase");
          Pkg.add("PyPlot"); Pkg.add("Gadfly"); Pkg.add("DataFrames");
          Pkg.add("DataArrays"); Pkg.add("RDatasets"); Pkg.update()'

# you need to set JAGS_HOME and JULIA_SVG_BROWSER in ~/.juliarc.jl
echo 'JAGS_HOME = "/usr/lib/JAGS"' >> ~/.juliarc.jl
echo 'JULIA_SVG_BROWSER = "google-chrome"' >> ~/.juliarc.jl # you might want to change that
