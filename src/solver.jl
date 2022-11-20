"""

    solve_graph_greedy(city::City=read_city())

Generates a greedy solution to the provided city, or uses the default
city if none is provided. The greedy algorithm can be described as follows:
    - At each junction, the car will choose to traverse the street with the
    highest "value" = length / time.
    - Traversed streets will be recorded.
    - Traversed streets will have their length decreased by a constant factor
    to discourage but allow usage. This constant is likely a responsive to
    optimization.

Inefficient due to only routing a single path at a time. Implementing a
shared list of traversed streets and dedicating a separate thread to each path
would likely improve performance.
"""
function solve_graph_greedy(city::City=nothing)
    elapsed_street_penalty = 0.5

    if isnothing(city)
        city = read_city()
    end

    solution = Vector{Vector{Int}}(undef, city.nb_cars)
    city_graph = create_input_graph(city)
    traversed_streets = Dict()

    for i in 1:(city.nb_cars)
        remaining_time = city.total_duration
        current_junction = city.starting_junction

        itinerary = Vector{Int64}(undef, 1)
        itinerary[1] = current_junction

        while remaining_time > 0

            # identify all valid streets available to traverse
            possible_streets = Street[]
            for neighbor in neighbors(city_graph, current_junction)
                outgoing_street = get_city_street(city, current_junction, neighbor)
                if !isnothing(outgoing_street)
                    if remaining_time - outgoing_street.duration >= 0
                        push!(possible_streets, outgoing_street)
                    end
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
            for i in 1:lastindex(possible_streets)
                street = possible_streets[i]
                street_value = street.distance / street.duration

                if street in keys(traversed_streets)
                    penalty_factor =
                        elapsed_street_penalty^get(traversed_streets, street, 1)
                    street_value *= penalty_factor
                end

                if street_value > max_street_value
                    max_street_value = street_value
                    max_street_value_index = i
                end
            end
            selected_street = possible_streets[max_street_value_index]

            # update traversed streets
            if selected_street ∉ keys(traversed_streets)
                traversed_streets[selected_street] = 1
            else
                traversed_streets[selected_street] += 1
            end

            # update itinerary and elapsed time
            end_junction = if (current_junction == selected_street.endpointA)
                selected_street.endpointB
            else
                selected_street.endpointA
            end
            push!(itinerary, end_junction)
            remaining_time -= selected_street.duration
            current_junction = end_junction
        end

        solution[i] = itinerary
    end

    return Solution(solution)
end