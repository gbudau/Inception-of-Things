#/bin/sh

# Run ArgoCD
k3d cluster create develop -p "8080:443@loadbalancer" #-p "
kubectl apply -f ../conf/ArgoNspace.yaml
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f ../conf/ArgoConf.yaml

# Define dev namespace
kubectl apply -f ../conf/DevNspace.yaml
