"""

    get_total_city_cost(city::City)

Returns the total time (in seconds) required to traverse all streets of the provided city.
"""
function get_total_city_cost(city::City)
    total_cost = 0
    for street in city.streets
        total_cost += street.duration
    end

    return total_cost
end

"""

    get_total_city_length(city::City)

Returns the total length (in meters) of all streets in the provided city.
"""
function get_total_city_length(city::City)
    total_distance = 0
    for street in city.streets
        total_distance += street.distance
    end

    return total_distance
end

"""

    check_solution_feasibility(soln::Solution, city_meta_graph::CityGraph; verbose=false)::Bool


Check if `soln` satisfies the constraints for the instance defined by `city_meta_graph`.
    The following criteria are considered (taken from the problem statement):
    - the number of itineraries has to match the number of cars of `city_meta_graph`
    - the first junction of each itinerary has to be the starting junction of `city_meta_graph`
    - for each consecutive pair of junctions on an itinerary, a street connecting these junctions has to exist in `city_meta_graph` (if the street is one directional, it has to be traversed in the correct direction)
    - the duration of each itinerary has to be lower or equal to the total duration of `city_meta_graph`

Credit to HashCode2014 for such a clear docstring
"""
function check_solution_feasibility(
    soln::Solution, city_meta_graph::CityGraph; verbose=false
)::Bool

    # extract CityData and CityGraph objects
    city_data = city_meta_graph.data
    city_graph = city_meta_graph.graph

    # check that the correct number of itineraries are present in the solution
    nb_cars = length(soln.itineraries)
    if nb_cars != city_data.nb_cars
        verbose && @warn "Incoherent number of cars"
        return false
    end

    for (c, itinerary) in enumerate(soln.itineraries)

        # check that each car itinerary begins at starting juction
        if first(itinerary) != city_data.starting_junction
            verbose && @warn "Itinerary $c has invalid starting junction"
            return false
        end

        duration = 0
        for v in 1:(length(itinerary) - 1)
            # check that each street in itinerary exists
            i, j = itinerary[v], itinerary[v + 1]
            if !has_edge(city_graph, i, j)
                verbose && @warn "Street $i -> $j does not exist"
                return false
            end
        end
        # check that total time elapsed per itinerary is <= alloted time
        if duration > city_data.total_duration
            verbose &&
                @warn "Itinerary $c has duration $duration > $(city_data.total_duration)"
            return false
        end
    end

    return true
end

"""
    get_solution_distance(solution, city_meta_graph)
    
Compute the total distance of all itineraries in `solution` based on the street data from `city`.
Streets visited several times are only counted once.
"""
function get_solution_distance(solution::Solution, meta_city_graph::CityGraph)
    total_distance::Int64 = 0
    city_graph = meta_city_graph.graph

    # holds the street id's of visited streets
    visited_streets::Vector{Int64} = []

    for edge in edges(city_graph)
        if get_edgeval(city_graph, src(edge), dst(edge), 1).id ∉ visited_streets
            visited = false
            for itinerary in solution.itineraries
                for v in 1:(length(itinerary) - 1)
                    i, j = itinerary[v], itinerary[v + 1]
                    if has_edge(city_graph, i, j)
                        total_distance += get_edgeval(city_graph, i, j, 1).distance
                        push!(visited_streets, get_edgeval(city_graph, i, j, 1).id)
                        visited = true
                        break
                    end
                end
                if visited
                    break
                end
            end
        end
    end

    return total_distance
end
