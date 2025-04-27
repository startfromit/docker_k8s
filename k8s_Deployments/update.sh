#!/bin/bash
#kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:1.16.1
kubectl set image deployment/nginx-deployment nginx=nginx:1.16.1
ubectl annotate deployment/nginx-deployment kubernetes.io/change-cause="image updated to 1.16.1"
kubectl get pods --show-labels
kubectl rollout status deployment/nginx-deployment

# 或者直接编辑deployment中的镜像地址
kubectl edit deployment/nginx-deployment

# 升级后，查看deployments和rs
kubectl get deployments
kubectl get rs
# (* main) yu@192.168.0.104:docker_k8s_learn $ kubectl get rs
# NAME                          DESIRED   CURRENT   READY   AGE
# nginx-deployment-647677fc66   0         0         0       14m
# nginx-deployment-8d94c585f    3         3         3       3m19s

# 查看总体过程
kubectl describe deployments