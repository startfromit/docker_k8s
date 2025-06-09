#!/usr/bin/env bash
kubectl -n istio-system get svc prometheus

istioctl dashboard prometheus --address 192.168.0.166 

# https://istio.io/latest/docs/tasks/observability/metrics/querying-metrics/

# istio_requests_total
# istio_requests_total{destination_service="productpage.default.svc.cluster.local"}
# istio_requests_total{destination_service="reviews.default.svc.cluster.local", destination_version="v3"}
# rate(istio_requests_total{destination_service=~"productpage.*", response_code="200"}[5m])

# https://prometheus.io/docs/prometheus/latest/querying/basics/