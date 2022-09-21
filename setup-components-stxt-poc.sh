#!/bin/bash 


## Configuration
PHASE='dev'
# sourcing the right env file
. ".env.${PHASE}"


## install all needed operators including their crd's
kubectl apply -f ./k8s-setup/operator-subscriptions/argocd.yaml
kubectl create secret generic srf-helm-charts-secret --from-file=./srf-helm-chart-private.key

## Setup ArgoCD
kubectl create namespace argocd
kubectl apply -f ./k8s-setup/argocd/argocd-server.yaml
