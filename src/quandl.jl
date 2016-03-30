# Helper function for converting a string to Unix time (float)
function dateconv(s::AbstractString)
    Dates.datetime2unix(Dates.DateTime(s))
end

const QUANDLROOT = "https://www.quandl.com/api/v3/datasets"
@doc doc"""
quandl(code::AbstractString;
       from::AbstractString="",
       thru::AbstractString="",
       freq::AbstractString="daily",
       calc::AbstractString="none",
       sort::AbstractString="asc",
       rows::Int=0,
       auth::AbstractString=quandl_auth())

Quandl data download
""" ->
function quandl(code::AbstractString;
                from::AbstractString="",
                thru::AbstractString="",
                freq::AbstractString="daily",
                calc::AbstractString="none",
                sort::AbstractString="asc",
                rows::Int=0,
                auth::AbstractString=quandl_auth())
    # Check arguments =========================================================
    @assert from=="" || (from[5]=='-' && from[8]=='-') "Argument `from` has invlalid format."
    @assert thru=="" || (thru[5]=='-' && thru[8]=='-') "Argument `thru` has invlalid format."
    @assert freq in ["daily","weekly","monthyl","quarterly","annual"] "Invalid `freq` argument."
    @assert calc in ["none","diff","rdiff","cumul","normalize"] "Invalid `calc` argument."
    @assert sort  == "asc" || sort == "des" "Argument `sort` must be either \"asc\" or \"des\"."
    if rows != 0 && (from != "" || thru != "")
        error("Cannot specify `rows` and date range (`from` or `thru`).")
    end
    # Format URL ===============================================================
    if rows == 0
        fromstr = from == "" ? "" : "&start_date=$from"
        thrustr = thru == "" ? "" : "&end_date=$thru"
        url = "$QUANDLROOT/$code.csv?$(fromstr)$(thrustr)&order=$sort&collapse=$freq&transform=$calc&api_key=$auth"
    else
        url = "$QUANDLROOT/$code.csv?&rows=$rows&order=$sort&collapse=$freq&transform=$calc&api_key=$auth"
    end
    # Send request =============================================================
    resp = get(url)
    @assert resp.status == 200 "Error downloading data from Quandl."
    # Parse response to numerical data =========================================
    rowdata = Array{ASCIIString}(split(readall(resp), '\n'))
    header = Array{ASCIIString}(split(shift!(rowdata), ','))
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

@doc doc"""
""" ->
function quandl_meta(database::AbstractString, dataset::AbstractString)

end
