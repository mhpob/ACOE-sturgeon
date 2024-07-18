
docker build -t sturgeon_alert `pwd`/api_duckdb


## run the image

docker run --name sturgeon_alert --rm -p 20619:8000 -w /app  \
    -v `pwd`/api_duckdb/result:/app/result -v `pwd`/api_duckdb/api.R:/app/api.R \
    sturgeon_alert 

# docker comes first, then run, then options
# then comes the image ("plumber")
# then commands.
# In this image, the "command" is the file in the container that should be plumbed.
# Since the wd in the container was specified to be /app via -w /app, the file to be plumbed is api.R


docker run -it --rm --entrypoint /bin/bash -w /app plumber_db 

curl -w '\n' http://localhost:20619/fls
curl -w '\n' http://localhost:20619/db
curl -w '\n' http://localhost:20619/ -d "fish=boi_pool"