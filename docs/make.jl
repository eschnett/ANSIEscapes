# Generate documentation with this command:
# (cd docs && julia make.jl)

push!(LOAD_PATH, "..")

using Documenter
using ANSIEscapes

makedocs(; sitename="ANSIEscapes", format=Documenter.HTML(), modules=[ANSIEscapes])

deploydocs(; repo="github.com/eschnett/ANSIEscapes.jl.git", devbranch="main", push_preview=true)
