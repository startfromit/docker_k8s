#!/bin/bash
echo "==========running nginxtest, populating nginx html files to volume: nginx-vol"
docker run --rm -d \
  --name=nginxtest \
  --mount source=nginx-vol,destination=/usr/share/nginx/html \
  nginx:latest

echo "==========running docker volume inspect"
docker volume inspect nginx-vol

echo "==========runing another container with nginx-vol"
docker run --rm --name=lstest \
  --mount source=nginx-vol,target=/myvol \
  alpine ls /myvol

echo "==========cleaning..."
docker container stop nginxtest
docker container stop lstest
docker container rm nginxtest
docker container rm lstest
docker volume rm nginx-vol
