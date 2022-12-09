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

"""
    CityGraph(data::CityData, graph::ValOutDiGraph)

A graph representation of a City object. The graph is a SimpleValueGraphs.jl ValOutDiGraph, and the data is a CityData object.
"""
struct CityGraph{T<:SimpleValueGraphs.AbstractValGraph}
    data::CityData
    graph::T
end

"""

    create_input_graph(city::City)

Returns a `CityGraph` which contains a `CityData` object with key city information and a `SimpleValueGraphs`
which contains juction and street relations.
"""
function create_input_graph(city::City)
    # Each node only stores outgoing edges -> heavily reduced memory
    # but DO NOT access incoming edges
    city_graph = ValOutDiGraph(
        length(city.junctions);
        vertexval_types=(Int64,),
        vertexval_init=v -> (v,),
        edgeval_types=(StreetData,),
    )
    city_data = CityData(city)

    for (i, s) in enumerate(city.streets)
        A = s.endpointA
        B = s.endpointB
        sdata = StreetData(s, i)

        #* Define edges
        t = add_edge!(city_graph, A, B, (sdata,))
        if s.bidirectional
            t = add_edge!(city_graph, B, A, (sdata,))
        end
    end

    return CityGraph(city_data, city_graph)
end
