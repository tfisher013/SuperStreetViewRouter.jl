using Documenter
using SuperStreetViewRouter

DocMeta.setdocmeta!(
    SuperStreetViewRouter, :DocTestSetup, :(using SuperStreetViewRouter); recursive=true
)

makedocs(;
    modules=[SuperStreetViewRouter],
    authors="Shelley Choi, Thomas Fisher, Luc Paoli",
    repo="https://github.com/tfisher013/SuperStreetViewRouter.jl/blob/{commit}{path}#{line}",
    sitename="SuperStreetViewRouter.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://tfisher013.github.io/SuperStreetViewRouter.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Example Usage" => "example_usage.md",
        "Algorithm" => "algorithm.md",
        "Upper Bound" => "algorithm_upper_bound.md",
        "API" => "index.md",
    ],
)

deploydocs(; repo="github.com/tfisher013/SuperStreetViewRouter.jl", devbranch="main")
