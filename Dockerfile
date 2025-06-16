FROM alpine:3.20

# Install curl and kubectl dependencies
RUN apk add --no-cache curl bash

# Install kubectl (replace version if you want latest stable)
ENV KUBECTL_VERSION=v1.33.1

RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/arm64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/kubectl

# Install argo-rollouts CLI
ENV ARGO_ROLLOUTS_VERSION=v1.8.1

RUN curl -LO "https://github.com/argoproj/argo-rollouts/releases/download/${ARGO_ROLLOUTS_VERSION}/kubectl-argo-rollouts-linux-arm64" \
    && chmod +x kubectl-argo-rollouts-linux-arm64 \
    && mv kubectl-argo-rollouts-linux-arm64 /usr/local/bin/kubectl-argo-rollouts

# Copy your rollout watcher script
COPY ./watch-rollout.sh /watch-rollout.sh
RUN chmod +x /watch-rollout.sh

ENTRYPOINT ["/watch-rollout.sh"]
