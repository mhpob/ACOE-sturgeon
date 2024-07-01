FROM rstudio/plumber

RUN R -e "install.packages(c('data.table', 'duckdb'))"

COPY / /app