#!/bin/bash
set -e


# Start Docker-in-Docker
dockerd &

# Wait for dockerd to be ready
while(! docker info > /dev/null 2>&1); do
    echo "Waiting for Docker..."
    sleep 2
done

echo "Docker is ready"

# Create k3d cluster
k3d cluster create wiki-cluster --servers 1 --agents 1 --ports "8080:80@loadbalancer"


# Load FastAPI image into k3d 
docker build -t wiki-service:latest ./wiki-service
k3d image import wiki-service:latest -c wiki-cluster

# Install Helm chart
helm repo add stable https://charts.helm.sh/stable || true
helm install wiki ./wiki-chart --set fastapi.image_name=wiki-service:latest

#keep container alive
tail -f /dev/null