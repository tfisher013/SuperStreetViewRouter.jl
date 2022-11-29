"""

    get_city_street(city::City, start_junction::Int64, end_junction::Int64) 

Returns a Street object in the provided City that allows travel from the provided start
junction index to the provided end junction index whether one-directional or bi-directional. 
Returns nothing if no such Street is found.
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
