#/bin/sh

# Run ArgoCD
k3d cluster create develop -p 80:80@loadbalancer -p 8888:8888@loadbalancer
kubectl apply -f ../conf/ArgoNspace.yaml
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f ../conf/ArgoConf.yaml

# Define dev namespace
kubectl apply -f ../conf/DevNspace.yaml

echo 'ArgoCD password:'
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

