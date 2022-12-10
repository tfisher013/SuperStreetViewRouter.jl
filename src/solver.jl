"""

    solve(prob::CityProblem; depth=5, n_steps=1)

Generates a `Solution` object to the provided `CityProblem``, or uses the default
city if none is provided. The depth parameter specifies the depth of the
performed BFS and n_steps specifices how many steps to traverse the chosen
BFS path per iteration.
"""
function solve(prob::CityProblem; depth=5, n_steps=1)
    city_data = prob.data
    city_graph = prob.graph

    solution = Vector{Vector{Int}}(undef, city_data.nb_cars)

    traversed_streets = DefaultDict{Int,Int}(0)

    for i in 1:(city_data.nb_cars)
        remaining_time = city_data.total_duration
        current_junction = city_data.starting_junction

        itinerary = Vector{typeof(current_junction)}(undef, 1)
        itinerary[1] = current_junction

        while remaining_time > 0.0
            # identify all valid paths available to traverse
            possible_paths = get_possible_paths(
                city_graph, current_junction, remaining_time, depth
            )

            # this could happen if we can't traverse any outgoing street with our remaining time
            if length(possible_paths) == 0
                break
            end

            # choose the best street to take
            path = find_best_path(possible_paths, traversed_streets, prob.penalty_function)

            for j in 1:min(n_steps, length(path))
                end_junction, street = path[j]

                # update traversed streets
                traversed_streets[street.id] += 1
                remaining_time -= street.duration

                append!(itinerary, end_junction)
                current_junction = end_junction
            end
        end

        solution[i] = itinerary
    end

    return Solution(solution)
end

"""

    get_possible_streets(city_graph, current_junction, remaining_time)

Returns a list of all streets that can be traversed from the provided junction.
The streets are tuples of (end_junction, street_data)
"""
function get_possible_streets(city_graph, current_junction, remaining_time)
    n_neighbors = length(outneighbors(city_graph, current_junction))
    possible_streets = Vector{Tuple{Int64,StreetData}}(undef, n_neighbors)

    i = 1
    for n in outneighbors(city_graph, current_junction)
        s = get_edgeval(city_graph, current_junction, n, 1)
        if remaining_time - s.duration >= 0.0
            possible_streets[i] = (n, s)
            i += 1
        end
    end
    deleteat!(possible_streets, i:n_neighbors)

    return possible_streets
end

"""

        get_possible_paths(city_graph, current_junction, remaining_time, depth)

returns list of tuples
"""
function get_possible_paths(city_graph, current_junction, remaining_time, depth)
    possible_paths = [
        [i] for i in get_possible_streets(city_graph, current_junction, remaining_time)
    ]

    #! Path should be a list of junctions
    final_paths = Vector{Vector{Tuple{Int64,StreetData}}}([])
    while length(possible_paths) > 0
        path = pop!(possible_paths)
        if length(path) == depth
            if path_time(path) <= remaining_time
                push!(final_paths, path)
            end
        else
            new_paths = get_possible_streets(city_graph, first(last(path)), remaining_time)
            if length(new_paths) == 0
                push!(final_paths, path)
            else
                for p in new_paths
                    push!(possible_paths, [path..., p])
                end
            end
        end
    end
    return final_paths
end

"""
    path_time(path)

Returns the time it takes to traverse the provided path
"""
function path_time(path)
    return sum(s[2].duration for s in path)
end

"""
    get_path_value(path, traversed_streets, penalty_function)

Returns the value of the provided path, taking into account the number of times each street has been traversed with the provided penalty
"""
function get_path_value(path, traversed_streets, penalty_function)
    path_value = 0.0
    temp_traversed_streets = DefaultDict{Int,Int}(0)

    for street in last.(path)
        v = street.distance / street.duration
        if street.id in keys(traversed_streets)
            v = apply_penalty(v, traversed_streets[street.id], penalty_function)
        end
        if street.id in keys(temp_traversed_streets)
            v = apply_penalty(v, temp_traversed_streets[street.id], penalty_function)
        end

        path_value += v
        temp_traversed_streets[street.id] += 1
    end
    return path_value
end

"""
    find_best_path(possible_paths, traversed_streets, penalty_function)

Returns the best path to traverse from the provided list of possible paths. The best path is the one with the highest value considering the number of times each street has been traversed with the provided penalty
"""
function find_best_path(possible_paths, traversed_streets, penalty_function)
    max_path_value = -1.0
    best_path = first(possible_paths)
    for path in possible_paths
        path_value = get_path_value(path, traversed_streets, penalty_function)

        if path_value > max_path_value
            best_path = path
            max_path_value = path_value
        end
    end
    return best_path
end
