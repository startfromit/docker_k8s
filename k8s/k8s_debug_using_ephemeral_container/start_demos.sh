#!/bin/bash

kubectl run ephemeral-demo --image=registry.k8s.io/pause:3.10 --restart=Never

kubectl exec -it ephemeral-demo -- sh # error, cause no shell in this container

kubectl debug -it ephemeral-demo --image=busybox:1.28 --target=ephemeral-demo

kubectl describe pod ephemeral-demo
kubectl delete pod ephemeral-demo
