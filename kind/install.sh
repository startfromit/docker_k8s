#!/bin/bash

# scp kubectl kind-linux-amd64 192.168.0.104:~
# sudo install kubectl -m 0755 /usr/local/bin/kubectl

docker pull kindest/node:v1.32.2

cat > kind-config.yaml <<EOF
# kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
kubeadmConfigPatches:
- |-
  apiVersion: kubeadm.k8s.io/v1beta3
  kind: ClusterConfiguration
  metadata:
    name: config
  imageRepository: registry.aliyuncs.com/google_containers  # 替换为阿里云镜像仓库[1,3,5](@ref)
  networking:
    serviceSubnet: 10.0.0.0/16
  nodeRegistration:
    kubeletExtraArgs:
      pod-infra-container-image: registry.aliyuncs.com/google_containers/pause:3.6  # 指定基础容器镜像[2,3](@ref)
EOF

kind create cluster --image kindest/node:v1.32.2 --config kind-config.yaml

kubectl cluster-info --context kind-kind
kubectl get nodes
