#!/usr/bin/env bash
# To test the Bookinfo application microservices for resiliency, inject a 7s delay between the reviews:v2 and ratings microservices for user jason. This test will uncover a bug that was intentionally introduced into the Bookinfo app.

kubectl apply -f ../istio-1.26.1/samples/bookinfo/networking/virtual-service-ratings-test-delay.yaml
