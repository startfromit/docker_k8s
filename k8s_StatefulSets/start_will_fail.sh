#!/bin/bash
kubectl create namespace test
kubectl apply -f ./nginx-statefulsets.yaml -n test

kubectl describe sts web -n test

# will block，因为没有pv
kubectl describe pod -n test web-0