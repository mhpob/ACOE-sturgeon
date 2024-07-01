library(duckdb)
library(data.table)

con <- dbConnect(
    duckdb(),
    dbdir = "api_duckdb/result/sturg-alert.duckdb",
    read_only = FALSE
)

dbExecute(con, "CREATE TABLE alerts (fish VARCHAR, time TIMESTAMP)")

dbExecute(con, "INSERT INTO alerts VALUES (?, ?)",
    list("serge", Sys.time())
)

dbAppendTable(con, "alerts", data.table(name = 'serge2', time = Sys.time()))

dbGetQuery(con, "SELECT * FROM alerts")
dbDisconnect(con)