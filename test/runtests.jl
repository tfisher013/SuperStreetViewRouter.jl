using Aqua
using Documenter
using JuliaFormatter
using SuperStreetViewRouter
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
end
