# Functionality for interfacing with the Yahoo Finance api

const YAHOO_URL = "http://real-chart.finance.yahoo.com/table.csv"

function yahoo(symb::AbstractString;
               from::AbstractString="1900-01-01",
               thru::AbstractString=string(Dates.today()),
               freq::Char='d')
    @assert freq in ['d','w','m','v'] "Argument `freq` must be in ['d','w','m','v']"
    @assert from[5] == '-' && from[8] == '-' "Argument `from` has invalid date format."
    @assert thru[5] == '-' && thru[8] == '-' "Argument `thru` has invalid date format."
    m = Base.parse(Int, from[6:7]) - 1
    a = m<10 ? string("0",m) : string(m)
    b = from[9:10]
    c = from[1:4]
    m = Base.parse(Int, thru[6:7]) - 1
    d = m<10 ? string("0",m) : string(m)
    e = thru[9:10]
    f = thru[1:4]
    indata = csvresp(get("$YAHOO_URL?s=$symb&a=$a&b=$b&c=$c&d=$d&e=$e&f=$f&g=$freq&ignore=.csv"))
    return ts(indata[1], indata[2], indata[3][2:end])
end

