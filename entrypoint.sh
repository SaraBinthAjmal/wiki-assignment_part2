#!/bin/sh
set -e

echo "Starting Docker daemon..."
dockerd-entrypoint.sh &

# Wait for Docker
until docker info >/dev/null 2>&1; do
  sleep 1
done

echo "Docker is ready"

# Create k3d cluster (IMPORTANT: no host port binding)
k3d cluster create wiki-cluster \
  --agents 1 \
  -p "8080:80@loadbalancer" \
  --k3s-arg "--disable=traefik@server:*"

export KUBECONFIG="$(k3d kubeconfig write wiki-cluster)"

# Wait for cluster
kubectl wait --for=condition=Ready node --all --timeout=120s

# Deploy Helm chart
helm upgrade --install wiki ./wiki-chart

echo "Cluster is up. Holding container..."
tail -f /dev/null
