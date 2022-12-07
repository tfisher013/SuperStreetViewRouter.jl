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

    StreetData(duration::Real, value::Real, id::Int)

Structure storing the data required for greedy algorithm in edges of city graph. Has constructors
    
    StreetData(street::Street)
    StreetData(street::Street, id::Int)

"""
struct StreetData{D<:Real,V<:Real} <: Real
    duration::D # time cost of traversing the street (seconds)
    value::V # distance/duration -> maximise this
    id::Int # index of street in city.streets
end

function StreetData(s::Street, i::Int)
    return StreetData{Int,Float64}(s.duration, s.distance / s.duration, i)
end
StreetData(v::T) where {T<:Real} = StreetData(0, v, 0)

Base.:+(x::StreetData, y::StreetData) = StreetData(x.duration, x.value + y.value, x.id)
Base.:-(x::StreetData, y::StreetData) = StreetData(x.duration, x.value - y.value, x.id)
Base.:*(x::StreetData, y::StreetData) = StreetData(x.duration, x.value * y.value, x.id)
Base.:/(x::StreetData, y::StreetData) = StreetData(x.duration, x.value / y.value, x.id)

Base.:<(x::StreetData, y::StreetData) = x.value < y.value
Base.:^(x::StreetData, y::StreetData) = StreetData(x.duration, x.value^y.value, x.id)
Base.zero(::Type{StreetData}) = StreetData(0, 0.0, 0)
Base.typemax(::Type{StreetData}) = StreetData(0, typemax(Float64), 0)

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
        # edgeval_types=(Float64,),
        edgeval_types=(s = StreetData, d = Float64),
    )
    city_data = CityData(city)

    for (i, s) in enumerate(city.streets)
        A = s.endpointA
        B = s.endpointB
        sdata = StreetData(s, i)

        #* Define edges
        t = add_edge!(city_graph, A, B, (sdata, sdata.value))
        if s.bidirectional
            t = add_edge!(city_graph, B, A, (sdata, sdata.value))
        end
        # t = add_edge!(city_graph, A, B, (sdata.value,))
        # if s.bidirectional
        #     t = add_edge!(city_graph, B, A, (sdata.value,))
        # end
    end

    return CityGraph(city_data, city_graph)
end

function create_subgraphs(city::City)
    city_meta_graph = create_input_graph(city)
    city_data = city_meta_graph.data
    city_graph = city_meta_graph.graph

    # source = city_data.starting_junction
    # paths = get_possible_streets(city_graph, source, time)
    # target = last(paths)[2].id

    capacity_matrix = ValMatrix(city_graph, :d, 0.0)
    parity, bestcut = mincut(city_graph, capacity_matrix)
    # parity, bestcut = mincut(city_graph)
    karger_parity = karger_min_cut(city_graph)

    subgraph1 = Vector{Int8}()
    subgraph2 = Vector{Int8}()
    for p in parity
        if p == 1
            append!(subgraph1, p)
        elseif p == 2
            append!(subgraph2, p)
        end
    end

    println(length(subgraph1))
    println(length(subgraph2))

    return parity
end

function practice_subgraph_matrix()
    g = ValGraph(4, edgeval_types = (a = Int, b = String))
    add_edge!(g, 1, 2, (a=10, b="abc"))
    add_edge!(g, 1, 3, (a=20, b="xyz"))
    add_edge!(g, 2, 4, (a=10, b="xyz"))
    capacity_matrix = ValMatrix(g, :a, 0)
    print(capacity_matrix)
    return mincut(g, capacity_matrix)
end

function practice_subgraph()
    g = ValGraph(4, edgeval_types=(Int,));
    add_edge!(g, 1, 2, (10,))
    add_edge!(g, 1, 3, (20,))
    add_edge!(g, 2, 4, (10,))
    return mincut(g)
end