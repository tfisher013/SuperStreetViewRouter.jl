module SuperStreetViewRouter

using DataStructures
using Graphs, SimpleValueGraphs
using HashCode2014
using Statistics

export CityProblem, solve
export check_solution_feasibility,
    get_possible_streets,
    get_possible_paths,
    get_solution_distance,
    find_best_path,
    get_total_city_cost,
    get_total_city_length

include("graphs.jl")
include("penalty.jl")
include("problem.jl")
include("solver.jl")
include("util.jl")
end
