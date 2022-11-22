module SuperStreetViewRouter
using Graphs
using MetaGraphsNext

using HashCode2014
using Statistics

using DataStructures

export benchmark_random_walk_solutions
export get_total_city_cost, get_total_city_length, generate_output_file
export solve_graph_greedy

include("functions.jl")
include("graphs.jl")
include("solver.jl")
include("util.jl")
end
