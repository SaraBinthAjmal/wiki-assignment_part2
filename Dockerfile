# Use Docker-in-Docker as base
FROM docker:26-dind

# Install required tools: bash, curl, k3d, kubectl, helm
RUN apk add --no-cache bash curl git wget tar gzip

# Install k3d
RUN wget -q -O /usr/local/bin/k3d https://github.com/k3d-io/k3d/releases/download/v5.7.0/k3d-linux-amd64 \
    && chmod +x /usr/local/bin/k3d 

# install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Install Helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Copy your application and chart
COPY wiki-service /app/wiki-service
COPY wiki-chart /app/wiki-chart
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

WORKDIR /app

# Expose port 8080 for all endpoints
EXPOSE 8080

# Run entrypoint
ENTRYPOINT [ "/app/entrypoint.sh" ]
