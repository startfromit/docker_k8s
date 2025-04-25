#!/bin/bash

# target不存在会失败
docker run -d \
  -it \
  --name devtest \
  --mount type=bind,source="$(pwd)"/target,target=/app \
  nginx:latest

docker inspect -f "{{json .Mounts}}" devtest|jq
docker container stop devtest
docker container rm -fv devtest

# target不存在会创建
docker run -d \
  -it \
  --name devtest \
  -v "$(pwd)"/target:/app \
  nginx:latest

docker inspect -f "{{json .Mounts}}" devtest|jq
docker container stop devtest
docker container rm -fv devtest
