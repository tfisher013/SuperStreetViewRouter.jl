"""

    create_input_graph(city::City)

Returns a SimpleWeightedDiGraph representing the provided City object. Graph
vertices are Junction indices (as stored in the City object) and edges are
street lengths.
"""
function create_input_graph(city::City)
    city_graph = MetaGraph(
        DiGraph();
        Label=Symbol,
        # Label=Int,
        # EdgeData=StreetData,
        EdgeData=Street,
        VertexData=Nothing,
        graph_data=CityData(
            city.total_duration,
            city.nb_cars,
            Symbol(city.starting_junction),
            # city.total_duration, city.nb_cars, city.starting_junction
        ),
    )

    for s in city.streets
        #* Turn to symbols for graph labels
        A = Symbol(s.endpointA)
        B = Symbol(s.endpointB)

        #* Create vertices
        city_graph[A] = nothing
        city_graph[B] = nothing

        #* Define edges
        city_graph[A, B] = s
        if s.bidirectional
            city_graph[B, A] = s
        end
    end

    # for s in city.streets
    #     v = s.distance / s.duration
    #     A = Symbol(s.endpointA)
    #     B = Symbol(s.endpointB)
    #     @assert v == city_graph[A, B].value
    # end

    return city_graph
end

# """

#     StreetData(duration::Int, distance::Int)

# Structure storing the data required for greedy algorithm in edges of city graph
# """
# struct StreetData
#     duration::Int # time cost of traversing the street (seconds)
#     distance::Int
#     value::Float64 # distance/duration -> maximise this

#     StreetData(duration::Int, distance::Int) = new(duration, distance / duration)
#     # StreetData(s::Street) = new(s.duration,s.distance / s.duration)
#     StreetData(s::Street) = new(s.duration, s.distance, s.distance / s.duration)
# end

struct CityData
    total_duration::Int # Total time available for car itineraries (seconds)
    nb_cars::Int # number of cars in the fleed
    starting_junction::Symbol # Index of junction where all cars initially located
end

function get_neighbor_labels(graph, index)
    # return label_for.(graph, neighbors(graph, code_for(graph, index)))
    return Tuple(label_for(graph, s) for s in neighbors(graph, code_for(graph, index)))
end

function n_cars(city_graph)
    return city_graph.graph_data.nb_cars
end

function total_time(city_graph)
    return city_graph.graph_data.total_duration
end

function starting_junction(city_graph)
    return city_graph.graph_data.starting_junction
end