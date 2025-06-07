#!/bin/bash
minikube image load gcr.io/k8s-minikube/kicbase:v0.0.47
minikube start --kubernetes-version v1.30.2
# install pipeline
# https://tekton.dev/docs/getting-started/tasks/
# https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
sed "s/ghcr.io/ghcr.nju.edu.cn/g" -i *.yaml
kubectl apply -f ./pipeline.yaml
kubectl get pods -n tekton-pipelines --watch
# install triggers
# https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
# https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
sed "s/ghcr.io/ghcr.nju.edu.cn/g" -i *.yaml
kubectl apply -f ./triggers.yaml
kubectl apply -f ./triggers_interceptors.yaml
kubectl get pods -n tekton-pipelines --watch

kubectl get pods -n tekton-pipelines
kubectl delete pods --all --force -n tekton-pipelines
