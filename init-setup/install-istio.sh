#!/bin/bash

cd /opt/ || exit
curl -L https://istio.io/downloadIstio | sh -
cd istio-* && export PATH=$PWD/bin:$PATH

istioctl install --set profile=demo -y
kubectl label namespace testingns istio-injection=enabled
