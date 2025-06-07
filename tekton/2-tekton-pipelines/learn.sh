#!/bin/bash
kubectl apply -f ./hello-goodbye-pipeline.yaml
kubectl apply -f ./hello-goodbye-pipeline-run.yaml
kubectl get pipelinerun
kubectl logs --selector=tekton.dev/pipelineRun=hello-goodbye-run
