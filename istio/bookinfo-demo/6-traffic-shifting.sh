#!/usr/bin/env bash
# 50%到一个版本，50%到另一个版本，然后将100%流量切换到某个版本

# 将所有流量转到 v1
kubectl apply -f ../istio-1.26.1/samples/bookinfo/gateway-api/route-reviews-v1.yaml

# 将 50% 流量转到 v1，其余转到 v3
kubectl apply -f ../istio-1.26.1/samples/bookinfo/gateway-api/route-reviews-50-v3.yaml

# kubectl get httproute reviews -o yaml

# 将所有流量转到 v3
kubectl apply -f ../istio-1.26.1/samples/bookinfo/gateway-api/route-reviews-v3.yaml
