#!/bin/bash
# enable containerd in /etc/docker/daemon.json first
docker build --platform linux/amd64,linux/arm64 -t go-server .
