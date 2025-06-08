#!/bin/bash
kubectl rollout history deployment/nginx-deployment
kubectl rollout history deployment/nginx-deployment --revision=2
kubectl rollout undo
kubectl rollout undo deployment/nginx-deployment --to-revision=2
