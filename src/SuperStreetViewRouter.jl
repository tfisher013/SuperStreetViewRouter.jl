module SuperStreetViewRouter

using DataStructures
using Graphs, SimpleValueGraphs
using HashCode2014
using Statistics

export check_solution_feasibility,
    get_possible_streets,
    get_possible_paths,
    get_solution_distance,
    find_best_path,
    get_total_city_cost,
    get_total_city_length,
    solve_graph_greedy
export create_input_graph

include("graphs.jl")
include("solver.jl")
include("util.jl")
end
