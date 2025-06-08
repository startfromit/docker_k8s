#!/bib/bash
kubectl scale deployment/nginx-deployment --replicas=2
kubectl get deployment nginx-deployment

# 自动伸缩
kubectl autoscale deployment/nginx-deployment --min=1 --max=3 --cpu-percent=80
