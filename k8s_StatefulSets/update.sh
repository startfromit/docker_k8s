#!/bin/bash
# another terminal
# kubectl -n test get pod -l app=nginx --watch

# 先升级web-1，再升级web-0
kubectl -n test patch statefulset web --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"registry.k8s.io/nginx-slim:0.24"}]'

kubectl -n test scale sts web --replicas=5
# 分区/分阶段升级/金丝雀发布
#   增加一个分区
kubectl -n test patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":3}}}}'
#   只有web-4和web-3会升级(大于等于partition)
kubectl -n test patch statefulset web --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"registry.k8s.io/nginx-slim:0.21"}]'
#   即使擅长web-2也不会升级
kubectl -n test delete pod web-2
kubectl -n test get pod web-2 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'

# 此时将partition改为2，web-2就会升级
kubectl -n test patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":2}}}}'

# 将partition设置为0，将剩下的pod全部升级
kubectl -n test patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":0}}}}'
for p in 0 1 2; do kubectl -n test get pod "web-$p" --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'; echo; done
