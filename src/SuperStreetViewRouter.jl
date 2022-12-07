module SuperStreetViewRouter
using Graphs, SimpleValueGraphs

using HashCode2014
using Statistics

using DataStructures

export benchmark_random_walk_solutions
export get_total_city_cost, get_total_city_length
export solve_graph_greedy, create_input_graph
export create_subgraphs, practice_subgraph, practice_subgraph_matrix

include("functions.jl")
include("graphs.jl")
include("solver.jl")
include("util.jl")
include("subgraphs.jl")
end
