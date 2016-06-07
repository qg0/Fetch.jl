const QUANDL_URL = "https://www.quandl.com/api/v3/datasets"

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
        url = "$QUANDL_URL/$code.csv?$(fromstr)$(thrustr)&order=$sort&collapse=$freq&transform=$calc&api_key=$auth"
    else
        url = "$QUANDL_URL/$code.csv?&rows=$rows&order=$sort&collapse=$freq&transform=$calc&api_key=$auth"
    end
    indata = csvresp(get(url), sort=sort)
    return ts(indata[1], indata[2], indata[3][2:end])
end

@doc doc"""
quandl_meta(database::AbstractString, dataset::AbstractString)

Quandl dataset metadata downloaded into a Julia Dict
""" ->
function quandl_meta(database::AbstractString, dataset::AbstractString)
    resp = get("$QUANDL_URL/$database/$dataset/metadata.json")
    @assert resp.status == 200 "Error downloading metadata from Quandl."
    return parse(readall(resp))["dataset"]
end

@doc doc"""
quandl_search(;db::AbstractString="", qry::AbstractString="", perpage::Int=1, pagenum::Int=1)

Search Quandl for data in a given database, `db`, or matching a given query, `qry`.
""" ->
function quandl_search(;db::AbstractString="", qry::AbstractString="", perpage::Int=1, pagenum::Int=1)
    @assert db!="" || qry!="" "Must enter a database or a search query."
    dbstr = db   == "" ? "" : "database_code=$db&"
    qrystr = qry  == "" ? "" : "query=$(replace(qry, ' ', '+'))&"
    resp = get("$QUANDL_URL.json?$(dbstr)$(qrystr)per_page=$perpage&page=$pagenum")
    @assert resp.status == 200 "Error retrieving search results from Quandl"
    return parse(readall(resp))
end
