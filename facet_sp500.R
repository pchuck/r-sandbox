## faceted search, correlation and plot of s&p 500 constituents
## utilizes data from data.okfn.org
##
##   accepts a facet of interest
##   and returns the top-ranked securities based on that attribute
##
SRC = "http://data.okfn.org/data/core/s-and-p-500-companies/r/constituents-financials.csv"
args <- commandArgs(trailingOnly=TRUE)

if(length(args) < 1) {
    print("usage: Rscript facet_sp500.R facet [reverse] [plot]")
    print("  e.g. Rscript facet_sp500.R Market.Cap true true")
    quit()
}

facet = args[1]
## by default, reverse sort unless otherwise specified
reverse = T
if(length(args) == 2) 
    reverse <- args[2] == "true"
## by default, don't generate plot unless otherwise specified
doPlot = F
if(length(args) == 3) 
    doPlot <- args[3] == "true"

## load the data source
loadFinancialData <- function(src) { 
    sp.detail <- read.csv(src, sep=",", header=1)
    sp.detail
}

## sort and return the constituents by the specified facet
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

## generate a plot of the top constituents share of the facet
plotFacetShare <- function(faceted, facet, index) {
    lbls = faceted$Name
    slices = faceted[, index]
    pie(slices, labels = lbls, main = paste("Top Constituents by ", facet))
}


##
## main

## load the data from the source into a data frame
sp.detail <- loadFinancialData(SRC)
    
## extract the sorted data by facet
byFacet <- sortByFacet(sp.detail, facet, reverse)

## subset by name and facet
columns = colnames(sp.detail)
index = match(facet, columns)
summary <- subset(byFacet, select = c(Name, index))
summary

## plot
if(doPlot) {
    cat("\ngenerating plot to Rplot.pdf.. ")
    plotFacetShare(byFacet, facet, index)
    cat("done\n")
}

