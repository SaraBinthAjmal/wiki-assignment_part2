FROM docker:26-dind

# Install dependencies
RUN apk add --no-cache \
    curl \
    bash \
    ca-certificates \
    iptables \
    libc6-compat

# Install kubectl
RUN curl -LO https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install k3d
RUN curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

WORKDIR /app

# Copy project files
COPY wiki-service ./wiki-service
COPY wiki-chart ./wiki-chart
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
