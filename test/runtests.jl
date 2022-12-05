using Aqua
using Documenter
using JuliaFormatter
using SuperStreetViewRouter
using HashCode2014
using Test

DocMeta.setdocmeta!(
    SuperStreetViewRouter, :DocTestSetup, :(using SuperStreetViewRouter); recursive=true
)

@testset verbose = true "SuperStreetViewRouter.jl" begin
    @testset verbose = true "Code quality (Aqua.jl)" begin
        Aqua.test_all(SuperStreetViewRouter; ambiguities=false)
    end
    @testset verbose = true "Code formatting (JuliaFormatter.jl)" begin
        @test format(SuperStreetViewRouter; verbose=true, overwrite=false)
    end
    @testset verbose = true "Doctests (Documenter.jl)" begin
        doctest(SuperStreetViewRouter)
    end
    @testset verbose = true "Solution feasibility" begin
        city = read_city()
        solution = solve_graph_greedy()
        @test is_feasible(solution, city)
    end

    # test get_possible_streets()
    @testset verbose = true "get_possible_streets" begin
        city = read_city()
        city_graph = create_input_graph(city).graph

        # we should have no possible streets returned if we provide remaining time = 0
        @test length(get_possible_streets(city_graph, city.starting_junction, 0)) == 0

        # ensure returned streets have duration ≤ remaining time
        for i in [10, 25, 50]
            for possible_street in
                get_possible_streets(city_graph, city.starting_junction, i)
                @test possible_street[2].duration ≤ i
            end
        end
    end

    # test get_total_city_cost
    @testset verbose = true "get_total_city_cost" begin
        city = read_city()
        @test get_total_city_cost(city) == 274628
    end

    # test get_total_city_length
    @testset verbose = true "get_total_city_length" begin
        city = read_city()
        @test get_total_city_length(city) == 1967444
    end
end
