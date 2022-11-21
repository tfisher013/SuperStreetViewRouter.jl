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
function solve_graph_greedy() end

function solve_graph_greedy(city_graph)
    elapsed_street_penalty = 0.1

    solution = Vector{Vector{Int}}(undef, city_graph.graph_data.nb_cars)
    traversed_streets = Dict()

    for i in 1:(city_graph.graph_data.nb_cars)
        remaining_time = city_graph.graph_data.total_duration
        current_junction = city_graph.graph_data.starting_junction

        itinerary = Vector{typeof(current_junction)}(undef, 1)
        itinerary[1] = current_junction

        while remaining_time > 0

            # identify all valid streets available to traverse
            possible_streets = Vector{Tuple{Symbol,StreetData}}(undef, 0)
            for neighbor in get_neighbor_labels(city_graph, current_junction)
                outgoing_street = city_graph[current_junction, neighbor]

                if remaining_time - outgoing_street.duration >= 0
                    push!(possible_streets, (neighbor, outgoing_street))
                end
            end

            if length(possible_streets) == 0
                # this could happen if we can't traverse
                # any outgoing street with our remaining time
                break
            end

            # choose the best street to take
            max_street_value = -1
            max_street_value_index = 1
            for i in eachindex(possible_streets)
                street = possible_streets[i][2]
                street_value = street.value

                street_value *= elapsed_street_penalty^get(traversed_streets, street, 0)

                if street_value > max_street_value
                    max_street_value = street_value
                    max_street_value_index = i
                end
            end
            end_junction, selected_street = possible_streets[max_street_value_index]

            # update traversed streets
            if selected_street ∉ keys(traversed_streets)
                traversed_streets[selected_street] = 1
            else
                traversed_streets[selected_street] += 1
            end

            push!(itinerary, end_junction)
            remaining_time -= selected_street.duration
            current_junction = end_junction
        end

        solution[i] = parse.(Int, String.(itinerary))
    end

    return Solution(solution)
end

function solve_graph_greedy(city::City=read_city())
    city_graph = create_input_graph(city)
    return solve_graph_greedy(city_graph)
end