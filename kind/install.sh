#!/bin/bash

# 准备
# (not a git repo) yu@Mars:Downloads $ ls -1
# cni-plugins-linux-amd64-v1.7.1.tgz
# crictl
# helm-v3.17.3-linux-amd64.tar.gz
# kind-linux-amd64
# kubeadm
# kubectl
# kubelet
# (not a git repo) yu@Mars:Downloads $ scp * 192.168.0.27:~

docker pull kindest/node:v1.32.2

cat > kind-config.yaml <<EOF
# kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "192.168.0.104"  # 允许外部访问，不要使用0.0.0.0，helm会无法访问
  apiServerPort: 6443 # 固定端口
  serviceSubnet: 10.0.0.0/16
nodes:
  - role: control-plane
  - role: worker
  - role: worker
  - role: worker
kubeadmConfigPatches:
- |-
  apiVersion: kubeadm.k8s.io/v1beta3
  kind: ClusterConfiguration
  metadata:
    name: config
  imageRepository: registry.aliyuncs.com/google_containers  # 替换为阿里云镜像仓库[1,3,5](@ref)
  nodeRegistration:
    kubeletExtraArgs:
      pod-infra-container-image: registry.aliyuncs.com/google_containers/pause:3.10  # 指定基础容器镜像[2,3](@ref)
EOF

kind create cluster --image kindest/node:v1.32.2 --config kind-config.yaml

kubectl cluster-info --context kind-kind
kubectl get nodes
