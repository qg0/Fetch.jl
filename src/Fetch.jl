VERSION >= v"0.4.0" && __precompile__(true)

module Fetch

export
    quandl_auth, quandl

include("auth.jl")
include("quandl.jl")

end
