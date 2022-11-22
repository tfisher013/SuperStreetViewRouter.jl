var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = SuperStreetViewRouter","category":"page"},{"location":"#SuperStreetViewRouter","page":"Home","title":"SuperStreetViewRouter","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for SuperStreetViewRouter.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [SuperStreetViewRouter]","category":"page"},{"location":"#SuperStreetViewRouter.benchmark_random_walk_solutions","page":"Home","title":"SuperStreetViewRouter.benchmark_random_walk_solutions","text":"benchmark_random_walk_solution(test_iterations::Int64=10)\n\nGenerates the provided number of random walk solutions and displays statistics on the lengths of the results. Intended to provide a lower bound upon which to  improve.\n\n\n\n\n\n","category":"function"},{"location":"#SuperStreetViewRouter.create_input_graph-Tuple{HashCode2014.City}","page":"Home","title":"SuperStreetViewRouter.create_input_graph","text":"create_input_graph(city::City)\n\nReturns a SimpleWeightedDiGraph representing the provided City object. Graph vertices are Junction indices (as stored in the City object) and edges are street lengths.\n\n\n\n\n\n","category":"method"},{"location":"#SuperStreetViewRouter.generate_output_file","page":"Home","title":"SuperStreetViewRouter.generate_output_file","text":"generate_output_file(solution::Solution, path=nothing)\n\nCreates a text file using the provided Solution object and saves it to the specified path.\n\n\n\n\n\n","category":"function"},{"location":"#SuperStreetViewRouter.get_city_street-Tuple{HashCode2014.City, Int64, Int64}","page":"Home","title":"SuperStreetViewRouter.get_city_street","text":"get_city_street(city::City, start_junction::Int64, end_junction::Int64)\n\nReturns a Street object in the provided city that allows travel from the provided start junction index to the provided end junction index. Returns nothing if no such Street is found.\n\n\n\n\n\n","category":"method"},{"location":"#SuperStreetViewRouter.get_total_city_cost-Tuple{HashCode2014.City}","page":"Home","title":"SuperStreetViewRouter.get_total_city_cost","text":"get_total_city_cost(city::City)\n\nReturns the total time required to traverse all streets of the provided city in seconds.\n\n\n\n\n\n","category":"method"},{"location":"#SuperStreetViewRouter.get_total_city_length-Tuple{HashCode2014.City}","page":"Home","title":"SuperStreetViewRouter.get_total_city_length","text":"get_total_city_length(city::City)\n\nReturns the total length of all streets in the provided city in meters.\n\n\n\n\n\n","category":"method"},{"location":"#SuperStreetViewRouter.solve_graph_greedy","page":"Home","title":"SuperStreetViewRouter.solve_graph_greedy","text":"solve_graph_greedy(city::City=read_city())\n\nGenerates a greedy solution to the provided city, or uses the default city if none is provided. The greedy algorithm can be described as follows:     - At each junction, the car will choose to traverse the street with the     highest \"value\" = length / time.     - Traversed streets will be recorded.     - Traversed streets will have their length decreased by a constant factor     to discourage but allow usage. This constant is likely responsive to     optimization.\n\nInefficient due to only routing a single path at a time. Implementing a shared list of traversed streets and dedicating a separate thread to each path would likely improve performance.\n\n\n\n\n\n","category":"function"}]
}