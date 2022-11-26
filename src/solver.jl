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
    traversed_streets = DefaultDict(0)

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
            selected_street = find_best_street(
                possible_streets, traversed_streets, elapsed_street_penalty
            )
            end_junction = HashCode2014.get_street_end(current_junction, selected_street)

            # update traversed streets
            traversed_streets[selected_street] += 1

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

"""
function get_possible_streets(city_graph, current_junction, remaining_time)
    possible_streets = Vector{Street}(undef, 0)
    for s in outedgevals(city_graph, current_junction)
        if remaining_time - s.duration >= 0.0
            push!(possible_streets, s)
        end
    end

    return possible_streets
end

"""

    find_best_street(possible_streets)

"""
function find_best_street(possible_streets, traversed_streets, elapsed_street_penalty)
    max_street_value = -1.0

    # This will always be overwritten
    best_street = first(possible_streets)
    for s in possible_streets
        street_value =
            s.distance / s.duration * elapsed_street_penalty^get(traversed_streets, s, 0)

        if street_value > max_street_value
            best_street = s
            max_street_value = street_value
        end
    end

    return best_street
end