#!/bin/bash
kubectl --kubeconfig="$GITHUB_WORKSPACE/.kube/config" get node
kubectl --kubeconfig="$GITHUB_WORKSPACE/.kube/config" config view


RANDOM_HEX=$(openssl rand -hex 32)
printf "proxy:\n\tsecretToken: \"$RANDOM_HEX\"" > config.yaml
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
