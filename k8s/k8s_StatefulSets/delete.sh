#!/bin/bash

# 不会删除pod
kubectl -n test delete sts web --cascade=orphan

# 级联删除pod，但是仍然不会删除service
kubectl -n test delete sts web

kubectl -n test delete svc nginx

kubectl get pv
kubectl -n test delete pvc www-web-0 www-web-1 www-web-2 www-web-3 www-web-4
kubectl get pv
