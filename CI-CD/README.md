## CD additions for model deployment

This repo is focused on deployment. Model training, image build, and image publishing are expected to happen in another repo or pipeline. This repo consumes an existing container image reference and deploys it to Kubernetes.

### CD

The workflow file [cd.yml](/Users/linghuang/Git/Model-Deployment/.github/workflows/cd.yml) does this:

1. reads an existing image repository and tag
2. deploys with Helm to Kubernetes
3. supports `staging` and `production`
4. optionally creates a second canary Helm release in production

The deploy logic is in [deploy_with_helm.sh](/Users/linghuang/Git/Model-Deployment/ci/deploy_with_helm.sh).

### Run locally on macOS

Use [run-local-deploy.sh](/Users/linghuang/Git/Model-Deployment/scripts/run-local-deploy.sh) for a one-command local deployment:

```bash
chmod +x scripts/run-local-deploy.sh ci/deploy_with_helm.sh
export IMAGE_REPOSITORY=ghcr.io/<your-user>/<your-image>
export IMAGE_TAG=<tag>
export DEPLOY_ENVIRONMENT=staging
./scripts/run-local-deploy.sh
```

Optional variables:

- `IMAGE_TAG`
- `RELEASE_NAME`
- `KUBE_NAMESPACE`
- `DEPLOY_STRATEGY`

### Service and load balancing

The default recommendation in this repo is:

- `Deployment` for the serving pods
- `Service` with `type: ClusterIP` for internal Kubernetes load balancing across replicas
- `Ingress` or an external gateway for public access, TLS, and traffic controls

Use `LoadBalancer` only when you want the cloud provider to expose the service directly.

### Environment values

Helm values were added for:

- [values-staging.yaml](/Users/linghuang/Git/Model-Deployment/Helm-Chart/mychart/values-staging.yaml)
- [values-production.yaml](/Users/linghuang/Git/Model-Deployment/Helm-Chart/mychart/values-production.yaml)
- [values-production-canary.yaml](/Users/linghuang/Git/Model-Deployment/Helm-Chart/mychart/values-production-canary.yaml)

### Secrets and variables to set in GitHub

- `KUBE_CONFIG_DATA`: base64-encoded kubeconfig
- `IMAGE_REPOSITORY`: repository to push your model image to
- `REGISTRY_HOST`: optional registry host reference for your own conventions

### About canary and shadow deployment

This starter implements the deployment side of a canary release by creating a separate canary Helm release. Traffic splitting is cluster-specific and is usually handled by an ingress controller, service mesh, or rollout controller such as Argo Rollouts.

Shadow deployment is also controller-specific. The most common implementation is request mirroring at the ingress or service-mesh layer. That is not baked into this repo because the exact manifest depends on whether you use NGINX Ingress, Istio, Linkerd, or another gateway.

An NGINX Ingress mirroring example was added at [shadow-ingress-nginx-example.yaml](/Users/linghuang/Git/Model-Deployment/Kubernetes/shadow-ingress-nginx-example.yaml). Update the host, namespace, and mirrored service name before using it.
