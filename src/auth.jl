# Methods for managing credentials, subscriptions, and other authorization-based work

const AUTHDIR = "$(Pkg.dir("Fetch"))/auth"  # location where credentials are to be stored

function checkdir()
	if !isdir(AUTHDIR)
		mkdir(AUTHDIR)
	end
	return true
end

function writeauth(key::AbstractString, fname::AbstractString; dir::AbstractString=AUTHDIR)
    @assert checkdir()
    f = open("$dir/$fname", "w")
    write(f, key)
    close(f)
end

@doc doc"""
Store Quandl API key for future use or read API key from stored file.

quandl_auth{T<:AbstractString}(`token`::T="")

If `token` is an empty string, returns stored key if it exists, otherwise returns empty string.\n
If `token` is non-empty, will store it as a text file for future use in the Quandl package directory and returns itself.
""" ->
function quandl_auth{T<:AbstractString}(key::T="")
    if "QuandlAuth" in keys(ENV) && ENV["QuandlAuth"] != ""
        return ENV["QuandlAuth"]
    end
	checkdir()
    authfile = "$AUTHDIR/quandl-auth"
    if key == ""
        if isfile(authfile)
            key = open(readall, authfile)
            ENV["QuandlAuth"] = key
            return key
        else
            return ""
        end
    else
        writeauth(key, "quandl-auth", dir=AUTHDIR)
        return key
    end
end
