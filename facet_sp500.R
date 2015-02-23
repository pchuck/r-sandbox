## faceted search, correlation and plot of s&p 500 constituents
## utilizes data from data.okfn.org
##
##   accepts a facet of interest
##   and returns the top-ranked securities based on that attribute
##
args <- commandArgs(trailingOnly=TRUE)

if(length(args) < 1) {
    print("usage: Rscript facet_sp500.R facet [reverse]")
    print("  e.g. Rscript facet_sp500.R Market.Cap true")
    quit()
}

facet = args[1]
reverse = T
## by default, reverse sort unless otherwise specified
if(length(args) == 2) 
    reverse <- args[2] == "true"

## load the data source
dsource = "http://data.okfn.org/data/core/s-and-p-500-companies/r/constituents-financials.csv"
sp.detail <- read.csv(dsource, sep=",", header=1)

sortByFacet <- function(sp.data, facet, reverse) {
    ## locate the column of interest
    columns = colnames(sp.data)

    index = match(facet, columns)
    if(is.na(index)) {
        cat("invalid facet: ", facet, "\n")
        cat("valid values are:\n")
        lapply(columns, function(cname) { cat("  ", cname, "\n") } )
        cat("exiting..\n")
        quit()
    }

    byFacet <- head(sp.data[order(sp.data[ ,index], decreasing=reverse), ])
    byFacet
}

## extract the sorted data by facet
byFacet <- sortByFacet(sp.detail, facet, reverse)

## subset by name and facet
columns = colnames(sp.detail)
index = match(facet, columns)
summary <- subset(byFacet, select = c(Name, index))
summary

