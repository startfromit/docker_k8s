#!/usr/bin/env bash

# 定义版本
# https://istio.io/latest/docs/examples/bookinfo/#define-the-service-versions
kubectl apply -f ../istio-1.26.1/samples/bookinfo/platform/kube/bookinfo-versions.yaml

# 创建规则，全部路由到 reviews-v1
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: reviews
spec:
  parentRefs:
  - group: ""
    kind: Service
    name: reviews
    port: 9080
  rules:
  - backendRefs:
    - name: reviews-v1
      port: 9080
EOF

# 显示规则
kubectl get httproute reviews -o yaml | grep -C 2 Accepted

# 所有来自 json 用户的请求都转发到 review-v2
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: reviews
spec:
  parentRefs:
  - group: ""
    kind: Service
    name: reviews
    port: 9080
  rules:
  - matches:
    - headers:
      - name: end-user
        value: jason
    backendRefs:
    - name: reviews-v2
      port: 9080
  - backendRefs:
    - name: reviews-v1
      port: 9080
EOF

kubectl delete httproute reviews