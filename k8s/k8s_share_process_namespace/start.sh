#!/bin/bash

docker pull nginx
kind load docker-image nginx

kubectl apply -f ./example.yaml

kubectl get pod

# nginx pod中的 shell 容器可以看到 nginx 容器中的进程, 甚至文件系统, https://kubernetes.io/docs/tasks/configure-pod-container/share-process-namespace/#configure-a-pod
kubectl exec -it nginx -c shell -- sh

