# Example Usage

## City Data

The `SuperStreetViewRouter.jl` solver accepts a `CityProblem` object which in turn is built from a [`City` object](https://gdalle.github.io/HashCode2014.jl/dev/api/#HashCode2014.City). The `City` object can be read in from a default online file or from a local file.

```julia
using HashCode2014

# using default city data file
julia> city = read_city()

# using local city data file
julia> city = read_city("path/to/city/file.txt")

# create CityProblem object
julia> city_problem = CityProblem(city, ExponentialPenaltyFunction())
```

## Generating Solution

The function `solve_graph_greedy()` generates a [Solution object](https://gdalle.github.io/HashCode2014.jl/dev/api/#HashCode2014.Solution)
describing an optimal itinerary for the provided City object.

```julia
using HashCode2014, SuperStreetViewRouter

# generate solution using CityProblem object and parameters
julia> solution = solve(city_problem; depth=5, n_steps=1)
```

## Evaluating Solution

Use the following functions to determine the feasibility, score, and to generate a visual representation of the solution:

```julia
using HashCode2014

# determine feasibility of solution
julia> check_solution_feasibility(solution, city_problem)

# determine distance of solution
julia> get_solution_distance(solution, city_problem)

# generate visual representation of solution
julia> plot_streets(city_object, solution; path="solution_plot.html")
```
