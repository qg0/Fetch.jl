# Cross-applicable utilies supporting other user-facing functions

# Helper function for converting a string to Unix time (float)
function dateconv(s::AbstractString)
    Dates.datetime2unix(Dates.DateTime(s))
end

function isdate(t::Vector{DateTime})
    h = Dates.hour(t)
    m = Dates.minute(t)
    s = Dates.second(t)
    ms = Dates.millisecond(t)
    return all(h.==h[1]) && all(m.==m[1]) && all(s.==s[1]) && all(ms.==ms[1])
end

function csvresp(resp; sort::AbstractString="des")
    @assert resp.status == 200 "Error in download request."
    rowdata = Vector{ASCIIString}(split(readall(resp), '\n'))
    header = Vector{ASCIIString}(split(shift!(rowdata), ','))
    pop!(rowdata)
    if sort == "des"
        reverse!(rowdata)
    end
    N = length(rowdata)
    k = length(header)
    data = zeros(Float64, (N,k-1))
    v = map(s -> Array{ASCIIString}(split(s, ',')), rowdata)
    t = map(s -> Dates.DateTime(s[1]), v)
    isdate(t) ? t = Date(t) : nothing
    @inbounds for i = 1:N
        j = (v[i] .== "")
        v[i][find(j)] = "NaN"
        data[i,:] = float(v[i][2:k])
    end
    return (data, t, header)
end

