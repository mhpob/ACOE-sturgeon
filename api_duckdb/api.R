#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(data.table)
library(duckdb)

#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.

#* @get /db
#* @serializer print
function() {
  con <- dbConnect(
  duckdb(),
  dbdir = "result/sturg-alert.duckdb",
  read_only = TRUE
)

  res <- dbGetQuery(con, "SELECT * FROM alerts")

  dbDisconnect(con)
  
  res
}

#* @post /
#* @serializer cat
function(fish = 'unknown') {
  payload <- as.data.table(fish)
  payload[, time := Sys.time()]

  con <- dbConnect(
    duckdb(),
    dbdir = "result/sturg-alert.duckdb",
    read_only = FALSE
  )
  dbAppendTable(con, "alerts", payload)
  dbDisconnect(con)
  
  paste0('Detection of ', payload$fish, ' logged at ', payload$time)
  
}


#* @get /fls
function() {
  list(
    fls = list.files(),
    res = list.files("result")
  )
}