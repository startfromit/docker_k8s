#!/bin/bash
# install pipeline
# https://tekton.dev/docs/getting-started/tasks/
# https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl apply -f ./pipeline.yaml
kubectl get pods -n tekton-pipelines --watch
# install triggers
# https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
# https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
kubectl get pods -n tekton-pipelines --watch
