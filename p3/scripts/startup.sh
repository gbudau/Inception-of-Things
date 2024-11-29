#/bin/sh

# Run ArgoCD
k3d cluster create develop -p 8080:80@loadbalancer -p 8888:8888@loadbalancer

# Define dev & argocd namespace
kubectl apply -f ../conf/ArgoNspace.yaml
# kubectl apply -f ../conf/DevNspace.yaml
sleep 3

# Install ArgoCD
# kubectl apply -f ../conf/ArgoDeploy.yaml
kubectl wait -n argocd --for=condition=Ready pods --all

# Deploy App
# k3d cluster create develop -p 8080:80@loadbalancer -p 8888:80@loadbalancer
kubectl apply -k ../conf
# kubectl apply -f ../conf/ArgoConf.yaml

# Create Ingress
# kubectl apply -f ../conf/ArgoIngress.yaml



# Wait for ArgoCD to be ready and show password
INTERVAL=10

echo "Waiting for the ArgoCD Admin secret to be created... (approx. 3 minute)"

while true; do
  # Get the pod status
  STATUS=$(kubectl get pod -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath="{.items[0].status.phase}" 2>/dev/null)
  
  # Check if the pod is in Running state
  if [[ "$STATUS" == "Running" ]]; then
    echo "Pod 'argocd-server' is running."
    echo "ArgoCD password:"
    kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
    echo ""
    exit 0
  fi

  if [[ "$STATUS" != "Pending" ]]; then
    echo "Something bad happened. Exiting..."
    exit 1
  fi

  echo $STATUS
  # Wait before checking again
  sleep $INTERVAL
done


