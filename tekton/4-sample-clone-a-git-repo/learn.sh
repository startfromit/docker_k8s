#!/bin/bash

# https://github.com/dev-easily/docker-auto-mirror/issues/29
# minikube image load gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.29.0
kubectl apply -f secret-git-credentials.yaml
kubectl apply -f task-git-clone.yaml
# docker tag alpine:latest alpine:local
# minikube image load alpine:local
kubectl apply -f task-show-readme.yaml
kubectl apply -f pipeline.yaml
kubectl create -f pipeline-run.yaml
kubectl get pipelinerun
kubectl describe pipelinerun clone-read-run-drf8t 
kubectl get taskrun
kubectl describe taskrun clone-read-run-drf8t-fetch-source
tkn pipelinerun logs clone-read-run-57kfr -f
kubectl logs --selector=tekton.dev/taskRun=clone-read-run-drf8t-fetch-source
kubectl logs --selector=tekton.dev/taskRun=clone-read-run-drf8t-show-readme -f

# pipelinerun 传入实际的值
# 1.param:repo-url(git@github.com:tektoncd/website.git) 
# 2.workspace:git-credentials 
# 3.workspace:shared-data:volumeclaim
# 🔽
# pipeline 定义需要的 workspace 和 param 等模板，并将 shared-data 改名成 output 或者 source 等其它任务需要的 workspace 名称
# 1.param:repo-url
# 2.workspace:git-credentials 
# 3.workspace:shared-data
# 4.tasks: task1+workspace:output(shared-data)+param, task2+workspace:source(shared-data)+param
# 🔽
# task:git-clone
# task:show-readme