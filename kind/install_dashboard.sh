#!/bin/bash
# sudo install helm -m 0755 /usr/local/bin/helm
#helm repo remove stable

images=(
    kubernetesui/dashboard-api:1.12.0
    kubernetesui/dashboard-web:1.6.2
    kubernetesui/dashboard-auth:1.2.4
    library/kong:3.8
    kubernetesui/dashboard-metrics-scraper:1.2.2
)

for image in "${images[@]}"; do
    docker pull "$image"
    kind load docker-image "$image"
done


# 开代理
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update
# 7.12.0
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
# Congratulations! You have just installed Kubernetes Dashboard in your cluster.

# To access Dashboard run:
#   kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443

# NOTE: In case port-forward command does not work, make sure that kong service name is correct.
#       Check the services in Kubernetes Dashboard namespace using:
#         kubectl -n kubernetes-dashboard get svc

# Dashboard will be available at:
#   https://localhost:8443

kubectl get pod -n kubernetes-dashboard

# 创建service account并添加权限
kubectl -n kubernetes-dashboard create serviceaccount dashboard-user
kubectl create clusterrolebinding dashboard-admin \
  --clusterrole=cluster-admin \
  --serviceaccount=kubernetes-dashboard:dashboard-user

# 选择一：获取token(一个小时有效期)
kubectl -n kubernetes-dashboard create token dashboard-user
echo "打开 ip:8443 输入 token 登陆"

# 选择二：永久的token
cat > sa-secret.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: dashboard-user-token
  annotations:
    kubernetes.io/service-account.name: dashboard-user
type: kubernetes.io/service-account-token
EOF

kubectl apply -f sa-secret.yaml -n kubernetes-dashboard
kubectl get secret dashboard-user-token -n kubernetes-dashboard -o jsonpath='{.data.token}' | base64 -d


# 阻塞 block
kubectl -n kubernetes-dashboard port-forward --address 0.0.0.0 svc/kubernetes-dashboard-kong-proxy 8443:443