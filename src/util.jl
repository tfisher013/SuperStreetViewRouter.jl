"""

    get_city_street(city::City, start_junction::Int64, end_junction::Int64) 

Returns the Street object in the provided city corresponding to provided start
and end junctions. Returns nothing if no such Street is found.
"""
function get_city_street(city::City, start_junction::Int64, end_junction::Int64)

    for street in city.streets
        if street.endpointA == start_junction
            if street.endpointB == end_junction
                return street
            end
        end
    end

    return nothing
end