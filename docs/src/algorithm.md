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

## Analysis

!!!In Progress!!!

The upper bound of the algorithm can be described as the maximum score achievable on a given city data of which we know some 
information. In this section, a reasonable upper bound will be derived beginning from simple assumptions and gradually accounting
for increasing complexity.

Let's begin by considering a City object whose streets so exceed the number of cars and total duration that all cars can run freely 
without fear of overlap. Here we assume that the traversal penalty described above is sufficient to prevent overlap in the presence 
of an abudance of available streets. With all $\text{num}\textunderscore\text{cars}$ cars running for $\text{total}\textunderscore\text{duration}$ 
seconds each, there are $\text{num}\textunderscore\text{cars} \cdot \text{total}\textunderscore\text{duration}$ seconds during which 
streets will be traversed.

To generate a distance score from the available time, we introduce a normalized average rate for the City object as described below:

$$\text{norm}\textunderscore\text{avg}\textunderscore\text{speed} = \frac{\displaystyle \sum_{s \in S} s_d \cdot \frac{s_d}{s_t}}{\displaystyle \sum_{s \in S} s_d}$$

$S$ is the set of streets in the the city

$s_d$ is the distance of street $s \in S$

$s_t$ is the duration of street $s \in S$

Using this value as an approximation for the typical speed at which a car can traverse any given street in the City object, we arrive 
at a idyllic upper bound $b_{u}$ (measured in meters) of

$$b_{u} \leq \text{num}\textunderscore\text{cars} \cdot \text{total}\textunderscore\text{duration} \cdot \text{norm}\textunderscore\text{avg}\textunderscore\text{speed}$$

Now applying this model to a more general City object requires accounting for two possibilities related to scarcity:

1. Suppose a City object contains less distance in its streets than the value obtained from the expression above?
2. Suppose cars are forced to overlap one another in the course of their paths?

Handling the first situation is simple. We cap our bound at the total distance of the City object:

$$b_{u} \leq \min(\text{num}\textunderscore\text{cars} \cdot \text{total}\textunderscore\text{duration} \cdot \text{norm}\textunderscore\text{avg}\textunderscore\text{speed}, d_{total})$$

where $d_{total}=\sum_{s \in S} s_d$

To address overlap, consider how its effect ranges from absolute (the score of $n$ cars is equivalent to the score of 
$1$) to non-existent (ideal model above). Expressed in terms of our quantities,

$$ \min(\text{total}\textunderscore\text{duration} \cdot \text{norm}\textunderscore\text{avg}\textunderscore\text{speed}, 
d_{total}) \leq b_{u} \leq \min(\text{num}\textunderscore\text{cars} \cdot \text{total}\textunderscore\text{duration} \cdot \text{norm}\textunderscore\text{avg}\textunderscore\text{speed}, d_{total}) $$

To simplify our expression, let's condense the effect of overlap into a single factor, $o_f$, like so:

$$b_{u} \leq \min(\text{num}\textunderscore\text{cars} \cdot \text{total}\textunderscore\text{duration} \cdot \text{norm}\textunderscore\text{avg}\textunderscore\text{speed} \cdot o_f, d_{total})$$

where $\frac{1}{\text{num}\textunderscore\text{cars}} \leq o_f \leq 1$

A simple way to construct $o_f$ is to relate it to the following ratio, which represents what portion of the city $1$ car 
could traverse on its own:

$$\frac{\text{total}\textunderscore\text{duration} \cdot \text{norm}\textunderscore\text{avg}\textunderscore\text{speed}}{d_{total}}$$

!!!In Progress!!!

## Areas For Improvement

There are several ideas relating to BFS that could likely improve performance. Performance improvements themselves do not 
increase score, but allow for increased depth (which may augment score) in a manageable amount of time.
* Trimming BFS set periodically either by value, randomness, or the similarity between paths.
* Pre-allocating and considering only a set number of length `depth` paths per BFS routine to decrease runtime memory allocations.
* Applying threading to each iteration of BFS as next-step paths are generated independently.



