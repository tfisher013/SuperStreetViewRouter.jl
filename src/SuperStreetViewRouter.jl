module SuperStreetViewRouter

using DataStructures
using Graphs, SimpleValueGraphs
using HashCode2014
using Statistics

export benchmark_random_walk_solutions
export get_possible_streets, get_total_city_cost, get_total_city_length, solve_graph_greedy
export create_input_graph

include("functions.jl")
include("graphs.jl")
include("solver.jl")
include("util.jl")
end
