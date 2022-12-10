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
        @test format(SuperStreetViewRouter; verbose=true, overwrite=true)
    end
    @testset verbose = true "Doctests (Documenter.jl)" begin
        doctest(SuperStreetViewRouter)
    end
    @testset verbose = true "Solution feasibility" begin
        prob = CityProblem()
        sol = solve(prob)
        @test check_solution_feasibility(sol, prob)

        data2 = SuperStreetViewRouter.CityData(;
            total_duration=prob.data.total_duration,
            nb_cars=prob.data.nb_cars + 1,
            starting_junction=prob.data.starting_junction,
        )
        prob = CityProblem(;
            data=data2, graph=prob.graph, penalty_function=prob.penalty_function
        )
        @test ~check_solution_feasibility(sol, prob)

        data3 = SuperStreetViewRouter.CityData(;
            total_duration=prob.data.total_duration,
            nb_cars=prob.data.nb_cars,
            starting_junction=prob.data.starting_junction + 1,
        )
        prob = CityProblem(;
            data=data3, graph=prob.graph, penalty_function=prob.penalty_function
        )
        @test ~check_solution_feasibility(sol, prob)
    end
    @testset verbose = true "Solution Distance" begin
        prob = CityProblem()
        sol = solve(prob)
        @test get_solution_distance(sol, prob) == 1790843
    end

    # test get_possible_streets()
    @testset verbose = true "get_possible_streets" begin
        prob = CityProblem()

        # we should have no possible streets returned if we provide remaining time = 0
        @test length(get_possible_streets(prob.graph, prob.data.starting_junction, 0)) == 0

        # ensure returned streets have duration ≤ remaining time
        for i in [10, 25, 50]
            for possible_street in
                get_possible_streets(prob.graph, prob.data.starting_junction, i)
                @test possible_street[2].duration ≤ i
            end
        end
    end

    # test get_possible_paths
    @testset verbose = true "get_possible_paths" begin
        prob = CityProblem()

        @test length(get_possible_paths(prob.graph, prob.data.starting_junction, 0, 0)) == 0

        for i in [10, 25, 50]
            for j in [1, 5, 10]
                for possible_path in
                    get_possible_paths(prob.graph, prob.data.starting_junction, i, j)
                    @test possible_path[1][2].duration ≤ i
                end
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
