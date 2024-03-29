#!/bin/bash
kubectl --kubeconfig="$GITHUB_WORKSPACE/config" get node
kubectl --kubeconfig="$GITHUB_WORKSPACE/config" config view

export KUBECONFIG="$GITHUB_WORKSPACE/config"
export RANDOM_HEX=$(openssl rand -hex 32)
envsubst < config.yaml.template > config.yaml

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

RELEASE=jhub
NAMESPACE=jhub

helm upgrade --cleanup-on-fail \
  --install $RELEASE jupyterhub/jupyterhub \
  --namespace $NAMESPACE \
  --create-namespace \
  --version=0.9.0 \
  --values config.yaml
  
 kubectl --namespace=jhub get svc proxy-public
