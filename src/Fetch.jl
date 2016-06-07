VERSION >= v"0.4.0" && __precompile__(true)

module Fetch

using Base.Dates, Requests, Temporal

export
    quandl_auth, quandl, quandl_meta, quandl_search,
    yahoo

include("utils.jl")
include("auth.jl")
include("quandl.jl")
include("yahoo.jl")

end
