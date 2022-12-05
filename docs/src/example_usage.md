# Example Usage

## City Data

The `SuperStreetViewRouter.jl` solver accepts a [City object](https://gdalle.github.io/HashCode2014.jl/dev/api/#HashCode2014.City)
which can be generated using the `HashCode2014.jl` dependency or read in from a local file. 

```julia
using HashCode2014

# using default city data file
julia> city = read_city()

# using local city data file
julia> city = read_city("path/to/city/file.txt")
```

## Generating Solution

The function `solve_graph_greedy()` generates a [Solution object](https://gdalle.github.io/HashCode2014.jl/dev/api/#HashCode2014.Solution)
describing an optimal itinerary for the provided City object.

```julia
using HashCode2014, SuperStreetViewRouter

# generate solution using default city object and parameters
julia> solution = solve_graph_greedy()

# generate solution with custom city object and parameters
julia> solution = solve_graph_greedy(city; elapsed_street_penalty=0.25, depth=6, n_steps=3)
```

## Evaluating Solution

The feasibility, distance, and a visual representation of a solution can be obtained using fuctions from the `HashCode2014.jl` dependency:

```julia
using HashCode2014

# determine feasibility of solution
julia> is_feasible(solution, city)

# determine distance of solution
julia> total_distance(solution, city)

# generate visual representation of solution
julia> plot_streets(city_object, solution; path="solution_plot.html")
```
