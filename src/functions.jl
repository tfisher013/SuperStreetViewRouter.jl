"""

    benchmark_random_walk_solution(test_iterations::Int64=10)

Generates the provided number of random walk solutions and displays statistics
on the lengths of the results. Intended to provide a lower bound upon which to 
improve.
"""
function benchmark_random_walk_solutions(city::City, test_iterations::Int64=10)
    println("Generating solutions...")

    rand_solns_length_array = zeros(test_iterations)
    for i in 1:test_iterations
        rand_soln = random_walk(city)
        if (is_feasible(rand_soln, city))
            rand_solns_length_array[i] = total_distance(rand_soln, city)
        else
            rand_solns_length_array[i] = nothing
        end
    end

    println("min solution: ", minimum(rand_solns_length_array))
    println("max solution: ", maximum(rand_solns_length_array))
    return println("mean solution: ", mean(rand_solns_length_array))
end
