#!/bin/bash 


## Configuration
PHASE='okd-poc'
# sourcing the right env file
. ".env.${PHASE}"

## install all needed operators including their crd's
kubectl apply -f ./k8s-setup/operator-subscriptions/argocd.yaml
kubectl apply -f ./k8s-setup/operator-subscriptions/cert-manager.yaml

kubectl create secret generic srf-helm-charts-secret --from-file=./srf-helm-chart-private.key

## Set default cert-manager issuer
kubectl apply -f ./k8s-setup/cert-manager/cluster-issuer.yaml

## Setup ArgoCD

kubectl create namespace argocd
kubectl apply -f ./k8s-setup/argocd/openshift-argocd-role.yaml
envsubst < ./k8s-setup/argocd/argocd-server.yaml | kubectl apply -f -

kubectl apply -f ./k8s-setup/argocd/argocd-app-of-apps.yaml
