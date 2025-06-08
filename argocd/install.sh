#!/usr/bin/env bash
kubectl create namespace argocd
# https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# (* main) yu@192.168.0.104:argocd $ cat install.yaml | grep image: | sort -u
#         image: ghcr.io/dexidp/dex:v2.41.1
#         image: quay.io/argoproj/argocd:v3.0.5
#         image: redis:7.2.7-alpine
# https://github.com/dev-easily/docker-auto-mirror/issues/30
# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/redis:7.2.7-alpine && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/redis:7.2.7-alpine redis:7.2.7-alpine
# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/quay.io.argoproj.argocd:v3.0.5 && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/quay.io.argoproj.argocd:v3.0.5 quay.io/argoproj/argocd:v3.0.5
# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/ghcr.io.dexidp.dex:v2.41.1 && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/ghcr.io.dexidp.dex:v2.41.1 ghcr.io/dexidp/dex:v2.41.1

# minikube image load redis:7.2.7-alpine
# minikube image load quay.io/argoproj/argocd:v3.0.5
# minikube image load ghcr.io/dexidp/dex:v2.41.1
kubectl create namespace argocd

kubectl apply -n argocd -f ./install.yaml
kubectl config set-context --current --namespace=argocd
kubectl get pod

# 开启访问 https://argo-cd.readthedocs.io/en/stable/getting_started/#3-access-the-argo-cd-api-server
#kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443

kubectl get svc -n argocd

# 获取登陆密码 F-Js8UNNtcHd1ObO
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# 安装 cli
# curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
# sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
# rm argocd-linux-amd64
argocd admin initial-password -n argocd
argocd login localhost:8080

kubectl config get-contexts -o name
argocd cluster add minikube

# 创建应用
# cd ../helloworld_app
# sh build.sh
# minikube image load hello-there:local
argocd app create hello-there --repo https://github.com/startfromit/docker_k8s.git --path helloworld_app --dest-server https://kubernetes.default.svc --dest-namespace default
argocd app get hello-there
argocd app sync hello-there

# 在argocd 前端可以修改这个 svc 为 nodeport，也可以通过端口转发
kubectl get svc -n default
minikube service hello-there -n default

kubectl port-forward --address 0.0.0.0 svc/hello-there -n default 8081:80
