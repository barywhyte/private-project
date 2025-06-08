# Django Application & CI/CD (main)

This branch contains:

- Django application code.
- Dockerfile for image build.
- Helm chart for app deployment.
- GitLab CI/CD pipeline for build and push.

## Key Components

- `app/` – Django project with APIs and settings.
- `Dockerfile` – Builds the app container.
- `.gitlab-ci.yml` – CI pipeline to build/push image.
- `operations/app/templates/ingress.yml` – custom Ingress Controller to expose app endpoints

The CI pipeline handles containerization and also trigger ArgoCD sync for automated deployment.

