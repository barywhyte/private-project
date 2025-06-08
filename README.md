# Infrastructure, Kubernetes, CI/CD, and Monitoring Setup

This repository implements a full GitOps-based environment with declarative infrastructure provisioning, K3s-powered Kubernetes, automated CI/CD, RBAC, and monitoring — all managed with Helm and ArgoCD.

```
  A[Terraform (Infra Branch)] --> B[K3s Cluster: 1 Master, 2 Workers]
  B --> C[Cert Manager]
  B --> D[Ingress NGINX]
  B --> E[ArgoCD (App of Apps)]
  E --> F[App Deployment (Helm)]
  F --> G[Django App & API Gateway]
  E --> H[Prometheus Monitoring]
  G --> I[Network Policies & RBAC]
  G --> J[CI/CD via GitLab Pipeline]
  ```

Master Node boots K3s via cloud-init and registers worker nodes.

Ingress & TLS managed by ingress-nginx and cert-manager.

ArgoCD pulls and applies all application and infra Helm charts (no kubectl apply).

GitLab CI builds, pushes images, and optionally triggers ArgoCD sync.

# Tools Used & Justifications

| Tool             | Purpose                                     | Justification                                                                      |
|------------------|---------------------------------------------|-------------------------------------------------------------------------------     |
| **K3s**          | Lightweight Kubernetes distribution          | Chosen for simplicity, speed, and low resource footprint in VM-based setup.       |
| **Terraform**    | Infrastructure provisioning                  | Enables declarative VM and network provisioning across environments.              |
| **Helm**         | Kubernetes resource templating and packaging | Simplifies deployment and reuse of app and infrastructure manifests.              |
| **ArgoCD**       | GitOps-based Continuous Delivery             | Pulls manifests from Git and syncs them with the cluster declaratively.           |
| **GitLab CI**    | Continuous Integration and container builds  | Automates Docker builds, tests, and artifact versioning from the main branch.     |
| **cert-manager** | TLS certificate automation                   | Automatically issues and renews Let's Encrypt certificates via ACME.              |
| **ingress-nginx**| HTTP Ingress controller for Kubernetes       | Provides routing, TLS termination, and L7 load balancing capabilities.            |
| **Prometheus**   | Metrics collection and monitoring            | Deployed via Helm to monitor cluster and application health.                      |
| **RBAC (K8s)**   | Role-based access control                    | Ensures least-privilege access to resources using Roles and Bindings.             |
| **Grafana**      | Metrics visualization on dashboard           | Deployed via helm for cluster and application metrics monitoring and visualization|



# Setup Instructions
# 1. Provision Infrastructure & Kubernetes

# Navigate to infra branch
`git checkout infra`

# Initialize and apply Terraform (requires valid cloud provider credentials)
```
cd terraform
terraform init
terraform apply
```

Cloud-init automatically bootstraps the master node and joins workers to form the K3s cluster. If this fails, see [Infra Branch README](https://gitlab.com/barywhyte/private-pro/-/blob/infra/README.md?ref_type=heads) for help.

# 2. Install Base Cluster Addons (cert-manager, ingress-nginx)
```
 Install cert-manager
cd ../cert-manager
bash install.sh

 Install ingress-nginx
cd ../ingress-nginx
bash install.sh
```
# 3. Deploy ArgoCD & Applications
```
# Checkout operations branch
git checkout operations

# Then apply root-app.yml to trigger the App of Apps pattern
kubectl apply -f argocd/root-app.yml
```

This will deploy:

    Django API app from main branch (via Helm chart).

    Monitoring stack (Prometheus).

    Any RBAC/NetworkPolicy configurations.

# 4. Configure RBAC Policies
```
RBAC templates live in:
operations/api/templates/

    cluster-auditor-role.yaml

    cluster-auditor-binding.yaml

    api-dev-role.yaml

    api-dev-binding.yaml
```

# 5. Set Up CI/CD Pipeline (Main Branch)

     Trigger pipeline with any push to main.
    .gitlab-ci.yml handles:

        Docker image build

        Push to container registry

        Push triggers ArgoCD webhook sync


# 6. Accessing the Monitoring Stack

    Prometheus/Grafana is deployed via ArgoCD from monitoring.yml.

    Exposed via ingress at: https://barygrafana.duckdns.org. Requires authentication

    Requires ingress setup and valid TLS from cert-manager.


# Branch Overview

| Branch      | Purpose                                                                                                                                      |
|-------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `infra`     | Contains Terraform code for provisioning VMs, cloud-init scripts for K3s setup, cert-manager and ingress-nginx installation.                |
| `main`      | Stores the Django application code, Dockerfile, GitLab CI/CD pipeline configuration, and application Helm chart.                            |
| `operations`| Hosts all ArgoCD-related Helm charts, including the app-of-apps setup and monitoring stack (e.g., Prometheus).                              |


# Exposed Applications Endpoints
```
https://barywhyt.duckdns.org/info
https://barywhyt.duckdns.org/health
```

# Continuous Delivery Platform (Argocd)
`https://argocdbary.duckdns.org` Requires authentication