#!/usr/bin/env bash
# The Bookinfo application is deployed, but not accessible from the outside. To make it accessible, you need to create an ingress gateway, which maps a path to a route at the edge of your mesh.
kubectl apply -f ../istio-1.26.1/samples/bookinfo/gateway-api/bookinfo-gateway.yaml
# gateway.gateway.networking.k8s.io/bookinfo-gateway created
# httproute.gateway.networking.k8s.io/bookinfo created
# (* main) yu@192.168.0.104:bookinfo-demo $ kubectl get gateway
# NAME               CLASS   ADDRESS   PROGRAMMED   AGE
# bookinfo-gateway   istio             False        29s
# (* main) yu@192.168.0.104:bookinfo-demo $ kubectl get httproute
# NAME       HOSTNAMES   AGE
# bookinfo               35s

# Change the service type to ClusterIP by annotating the gateway:
kubectl annotate gateway bookinfo-gateway networking.istio.io/service-type=ClusterIP --namespace=default
kubectl get gateway
# NAME               CLASS   ADDRESS                                            PROGRAMMED   AGE
# bookinfo-gateway   istio   bookinfo-gateway-istio.default.svc.cluster.local   True         117s

kubectl port-forward --address 0.0.0.0 svc/bookinfo-gateway-istio 8080:80
# http://192.168.0.104:18080/productpage