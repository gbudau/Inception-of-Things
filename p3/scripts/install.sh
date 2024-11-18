#!/bin/env bash

# Install ArgoCD
k3d cluster create develop
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f ../confs/application.yaml
# kubectl port-forward svc/argocd-server -n argocd 8080:443 &
# echo 'ArgoCD password:' $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
# curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
# sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
# rm argocd-linux-amd64
# argocd login $(kubectl get service argocd-server -n argocd --output=jsonpath='{.status.loadBalancer.ingress[0].hostname}') --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) --insecure
