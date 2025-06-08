#!/bin/bash

kubectl apply -f ./run-my-nginx.yaml

kubectl get pods -l run=my-nginx -o wide

kubectl get pods -l run=my-nginx -o custom-columns=POD_IP:.status.podIPs

# 等同于创建一个如下的 Service
# apiVersion: v1
# kind: Service
# metadata:
#   name: my-nginx
#   labels:
#     run: my-nginx
# spec:
#   ports:
#   - port: 80
#     protocol: TCP
#   selector:
#     run: my-nginx
kubectl expose deployment/my-nginx
kubectl get svc my-nginx

# Endpoints 中会显示上面的两个 pod ip
kubectl describe svc my-nginx
kubectl get endpointslices -l kubernetes.io/service-name=my-nginx

# 在节点上可以 curl 上面的 cluster ip

# 一：通过环境变量访问 service
# 在创建 service 之前创建的 replicaset 变量里面没有 service 相关信息
# (* main) yu@192.168.0.104:k8s_services $ kubectl get pod
# NAME                        READY   STATUS    RESTARTS   AGE
# my-nginx-77b9c67898-9bh77   1/1     Running   0          12m
# my-nginx-77b9c67898-qwhmm   1/1     Running   0          12m
# (* main) yu@192.168.0.104:k8s_services $ kubectl exec my-nginx-77b9c67898-9bh77 -- printenv

# 这样就有了
# kubectl exec my-nginx-77b9c67898-7pjhg -- printenv | grep SERVICE
# KUBERNETES_SERVICE_PORT=443
# MY_NGINX_SERVICE_HOST=10.0.112.226
# KUBERNETES_SERVICE_HOST=10.0.0.1
# MY_NGINX_SERVICE_PORT=80
# KUBERNETES_SERVICE_PORT_HTTPS=443
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=2;
kubectl get pods -l run=my-nginx -o wide
kubectl exec my-nginx-77b9c67898-7pjhg -- printenv | grep SERVICE


# 二：通过 DNS 访问 service
kubectl get services kube-dns --namespace=kube-system
kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm
nslookup my-nginx