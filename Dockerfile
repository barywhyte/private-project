FROM alpine:3.20

# Install kubectl & curl
RUN apk add --no-cache kubectl curl

# Install argo-rollouts CLI
RUN curl -LO https://github.com/argoproj/argo-rollouts/releases/download/v1.7.4/kubectl-argo-rollouts-linux-amd64 \
    && chmod +x ./kubectl-argo-rollouts-linux-amd64 \
    && mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts

COPY ./watch-rollout.sh /watch-rollout.sh
RUN chmod +x /watch-rollout.sh

ENTRYPOINT ["/watch-rollout.sh"]
