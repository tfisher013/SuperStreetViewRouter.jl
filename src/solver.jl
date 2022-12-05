"""

    solve_graph_greedy(city::City=read_city())

Generates a greedy solution to the provided city, or uses the default
city if none is provided. The greedy algorithm can be described as follows:
    - At each junction, the car will choose to traverse the street with the
    highest "value" = length / time.
    - Traversed streets will be recorded.
    - Traversed streets will have their length decreased by a constant factor
    to discourage but allow usage. This constant is likely responsive to
    optimization.

Inefficient due to only routing a single path at a time. Implementing a
shared list of traversed streets and dedicating a separate thread to each path
would likely improve performance.
"""
function solve_graph_greedy(city::City=read_city(); elapsed_street_penalty=0.1)
    city_graph = create_input_graph(city)
    return solve_graph_greedy(city_graph; elapsed_street_penalty=elapsed_street_penalty)
end

function solve_graph_greedy(city_meta_graph; elapsed_street_penalty=0.1)
    city_data = city_meta_graph.data
    city_graph = city_meta_graph.graph

    solution = Vector{Vector{Int}}(undef, city_data.nb_cars)
    traversed_streets = DefaultDict{Int,Int}(0)

    for i in 1:(city_data.nb_cars)
        remaining_time = city_data.total_duration
        current_junction = city_data.starting_junction

        itinerary = Vector{typeof(current_junction)}(undef, 1)
        itinerary[1] = current_junction

        while remaining_time > 0.0

            # identify all valid streets available to traverse
            possible_streets = get_possible_streets(
                city_graph, current_junction, remaining_time
            )

            if length(possible_streets) == 0
                # this could happen if we can't traverse any outgoing street with our remaining time
                break
            end

            # choose the best street to take
            end_junction, selected_street = find_best_street(
                possible_streets, traversed_streets, elapsed_street_penalty
            )

            # update traversed streets
            traversed_streets[selected_street.id] += 1

            push!(itinerary, end_junction)
            remaining_time -= selected_street.duration
            current_junction = end_junction
        end

        solution[i] = itinerary
    end

    return Solution(solution)
end

"""

    get_possible_streets(city_graph)

Returns a list of all streets that can be traversed from the provided junction.
The streets are tuples of (end_junction, street_data)
"""
function get_possible_streets(city_graph, current_junction, remaining_time)
    possible_streets = Vector{Tuple{Int64,StreetData}}(undef, 0)

    for n in outneighbors(city_graph, current_junction)
        s = get_edgeval(city_graph, current_junction, n, 1)
        if remaining_time - s.duration >= 0.0
            push!(possible_streets, (n, s))
        end
    end

    return possible_streets
end

"""

    find_best_street(possible_streets)

Returns the best street to traverse from the provided list of possible streets. The best street is the one with the highest value,
or the one with the highest value * elapsed_street_penalty ^ times traversed if it has been traversed before.
"""
function find_best_street(possible_streets, traversed_streets, elapsed_street_penalty)
    max_street_value = -1.0

    # This will always be overwritten
    end_point, best_street = first(possible_streets)
    for i in eachindex(possible_streets)
        s = possible_streets[i][2]
        street_value = s.value * elapsed_street_penalty^get(traversed_streets, s.id, 0)

        if street_value > max_street_value
            best_street = s
            end_point = possible_streets[i][1]
            max_street_value = street_value
        end
    end

    return (end_point, best_street)
end

"""
        get_possible_paths(city_graph, current_junction, remaining_time, depth)
returns list of tuples of (path_value, path) where path is a list of junctions and path_value is the value of the path
"""
function get_possible_paths(city_graph, current_junction, remaining_time, depth)
    possible_paths = [
        [i] for i in get_possible_streets(city_graph, current_junction, remaining_time)
    ]
    final_paths = []
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