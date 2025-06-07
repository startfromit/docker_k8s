#!/bin/bash
# 定义
kubectl apply -f hello-world.yaml
# 执行, 需要 alpine 镜像
# minikube image load alpine:latest
kubectl apply -f hello-world-run.yaml
kubectl get taskrun hello-task-run
kubectl logs --selector=tekton.dev/taskRun=hello-task-run
