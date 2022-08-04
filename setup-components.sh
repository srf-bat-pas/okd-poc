#!/bin/bash 


## Configuration
PHASE='dev'
# sourcing the right env file
. ".env.${PHASE}"


## Setup Azure AD
kubectl create secret generic azure-client-secret --from-literal=clientSecret=${AZURE_OIDC_CLIENT_SECRET} -n openshift-config
kubectl apply -f ./k8s-setup/ad-login/oauth.yaml


## install all needed operators including their crd's
kubectl apply -f ./k8s-setup/operator-subscriptions/external-secrets.yaml
kubectl apply -f ./k8s-setup/operator-subscriptions/argocd.yaml
kubectl apply -f ./k8s-setup/operator-subscriptions/cert-manager.yaml
kubectl apply -f ./k8s-setup/operator-subscriptions/strimzi.yaml


## external secrets setup
# aws access key as k8s secret
echo -n ${AWS_SECRETSMANAGER_KEY_ID} > ./access-key
echo -n ${AWS_SECRETSMANAGER_KEY_SECRET} > ./secret-access-key
kubectl create secret generic awssm-reader --from-file=./access-key  --from-file=./secret-access-key -n openshift-operators
rm ./access-key ./secret-access-key

# setup a cluster-wide store and a operator config processing it
kubectl apply -f ./k8s-setup/external-secrets/operator-config.yaml
kubectl apply -f ./k8s-setup/external-secrets/cluster-secret-store.yaml


## Setup ArgoCD
kubectl create namespace argocd
kubectl apply -f ./k8s-setup/argocd/argocd-repo-secret.yaml
kubectl apply -f ./k8s-setup/argocd/argocd-server.yaml
kubectl apply -f ./k8s-setup/argocd/argocd-app-of-apps.yaml
