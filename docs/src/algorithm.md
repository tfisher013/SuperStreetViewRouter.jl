# Algorithm

`SuperStreetViewRouter.jl` uses a depth searched-enhanced greedy algorithm with optimizations to maximize traversed distance over the provided city input file. The algorithm's implementation and ideas for how it can be improved are described below.

Before continuing, it will be helpful to first familiarize yourself with the details of the [Google 2014 HashCode problem](https://storage.googleapis.com/coding-competitions.appspot.com/HC/2014/hashcode2014_final_task.pdf), as references to aspects of the problem will be made throughout.

## Depth Searched-Enhanced Greedy BFS

The algorithm performs the same routine for each car sequentially.

1. Enumerate all paths of `depth` edges from current junction that can be traversed in remaining time.
2. Select the path which generates the greatest value.
3. Travel `n_steps` along the selected path, updating remaining time with the travel cost.
4. Repeat from 1 until remaining time prohibits further travel.

### Path Value

To compare paths in terms of the benefit they will confer on itinerary score, we use the following metric:

The value of a path consisting of a list of $n$ junctions is given by

$$\sum_{i=1}^{n-1} d_{i,i+1}$$

where $d_{i, i+1}$ is the penalized distance (see information on penalties below) of traversing the street between junctions $i$
and $i+1$.

### Traversal Penalty

Since streets which have already been traversed once no longer add to the final itinerary score, the algorithm incorporates 
a traversal penalty to artificially deflate the distance of traversed streets when scoring paths. The idea is that streets 
with no or a low number of traversals will be selected over streets with a high number of traversals.

Our penalty function is of the following form:

$$f(x, n, p) = x * p^n$$

$x$ is the distance of the street assuming $0$ traversals
$n$ is the number of times the street has been traversed
$p$ is the parameter `elapsed_street_penalty`

## Search Parameters

All tunable algorithm parameters can be provided when calling `solve_graph_greedy()`:

  * `elapsed_street_penalty` controls the penalization accrued by traversed streets.
  * `depth` controls the maximum depth to which each BFS invocation will run.
  * `n_steps` is the number of street edges traversed once an optimal path of depth `depth` has been determined. Note that 
  * `n_steps` $\leq$ `depth` as the depth of our BFS limits how many steps forward can be taken per iteration.

## Minimum cut Algorithm

In graph theory, the mincut algorithm "cuts" the graph into two disjoint subsets by minimum sum of weights of at least one edge that's removed from the graph. The algorithm implementation can be found in the `add-subgraph` branch. 

The purpose of mincut in this project is to be able to run the `Depth Searched-Enhanced Greedy BFS` algorithm on smaller graphs, for higher accuracy with lower computational time. 

In our implementation in `create_subgraphs()`, we wanted to split the larger city graph into smaller graphs recursively, until there are $N$ subgraphs where $N$ is the number of cars. 

Each subgraph would thus have similar `value`, which is $$\frac{distance}{duration}$$. 

Then, each car will run within each subgraph, maximize the traveled path length in their respective subgraph, and complete at the same time as the other cars. Note that because the optimal path length may only be derived if cars are able to exit their respective subgraph, the cars should be able to traverse outside of their subgraph, albeit with a heavier penalty.

The steps taken look like the following.
1. Modify the graphical representation to include `value`.
2. Given a city graph, generate the 2-dimensional capacity matrix of the distance between each respective junction $j$.
3. Compute the parity and best cut from either the Graphs.jl mincut algorithm (https://docs.juliahub.com/Graphs/VJ6vx/1.5.0/pathing/#Graphs.mincut) or the Karger mincut algorithm. 
4. Generate two subgraphs using the returned parity, with one subgraph containing junctions labeled $1$ and the other containing junctions labeled $2$.
5. With each new subgraph, repeat steps 1-4 until $N$ subgraphs are created, where $N$ is the number of cars. 

We were unfortunately unable to merge the implemented mincut algorithm with the final product due to the nature of the mincut algorithm. For the first split, which should've outputted two subgraphs, the cut seemed incorrect. The first subgraph had 11347 junctions, whereas the second subgraph had 1 junction. We were expecting the numbers to be more balanced. However, on second thought, it is not too surprising that the mincut algorithm selects just one junction in one of the subgraphs. If that vertex only has one neighbor, the cut will only cross that one edge.

In future works, we would still like to pursue the idea of splitting the graph into smaller subgraphs because the idea would offer better accuracy. However, the mincut algorithm seems unlikely to support this endeavour. 

## Areas For Improvement

There are several ideas relating to BFS that could likely improve performance. Performance improvements themselves do not 
increase score, but allow for increased depth (which may augment score) in a manageable amount of time.
* Trimming BFS set periodically either by value, randomness, or the similarity between paths.
* Pre-allocating and considering only a set number of length `depth` paths per BFS routine to decrease runtime memory allocations.
* Applying threading to each iteration of BFS as next-step paths are generated independently.
* Splitting the graph geometrically or graphically with a different algorithm

