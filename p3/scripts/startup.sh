#/bin/sh

# Run ArgoCD
k3d cluster create develop
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f ../conf/*.yaml


