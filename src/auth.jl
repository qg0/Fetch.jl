# Methods for managing credentials, subscriptions, and other authorization-based work

@doc doc"""
Store Quandl API key for future use or read API key from stored file.

quandl_auth{T<:AbstractString}(`token`::T="")

If `token` is an empty string, returns stored key if it exists, otherwise returns empty string.\n
If `token` is non-empty, will store it as a text file for future use in the Quandl package directory and returns itself.
""" ->
function quandl_auth{T<:AbstractString}(token::T="")
    authpath = string(Pkg.dir(), "/Quandl/authcode.txt")
    if token == ""
        if isfile(authpath)
            authfile = open(authpath)
            authcode = readall(authfile)
            close(authfile)
            return authcode
        else
            return ""
        end
    else
        authfile = open(authpath, "w")
        write(authfile, token)
        close(authfile)
        return token
    end
end
