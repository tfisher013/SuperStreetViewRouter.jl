struct CityData
    total_duration::Int # Total time available for car itineraries (seconds)
    nb_cars::Int # number of cars in the fleed
    starting_junction::Int # Index of junction where all cars initially located
    CityData(c::City) = new(c.total_duration, c.nb_cars, c.starting_junction)
end

struct CityGraph
    data::CityData
    graph::ValOutDiGraph
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

"""

    StreetData(duration::Int, distance::Int)

Structure storing the data required for greedy algorithm in edges of city graph
"""
struct StreetData
    duration::Int # time cost of traversing the street (seconds)
    value::Float64 # distance/duration -> maximise this
    id::Int # index of street in city.streets

    StreetData(duration::Int, distance::Int, i::Int) = new(duration, distance / duration, i)
    StreetData(s::Street, i::Int) = new(s.duration, s.distance / s.duration, i)
end

# function get_neighbor_labels(graph, index)
#     # return label_for.(graph, neighbors(graph, code_for(graph, index)))
#     return Tuple(label_for(graph, s) for s in neighbors(graph, code_for(graph, index)))
# end

# function n_cars(city_graph)
#     return city_graph.graph_data.nb_cars
# end

# function total_time(city_graph)
#     return city_graph.graph_data.total_duration
# end

# function starting_junction(city_graph)
#     return city_graph.graph_data.starting_junction
# end
