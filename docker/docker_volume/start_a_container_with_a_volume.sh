#!/bin/bash

docker run -d --name devtest --mount source=myvol2,target=/app nginx:latest
docker inspect -f '{{json .Mounts}}' devtest|jq

docker container stop devtest
docker container rm devtest
docker volume rm myvol2
