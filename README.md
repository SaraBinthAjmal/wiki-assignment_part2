# wiki-assignment_part2

This is part 2 from wiki-assignment

## Docker in Docker + k3d setup
This is a Docker-in-Docker (DinD) + k3d setup where everything (K3s cluster, Helm chart, FastAPI app, Grafana, Prometheus) runs inside one Docker container, and port 8080 on the container exposes all endpoints.