"""
    create_subgraphs(city_meta_graph)

"""
# function create_subgraphs(city_meta_graph, edgeLength::Integer)
#     # subgraphs = Vector{Tuple{Int64,StreetData}}(undef, 0)

#     city_data = city_meta_graph.data
#     city_graph = city_meta_graph.graph

#     source = city_data.starting_junction

#     bfs = bfs_tree(g, source)

#     for i in bfs
#         print(i)
#     end

#     # target = city_data.

#     solution = mincut(city_graph::lg.IsDirected, source::Integer, target::Integer, capacity_matrix::AbstractMatrix, algorithm::AbstractFlowAlgorithm)
#     return solution
# end