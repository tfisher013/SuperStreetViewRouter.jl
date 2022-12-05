# Algorithm

`SuperStreetViewRouter.jl` uses a depth searched-enhanced greedy algorithm with optimizations to maximize traversed distance over the provided city input file. The algorithm's implementation and ideas for it can be improvemed are described below.

Before continuing, it will be helpful to first familiarize yourself with the details of the [Google 2014 HashCode problem](https://storage.googleapis.com/coding-competitions.appspot.com/HC/2014/hashcode2014_final_task.pdf), as references to aspects of the problem will be made throughout.

## Depth Searched-Enhanced Greedy BFS

The algorithm performs the same routine for each car sequentially.

1. Enumerate all paths of `depth` edges from current position.
2. Select the path which generates the greatest value.
3. Travel `n_steps` along the selected path, updating remaining time with the travel cost.
4. Repeat from 1 until remaining time prohibits further travel.

### Path Value

To compare paths in terms of the benefit they will confer on itinerary score, we use the following metric:

The value of a path consisting of a list of $n$ junctions is given by

$$\sum_{i=1}^{n-1} d_{i,i+1}$$

where $d_{i, i+1}$ is the penalized cost (see information on penalties below) of traversing the street between junctions $i$
and $i+1$.

### Traversal Penalty

Since streets which have already been traversed once no longer add to the final itinerary score, the algorithm incorporates 
a traversal penalty to artificially deflate the distance of traversed streets when scoring paths. The idea is that streets 
with no or a low number of traversals will be selected over streets with a high number of traversals.

Our penalty function is of the following form:

$$f(x, n, p) = x * p^n$$

$x$ is the distance of the street assuming $0$ traversals<br/>
$n$ is the number of times the street has been traversed<br/>
$p$ is the parameter `elapsed_street_penalty`

## Search Parameters

All tunable algorithm parameters can be provided when calling `solve_graph_greedy()`:

  * `elapsed_street_penalty` controls the penalization accrued by traversed streets.
  * `depth` controls the maximum depth to which each BFS invocation will run.
  * `n_steps` is the number of street edges traversed once an optimal path of depth `depth` has been determined. Note that 
  * `n_steps` $\leq$ `depth` as the depth of our BFS limits how many steps forward we can take per iteration.

## Areas For Improvement
