#!/bin/bash
docker build . # auth error


eval $(ssh-agent)
ssh-add ~/.ssh/id_ecdsa
docker build --ssh default .
