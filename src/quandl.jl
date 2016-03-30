function quandl(code::AbstractString;
                from::AbstractString="",
                thru::AbstractString="",
                freq::AbstractString="",
                calc::AbstractString="",
                sort::AbstractString="",
                rows::Int=0,
                auth::AbstractString=quandl_auth())
    # Argument checks =========================================================
    if from != "" && (from[5] != '-' || from[8] != '-')
        error("Invalid format for argument `from`.")
    end
    if thru != "" && (thru[5] != '-' || from[8] != '-')
        error("Invalid format for argument `thru`.")
    end
    if !in(freq, ["", "daily", "weekly", "monthly", "quarterly", "annual"])
        error("Argument `freq` must be either 'daily', 'weekly', 'monthly', 'quarterly', or 'annual'.")
    end
    if !in(calc, ["", "none", "diff", "rdiff", "cumul", "normalize"])
        error("Argument `calc` must be either 'none', 'diff', 'rdiff', 'cumul', or 'normalize'.")
    end
    if sort != "asc" && sort != "des" && sort != ""
        error("Argument `sort` must be either 'asc' or 'des'.")
    end
    if rows != 0 && (from != "" || thru != "")
        error("Cannot specify `rows` and date range (`from` or `thru`).")
    end
    # URL string interpolation ================================================
    token = quandl_auth(auth)
	println(token)
    if rows == 0
        url = "https://www.quandl.com/api/v3/datasets/$code.csv?" *
              ifelse(from=="", "", "&start_date=$from") *
              ifelse(thru=="", "", "&end_date=$thru") *
              ifelse(rows==0,  "", "&rows=$rows&") *
			  ifelse(sort=="", "", "&order=$sort") *
			  ifelse(freq=="", "", "&collapse=$freq") *
			  ifelse(calc=="", "", "&transform=$calc") *
              ifelse(token=="", "", "&api_key=$token")
    else
        url = "https://www.quandl.com/api/v3/datasets/$code.csv?&rows=$rows" *
			  ifelse(sort=="", "", "&order=$sort") *
			  ifelse(freq=="", "", "&collapse=$freq") *
			  ifelse(calc=="", "", "&transform=$calc") *
              ifelse(token=="", "", "&api_key=$token")
    end
    resp = get(url)
    resp.status != 200 ? error("Error downloading data from Quandl.") : nothing
    rowdata = split(Requests.text(resp), '\n')[1:end-1]
    flds = split(convert(ASCIIString, rowdata[1]), ',')
    N = length(rowdata) - 1
    k = length(flds)
    data = zeros(N, k)
    for i = 1:N
        thisrow = split(rowdata[i+1], ',')
        data[i,1] = Dates.datetime2unix(Dates.DateTime(convert(ASCIIString, thisrow[1])))
        for j = 2:k
            if isempty(thisrow[j])
                data[i,j] = NaN
            else
                data[i,j] = float(thisrow[j])
            end
        end
    end
    return [flds[j] => data[:,j] for j=1:k]
    # return data
end

