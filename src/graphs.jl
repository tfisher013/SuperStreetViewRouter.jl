"""

    create_input_graph(city::City)

Returns a SimpleWeightedDiGraph representing the provided City object in a directed graph. 
Graph vertices are Junction indices (as stored in the City object) and edges are weighted by
street lengths.
"""
function create_input_graph(city::City)
    num_vertices = length(city.junctions)
    graph = SimpleWeightedDiGraph(num_vertices)

    for street in city.streets
        add_edge!(graph, street.endpointA, street.endpointB, street.distance)

        if street.bidirectional
            add_edge!(graph, street.endpointB, street.endpointA, street.distance)
        end
    end

    return graph
end
