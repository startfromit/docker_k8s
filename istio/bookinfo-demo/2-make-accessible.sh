#!/usr/bin/env bash
# The Bookinfo application is deployed, but not accessible from the outside. To make it accessible, you need to create an ingress gateway, which maps a path to a route at the edge of your mesh.
kubectl apply -f ../istio-1.26.1/samples/bookinfo/gateway-api/bookinfo-gateway.yaml
# gateway.gateway.networking.k8s.io/bookinfo-gateway created
# httproute.gateway.networking.k8s.io/bookinfo created

# 此时的 gateway 和 httproute
kubectl get gateway
# NAME               CLASS   ADDRESS   PROGRAMMED   AGE
# bookinfo-gateway   istio             False        29s
kubectl get httproute
# NAME       HOSTNAMES   AGE
# bookinfo               35s

# 此时的 service
kubectl get svc
# NAME                     TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                        AGE
# bookinfo-gateway-istio   LoadBalancer   10.0.181.31    <pending>     15021:32535/TCP,80:30942/TCP   4m17s

# Change the service type to ClusterIP by annotating the gateway: 将 LB 类型的 service 更改成 ClusterIP
kubectl annotate gateway bookinfo-gateway networking.istio.io/service-type=ClusterIP --namespace=default
kubectl get gateway
# NAME               CLASS   ADDRESS                                            PROGRAMMED   AGE
# bookinfo-gateway   istio   bookinfo-gateway-istio.default.svc.cluster.local   True         117s

# 此时的 service 从 LoadBalancer 变成了 ClusterIP
kubectl get svc
# NAME                     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)            AGE
# bookinfo-gateway-istio   ClusterIP   10.0.181.31    <none>        15021/TCP,80/TCP   5m30s

kubectl port-forward --address 0.0.0.0 svc/bookinfo-gateway-istio 8080:80
# http://192.168.0.104:18080/productpage