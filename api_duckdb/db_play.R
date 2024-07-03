library(duckdb)
library(data.table)
library(pool)

con <- dbPool(
    drv = duckdb(),
    dbdir = "api_duckdb/result/sturg-alert.duckdb",
    read_only = FALSE
)

poolClose(con)

dbExecute(con, "CREATE TABLE alerts (fish VARCHAR, time TIMESTAMP)")

dbExecute(con, "INSERT INTO alerts VALUES (?, ?)",
    list("serge", Sys.time())
)

dbAppendTable(con, "alerts", data.table(name = 'serge2', time = Sys.time()))

dbGetQuery(con, "SELECT * FROM alerts")
dbDisconnect(con)