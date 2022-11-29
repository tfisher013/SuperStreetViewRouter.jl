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
