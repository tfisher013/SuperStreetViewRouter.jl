using SuperStreetViewRouter
using Aqua
using Documenter
using MyJuliaPackage
using JuliaFormatter
using Test

DocMeta.setdocmeta!(
MyJuliaPackage,
:DocTestSetup,
:(using SuperStreetViewRouter);
recursive=true
)

@testset verbose = true "MyJuliaPackage.jl" begin
@testset verbose = true "Code quality (Aqua.jl)" begin
Aqua.test_all(MyJuliaPackage; ambiguities=false)
end
@testset verbose = true "Code formatting (JuliaFormatter.jl)" begin
@test format(MyJuliaPackage; verbose=true, overwrite=false)
end
@testset verbose = true "Doctests (Documenter.jl)" begin
doctest(MyJuliaPackage)
end
end
