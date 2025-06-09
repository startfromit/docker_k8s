#!/usr/bin/env bash
kubectl -n istio-system get svc prometheus
kubectl -n istio-system get svc grafana
istioctl dashboard grafana --address 192.168.0.166 

# Home > Dashboards > istio > Istio Mesh Dashboard
# Home > Dashboards > istio > Istio Service Dashboard