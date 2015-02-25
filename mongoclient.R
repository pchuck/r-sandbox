#! /usr/bin/env Rscript
##
##

# install.packages("rmongodb")
library(rmongodb)
m = mongo.create()

## display information about the dbs and collections
getDbInfo <- function() {
    #print(m)

    ## fetch and display databases and collections
    dbs = mongo.get.databases(m)
    cat("dbs:", dbs, "\n")
    collections = mongo.get.database.collections(m, dbs)
    cat("collections:", collections, "\n")
}

## count documents in a collection
countDocuments <- function(m, collection) {
    count = mongo.count(m, collection)
    count 
}

## fetch a single document from the collectiondocument
## returns bson
findOne <- function(m, collection) {
    res = mongo.find.one(m, collection)
    res
}

## read and convert a collection to a dataframe
collectionToDataFrame <- function(m, collection) {
    ## query with criteria
    bson = mongo.bson.buffer.create()
#    mongo.bson.buffer.append(bson, 'lastName', 'jones')
    query = mongo.bson.from.buffer(bson)
    query

    ## convert to a dataframe
    cursor = mongo.find(m, collection, query)
    df = mongo.cursor.to.data.frame(cursor, nullToNA = TRUE)
    df
}
    
getDbInfo()
collection = 'demo.userdata'
count = countDocuments(m, collection)
cat(collection, "contains", count, "documents\n")

bson = findOne(m, collection)
print("findOne() (in bson)..")
print(bson)

resl = mongo.bson.to.list(bson)
print("as a list.. ")
print(resl)

df = collectionToDataFrame(m, collection)
print("as a data.frame.. ")
print(df)

