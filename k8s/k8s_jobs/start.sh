#!/bin/bash
# docker pull perl:5.34.0

kubectl apply -f ./pi.yaml
kubectl describe job pi

pods=$(kubectl get pods --selector=batch.kubernetes.io/job-name=pi --output=jsonpath='{.items[*].metadata.name}')
echo $pods