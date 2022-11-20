"""

    generate_output_file(solution::Solution, path=nothing)

Creates a text file using the provided Solution object and saves it
to the specified path.
"""
function generate_output_file(solution::Solution, path=nothing)
    if isnothing(path)
        path = pwd() * "/output.txt"
    end

    if !isfile(path)
        touch(path)
    end

    open(path, "w") do f

        # write the number of cars (or paths)
        write(f, string(length(solution.itineraries)))
        write(f, "\n")

        for itinerary in solution.itineraries
            # write the number of junctions in the itinerary before listing the junctions
            write(f, string(length(itinerary)))
            write(f, "\n")

            # list the junctions in the itinerary
            for junction in itinerary
                write(f, string(junction))
                write(f, "\n")
            end
        end
    end
end

"""

    get_city_street(city::City, start_junction::Int64, end_junction::Int64) 

Returns a Street object in the provided city that allows travel from the provided start
junction index to the provided end junction index. Returns nothing if no such Street is found.
"""
function get_city_street(city::City, start_junction::Int64, end_junction::Int64)
    for street in city.streets
        if street.endpointA == start_junction
            if street.endpointB == end_junction
                return street
            end
        end

        if street.bidirectional
            if street.endpointB == start_junction
                if street.endpointA == end_junction
                    return street
                end
            end
        end
    end

    return nothing
end

"""

    get_total_city_cost(city::City)

Returns the total time required to traverse all streets of the provided city in seconds.
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

Returns the total length of all streets in the provided city in meters.
"""
function get_total_city_length(city::City)
    total_distance = 0
    for street in city.streets
        total_distance += street.distance
    end

    return total_distance
end
