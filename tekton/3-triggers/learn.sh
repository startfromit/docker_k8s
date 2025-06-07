#!/bin/bash
# ubuntu todo
docker tag alpine:latest alpine:local
minikube image load alpine:local
kubectl apply -f ./hello-world.yaml
kubectl apply -f ./goodbye-world.yaml
kubectl apply -f ./hello-goodbye-pipeline.yaml
kubectl apply -f ./rbac.yaml
kubectl apply -f ./trigger-binding.yaml
kubectl apply -f ./trigger-template.yaml
kubectl apply -f ./event-listener.yaml
# 在kubectl get pod显示 el-hello-listener是 running 之后，打开一个终端
kubectl port-forward service/el-hello-listener 8080
# 在另一个终端执行
curl -v \
   -H 'content-Type: application/json' \
   -d '{"username": "Tekton"}' \
   http://localhost:8080


kubectl get pipelineruns

kubectl get taskrun
kubectl describe taskrun hello-goodbye-run-cr2tx-hello
tkn pipelinerun logs hello-goodbye-run-cr2tx-hello -f
