module SuperStreetViewRouter
using Graphs
using HashCode2014
using SimpleWeightedGraphs
using Statistics

export benchmark_random_walk_solutions
export create_input_graph

include("functions.jl")
include("graphs.jl")
end
