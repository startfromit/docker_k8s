#!/usr/bin/env bash
# istioctl
# curl -L https://istio.io/downloadIstio | sh -
# export PATH="$PATH:/home/yu/Projects/docker_k8s/istio/istio-1.26.1/bin"

# install istiod
docker pull docker.io/istio/pilot:1.26.1
kind load docker-image docker.io/istio/pilot:1.26.1
cd istio-1.26.1
istioctl install -f samples/bookinfo/demo-profile-no-gateways.yaml -y
kubectl get pod -n istio-system
kubectl label namespace default istio-injection=enabled
kubectl get ns default -o yaml

# install kubeneted gateway api crds if not present
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
{ kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.3.0" | kubectl apply -f -; }

# 以上命令如果因为网络问题卡住，执行以下命令
kubectl kustomize gateway_crds/ | kubectl apply -f -