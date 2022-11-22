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

function solve_graph_greedy(city_graph; elapsed_street_penalty=0.1)

    solution = Vector{Vector{Int}}(undef, city_graph.graph_data.nb_cars)
    traversed_streets = DefaultDict(0)

    for i in 1:(n_cars(city_graph))
        remaining_time = total_time(city_graph)
        current_junction = starting_junction(city_graph)

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
            traversed_streets[selected_street] += 1

            push!(itinerary, end_junction)
            remaining_time -= selected_street.duration
            current_junction = end_junction
        end

        solution[i] = @. parse(Int, String(itinerary))
    end

    return Solution(solution)
end

"""

    get_possible_streets(city_graph)

"""
function get_possible_streets(city_graph, current_junction, remaining_time)
    possible_streets = Vector{Tuple{Symbol, Street}}(undef, 0)
    # possible_streets = Vector{Tuple{Symbol,Street}}(undef, 0)
    for neighbor in get_neighbor_labels(city_graph, current_junction)
        outgoing_street = city_graph[current_junction, neighbor]

        if remaining_time - outgoing_street.duration >= 0.0
            push!(possible_streets, (neighbor, outgoing_street))
        end
    end

    return possible_streets
end

"""

    find_best_street(possible_streets)

"""
function find_best_street(possible_streets, traversed_streets, elapsed_street_penalty)
    max_street_value = -1.0
    max_street_value_index = 0
    for i in eachindex(possible_streets)
        street = possible_streets[i][2]
        street_value = street.distance / street.duration

        street_value *= elapsed_street_penalty^get(traversed_streets, street, 0)

        if street_value > max_street_value
            max_street_value = street_value
            max_street_value_index = i
        end
    end

    return possible_streets[max_street_value_index]
end