#!/bin/bash
kubectl create namespace test
kubectl apply -f ./job.yaml -n test
kubectl get pod -n test
while true;do
  kubectl logs --selector=job-name=hello -n test
  sleep 1
done
