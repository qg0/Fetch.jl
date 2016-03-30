VERSION >= v"0.4.0" && __precompile__(true)

using Base.Dates

module Fetch

using Base.Dates, Requests

export
    quandl_auth, quandl, quandl_meta, quandl_search,
    yahoo

include("utils.jl")
include("auth.jl")
include("quandl.jl")
include("yahoo.jl")

end
