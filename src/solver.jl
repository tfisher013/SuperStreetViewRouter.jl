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
    solution = Vector{Vector{Int}}(undef, city.nb_cars)
    elapsed_street_penalty = 0.5

    if isnothing(city)
        city = read_city()
    end

    city_graph = create_input_graph(city)
    traversed_streets = Set()

    for i in 1:(city.nb_cars)
        println("Car ", i, " is pathing")

        elapsed_time = city.total_duration
        current_junction = city.starting_junction

        itinerary = Vector{Int64}(undef, 1)
        itinerary[1] = current_junction

        while elapsed_time > 0

            # identify all valid streets available to traverse
            possible_streets = Street[]
            for neighbor in neighbors(city_graph, current_junction)
                outgoing_street = get_city_street(city, current_junction, neighbor)
                if elapsed_time + outgoing_street.duration <= city.total_duration
                    push!(possible_streets, outgoing_street)
                end
            end

            if length(possible_streets) == 0
                # this could happen if we don't have enough time to traverse
                # any street with our remaining time
                break
            end

            # choose the best street to take
            max_street_value = -1
            max_street_value_index = 1
            for i in 1:length(possible_streets)
                street = possible_streets[i]
                street_value = street.distance / street.duration

                if street in traversed_streets
                    street_value *= elapsed_street_penalty
                end

                if street_value > max_street_value
                    max_street_value = street_value
                    max_street_value_index = i
                end
            end
            selected_street = possible_streets[max_street_value_index]

            # update traversed streets (if applicable)
            if selected_street ∉ traversed_streets
                push!(traversed_streets, selected_street)
            end

            # update itinerary and elapsed time
            push!(itinerary, selected_street.endpointB)
            elapsed_time -= selected_street.duration
        end

        push!(solution, itinerary)
    end

    return Solution(solution)
end