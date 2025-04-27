#!/bin/bash

kubectl run myapp --image=busybox:1.28 --restart=Never -- sleep 1d
kubectl debug myapp -it --image=ubuntu --share-processes --copy-to=myapp-debug

#kubectl delete pod myapp myapp-debug
