#!/usr/bin/env bash

images=(
docker.io/istio/proxyv2:1.26.1
docker.io/istio/examples-bookinfo-productpage-v1:1.20.3
docker.io/istio/examples-bookinfo-details-v1:1.20.3
docker.io/istio/examples-bookinfo-ratings-v1:1.20.3
docker.io/istio/examples-bookinfo-reviews-v1:1.20.3
docker.io/istio/examples-bookinfo-reviews-v2:1.20.3
docker.io/istio/examples-bookinfo-reviews-v3:1.20.3
)

for image in ${images[@]};do
    docker pull $image
    kind load docker-image $image
done

kubectl apply -f ../istio-1.26.1/samples/bookinfo/platform/kube/bookinfo.yaml

# service/details created
# serviceaccount/bookinfo-details created
# deployment.apps/details-v1 created
# service/ratings created
# serviceaccount/bookinfo-ratings created
# deployment.apps/ratings-v1 created
# service/reviews created
# serviceaccount/bookinfo-reviews created
# deployment.apps/reviews-v1 created
# deployment.apps/reviews-v2 created
# deployment.apps/reviews-v3 created
# service/productpage created
# serviceaccount/bookinfo-productpage created
# deployment.apps/productpage-v1 created


kubectl get pod
# NAME                              READY   STATUS    RESTARTS   AGE
# details-v1-766844796b-fvgn4       2/2     Running   0          13m
# productpage-v1-54bb874995-s55qq   2/2     Running   0          3m52s
# ratings-v1-5dc79b6bcd-v678q       2/2     Running   0          13m
# reviews-v1-598b896c9d-xsgtp       2/2     Running   0          3m52s
# reviews-v2-556d6457d-5h56p        2/2     Running   0          13m
# reviews-v3-564544b4d6-ptcfz       2/2     Running   0          3m52s

kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"