
docker build -t plumber .


## run the image

docker run --rm -p 20688:8000 -w /app  -v `pwd`/result:/app/result -v `pwd`/api.R:/app/api.R plumber api.R

# docker comes first, then run, then options
# then comes the image ("plumber")
# then commands.
# In this image, the "command" is the file in the container that should be plumbed.
# Since the wd in the container was specified to be /app via -w /app, the file to be plumbed is api.R


docker run -it --rm --entrypoint /bin/bash  plumber 