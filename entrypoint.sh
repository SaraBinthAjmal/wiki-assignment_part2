#!/bin/bash
set -e

# Start Docker-in-Docker
dockerd &

# Wait for dockerd
while(! docker info > /dev/null 2>&1); do
    echo "Waiting for Docker..."
    sleep 2
done
echo "Docker is ready"

# Create k3d cluster with port 8080 mapped
k3d cluster create wiki-cluster \
    --agents 1 \
    --port "8080:80@loadbalancer" \
    --wait

# Build and load FastAPI image into k3d
docker build -t wiki-service:latest ./wiki-service
k3d image import wiki-service:latest -c wiki-cluster

# Configure kubeconfig
export KUBECONFIG=$(k3d kubeconfig get wiki-cluster)

# Install Helm chart
helm install wiki ./wiki-chart --set fastapi.image_name=wiki-service:latest

# Wait for FastAPI pod to be running
echo "Waiting for FastAPI pod..."
kubectl wait --for=condition=Ready pod -l app=fastapi --timeout=120s

# Pre-hit FastAPI endpoints to generate metrics
echo "Seeding metrics..."
curl -s http://localhost:8080/users > /dev/null
curl -s http://localhost:8080/posts > /dev/null

# Keep container alive
echo "Cluster is running. Services available on port 8080."
tail -f /dev/null