#!/bin/bash
kubectl create namespace test
kubectl apply -f ./nginx-with-pv.yaml -n test

kubectl describe sts web -n test

# will block，因为没有pv
kubectl describe pod -n test web-0

kubectl get pod -n test

# watch
kubectl get pods --watch -l app=nginx -n test

# service
kubectl -n test get svc

# pv
kubectl get pvc,pv

# (* main) yu@192.168.0.104:k8s_StatefulSets $ kubectl get -n test pvc,pv
# NAME                              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
# persistentvolumeclaim/www-web-0   Bound    pvc-1923314e-7557-4012-8594-1a320ec338ad   1Gi        RWO            standard       <unset>                 54s
# persistentvolumeclaim/www-web-1   Bound    pvc-4e7a3b19-ccf5-4b4f-80a0-716bd6716354   1Gi        RWO            standard       <unset>                 40s
# 
# NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM            STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
# persistentvolume/pvc-1923314e-7557-4012-8594-1a320ec338ad   1Gi        RWO            Delete           Bound    test/www-web-0   standard       <unset>                          51s
# persistentvolume/pvc-4e7a3b19-ccf5-4b4f-80a0-716bd6716354   1Gi        RWO            Delete           Bound    test/www-web-1   standard       <unset>                          36s
kubectl get pvc -l app=nginx -n test
kubectl describe pv pvc-1923314e-7557-4012-8594-1a320ec338ad

for i in 0 1; do kubectl -n test exec "web-$i" -- sh -c 'echo "hello, $(hostname)" > /usr/share/nginx/html/index.html'; done
for i in 0 1; do kubectl -n test exec -i -t "web-$i" -- curl http://localhost/; done
# 验证数据持久化了
kubectl -n test delete pod -l app=nginx
for i in 0 1; do kubectl -n test exec -i -t "web-$i" -- curl http://localhost/; done

# pods
kubectl get pods -l app=nginx -n test
for i in 0 1; do kubectl -n test exec "web-$i" -- sh -c 'hostname'; done

# dns
kubectl -n test run -i --tty --image busybox:1.28 dns-test --restart=Never --rm
nslookup web-0.nginx

# (not a git repo) yu@192.168.0.104:create_a_deployment $ kubectl -n test run -i --tty -
# -image busybox:1.28 dns-test --restart=Never --rm
# If you don't see a command prompt, try pressing enter.
# / # nslookup web-0.nginx
# Server:    10.0.0.10
# Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local
# 
# Name:      web-0.nginx
# Address 1: 10.244.2.11 web-0.nginx.test.svc.cluster.local
