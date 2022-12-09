"""
    CityData(total_duration::Int, nb_cars::Int, starting_junction::Int)

A struct that holds the metadata for a city. Has constructor(s)

    CityData(c::City)
    CityData(total_duration::Int, nb_cars::Int, starting_junction::Int)
"""
struct CityData
    total_duration::Int # Total time available for car itineraries (seconds)
    nb_cars::Int # number of cars in the fleed
    starting_junction::Int # Index of junction where all cars initially located
    CityData(c::City) = new(c.total_duration, c.nb_cars, c.starting_junction)
end

"""

    StreetData(duration::Int, id::Int, distance::Int)

Structure storing the data required for greedy algorithm in edges of city graph. Has constructors
    
    StreetData(street::Street)
    StreetData(street::Street, id::Int)

"""
struct StreetData
    duration::Int # time cost of traversing the street (seconds)
    id::Int # index of street in city.streets
    distance::Int # distance of the street (meters)

    StreetData(duration::Int, distance::Int, i::Int) = new(duration, i, distance)
    StreetData(s::Street, i::Int) = new(s.duration, i, s.distance)
end

function Base.:+(x::StreetData, y::StreetData)
    return StreetData(x.duration + y.duration, x.value + y.value, x.id)
end
function Base.:-(x::StreetData, y::StreetData)
    return StreetData(x.duration - y.duration, x.value - y.value, x.id)
end
function Base.:*(x::StreetData, y::StreetData)
    return StreetData(x.duration * y.duration, x.value * y.value, x.id)
end
function Base.:/(x::StreetData, y::StreetData)
    return StreetData(x.duration / y.duration, x.value / y.value, x.id)
end

Base.:<(x::StreetData, y::StreetData) = x.value < y.value
Base.:^(x::StreetData, y::StreetData) = x.value^y.value
