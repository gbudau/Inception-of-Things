#/bin/sh

# Run ArgoCD
k3d cluster create develop -p 8080:80@loadbalancer -p 8888:8888@loadbalancer
kubectl apply -f ../conf/ArgoNspace.yaml
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f ../conf/ArgoConf.yaml

# Define dev namespace
kubectl apply -f ../conf/DevNspace.yaml


# Wait for ArgoCD to be ready and show password
TIMEOUT=360  # Timeout in seconds
INTERVAL=5  # Check every 5 seconds

echo "Waiting for pod 'argocd-server' in namespace 'argocd' to be in 'Running' state..."

# Initialize timer
START_TIME=$(date +%s)

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

  echo $STATUS
  # Wait before checking again
  sleep $INTERVAL
done


