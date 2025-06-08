# GitOps & ArgoCD Deployment (operations)

This branch handles:

- ArgoCD App-of-Apps setup.
- Helm chart for deploying the Django app.
- Monitoring configuration (e.g., Prometheus).
- All ArgoCD app resources.

## Structure

- `argocd/`
  - `root-app.yml` – Root application for App-of-Apps.
  - `api.yml` – ArgoCD app for Django.
  - `monitoring.yml` – Monitoring stack with prometheus and grafana
- `api/`
  - `templates/` – Helm templates (Deployment, HPA, Service, Ingress, etc.)
  - `values.yaml` – Default Helm values.
- `argocd.sh` – ArgoCD helm and argo rollout script.

Everything in this branch is declarative. ArgoCD syncs from this branch to deploy and manage resources in the cluster.

