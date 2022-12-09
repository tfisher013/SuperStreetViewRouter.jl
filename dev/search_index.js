var documenterSearchIndex = {"docs":
[{"location":"algorithm_upper_bound/#Analysis","page":"Upper Bound","title":"Analysis","text":"","category":"section"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"The upper bound of the algorithm can be described as the maximum score achievable on a given city data of which we know some  information. In this section, a reasonable upper bound will be derived beginning from simple assumptions and gradually accounting for increasing complexity.","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"Let's begin by considering a City object whose streets so exceed the number of cars and total duration that all cars can run freely  without fear of overlap. Here we assume that the traversal penalty described above is sufficient to prevent overlap in the presence  of an abudance of available streets. With all textnumtextunderscoretextcars cars running for duration  seconds each, there are n_cars cdot duration seconds during which  streets will be traversed.","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"To generate a (safely conservative) distance score from the available time, we introduce a normalized average rate for the City object as described below:","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"speed_avg = 15 cdot fracdisplaystyle sum_s in S s_d cdot fracs_ds_tdisplaystyle sum_s in S s_d","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"S","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"is the set of streets in the the city","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"s_d","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"is the distance of street s in S","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"s_t","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"is the duration of street s in S","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"Using this value as an approximation for the typical speed at which a car can traverse any given street in the City object, we arrive  at a simplistic upper bound (measured in meters) of","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"score leq n_cars cdot duration cdot speed_avg","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"Now applying this model to a more general City object requires accounting for two possibilities related to scarcity:","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"Suppose a City object contains less distance in its streets than the value obtained from the expression above?\nSuppose cars are forced to overlap one another in the course of their paths?","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"Handling the first situation is simple. We cap our bound at the total distance of the City object:","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"score leq min(n_cars cdot duration cdot speed_avg d_total)","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"where d_total=sum_s in S s_d","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"To address overlap, consider how its effect ranges from absolute (the score of n cars is equivalent to the score of  1) to non-existent (ideal model above). Expressed in terms of our quantities,","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"$","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"\\min(duration \\cdot speed{avg},  d{total}) \\leq d \\leq \\min(n{cars} \\cdot duration \\cdot speed{avg}, d_{total}) $","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"To simplify our expression, let's condense the effect of overlap into a single factor, o_f, like so:","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"score leq min(n_cars cdot duration cdot speed_avg cdot o_f d_total)","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"where frac1n_cars leq o_f leq 1","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"A simple way to construct o_f is to use some version of a sign-like function which varies between frac1n_cars and 1 in value. tanh(x) does the trick, and shifted and scaled between our values it becomes","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"o_f=frac12 cdot left(1-frac1n_cars right) tanh(x) + frac12 cdot left( 1 + frac1n_cars right)","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"The input variable to the tanh function must be a measure of the amount of overlap we expect in a city of fixed size. To represent this, we introduce the quantity cars_supported = fracd_totalt_total cdot speed_avg. This normalized difference between the number of cars the city can support and the number of cars in the input file, scaled by the number of cars, is what we use in our overlap factor value:","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"o_f=frac12 cdot left(1-frac1n_cars right) tanhleft(frac1n_cars cdot fraccars_supported-n_carscars_supportedright) + frac12 cdot left( 1 + frac1n_cars right) ","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"Combining all the components above, we arrive at the following inequality for all feasible distance scores d from our algorithm:","category":"page"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"score leq minleft(n_cars cdot duration cdot speed_avg cdot frac12 cdot left(1-frac1n_cars right) tanhleft(fraccars_supported-n_carscars_supportedright) + frac12 cdot left( 1 + frac1n_cars right) d_totalright)","category":"page"},{"location":"algorithm_upper_bound/#Experimental-Confirmation","page":"Upper Bound","title":"Experimental Confirmation","text":"","category":"section"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"Since we have a well defined upper bound for any solution from SuperStreetViewRouter.jl and a solver, experimental verification is easy to generate. See graphs below which plot solution scores from the library against upper bound values, varying 1 parameter at a time.","category":"page"},{"location":"algorithm_upper_bound/#Score-vs.-Upper-Bound-Across-Cars","page":"Upper Bound","title":"Score vs. Upper Bound Across Cars","text":"","category":"section"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"(Image: Score vs. upper bound across varying cars)","category":"page"},{"location":"algorithm_upper_bound/#Score-vs.-Upper-Bound-Across-Durations","page":"Upper Bound","title":"Score vs. Upper Bound Across Durations","text":"","category":"section"},{"location":"algorithm_upper_bound/","page":"Upper Bound","title":"Upper Bound","text":"(Image: Score vs. upper bound across varying durations)","category":"page"},{"location":"algorithm/#Algorithm","page":"Algorithm","title":"Algorithm","text":"","category":"section"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"SuperStreetViewRouter.jl uses a depth searched-enhanced greedy algorithm with optimizations to maximize traversed distance over the provided city input file. The algorithm's implementation and ideas for how it can be improved are described below.","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"Before continuing, it will be helpful to first familiarize yourself with the details of the Google 2014 HashCode problem, as references to aspects of the problem will be made throughout.","category":"page"},{"location":"algorithm/#Depth-Searched-Enhanced-Greedy-BFS","page":"Algorithm","title":"Depth Searched-Enhanced Greedy BFS","text":"","category":"section"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"The algorithm performs the same routine for each car sequentially.","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"Enumerate all paths of depth edges from current junction that can be traversed in remaining time.\nSelect the path which generates the greatest value.\nTravel n_steps along the selected path, updating remaining time with the travel cost.\nRepeat from 1 until remaining time prohibits further travel.","category":"page"},{"location":"algorithm/#Path-Value","page":"Algorithm","title":"Path Value","text":"","category":"section"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"To compare paths in terms of the benefit they will confer on itinerary score, we use the following metric:","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"The value of a path consisting of a list of n junctions is given by","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"sum_i=1^n-1 d_ii+1","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"where d_i i+1 is the penalized distance (see information on penalties below) of traversing the street between junctions i and i+1.","category":"page"},{"location":"algorithm/#Traversal-Penalty","page":"Algorithm","title":"Traversal Penalty","text":"","category":"section"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"Since streets which have already been traversed once no longer add to the final itinerary score, the algorithm incorporates  a traversal penalty to artificially deflate the distance of traversed streets when scoring paths. The idea is that streets  with no or a low number of traversals will be selected over streets with a high number of traversals.","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"Our penalty function is of the following form:","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"f(x n p) = x * p^n","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"x","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"is the distance of the street assuming 0 traversals n is the number of times the street has been traversed p is the parameter elapsed_street_penalty","category":"page"},{"location":"algorithm/#Search-Parameters","page":"Algorithm","title":"Search Parameters","text":"","category":"section"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"All tunable algorithm parameters can be provided when calling solve_graph_greedy():","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"elapsed_street_penalty controls the penalization accrued by traversed streets.\ndepth controls the maximum depth to which each BFS invocation will run.\nn_steps is the number of street edges traversed once an optimal path of depth depth has been determined. Note that \nn_steps leq depth as the depth of our BFS limits how many steps forward can be taken per iteration.","category":"page"},{"location":"algorithm/#Minimum-cut-Algorithm","page":"Algorithm","title":"Minimum cut Algorithm","text":"","category":"section"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"In graph theory, the mincut algorithm \"cuts\" the graph into two disjoint subsets by minimum sum of weights of at least one edge that's removed from the graph. The algorithm implementation can be found in the add-subgraph branch. ","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"The purpose of mincut in this project is to be able to run the Depth Searched-Enhanced Greedy BFS algorithm on smaller graphs, for higher accuracy with lower computational time. ","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"In our implementation in create_subgraphs(), we wanted to split the larger city graph into smaller graphs recursively, until there are N subgraphs where N is the number of cars. ","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"Each subgraph would thus have similar value, which is fracdistanceduration. ","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"Then, each car will run within each subgraph, maximize the traveled path length in their respective subgraph, and complete at the same time as the other cars. Note that because the optimal path length may only be derived if cars are able to exit their respective subgraph, the cars should be able to traverse outside of their subgraph, albeit with a heavier penalty.","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"The steps taken look like the following.","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"Modify the graphical representation to include value.\nGiven a city graph, generate the 2-dimensional capacity matrix of the distance between each respective junction j.\nCompute the parity and best cut from either the Graphs.jl mincut algorithm (https://docs.juliahub.com/Graphs/VJ6vx/1.5.0/pathing/#Graphs.mincut) or the Karger mincut algorithm. \nGenerate two subgraphs using the returned parity, with one subgraph containing junctions labeled 1 and the other containing junctions labeled 2.\nWith each new subgraph, repeat steps 1-4 until N subgraphs are created, where N is the number of cars. ","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"We were unfortunately unable to merge the implemented mincut algorithm with the final product due to the nature of the mincut algorithm. For the first split, which should've outputted two subgraphs, the cut seemed incorrect. The first subgraph had 11347 junctions, whereas the second subgraph had 1 junction. We were expecting the numbers to be more balanced. However, on second thought, it is not too surprising that the mincut algorithm selects just one junction in one of the subgraphs. If that vertex only has one neighbor, the cut will only cross that one edge.","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"In future works, we would still like to pursue the idea of splitting the graph into smaller subgraphs because the idea would offer better accuracy. However, the mincut algorithm seems unlikely to support this endeavour. ","category":"page"},{"location":"algorithm/#Areas-For-Improvement","page":"Algorithm","title":"Areas For Improvement","text":"","category":"section"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"There are several ideas relating to BFS that could likely improve performance. Performance improvements themselves do not  increase score, but allow for increased depth (which may augment score) in a manageable amount of time.","category":"page"},{"location":"algorithm/","page":"Algorithm","title":"Algorithm","text":"Trimming BFS set periodically either by value, randomness, or the similarity between paths.\nPre-allocating and considering only a set number of length depth paths per BFS routine to decrease runtime memory allocations.\nApplying threading to each iteration of BFS as next-step paths are generated independently.\nSplitting the graph geometrically or graphically with a different algorithm","category":"page"},{"location":"","page":"API","title":"API","text":"CurrentModule = SuperStreetViewRouter","category":"page"},{"location":"#SuperStreetViewRouter","page":"API","title":"SuperStreetViewRouter","text":"","category":"section"},{"location":"","page":"API","title":"API","text":"Documentation for SuperStreetViewRouter.","category":"page"},{"location":"","page":"API","title":"API","text":"","category":"page"},{"location":"","page":"API","title":"API","text":"Modules = [SuperStreetViewRouter]","category":"page"},{"location":"#SuperStreetViewRouter.CityData","page":"API","title":"SuperStreetViewRouter.CityData","text":"CityData(total_duration::Int, nb_cars::Int, starting_junction::Int)\n\nA struct that holds the metadata for a city. Has constructor(s)\n\nCityData(c::City)\nCityData(total_duration::Int, nb_cars::Int, starting_junction::Int)\n\n\n\n\n\n","category":"type"},{"location":"#SuperStreetViewRouter.StreetData","page":"API","title":"SuperStreetViewRouter.StreetData","text":"StreetData(duration::Int, id::Int, distance::Int)\n\nStructure storing the data required for greedy algorithm in edges of city graph. Has constructors\n\nStreetData(street::Street)\nStreetData(street::Street, id::Int)\n\n\n\n\n\n","category":"type"},{"location":"#SuperStreetViewRouter.check_solution_feasibility-Tuple{HashCode2014.Solution, CityProblem}","page":"API","title":"SuperStreetViewRouter.check_solution_feasibility","text":"check_solution_feasibility(soln::Solution, city_meta_graph::CityGraph; verbose=false)::Bool\n\nCheck if soln satisfies the constraints for the instance defined by city_meta_graph.     The following criteria are considered (taken from the problem statement):     - the number of itineraries has to match the number of cars of city_meta_graph     - the first junction of each itinerary has to be the starting junction of city_meta_graph     - for each consecutive pair of junctions on an itinerary, a street connecting these junctions has to exist in city_meta_graph (if the street is one directional, it has to be traversed in the correct direction)     - the duration of each itinerary has to be lower or equal to the total duration of city_meta_graph\n\nCredit to HashCode2014 for such a clear docstring\n\n\n\n\n\n","category":"method"},{"location":"#SuperStreetViewRouter.find_best_path-Tuple{Any, Any, Any}","page":"API","title":"SuperStreetViewRouter.find_best_path","text":"find_best_path(possible_paths, traversed_streets, elapsed_street_penalty)\n\nReturns the best path to traverse from the provided list of possible paths. The best path is the one with the highest value considering the number of times each street has been traversed with the provided penalty\n\n\n\n\n\n","category":"method"},{"location":"#SuperStreetViewRouter.get_path_value-Tuple{Any, Any, Any}","page":"API","title":"SuperStreetViewRouter.get_path_value","text":"get_path_value(path, traversed_streets, elapsed_street_penalty)\n\nReturns the value of the provided path, taking into account the number of times each street has been traversed with the provided penalty\n\n\n\n\n\n","category":"method"},{"location":"#SuperStreetViewRouter.get_possible_paths-NTuple{4, Any}","page":"API","title":"SuperStreetViewRouter.get_possible_paths","text":"    get_possible_paths(city_graph, current_junction, remaining_time, depth)\n\nreturns list of tuples\n\n\n\n\n\n","category":"method"},{"location":"#SuperStreetViewRouter.get_possible_streets-Tuple{Any, Any, Any}","page":"API","title":"SuperStreetViewRouter.get_possible_streets","text":"get_possible_streets(city_graph)\n\nReturns a list of all streets that can be traversed from the provided junction. The streets are tuples of (endjunction, streetdata)\n\n\n\n\n\n","category":"method"},{"location":"#SuperStreetViewRouter.get_solution_distance-Tuple{HashCode2014.Solution, CityProblem}","page":"API","title":"SuperStreetViewRouter.get_solution_distance","text":"get_solution_distance(solution::Solution, city_meta_graph::CityGraph)\n\nCompute the total distance of all itineraries in solution based on the street data from city. Streets visited several times are only counted once.\n\n\n\n\n\n","category":"method"},{"location":"#SuperStreetViewRouter.get_total_city_cost-Tuple{HashCode2014.City}","page":"API","title":"SuperStreetViewRouter.get_total_city_cost","text":"get_total_city_cost(city::City)\n\nReturns the total time (in seconds) required to traverse all streets of the provided city.\n\n\n\n\n\n","category":"method"},{"location":"#SuperStreetViewRouter.get_total_city_length-Tuple{HashCode2014.City}","page":"API","title":"SuperStreetViewRouter.get_total_city_length","text":"get_total_city_length(city::City)\n\nReturns the total length (in meters) of all streets in the provided city.\n\n\n\n\n\n","category":"method"},{"location":"#SuperStreetViewRouter.path_time-Tuple{Any}","page":"API","title":"SuperStreetViewRouter.path_time","text":"path_time(path)\n\nReturns the time it takes to traverse the provided path\n\n\n\n\n\n","category":"method"},{"location":"example_usage/#Example-Usage","page":"Example Usage","title":"Example Usage","text":"","category":"section"},{"location":"example_usage/#City-Data","page":"Example Usage","title":"City Data","text":"","category":"section"},{"location":"example_usage/","page":"Example Usage","title":"Example Usage","text":"The SuperStreetViewRouter.jl solver accepts a CityProblem object which in turn is built from a City object. The City object can be read in from a default online file or from a local file.","category":"page"},{"location":"example_usage/","page":"Example Usage","title":"Example Usage","text":"using HashCode2014\n\n# using default city data file\njulia> city = read_city()\n\n# using local city data file\njulia> city = read_city(\"path/to/city/file.txt\")\n\n# create CityProblem object\njulia> city_problem = CityProblem(city, ExponentialPenaltyFunction())","category":"page"},{"location":"example_usage/#Generating-Solution","page":"Example Usage","title":"Generating Solution","text":"","category":"section"},{"location":"example_usage/","page":"Example Usage","title":"Example Usage","text":"The function solve_graph_greedy() generates a Solution object describing an optimal itinerary for the provided City object.","category":"page"},{"location":"example_usage/","page":"Example Usage","title":"Example Usage","text":"using HashCode2014, SuperStreetViewRouter\n\n# generate solution using CityProblem object and parameters\njulia> solution = solve(city_problem; depth=5, n_steps=1)","category":"page"},{"location":"example_usage/#Evaluating-Solution","page":"Example Usage","title":"Evaluating Solution","text":"","category":"section"},{"location":"example_usage/","page":"Example Usage","title":"Example Usage","text":"Use the following functions to determine the feasibility, score, and to generate a visual representation of the solution:","category":"page"},{"location":"example_usage/","page":"Example Usage","title":"Example Usage","text":"using HashCode2014\n\n# determine feasibility of solution\njulia> check_solution_feasibility(solution, city_problem)\n\n# determine distance of solution\njulia> get_solution_distance(solution, city_problem)\n\n# generate visual representation of solution\njulia> plot_streets(city_object, solution; path=\"solution_plot.html\")","category":"page"}]
}
