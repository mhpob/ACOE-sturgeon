FROM rocker/r-ver

RUN mkdir app && \
    cd app && \
    mkdir result

RUN R -e "install.packages(c('data.table', 'duckdb', 'plumber'))"

EXPOSE 8000

ENTRYPOINT ["R", \
            "-e", \
            "plumber::pr(rev(commandArgs())[1]) |> \
            plumber::pr_run(host = '0.0.0.0', port = 8000)"]

CMD ["~/plumber.R"]