#!/usr/bin/env bash
# kiali, Prometheus, Grafana, Jaeger

# grep "image: " ../istio-1.26.1/samples/addons/ -hr|cut -d : -f 2-
images=(
 "kiwigrid/k8s-sidecar:1.30.2"
 docker.io/grafana/loki:3.4.2
 "quay.io/kiali/kiali:v2.8"
 "docker.io/jaegertracing/all-in-one:1.67.0"
 "docker.io/grafana/grafana:11.3.1"
 apache/skywalking-oap-server:9.7.0
 apache/skywalking-ui:9.1.0
 openzipkin/zipkin-slim:3.4.0
 "ghcr.io/prometheus-operator/prometheus-config-reloader:v0.81.0"
 "prom/prometheus:v3.2.1"
)

for image in ${images[@]};do
    docker pull $image
    kind load docker-image $image
done
