# Cross-applicable utilies supporting other user-facing functions

function csvresp(resp)
    @assert resp.status == 200 "Error in download request."
    rowdata = Vector{ASCIIString}(split(readall(resp), '\n'))
    header = Vector{ASCIIString}(split(shift!(rowdata), ','))
    pop!(rowdata)
    if sort == ""
        reverse!(rowdata)
    end
    N = length(rowdata)
    k = length(header)
    data = zeros(Float64, (N,k))
    data[:,1] = map(s->dateconv(split(s,',')[1]), rowdata)
    v = map(s->Array{ASCIIString}(split(s,',')[2:end]), rowdata)
    @inbounds for i = 1:N
        j = (v[i] .== "")
        v[i][find(j)] = "NaN"
        data[i,2:end] = float(v[i])
    end
    return (data, header)
end

