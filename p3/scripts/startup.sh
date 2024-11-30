#/bin/sh

# Starts the cluster
k3d cluster create develop -p 8080:80@loadbalancer

# Deploys Namespaces
kubectl apply -f ../conf/Namespaces
sleep 3

# Deploys ArgoCD app & conf
kubectl apply -k ../conf/ArgoCD


# Wait for ArgoCD to be ready and show password
INTERVAL=10  # Check every 5 seconds

echo "Waiting for the ArgoCD Admin secret to be created... (approx. 3 minute)"

while true; do
  sleep $INTERVAL

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
done


