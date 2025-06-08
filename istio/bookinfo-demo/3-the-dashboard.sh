#!/usr/bin/env bash
# https://istio.io/latest/docs/setup/getting-started/#dashboard
# kiali, Prometheus, Grafana, Jaeger

# grep "image: " ../istio-1.26.1/samples/addons/ -hr|cut -d : -f 2-
# https://github.com/dev-easily/docker-auto-mirror/issues/31

# images=(
#  "kiwigrid/k8s-sidecar:1.30.2"
#  "docker.io/grafana/loki:3.4.2"
#  "quay.io/kiali/kiali:v2.8"
#  "docker.io/jaegertracing/all-in-one:1.67.0"
#  "docker.io/grafana/grafana:11.3.1"
#  "apache/skywalking-oap-server:9.7.0"
#  "apache/skywalking-ui:9.1.0"
#  "openzipkin/zipkin-slim:3.4.0"
#  "ghcr.io/prometheus-operator/prometheus-config-reloader:v0.81.0"
#  "prom/prometheus:v3.2.1"
# )
# 
# for image in ${images[@]};do
#     docker pull $image
#     kind load docker-image $image
# done

# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/ghcr.io.prometheus-operator.prometheus-config-reloader:v0.81.0 && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/ghcr.io.prometheus-operator.prometheus-config-reloader:v0.81.0 ghcr.io/prometheus-operator/prometheus-config-reloader:v0.81.0
# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/prom.prometheus:v3.2.1 && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/prom.prometheus:v3.2.1 prom/prometheus:v3.2.1
# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/docker.io.grafana.loki:3.4.2 && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/docker.io.grafana.loki:3.4.2 docker.io/grafana/loki:3.4.2
# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/apache.skywalking-ui:9.1.0 && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/apache.skywalking-ui:9.1.0 apache/skywalking-ui:9.1.0
# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/openzipkin.zipkin-slim:3.4.0 && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/openzipkin.zipkin-slim:3.4.0 openzipkin/zipkin-slim:3.4.0
# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/docker.io.jaegertracing.all-in-one:1.67.0 && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/docker.io.jaegertracing.all-in-one:1.67.0 docker.io/jaegertracing/all-in-one:1.67.0
# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/kiwigrid.k8s-sidecar:1.30.2 && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/kiwigrid.k8s-sidecar:1.30.2 kiwigrid/k8s-sidecar:1.30.2
# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/quay.io.kiali.kiali:v2.8 && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/quay.io.kiali.kiali:v2.8 quay.io/kiali/kiali:v2.8
# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/docker.io.grafana.grafana:11.3.1 && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/docker.io.grafana.grafana:11.3.1 docker.io/grafana/grafana:11.3.1
# docker pull registry.cn-hangzhou.aliyuncs.com/eliteunited/apache.skywalking-oap-server:9.7.0 && docker tag registry.cn-hangzhou.aliyuncs.com/eliteunited/apache.skywalking-oap-server:9.7.0 apache/skywalking-oap-server:9.7.0

kubectl apply -f ../istio-1.26.1/samples/addons
kubectl rollout status deployment/kiali -n istio-system
kubectl get pod -n istio-system

# grafana-65bfb5f855-snjm8      1/1     Running   0          87s
# istiod-6947584d6-dfsr2        1/1     Running   0          29m
# jaeger-868fbc75d7-pqjf6       1/1     Running   0          87s
# kiali-6d774d8bb8-chw94        1/1     Running   0          87s
# loki-0                        2/2     Running   0          87s
# prometheus-689cc795d4-722kl   2/2     Running   0          87s

# 打开 kiali 等
istioctl dashboard kiali --address 192.168.0.166 # 本机 ip
istioctl dashboard grafana --address 192.168.0.166 # 本机 ip
istioctl dashboard jaeger --address 192.168.0.166 # 本机 ip
istioctl dashboard prometheus --address 192.168.0.166 # 本机 ip
# 打开上节的 bookinfo 应用转发
kubectl port-forward --address 0.0.0.0 svc/bookinfo-gateway-istio 8080:80
# 并访问一百次
for i in $(seq 1 100); do curl -s -o /dev/null "http://192.168.0.166:8080/productpage"; done