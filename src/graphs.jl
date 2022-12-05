"""
    CityData(total_duration::Int, nb_cars::Int, starting_junction::Int)

A struct that holds the metadata for a city. Has constructor(s)

    CityData(c::City)
"""
struct CityData
    total_duration::Int # Total time available for car itineraries (seconds)
    nb_cars::Int # number of cars in the fleed
    starting_junction::Int # Index of junction where all cars initially located
    CityData(c::City) = new(c.total_duration, c.nb_cars, c.starting_junction)
end

"""

    StreetData(duration::Int, value::Int, id::Int)

Structure storing the data required for greedy algorithm in edges of city graph. Has constructors
    
    StreetData(street::Street)
    StreetData(street::Street, id::Int)

"""
struct StreetData
    duration::Int # time cost of traversing the street (seconds)
    value::Float64 # distance/duration -> maximise this
    id::Int # index of street in city.streets

    StreetData(duration::Int, distance::Int, i::Int) = new(duration, distance / duration, i)
    StreetData(s::Street, i::Int) = new(s.duration, s.distance / s.duration, i)
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

Returns a SimpleWeightedDiGraph representing the provided City object in a directed graph. 
Graph vertices are Junction indices (as stored in the City object) and edges are weighted by
street lengths.
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

function create_subgraphs(city_meta_graph, time, edgeLength)
    # subgraphs = Vector{Tuple{Int64,StreetData}}(undef, 0)

    city_data = city_meta_graph.data
    city_graph = city_meta_graph.graph

    source = city_data.starting_junction
    paths = get_possible_streets(city_graph, source, time)
    target = last(paths)[2].id

    # print(typeof(city_graph))
    # capacity_matrix = get_capacity_matrix(

    solution = mincut(city_graph)
    return solution
end
