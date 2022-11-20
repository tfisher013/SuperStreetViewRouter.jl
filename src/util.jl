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