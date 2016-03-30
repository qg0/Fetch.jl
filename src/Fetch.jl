VERSION >= v"0.4.0" && __precompile__(true)

using Base.Dates
module Fetch

export
    quandl_auth, quandl

include("auth.jl")
include("quandl.jl")

end
