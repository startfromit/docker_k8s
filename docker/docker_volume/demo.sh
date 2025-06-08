#!/bin/bash
docker volume create my-vol
docker volume ls
docker volume inspect my-vol
docker volume rm my-vol
