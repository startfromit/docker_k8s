#!/bin/bash
kubectl apply -f ./daemonset.yaml

kubectl get ds -n kube-system fluentd-elasticsearch