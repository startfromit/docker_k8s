#!/bin/bash
kubectl apply -f ./nginx-deployment.yaml
kubectl get deployments
kubectl get pods
kubectl rollout status deployment/nginx-deployment
kubectl get pods --show-labels