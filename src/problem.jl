struct CityProblem{G<:SimpleValueGraphs.AbstractValGraph,P<:AbstractPenaltyFunction}
    data::CityData
    graph::G
    penalty_function::P
end

function CityProblem(
    city::City=read_city(); penalty_function::AbstractPenaltyFunction=ExponentialPenalty()
)
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

    return CityProblem(city_data, city_graph, penalty_function)
end
